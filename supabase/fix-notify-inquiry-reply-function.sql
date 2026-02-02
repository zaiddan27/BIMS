-- =====================================================
-- Fix the notify_inquiry_reply() function
-- The function references inquiry_tbl (lowercase) instead of "Inquiry_Tbl"
-- =====================================================

-- First, check the current function definition
SELECT pg_get_functiondef(oid)
FROM pg_proc
WHERE proname = 'notify_inquiry_reply';

-- Drop and recreate the function with proper table name quoting
CREATE OR REPLACE FUNCTION notify_inquiry_reply()
RETURNS TRIGGER AS $$
DECLARE
    inquiry_owner_id UUID;
    project_title TEXT;
BEGIN
    -- Get the inquiry owner and project title with proper table quoting
    SELECT i."userID", p."title"
    INTO inquiry_owner_id, project_title
    FROM "Inquiry_Tbl" i
    JOIN "Pre_Project_Tbl" p ON i."preProjectID" = p."preProjectID"
    WHERE i."inquiryID" = NEW."inquiryID";

    -- Create notification for the inquiry owner (if reply is from someone else)
    IF inquiry_owner_id IS NOT NULL AND inquiry_owner_id != NEW."userID" THEN
        INSERT INTO "Notification_Tbl" (
            "userID",
            "type",
            "title",
            "message",
            "replyID",
            "inquiryID",
            "isRead",
            "createdAt"
        ) VALUES (
            inquiry_owner_id,
            'INQUIRY_REPLY',
            'New Reply to Your Inquiry',
            'Someone replied to your inquiry on project: ' || COALESCE(project_title, 'Unknown Project'),
            NEW."replyID",
            NEW."inquiryID",
            FALSE,
            NOW()
        );
    END IF;

    -- Mark inquiry as replied
    UPDATE "Inquiry_Tbl"
    SET "isReplied" = TRUE
    WHERE "inquiryID" = NEW."inquiryID";

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Verify the trigger still exists
SELECT trigger_name, event_manipulation, action_statement
FROM information_schema.triggers
WHERE event_object_table = 'Reply_Tbl';
