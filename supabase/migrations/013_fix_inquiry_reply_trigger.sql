-- ============================================
-- Fix: notify_inquiry_reply() uses wrong column names
--
-- Problem: A previous fix overwrote this function with direct INSERT
-- that references columns "type", "message", "replyID", "inquiryID"
-- which don't exist in Notification_Tbl.
-- Actual columns: notificationID, userID, notificationType, title, isRead, createdAt
--
-- Fix: Rewrite to use create_notification() helper which has correct columns
-- ============================================

CREATE OR REPLACE FUNCTION public.notify_inquiry_reply()
RETURNS TRIGGER AS $$
DECLARE
  v_inquiry_user_id UUID;
  v_project_title VARCHAR(255);
BEGIN
  -- Get the inquiry owner and project title
  SELECT i."userID", p."title"
  INTO v_inquiry_user_id, v_project_title
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
      'Your inquiry about "' || COALESCE(v_project_title, 'Unknown Project') || '" has been answered'
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Recreate the trigger
DROP TRIGGER IF EXISTS on_inquiry_reply_created ON "Reply_Tbl";
CREATE TRIGGER on_inquiry_reply_created
  AFTER INSERT ON "Reply_Tbl"
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_inquiry_reply();
