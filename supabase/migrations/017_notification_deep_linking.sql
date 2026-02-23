-- ============================================
-- Migration 017: Notification Deep Linking
--
-- Problem: Clicking notifications does nothing because
-- Notification_Tbl has no reference to the related entity
-- (project, inquiry, etc). The NotificationModal can only
-- mark as read and close.
--
-- Fix:
--   1. Add referenceID column to store preProjectID
--   2. Update create_notification() with optional 4th param
--   3. Update all 4 trigger functions to pass preProjectID
--   4. Add new notify_new_inquiry() trigger (was missing)
-- ============================================

-- ============================================
-- PART 1: Add referenceID column
-- ============================================

ALTER TABLE "Notification_Tbl"
ADD COLUMN IF NOT EXISTS "referenceID" INTEGER NULL;

-- Index for efficient lookups
CREATE INDEX IF NOT EXISTS idx_notification_reference
ON "Notification_Tbl"("referenceID");

-- ============================================
-- PART 2: Update create_notification() function
-- Add optional 4th parameter p_reference_id
-- ============================================

CREATE OR REPLACE FUNCTION public.create_notification(
  p_user_id UUID,
  p_notification_type VARCHAR(50),
  p_title VARCHAR(255),
  p_reference_id INTEGER DEFAULT NULL
)
RETURNS INTEGER AS $$
DECLARE
  v_notification_id INTEGER;
BEGIN
  INSERT INTO public."Notification_Tbl" (
    "userID",
    "notificationType",
    "title",
    "isRead",
    "referenceID",
    "createdAt"
  ) VALUES (
    p_user_id,
    p_notification_type,
    p_title,
    false,
    p_reference_id,
    CURRENT_TIMESTAMP
  )
  RETURNING "notificationID" INTO v_notification_id;

  RETURN v_notification_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- PART 3: Update notify_inquiry_reply() trigger
-- Now passes preProjectID as referenceID
-- (Supersedes 013_fix_inquiry_reply_trigger.sql)
-- ============================================

CREATE OR REPLACE FUNCTION public.notify_inquiry_reply()
RETURNS TRIGGER AS $$
DECLARE
  v_inquiry_user_id UUID;
  v_project_title VARCHAR(255);
  v_pre_project_id INTEGER;
BEGIN
  -- Get the inquiry owner, project title, and project ID
  SELECT i."userID", p."title", p."preProjectID"
  INTO v_inquiry_user_id, v_project_title, v_pre_project_id
  FROM "Inquiry_Tbl" i
  JOIN "Pre_Project_Tbl" p ON i."preProjectID" = p."preProjectID"
  WHERE i."inquiryID" = NEW."inquiryID";

  -- Mark inquiry as replied
  UPDATE "Inquiry_Tbl"
  SET "isReplied" = TRUE
  WHERE "inquiryID" = NEW."inquiryID";

  -- Create notification for the inquiry owner (only if reply is from someone else)
  IF v_inquiry_user_id IS NOT NULL AND v_inquiry_user_id != NEW."userID" THEN
    PERFORM create_notification(
      v_inquiry_user_id,
      'inquiry_update',
      'Your inquiry about "' || COALESCE(v_project_title, 'Unknown Project') || '" has been answered',
      v_pre_project_id
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- PART 4: Update notify_application_status() trigger
-- Now passes preProjectID as referenceID
-- (Supersedes 012_fix_application_status_trigger.sql)
-- ============================================

CREATE OR REPLACE FUNCTION public.notify_application_status()
RETURNS TRIGGER AS $$
DECLARE
  v_project_title VARCHAR(255);
BEGIN
  -- Only notify on status change
  IF OLD."applicationStatus" != NEW."applicationStatus" THEN
    -- Get project title
    SELECT title INTO v_project_title
    FROM "Pre_Project_Tbl"
    WHERE "preProjectID" = NEW."preProjectID";

    -- Create notification based on new status
    IF NEW."applicationStatus" = 'APPROVED' THEN
      PERFORM create_notification(
        NEW."userID",
        'application_approved',
        'Your application for "' || v_project_title || '" has been approved!',
        NEW."preProjectID"
      );
    ELSIF NEW."applicationStatus" = 'REJECTED' THEN
      PERFORM create_notification(
        NEW."userID",
        'application_pending',
        'Your application for "' || v_project_title || '" status has been updated',
        NEW."preProjectID"
      );
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Recreate the trigger
DROP TRIGGER IF EXISTS on_application_status_changed ON "Application_Tbl";
CREATE TRIGGER on_application_status_changed
  AFTER UPDATE ON "Application_Tbl"
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_application_status();

-- ============================================
-- PART 5: Update notify_project_approval() trigger
-- Now passes preProjectID as referenceID
-- ============================================

CREATE OR REPLACE FUNCTION public.notify_project_approval()
RETURNS TRIGGER AS $$
BEGIN
  -- Only notify on approval status change
  IF OLD."approvalStatus" != NEW."approvalStatus" THEN
    -- Notify project creator
    IF NEW."approvalStatus" = 'APPROVED' THEN
      PERFORM create_notification(
        NEW."userID",
        'project_approved',
        'Your project "' || NEW."title" || '" has been approved!',
        NEW."preProjectID"
      );
    ELSIF NEW."approvalStatus" = 'REJECTED' THEN
      PERFORM create_notification(
        NEW."userID",
        'project_rejected',
        'Your project "' || NEW."title" || '" needs revision',
        NEW."preProjectID"
      );
    ELSIF NEW."approvalStatus" = 'REVISION' THEN
      PERFORM create_notification(
        NEW."userID",
        'revision_requested',
        'Revision requested for "' || NEW."title" || '"',
        NEW."preProjectID"
      );
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Recreate the trigger
DROP TRIGGER IF EXISTS on_project_approval_changed ON "Pre_Project_Tbl";
CREATE TRIGGER on_project_approval_changed
  AFTER UPDATE ON "Pre_Project_Tbl"
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_project_approval();

-- ============================================
-- PART 6: Update notify_new_project() trigger
-- Now passes preProjectID as referenceID
-- ============================================

CREATE OR REPLACE FUNCTION public.notify_new_project()
RETURNS TRIGGER AS $$
DECLARE
  v_captain_id UUID;
BEGIN
  -- Get Captain userID
  SELECT "userID" INTO v_captain_id
  FROM "User_Tbl"
  WHERE "role" = 'CAPTAIN'
  LIMIT 1;

  -- Notify Captain of new project awaiting approval
  IF v_captain_id IS NOT NULL THEN
    PERFORM create_notification(
      v_captain_id,
      'project_awaiting_approval',
      'New project proposal: "' || NEW."title" || '" awaits your approval',
      NEW."preProjectID"
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Recreate the trigger
DROP TRIGGER IF EXISTS on_new_project_created ON "Pre_Project_Tbl";
CREATE TRIGGER on_new_project_created
  AFTER INSERT ON "Pre_Project_Tbl"
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_new_project();

-- ============================================
-- PART 7: New trigger - notify_new_inquiry()
-- Notifies the SK project owner when a youth
-- submits an inquiry (was previously missing)
-- ============================================

CREATE OR REPLACE FUNCTION public.notify_new_inquiry()
RETURNS TRIGGER AS $$
DECLARE
  v_project_owner_id UUID;
  v_project_title VARCHAR(255);
BEGIN
  -- Get the project owner and title
  SELECT "userID", "title"
  INTO v_project_owner_id, v_project_title
  FROM "Pre_Project_Tbl"
  WHERE "preProjectID" = NEW."preProjectID";

  -- Notify project owner (only if inquiry is from someone else)
  IF v_project_owner_id IS NOT NULL AND v_project_owner_id != NEW."userID" THEN
    PERFORM create_notification(
      v_project_owner_id,
      'new_inquiry',
      'New inquiry about "' || COALESCE(v_project_title, 'Unknown Project') || '"',
      NEW."preProjectID"
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_new_inquiry_created ON "Inquiry_Tbl";
CREATE TRIGGER on_new_inquiry_created
  AFTER INSERT ON "Inquiry_Tbl"
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_new_inquiry();
