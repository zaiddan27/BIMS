-- =====================================================
-- BIMS Comprehensive RLS Optimization Migration
-- =====================================================
-- Fixes 4 categories of Supabase linter warnings:
--
-- 1. auth_rls_initplan (38 warnings):
--    Wrap auth.uid() with (select auth.uid()) in all
--    RLS policies to prevent per-row re-evaluation
--
-- 2. multiple_permissive_policies:
--    Consolidate overlapping permissive policies on
--    same table/role/action into single policies
--
-- 3. unindexed_foreign_keys (10 warnings):
--    Add indexes on foreign keys for Logs_Tbl,
--    Post_Project_Tbl, Report_Tbl
--
-- 4. unused_index cleanup:
--    (Handled separately - see verification queries)
--
-- Strategy: Drop ALL existing policies, then recreate
-- optimized consolidated policies with (select auth.uid())
-- =====================================================

-- =====================================================
-- PART 1: UPDATE HELPER FUNCTIONS
-- Use (select auth.uid()) inside helper functions too
-- =====================================================

CREATE OR REPLACE FUNCTION is_sk_official()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM "User_Tbl"
    WHERE "userID" = (select auth.uid())
    AND "role" = 'SK_OFFICIAL'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION is_captain()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM "User_Tbl"
    WHERE "userID" = (select auth.uid())
    AND "role" = 'CAPTAIN'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION is_sk_official_or_captain()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM "User_Tbl"
    WHERE "userID" = (select auth.uid())
    AND "role" IN ('SK_OFFICIAL', 'CAPTAIN')
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION is_superadmin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM "User_Tbl"
    WHERE "userID" = (select auth.uid())
    AND "role" = 'SUPERADMIN'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION is_superadmin_or_captain()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM "User_Tbl"
    WHERE "userID" = (select auth.uid())
    AND "role" IN ('SUPERADMIN', 'CAPTAIN')
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION get_user_role()
RETURNS TEXT AS $$
BEGIN
  RETURN (
    SELECT "role" FROM "User_Tbl" WHERE "userID" = (select auth.uid())
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- PART 2: DROP ALL EXISTING POLICIES
-- Clean slate before creating optimized policies
-- =====================================================

-- User_Tbl
DROP POLICY IF EXISTS "Users can view their own profile" ON "User_Tbl";
DROP POLICY IF EXISTS "SK Officials can view all profiles" ON "User_Tbl";
DROP POLICY IF EXISTS "Public can view active user profiles" ON "User_Tbl";
DROP POLICY IF EXISTS "Users can update their own profile" ON "User_Tbl";
DROP POLICY IF EXISTS "Users can create their own profile" ON "User_Tbl";
DROP POLICY IF EXISTS "SK Officials can update account status" ON "User_Tbl";
DROP POLICY IF EXISTS "Superadmin can view all users" ON "User_Tbl";
DROP POLICY IF EXISTS "Superadmin can change user roles" ON "User_Tbl";
DROP POLICY IF EXISTS "Captain can change user roles" ON "User_Tbl";
DROP POLICY IF EXISTS "Captain can view all users" ON "User_Tbl";

-- SK_Tbl
DROP POLICY IF EXISTS "Public can view SK Officials" ON "SK_Tbl";
DROP POLICY IF EXISTS "SK Officials can manage SK records" ON "SK_Tbl";
DROP POLICY IF EXISTS "Superadmin can view SK assignments" ON "SK_Tbl";
DROP POLICY IF EXISTS "Superadmin can create SK assignments" ON "SK_Tbl";
DROP POLICY IF EXISTS "Superadmin can delete SK assignments" ON "SK_Tbl";
DROP POLICY IF EXISTS "Captain can manage SK assignments" ON "SK_Tbl";

-- Captain_Tbl
DROP POLICY IF EXISTS "Captain and SK Officials can view Captain records" ON "Captain_Tbl";
DROP POLICY IF EXISTS "System function can manage Captain records" ON "Captain_Tbl";

-- Announcement_Tbl
DROP POLICY IF EXISTS "Public can view active announcements" ON "Announcement_Tbl";
DROP POLICY IF EXISTS "SK Officials can view all announcements" ON "Announcement_Tbl";
DROP POLICY IF EXISTS "SK Officials can create announcements" ON "Announcement_Tbl";
DROP POLICY IF EXISTS "SK Officials can update their announcements" ON "Announcement_Tbl";
DROP POLICY IF EXISTS "SK Officials can delete their announcements" ON "Announcement_Tbl";
DROP POLICY IF EXISTS "Captain can view archived announcements" ON "Announcement_Tbl";

-- File_Tbl
DROP POLICY IF EXISTS "Public can view active files" ON "File_Tbl";
DROP POLICY IF EXISTS "SK Officials can view all files" ON "File_Tbl";
DROP POLICY IF EXISTS "SK Officials can upload files" ON "File_Tbl";
DROP POLICY IF EXISTS "SK Officials can update files" ON "File_Tbl";
DROP POLICY IF EXISTS "SK Officials can delete files" ON "File_Tbl";
DROP POLICY IF EXISTS "Captain can view archived files" ON "File_Tbl";

-- Pre_Project_Tbl
DROP POLICY IF EXISTS "Public can view approved projects" ON "Pre_Project_Tbl";
DROP POLICY IF EXISTS "Users can view approved projects" ON "Pre_Project_Tbl";
DROP POLICY IF EXISTS "SK Officials can view all projects" ON "Pre_Project_Tbl";
DROP POLICY IF EXISTS "SK Officials can create projects" ON "Pre_Project_Tbl";
DROP POLICY IF EXISTS "SK Officials can update their projects" ON "Pre_Project_Tbl";
DROP POLICY IF EXISTS "SK Officials can delete their projects" ON "Pre_Project_Tbl";
DROP POLICY IF EXISTS "Captain can view all projects" ON "Pre_Project_Tbl";
DROP POLICY IF EXISTS "Captain can approve projects" ON "Pre_Project_Tbl";

-- Post_Project_Tbl
DROP POLICY IF EXISTS "Public can view completed projects" ON "Post_Project_Tbl";
DROP POLICY IF EXISTS "SK Officials can manage completed projects" ON "Post_Project_Tbl";

-- Application_Tbl
DROP POLICY IF EXISTS "Users can view their applications" ON "Application_Tbl";
DROP POLICY IF EXISTS "SK Officials can view all applications" ON "Application_Tbl";
DROP POLICY IF EXISTS "Users can submit applications" ON "Application_Tbl";
DROP POLICY IF EXISTS "Users can update pending applications" ON "Application_Tbl";
DROP POLICY IF EXISTS "SK Officials can update applications" ON "Application_Tbl";
DROP POLICY IF EXISTS "Users can delete pending applications" ON "Application_Tbl";
DROP POLICY IF EXISTS "Authenticated users can insert applications" ON "Application_Tbl";
DROP POLICY IF EXISTS "Users can read own applications" ON "Application_Tbl";
DROP POLICY IF EXISTS "SK Officials can read all applications" ON "Application_Tbl";

-- Inquiry_Tbl
DROP POLICY IF EXISTS "Users can view their inquiries" ON "Inquiry_Tbl";
DROP POLICY IF EXISTS "SK Officials can view all inquiries" ON "Inquiry_Tbl";
DROP POLICY IF EXISTS "Users can create inquiries" ON "Inquiry_Tbl";
DROP POLICY IF EXISTS "Authenticated users can insert inquiries" ON "Inquiry_Tbl";
DROP POLICY IF EXISTS "Anyone can read inquiries" ON "Inquiry_Tbl";

-- Reply_Tbl
DROP POLICY IF EXISTS "Users can view replies to their inquiries" ON "Reply_Tbl";
DROP POLICY IF EXISTS "SK Officials can view all replies" ON "Reply_Tbl";
DROP POLICY IF EXISTS "SK Officials can create replies" ON "Reply_Tbl";
DROP POLICY IF EXISTS "Authenticated users can insert replies" ON "Reply_Tbl";
DROP POLICY IF EXISTS "Anyone can read replies" ON "Reply_Tbl";
DROP POLICY IF EXISTS "Users can update own replies" ON "Reply_Tbl";
DROP POLICY IF EXISTS "Users can delete own replies" ON "Reply_Tbl";

-- Notification_Tbl
DROP POLICY IF EXISTS "Users can view their notifications" ON "Notification_Tbl";
DROP POLICY IF EXISTS "System can create notifications" ON "Notification_Tbl";
DROP POLICY IF EXISTS "Users can update their notifications" ON "Notification_Tbl";
DROP POLICY IF EXISTS "Users can delete their notifications" ON "Notification_Tbl";

-- OTP_Tbl
DROP POLICY IF EXISTS "Users can view their OTP" ON "OTP_Tbl";
DROP POLICY IF EXISTS "System can create OTP" ON "OTP_Tbl";
DROP POLICY IF EXISTS "System can update OTP" ON "OTP_Tbl";

-- Certificate_Tbl
DROP POLICY IF EXISTS "Users can view their certificates" ON "Certificate_Tbl";
DROP POLICY IF EXISTS "SK Officials can view all certificates" ON "Certificate_Tbl";
DROP POLICY IF EXISTS "SK Officials can create certificates" ON "Certificate_Tbl";

-- Evaluation_Tbl
DROP POLICY IF EXISTS "Users can view their evaluations" ON "Evaluation_Tbl";
DROP POLICY IF EXISTS "SK Officials can view all evaluations" ON "Evaluation_Tbl";
DROP POLICY IF EXISTS "Users can submit evaluations" ON "Evaluation_Tbl";

-- Testimonies_Tbl
DROP POLICY IF EXISTS "Public can view testimonies" ON "Testimonies_Tbl";
DROP POLICY IF EXISTS "SK Officials can view all testimonies" ON "Testimonies_Tbl";
DROP POLICY IF EXISTS "Users can submit testimonies" ON "Testimonies_Tbl";
DROP POLICY IF EXISTS "SK Officials can filter testimonies" ON "Testimonies_Tbl";

-- BudgetBreakdown_Tbl
DROP POLICY IF EXISTS "Public can view budget breakdown" ON "BudgetBreakdown_Tbl";
DROP POLICY IF EXISTS "SK Officials can manage budgets" ON "BudgetBreakdown_Tbl";

-- Expenses_Tbl
DROP POLICY IF EXISTS "SK Officials can view expenses" ON "Expenses_Tbl";
DROP POLICY IF EXISTS "SK Officials can manage expenses" ON "Expenses_Tbl";

-- Annual_Budget_Tbl
DROP POLICY IF EXISTS "Public can view annual budgets" ON "Annual_Budget_Tbl";
DROP POLICY IF EXISTS "SK Officials can manage budgets" ON "Annual_Budget_Tbl";

-- Report_Tbl
DROP POLICY IF EXISTS "SK Officials can view reports" ON "Report_Tbl";
DROP POLICY IF EXISTS "SK Officials can manage reports" ON "Report_Tbl";

-- Logs_Tbl
DROP POLICY IF EXISTS "SK Officials can view logs" ON "Logs_Tbl";
DROP POLICY IF EXISTS "Superadmin can view all logs" ON "Logs_Tbl";
DROP POLICY IF EXISTS "Captain can view logs" ON "Logs_Tbl";
DROP POLICY IF EXISTS "SK Officials can view their logs" ON "Logs_Tbl";
DROP POLICY IF EXISTS "Authorized roles can view logs" ON "Logs_Tbl";
DROP POLICY IF EXISTS "Users can create their own logs" ON "Logs_Tbl";
DROP POLICY IF EXISTS "System can create logs" ON "Logs_Tbl";


-- =====================================================
-- PART 3: CREATE OPTIMIZED CONSOLIDATED POLICIES
-- All use (select auth.uid()) for InitPlan optimization
-- =====================================================

-- =====================================================
-- USER_TBL (was 4 SELECT + 2 UPDATE + 1 INSERT = 7 policies)
-- Now: 2 SELECT + 1 INSERT + 1 UPDATE = 4 policies
-- =====================================================

-- Anon: view active profiles only
CREATE POLICY "anon_select_active_profiles"
ON "User_Tbl" FOR SELECT
TO anon
USING ("accountStatus" = 'ACTIVE');

-- Authenticated: view own profile OR staff can view all
CREATE POLICY "auth_select_profiles"
ON "User_Tbl" FOR SELECT
TO authenticated
USING (
  "userID" = (select auth.uid())
  OR is_sk_official_or_captain()
  OR is_superadmin()
);

-- Authenticated: create own profile during signup
CREATE POLICY "auth_insert_own_profile"
ON "User_Tbl" FOR INSERT
TO authenticated
WITH CHECK ("userID" = (select auth.uid()));

-- Authenticated: update own profile OR superadmin can update others
CREATE POLICY "auth_update_profile"
ON "User_Tbl" FOR UPDATE
TO authenticated
USING (
  "userID" = (select auth.uid())
  OR (is_superadmin() AND "userID" != (select auth.uid()))
)
WITH CHECK (
  "userID" = (select auth.uid())
  OR (is_superadmin() AND "userID" != (select auth.uid()))
);


-- =====================================================
-- SK_TBL (was 5 policies)
-- Now: 2 policies
-- =====================================================

-- Public: view all SK officials
CREATE POLICY "public_select_sk"
ON "SK_Tbl" FOR SELECT
TO public
USING (true);

-- Authenticated: SK/Captain/Superadmin can manage
CREATE POLICY "auth_manage_sk"
ON "SK_Tbl" FOR ALL
TO authenticated
USING (is_sk_official_or_captain() OR is_superadmin())
WITH CHECK (is_sk_official_or_captain() OR is_superadmin());


-- =====================================================
-- CAPTAIN_TBL (2 policies - no change needed)
-- =====================================================

CREATE POLICY "auth_select_captain"
ON "Captain_Tbl" FOR SELECT
TO authenticated
USING (is_sk_official_or_captain() OR is_superadmin());

CREATE POLICY "system_manage_captain"
ON "Captain_Tbl" FOR ALL
TO authenticated
USING (false)
WITH CHECK (false);


-- =====================================================
-- ANNOUNCEMENT_TBL (was 6 policies)
-- Now: 5 policies (merged SK + Captain SELECT into one)
-- =====================================================

-- Public: view active announcements
CREATE POLICY "public_select_active_announcements"
ON "Announcement_Tbl" FOR SELECT
TO public
USING ("contentStatus" = 'ACTIVE');

-- Authenticated: SK/Captain can view all (including archived)
CREATE POLICY "auth_select_all_announcements"
ON "Announcement_Tbl" FOR SELECT
TO authenticated
USING (is_sk_official_or_captain());

-- Authenticated: SK can create (own)
CREATE POLICY "auth_insert_announcements"
ON "Announcement_Tbl" FOR INSERT
TO authenticated
WITH CHECK (is_sk_official() AND "userID" = (select auth.uid()));

-- Authenticated: SK can update (own)
CREATE POLICY "auth_update_announcements"
ON "Announcement_Tbl" FOR UPDATE
TO authenticated
USING (is_sk_official() AND "userID" = (select auth.uid()))
WITH CHECK (is_sk_official() AND "userID" = (select auth.uid()));

-- Authenticated: SK can delete (own)
CREATE POLICY "auth_delete_announcements"
ON "Announcement_Tbl" FOR DELETE
TO authenticated
USING (is_sk_official() AND "userID" = (select auth.uid()));


-- =====================================================
-- FILE_TBL (was 6 policies)
-- Now: 5 policies (merged SK + Captain SELECT into one)
-- =====================================================

-- Public: view active files
CREATE POLICY "public_select_active_files"
ON "File_Tbl" FOR SELECT
TO public
USING ("fileStatus" = 'ACTIVE');

-- Authenticated: SK/Captain can view all (including archived)
CREATE POLICY "auth_select_all_files"
ON "File_Tbl" FOR SELECT
TO authenticated
USING (is_sk_official_or_captain());

-- Authenticated: SK can upload (own)
CREATE POLICY "auth_insert_files"
ON "File_Tbl" FOR INSERT
TO authenticated
WITH CHECK (is_sk_official() AND "userID" = (select auth.uid()));

-- Authenticated: SK can update
CREATE POLICY "auth_update_files"
ON "File_Tbl" FOR UPDATE
TO authenticated
USING (is_sk_official());

-- Authenticated: SK can delete
CREATE POLICY "auth_delete_files"
ON "File_Tbl" FOR DELETE
TO authenticated
USING (is_sk_official());


-- =====================================================
-- PRE_PROJECT_TBL (was 8 policies)
-- Now: 5 policies
-- =====================================================

-- Public: view approved projects
CREATE POLICY "public_select_approved_projects"
ON "Pre_Project_Tbl" FOR SELECT
TO public
USING ("approvalStatus" = 'APPROVED');

-- Authenticated: SK/Captain can view all projects
CREATE POLICY "auth_select_all_projects"
ON "Pre_Project_Tbl" FOR SELECT
TO authenticated
USING (is_sk_official_or_captain());

-- Authenticated: SK can create projects (own)
CREATE POLICY "auth_insert_projects"
ON "Pre_Project_Tbl" FOR INSERT
TO authenticated
WITH CHECK (is_sk_official() AND "userID" = (select auth.uid()));

-- Authenticated: SK can update own, Captain can update any (for approval)
CREATE POLICY "auth_update_projects"
ON "Pre_Project_Tbl" FOR UPDATE
TO authenticated
USING (
  (is_sk_official() AND "userID" = (select auth.uid()))
  OR is_captain()
)
WITH CHECK (
  (is_sk_official() AND "userID" = (select auth.uid()))
  OR is_captain()
);

-- Authenticated: SK can delete own projects
CREATE POLICY "auth_delete_projects"
ON "Pre_Project_Tbl" FOR DELETE
TO authenticated
USING (is_sk_official() AND "userID" = (select auth.uid()));


-- =====================================================
-- POST_PROJECT_TBL (2 policies - no change needed)
-- =====================================================

-- Public: view completed projects
CREATE POLICY "public_select_completed_projects"
ON "Post_Project_Tbl" FOR SELECT
TO public
USING (true);

-- Authenticated: SK/Captain can manage
CREATE POLICY "auth_manage_completed_projects"
ON "Post_Project_Tbl" FOR ALL
TO authenticated
USING (is_sk_official_or_captain())
WITH CHECK (is_sk_official_or_captain());


-- =====================================================
-- APPLICATION_TBL (was 9 policies with duplicates)
-- Now: 4 policies
-- =====================================================

-- Authenticated: view own OR staff view all
CREATE POLICY "auth_select_applications"
ON "Application_Tbl" FOR SELECT
TO authenticated
USING (
  "userID" = (select auth.uid())
  OR is_sk_official_or_captain()
  OR is_superadmin()
);

-- Authenticated: submit own applications
CREATE POLICY "auth_insert_applications"
ON "Application_Tbl" FOR INSERT
TO authenticated
WITH CHECK ("userID" = (select auth.uid()));

-- Authenticated: users update own pending OR staff update any
CREATE POLICY "auth_update_applications"
ON "Application_Tbl" FOR UPDATE
TO authenticated
USING (
  ("userID" = (select auth.uid()) AND "applicationStatus" = 'PENDING')
  OR is_sk_official_or_captain()
)
WITH CHECK (
  ("userID" = (select auth.uid()) AND "applicationStatus" = 'PENDING')
  OR is_sk_official_or_captain()
);

-- Authenticated: users delete own pending applications
CREATE POLICY "auth_delete_applications"
ON "Application_Tbl" FOR DELETE
TO authenticated
USING ("userID" = (select auth.uid()) AND "applicationStatus" = 'PENDING');


-- =====================================================
-- INQUIRY_TBL (was 5 policies with duplicates)
-- Now: 2 policies
-- =====================================================

-- Authenticated: all can read inquiries (needed for reply system)
CREATE POLICY "auth_select_inquiries"
ON "Inquiry_Tbl" FOR SELECT
TO authenticated
USING (true);

-- Authenticated: users create own inquiries
CREATE POLICY "auth_insert_inquiries"
ON "Inquiry_Tbl" FOR INSERT
TO authenticated
WITH CHECK ("userID" = (select auth.uid()));


-- =====================================================
-- REPLY_TBL (was 7 policies with duplicates)
-- Now: 4 policies
-- =====================================================

-- Authenticated: all can read replies (needed for reply system)
CREATE POLICY "auth_select_replies"
ON "Reply_Tbl" FOR SELECT
TO authenticated
USING (true);

-- Authenticated: users create own replies
CREATE POLICY "auth_insert_replies"
ON "Reply_Tbl" FOR INSERT
TO authenticated
WITH CHECK ("userID" = (select auth.uid()));

-- Authenticated: users update own replies
CREATE POLICY "auth_update_replies"
ON "Reply_Tbl" FOR UPDATE
TO authenticated
USING ("userID" = (select auth.uid()))
WITH CHECK ("userID" = (select auth.uid()));

-- Authenticated: users delete own replies
CREATE POLICY "auth_delete_replies"
ON "Reply_Tbl" FOR DELETE
TO authenticated
USING ("userID" = (select auth.uid()));


-- =====================================================
-- NOTIFICATION_TBL (4 policies - no consolidation needed)
-- Just fix auth.uid() wrapping
-- =====================================================

-- Authenticated: view own notifications
CREATE POLICY "auth_select_notifications"
ON "Notification_Tbl" FOR SELECT
TO authenticated
USING ("userID" = (select auth.uid()));

-- System/triggers can create notifications
CREATE POLICY "auth_insert_notifications"
ON "Notification_Tbl" FOR INSERT
TO authenticated
WITH CHECK (true);

-- Authenticated: update own (mark as read)
CREATE POLICY "auth_update_notifications"
ON "Notification_Tbl" FOR UPDATE
TO authenticated
USING ("userID" = (select auth.uid()))
WITH CHECK ("userID" = (select auth.uid()));

-- Authenticated: delete own
CREATE POLICY "auth_delete_notifications"
ON "Notification_Tbl" FOR DELETE
TO authenticated
USING ("userID" = (select auth.uid()));


-- =====================================================
-- OTP_TBL (3 policies - no consolidation needed)
-- Just fix auth.uid() wrapping
-- =====================================================

-- Authenticated: view own OTPs
CREATE POLICY "auth_select_otp"
ON "OTP_Tbl" FOR SELECT
TO authenticated
USING ("userID" = (select auth.uid()));

-- Authenticated: create own OTPs
CREATE POLICY "auth_insert_otp"
ON "OTP_Tbl" FOR INSERT
TO authenticated
WITH CHECK ("userID" = (select auth.uid()));

-- Authenticated: update own OTPs
CREATE POLICY "auth_update_otp"
ON "OTP_Tbl" FOR UPDATE
TO authenticated
USING ("userID" = (select auth.uid()))
WITH CHECK ("userID" = (select auth.uid()));


-- =====================================================
-- CERTIFICATE_TBL (was 3 policies)
-- Now: 2 policies (merged 2 SELECT into one)
-- =====================================================

-- Authenticated: view own OR staff view all
CREATE POLICY "auth_select_certificates"
ON "Certificate_Tbl" FOR SELECT
TO authenticated
USING (
  "userID" = (select auth.uid())
  OR is_sk_official_or_captain()
);

-- Authenticated: SK can create certificates
CREATE POLICY "auth_insert_certificates"
ON "Certificate_Tbl" FOR INSERT
TO authenticated
WITH CHECK (is_sk_official_or_captain());


-- =====================================================
-- EVALUATION_TBL (was 3 policies)
-- Now: 2 policies (merged 2 SELECT into one)
-- =====================================================

-- Authenticated: view own evaluations OR staff view all
CREATE POLICY "auth_select_evaluations"
ON "Evaluation_Tbl" FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM "Application_Tbl"
    WHERE "Application_Tbl"."applicationID" = "Evaluation_Tbl"."applicationID"
    AND "Application_Tbl"."userID" = (select auth.uid())
  )
  OR is_sk_official_or_captain()
);

-- Authenticated: users submit evaluations for their applications
CREATE POLICY "auth_insert_evaluations"
ON "Evaluation_Tbl" FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM "Application_Tbl"
    WHERE "Application_Tbl"."applicationID" = "Evaluation_Tbl"."applicationID"
    AND "Application_Tbl"."userID" = (select auth.uid())
  )
);


-- =====================================================
-- TESTIMONIES_TBL (4 policies - minor consolidation)
-- =====================================================

-- Public: view unfiltered testimonies
CREATE POLICY "public_select_testimonies"
ON "Testimonies_Tbl" FOR SELECT
TO public
USING ("isFiltered" = false);

-- Authenticated: SK/Captain view all (including filtered)
CREATE POLICY "auth_select_all_testimonies"
ON "Testimonies_Tbl" FOR SELECT
TO authenticated
USING (is_sk_official_or_captain());

-- Authenticated: users submit own testimonies
CREATE POLICY "auth_insert_testimonies"
ON "Testimonies_Tbl" FOR INSERT
TO authenticated
WITH CHECK ("userID" = (select auth.uid()));

-- Authenticated: SK can filter/moderate testimonies
CREATE POLICY "auth_update_testimonies"
ON "Testimonies_Tbl" FOR UPDATE
TO authenticated
USING (is_sk_official_or_captain());


-- =====================================================
-- BUDGETBREAKDOWN_TBL (2 policies - no change needed)
-- =====================================================

-- Public: view budgets of approved projects
CREATE POLICY "public_select_budgets"
ON "BudgetBreakdown_Tbl" FOR SELECT
TO public
USING (
  EXISTS (
    SELECT 1 FROM "Pre_Project_Tbl"
    WHERE "Pre_Project_Tbl"."preProjectID" = "BudgetBreakdown_Tbl"."preProjectID"
    AND "Pre_Project_Tbl"."approvalStatus" = 'APPROVED'
  )
);

-- Authenticated: SK/Captain can manage budgets
CREATE POLICY "auth_manage_budgets"
ON "BudgetBreakdown_Tbl" FOR ALL
TO authenticated
USING (is_sk_official_or_captain())
WITH CHECK (is_sk_official_or_captain());


-- =====================================================
-- EXPENSES_TBL (was 2 policies with overlap)
-- Now: 1 policy (FOR ALL already covers SELECT)
-- =====================================================

-- Authenticated: SK/Captain can manage expenses
CREATE POLICY "auth_manage_expenses"
ON "Expenses_Tbl" FOR ALL
TO authenticated
USING (is_sk_official_or_captain())
WITH CHECK (is_sk_official_or_captain());


-- =====================================================
-- ANNUAL_BUDGET_TBL (2 policies - no change needed)
-- =====================================================

-- Public: view annual budgets
CREATE POLICY "public_select_annual_budgets"
ON "Annual_Budget_Tbl" FOR SELECT
TO public
USING (true);

-- Authenticated: SK/Captain can manage
CREATE POLICY "auth_manage_annual_budgets"
ON "Annual_Budget_Tbl" FOR ALL
TO authenticated
USING (is_sk_official_or_captain())
WITH CHECK (is_sk_official_or_captain());


-- =====================================================
-- REPORT_TBL (was 2 policies with overlap)
-- Now: 1 policy (FOR ALL already covers SELECT)
-- =====================================================

-- Authenticated: SK/Captain can manage reports
CREATE POLICY "auth_manage_reports"
ON "Report_Tbl" FOR ALL
TO authenticated
USING (is_sk_official_or_captain())
WITH CHECK (is_sk_official_or_captain());


-- =====================================================
-- LOGS_TBL (was 4+ policies with duplicates)
-- Now: 2 policies
-- =====================================================

-- Authenticated: authorized roles can view logs
CREATE POLICY "auth_select_logs"
ON "Logs_Tbl" FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM "User_Tbl"
    WHERE "User_Tbl"."userID" = (select auth.uid())
    AND "User_Tbl"."role" IN ('SUPERADMIN', 'SK_OFFICIAL', 'CAPTAIN')
  )
);

-- Authenticated: users create own logs
CREATE POLICY "auth_insert_logs"
ON "Logs_Tbl" FOR INSERT
TO authenticated
WITH CHECK ("userID" = (select auth.uid()));


-- =====================================================
-- PART 4: ADD MISSING FOREIGN KEY INDEXES
-- Fixes 10 unindexed_foreign_keys warnings
-- =====================================================

-- Logs_Tbl: 7 unindexed foreign keys
CREATE INDEX IF NOT EXISTS idx_logs_reply ON "Logs_Tbl"("replyID");
CREATE INDEX IF NOT EXISTS idx_logs_postproject ON "Logs_Tbl"("postProjectID");
CREATE INDEX IF NOT EXISTS idx_logs_application ON "Logs_Tbl"("applicationID");
CREATE INDEX IF NOT EXISTS idx_logs_inquiry ON "Logs_Tbl"("inquiryID");
CREATE INDEX IF NOT EXISTS idx_logs_notification ON "Logs_Tbl"("notificationID");
CREATE INDEX IF NOT EXISTS idx_logs_file ON "Logs_Tbl"("fileID");
CREATE INDEX IF NOT EXISTS idx_logs_testimony ON "Logs_Tbl"("testimonyID");

-- Post_Project_Tbl: 1 unindexed foreign key
CREATE INDEX IF NOT EXISTS idx_postproject_breakdown ON "Post_Project_Tbl"("breakdownID");

-- Report_Tbl: 2 unindexed foreign keys
CREATE INDEX IF NOT EXISTS idx_report_application ON "Report_Tbl"("applicationID");
CREATE INDEX IF NOT EXISTS idx_report_evaluation ON "Report_Tbl"("evaluationID");


-- =====================================================
-- VERIFICATION QUERIES (run these after migration)
-- =====================================================

-- Check total policy count per table
-- SELECT tablename, count(*) as policy_count
-- FROM pg_policies
-- WHERE schemaname = 'public'
-- GROUP BY tablename
-- ORDER BY tablename;

-- Check for any remaining auth.uid() without (select ...) wrapper
-- SELECT policyname, tablename, qual, with_check
-- FROM pg_policies
-- WHERE schemaname = 'public'
-- AND (qual::text LIKE '%auth.uid()%' OR with_check::text LIKE '%auth.uid()%')
-- AND (qual::text NOT LIKE '%(select auth.uid())%' AND with_check::text NOT LIKE '%(select auth.uid())%');

-- Check for multiple permissive policies on same table/role/action
-- SELECT tablename, roles, cmd, count(*) as count
-- FROM pg_policies
-- WHERE schemaname = 'public'
-- AND permissive = 'PERMISSIVE'
-- GROUP BY tablename, roles, cmd
-- HAVING count(*) > 1
-- ORDER BY count DESC;
