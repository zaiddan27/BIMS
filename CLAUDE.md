# BIMS - Barangay Information Management System

## Project Context
SE2 implementation phase for SK Malanday, Marikina City. All SE1 planning/design is complete.
Original documentation in `PROJECT DOCUMENTS/` (SPMP, SRS, SDD) - reference only if needed for edge cases.

## IMPORTANT: Check Progress First
**Always read `PROGRESS.md` to see current phase and what's completed.**
- Update `PROGRESS.md` after completing tasks
- Follow the phase order (don't skip ahead)

## Tech Stack
- **Frontend:** HTML, Tailwind CSS, Vanilla JavaScript
- **Backend:** Firebase (Authentication, Firestore, Storage)
- **Authentication:** Email/Password with OTP verification via Gmail API

---

## USER ROLES & PERMISSIONS

| Role | Access Level | Permissions |
|------|-------------|-------------|
| Barangay Captain | Approval | Review/Approve/Reject project proposals, view dashboard |
| SK Officials | Administrator | Full CRUD on projects, files, announcements, manage applications |
| Youth Volunteers | User | View, apply to projects, inquire, receive certificates, submit testimonials |
| Visitors (no account) | Public | View landing page, projects, testimonials, transparency reports |

---

## CORE MODULES

### 1. Login & Authentication
- Email/Password login with OTP verification
- Sign-up (Youth Volunteers only)
- Forgot Password with OTP
- 5 login attempts max, then 15-min lockout
- Role-based redirection after login

### 2. Manage Content (Announcements)
- Categories: URGENT, UPDATE, GENERAL
- SK Officials: Create, Edit, Delete, Archive
- Youth Volunteers: View only
- Image upload max 5MB

### 3. Manage Files
- Public document repository
- File types: PDF, XLSX, JPG, PNG, DOC
- Max file size: 10MB
- Categories: GENERAL, PROJECT
- Auto-archive after 1 year shelf-life
- SK Officials: Upload, Delete, Archive
- Youth Volunteers: View, Download, Search

### 4. Monitor Projects
- Full lifecycle: Proposal → Approval → Ongoing → Completed → Archived
- SK Officials: Create, Edit, Delete, Manage Applications, Reply Inquiries
- Barangay Captain: Approve/Reject/Request Revision
- Youth Volunteers: View, Apply, Inquire
- Applicants under 18 require parental consent upload

---

## PROJECT SUCCESS METRICS (Weighted)
- Budget Efficiency: 25%
- Volunteer Participation: 20%
- Community Impact: 20%
- Timeline Adherence: 20%
- Volunteer Feedback: 15%

---

## FIREBASE COLLECTIONS (Data Dictionary)

### User_Tbl
```
userID: STRING (PRIMARY KEY - Firebase Auth UID)
email: STRING (UNIQUE, NOT NULL)
password: STRING (NOT NULL - Firebase Auth handles)
firstName: STRING (NOT NULL)
lastName: STRING (NOT NULL)
middleName: STRING (NOT NULL)
role: ENUM ['SK_OFFICIAL', 'YOUTH_VOLUNTEER', 'CAPTAIN']
birthday: DATE (NOT NULL)
contactNumber: STRING (max 13 chars, NOT NULL)
address: STRING (NOT NULL)
imagePathURL: STRING (NULLABLE)
termsConditions: BOOLEAN (NOT NULL)
accountStatus: ENUM ['ACTIVE', 'INACTIVE', 'PENDING'] (DEFAULT: PENDING)
```

### SK_Tbl
```
skID: INTEGER (PRIMARY KEY)
userID: STRING (FOREIGN KEY → User_Tbl)
position: ENUM ['SK_CHAIRMAN', 'SK_SECRETARY', 'SK_TREASURER', 'SK_AUDITOR', 'SK_KAGAWAD']
termStart: DATE (NOT NULL)
termEnd: DATE (NOT NULL)
```

### Announcement_Tbl
```
announcementID: INTEGER (PRIMARY KEY)
userID: STRING (FOREIGN KEY → User_Tbl)
title: STRING (NOT NULL)
category: ENUM ['URGENT', 'UPDATE', 'GENERAL']
contentStatus: ENUM ['ACTIVE', 'ARCHIVED'] (DEFAULT: ACTIVE)
description: STRING (NULLABLE)
imagePathURL: STRING (NULLABLE)
publishedDate: DATE (NOT NULL)
```

### File_Tbl
```
fileID: INTEGER (PRIMARY KEY)
userID: STRING (FOREIGN KEY → User_Tbl)
fileName: STRING (NOT NULL)
fileType: ENUM ['PDF', 'XLSX', 'JPG', 'PNG', 'DOC']
fileStatus: ENUM ['ACTIVE', 'ARCHIVED'] (DEFAULT: ACTIVE)
filePath: STRING (NOT NULL)
fileCategory: ENUM ['GENERAL', 'PROJECT']
dateUploaded: DATE (DEFAULT: CURRENT)
```

### Pre_Project_Tbl (Project Proposals)
```
preProjectID: INTEGER (PRIMARY KEY)
userID: STRING (FOREIGN KEY → User_Tbl, creator)
skID: INTEGER (FOREIGN KEY → SK_Tbl, project head)
title: STRING (NOT NULL)
description: STRING (NOT NULL)
category: STRING (NOT NULL)
budget: LONG (NOT NULL)
volunteers: INTEGER (NOT NULL, expected count)
beneficiaries: INTEGER (NOT NULL, expected count)
status: ENUM ['ONGOING', 'COMPLETED', 'CANCELLED'] (DEFAULT: ONGOING)
startDateTime: DATETIME (NOT NULL)
endDateTime: DATETIME (NOT NULL)
location: STRING (NOT NULL)
imagePathURL: STRING (NULLABLE)
submittedDate: DATE (NOT NULL)
approvalStatus: ENUM ['PENDING', 'APPROVED', 'REJECTED', 'REVISION'] (DEFAULT: PENDING)
approvalDate: DATE (NULLABLE)
approvalNotes: STRING (NULLABLE, for revision/rejection reasons)
```

### Post_Project_Tbl (Completed Projects)
```
postProjectID: INTEGER (PRIMARY KEY)
preProjectID: INTEGER (FOREIGN KEY → Pre_Project_Tbl)
breakdownID: INTEGER (FOREIGN KEY → BudgetBreakdown_Tbl)
actualVolunteer: INTEGER (NOT NULL)
timelineAdherence: ENUM ['Completed_On_Time', 'Slightly_Delayed', 'Delayed', 'Significantly_Delayed']
beneficiariesReached: INTEGER (NOT NULL)
projectAchievement: STRING (NOT NULL)
```

### Application_Tbl
```
applicationID: INTEGER (PRIMARY KEY)
userID: STRING (FOREIGN KEY → User_Tbl)
preProjectID: INTEGER (FOREIGN KEY → Pre_Project_Tbl)
preferredRole: STRING (NOT NULL)
parentConsentFile: STRING (NOT NULL if under 18)
applicationStatus: ENUM ['PENDING', 'APPROVED', 'REJECTED'] (DEFAULT: PENDING)
appliedDate: DATE (DEFAULT: CURRENT)
```

### Inquiry_Tbl
```
inquiryID: INTEGER (PRIMARY KEY)
preProjectID: INTEGER (FOREIGN KEY → Pre_Project_Tbl)
userID: STRING (FOREIGN KEY → User_Tbl)
message: STRING (NOT NULL)
isReplied: BOOLEAN (DEFAULT: FALSE)
timeStamp: DATETIME (DEFAULT: CURRENT)
```

### Reply_Tbl
```
replyID: INTEGER (PRIMARY KEY)
inquiryID: INTEGER (FOREIGN KEY → Inquiry_Tbl)
userID: STRING (FOREIGN KEY → User_Tbl)
message: STRING (NOT NULL)
timeStamp: DATETIME (DEFAULT: CURRENT)
```

### Notification_Tbl
```
notificationID: INTEGER (PRIMARY KEY)
userID: STRING (FOREIGN KEY → User_Tbl)
notificationType: ENUM ['new_announcement', 'inquiry_update', 'new_project', 'application_approved', 'application_pending', 'project_approved', 'project_rejected', 'revision_requested', 'new_inquiry', 'new_application', 'project_awaiting_approval']
title: STRING (NOT NULL)
isRead: BOOLEAN (DEFAULT: FALSE)
createdAt: DATETIME (NOT NULL)
```

### OTP_Tbl
```
otpID: INTEGER (PRIMARY KEY)
userID: STRING (FOREIGN KEY → User_Tbl)
otpCode: STRING (6 chars, NOT NULL)
expiresAt: DATETIME (NOT NULL)
isUsed: BOOLEAN (DEFAULT: FALSE)
purpose: ENUM ['LOGIN', 'FORGOT_PASSWORD', 'SIGN_UP']
```

### Certificate_Tbl
```
certificationID: INTEGER (PRIMARY KEY)
postProjectID: INTEGER (FOREIGN KEY → Post_Project_Tbl)
applicationID: INTEGER (FOREIGN KEY → Application_Tbl)
userID: STRING (FOREIGN KEY → User_Tbl)
certificateFileURL: STRING (NOT NULL)
timeStamp: DATETIME (NOT NULL)
```

### Evaluation_Tbl
```
evaluationID: INTEGER (PRIMARY KEY)
postProjectID: INTEGER (FOREIGN KEY → Post_Project_Tbl)
applicationID: INTEGER (FOREIGN KEY → Application_Tbl)
q1: INTEGER (NOT NULL, rating 1-5)
q2: INTEGER (NOT NULL, rating 1-5)
q3: INTEGER (NOT NULL, rating 1-5)
q4: INTEGER (NOT NULL, rating 1-5)
q5: INTEGER (NOT NULL, rating 1-5)
message: STRING (NULLABLE, suggestions)
timeStamp: DATETIME (NOT NULL)
hasCertificate: BOOLEAN (DEFAULT: FALSE)
```

### Testimonies_Tbl
```
testimonyID: INTEGER (PRIMARY KEY)
userID: STRING (FOREIGN KEY → User_Tbl)
message: TEXT (NOT NULL)
isFiltered: BOOLEAN (DEFAULT: FALSE, moderation flag)
timeStamp: DATETIME (DEFAULT: CURRENT)
```

### BudgetBreakdown_Tbl
```
breakdownID: INTEGER (PRIMARY KEY)
preProjectID: INTEGER (FOREIGN KEY → Pre_Project_Tbl)
description: STRING (NOT NULL, item name)
cost: LONG (NOT NULL)
```

### Expenses_Tbl
```
expenseID: INTEGER (PRIMARY KEY)
breakdownID: INTEGER (FOREIGN KEY → BudgetBreakdown_Tbl)
actualCost: DECIMAL(15,2) (NOT NULL)
receiptURL: STRING (NULLABLE)
```

### Annual_Budget_Tbl
```
annualBudgetID: INTEGER (PRIMARY KEY)
expenseCategory: STRING (NULLABLE)
budget: LONG (NULLABLE)
fiscalYear: INTEGER (NOT NULL)
```

### Report_Tbl
```
reportID: INTEGER (PRIMARY KEY)
postProjectID: INTEGER (FOREIGN KEY → Post_Project_Tbl)
applicationID: INTEGER (FOREIGN KEY → Application_Tbl)
evaluationID: INTEGER (FOREIGN KEY → Evaluation_Tbl)
reportStatus: ENUM ['DRAFT', 'SUBMITTED', 'APPROVED', 'REJECTED'] (DEFAULT: DRAFT)
requestedAt: DATETIME (NULLABLE)
```

### Logs_Tbl
```
logID: INTEGER (PRIMARY KEY)
userID: STRING (FOREIGN KEY → User_Tbl)
action: STRING (NOT NULL)
replyID: INTEGER (NULLABLE)
postProjectID: INTEGER (NULLABLE)
applicationID: INTEGER (NULLABLE)
inquiryID: INTEGER (NULLABLE)
notificationID: INTEGER (NULLABLE)
fileID: INTEGER (NULLABLE)
testimonyID: INTEGER (NULLABLE)
timestamp: DATETIME (DEFAULT: CURRENT)
```

---

## ENTITY RELATIONSHIPS

```
User_Tbl (1) ←→ (M) SK_Tbl
User_Tbl (1) ←→ (M) Announcement_Tbl
User_Tbl (1) ←→ (M) File_Tbl
User_Tbl (1) ←→ (M) Application_Tbl
User_Tbl (1) ←→ (M) Inquiry_Tbl
User_Tbl (1) ←→ (M) Reply_Tbl
User_Tbl (1) ←→ (M) Notification_Tbl
User_Tbl (1) ←→ (M) OTP_Tbl
User_Tbl (1) ←→ (M) Testimonies_Tbl
User_Tbl (1) ←→ (M) Logs_Tbl

Pre_Project_Tbl (1) ←→ (M) Application_Tbl
Pre_Project_Tbl (1) ←→ (M) Inquiry_Tbl
Pre_Project_Tbl (1) ←→ (M) BudgetBreakdown_Tbl
Pre_Project_Tbl (1) ←→ (1) Post_Project_Tbl

Post_Project_Tbl (1) ←→ (M) Certificate_Tbl
Post_Project_Tbl (1) ←→ (M) Evaluation_Tbl
Post_Project_Tbl (1) ←→ (M) Report_Tbl

Inquiry_Tbl (1) ←→ (M) Reply_Tbl
BudgetBreakdown_Tbl (1) ←→ (M) Expenses_Tbl
Application_Tbl (1) ←→ (M) Certificate_Tbl
```

---

## CHANGE MANAGEMENT PROTOCOL

When deviating from this specification:
1. STOP and explain why documented approach won't work
2. PROPOSE alternative with technical reasoning
3. REPORT using format:

```
DOCUMENTATION DEVIATION REPORT
Document: [SRS/SDD/SPMP]
Section: [reference]
Original Spec: [what docs say]
Proposed Change: [what you recommend]
Reason: [technical justification]
Impact: [affected components, database changes, risks]
```

4. WAIT for approval before implementing
5. LOG approved changes in CHANGES.md

---

## BEST PRACTICES (Mandatory)
- Clean, maintainable code following industry standards
- Proper error handling and input validation
- Firebase Security Rules for role-based access
- Exact naming conventions from Data Dictionary above
- Maintain all entity relationships
- Responsive design and cross-browser compatibility
- Comments for complex logic
- No hardcoded values

---

## SKILLS USAGE (Auto-Invoke)

### Development Workflow
- **New Feature** → Use `brainstorming` skill first, then `writing-plans`
- **Implementation** → Use `executing-plans` with `test-driven-development`
- **Bug Fix** → Use `systematic-debugging` (4-phase investigation)
- **Code Review** → Use `requesting-code-review` after implementation

### Skill Priority Order
1. Process skills FIRST (brainstorming, debugging)
2. Implementation skills SECOND (frontend-design, TDD)

### Document Skills
- `pdf`, `docx`, `xlsx`, `pptx` - For generating reports, certificates, exports

### Commands
- `/brainstorm [feature]` - Design session
- `/write-plan [feature]` - Create implementation plan
- `/execute-plan` - Run saved plan
- `/debug [issue]` - Systematic debugging
- `/tdd [feature]` - Test-driven development
