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
- **Backend:** Supabase (PostgreSQL Database, Authentication, Storage)
- **Deployment:** Netlify (Frontend Hosting with CI/CD)
- **Authentication:** Email/Password with OTP verification via Gmail API
- **Database:** PostgreSQL (via Supabase)

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
- SK Officials: Create, Edit, Delete (permanent)
- Youth Volunteers: View only
- Image upload max 5MB
- Note: Delete is permanent (no archive functionality)

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

## SUPABASE DATABASE SCHEMA (Data Dictionary)

**Name Formatting Standard:**
- All names (firstName, lastName, middleName) are stored in **Title Case**
- Example: "john doe" → "John Doe", "MARY" → "Mary"
- **Table names** use **Title Case with underscores** (e.g., User_Tbl, SK_Tbl, Announcement_Tbl)
- **Column names** use **camelCase** (e.g., userID, firstName, imagePathURL)
- Actual name data uses **Title Case** (proper capitalization)

### User_Tbl (Core User Information)
```
userID: UUID (PRIMARY KEY - Supabase Auth UID)
email: VARCHAR(255) (UNIQUE, NOT NULL - Supabase Auth handles)
password: TEXT (NOT NULL - Supabase Auth handles)
firstName: VARCHAR(100) (NOT NULL, min 2 characters)
lastName: VARCHAR(100) (NOT NULL, min 2 characters)
middleName: VARCHAR(100) (NULLABLE, no minimum length - can be single letter or initial)
role: VARCHAR(20) ('SK_OFFICIAL', 'YOUTH_VOLUNTEER', 'CAPTAIN')
birthday: DATE (NOT NULL)
contactNumber: VARCHAR(13) (NOT NULL)
address: TEXT (NOT NULL)
imagePathURL: TEXT (NULLABLE)
termsConditions: BOOLEAN (NOT NULL)
accountStatus: VARCHAR(20) ('ACTIVE', 'INACTIVE', 'PENDING') (DEFAULT: 'PENDING')
gender: VARCHAR(20) (NULLABLE)
createdAt: TIMESTAMPTZ (DEFAULT: NOW())
updatedAt: TIMESTAMPTZ (DEFAULT: NOW())
```

### SK_Tbl (SK Officials)
```
skID: SERIAL (PRIMARY KEY)
userID: UUID (FOREIGN KEY → User_Tbl.userID)
position: VARCHAR(20) ('SK_CHAIRMAN', 'SK_SECRETARY', 'SK_TREASURER', 'SK_KAGAWAD')
termStart: DATE (NOT NULL)
termEnd: DATE (NOT NULL)
createdAt: TIMESTAMPTZ (DEFAULT: NOW())
```

**Position Constraints:**
- **Single Active Account Positions** (Only ONE active account allowed):
  - SK_CHAIRMAN
  - SK_SECRETARY
  - SK_TREASURER
- **Multiple Active Account Positions:**
  - SK_KAGAWAD (Maximum 7 active accounts)

### Captain_Tbl (Barangay Captain)
```
captainID: SERIAL (PRIMARY KEY)
userID: UUID (FOREIGN KEY → User_Tbl.userID)
termStart: DATE (NOT NULL)
termEnd: DATE (NOT NULL)
isActive: BOOLEAN (DEFAULT: TRUE)
createdAt: TIMESTAMPTZ (DEFAULT: NOW())
updatedAt: TIMESTAMPTZ (DEFAULT: NOW())
```

**Captain Role Constraint:**
- Only ONE active CAPTAIN account allowed in the system
- Promoting a new Captain automatically deactivates the existing active Captain

### Announcement_Tbl (Announcements)
```
announcementID: SERIAL (PRIMARY KEY)
userID: UUID (FOREIGN KEY → User_Tbl.userID)
title: VARCHAR(255) (NOT NULL)
category: VARCHAR(20) ('URGENT', 'UPDATE', 'GENERAL')
description: TEXT (NULLABLE)
imagePathURL: TEXT (NULLABLE)
publishedDate: TIMESTAMPTZ (NOT NULL)
createdAt: TIMESTAMPTZ (DEFAULT: NOW())
updatedAt: TIMESTAMPTZ (DEFAULT: NOW())
```

### File_Tbl (Document Repository)
```
fileID: SERIAL (PRIMARY KEY)
userID: UUID (FOREIGN KEY → User_Tbl.userID)
fileName: VARCHAR(255) (NOT NULL)
fileType: VARCHAR(10) ('PDF', 'XLSX', 'JPG', 'PNG', 'DOC')
fileStatus: VARCHAR(20) ('ACTIVE', 'ARCHIVED') (DEFAULT: 'ACTIVE')
filePath: TEXT (NOT NULL)
fileCategory: VARCHAR(20) ('GENERAL', 'PROJECT')
dateUploaded: TIMESTAMPTZ (DEFAULT: NOW())
createdAt: TIMESTAMPTZ (DEFAULT: NOW())
```

### Pre_Project_Tbl (Project Proposals)
```
preProjectID: SERIAL (PRIMARY KEY)
userID: UUID (FOREIGN KEY → User_Tbl.userID, creator)
skID: INTEGER (FOREIGN KEY → SK_Tbl.skID, project head)
title: VARCHAR(255) (NOT NULL)
description: TEXT (NOT NULL)
category: VARCHAR(100) (NOT NULL)
budget: BIGINT (NOT NULL)
volunteers: INTEGER (NOT NULL, expected count)
beneficiaries: INTEGER (NOT NULL, expected count)
status: VARCHAR(20) ('ONGOING', 'COMPLETED', 'CANCELLED') (DEFAULT: 'ONGOING')
startDateTime: TIMESTAMPTZ (NOT NULL)
endDateTime: TIMESTAMPTZ (NOT NULL)
location: TEXT (NOT NULL)
imagePathURL: TEXT (NULLABLE)
submittedDate: TIMESTAMPTZ (NOT NULL)
approvalStatus: VARCHAR(20) ('PENDING', 'APPROVED', 'REJECTED', 'REVISION') (DEFAULT: 'PENDING')
approvalDate: TIMESTAMPTZ (NULLABLE)
approvalNotes: TEXT (NULLABLE, for revision/rejection reasons)
createdAt: TIMESTAMPTZ (DEFAULT: NOW())
updatedAt: TIMESTAMPTZ (DEFAULT: NOW())
```

### Post_Project_Tbl (Completed Projects)
```
postProjectID: SERIAL (PRIMARY KEY)
preProjectID: INTEGER (FOREIGN KEY → Pre_Project_Tbl.preProjectID)
breakdownID: INTEGER (FOREIGN KEY → BudgetBreakdown_Tbl.breakdownID)
actualVolunteer: INTEGER (NOT NULL)
timelineAdherence: VARCHAR(30) ('Completed_On_Time', 'Slightly_Delayed', 'Delayed', 'Significantly_Delayed')
beneficiariesReached: INTEGER (NOT NULL)
projectAchievement: TEXT (NOT NULL)
createdAt: TIMESTAMPTZ (DEFAULT: NOW())
updatedAt: TIMESTAMPTZ (DEFAULT: NOW())
```

### Application_Tbl (Volunteer Applications)
```
applicationID: SERIAL (PRIMARY KEY)
userID: UUID (FOREIGN KEY → User_Tbl.userID)
preProjectID: INTEGER (FOREIGN KEY → Pre_Project_Tbl.preProjectID)
preferredRole: VARCHAR(100) (NOT NULL)
parentConsentFile: TEXT (NOT NULL if under 18)
applicationStatus: VARCHAR(20) ('PENDING', 'APPROVED', 'REJECTED') (DEFAULT: 'PENDING')
appliedDate: TIMESTAMPTZ (DEFAULT: CURRENT_TIMESTAMP)
createdAt: TIMESTAMPTZ (DEFAULT: NOW())
```

### Inquiry_Tbl (Project Inquiries)
```
inquiryID: SERIAL (PRIMARY KEY)
preProjectID: INTEGER (FOREIGN KEY → Pre_Project_Tbl.preProjectID)
userID: UUID (FOREIGN KEY → User_Tbl.userID)
message: TEXT (NOT NULL)
isReplied: BOOLEAN (DEFAULT: FALSE)
timeStamp: TIMESTAMPTZ (DEFAULT: NOW())
createdAt: TIMESTAMPTZ (DEFAULT: NOW())
```

### Reply_Tbl (Inquiry Replies)
```
replyID: SERIAL (PRIMARY KEY)
inquiryID: INTEGER (FOREIGN KEY → Inquiry_Tbl.inquiryID)
userID: UUID (FOREIGN KEY → User_Tbl.userID)
message: TEXT (NOT NULL)
timeStamp: TIMESTAMPTZ (DEFAULT: NOW())
createdAt: TIMESTAMPTZ (DEFAULT: NOW())
```

### Notification_Tbl (User Notifications)
```
notificationID: SERIAL (PRIMARY KEY)
userID: UUID (FOREIGN KEY → User_Tbl.userID)
notificationType: VARCHAR(50) ('new_announcement', 'inquiry_update', 'new_project', 'application_approved', 'application_pending', 'project_approved', 'project_rejected', 'revision_requested', 'new_inquiry', 'new_application', 'project_awaiting_approval')
title: VARCHAR(255) (NOT NULL)
isRead: BOOLEAN (DEFAULT: FALSE)
createdAt: TIMESTAMPTZ (NOT NULL, DEFAULT: NOW())
```

### OTP_Tbl (One-Time Passwords)
```
otpID: SERIAL (PRIMARY KEY)
userID: UUID (FOREIGN KEY → User_Tbl.userID)
otpCode: VARCHAR(6) (NOT NULL)
expiresAt: TIMESTAMPTZ (NOT NULL)
isUsed: BOOLEAN (DEFAULT: FALSE)
purpose: VARCHAR(20) ('LOGIN', 'FORGOT_PASSWORD', 'SIGN_UP')
createdAt: TIMESTAMPTZ (DEFAULT: NOW())
```

### Certificate_Tbl (Volunteer Certificates)
```
certificateID: SERIAL (PRIMARY KEY)
postProjectID: INTEGER (FOREIGN KEY → Post_Project_Tbl.postProjectID)
applicationID: INTEGER (FOREIGN KEY → Application_Tbl.applicationID)
userID: UUID (FOREIGN KEY → User_Tbl.userID)
certificateFileURL: TEXT (NOT NULL)
timeStamp: TIMESTAMPTZ (NOT NULL)
createdAt: TIMESTAMPTZ (DEFAULT: NOW())
```

### Evaluation_Tbl (Project Evaluations)
```
evaluationID: SERIAL (PRIMARY KEY)
postProjectID: INTEGER (FOREIGN KEY → Post_Project_Tbl.postProjectID)
applicationID: INTEGER (FOREIGN KEY → Application_Tbl.applicationID)
q1: INTEGER (NOT NULL, rating 1-5, CHECK (q1 BETWEEN 1 AND 5))
q2: INTEGER (NOT NULL, rating 1-5, CHECK (q2 BETWEEN 1 AND 5))
q3: INTEGER (NOT NULL, rating 1-5, CHECK (q3 BETWEEN 1 AND 5))
q4: INTEGER (NOT NULL, rating 1-5, CHECK (q4 BETWEEN 1 AND 5))
q5: INTEGER (NOT NULL, rating 1-5, CHECK (q5 BETWEEN 1 AND 5))
message: TEXT (NULLABLE, suggestions)
timeStamp: TIMESTAMPTZ (NOT NULL)
hasCertificate: BOOLEAN (DEFAULT: FALSE)
createdAt: TIMESTAMPTZ (DEFAULT: NOW())
```

### Testimonies_Tbl (User Testimonials)
```
testimonyID: SERIAL (PRIMARY KEY)
userID: UUID (FOREIGN KEY → User_Tbl.userID)
message: TEXT (NOT NULL)
rating: INTEGER (NULLABLE, 1-5 stars, CHECK (rating BETWEEN 1 AND 5))
isFiltered: BOOLEAN (DEFAULT: FALSE, moderation flag)
timeStamp: TIMESTAMPTZ (DEFAULT: NOW())
createdAt: TIMESTAMPTZ (DEFAULT: NOW())
```

### BudgetBreakdown_Tbl (Budget Items)
```
breakdownID: SERIAL (PRIMARY KEY)
preProjectID: INTEGER (FOREIGN KEY → Pre_Project_Tbl.preProjectID)
description: VARCHAR(255) (NOT NULL, item name)
cost: BIGINT (NOT NULL)
createdAt: TIMESTAMPTZ (DEFAULT: NOW())
```

### Expenses_Tbl (Actual Expenses)
```
expenseID: SERIAL (PRIMARY KEY)
breakdownID: INTEGER (FOREIGN KEY → BudgetBreakdown_Tbl.breakdownID)
actualCost: DECIMAL(15,2) (NOT NULL)
receiptURL: TEXT (NULLABLE)
createdAt: TIMESTAMPTZ (DEFAULT: NOW())
```

### Annual_Budget_Tbl (Annual Budget Allocation)
```
budgetID: SERIAL (PRIMARY KEY)
expenseCategory: VARCHAR(100) (NULLABLE)
budget: BIGINT (NULLABLE)
fiscalYear: INTEGER (NOT NULL)
createdAt: TIMESTAMPTZ (DEFAULT: NOW())
```

### Report_Tbl (Project Reports)
```
reportID: SERIAL (PRIMARY KEY)
postProjectID: INTEGER (FOREIGN KEY → Post_Project_Tbl.postProjectID)
applicationID: INTEGER (FOREIGN KEY → Application_Tbl.applicationID)
evaluationID: INTEGER (FOREIGN KEY → Evaluation_Tbl.evaluationID)
reportStatus: VARCHAR(20) ('DRAFT', 'SUBMITTED', 'APPROVED', 'REJECTED') (DEFAULT: 'DRAFT')
requestedAt: TIMESTAMPTZ (NULLABLE)
createdAt: TIMESTAMPTZ (DEFAULT: NOW())
updatedAt: TIMESTAMPTZ (DEFAULT: NOW())
```

### Logs_Tbl (Activity Logs)
```
logID: SERIAL (PRIMARY KEY)
userID: UUID (FOREIGN KEY → User_Tbl.userID)
action: VARCHAR(255) (NOT NULL)
replyID: INTEGER (NULLABLE)
postProjectID: INTEGER (NULLABLE)
applicationID: INTEGER (NULLABLE)
inquiryID: INTEGER (NULLABLE)
notificationID: INTEGER (NULLABLE)
fileID: INTEGER (NULLABLE)
testimonyID: INTEGER (NULLABLE)
timeStamp: TIMESTAMPTZ (DEFAULT: NOW())
createdAt: TIMESTAMPTZ (DEFAULT: NOW())
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

## ROW LEVEL SECURITY (RLS) POLICIES

**All tables use RLS for role-based access control.** Policies are enforced at the database level using Supabase/PostgreSQL.

### Helper Functions

```sql
is_sk_official()           -- Checks if user is SK Official
is_captain()               -- Checks if user is Captain
is_sk_official_or_captain() -- Checks if user is SK Official OR Captain
is_superadmin()            -- Checks if user is Superadmin
```

### Role-Based Access Summary

| Feature | Captain | SK Official | Youth Volunteer | Public |
|---------|---------|-------------|----------------|--------|
| **Announcements** | View all | Full CRUD | View active | View active |
| **Files** | View all | Full CRUD | View/Download | View active |
| **Projects (Proposals)** | Approve/Reject/Revise | Full CRUD | View approved | View approved |
| **Projects (Completed)** | View | Full CRUD | View | View |
| **Applications** | None | View/Update | Own CRUD | None |
| **Inquiries** | None | View all | Own CRUD | None |
| **Replies** | None | Create/View | View own | None |
| **Testimonies** | View unfiltered | Filter/View all | Submit | View unfiltered |
| **Certificates** | None | Create/View | View own | None |
| **Evaluations** | None | View all | Submit own | None |
| **Budget/Expenses** | None | Full CRUD | None | View approved |
| **Notifications** | Own CRUD | Own CRUD | Own CRUD | None |
| **User Profiles** | View all | View all | View own/Update | View active |

### Key Permission Rules

**Captain (Governance/Oversight Role)**
- ✅ View all announcements (active + archived)
- ✅ View all files (active + archived)
- ✅ View all projects (any status)
- ✅ Approve/Reject/Request Revision on projects
- ❌ NO CRUD on announcements
- ❌ NO CRUD on files
- ❌ NO CRUD on projects
- ❌ NO access to testimonies filtering
- ❌ NO access to applications/inquiries

**SK Officials (Administrator)**
- ✅ Full CRUD on announcements
- ✅ Full CRUD on files
- ✅ Full CRUD on projects
- ✅ Manage applications, inquiries, replies
- ✅ Filter/moderate testimonies
- ✅ Create certificates
- ✅ View all evaluations
- ✅ Manage budgets and expenses

**Youth Volunteers (User)**
- ✅ View approved projects only
- ✅ Apply to projects
- ✅ Create inquiries
- ✅ Submit testimonies
- ✅ Submit evaluations
- ✅ Update own profile
- ❌ NO access to pending/rejected projects
- ❌ NO access to other users' data

**Public (No Account)**
- ✅ View active announcements
- ✅ View active files
- ✅ View approved projects
- ✅ View unfiltered testimonies
- ✅ View active user profiles
- ❌ NO write access to anything

### RLS Implementation File

Complete RLS policies stored in: `supabase/rls-policies.sql`

All policies use table names in Title Case (`User_Tbl`) and column names in camelCase (`userID`).

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

### 4 Core Principles

All development must adhere to these fundamental principles:

#### 1. 🔒 **Security**
- **RLS Policies**: Enforce role-based access control at database level
- **Input Validation**: Sanitize and validate all user inputs
- **Authentication**: Use Supabase Auth with OTP verification
- **Environment Variables**: Never hardcode sensitive keys or credentials
- **XSS Prevention**: Escape all user-generated content
- **SQL Injection Prevention**: Use parameterized queries only
- **HTTPS Only**: All communications must be encrypted

#### 2. 🛡️ **Reliability**
- **Error Handling**: Comprehensive try-catch blocks with user-friendly messages
- **Data Integrity**: PostgreSQL constraints, foreign keys, and CHECK constraints
- **Transaction Safety**: Use database transactions for multi-step operations
- **Graceful Degradation**: System remains functional even when features fail
- **Backup Strategy**: Regular database backups via Supabase
- **Testing**: Thorough testing before deployment
- **Logging**: Track critical operations in Logs_Tbl for audit trails

#### 3. ⚡ **Efficiency**
- **Query Optimization**: Use indexes, avoid N+1 queries, minimize joins
- **Caching**: Implement appropriate caching strategies
- **Lazy Loading**: Load resources only when needed
- **Code Splitting**: Break large files into smaller, focused modules
- **Database Performance**: Leverage PostgreSQL features (triggers, functions)
- **Asset Optimization**: Compress images, minify CSS/JS
- **Responsive Design**: Mobile-first approach with Tailwind CSS

#### 4. 🔧 **Maintainability**
- **Clean Code**: Follow industry standards and consistent style
- **Naming Conventions**:
  - Table names: Title Case with underscores (e.g., `User_Tbl`, `SK_Tbl`)
  - Column names: camelCase (e.g., `userID`, `firstName`, `imagePathURL`)
  - Functions: camelCase with descriptive names
  - Constants: UPPER_CASE with underscores
- **Documentation**: Comment complex logic, maintain up-to-date docs
- **Modular Design**: Small, focused functions and components
- **DRY Principle**: Don't Repeat Yourself - reuse code via functions/modules
- **Version Control**: Clear, descriptive commit messages
- **Code Reviews**: All changes reviewed before merging
- **Entity Relationships**: Maintain all foreign key constraints

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
