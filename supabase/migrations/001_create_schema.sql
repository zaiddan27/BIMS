-- ============================================
-- BIMS Database Schema
-- Barangay Information Management System
-- ============================================

-- Enable UUID extension for generating IDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- USER TABLES
-- ============================================

-- User_Tbl: Core user information
-- Note: userID matches Firebase Auth UID (Supabase auth.users.id)
CREATE TABLE User_Tbl (
  userID UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR(255) UNIQUE NOT NULL,
  firstName VARCHAR(100) NOT NULL,
  lastName VARCHAR(100) NOT NULL,
  middleName VARCHAR(100),
  role VARCHAR(20) NOT NULL CHECK (role IN ('SK_OFFICIAL', 'YOUTH_VOLUNTEER', 'CAPTAIN')),
  birthday DATE NOT NULL,
  contactNumber VARCHAR(13) NOT NULL,
  address TEXT NOT NULL,
  imagePathURL TEXT,
  termsConditions BOOLEAN NOT NULL DEFAULT FALSE,
  accountStatus VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (accountStatus IN ('ACTIVE', 'INACTIVE', 'PENDING')),
  createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index for common queries
CREATE INDEX idx_user_email ON User_Tbl(email);
CREATE INDEX idx_user_role ON User_Tbl(role);
CREATE INDEX idx_user_status ON User_Tbl(accountStatus);

-- SK_Tbl: SK Officials information
CREATE TABLE SK_Tbl (
  skID SERIAL PRIMARY KEY,
  userID UUID NOT NULL REFERENCES User_Tbl(userID) ON DELETE CASCADE,
  position VARCHAR(20) NOT NULL CHECK (position IN ('SK_CHAIRMAN', 'SK_SECRETARY', 'SK_TREASURER', 'SK_KAGAWAD')),
  termStart DATE NOT NULL,
  termEnd DATE NOT NULL,
  createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(userID, termStart) -- Prevent duplicate assignments
);

CREATE INDEX idx_sk_user ON SK_Tbl(userID);
CREATE INDEX idx_sk_term ON SK_Tbl(termStart, termEnd);

-- ============================================
-- CONTENT MANAGEMENT TABLES
-- ============================================

-- Announcement_Tbl: Announcements posted by SK Officials
CREATE TABLE Announcement_Tbl (
  announcementID SERIAL PRIMARY KEY,
  userID UUID NOT NULL REFERENCES User_Tbl(userID) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  category VARCHAR(20) NOT NULL CHECK (category IN ('URGENT', 'UPDATE', 'GENERAL')),
  contentStatus VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (contentStatus IN ('ACTIVE', 'ARCHIVED')),
  description TEXT,
  imagePathURL TEXT,
  publishedDate TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_announcement_user ON Announcement_Tbl(userID);
CREATE INDEX idx_announcement_category ON Announcement_Tbl(category);
CREATE INDEX idx_announcement_status ON Announcement_Tbl(contentStatus);
CREATE INDEX idx_announcement_date ON Announcement_Tbl(publishedDate DESC);

-- File_Tbl: Document repository
CREATE TABLE File_Tbl (
  fileID SERIAL PRIMARY KEY,
  userID UUID NOT NULL REFERENCES User_Tbl(userID) ON DELETE CASCADE,
  fileName VARCHAR(255) NOT NULL,
  fileType VARCHAR(10) NOT NULL CHECK (fileType IN ('PDF', 'XLSX', 'JPG', 'PNG', 'DOC')),
  fileStatus VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (fileStatus IN ('ACTIVE', 'ARCHIVED')),
  filePath TEXT NOT NULL,
  fileCategory VARCHAR(20) NOT NULL CHECK (fileCategory IN ('GENERAL', 'PROJECT')),
  dateUploaded TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_file_user ON File_Tbl(userID);
CREATE INDEX idx_file_status ON File_Tbl(fileStatus);
CREATE INDEX idx_file_category ON File_Tbl(fileCategory);
CREATE INDEX idx_file_date ON File_Tbl(dateUploaded DESC);

-- ============================================
-- PROJECT MANAGEMENT TABLES
-- ============================================

-- Pre_Project_Tbl: Project proposals
CREATE TABLE Pre_Project_Tbl (
  preProjectID SERIAL PRIMARY KEY,
  userID UUID NOT NULL REFERENCES User_Tbl(userID) ON DELETE CASCADE,
  skID INTEGER REFERENCES SK_Tbl(skID) ON DELETE SET NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  category VARCHAR(100) NOT NULL,
  budget BIGINT NOT NULL CHECK (budget >= 0),
  volunteers INTEGER NOT NULL CHECK (volunteers >= 0),
  beneficiaries INTEGER NOT NULL CHECK (beneficiaries >= 0),
  status VARCHAR(20) NOT NULL DEFAULT 'ONGOING' CHECK (status IN ('ONGOING', 'COMPLETED', 'CANCELLED')),
  startDateTime TIMESTAMP WITH TIME ZONE NOT NULL,
  endDateTime TIMESTAMP WITH TIME ZONE NOT NULL,
  location TEXT NOT NULL,
  imagePathURL TEXT,
  submittedDate TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  approvalStatus VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (approvalStatus IN ('PENDING', 'APPROVED', 'REJECTED', 'REVISION')),
  approvalDate TIMESTAMP WITH TIME ZONE,
  approvalNotes TEXT,
  createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT check_dates CHECK (endDateTime > startDateTime)
);

CREATE INDEX idx_preproject_user ON Pre_Project_Tbl(userID);
CREATE INDEX idx_preproject_sk ON Pre_Project_Tbl(skID);
CREATE INDEX idx_preproject_status ON Pre_Project_Tbl(status);
CREATE INDEX idx_preproject_approval ON Pre_Project_Tbl(approvalStatus);
CREATE INDEX idx_preproject_date ON Pre_Project_Tbl(startDateTime DESC);

-- BudgetBreakdown_Tbl: Budget line items for projects
CREATE TABLE BudgetBreakdown_Tbl (
  breakdownID SERIAL PRIMARY KEY,
  preProjectID INTEGER NOT NULL REFERENCES Pre_Project_Tbl(preProjectID) ON DELETE CASCADE,
  description VARCHAR(255) NOT NULL,
  cost BIGINT NOT NULL CHECK (cost >= 0),
  createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_budget_project ON BudgetBreakdown_Tbl(preProjectID);

-- Expenses_Tbl: Actual expenses with receipts
CREATE TABLE Expenses_Tbl (
  expenseID SERIAL PRIMARY KEY,
  breakdownID INTEGER NOT NULL REFERENCES BudgetBreakdown_Tbl(breakdownID) ON DELETE CASCADE,
  actualCost DECIMAL(15,2) NOT NULL CHECK (actualCost >= 0),
  receiptURL TEXT,
  createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_expense_breakdown ON Expenses_Tbl(breakdownID);

-- Post_Project_Tbl: Completed project data
CREATE TABLE Post_Project_Tbl (
  postProjectID SERIAL PRIMARY KEY,
  preProjectID INTEGER UNIQUE NOT NULL REFERENCES Pre_Project_Tbl(preProjectID) ON DELETE CASCADE,
  breakdownID INTEGER REFERENCES BudgetBreakdown_Tbl(breakdownID) ON DELETE SET NULL,
  actualVolunteer INTEGER NOT NULL CHECK (actualVolunteer >= 0),
  timelineAdherence VARCHAR(30) NOT NULL CHECK (timelineAdherence IN ('Completed_On_Time', 'Slightly_Delayed', 'Delayed', 'Significantly_Delayed')),
  beneficiariesReached INTEGER NOT NULL CHECK (beneficiariesReached >= 0),
  projectAchievement TEXT NOT NULL,
  createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_postproject_pre ON Post_Project_Tbl(preProjectID);

-- ============================================
-- APPLICATION & INQUIRY TABLES
-- ============================================

-- Application_Tbl: Volunteer applications for projects
CREATE TABLE Application_Tbl (
  applicationID SERIAL PRIMARY KEY,
  userID UUID NOT NULL REFERENCES User_Tbl(userID) ON DELETE CASCADE,
  preProjectID INTEGER NOT NULL REFERENCES Pre_Project_Tbl(preProjectID) ON DELETE CASCADE,
  preferredRole VARCHAR(100) NOT NULL,
  parentConsentFile TEXT,
  applicationStatus VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (applicationStatus IN ('PENDING', 'APPROVED', 'REJECTED')),
  appliedDate TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(userID, preProjectID) -- Prevent duplicate applications
);

CREATE INDEX idx_application_user ON Application_Tbl(userID);
CREATE INDEX idx_application_project ON Application_Tbl(preProjectID);
CREATE INDEX idx_application_status ON Application_Tbl(applicationStatus);

-- Inquiry_Tbl: User inquiries about projects
CREATE TABLE Inquiry_Tbl (
  inquiryID SERIAL PRIMARY KEY,
  preProjectID INTEGER NOT NULL REFERENCES Pre_Project_Tbl(preProjectID) ON DELETE CASCADE,
  userID UUID NOT NULL REFERENCES User_Tbl(userID) ON DELETE CASCADE,
  message TEXT NOT NULL,
  isReplied BOOLEAN DEFAULT FALSE,
  timeStamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_inquiry_project ON Inquiry_Tbl(preProjectID);
CREATE INDEX idx_inquiry_user ON Inquiry_Tbl(userID);
CREATE INDEX idx_inquiry_replied ON Inquiry_Tbl(isReplied);

-- Reply_Tbl: Replies to inquiries
CREATE TABLE Reply_Tbl (
  replyID SERIAL PRIMARY KEY,
  inquiryID INTEGER NOT NULL REFERENCES Inquiry_Tbl(inquiryID) ON DELETE CASCADE,
  userID UUID NOT NULL REFERENCES User_Tbl(userID) ON DELETE CASCADE,
  message TEXT NOT NULL,
  timeStamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_reply_inquiry ON Reply_Tbl(inquiryID);
CREATE INDEX idx_reply_user ON Reply_Tbl(userID);

-- ============================================
-- NOTIFICATION & COMMUNICATION TABLES
-- ============================================

-- Notification_Tbl: User notifications
CREATE TABLE Notification_Tbl (
  notificationID SERIAL PRIMARY KEY,
  userID UUID NOT NULL REFERENCES User_Tbl(userID) ON DELETE CASCADE,
  notificationType VARCHAR(50) NOT NULL CHECK (notificationType IN (
    'new_announcement', 'inquiry_update', 'new_project',
    'application_approved', 'application_pending', 'project_approved',
    'project_rejected', 'revision_requested', 'new_inquiry',
    'new_application', 'project_awaiting_approval'
  )),
  title VARCHAR(255) NOT NULL,
  isRead BOOLEAN DEFAULT FALSE,
  createdAt TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_notification_user ON Notification_Tbl(userID);
CREATE INDEX idx_notification_read ON Notification_Tbl(isRead);
CREATE INDEX idx_notification_date ON Notification_Tbl(createdAt DESC);

-- OTP_Tbl: One-time passwords for verification
CREATE TABLE OTP_Tbl (
  otpID SERIAL PRIMARY KEY,
  userID UUID NOT NULL REFERENCES User_Tbl(userID) ON DELETE CASCADE,
  otpCode VARCHAR(6) NOT NULL,
  expiresAt TIMESTAMP WITH TIME ZONE NOT NULL,
  isUsed BOOLEAN DEFAULT FALSE,
  purpose VARCHAR(20) NOT NULL CHECK (purpose IN ('LOGIN', 'FORGOT_PASSWORD', 'SIGN_UP')),
  createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_otp_user ON OTP_Tbl(userID);
CREATE INDEX idx_otp_code ON OTP_Tbl(otpCode);
CREATE INDEX idx_otp_expires ON OTP_Tbl(expiresAt);

-- ============================================
-- EVALUATION & CERTIFICATE TABLES
-- ============================================

-- Certificate_Tbl: Volunteer certificates
CREATE TABLE Certificate_Tbl (
  certificationID SERIAL PRIMARY KEY,
  postProjectID INTEGER NOT NULL REFERENCES Post_Project_Tbl(postProjectID) ON DELETE CASCADE,
  applicationID INTEGER NOT NULL REFERENCES Application_Tbl(applicationID) ON DELETE CASCADE,
  userID UUID NOT NULL REFERENCES User_Tbl(userID) ON DELETE CASCADE,
  certificateFileURL TEXT NOT NULL,
  timeStamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_certificate_post ON Certificate_Tbl(postProjectID);
CREATE INDEX idx_certificate_app ON Certificate_Tbl(applicationID);
CREATE INDEX idx_certificate_user ON Certificate_Tbl(userID);

-- Evaluation_Tbl: Project evaluations by volunteers
CREATE TABLE Evaluation_Tbl (
  evaluationID SERIAL PRIMARY KEY,
  postProjectID INTEGER NOT NULL REFERENCES Post_Project_Tbl(postProjectID) ON DELETE CASCADE,
  applicationID INTEGER NOT NULL REFERENCES Application_Tbl(applicationID) ON DELETE CASCADE,
  q1 INTEGER NOT NULL CHECK (q1 BETWEEN 1 AND 5),
  q2 INTEGER NOT NULL CHECK (q2 BETWEEN 1 AND 5),
  q3 INTEGER NOT NULL CHECK (q3 BETWEEN 1 AND 5),
  q4 INTEGER NOT NULL CHECK (q4 BETWEEN 1 AND 5),
  q5 INTEGER NOT NULL CHECK (q5 BETWEEN 1 AND 5),
  message TEXT,
  timeStamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  hasCertificate BOOLEAN DEFAULT FALSE,
  createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(postProjectID, applicationID) -- One evaluation per volunteer per project
);

CREATE INDEX idx_evaluation_post ON Evaluation_Tbl(postProjectID);
CREATE INDEX idx_evaluation_app ON Evaluation_Tbl(applicationID);

-- ============================================
-- TESTIMONIES & BUDGET TABLES
-- ============================================

-- Testimonies_Tbl: User testimonials
CREATE TABLE Testimonies_Tbl (
  testimonyID SERIAL PRIMARY KEY,
  userID UUID NOT NULL REFERENCES User_Tbl(userID) ON DELETE CASCADE,
  message TEXT NOT NULL,
  isFiltered BOOLEAN DEFAULT FALSE,
  timeStamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_testimony_user ON Testimonies_Tbl(userID);
CREATE INDEX idx_testimony_filtered ON Testimonies_Tbl(isFiltered);

-- Annual_Budget_Tbl: Annual budget tracking
CREATE TABLE Annual_Budget_Tbl (
  annualBudgetID SERIAL PRIMARY KEY,
  expenseCategory VARCHAR(100),
  budget BIGINT CHECK (budget >= 0),
  fiscalYear INTEGER NOT NULL,
  createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(expenseCategory, fiscalYear)
);

CREATE INDEX idx_annual_budget_year ON Annual_Budget_Tbl(fiscalYear);

-- ============================================
-- REPORT & LOGGING TABLES
-- ============================================

-- Report_Tbl: Project reports
CREATE TABLE Report_Tbl (
  reportID SERIAL PRIMARY KEY,
  postProjectID INTEGER NOT NULL REFERENCES Post_Project_Tbl(postProjectID) ON DELETE CASCADE,
  applicationID INTEGER REFERENCES Application_Tbl(applicationID) ON DELETE SET NULL,
  evaluationID INTEGER REFERENCES Evaluation_Tbl(evaluationID) ON DELETE SET NULL,
  reportStatus VARCHAR(20) NOT NULL DEFAULT 'DRAFT' CHECK (reportStatus IN ('DRAFT', 'SUBMITTED', 'APPROVED', 'REJECTED')),
  requestedAt TIMESTAMP WITH TIME ZONE,
  createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_report_post ON Report_Tbl(postProjectID);
CREATE INDEX idx_report_status ON Report_Tbl(reportStatus);

-- Logs_Tbl: System activity logs
CREATE TABLE Logs_Tbl (
  logID SERIAL PRIMARY KEY,
  userID UUID NOT NULL REFERENCES User_Tbl(userID) ON DELETE CASCADE,
  action VARCHAR(255) NOT NULL,
  replyID INTEGER REFERENCES Reply_Tbl(replyID) ON DELETE SET NULL,
  postProjectID INTEGER REFERENCES Post_Project_Tbl(postProjectID) ON DELETE SET NULL,
  applicationID INTEGER REFERENCES Application_Tbl(applicationID) ON DELETE SET NULL,
  inquiryID INTEGER REFERENCES Inquiry_Tbl(inquiryID) ON DELETE SET NULL,
  notificationID INTEGER REFERENCES Notification_Tbl(notificationID) ON DELETE SET NULL,
  fileID INTEGER REFERENCES File_Tbl(fileID) ON DELETE SET NULL,
  testimonyID INTEGER REFERENCES Testimonies_Tbl(testimonyID) ON DELETE SET NULL,
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_logs_user ON Logs_Tbl(userID);
CREATE INDEX idx_logs_timestamp ON Logs_Tbl(timestamp DESC);
CREATE INDEX idx_logs_action ON Logs_Tbl(action);

-- ============================================
-- TRIGGERS FOR UPDATED_AT TIMESTAMPS
-- ============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updatedAt = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply trigger to tables with updatedAt column
CREATE TRIGGER update_user_updated_at BEFORE UPDATE ON User_Tbl
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_announcement_updated_at BEFORE UPDATE ON Announcement_Tbl
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_preproject_updated_at BEFORE UPDATE ON Pre_Project_Tbl
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_postproject_updated_at BEFORE UPDATE ON Post_Project_Tbl
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_report_updated_at BEFORE UPDATE ON Report_Tbl
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
