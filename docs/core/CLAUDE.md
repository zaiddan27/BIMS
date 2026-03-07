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
role: VARCHAR(20) ('SUPERADMIN', 'CAPTAIN', 'SK_OFFICIAL', 'YOUTH_VOLUNTEER')
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
attended: BOOLEAN (DEFAULT: FALSE, tracks project attendance)
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
notificationType: VARCHAR(50) ('new_announcement', 'inquiry_update', 'new_project', 'application_approved', 'application_pending', 'project_approved', 'project_rejected', 'revision_requested', 'new_inquiry', 'new_application', 'project_awaiting_approval', 'user_promoted', 'user_deactivated', 'user_reactivated', 'captain_term_expiring', 'captain_term_expired')
title: VARCHAR(255) (NOT NULL)
isRead: BOOLEAN (DEFAULT: FALSE)
referenceID: INTEGER (NULLABLE, deep link to related entity e.g. preProjectID)
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
postProjectID: INTEGER (NULLABLE, FOREIGN KEY → Post_Project_Tbl.postProjectID)
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

**Status:** ✅ All 20 tables verified (2026-02-21)
**Version:** 3.0 (Optimized - Consolidated + InitPlan)

All tables use **Row Level Security (RLS)** for role-based access control enforced at the database level.

### Performance Optimizations (v3.0)
- All `auth.uid()` wrapped as `(select auth.uid())` — evaluated once per query, not per row
- Duplicate/overlapping permissive policies consolidated — 51 total policies (down from ~70+)
- 10 missing foreign key indexes added (Logs_Tbl, Post_Project_Tbl, Report_Tbl)
- All Supabase linter warnings resolved (`auth_rls_initplan`, `multiple_permissive_policies`, `unindexed_foreign_keys`)

### 📖 Complete RLS Documentation

**Full policy reference:** `DATABASE_TABLE_COLUMN_REFERENCE.md` (Row Level Security section)

This comprehensive documentation includes:
- System status (51 policies across 20 tables)
- Helper functions (is_sk_official, is_captain, is_superadmin, etc.)
- Complete role permission matrix (PUBLIC, YOUTH_VOLUNTEER, CAPTAIN, SK_OFFICIAL, SUPERADMIN)
- Policy patterns and examples
- Table-specific policies for all 20 tables
- Verification commands
- Policy count summary

**SQL Implementation:** `supabase/rls-policies.sql`
**Verification Script:** `supabase/verification/verify_rls_policies.sql`
**Latest Verification Report:** `RLS_POLICIES_FINAL_VERIFICATION_2026-01-12.md`
**Optimization Migrations:** `supabase/migrations/015_comprehensive_rls_optimization.sql`, `015b_fix_rls_policies.sql`

### Quick Reference: Key Permission Rules

**Captain (Governance/Oversight)**
- ✅ View all content (announcements, files, projects)
- ✅ Approve/Reject/Request Revision on projects
- ❌ NO CRUD operations (view + approve only)
- ❌ NO access to testimony moderation
- ❌ NO access to applications/inquiries

**SK Officials (Administrator)**
- ✅ Full CRUD on all content (announcements, files, projects)
- ✅ Manage applications, inquiries, replies
- ✅ Filter/moderate testimonies
- ✅ Create certificates, view evaluations
- ✅ Manage budgets and expenses

**Youth Volunteers (User)**
- ✅ View approved content only
- ✅ Apply to projects, create inquiries, submit testimonies/evaluations
- ✅ Update own profile
- ❌ NO access to pending/rejected projects
- ❌ NO access to other users' data

**Public (No Account)**
- ✅ View active/approved content only
- ❌ NO write access to anything

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

## DOCUMENTATION MANAGEMENT

### 📁 Markdown File Organization

**CRITICAL**: All markdown (.md) files MUST be created in the appropriate `docs/` subfolder. NEVER create .md files in the project root.

### Folder Structure

```
docs/
├── core/                    # Core project documentation
│   ├── CLAUDE.md           # This file - Development specification
│   ├── README.md           # Detailed project overview
│   ├── PROGRESS.md         # Project phase tracking
│   └── CHANGELOG.md        # Version history
│
├── database/               # Database documentation
│   ├── DATABASE_TABLE_COLUMN_REFERENCE.md  # Complete schema + RLS
│   ├── AUTH-SETUP.md       # Authentication configuration
│   └── SUPABASE-SETUP.md   # Supabase setup guide
│
├── verification/           # Testing & verification
│   ├── RLS_POLICIES_FINAL_VERIFICATION_2026-01-12.md
│   └── TESTING_GUIDE.md    # Testing procedures
│
└── archive/                # Historical documentation
    ├── CLEANUP_SUMMARY.md
    ├── MARKDOWN_CLEANUP_CONSOLIDATION_PLAN.md
    └── SQL_CLEANUP_PLAN.md
```

### Rules for Creating Markdown Files

1. **NEVER create .md files in project root** - always use `docs/` subfolders
2. **Choose the appropriate subfolder:**
   - **`docs/core/`** - Project specifications, progress tracking, changelogs
   - **`docs/database/`** - Database schemas, RLS policies, backend setup
   - **`docs/verification/`** - Test reports, verification results, QA documentation
   - **`docs/archive/`** - Historical docs, cleanup plans, deprecated guides

3. **File naming conventions:**
   - Use **UPPER_CASE** for major documents (e.g., `CLAUDE.md`, `README.md`)
   - Use **Title_Case** for specific reports (e.g., `RLS_Policies_Final_Verification.md`)
   - Use **kebab-case** for guides (e.g., `user-management-guide.md`)
   - Include dates for time-sensitive docs (e.g., `_YYYY-MM-DD.md` suffix)

4. **Before creating a new .md file:**
   - Check if a relevant file already exists
   - If updating existing content, edit the existing file instead of creating new
   - If creating verification/audit reports, use `docs/verification/`
   - If creating historical/cleanup docs, use `docs/archive/`

### Examples

```bash
# ✅ CORRECT - Create in appropriate subfolder
docs/database/NEW_FEATURE_SETUP.md
docs/verification/API_TEST_REPORT_2026-01-15.md
docs/archive/MIGRATION_CLEANUP_PLAN.md

# ❌ INCORRECT - Never in root
NEW_FEATURE_SETUP.md
API_TEST_REPORT.md
CLEANUP_PLAN.md
```

### SQL File Organization

**SQL files should be organized as follows:**

```
supabase/
├── migrations/              # Database migrations (sequential)
│   ├── 001_create_schema.sql
│   ├── 002_create_storage_buckets.sql
│   └── ...
│   └── archived/           # Archived/redundant migrations
│
├── verification/           # SQL verification scripts
│   └── verify_rls_policies.sql
│
└── rls-policies.sql        # Complete RLS policy definitions
```

**Rules:**
- Keep `supabase/migrations/` clean - only essential migrations
- Archive redundant migrations to `supabase/migrations/archived/`
- Use `supabase/verification/` for verification scripts only
- NEVER create SQL files in project root

---

## SUPABASE CLI & DATABASE TOOLS

### Running SQL Directly
Use the `run-sql.sh` script to execute SQL against the remote Supabase database instead of manually copy-pasting into the dashboard:

```bash
# Run inline SQL
bash supabase/run-sql.sh "SELECT * FROM \"User_Tbl\" LIMIT 5;"

# Run a SQL file
bash supabase/run-sql.sh supabase/migrations/018_fix_testimony_and_archive_delete.sql
```

### Migration Management
```bash
# Preview which migrations would be applied
npx supabase db push --dry-run

# Push pending migrations to remote database
npx supabase db push

# List projects
npx supabase projects list
```

### When to Use
- **New migration files** → Run them with `bash supabase/run-sql.sh path/to/file.sql`
- **Debugging database issues** → Query directly with `bash supabase/run-sql.sh "SELECT ..."`
- **Verifying schema/data** → Use run-sql.sh instead of asking the user to check the dashboard
- **Batch migrations** → Use `npx supabase db push`

### Configuration
- Access token stored in `.env.supabase` (gitignored)
- Project linked to `vreuvpzxnvrhftafmado` (BIMS)

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
