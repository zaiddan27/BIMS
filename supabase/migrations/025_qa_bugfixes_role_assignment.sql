-- =====================================================
-- QA Bug Fixes & Role Assignment Feature
-- =====================================================
-- 1. Fix Inquiry visibility: all youth should see all
--    project inquiries (not just their own)
-- 2. Fix Reply visibility: all youth should see replies
--    on project inquiries
-- 3. Add assignedRole column to Application_Tbl for SK
--    role assignment on approval
-- 4. Add projectHeads column to Pre_Project_Tbl for
--    storing multiple project heads
-- =====================================================

-- =====================================================
-- FIX 1: Inquiry_Tbl SELECT policy
-- Current (016): userID = auth.uid() OR is_sk_official_or_captain()
-- Fix: All authenticated users can see all inquiries
-- Reason: QA found youth can't see other people's inquiries
-- on a project. All inquiries should be visible to prevent
-- repetitive questions.
-- =====================================================

DROP POLICY IF EXISTS "auth_select_inquiries" ON "Inquiry_Tbl";

CREATE POLICY "auth_select_inquiries"
ON "Inquiry_Tbl" FOR SELECT
TO authenticated
USING (true);

-- =====================================================
-- FIX 2: Reply_Tbl SELECT policy
-- Current (016): own replies OR own inquiry replies OR SK
-- Fix: All authenticated users can see all replies
-- Reason: Replies on visible inquiries should also be visible
-- =====================================================

DROP POLICY IF EXISTS "auth_select_replies" ON "Reply_Tbl";

CREATE POLICY "auth_select_replies"
ON "Reply_Tbl" FOR SELECT
TO authenticated
USING (true);

-- =====================================================
-- FEATURE: Add assignedRole column to Application_Tbl
-- SK officials can assign a role when approving applicants
-- Defaults to NULL (uses preferredRole if not assigned)
-- =====================================================

ALTER TABLE "Application_Tbl"
ADD COLUMN IF NOT EXISTS "assignedRole" VARCHAR(100) DEFAULT NULL;

-- =====================================================
-- FEATURE: Add projectHeads column to Pre_Project_Tbl
-- Stores additional project head names as JSON array
-- =====================================================

ALTER TABLE "Pre_Project_Tbl"
ADD COLUMN IF NOT EXISTS "projectHeads" TEXT DEFAULT NULL;

-- =====================================================
-- FIX 3: Remove duplicate application status trigger
-- The JS code now creates professional notifications with
-- role assignment info. The DB trigger creates duplicates
-- with generic text and even uses wrong type for rejections
-- (application_pending instead of application_rejected).
-- =====================================================

DROP TRIGGER IF EXISTS on_application_status_changed ON "Application_Tbl";

-- =====================================================
-- FIX 4: Improve inquiry reply notification message
-- =====================================================

CREATE OR REPLACE FUNCTION public.notify_inquiry_reply()
RETURNS TRIGGER AS $$
DECLARE
  v_inquiry_user_id UUID;
  v_project_title VARCHAR(255);
  v_pre_project_id INTEGER;
BEGIN
  SELECT i."userID", p."title", p."preProjectID"
  INTO v_inquiry_user_id, v_project_title, v_pre_project_id
  FROM "Inquiry_Tbl" i
  JOIN "Pre_Project_Tbl" p ON i."preProjectID" = p."preProjectID"
  WHERE i."inquiryID" = NEW."inquiryID";

  UPDATE "Inquiry_Tbl"
  SET "isReplied" = TRUE
  WHERE "inquiryID" = NEW."inquiryID";

  IF v_inquiry_user_id IS NOT NULL AND v_inquiry_user_id != NEW."userID" THEN
    PERFORM create_notification(
      v_inquiry_user_id,
      'inquiry_update',
      'You have received a reply to your inquiry on "' || COALESCE(v_project_title, 'a project') || '". Check the project inquiries for details.',
      v_pre_project_id
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- FIX 4b: Allow all SK officials to update/delete announcements
-- Current: only the creator (userID = auth.uid()) can edit/delete
-- Fix: any SK official or Captain can edit/delete any announcement
-- =====================================================

DROP POLICY IF EXISTS "auth_update_announcements" ON "Announcement_Tbl";
CREATE POLICY "auth_update_announcements"
ON "Announcement_Tbl" FOR UPDATE
TO authenticated
USING (is_sk_official_or_captain())
WITH CHECK (is_sk_official_or_captain());

DROP POLICY IF EXISTS "auth_delete_announcements" ON "Announcement_Tbl";
CREATE POLICY "auth_delete_announcements"
ON "Announcement_Tbl" FOR DELETE
TO authenticated
USING (is_sk_official_or_captain());

-- =====================================================
-- FIX 5: Remove duplicate project approval trigger
-- The captain-dashboard.html JS creates professional
-- notifications. The DB trigger creates duplicates.
-- =====================================================

DROP TRIGGER IF EXISTS on_project_approval_changed ON "Pre_Project_Tbl";

-- =====================================================
-- FIX 6: Remove duplicate new project trigger
-- The sk-projects.html JS creates the notification to
-- captain. The DB trigger creates a duplicate.
-- =====================================================

DROP TRIGGER IF EXISTS on_new_project_created ON "Pre_Project_Tbl";

-- =====================================================
-- FIX 7: Improve new inquiry notification message
-- =====================================================

CREATE OR REPLACE FUNCTION public.notify_new_inquiry()
RETURNS TRIGGER AS $$
DECLARE
  v_project_owner_id UUID;
  v_project_title VARCHAR(255);
BEGIN
  SELECT "userID", "title"
  INTO v_project_owner_id, v_project_title
  FROM "Pre_Project_Tbl"
  WHERE "preProjectID" = NEW."preProjectID";

  IF v_project_owner_id IS NOT NULL AND v_project_owner_id != NEW."userID" THEN
    PERFORM create_notification(
      v_project_owner_id,
      'new_inquiry',
      'A new inquiry has been submitted on your project "' || COALESCE(v_project_title, 'Unknown') || '". Please review and respond.',
      NEW."preProjectID"
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
