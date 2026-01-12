# BIMS Database - Table & Column Name Reference

**CRITICAL**: All table names use **Title Case with underscores** (e.g., `User_Tbl`, `SK_Tbl`)
**CRITICAL**: All column names use **camelCase** (e.g., `userID`, `firstName`, `publishedDate`)

---

## Complete Table & Column Reference

### User_Tbl (Core User Information)
```sql
User_Tbl (
  userID UUID PRIMARY KEY,
  email VARCHAR(255),
  firstName VARCHAR(100),
  lastName VARCHAR(100),
  middleName VARCHAR(100),
  role VARCHAR(20),                -- 'SK_OFFICIAL', 'YOUTH_VOLUNTEER', 'CAPTAIN'
  birthday DATE,
  contactNumber VARCHAR(13),
  address TEXT,
  imagePathURL TEXT,
  termsConditions BOOLEAN,
  accountStatus VARCHAR(20),       -- 'ACTIVE', 'INACTIVE', 'PENDING'
  createdAt TIMESTAMPTZ,
  updatedAt TIMESTAMPTZ,
  gender VARCHAR(20)               -- Optional gender field
)
```

### SK_Tbl (SK Officials)
```sql
SK_Tbl (
  skID SERIAL PRIMARY KEY,
  userID UUID REFERENCES User_Tbl(userID),
  position VARCHAR(20),            -- 'SK_CHAIRMAN', 'SK_SECRETARY', 'SK_TREASURER', 'SK_KAGAWAD'
  termStart DATE,
  termEnd DATE,
  createdAt TIMESTAMPTZ
)
```

### Captain_Tbl (Barangay Captain)
```sql
Captain_Tbl (
  captainID SERIAL PRIMARY KEY,
  userID UUID REFERENCES User_Tbl(userID),
  termStart DATE,
  termEnd DATE,
  isActive BOOLEAN,
  createdAt TIMESTAMPTZ,
  updatedAt TIMESTAMPTZ
)
```

### Announcement_Tbl (Announcements)
```sql
Announcement_Tbl (
  announcementID SERIAL PRIMARY KEY,
  userID UUID REFERENCES User_Tbl(userID),
  title VARCHAR(255),
  category VARCHAR(20),            -- 'URGENT', 'UPDATE', 'GENERAL'
  description TEXT,
  imagePathURL TEXT,
  publishedDate TIMESTAMPTZ,
  createdAt TIMESTAMPTZ,
  updatedAt TIMESTAMPTZ
)
```

### File_Tbl (Document Repository)
```sql
File_Tbl (
  fileID SERIAL PRIMARY KEY,
  userID UUID REFERENCES User_Tbl(userID),
  fileName VARCHAR(255),
  fileType VARCHAR(10),            -- 'PDF', 'XLSX', 'JPG', 'PNG', 'DOC'
  fileStatus VARCHAR(20),          -- 'ACTIVE', 'ARCHIVED'
  filePath TEXT,
  fileCategory VARCHAR(20),        -- 'GENERAL', 'PROJECT'
  dateUploaded TIMESTAMPTZ,
  createdAt TIMESTAMPTZ
)
```

### Pre_Project_Tbl (Project Proposals)
```sql
Pre_Project_Tbl (
  preProjectID SERIAL PRIMARY KEY,
  userID UUID REFERENCES User_Tbl(userID),
  skID INTEGER REFERENCES SK_Tbl(skID),
  title VARCHAR(255),
  description TEXT,
  category VARCHAR(100),
  budget BIGINT,
  volunteers INTEGER,
  beneficiaries INTEGER,
  status VARCHAR(20),              -- 'ONGOING', 'COMPLETED', 'CANCELLED'
  startDateTime TIMESTAMPTZ,
  endDateTime TIMESTAMPTZ,
  location TEXT,
  imagePathURL TEXT,
  submittedDate TIMESTAMPTZ,
  approvalStatus VARCHAR(20),      -- 'PENDING', 'APPROVED', 'REJECTED', 'REVISION'
  approvalDate TIMESTAMPTZ,
  approvalNotes TEXT,
  createdAt TIMESTAMPTZ,
  updatedAt TIMESTAMPTZ
)
```

### Post_Project_Tbl (Completed Projects)
```sql
Post_Project_Tbl (
  postProjectID SERIAL PRIMARY KEY,
  preProjectID INTEGER REFERENCES Pre_Project_Tbl(preProjectID),
  breakdownID INTEGER REFERENCES BudgetBreakdown_Tbl(breakdownID),
  actualVolunteer INTEGER,
  timelineAdherence VARCHAR(30),   -- 'Completed_On_Time', 'Slightly_Delayed', etc.
  beneficiariesReached INTEGER,
  projectAchievement TEXT,
  createdAt TIMESTAMPTZ,
  updatedAt TIMESTAMPTZ
)
```

### Application_Tbl (Volunteer Applications)
```sql
Application_Tbl (
  applicationID SERIAL PRIMARY KEY,
  userID UUID REFERENCES User_Tbl(userID),
  preProjectID INTEGER REFERENCES Pre_Project_Tbl(preProjectID),
  preferredRole VARCHAR(100),
  parentConsentFile TEXT,
  applicationStatus VARCHAR(20),   -- 'PENDING', 'APPROVED', 'REJECTED'
  appliedDate TIMESTAMPTZ,
  createdAt TIMESTAMPTZ
)
```

### Inquiry_Tbl (Project Inquiries)
```sql
Inquiry_Tbl (
  inquiryID SERIAL PRIMARY KEY,
  preProjectID INTEGER REFERENCES Pre_Project_Tbl(preProjectID),
  userID UUID REFERENCES User_Tbl(userID),
  message TEXT,
  isReplied BOOLEAN,
  timeStamp TIMESTAMPTZ,
  createdAt TIMESTAMPTZ
)
```

### Reply_Tbl (Inquiry Replies)
```sql
Reply_Tbl (
  replyID SERIAL PRIMARY KEY,
  inquiryID INTEGER REFERENCES Inquiry_Tbl(inquiryID),
  userID UUID REFERENCES User_Tbl(userID),
  message TEXT,
  timeStamp TIMESTAMPTZ,
  createdAt TIMESTAMPTZ
)
```

### Notification_Tbl (User Notifications)
```sql
Notification_Tbl (
  notificationID SERIAL PRIMARY KEY,
  userID UUID REFERENCES User_Tbl(userID),
  notificationType VARCHAR(50),
  title VARCHAR(255),
  isRead BOOLEAN,
  createdAt TIMESTAMPTZ
)
```

### OTP_Tbl (One-Time Passwords)
```sql
OTP_Tbl (
  otpID SERIAL PRIMARY KEY,
  userID UUID REFERENCES User_Tbl(userID),
  otpCode VARCHAR(6),
  expiresAt TIMESTAMPTZ,
  isUsed BOOLEAN,
  purpose VARCHAR(20),             -- 'LOGIN', 'FORGOT_PASSWORD', 'SIGN_UP'
  createdAt TIMESTAMPTZ
)
```

### Certificate_Tbl (Volunteer Certificates)
```sql
Certificate_Tbl (
  certificateID SERIAL PRIMARY KEY,
  postProjectID INTEGER REFERENCES Post_Project_Tbl(postProjectID),
  applicationID INTEGER REFERENCES Application_Tbl(applicationID),
  userID UUID REFERENCES User_Tbl(userID),
  certificateFileURL TEXT,
  timeStamp TIMESTAMPTZ,
  createdAt TIMESTAMPTZ
)
```

### Evaluation_Tbl (Project Evaluations)
```sql
Evaluation_Tbl (
  evaluationID SERIAL PRIMARY KEY,
  postProjectID INTEGER REFERENCES Post_Project_Tbl(postProjectID),
  applicationID INTEGER REFERENCES Application_Tbl(applicationID),
  q1 INTEGER,                      -- Rating 1-5
  q2 INTEGER,                      -- Rating 1-5
  q3 INTEGER,                      -- Rating 1-5
  q4 INTEGER,                      -- Rating 1-5
  q5 INTEGER,                      -- Rating 1-5
  message TEXT,
  timeStamp TIMESTAMPTZ,
  hasCertificate BOOLEAN,
  createdAt TIMESTAMPTZ
)
```

### Testimonies_Tbl (User Testimonials)
```sql
Testimonies_Tbl (
  testimonyID SERIAL PRIMARY KEY,
  userID UUID REFERENCES User_Tbl(userID),
  message TEXT,
  isFiltered BOOLEAN,
  timeStamp TIMESTAMPTZ,
  createdAt TIMESTAMPTZ,
  rating INTEGER                   -- 1-5 stars
)
```

### BudgetBreakdown_Tbl (Budget Items)
```sql
BudgetBreakdown_Tbl (
  breakdownID SERIAL PRIMARY KEY,
  preProjectID INTEGER REFERENCES Pre_Project_Tbl(preProjectID),
  description VARCHAR(255),
  cost BIGINT,
  createdAt TIMESTAMPTZ
)
```

### Expenses_Tbl (Actual Expenses)
```sql
Expenses_Tbl (
  expenseID SERIAL PRIMARY KEY,
  breakdownID INTEGER REFERENCES BudgetBreakdown_Tbl(breakdownID),
  actualCost DECIMAL(15,2),
  receiptURL TEXT,
  createdAt TIMESTAMPTZ
)
```

### Annual_Budget_Tbl (Annual Budget Allocation)
```sql
Annual_Budget_Tbl (
  budgetID SERIAL PRIMARY KEY,
  expenseCategory VARCHAR(100),
  budget BIGINT,
  fiscalYear INTEGER,
  createdAt TIMESTAMPTZ
)
```

### Report_Tbl (Project Reports)
```sql
Report_Tbl (
  reportID SERIAL PRIMARY KEY,
  postProjectID INTEGER REFERENCES Post_Project_Tbl(postProjectID),
  applicationID INTEGER REFERENCES Application_Tbl(applicationID),
  evaluationID INTEGER REFERENCES Evaluation_Tbl(evaluationID),
  reportStatus VARCHAR(20),        -- 'DRAFT', 'SUBMITTED', 'APPROVED', 'REJECTED'
  requestedAt TIMESTAMPTZ,
  createdAt TIMESTAMPTZ,
  updatedAt TIMESTAMPTZ
)
```

### Logs_Tbl (Activity Logs)
```sql
Logs_Tbl (
  logID SERIAL PRIMARY KEY,
  userID UUID REFERENCES User_Tbl(userID),
  action VARCHAR(255),
  replyID INTEGER,
  postProjectID INTEGER,
  applicationID INTEGER,
  inquiryID INTEGER,
  notificationID INTEGER,
  fileID INTEGER,
  testimonyID INTEGER,
  timeStamp TIMESTAMPTZ,
  createdAt TIMESTAMPTZ
)
```

---

## Common Naming Patterns

### Table Names
- **Pattern**: `TableName_Tbl`
- **Case**: Title Case with underscore before `_Tbl`
- **Examples**: `User_Tbl`, `SK_Tbl`, `Announcement_Tbl`

### Column Names
- **Pattern**: `camelCase`
- **Primary Keys**: `tableName + ID` (e.g., `userID`, `announcementID`)
- **Foreign Keys**: Same as primary keys (e.g., `userID` references `User_Tbl.userID`)
- **Timestamps**: `createdAt`, `updatedAt`, `publishedDate`, `timeStamp`
- **Status Fields**: `accountStatus`, `fileStatus`, `applicationStatus`, `approvalStatus`
- **URLs**: `imagePathURL`, `certificateFileURL`, `receiptURL`

---

## JavaScript Query Examples

### SELECT Query
```javascript
const { data, error } = await supabaseClient
  .from('User_Tbl')
  .select('userID, firstName, lastName, email, role, accountStatus')
  .eq('userID', userId)
  .single();

// Access data
const userName = `${data.firstName} ${data.lastName}`;
const isActive = data.accountStatus === 'ACTIVE';
```

### INSERT Query
```javascript
const { data, error } = await supabaseClient
  .from('Announcement_Tbl')
  .insert({
    userID: currentUser.id,
    title: 'New Announcement',
    category: 'GENERAL',
    description: 'Description here',
    imagePathURL: null,
    publishedDate: new Date().toISOString()
  })
  .select();
```

### UPDATE Query
```javascript
const { data, error } = await supabaseClient
  .from('User_Tbl')
  .update({
    firstName: 'John',
    lastName: 'Doe',
    accountStatus: 'ACTIVE',
    updatedAt: new Date().toISOString()
  })
  .eq('userID', userId);
```

### JOIN Query
```javascript
const { data, error } = await supabaseClient
  .from('User_Tbl')
  .select(`
    userID,
    firstName,
    lastName,
    email,
    SK_Tbl (
      skID,
      position,
      termStart,
      termEnd
    )
  `)
  .eq('role', 'SK_OFFICIAL');
```

---

## Migration Notes

If you find snake_case in existing code, update to camelCase:

### Common Conversions
```
user_id       → userID
first_name    → firstName
last_name     → lastName
middle_name   → middleName
account_status → accountStatus
file_status   → fileStatus
published_date → publishedDate
image_path_url → imagePathURL
created_at    → createdAt
updated_at    → updatedAt
```

---

## File Updates Required

When updating existing code, search for these patterns and replace:

1. **Table Names**: Replace all `'tablename_tbl'` with `'TableName_Tbl'`
2. **Column Names**: Replace all `columnname` with `columnName` (camelCase)
3. **Dot Notation**: Update `data.column_name` to `data.columnName`

**Example**:
```javascript
// ❌ OLD (Wrong)
const { data } = await supabaseClient
  .from('user_tbl')
  .select('first_name, last_name')
  .eq('user_id', id);

// ✅ NEW (Correct)
const { data } = await supabaseClient
  .from('User_Tbl')
  .select('firstName, lastName')
  .eq('userID', id);
```

---

## Row Level Security (RLS) Policies

**Last Verified:** 2026-01-12 ✅ All 20 checks passed
**SQL Implementation:** `supabase/rls-policies.sql`
**Verification Script:** `supabase/verification/verify_rls_policies.sql`

All tables use **Row Level Security (RLS)** policies enforced at the database level. RLS provides role-based access control regardless of how the application is accessed.

### System Status

| Metric | Value | Status |
|--------|-------|--------|
| **Tables with RLS** | 20/20 (100%) | ✅ |
| **Total Policies** | 80 policies | ✅ |
| **Helper Functions** | 4 functions | ✅ |
| **Security Gaps** | 0 | ✅ |
| **Duplicate Policies** | 0 | ✅ |

---

### Helper Functions

These PostgreSQL functions check user roles in RLS policies:

```sql
is_sk_official()           -- Returns true if user is SK Official
is_captain()               -- Returns true if user is Barangay Captain
is_sk_official_or_captain() -- Returns true if user is SK Official OR Captain
is_superadmin()            -- Returns true if user is Superadmin
```

**Usage Example:**
```sql
-- Policy using helper function
CREATE POLICY "SK Officials can view all files"
ON "File_Tbl"
FOR SELECT
USING (is_sk_official());
```

---

### Role Permission Matrix

#### 🔵 PUBLIC (No Account)

| Feature | Access | Restriction |
|---------|--------|-------------|
| Announcements | ✅ View all | Read-only |
| Files | ✅ View active only | No archived |
| Projects | ✅ View approved only | No pending/rejected |
| Testimonies | ✅ View unfiltered only | No filtered content |
| User Profiles | ✅ View active only | No inactive users |
| Budget Data | ✅ View all | Read-only |

#### 🟢 YOUTH_VOLUNTEER (Authenticated User)

Inherits PUBLIC access, plus:

| Feature | Access | Restriction |
|---------|--------|-------------|
| Own Profile | ✅ View + Update | Cannot change role |
| Applications | ✅ Full CRUD (pending only) | Cannot modify approved/rejected |
| Inquiries | ✅ Create + View own | Cannot see others' |
| Replies | ✅ View replies to own inquiries | Cannot create replies |
| Testimonies | ✅ Submit | Cannot moderate |
| Evaluations | ✅ Submit own | Via application |
| Certificates | ✅ View own | Cannot create |
| Notifications | ✅ Full CRUD (own only) | Strict isolation |

#### 🟡 CAPTAIN (Governance)

Inherits PUBLIC access, plus:

| Feature | Access | Restriction |
|---------|--------|-------------|
| Files | ✅ View ALL (active + archived) | Cannot upload/delete |
| Projects | ✅ View ALL + Approve/Reject/Revise | Cannot create/delete |
| User Profiles | ✅ View all | Cannot modify |
| Logs | ✅ View all | Read-only |

**Key Restrictions:**
- ❌ NO CRUD on announcements
- ❌ NO CRUD on files (view only)
- ❌ NO CRUD on projects (approve only)
- ❌ NO access to testimony moderation
- ❌ NO access to applications/inquiries

#### 🔴 SK_OFFICIAL (Administrator)

Full system access:

| Feature | Access |
|---------|--------|
| Announcements | ✅ Full CRUD (ALL announcements) |
| Files | ✅ Full CRUD |
| Projects | ✅ Full CRUD (own projects) |
| Applications | ✅ View all + Update status |
| Inquiries | ✅ View all |
| Replies | ✅ Create + View all |
| Testimonies | ✅ View all + Filter/Moderate |
| Certificates | ✅ Create + View all |
| Evaluations | ✅ View all |
| Budget/Expenses | ✅ Full CRUD |
| Reports | ✅ Full CRUD |
| Logs | ✅ View all |
| User Profiles | ✅ View all |

#### 🟣 SUPERADMIN (System Management)

Focused on user management:

| Feature | Access |
|---------|--------|
| User Roles | ✅ Change any user's role (except own) |
| SK Assignments | ✅ Create/Delete SK Official positions |
| Captain Records | ✅ Manage Captain succession |
| Logs | ✅ View all system logs |
| User Profiles | ✅ View all |

---

### Policy Patterns

#### Ownership Check
Users access only their own data:
```sql
USING ("userID" = auth.uid())
WITH CHECK ("userID" = auth.uid())
```

#### Status-Based Access
Content visibility by status:
```sql
USING ("fileStatus" = 'ACTIVE')        -- Files
USING ("approvalStatus" = 'APPROVED')  -- Projects
USING ("isFiltered" = false)           -- Testimonies
USING ("accountStatus" = 'ACTIVE')     -- Users
```

#### Role-Based Access
Administrative functions:
```sql
USING (is_sk_official())               -- SK Officials only
USING (is_captain())                   -- Captain only
USING (is_sk_official_or_captain())    -- Either role
```

#### Relational Access
Access via related data:
```sql
-- Users can view replies to their inquiries
USING (
  EXISTS (
    SELECT 1 FROM "Inquiry_Tbl"
    WHERE "Inquiry_Tbl"."inquiryID" = "Reply_Tbl"."inquiryID"
    AND "Inquiry_Tbl"."userID" = auth.uid()
  )
)
```

---

### Table-Specific Policies

#### Announcement_Tbl (5 policies) - v2.1 Simplified ✅

| Policy | Operation | Logic |
|--------|-----------|-------|
| Public can view all announcements | SELECT | `true` |
| Authenticated users can view all announcements | SELECT | `true` |
| SK Officials can insert announcements | INSERT | `is_sk_official()` |
| SK Officials can update all announcements | UPDATE | `is_sk_official()` |
| SK Officials can delete all announcements | DELETE | `is_sk_official()` |

**v2.1 Changes:**
- Removed `contentStatus` column (no archive functionality)
- SK Officials can edit/delete ALL announcements (not just own)
- Public sees ALL announcements (no filtering)

#### User_Tbl (7 policies)

| Policy | Operation | Logic |
|--------|-----------|-------|
| Public can view active profiles | SELECT | `accountStatus = 'ACTIVE'` |
| Users can view own profile | SELECT | `userID = auth.uid()` |
| SK Officials can view all profiles | SELECT | `is_sk_official_or_captain()` |
| Superadmin can view all users | SELECT | `is_superadmin()` |
| Users can create profile | INSERT | `userID = auth.uid()` |
| Users can update own profile | UPDATE | `userID = auth.uid()` |
| Superadmin can change roles | UPDATE | `is_superadmin()` AND `userID != auth.uid()` |

**Security:** Superadmin cannot modify own role (prevents self-demotion)

#### File_Tbl (6 policies)

| Policy | Operation | Logic |
|--------|-----------|-------|
| Public can view active files | SELECT | `fileStatus = 'ACTIVE'` |
| Captain can view archived files | SELECT | `is_captain()` AND `fileStatus = 'ARCHIVED'` |
| SK Officials can view all files | SELECT | `is_sk_official()` |
| SK Officials can upload files | INSERT | `is_sk_official()` |
| SK Officials can update files | UPDATE | `is_sk_official()` |
| SK Officials can delete files | DELETE | `is_sk_official()` |

**Captain Access:** View only, no CRUD

#### Pre_Project_Tbl (8 policies)

| Policy | Operation | Logic |
|--------|-----------|-------|
| Public can view approved | SELECT | `approvalStatus = 'APPROVED'` |
| Users can view approved | SELECT | `approvalStatus = 'APPROVED'` |
| Captain can view all | SELECT | `is_captain()` |
| SK Officials can view all | SELECT | `is_sk_official()` |
| SK Officials can create | INSERT | `is_sk_official()` AND `userID = auth.uid()` |
| SK Officials can update own | UPDATE | `is_sk_official()` AND `userID = auth.uid()` |
| Captain can approve | UPDATE | `is_captain()` |
| SK Officials can delete own | DELETE | `is_sk_official()` AND `userID = auth.uid()` |

**Workflow:** Captain can VIEW all + APPROVE but not CREATE/DELETE

#### Application_Tbl (6 policies)

| Policy | Operation | Logic |
|--------|-----------|-------|
| Users can view own | SELECT | `userID = auth.uid()` |
| SK Officials can view all | SELECT | `is_sk_official()` |
| Users can submit | INSERT | `userID = auth.uid()` |
| Users can update pending | UPDATE | `userID = auth.uid()` AND `status = 'PENDING'` |
| SK Officials can update | UPDATE | `is_sk_official()` |
| Users can delete pending | DELETE | `userID = auth.uid()` AND `status = 'PENDING'` |

**Protection:** Users can only modify PENDING applications

#### Notification_Tbl (4 policies)

| Policy | Operation | Logic |
|--------|-----------|-------|
| Users can view own | SELECT | `userID = auth.uid()` |
| System can create | INSERT | `true` |
| Users can update own | UPDATE | `userID = auth.uid()` |
| Users can delete own | DELETE | `userID = auth.uid()` |

**Isolation:** Strict user-scoped access

#### OTP_Tbl (3 policies)

| Policy | Operation | Logic |
|--------|-----------|-------|
| Users can view own OTP | SELECT | `userID = auth.uid()` |
| System can create OTP | INSERT | `userID = auth.uid()` |
| System can update OTP | UPDATE | `userID = auth.uid()` |

**Security:** OTP codes strictly scoped to owning user

#### Testimonies_Tbl (4 policies)

| Policy | Operation | Logic |
|--------|-----------|-------|
| Public can view unfiltered | SELECT | `isFiltered = false` |
| SK Officials can view all | SELECT | `is_sk_official()` |
| Users can submit | INSERT | `userID = auth.uid()` |
| SK Officials can moderate | UPDATE | `is_sk_official()` |

**Moderation:** Public sees unfiltered only, SK Officials manage all

#### Budget Tables (Annual_Budget_Tbl, BudgetBreakdown_Tbl, Expenses_Tbl)

Each has 2 policies:
- **SELECT:** Public can view (`true`)
- **ALL:** SK Officials can manage (`is_sk_official()`)

**Transparency:** Budget data public, management restricted

---

### Verification Commands

#### Check RLS Status
```sql
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;
```

#### List All Policies
```sql
SELECT tablename, policyname, cmd, qual
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
```

#### View Helper Functions
```sql
SELECT routine_name, data_type
FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_name LIKE 'is_%';
```

#### Test Policy as User
```sql
-- In application code
SET LOCAL rls.user_id = 'user-uuid';
SELECT * FROM "Table_Tbl";
```

---

### Policy Count Summary

| Table | Policies | Operations |
|-------|----------|------------|
| Pre_Project_Tbl | 8 | SELECT (4), INSERT, UPDATE (2), DELETE |
| User_Tbl | 7 | SELECT (4), INSERT, UPDATE (2) |
| Application_Tbl | 6 | SELECT (2), INSERT, UPDATE (2), DELETE |
| File_Tbl | 6 | SELECT (3), INSERT, UPDATE, DELETE |
| Announcement_Tbl | 5 | SELECT (2), INSERT, UPDATE, DELETE |
| SK_Tbl | 5 | SELECT (2), INSERT, DELETE, ALL |
| Logs_Tbl | 4 | SELECT (2), INSERT (2) |
| Notification_Tbl | 4 | SELECT, INSERT, UPDATE, DELETE |
| Testimonies_Tbl | 4 | SELECT (2), INSERT, UPDATE |
| Certificate_Tbl | 3 | SELECT (2), INSERT |
| Evaluation_Tbl | 3 | SELECT (2), INSERT |
| Inquiry_Tbl | 3 | SELECT (2), INSERT |
| OTP_Tbl | 3 | SELECT, INSERT, UPDATE |
| Reply_Tbl | 3 | SELECT (2), INSERT |
| Annual_Budget_Tbl | 2 | SELECT, ALL |
| BudgetBreakdown_Tbl | 2 | SELECT, ALL |
| Captain_Tbl | 2 | SELECT, ALL |
| Expenses_Tbl | 2 | SELECT, ALL |
| Post_Project_Tbl | 2 | SELECT, ALL |
| Report_Tbl | 2 | SELECT, ALL |

**Total:** 80 policies across 20 tables

---

### Key Security Features

1. **Data Isolation** ✅
   - Users access only their own notifications, OTPs, applications
   - No cross-user data leakage

2. **Role Hierarchy** ✅
   - Public < Youth Volunteer < Captain < SK Official < Superadmin
   - Appropriate access escalation

3. **Captain Restrictions** ✅
   - View-only for announcements and files
   - Approval-only for projects
   - No content CRUD

4. **SK Official Privileges** ✅
   - Edit/delete ALL announcements
   - Delete only own projects
   - Full management of applications/inquiries

5. **Content Filtering** ✅
   - Public: active files, approved projects, unfiltered testimonies
   - Captain: all files, all projects (for approval)
   - SK Officials: everything

6. **Workflow Protection** ✅
   - Users modify only PENDING applications
   - Once approved/rejected, SK Officials control

7. **Financial Transparency** ✅
   - Budget data publicly viewable
   - Management SK Officials only

8. **Audit Trail** ✅
   - All actions logged
   - SK Officials and Captain can view logs

---

### Related Files

- **RLS SQL Implementation:** `supabase/rls-policies.sql`
- **Verification Script:** `supabase/verification/verify_rls_policies.sql`
- **Complete Verification Report:** `RLS_POLICIES_FINAL_VERIFICATION_2026-01-12.md`

---

**Document Version**: 3.0
**Last Updated**: 2026-01-12
**Status**: Official Reference ✅ (Post-RLS Consolidation)
