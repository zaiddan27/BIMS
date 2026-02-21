-- =====================================================
-- PART 3 FIX: Recreate ALL optimized RLS policies
-- Based on ACTUAL database column names from diagnostic
-- =====================================================
-- Key finding: Announcement_Tbl has NO contentStatus column
-- All columns are camelCase (created via Supabase Dashboard)
-- =====================================================

-- Drop any partially-created policies from previous attempt
-- User_Tbl
DROP POLICY IF EXISTS "anon_select_active_profiles" ON "User_Tbl";
DROP POLICY IF EXISTS "auth_select_profiles" ON "User_Tbl";
DROP POLICY IF EXISTS "auth_insert_own_profile" ON "User_Tbl";
DROP POLICY IF EXISTS "auth_update_profile" ON "User_Tbl";
-- SK_Tbl
DROP POLICY IF EXISTS "public_select_sk" ON "SK_Tbl";
DROP POLICY IF EXISTS "auth_manage_sk" ON "SK_Tbl";
-- Captain_Tbl
DROP POLICY IF EXISTS "auth_select_captain" ON "Captain_Tbl";
DROP POLICY IF EXISTS "system_manage_captain" ON "Captain_Tbl";
-- Announcement_Tbl
DROP POLICY IF EXISTS "public_select_active_announcements" ON "Announcement_Tbl";
DROP POLICY IF EXISTS "auth_select_all_announcements" ON "Announcement_Tbl";
DROP POLICY IF EXISTS "auth_insert_announcements" ON "Announcement_Tbl";
DROP POLICY IF EXISTS "auth_update_announcements" ON "Announcement_Tbl";
DROP POLICY IF EXISTS "auth_delete_announcements" ON "Announcement_Tbl";
-- File_Tbl
DROP POLICY IF EXISTS "public_select_active_files" ON "File_Tbl";
DROP POLICY IF EXISTS "auth_select_all_files" ON "File_Tbl";
DROP POLICY IF EXISTS "auth_insert_files" ON "File_Tbl";
DROP POLICY IF EXISTS "auth_update_files" ON "File_Tbl";
DROP POLICY IF EXISTS "auth_delete_files" ON "File_Tbl";
-- Pre_Project_Tbl
DROP POLICY IF EXISTS "public_select_approved_projects" ON "Pre_Project_Tbl";
DROP POLICY IF EXISTS "auth_select_all_projects" ON "Pre_Project_Tbl";
DROP POLICY IF EXISTS "auth_insert_projects" ON "Pre_Project_Tbl";
DROP POLICY IF EXISTS "auth_update_projects" ON "Pre_Project_Tbl";
DROP POLICY IF EXISTS "auth_delete_projects" ON "Pre_Project_Tbl";
-- Post_Project_Tbl
DROP POLICY IF EXISTS "public_select_completed_projects" ON "Post_Project_Tbl";
DROP POLICY IF EXISTS "auth_manage_completed_projects" ON "Post_Project_Tbl";
-- Application_Tbl
DROP POLICY IF EXISTS "auth_select_applications" ON "Application_Tbl";
DROP POLICY IF EXISTS "auth_insert_applications" ON "Application_Tbl";
DROP POLICY IF EXISTS "auth_update_applications" ON "Application_Tbl";
DROP POLICY IF EXISTS "auth_delete_applications" ON "Application_Tbl";
-- Inquiry_Tbl
DROP POLICY IF EXISTS "auth_select_inquiries" ON "Inquiry_Tbl";
DROP POLICY IF EXISTS "auth_insert_inquiries" ON "Inquiry_Tbl";
-- Reply_Tbl
DROP POLICY IF EXISTS "auth_select_replies" ON "Reply_Tbl";
DROP POLICY IF EXISTS "auth_insert_replies" ON "Reply_Tbl";
DROP POLICY IF EXISTS "auth_update_replies" ON "Reply_Tbl";
DROP POLICY IF EXISTS "auth_delete_replies" ON "Reply_Tbl";
-- Notification_Tbl
DROP POLICY IF EXISTS "auth_select_notifications" ON "Notification_Tbl";
DROP POLICY IF EXISTS "auth_insert_notifications" ON "Notification_Tbl";
DROP POLICY IF EXISTS "auth_update_notifications" ON "Notification_Tbl";
DROP POLICY IF EXISTS "auth_delete_notifications" ON "Notification_Tbl";
-- OTP_Tbl
DROP POLICY IF EXISTS "auth_select_otp" ON "OTP_Tbl";
DROP POLICY IF EXISTS "auth_insert_otp" ON "OTP_Tbl";
DROP POLICY IF EXISTS "auth_update_otp" ON "OTP_Tbl";
-- Certificate_Tbl
DROP POLICY IF EXISTS "auth_select_certificates" ON "Certificate_Tbl";
DROP POLICY IF EXISTS "auth_insert_certificates" ON "Certificate_Tbl";
-- Evaluation_Tbl
DROP POLICY IF EXISTS "auth_select_evaluations" ON "Evaluation_Tbl";
DROP POLICY IF EXISTS "auth_insert_evaluations" ON "Evaluation_Tbl";
-- Testimonies_Tbl
DROP POLICY IF EXISTS "public_select_testimonies" ON "Testimonies_Tbl";
DROP POLICY IF EXISTS "auth_select_all_testimonies" ON "Testimonies_Tbl";
DROP POLICY IF EXISTS "auth_insert_testimonies" ON "Testimonies_Tbl";
DROP POLICY IF EXISTS "auth_update_testimonies" ON "Testimonies_Tbl";
-- BudgetBreakdown_Tbl
DROP POLICY IF EXISTS "public_select_budgets" ON "BudgetBreakdown_Tbl";
DROP POLICY IF EXISTS "auth_manage_budgets" ON "BudgetBreakdown_Tbl";
-- Expenses_Tbl
DROP POLICY IF EXISTS "auth_manage_expenses" ON "Expenses_Tbl";
-- Annual_Budget_Tbl
DROP POLICY IF EXISTS "public_select_annual_budgets" ON "Annual_Budget_Tbl";
DROP POLICY IF EXISTS "auth_manage_annual_budgets" ON "Annual_Budget_Tbl";
-- Report_Tbl
DROP POLICY IF EXISTS "auth_manage_reports" ON "Report_Tbl";
-- Logs_Tbl
DROP POLICY IF EXISTS "auth_select_logs" ON "Logs_Tbl";
DROP POLICY IF EXISTS "auth_insert_logs" ON "Logs_Tbl";


-- =====================================================
-- USER_TBL (4 policies)
-- Columns: userID, email, firstName, lastName, middleName,
--          role, birthday, contactNumber, address,
--          imagePathURL, termsConditions, accountStatus,
--          createdAt, updatedAt
-- =====================================================

CREATE POLICY "anon_select_active_profiles"
ON "User_Tbl" FOR SELECT
TO anon
USING ("accountStatus" = 'ACTIVE');

CREATE POLICY "auth_select_profiles"
ON "User_Tbl" FOR SELECT
TO authenticated
USING (
  "userID" = (select auth.uid())
  OR is_sk_official_or_captain()
  OR is_superadmin()
);

CREATE POLICY "auth_insert_own_profile"
ON "User_Tbl" FOR INSERT
TO authenticated
WITH CHECK ("userID" = (select auth.uid()));

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
-- SK_TBL (2 policies)
-- Columns: skID, userID, position, termStart, termEnd, createdAt
-- =====================================================

CREATE POLICY "public_select_sk"
ON "SK_Tbl" FOR SELECT
TO public
USING (true);

CREATE POLICY "auth_manage_sk"
ON "SK_Tbl" FOR ALL
TO authenticated
USING (is_sk_official_or_captain() OR is_superadmin())
WITH CHECK (is_sk_official_or_captain() OR is_superadmin());


-- =====================================================
-- CAPTAIN_TBL (2 policies)
-- Columns: captainID, userID, termStart, termEnd, isActive,
--          createdAt, updatedAt
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
-- ANNOUNCEMENT_TBL (4 policies)
-- Columns: announcementID, userID, title, category,
--          description, imagePathURL, publishedDate,
--          createdAt, updatedAt
-- NOTE: No contentStatus column exists in this table
-- =====================================================

CREATE POLICY "public_select_announcements"
ON "Announcement_Tbl" FOR SELECT
TO public
USING (true);

CREATE POLICY "auth_insert_announcements"
ON "Announcement_Tbl" FOR INSERT
TO authenticated
WITH CHECK (is_sk_official() AND "userID" = (select auth.uid()));

CREATE POLICY "auth_update_announcements"
ON "Announcement_Tbl" FOR UPDATE
TO authenticated
USING (is_sk_official() AND "userID" = (select auth.uid()))
WITH CHECK (is_sk_official() AND "userID" = (select auth.uid()));

CREATE POLICY "auth_delete_announcements"
ON "Announcement_Tbl" FOR DELETE
TO authenticated
USING (is_sk_official() AND "userID" = (select auth.uid()));


-- =====================================================
-- FILE_TBL (5 policies)
-- Columns: fileID, userID, fileName, fileType, fileStatus,
--          filePath, fileCategory, dateUploaded, createdAt,
--          isPublished
-- =====================================================

CREATE POLICY "public_select_active_files"
ON "File_Tbl" FOR SELECT
TO public
USING ("fileStatus" = 'ACTIVE');

CREATE POLICY "auth_select_all_files"
ON "File_Tbl" FOR SELECT
TO authenticated
USING (is_sk_official_or_captain());

CREATE POLICY "auth_insert_files"
ON "File_Tbl" FOR INSERT
TO authenticated
WITH CHECK (is_sk_official() AND "userID" = (select auth.uid()));

CREATE POLICY "auth_update_files"
ON "File_Tbl" FOR UPDATE
TO authenticated
USING (is_sk_official());

CREATE POLICY "auth_delete_files"
ON "File_Tbl" FOR DELETE
TO authenticated
USING (is_sk_official());


-- =====================================================
-- PRE_PROJECT_TBL (5 policies)
-- Columns: preProjectID, userID, skID, title, description,
--          category, budget, volunteers, beneficiaries,
--          status, startDateTime, endDateTime, location,
--          imagePathURL, submittedDate, approvalStatus,
--          approvalDate, approvalNotes, createdAt, updatedAt
-- =====================================================

CREATE POLICY "public_select_approved_projects"
ON "Pre_Project_Tbl" FOR SELECT
TO public
USING ("approvalStatus" = 'APPROVED');

CREATE POLICY "auth_select_all_projects"
ON "Pre_Project_Tbl" FOR SELECT
TO authenticated
USING (is_sk_official_or_captain());

CREATE POLICY "auth_insert_projects"
ON "Pre_Project_Tbl" FOR INSERT
TO authenticated
WITH CHECK (is_sk_official() AND "userID" = (select auth.uid()));

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

CREATE POLICY "auth_delete_projects"
ON "Pre_Project_Tbl" FOR DELETE
TO authenticated
USING (is_sk_official() AND "userID" = (select auth.uid()));


-- =====================================================
-- POST_PROJECT_TBL (2 policies)
-- Columns: postProjectID, preProjectID, breakdownID,
--          actualVolunteer, timelineAdherence,
--          beneficiariesReached, projectAchievement,
--          createdAt, updatedAt
-- =====================================================

CREATE POLICY "public_select_completed_projects"
ON "Post_Project_Tbl" FOR SELECT
TO public
USING (true);

CREATE POLICY "auth_manage_completed_projects"
ON "Post_Project_Tbl" FOR ALL
TO authenticated
USING (is_sk_official_or_captain())
WITH CHECK (is_sk_official_or_captain());


-- =====================================================
-- APPLICATION_TBL (4 policies)
-- Columns: applicationID, userID, preProjectID,
--          preferredRole, parentConsentFile,
--          applicationStatus, appliedDate, createdAt
-- =====================================================

CREATE POLICY "auth_select_applications"
ON "Application_Tbl" FOR SELECT
TO authenticated
USING (
  "userID" = (select auth.uid())
  OR is_sk_official_or_captain()
  OR is_superadmin()
);

CREATE POLICY "auth_insert_applications"
ON "Application_Tbl" FOR INSERT
TO authenticated
WITH CHECK ("userID" = (select auth.uid()));

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

CREATE POLICY "auth_delete_applications"
ON "Application_Tbl" FOR DELETE
TO authenticated
USING ("userID" = (select auth.uid()) AND "applicationStatus" = 'PENDING');


-- =====================================================
-- INQUIRY_TBL (2 policies)
-- Columns: inquiryID, preProjectID, userID, message,
--          isReplied, timeStamp, createdAt
-- =====================================================

CREATE POLICY "auth_select_inquiries"
ON "Inquiry_Tbl" FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "auth_insert_inquiries"
ON "Inquiry_Tbl" FOR INSERT
TO authenticated
WITH CHECK ("userID" = (select auth.uid()));


-- =====================================================
-- REPLY_TBL (4 policies)
-- Columns: replyID, inquiryID, userID, message,
--          timeStamp, createdAt
-- =====================================================

CREATE POLICY "auth_select_replies"
ON "Reply_Tbl" FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "auth_insert_replies"
ON "Reply_Tbl" FOR INSERT
TO authenticated
WITH CHECK ("userID" = (select auth.uid()));

CREATE POLICY "auth_update_replies"
ON "Reply_Tbl" FOR UPDATE
TO authenticated
USING ("userID" = (select auth.uid()))
WITH CHECK ("userID" = (select auth.uid()));

CREATE POLICY "auth_delete_replies"
ON "Reply_Tbl" FOR DELETE
TO authenticated
USING ("userID" = (select auth.uid()));


-- =====================================================
-- NOTIFICATION_TBL (4 policies)
-- Columns: notificationID, userID, notificationType,
--          title, isRead, createdAt
-- =====================================================

CREATE POLICY "auth_select_notifications"
ON "Notification_Tbl" FOR SELECT
TO authenticated
USING ("userID" = (select auth.uid()));

CREATE POLICY "auth_insert_notifications"
ON "Notification_Tbl" FOR INSERT
TO authenticated
WITH CHECK (true);

CREATE POLICY "auth_update_notifications"
ON "Notification_Tbl" FOR UPDATE
TO authenticated
USING ("userID" = (select auth.uid()))
WITH CHECK ("userID" = (select auth.uid()));

CREATE POLICY "auth_delete_notifications"
ON "Notification_Tbl" FOR DELETE
TO authenticated
USING ("userID" = (select auth.uid()));


-- =====================================================
-- OTP_TBL (3 policies)
-- Columns: otpID, userID, otpCode, expiresAt, isUsed,
--          purpose, createdAt
-- =====================================================

CREATE POLICY "auth_select_otp"
ON "OTP_Tbl" FOR SELECT
TO authenticated
USING ("userID" = (select auth.uid()));

CREATE POLICY "auth_insert_otp"
ON "OTP_Tbl" FOR INSERT
TO authenticated
WITH CHECK ("userID" = (select auth.uid()));

CREATE POLICY "auth_update_otp"
ON "OTP_Tbl" FOR UPDATE
TO authenticated
USING ("userID" = (select auth.uid()))
WITH CHECK ("userID" = (select auth.uid()));


-- =====================================================
-- CERTIFICATE_TBL (2 policies)
-- Columns: certificateID, postProjectID, applicationID,
--          userID, certificateFileURL, timeStamp, createdAt
-- =====================================================

CREATE POLICY "auth_select_certificates"
ON "Certificate_Tbl" FOR SELECT
TO authenticated
USING (
  "userID" = (select auth.uid())
  OR is_sk_official_or_captain()
);

CREATE POLICY "auth_insert_certificates"
ON "Certificate_Tbl" FOR INSERT
TO authenticated
WITH CHECK (is_sk_official_or_captain());


-- =====================================================
-- EVALUATION_TBL (2 policies)
-- Columns: evaluationID, postProjectID, applicationID,
--          q1-q5, message, timeStamp, hasCertificate, createdAt
-- =====================================================

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
-- TESTIMONIES_TBL (4 policies)
-- =====================================================

CREATE POLICY "public_select_testimonies"
ON "Testimonies_Tbl" FOR SELECT
TO public
USING ("isFiltered" = false);

CREATE POLICY "auth_select_all_testimonies"
ON "Testimonies_Tbl" FOR SELECT
TO authenticated
USING (is_sk_official_or_captain());

CREATE POLICY "auth_insert_testimonies"
ON "Testimonies_Tbl" FOR INSERT
TO authenticated
WITH CHECK ("userID" = (select auth.uid()));

CREATE POLICY "auth_update_testimonies"
ON "Testimonies_Tbl" FOR UPDATE
TO authenticated
USING (is_sk_official_or_captain());


-- =====================================================
-- BUDGETBREAKDOWN_TBL (2 policies)
-- Columns: breakdownID, preProjectID, description,
--          cost, createdAt
-- =====================================================

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

CREATE POLICY "auth_manage_budgets"
ON "BudgetBreakdown_Tbl" FOR ALL
TO authenticated
USING (is_sk_official_or_captain())
WITH CHECK (is_sk_official_or_captain());


-- =====================================================
-- EXPENSES_TBL (1 policy)
-- Columns: expenseID, breakdownID, actualCost,
--          receiptURL, createdAt
-- =====================================================

CREATE POLICY "auth_manage_expenses"
ON "Expenses_Tbl" FOR ALL
TO authenticated
USING (is_sk_official_or_captain())
WITH CHECK (is_sk_official_or_captain());


-- =====================================================
-- ANNUAL_BUDGET_TBL (2 policies)
-- Columns: budgetID, expenseCategory, budget,
--          fiscalYear, createdAt
-- =====================================================

CREATE POLICY "public_select_annual_budgets"
ON "Annual_Budget_Tbl" FOR SELECT
TO public
USING (true);

CREATE POLICY "auth_manage_annual_budgets"
ON "Annual_Budget_Tbl" FOR ALL
TO authenticated
USING (is_sk_official_or_captain())
WITH CHECK (is_sk_official_or_captain());


-- =====================================================
-- REPORT_TBL (1 policy)
-- Columns: reportID, postProjectID, applicationID,
--          evaluationID, reportStatus, requestedAt,
--          createdAt, updatedAt
-- =====================================================

CREATE POLICY "auth_manage_reports"
ON "Report_Tbl" FOR ALL
TO authenticated
USING (is_sk_official_or_captain())
WITH CHECK (is_sk_official_or_captain());


-- =====================================================
-- LOGS_TBL (2 policies)
-- Columns: logID, userID, action, replyID, postProjectID,
--          applicationID, inquiryID, notificationID, fileID,
--          testimonyID, timeStamp, createdAt
-- =====================================================

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

CREATE POLICY "auth_insert_logs"
ON "Logs_Tbl" FOR INSERT
TO authenticated
WITH CHECK ("userID" = (select auth.uid()));


-- =====================================================
-- PART 4: ADD MISSING FOREIGN KEY INDEXES
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_logs_reply ON "Logs_Tbl"("replyID");
CREATE INDEX IF NOT EXISTS idx_logs_postproject ON "Logs_Tbl"("postProjectID");
CREATE INDEX IF NOT EXISTS idx_logs_application ON "Logs_Tbl"("applicationID");
CREATE INDEX IF NOT EXISTS idx_logs_inquiry ON "Logs_Tbl"("inquiryID");
CREATE INDEX IF NOT EXISTS idx_logs_notification ON "Logs_Tbl"("notificationID");
CREATE INDEX IF NOT EXISTS idx_logs_file ON "Logs_Tbl"("fileID");
CREATE INDEX IF NOT EXISTS idx_logs_testimony ON "Logs_Tbl"("testimonyID");
CREATE INDEX IF NOT EXISTS idx_postproject_breakdown ON "Post_Project_Tbl"("breakdownID");
CREATE INDEX IF NOT EXISTS idx_report_application ON "Report_Tbl"("applicationID");
CREATE INDEX IF NOT EXISTS idx_report_evaluation ON "Report_Tbl"("evaluationID");
