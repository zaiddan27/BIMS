-- ============================================
-- BIMS Row Level Security (RLS) Policies
-- Barangay Information Management System
-- ============================================

-- Enable RLS on all tables
ALTER TABLE User_Tbl ENABLE ROW LEVEL SECURITY;
ALTER TABLE SK_Tbl ENABLE ROW LEVEL SECURITY;
ALTER TABLE Announcement_Tbl ENABLE ROW LEVEL SECURITY;
ALTER TABLE File_Tbl ENABLE ROW LEVEL SECURITY;
ALTER TABLE Pre_Project_Tbl ENABLE ROW LEVEL SECURITY;
ALTER TABLE BudgetBreakdown_Tbl ENABLE ROW LEVEL SECURITY;
ALTER TABLE Expenses_Tbl ENABLE ROW LEVEL SECURITY;
ALTER TABLE Post_Project_Tbl ENABLE ROW LEVEL SECURITY;
ALTER TABLE Application_Tbl ENABLE ROW LEVEL SECURITY;
ALTER TABLE Inquiry_Tbl ENABLE ROW LEVEL SECURITY;
ALTER TABLE Reply_Tbl ENABLE ROW LEVEL SECURITY;
ALTER TABLE Notification_Tbl ENABLE ROW LEVEL SECURITY;
ALTER TABLE OTP_Tbl ENABLE ROW LEVEL SECURITY;
ALTER TABLE Certificate_Tbl ENABLE ROW LEVEL SECURITY;
ALTER TABLE Evaluation_Tbl ENABLE ROW LEVEL SECURITY;
ALTER TABLE Testimonies_Tbl ENABLE ROW LEVEL SECURITY;
ALTER TABLE Annual_Budget_Tbl ENABLE ROW LEVEL SECURITY;
ALTER TABLE Report_Tbl ENABLE ROW LEVEL SECURITY;
ALTER TABLE Logs_Tbl ENABLE ROW LEVEL SECURITY;

-- ============================================
-- HELPER FUNCTIONS FOR RLS
-- ============================================

-- Function to check if user is SK Official or Captain
CREATE OR REPLACE FUNCTION is_sk_official_or_captain()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM User_Tbl
    WHERE userID = auth.uid() AND role IN ('SK_OFFICIAL', 'CAPTAIN')
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if user is Captain
CREATE OR REPLACE FUNCTION is_captain()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM User_Tbl
    WHERE userID = auth.uid() AND role = 'CAPTAIN'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get current user role
CREATE OR REPLACE FUNCTION get_user_role()
RETURNS TEXT AS $$
BEGIN
  RETURN (
    SELECT role FROM User_Tbl WHERE userID = auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- USER_TBL POLICIES
-- ============================================

-- Allow users to read their own profile
CREATE POLICY "Users can view their own profile"
ON User_Tbl FOR SELECT
TO authenticated
USING (userID = auth.uid());

-- Allow SK Officials to view all user profiles
CREATE POLICY "SK Officials can view all profiles"
ON User_Tbl FOR SELECT
TO authenticated
USING (is_sk_official_or_captain());

-- Allow public to view active user profiles (limited info)
CREATE POLICY "Public can view active user profiles"
ON User_Tbl FOR SELECT
TO anon
USING (accountStatus = 'ACTIVE');

-- Allow users to update their own profile
CREATE POLICY "Users can update their own profile"
ON User_Tbl FOR UPDATE
TO authenticated
USING (userID = auth.uid())
WITH CHECK (userID = auth.uid());

-- Allow users to insert their own profile during signup
CREATE POLICY "Users can create their own profile"
ON User_Tbl FOR INSERT
TO authenticated
WITH CHECK (userID = auth.uid());

-- SK Officials can update user account status
CREATE POLICY "SK Officials can update account status"
ON User_Tbl FOR UPDATE
TO authenticated
USING (is_sk_official_or_captain());

-- ============================================
-- SK_TBL POLICIES
-- ============================================

-- Public can view SK Officials
CREATE POLICY "Public can view SK Officials"
ON SK_Tbl FOR SELECT
TO public
USING (true);

-- Only SK Officials can insert/update SK records
CREATE POLICY "SK Officials can manage SK records"
ON SK_Tbl FOR ALL
TO authenticated
USING (is_sk_official_or_captain())
WITH CHECK (is_sk_official_or_captain());

-- ============================================
-- ANNOUNCEMENT_TBL POLICIES
-- ============================================

-- Public can view active announcements
CREATE POLICY "Public can view active announcements"
ON Announcement_Tbl FOR SELECT
TO public
USING (contentStatus = 'ACTIVE');

-- SK Officials can view all announcements (including archived)
CREATE POLICY "SK Officials can view all announcements"
ON Announcement_Tbl FOR SELECT
TO authenticated
USING (is_sk_official_or_captain());

-- SK Officials can create announcements
CREATE POLICY "SK Officials can create announcements"
ON Announcement_Tbl FOR INSERT
TO authenticated
WITH CHECK (
  is_sk_official_or_captain() AND
  userID = auth.uid()
);

-- SK Officials can update their own announcements
CREATE POLICY "SK Officials can update their announcements"
ON Announcement_Tbl FOR UPDATE
TO authenticated
USING (
  is_sk_official_or_captain() AND
  userID = auth.uid()
);

-- SK Officials can delete their own announcements
CREATE POLICY "SK Officials can delete their announcements"
ON Announcement_Tbl FOR DELETE
TO authenticated
USING (
  is_sk_official_or_captain() AND
  userID = auth.uid()
);

-- ============================================
-- FILE_TBL POLICIES
-- ============================================

-- Public can view active files
CREATE POLICY "Public can view active files"
ON File_Tbl FOR SELECT
TO public
USING (fileStatus = 'ACTIVE');

-- SK Officials can view all files
CREATE POLICY "SK Officials can view all files"
ON File_Tbl FOR SELECT
TO authenticated
USING (is_sk_official_or_captain());

-- SK Officials can upload files
CREATE POLICY "SK Officials can upload files"
ON File_Tbl FOR INSERT
TO authenticated
WITH CHECK (
  is_sk_official_or_captain() AND
  userID = auth.uid()
);

-- SK Officials can update files
CREATE POLICY "SK Officials can update files"
ON File_Tbl FOR UPDATE
TO authenticated
USING (is_sk_official_or_captain());

-- SK Officials can delete files
CREATE POLICY "SK Officials can delete files"
ON File_Tbl FOR DELETE
TO authenticated
USING (is_sk_official_or_captain());

-- ============================================
-- PRE_PROJECT_TBL POLICIES
-- ============================================

-- Public can view approved projects
CREATE POLICY "Public can view approved projects"
ON Pre_Project_Tbl FOR SELECT
TO public
USING (approvalStatus = 'APPROVED');

-- Authenticated users can view approved projects
CREATE POLICY "Users can view approved projects"
ON Pre_Project_Tbl FOR SELECT
TO authenticated
USING (approvalStatus = 'APPROVED');

-- SK Officials can view all projects
CREATE POLICY "SK Officials can view all projects"
ON Pre_Project_Tbl FOR SELECT
TO authenticated
USING (is_sk_official_or_captain());

-- SK Officials can create projects
CREATE POLICY "SK Officials can create projects"
ON Pre_Project_Tbl FOR INSERT
TO authenticated
WITH CHECK (
  is_sk_official_or_captain() AND
  userID = auth.uid()
);

-- SK Officials can update their own projects
CREATE POLICY "SK Officials can update their projects"
ON Pre_Project_Tbl FOR UPDATE
TO authenticated
USING (
  is_sk_official_or_captain() AND
  (userID = auth.uid() OR is_captain())
);

-- Captain can approve/reject projects
CREATE POLICY "Captain can approve projects"
ON Pre_Project_Tbl FOR UPDATE
TO authenticated
USING (is_captain());

-- SK Officials can delete their own projects
CREATE POLICY "SK Officials can delete their projects"
ON Pre_Project_Tbl FOR DELETE
TO authenticated
USING (
  is_sk_official_or_captain() AND
  userID = auth.uid()
);

-- ============================================
-- BUDGETBREAKDOWN_TBL POLICIES
-- ============================================

-- Public can view budget breakdown for approved projects
CREATE POLICY "Public can view budget breakdown"
ON BudgetBreakdown_Tbl FOR SELECT
TO public
USING (
  EXISTS (
    SELECT 1 FROM Pre_Project_Tbl
    WHERE preProjectID = BudgetBreakdown_Tbl.preProjectID
    AND approvalStatus = 'APPROVED'
  )
);

-- SK Officials can manage budget breakdowns
CREATE POLICY "SK Officials can manage budgets"
ON BudgetBreakdown_Tbl FOR ALL
TO authenticated
USING (is_sk_official_or_captain())
WITH CHECK (is_sk_official_or_captain());

-- ============================================
-- EXPENSES_TBL POLICIES
-- ============================================

-- SK Officials and Captain can view expenses
CREATE POLICY "SK Officials can view expenses"
ON Expenses_Tbl FOR SELECT
TO authenticated
USING (is_sk_official_or_captain());

-- SK Officials can manage expenses
CREATE POLICY "SK Officials can manage expenses"
ON Expenses_Tbl FOR ALL
TO authenticated
USING (is_sk_official_or_captain())
WITH CHECK (is_sk_official_or_captain());

-- ============================================
-- POST_PROJECT_TBL POLICIES
-- ============================================

-- Public can view completed projects
CREATE POLICY "Public can view completed projects"
ON Post_Project_Tbl FOR SELECT
TO public
USING (true);

-- SK Officials can manage completed projects
CREATE POLICY "SK Officials can manage completed projects"
ON Post_Project_Tbl FOR ALL
TO authenticated
USING (is_sk_official_or_captain())
WITH CHECK (is_sk_official_or_captain());

-- ============================================
-- APPLICATION_TBL POLICIES
-- ============================================

-- Users can view their own applications
CREATE POLICY "Users can view their applications"
ON Application_Tbl FOR SELECT
TO authenticated
USING (userID = auth.uid());

-- SK Officials can view all applications
CREATE POLICY "SK Officials can view all applications"
ON Application_Tbl FOR SELECT
TO authenticated
USING (is_sk_official_or_captain());

-- Authenticated users can submit applications
CREATE POLICY "Users can submit applications"
ON Application_Tbl FOR INSERT
TO authenticated
WITH CHECK (userID = auth.uid());

-- Users can update their pending applications
CREATE POLICY "Users can update pending applications"
ON Application_Tbl FOR UPDATE
TO authenticated
USING (
  userID = auth.uid() AND
  applicationStatus = 'PENDING'
);

-- SK Officials can update application status
CREATE POLICY "SK Officials can update applications"
ON Application_Tbl FOR UPDATE
TO authenticated
USING (is_sk_official_or_captain());

-- Users can delete their pending applications
CREATE POLICY "Users can delete pending applications"
ON Application_Tbl FOR DELETE
TO authenticated
USING (
  userID = auth.uid() AND
  applicationStatus = 'PENDING'
);

-- ============================================
-- INQUIRY_TBL POLICIES
-- ============================================

-- Users can view their own inquiries
CREATE POLICY "Users can view their inquiries"
ON Inquiry_Tbl FOR SELECT
TO authenticated
USING (userID = auth.uid());

-- SK Officials can view all inquiries
CREATE POLICY "SK Officials can view all inquiries"
ON Inquiry_Tbl FOR SELECT
TO authenticated
USING (is_sk_official_or_captain());

-- Authenticated users can create inquiries
CREATE POLICY "Users can create inquiries"
ON Inquiry_Tbl FOR INSERT
TO authenticated
WITH CHECK (userID = auth.uid());

-- ============================================
-- REPLY_TBL POLICIES
-- ============================================

-- Users can view replies to their inquiries
CREATE POLICY "Users can view replies to their inquiries"
ON Reply_Tbl FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM Inquiry_Tbl
    WHERE inquiryID = Reply_Tbl.inquiryID
    AND userID = auth.uid()
  )
);

-- SK Officials can view all replies
CREATE POLICY "SK Officials can view all replies"
ON Reply_Tbl FOR SELECT
TO authenticated
USING (is_sk_official_or_captain());

-- SK Officials can create replies
CREATE POLICY "SK Officials can create replies"
ON Reply_Tbl FOR INSERT
TO authenticated
WITH CHECK (
  is_sk_official_or_captain() AND
  userID = auth.uid()
);

-- ============================================
-- NOTIFICATION_TBL POLICIES
-- ============================================

-- Users can view their own notifications
CREATE POLICY "Users can view their notifications"
ON Notification_Tbl FOR SELECT
TO authenticated
USING (userID = auth.uid());

-- System can create notifications for users
CREATE POLICY "System can create notifications"
ON Notification_Tbl FOR INSERT
TO authenticated
WITH CHECK (true);

-- Users can update their own notifications (mark as read)
CREATE POLICY "Users can update their notifications"
ON Notification_Tbl FOR UPDATE
TO authenticated
USING (userID = auth.uid())
WITH CHECK (userID = auth.uid());

-- Users can delete their own notifications
CREATE POLICY "Users can delete their notifications"
ON Notification_Tbl FOR DELETE
TO authenticated
USING (userID = auth.uid());

-- ============================================
-- OTP_TBL POLICIES
-- ============================================

-- Users can view their own OTP records
CREATE POLICY "Users can view their OTP"
ON OTP_Tbl FOR SELECT
TO authenticated
USING (userID = auth.uid());

-- System can create OTP records
CREATE POLICY "System can create OTP"
ON OTP_Tbl FOR INSERT
TO authenticated
WITH CHECK (userID = auth.uid());

-- System can update OTP records
CREATE POLICY "System can update OTP"
ON OTP_Tbl FOR UPDATE
TO authenticated
USING (userID = auth.uid());

-- ============================================
-- CERTIFICATE_TBL POLICIES
-- ============================================

-- Users can view their own certificates
CREATE POLICY "Users can view their certificates"
ON Certificate_Tbl FOR SELECT
TO authenticated
USING (userID = auth.uid());

-- SK Officials can view all certificates
CREATE POLICY "SK Officials can view all certificates"
ON Certificate_Tbl FOR SELECT
TO authenticated
USING (is_sk_official_or_captain());

-- SK Officials can create certificates
CREATE POLICY "SK Officials can create certificates"
ON Certificate_Tbl FOR INSERT
TO authenticated
WITH CHECK (is_sk_official_or_captain());

-- ============================================
-- EVALUATION_TBL POLICIES
-- ============================================

-- Users can view their own evaluations
CREATE POLICY "Users can view their evaluations"
ON Evaluation_Tbl FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM Application_Tbl
    WHERE applicationID = Evaluation_Tbl.applicationID
    AND userID = auth.uid()
  )
);

-- SK Officials can view all evaluations
CREATE POLICY "SK Officials can view all evaluations"
ON Evaluation_Tbl FOR SELECT
TO authenticated
USING (is_sk_official_or_captain());

-- Users can submit their own evaluations
CREATE POLICY "Users can submit evaluations"
ON Evaluation_Tbl FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM Application_Tbl
    WHERE applicationID = Evaluation_Tbl.applicationID
    AND userID = auth.uid()
  )
);

-- ============================================
-- TESTIMONIES_TBL POLICIES
-- ============================================

-- Public can view unfiltered testimonies
CREATE POLICY "Public can view testimonies"
ON Testimonies_Tbl FOR SELECT
TO public
USING (isFiltered = false);

-- SK Officials can view all testimonies
CREATE POLICY "SK Officials can view all testimonies"
ON Testimonies_Tbl FOR SELECT
TO authenticated
USING (is_sk_official_or_captain());

-- Authenticated users can submit testimonies
CREATE POLICY "Users can submit testimonies"
ON Testimonies_Tbl FOR INSERT
TO authenticated
WITH CHECK (userID = auth.uid());

-- SK Officials can update testimonies (filter)
CREATE POLICY "SK Officials can filter testimonies"
ON Testimonies_Tbl FOR UPDATE
TO authenticated
USING (is_sk_official_or_captain());

-- ============================================
-- ANNUAL_BUDGET_TBL POLICIES
-- ============================================

-- Public can view annual budgets
CREATE POLICY "Public can view annual budgets"
ON Annual_Budget_Tbl FOR SELECT
TO public
USING (true);

-- SK Officials can manage annual budgets
CREATE POLICY "SK Officials can manage budgets"
ON Annual_Budget_Tbl FOR ALL
TO authenticated
USING (is_sk_official_or_captain())
WITH CHECK (is_sk_official_or_captain());

-- ============================================
-- REPORT_TBL POLICIES
-- ============================================

-- SK Officials can view all reports
CREATE POLICY "SK Officials can view reports"
ON Report_Tbl FOR SELECT
TO authenticated
USING (is_sk_official_or_captain());

-- SK Officials can manage reports
CREATE POLICY "SK Officials can manage reports"
ON Report_Tbl FOR ALL
TO authenticated
USING (is_sk_official_or_captain())
WITH CHECK (is_sk_official_or_captain());

-- ============================================
-- LOGS_TBL POLICIES
-- ============================================

-- SK Officials can view all logs
CREATE POLICY "SK Officials can view logs"
ON Logs_Tbl FOR SELECT
TO authenticated
USING (is_sk_official_or_captain());

-- System can create logs
CREATE POLICY "System can create logs"
ON Logs_Tbl FOR INSERT
TO authenticated
WITH CHECK (userID = auth.uid());
