-- =====================================================
-- BIMS - Complete Row Level Security (RLS) Policies
-- =====================================================
-- Project: Barangay Information Management System
-- Client: SK Malanday, Marikina City
-- Updated: 2026-01-11
-- Version: 2.0 (Post-Migration)
--
-- IMPORTANT:
-- - All table names use Title Case: User_Tbl, SK_Tbl, etc.
-- - All column names use camelCase: userID, firstName, etc.
-- - Always use double quotes for table/column names in SQL
-- =====================================================

-- =====================================================
-- ENABLE RLS ON ALL TABLES
-- =====================================================

ALTER TABLE "User_Tbl" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "SK_Tbl" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Captain_Tbl" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Announcement_Tbl" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "File_Tbl" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Pre_Project_Tbl" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Post_Project_Tbl" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Application_Tbl" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Inquiry_Tbl" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Reply_Tbl" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Notification_Tbl" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "OTP_Tbl" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Certificate_Tbl" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Evaluation_Tbl" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Testimonies_Tbl" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "BudgetBreakdown_Tbl" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Expenses_Tbl" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Annual_Budget_Tbl" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Report_Tbl" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Logs_Tbl" ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- HELPER FUNCTIONS
-- =====================================================

-- Check if user is SK Official
CREATE OR REPLACE FUNCTION is_sk_official()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM "User_Tbl"
    WHERE "User_Tbl"."userID" = auth.uid()
    AND "User_Tbl".role = 'SK_OFFICIAL'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Check if user is Captain
CREATE OR REPLACE FUNCTION is_captain()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM "User_Tbl"
    WHERE "User_Tbl"."userID" = auth.uid()
    AND "User_Tbl".role = 'CAPTAIN'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Check if user is SK Official OR Captain (for specific use cases)
CREATE OR REPLACE FUNCTION is_sk_official_or_captain()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM "User_Tbl"
    WHERE "User_Tbl"."userID" = auth.uid()
    AND "User_Tbl".role IN ('SK_OFFICIAL', 'CAPTAIN')
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Check if user is Superadmin (for future use)
CREATE OR REPLACE FUNCTION is_superadmin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM "User_Tbl"
    WHERE "User_Tbl"."userID" = auth.uid()
    AND "User_Tbl".role = 'SUPERADMIN'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- USER_TBL POLICIES
-- =====================================================

CREATE POLICY "Public can view active user profiles"
ON "User_Tbl"
FOR SELECT
USING ("accountStatus" = 'ACTIVE');

CREATE POLICY "SK Officials can view all profiles"
ON "User_Tbl"
FOR SELECT
USING (is_sk_official_or_captain());

CREATE POLICY "Users can view their own profile"
ON "User_Tbl"
FOR SELECT
USING ("userID" = auth.uid());

CREATE POLICY "Users can create their own profile"
ON "User_Tbl"
FOR INSERT
WITH CHECK ("userID" = auth.uid());

CREATE POLICY "Users can update their own profile"
ON "User_Tbl"
FOR UPDATE
USING ("userID" = auth.uid())
WITH CHECK ("userID" = auth.uid());

CREATE POLICY "Superadmin can view all users"
ON "User_Tbl"
FOR SELECT
USING (is_superadmin());

CREATE POLICY "Superadmin can change user roles"
ON "User_Tbl"
FOR UPDATE
USING (is_superadmin() AND "userID" <> auth.uid())
WITH CHECK (is_superadmin() AND "userID" <> auth.uid());

-- =====================================================
-- SK_TBL POLICIES
-- =====================================================

CREATE POLICY "Public can view SK Officials"
ON "SK_Tbl"
FOR SELECT
USING (true);

CREATE POLICY "SK Officials can manage SK records"
ON "SK_Tbl"
FOR ALL
USING (is_sk_official_or_captain())
WITH CHECK (is_sk_official_or_captain());

CREATE POLICY "Superadmin can view SK assignments"
ON "SK_Tbl"
FOR SELECT
USING (is_superadmin());

CREATE POLICY "Superadmin can create SK assignments"
ON "SK_Tbl"
FOR INSERT
WITH CHECK (is_superadmin());

CREATE POLICY "Superadmin can delete SK assignments"
ON "SK_Tbl"
FOR DELETE
USING (is_superadmin());

-- =====================================================
-- CAPTAIN_TBL POLICIES
-- =====================================================

CREATE POLICY "Captain and SK Officials can view Captain records"
ON "Captain_Tbl"
FOR SELECT
USING (is_sk_official_or_captain());

CREATE POLICY "System function can manage Captain records"
ON "Captain_Tbl"
FOR ALL
USING (false)
WITH CHECK (false);

-- =====================================================
-- ANNOUNCEMENT_TBL POLICIES
-- =====================================================
-- Captain: View only (active + archived)
-- SK Officials: Full CRUD
-- Public: View active only

CREATE POLICY "Public can view active announcements"
ON "Announcement_Tbl"
FOR SELECT
USING ("contentStatus" = 'ACTIVE');

CREATE POLICY "Captain can view archived announcements"
ON "Announcement_Tbl"
FOR SELECT
USING (is_captain() AND "contentStatus" = 'ARCHIVED');

CREATE POLICY "SK Officials can view all announcements"
ON "Announcement_Tbl"
FOR SELECT
USING (is_sk_official());

CREATE POLICY "SK Officials can create announcements"
ON "Announcement_Tbl"
FOR INSERT
WITH CHECK (is_sk_official() AND "userID" = auth.uid());

CREATE POLICY "SK Officials can update their announcements"
ON "Announcement_Tbl"
FOR UPDATE
USING (is_sk_official() AND "userID" = auth.uid())
WITH CHECK (is_sk_official() AND "userID" = auth.uid());

CREATE POLICY "SK Officials can delete their announcements"
ON "Announcement_Tbl"
FOR DELETE
USING (is_sk_official() AND "userID" = auth.uid());

-- =====================================================
-- FILE_TBL POLICIES
-- =====================================================
-- Captain: View only (active + archived) - NO CRUD
-- SK Officials: Full CRUD
-- Public: View active only

CREATE POLICY "Public can view active files"
ON "File_Tbl"
FOR SELECT
USING ("fileStatus" = 'ACTIVE');

CREATE POLICY "Captain can view archived files"
ON "File_Tbl"
FOR SELECT
USING (is_captain() AND "fileStatus" = 'ARCHIVED');

CREATE POLICY "SK Officials can view all files"
ON "File_Tbl"
FOR SELECT
USING (is_sk_official());

CREATE POLICY "SK Officials can upload files"
ON "File_Tbl"
FOR INSERT
WITH CHECK (is_sk_official() AND "userID" = auth.uid());

CREATE POLICY "SK Officials can update files"
ON "File_Tbl"
FOR UPDATE
USING (is_sk_official())
WITH CHECK (is_sk_official());

CREATE POLICY "SK Officials can delete files"
ON "File_Tbl"
FOR DELETE
USING (is_sk_official());

-- =====================================================
-- PRE_PROJECT_TBL POLICIES
-- =====================================================
-- Captain: View all + Approve/Reject/Revise (no create/delete)
-- SK Officials: Full CRUD
-- Users: View approved only

CREATE POLICY "Public can view approved projects"
ON "Pre_Project_Tbl"
FOR SELECT
USING ("approvalStatus" = 'APPROVED');

CREATE POLICY "Users can view approved projects"
ON "Pre_Project_Tbl"
FOR SELECT
USING ("approvalStatus" = 'APPROVED');

CREATE POLICY "Captain can view all projects"
ON "Pre_Project_Tbl"
FOR SELECT
USING (is_captain());

CREATE POLICY "Captain can approve projects"
ON "Pre_Project_Tbl"
FOR UPDATE
USING (is_captain())
WITH CHECK (is_captain());

CREATE POLICY "SK Officials can view all projects"
ON "Pre_Project_Tbl"
FOR SELECT
USING (is_sk_official());

CREATE POLICY "SK Officials can create projects"
ON "Pre_Project_Tbl"
FOR INSERT
WITH CHECK (is_sk_official() AND "userID" = auth.uid());

CREATE POLICY "SK Officials can update their projects"
ON "Pre_Project_Tbl"
FOR UPDATE
USING (is_sk_official() AND ("userID" = auth.uid() OR is_captain()))
WITH CHECK (is_sk_official() AND ("userID" = auth.uid() OR is_captain()));

CREATE POLICY "SK Officials can delete their projects"
ON "Pre_Project_Tbl"
FOR DELETE
USING (is_sk_official() AND "userID" = auth.uid());

-- =====================================================
-- POST_PROJECT_TBL POLICIES
-- =====================================================

CREATE POLICY "Public can view completed projects"
ON "Post_Project_Tbl"
FOR SELECT
USING (true);

CREATE POLICY "SK Officials can manage completed projects"
ON "Post_Project_Tbl"
FOR ALL
USING (is_sk_official())
WITH CHECK (is_sk_official());

-- =====================================================
-- APPLICATION_TBL POLICIES
-- =====================================================

CREATE POLICY "Users can view their applications"
ON "Application_Tbl"
FOR SELECT
USING ("userID" = auth.uid());

CREATE POLICY "Users can submit applications"
ON "Application_Tbl"
FOR INSERT
WITH CHECK ("userID" = auth.uid());

CREATE POLICY "Users can update pending applications"
ON "Application_Tbl"
FOR UPDATE
USING ("userID" = auth.uid() AND "applicationStatus" = 'PENDING')
WITH CHECK ("userID" = auth.uid() AND "applicationStatus" = 'PENDING');

CREATE POLICY "Users can delete pending applications"
ON "Application_Tbl"
FOR DELETE
USING ("userID" = auth.uid() AND "applicationStatus" = 'PENDING');

CREATE POLICY "SK Officials can view all applications"
ON "Application_Tbl"
FOR SELECT
USING (is_sk_official());

CREATE POLICY "SK Officials can update applications"
ON "Application_Tbl"
FOR UPDATE
USING (is_sk_official())
WITH CHECK (is_sk_official());

-- =====================================================
-- INQUIRY_TBL POLICIES
-- =====================================================

CREATE POLICY "Users can view their inquiries"
ON "Inquiry_Tbl"
FOR SELECT
USING ("userID" = auth.uid());

CREATE POLICY "Users can create inquiries"
ON "Inquiry_Tbl"
FOR INSERT
WITH CHECK ("userID" = auth.uid());

CREATE POLICY "SK Officials can view all inquiries"
ON "Inquiry_Tbl"
FOR SELECT
USING (is_sk_official());

-- =====================================================
-- REPLY_TBL POLICIES
-- =====================================================

CREATE POLICY "Users can view replies to their inquiries"
ON "Reply_Tbl"
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM "Inquiry_Tbl"
    WHERE "Inquiry_Tbl"."inquiryID" = "Reply_Tbl"."inquiryID"
    AND "Inquiry_Tbl"."userID" = auth.uid()
  )
);

CREATE POLICY "SK Officials can view all replies"
ON "Reply_Tbl"
FOR SELECT
USING (is_sk_official());

CREATE POLICY "SK Officials can create replies"
ON "Reply_Tbl"
FOR INSERT
WITH CHECK (is_sk_official() AND "userID" = auth.uid());

-- =====================================================
-- NOTIFICATION_TBL POLICIES
-- =====================================================

CREATE POLICY "Users can view their notifications"
ON "Notification_Tbl"
FOR SELECT
USING ("userID" = auth.uid());

CREATE POLICY "Users can update their notifications"
ON "Notification_Tbl"
FOR UPDATE
USING ("userID" = auth.uid())
WITH CHECK ("userID" = auth.uid());

CREATE POLICY "Users can delete their notifications"
ON "Notification_Tbl"
FOR DELETE
USING ("userID" = auth.uid());

CREATE POLICY "System can create notifications"
ON "Notification_Tbl"
FOR INSERT
WITH CHECK (true);

-- =====================================================
-- OTP_TBL POLICIES
-- =====================================================

CREATE POLICY "Users can view their OTP"
ON "OTP_Tbl"
FOR SELECT
USING ("userID" = auth.uid());

CREATE POLICY "System can create OTP"
ON "OTP_Tbl"
FOR INSERT
WITH CHECK ("userID" = auth.uid());

CREATE POLICY "System can update OTP"
ON "OTP_Tbl"
FOR UPDATE
USING ("userID" = auth.uid())
WITH CHECK ("userID" = auth.uid());

-- =====================================================
-- CERTIFICATE_TBL POLICIES
-- =====================================================

CREATE POLICY "Users can view their certificates"
ON "Certificate_Tbl"
FOR SELECT
USING ("userID" = auth.uid());

CREATE POLICY "SK Officials can view all certificates"
ON "Certificate_Tbl"
FOR SELECT
USING (is_sk_official());

CREATE POLICY "SK Officials can create certificates"
ON "Certificate_Tbl"
FOR INSERT
WITH CHECK (is_sk_official());

-- =====================================================
-- EVALUATION_TBL POLICIES
-- =====================================================

CREATE POLICY "Users can view their evaluations"
ON "Evaluation_Tbl"
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM "Application_Tbl"
    WHERE "Application_Tbl"."applicationID" = "Evaluation_Tbl"."applicationID"
    AND "Application_Tbl"."userID" = auth.uid()
  )
);

CREATE POLICY "Users can submit evaluations"
ON "Evaluation_Tbl"
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM "Application_Tbl"
    WHERE "Application_Tbl"."applicationID" = "Evaluation_Tbl"."applicationID"
    AND "Application_Tbl"."userID" = auth.uid()
  )
);

CREATE POLICY "SK Officials can view all evaluations"
ON "Evaluation_Tbl"
FOR SELECT
USING (is_sk_official());

-- =====================================================
-- TESTIMONIES_TBL POLICIES
-- =====================================================
-- Captain: View unfiltered only - NO moderation access
-- SK Officials: Filter/View all
-- Public: View unfiltered only

CREATE POLICY "Public can view testimonies"
ON "Testimonies_Tbl"
FOR SELECT
USING ("isFiltered" = false);

CREATE POLICY "Users can submit testimonies"
ON "Testimonies_Tbl"
FOR INSERT
WITH CHECK ("userID" = auth.uid());

CREATE POLICY "SK Officials can view all testimonies"
ON "Testimonies_Tbl"
FOR SELECT
USING (is_sk_official());

CREATE POLICY "SK Officials can filter testimonies"
ON "Testimonies_Tbl"
FOR UPDATE
USING (is_sk_official())
WITH CHECK (is_sk_official());

-- =====================================================
-- BUDGETBREAKDOWN_TBL POLICIES
-- =====================================================

CREATE POLICY "Public can view budget breakdown"
ON "BudgetBreakdown_Tbl"
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM "Pre_Project_Tbl"
    WHERE "Pre_Project_Tbl"."preProjectID" = "BudgetBreakdown_Tbl"."preProjectID"
    AND "Pre_Project_Tbl"."approvalStatus" = 'APPROVED'
  )
);

CREATE POLICY "SK Officials can manage budgets"
ON "BudgetBreakdown_Tbl"
FOR ALL
USING (is_sk_official())
WITH CHECK (is_sk_official());

-- =====================================================
-- EXPENSES_TBL POLICIES
-- =====================================================

CREATE POLICY "SK Officials can view expenses"
ON "Expenses_Tbl"
FOR SELECT
USING (is_sk_official());

CREATE POLICY "SK Officials can manage expenses"
ON "Expenses_Tbl"
FOR ALL
USING (is_sk_official())
WITH CHECK (is_sk_official());

-- =====================================================
-- ANNUAL_BUDGET_TBL POLICIES
-- =====================================================

CREATE POLICY "Public can view annual budgets"
ON "Annual_Budget_Tbl"
FOR SELECT
USING (true);

CREATE POLICY "SK Officials can manage budgets"
ON "Annual_Budget_Tbl"
FOR ALL
USING (is_sk_official())
WITH CHECK (is_sk_official());

-- =====================================================
-- REPORT_TBL POLICIES
-- =====================================================

CREATE POLICY "SK Officials can view reports"
ON "Report_Tbl"
FOR SELECT
USING (is_sk_official());

CREATE POLICY "SK Officials can manage reports"
ON "Report_Tbl"
FOR ALL
USING (is_sk_official())
WITH CHECK (is_sk_official());

-- =====================================================
-- LOGS_TBL POLICIES
-- =====================================================

CREATE POLICY "Users can create their own logs"
ON "Logs_Tbl"
FOR INSERT
WITH CHECK ("userID" = auth.uid());

CREATE POLICY "System can create logs"
ON "Logs_Tbl"
FOR INSERT
WITH CHECK ("userID" = auth.uid());

CREATE POLICY "SK Officials can view logs"
ON "Logs_Tbl"
FOR SELECT
USING (is_sk_official_or_captain());

CREATE POLICY "Superadmin can view all logs"
ON "Logs_Tbl"
FOR SELECT
USING (is_superadmin());

-- =====================================================
-- VERIFICATION QUERY
-- =====================================================

-- Run this to verify all policies are created
-- SELECT
--     schemaname,
--     tablename,
--     policyname,
--     cmd
-- FROM pg_policies
-- WHERE schemaname = 'public'
-- ORDER BY tablename, policyname;
