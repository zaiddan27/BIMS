-- ============================================
-- BIMS Auth Sync Trigger
-- Automatically sync Supabase Auth users to User_Tbl
-- ============================================

-- Function to handle new user creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  user_metadata JSONB;
BEGIN
  -- Get user metadata from auth.users
  user_metadata := NEW.raw_user_meta_data;

  -- Insert into User_Tbl with metadata from signup
  INSERT INTO public.User_Tbl (
    userID,
    email,
    firstName,
    lastName,
    middleName,
    role,
    birthday,
    contactNumber,
    address,
    termsConditions,
    accountStatus
  ) VALUES (
    NEW.id,
    NEW.email,
    COALESCE(user_metadata->>'first_name', ''),
    COALESCE(user_metadata->>'last_name', ''),
    user_metadata->>'middle_name',
    COALESCE(user_metadata->>'role', 'YOUTH_VOLUNTEER'),
    COALESCE((user_metadata->>'birthday')::DATE, CURRENT_DATE),
    COALESCE(user_metadata->>'contact_number', ''),
    COALESCE(user_metadata->>'address', ''),
    COALESCE((user_metadata->>'terms_conditions')::BOOLEAN, false),
    CASE
      WHEN NEW.email_confirmed_at IS NOT NULL THEN 'ACTIVE'
      ELSE 'PENDING'
    END
  )
  ON CONFLICT (userID) DO UPDATE
  SET
    email = EXCLUDED.email,
    accountStatus = CASE
      WHEN NEW.email_confirmed_at IS NOT NULL THEN 'ACTIVE'
      ELSE User_Tbl.accountStatus
    END,
    updatedAt = CURRENT_TIMESTAMP;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger on auth.users for new signups
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT OR UPDATE ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- ============================================
-- Function to update user profile
-- ============================================

-- Function to allow users to update their profile
CREATE OR REPLACE FUNCTION public.update_user_profile(
  p_first_name VARCHAR(100),
  p_last_name VARCHAR(100),
  p_middle_name VARCHAR(100),
  p_birthday DATE,
  p_contact_number VARCHAR(13),
  p_address TEXT,
  p_image_path_url TEXT
)
RETURNS VOID AS $$
BEGIN
  UPDATE public.User_Tbl
  SET
    firstName = p_first_name,
    lastName = p_last_name,
    middleName = p_middle_name,
    birthday = p_birthday,
    contactNumber = p_contact_number,
    address = p_address,
    imagePathURL = p_image_path_url,
    updatedAt = CURRENT_TIMESTAMP
  WHERE userID = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- Function to create notification
-- ============================================

CREATE OR REPLACE FUNCTION public.create_notification(
  p_user_id UUID,
  p_notification_type VARCHAR(50),
  p_title VARCHAR(255)
)
RETURNS INTEGER AS $$
DECLARE
  v_notification_id INTEGER;
BEGIN
  INSERT INTO public.Notification_Tbl (
    userID,
    notificationType,
    title,
    isRead,
    createdAt
  ) VALUES (
    p_user_id,
    p_notification_type,
    p_title,
    false,
    CURRENT_TIMESTAMP
  )
  RETURNING notificationID INTO v_notification_id;

  RETURN v_notification_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- Function to log user actions
-- ============================================

CREATE OR REPLACE FUNCTION public.log_action(
  p_action VARCHAR(255),
  p_reply_id INTEGER DEFAULT NULL,
  p_post_project_id INTEGER DEFAULT NULL,
  p_application_id INTEGER DEFAULT NULL,
  p_inquiry_id INTEGER DEFAULT NULL,
  p_notification_id INTEGER DEFAULT NULL,
  p_file_id INTEGER DEFAULT NULL,
  p_testimony_id INTEGER DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  INSERT INTO public.Logs_Tbl (
    userID,
    action,
    replyID,
    postProjectID,
    applicationID,
    inquiryID,
    notificationID,
    fileID,
    testimonyID,
    timestamp
  ) VALUES (
    auth.uid(),
    p_action,
    p_reply_id,
    p_post_project_id,
    p_application_id,
    p_inquiry_id,
    p_notification_id,
    p_file_id,
    p_testimony_id,
    CURRENT_TIMESTAMP
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- Trigger for automatic inquiry reply notification
-- ============================================

CREATE OR REPLACE FUNCTION public.notify_inquiry_reply()
RETURNS TRIGGER AS $$
DECLARE
  v_inquiry_user_id UUID;
  v_project_title VARCHAR(255);
BEGIN
  -- Get the inquiry user and project title
  SELECT i.userID, p.title
  INTO v_inquiry_user_id, v_project_title
  FROM Inquiry_Tbl i
  JOIN Pre_Project_Tbl p ON i.preProjectID = p.preProjectID
  WHERE i.inquiryID = NEW.inquiryID;

  -- Update inquiry as replied
  UPDATE Inquiry_Tbl
  SET isReplied = true
  WHERE inquiryID = NEW.inquiryID;

  -- Create notification for inquiry owner
  PERFORM create_notification(
    v_inquiry_user_id,
    'inquiry_update',
    'Your inquiry about "' || v_project_title || '" has been answered'
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_inquiry_reply_created ON Reply_Tbl;
CREATE TRIGGER on_inquiry_reply_created
  AFTER INSERT ON Reply_Tbl
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_inquiry_reply();

-- ============================================
-- Trigger for application status change notification
-- ============================================

CREATE OR REPLACE FUNCTION public.notify_application_status()
RETURNS TRIGGER AS $$
DECLARE
  v_project_title VARCHAR(255);
BEGIN
  -- Only notify on status change
  IF OLD.applicationStatus != NEW.applicationStatus THEN
    -- Get project title
    SELECT title INTO v_project_title
    FROM Pre_Project_Tbl
    WHERE preProjectID = NEW.preProjectID;

    -- Create notification based on new status
    IF NEW.applicationStatus = 'APPROVED' THEN
      PERFORM create_notification(
        NEW.userID,
        'application_approved',
        'Your application for "' || v_project_title || '" has been approved!'
      );
    ELSIF NEW.applicationStatus = 'REJECTED' THEN
      PERFORM create_notification(
        NEW.userID,
        'application_pending',
        'Your application for "' || v_project_title || '" status has been updated'
      );
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_application_status_changed ON Application_Tbl;
CREATE TRIGGER on_application_status_changed
  AFTER UPDATE ON Application_Tbl
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_application_status();

-- ============================================
-- Trigger for project approval notification
-- ============================================

CREATE OR REPLACE FUNCTION public.notify_project_approval()
RETURNS TRIGGER AS $$
BEGIN
  -- Only notify on approval status change
  IF OLD.approvalStatus != NEW.approvalStatus THEN
    -- Notify project creator
    IF NEW.approvalStatus = 'APPROVED' THEN
      PERFORM create_notification(
        NEW.userID,
        'project_approved',
        'Your project "' || NEW.title || '" has been approved!'
      );
    ELSIF NEW.approvalStatus = 'REJECTED' THEN
      PERFORM create_notification(
        NEW.userID,
        'project_rejected',
        'Your project "' || NEW.title || '" needs revision'
      );
    ELSIF NEW.approvalStatus = 'REVISION' THEN
      PERFORM create_notification(
        NEW.userID,
        'revision_requested',
        'Revision requested for "' || NEW.title || '"'
      );
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_project_approval_changed ON Pre_Project_Tbl;
CREATE TRIGGER on_project_approval_changed
  AFTER UPDATE ON Pre_Project_Tbl
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_project_approval();

-- ============================================
-- Trigger for new project notification to Captain
-- ============================================

CREATE OR REPLACE FUNCTION public.notify_new_project()
RETURNS TRIGGER AS $$
DECLARE
  v_captain_id UUID;
BEGIN
  -- Get Captain userID
  SELECT userID INTO v_captain_id
  FROM User_Tbl
  WHERE role = 'CAPTAIN'
  LIMIT 1;

  -- Notify Captain of new project awaiting approval
  IF v_captain_id IS NOT NULL THEN
    PERFORM create_notification(
      v_captain_id,
      'project_awaiting_approval',
      'New project proposal: "' || NEW.title || '" awaits your approval'
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_new_project_created ON Pre_Project_Tbl;
CREATE TRIGGER on_new_project_created
  AFTER INSERT ON Pre_Project_Tbl
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_new_project();
