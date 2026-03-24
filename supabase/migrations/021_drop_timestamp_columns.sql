-- Migration 021: Drop redundant timeStamp columns (2026-03-24)
--
-- Tables with BOTH timeStamp and createdAt (redundant):
-- Logs_Tbl, Inquiry_Tbl, Evaluation_Tbl, Testimonies_Tbl, Report_Tbl
--
-- All code references updated from timeStamp -> createdAt

-- Drop timeStamp from Logs_Tbl
ALTER TABLE "Logs_Tbl" DROP COLUMN IF EXISTS "timeStamp";

-- Drop timeStamp from Inquiry_Tbl
ALTER TABLE "Inquiry_Tbl" DROP COLUMN IF EXISTS "timeStamp";

-- Drop timeStamp from Evaluation_Tbl
ALTER TABLE "Evaluation_Tbl" DROP COLUMN IF EXISTS "timeStamp";

-- Drop timeStamp from Testimonies_Tbl
ALTER TABLE "Testimonies_Tbl" DROP COLUMN IF EXISTS "timeStamp";

-- Drop timeStamp from Report_Tbl
ALTER TABLE "Report_Tbl" DROP COLUMN IF EXISTS "timeStamp";

-- Update log_action() function to use createdAt instead of timeStamp
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
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Authentication required';
  END IF;

  IF p_action IS NULL OR length(trim(p_action)) = 0 THEN
    RAISE EXCEPTION 'Action description is required';
  END IF;

  IF length(p_action) > 255 THEN
    RAISE EXCEPTION 'Action description too long';
  END IF;

  INSERT INTO public."Logs_Tbl" (
    "userID", action, "replyID", "postProjectID",
    "applicationID", "inquiryID", "notificationID",
    "fileID", "testimonyID", "createdAt"
  ) VALUES (
    auth.uid(), p_action, p_reply_id, p_post_project_id,
    p_application_id, p_inquiry_id, p_notification_id,
    p_file_id, p_testimony_id, CURRENT_TIMESTAMP
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
