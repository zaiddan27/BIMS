# RLS Policies Reference Guide

**Updated:** 2026-01-11
**Version:** 2.0 (Post-Migration)

---

## Overview

Row Level Security (RLS) policies enforce role-based access control at the **database level**. All tables use RLS to ensure data security regardless of how the application is accessed.

---

## Helper Functions

These functions check user roles and are used in RLS policies:

```sql
is_sk_official()           -- Returns true if user is SK Official
is_captain()               -- Returns true if user is Captain
is_sk_official_or_captain() -- Returns true if user is SK Official OR Captain
is_superadmin()            -- Returns true if user is Superadmin
```

---

## Role Permissions Matrix

### Captain (Governance/Oversight)

| Feature | Permissions | Policy Logic |
|---------|------------|--------------|
| Announcements | View all | Public SELECT policy |
| Files | View all (active + archived) | `is_captain()` |
| Projects | View all + Approve/Reject/Revise | `is_captain()` for SELECT and UPDATE |
| Applications | None | No policies |
| Inquiries | None | No policies |
| Testimonies | View unfiltered only | Uses public policy |
| Certificates | None | No policies |
| Logs | View all | `is_sk_official_or_captain()` |

**Key Restrictions:**
- ❌ NO CRUD on announcements
- ❌ NO CRUD on files
- ❌ NO CRUD on projects (can only approve/reject/revise)
- ❌ NO access to testimony moderation
- ❌ NO access to applications/inquiries

---

### SK Officials (Administrators)

| Feature | Permissions | Policy Logic |
|---------|------------|--------------|
| Announcements | Full CRUD on ALL announcements | `is_sk_official()` |
| Files | Full CRUD | `is_sk_official()` |
| Projects | Full CRUD | `is_sk_official()` + own records |
| Applications | View all + Update | `is_sk_official()` |
| Inquiries | View all | `is_sk_official()` |
| Replies | Create + View all | `is_sk_official()` |
| Testimonies | View all + Filter/Moderate | `is_sk_official()` |
| Certificates | Create + View all | `is_sk_official()` |
| Evaluations | View all | `is_sk_official()` |
| Budget/Expenses | Full CRUD | `is_sk_official()` |
| Reports | Full CRUD | `is_sk_official()` |
| Logs | View all | `is_sk_official_or_captain()` |

---

### Youth Volunteers (Users)

| Feature | Permissions | Policy Logic |
|---------|------------|--------------|
| Announcements | View all | Public SELECT policy |
| Files | View active only | `fileStatus = 'ACTIVE'` |
| Projects | View approved only | `approvalStatus = 'APPROVED'` |
| Applications | Own CRUD (pending only) | `userID = auth.uid()` |
| Inquiries | Own CRUD | `userID = auth.uid()` |
| Replies | View own | Via inquiry ownership |
| Testimonies | Submit | `userID = auth.uid()` |
| Certificates | View own | `userID = auth.uid()` |
| Evaluations | Submit own | Via application ownership |
| Notifications | Own CRUD | `userID = auth.uid()` |
| User Profile | View own + Update | `userID = auth.uid()` |

**Key Restrictions:**
- ❌ NO access to pending/rejected projects
- ❌ NO access to other users' data
- ❌ Cannot update approved/rejected applications

---

### Public (No Account)

| Feature | Permissions | Policy Logic |
|---------|------------|--------------|
| Announcements | View all | `true` (no restrictions) |
| Files | View active only | `fileStatus = 'ACTIVE'` |
| Projects | View approved only | `approvalStatus = 'APPROVED'` |
| Testimonies | View unfiltered only | `isFiltered = false` |
| User Profiles | View active only | `accountStatus = 'ACTIVE'` |
| Budget Breakdown | View approved projects only | Via project approval status |
| Annual Budget | View all | `true` |
| Completed Projects | View all | `true` |

**Key Restrictions:**
- ❌ NO write access to any table
- ❌ Cannot view archived/pending content

---

## Common Policy Patterns

### Ownership Check
Used for users to access only their own data:
```sql
USING ("userID" = auth.uid())
WITH CHECK ("userID" = auth.uid())
```

### Status-Based Access
Used for content visibility:
```sql
USING ("fileStatus" = 'ACTIVE')     -- Files
USING ("approvalStatus" = 'APPROVED') -- Projects
USING ("isFiltered" = false)         -- Testimonies
USING ("accountStatus" = 'ACTIVE')  -- User accounts
```

### Role-Based Access
Used for administrative functions:
```sql
USING (is_sk_official())           -- SK Officials only
USING (is_captain())               -- Captain only
USING (is_sk_official_or_captain()) -- Either role
```

### Relational Access
Used for accessing related data:
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

## Policy Operations

### SELECT (Read)
Controls who can view records:
```sql
CREATE POLICY "policy_name"
ON "Table_Tbl"
FOR SELECT
USING (condition);
```

### INSERT (Create)
Controls who can create records:
```sql
CREATE POLICY "policy_name"
ON "Table_Tbl"
FOR INSERT
WITH CHECK (condition);
```

### UPDATE (Modify)
Controls who can modify records:
```sql
CREATE POLICY "policy_name"
ON "Table_Tbl"
FOR UPDATE
USING (condition_to_find_records)
WITH CHECK (condition_to_validate_changes);
```

### DELETE (Remove)
Controls who can delete records:
```sql
CREATE POLICY "policy_name"
ON "Table_Tbl"
FOR DELETE
USING (condition);
```

### ALL (Full CRUD)
Combines all operations:
```sql
CREATE POLICY "policy_name"
ON "Table_Tbl"
FOR ALL
USING (condition)
WITH CHECK (condition);
```

---

## Key Security Rules

### 1. Captain Restrictions
- **View Only** for announcements and files
- **Approval Only** for projects (cannot create/delete)
- **NO access** to testimony moderation
- **NO access** to applications/inquiries

### 2. SK Official Access
- Can create/edit/delete **ALL** announcements (regardless of who posted them)
- Can only edit/delete their **own** projects
- Can view/manage all applications and inquiries

### 3. User Data Isolation
- Users can only access their **own** data
- Cannot view other users' applications, inquiries, evaluations
- Can only modify **pending** applications (not approved/rejected)

### 4. Public Access
- **Read-only** access to active/approved/public content
- Cannot see archived, pending, or filtered content
- No authentication required

### 5. System Operations
- Notifications can be created by system (`WITH CHECK (true)`)
- OTP codes tied to user authentication
- Logs automatically associated with authenticated user

---

## Maintenance Commands

### Check All Policies
```sql
SELECT
    tablename,
    policyname,
    cmd,
    qual as using_expression
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
```

### Drop All Policies on a Table
```sql
DROP POLICY IF EXISTS "policy_name" ON "Table_Tbl";
```

### Disable RLS (Not Recommended)
```sql
ALTER TABLE "Table_Tbl" DISABLE ROW LEVEL SECURITY;
```

### Enable RLS
```sql
ALTER TABLE "Table_Tbl" ENABLE ROW LEVEL SECURITY;
```

---

## Testing RLS Policies

### Test as Different Users
```sql
-- Set current user context (in Supabase SQL Editor)
SELECT auth.uid(); -- Returns current authenticated user ID

-- Test policy behavior
SELECT * FROM "Table_Tbl"; -- Should respect RLS policies
```

### Verify Policy Application
```sql
-- Check if RLS is enabled on a table
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public';
```

### Debug Policy Issues
```sql
-- View policy definitions
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE tablename = 'Table_Tbl';
```

---

## File Location

**Full RLS Policy SQL:**
`supabase/rls-policies.sql`

**Apply All Policies:**
Run the SQL file in Supabase SQL Editor to apply all policies at once.

---

## Version History

- **v2.1** (2026-01-12): Announcement policy simplification
  - **REMOVED** `contentStatus` column from Announcement_Tbl
  - **REMOVED** archive functionality (hard delete instead of soft delete)
  - **UPDATED** SK Officials can now edit/delete ALL announcements (not just their own)
  - **UPDATED** Public and authenticated users can view ALL announcements
  - **REMOVED** 4 duplicate/conflicting announcement policies
  - **KEPT** 5 clean policies: 2 SELECT, 1 INSERT, 1 UPDATE, 1 DELETE

- **v2.0** (2026-01-11): Post-migration update
  - Updated all table names to Title Case
  - Updated all column names to camelCase
  - Fixed Captain permissions (removed CRUD on files/testimonies)
  - Fixed SK Official-only policies (removed Captain from inappropriate policies)

- **v1.0** (2025-12-01): Initial RLS setup
  - Original policies with lowercase table/column names

---

**Last Updated:** 2026-01-12
**Status:** ✅ Active and Enforced
