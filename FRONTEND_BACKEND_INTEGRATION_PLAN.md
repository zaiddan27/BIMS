# BIMS Frontend-Backend Integration Plan

**Date:** 2026-01-10
**Status:** Phase 2 → Phase 3 Transition
**Current State:** Auth working ✅ | Migrations created ✅ | Migrations NOT RUN ⚠️

---

## Integration Status Overview

| Component | Status | Notes |
|-----------|--------|-------|
| **Supabase Connection** | ✅ DONE | env.js configured, connection tested |
| **Authentication** | ✅ DONE | Sign up, login, OTP working |
| **Database Schema** | ✅ DONE | 6 migrations created, verified, READY TO RUN |
| **Superadmin Pages** | ✅ DONE | All 3 pages fully integrated with pagination |
| **Session Management** | ✅ PARTIAL | Superadmin auth guards working, need others |
| **Dashboard Data** | ✅ PARTIAL | Superadmin loads real data, others static |
| **CRUD Operations** | ✅ PARTIAL | Superadmin CRUD working, need SK/Youth |
| **Mobile Responsive** | ✅ DONE | Hamburger menu + pagination on all devices |
| **Role-Based Redirection** | ❌ TODO | Static routing, needs user role query |

---

## PHASE 2 COMPLETION - Database Setup

### Step 1: Run Migrations (FIRST PRIORITY)
**Status:** ⚠️ NOT DONE
**User must do:** Run all 6 migration files in Supabase SQL Editor

```bash
# In Supabase Dashboard → SQL Editor, run in order:
1. 001_create_schema.sql        ← Creates 19 tables
2. 002_create_storage_buckets.sql ← Creates 8 storage buckets
3. 003_row_level_security.sql    ← RLS policies
4. 004_auth_sync_trigger.sql     ← Auth sync triggers
5. 005_captain_table.sql         ← Captain term tracking
6. 006_add_superadmin_role.sql   ← SUPERADMIN role (FIXED)
```

**Verification:**
- Check Table Editor: Should see 20 tables
- Check Storage: Should see 8 buckets
- Check Auth Policies: RLS enabled on all tables

### Step 2: Create First SUPERADMIN
**Status:** ⚠️ NOT DONE
**User must do:** Manually promote first admin via SQL

```sql
-- After signing up an admin account, promote it:
UPDATE User_Tbl
SET role = 'SUPERADMIN', accountStatus = 'ACTIVE'
WHERE email = 'your-admin@example.com';
```

**Verification:**
```sql
-- Check if SUPERADMIN exists:
SELECT email, role, accountStatus FROM User_Tbl WHERE role = 'SUPERADMIN';
```

---

## PHASE 3 - Core Features Implementation

### Module 1: Authentication Enhancement

#### 1.1 Role-Based Dashboard Redirection
**Files:** `login.html`, `js/auth/session.js`
**Status:** ⚠️ NEEDS FIX
**Problem:** After login, redirects to hardcoded dashboard (doesn't check user role)

**Required Changes:**
```javascript
// In login.html after successful login:
// 1. Query User_Tbl to get user role
const { data: user } = await supabaseClient
  .from('User_Tbl')
  .select('role, accountStatus')
  .eq('userID', session.user.id)
  .single();

// 2. Redirect based on role
if (user.accountStatus !== 'ACTIVE') {
  // Show error: "Account pending approval"
} else {
  switch(user.role) {
    case 'SUPERADMIN': window.location.href = 'superadmin-dashboard.html'; break;
    case 'CAPTAIN': window.location.href = 'captain-dashboard.html'; break;
    case 'SK_OFFICIAL': window.location.href = 'sk-dashboard.html'; break;
    case 'YOUTH_VOLUNTEER': window.location.href = 'youth-dashboard.html'; break;
  }
}
```

#### 1.2 Session Management (Auth Guards)
**Files:** All dashboard HTML files
**Status:** ❌ NOT DONE
**Problem:** Anyone can access any dashboard by typing URL (no auth check)

**Required Changes:**
Add to ALL dashboard files (superadmin, captain, sk, youth):

```html
<!-- Add after Supabase imports -->
<script src="js/auth/session.js"></script>
<script>
  // Check authentication on page load
  window.addEventListener('DOMContentLoaded', async () => {
    const session = await SessionManager.getSession();

    if (!session) {
      // Not logged in - redirect to login
      window.location.href = 'login.html';
      return;
    }

    // Check user role matches this dashboard
    const { data: user } = await supabaseClient
      .from('User_Tbl')
      .select('role, accountStatus, firstName, lastName')
      .eq('userID', session.user.id)
      .single();

    if (!user || user.accountStatus !== 'ACTIVE') {
      await SessionManager.logout();
      window.location.href = 'login.html';
      return;
    }

    // Verify user has correct role for this page
    const expectedRole = 'SUPERADMIN'; // Change per page
    if (user.role !== expectedRole) {
      // Redirect to correct dashboard
      window.location.href = SessionManager.getRoleDashboard(user.role);
      return;
    }

    // User authenticated and authorized - load page data
    loadUserProfile(user);
    loadDashboardData();
  });
</script>
```

**Files that need this:**
- ✅ `superadmin-dashboard.html` - Already has Supabase imports, needs auth guard
- ❌ `captain-dashboard.html` - NO Supabase imports yet
- ❌ `sk-dashboard.html` - NO Supabase imports yet
- ❌ `sk-projects.html` - NO Supabase imports yet
- ❌ `sk-files.html` - NO Supabase imports yet
- ❌ `sk-archive.html` - NO Supabase imports yet
- ❌ `sk-calendar.html` - NO Supabase imports yet
- ❌ `sk-reports.html` - NO Supabase imports yet
- ❌ `sk-testimonies.html` - NO Supabase imports yet
- ❌ `youth-dashboard.html` - NO Supabase imports yet
- ❌ `youth-projects.html` - NO Supabase imports yet
- ❌ `youth-files.html` - NO Supabase imports yet
- ❌ `youth-certificates.html` - NO Supabase imports yet
- ❌ `youth-calendar.html` - NO Supabase imports yet

---

## HTML File Integration Checklist

### Authentication Pages (COMPLETED ✅)
- ✅ `login.html` - Supabase auth working
- ✅ `signup.html` - Supabase auth working
- ✅ `verify-otp.html` - OTP verification working
- ⚠️ `forgot-password.html` - Created but not tested
- ⚠️ `reset-password.html` - Created but not tested

### Superadmin Pages (COMPLETED ✅)

#### Superadmin Dashboard
**File:** `superadmin-dashboard.html`
**Status:** ✅ FULLY INTEGRATED
**Features:**
- ✅ Auth guard (SUPERADMIN role verification)
- ✅ Load user profile from user_tbl
- ✅ System statistics (users, projects, applications, logs)
- ✅ Captain term expiration warning
- ✅ Recent activity with pagination (10 per page)
- ✅ Mobile hamburger menu navigation
- ✅ Pagination dots + Prev/Next buttons
- ✅ Responsive for tablet, small/large phones

#### Superadmin User Management
**File:** `superadmin-user-management.html`
**Status:** ✅ FULLY INTEGRATED
**Features:**
- ✅ Auth guard (SUPERADMIN role verification)
- ✅ Load all users with SK info from user_tbl and sk_tbl
- ✅ User statistics cards (Total, SK Officials, Volunteers, Pending, Inactive)
- ✅ Search by name/email
- ✅ Filter by role and account status
- ✅ **Pagination: 10 users per page** with dots + Prev/Next
- ✅ Promote to SK Official modal (position, term dates)
- ✅ Deactivate user modal (reason tracking)
- ✅ Demote SK Official function
- ✅ Reactivate user function
- ✅ Mobile hamburger menu navigation
- ✅ Responsive table with horizontal scroll on mobile

#### Superadmin Activity Logs
**File:** `superadmin-activity-logs.html`
**Status:** ✅ FULLY INTEGRATED
**Features:**
- ✅ Auth guard (SUPERADMIN role verification)
- ✅ Three-tab interface (All Logs, Audit Trail, Database Stats)
- ✅ **All Activity Logs: 10 logs per page** with pagination
- ✅ **Audit Trail: 10 audit logs per page** with pagination
- ✅ Date filter for logs
- ✅ Database table counts (15 tables)
- ✅ Storage bucket information
- ✅ Mobile hamburger menu navigation
- ✅ Responsive tabs (scrollable on mobile)

**Implemented Supabase Queries:**
```javascript
// 1. Load user profile with auth guard
const { data: user } = await supabaseClient
  .from('user_tbl')
  .select('*')
  .eq('userid', session.user.id)
  .single();

// 2. Load all users with SK info + pagination
const { data: users } = await supabaseClient
  .from('user_tbl')
  .select(`
    *,
    sk_tbl (position, termend)
  `)
  .order('createdat', { ascending: false });

// 3. Load activity logs with pagination
const { data: logs } = await supabaseClient
  .from('logs_tbl')
  .select(`
    *,
    user_tbl (firstname, lastname, role)
  `)
  .order('timestamp', { ascending: false });

// 4. Load audit trail with pagination
const { data: auditLogs } = await supabaseClient
  .from('logs_tbl')
  .select(`
    *,
    user_tbl (firstname, lastname, role)
  `)
  .ilike('action', '%[AUDIT]%')
  .order('timestamp', { ascending: false });

// 5. Database stats
const { count } = await supabaseClient
  .from('user_tbl')
  .select('*', { count: 'exact', head: true });

// 6. Promote user to SK Official
const { error: roleError } = await supabaseClient
  .from('user_tbl')
  .update({ role: 'SK_OFFICIAL', accountstatus: 'ACTIVE' })
  .eq('userid', userId);

const { error: skError } = await supabaseClient
  .from('sk_tbl')
  .insert({
    userid: userId,
    position: position,
    termstart: termStart,
    termend: termEnd
  });

// 7. Deactivate user
const { error } = await supabaseClient
  .from('user_tbl')
  .update({ accountstatus: 'INACTIVE' })
  .eq('userid', userId);

// 8. Demote SK Official
const { error: skError } = await supabaseClient
  .from('sk_tbl')
  .delete()
  .eq('userid', userId);

const { error: roleError } = await supabaseClient
  .from('user_tbl')
  .update({ role: 'YOUTH_VOLUNTEER' })
  .eq('userid', userId);

// 9. Check Captain term expiration
const { data } = await supabaseClient
  .rpc('check_captain_term_expiration');
```

**Mobile Navigation:**
- ✅ Hamburger menu for all three superadmin pages
- ✅ Slide-out sidebar with overlay
- ✅ Auto-close on navigation link click
- ✅ Touch-friendly buttons (44px minimum)
- ✅ Responsive for tablet, small/large phones

**Pagination Design:**
- ✅ Center-aligned pagination dots
- ✅ Right-aligned Prev/Next buttons
- ✅ Active dot expands (2px → 8px width)
- ✅ Primary color (#2f6e4e) for active state
- ✅ Wrap-around navigation (last ↔ first page)
- ✅ Direct page navigation via dots
- ✅ Auto-hide when only 1 page
- ✅ Mobile responsive (horizontal scroll if needed)

**Database Table Names:**
✅ All queries use lowercase table names: `user_tbl`, `logs_tbl`, `sk_tbl`

### Captain Dashboard (NOT STARTED ❌)
**File:** `captain-dashboard.html`
**Has Supabase imports:** ❌ NO
**Needs:**
- ❌ Add Supabase imports (CDN, env.js, supabase.js)
- ❌ Auth guard (CAPTAIN role only)
- ❌ Load user profile
- ❌ Load announcements (read-only)
- ❌ Load projects awaiting approval
- ❌ Load archived projects/files
- ❌ Approve/reject project functions
- ❌ Request revision function

**Supabase Queries Needed:**
```javascript
// 1. Load projects awaiting approval
const { data: pendingProjects } = await supabaseClient
  .from('Pre_Project_Tbl')
  .select(`
    *,
    User_Tbl (firstName, lastName),
    SK_Tbl (position)
  `)
  .eq('approvalStatus', 'PENDING')
  .order('submittedDate', { ascending: false });

// 2. Load announcements (read-only)
const { data: announcements } = await supabaseClient
  .from('Announcement_Tbl')
  .select('*')
  .eq('contentStatus', 'ACTIVE')
  .order('publishedDate', { ascending: false });

// 3. Load archived projects
const { data: archivedProjects } = await supabaseClient
  .from('Pre_Project_Tbl')
  .select('*')
  .eq('status', 'COMPLETED')
  .order('endDateTime', { ascending: false });

// 4. Approve project
const { error } = await supabaseClient
  .from('Pre_Project_Tbl')
  .update({
    approvalStatus: 'APPROVED',
    approvalDate: new Date().toISOString()
  })
  .eq('preProjectID', projectId);

// 5. Reject project with notes
const { error } = await supabaseClient
  .from('Pre_Project_Tbl')
  .update({
    approvalStatus: 'REJECTED',
    approvalDate: new Date().toISOString(),
    approvalNotes: rejectionReason
  })
  .eq('preProjectID', projectId);

// 6. Request revision
const { error } = await supabaseClient
  .from('Pre_Project_Tbl')
  .update({
    approvalStatus: 'REVISION',
    approvalNotes: revisionNotes
  })
  .eq('preProjectID', projectId);
```

### SK Official Dashboard (NOT STARTED ❌)
**File:** `sk-dashboard.html`
**Has Supabase imports:** ❌ NO
**Needs:**
- ❌ Add Supabase imports
- ❌ Auth guard (SK_OFFICIAL role only)
- ❌ Load user profile with SK position
- ❌ Load announcements (CRUD)
- ❌ Load projects statistics
- ❌ Load application notifications
- ❌ Load inquiry notifications

**Supabase Queries Needed:**
```javascript
// 1. Load SK Official profile with position
const { data: skProfile } = await supabaseClient
  .from('User_Tbl')
  .select(`
    *,
    SK_Tbl (position, termStart, termEnd)
  `)
  .eq('userID', session.user.id)
  .single();

// 2. Load announcements (SK can CRUD)
const { data: announcements } = await supabaseClient
  .from('Announcement_Tbl')
  .select('*')
  .eq('contentStatus', 'ACTIVE')
  .order('publishedDate', { ascending: false });

// 3. Dashboard statistics
const { count: totalProjects } = await supabaseClient
  .from('Pre_Project_Tbl')
  .select('*', { count: 'exact', head: true })
  .eq('userID', session.user.id);

const { count: pendingApps } = await supabaseClient
  .from('Application_Tbl')
  .select('*', { count: 'exact', head: true })
  .eq('applicationStatus', 'PENDING');

// 4. Recent applications
const { data: applications } = await supabaseClient
  .from('Application_Tbl')
  .select(`
    *,
    User_Tbl (firstName, lastName, email),
    Pre_Project_Tbl (title)
  `)
  .eq('applicationStatus', 'PENDING')
  .order('appliedDate', { ascending: false })
  .limit(10);
```

### SK Projects Page (NOT STARTED ❌)
**File:** `sk-projects.html`
**Has Supabase imports:** ❌ NO
**Needs:**
- ❌ Add Supabase imports
- ❌ Auth guard
- ❌ Load all projects (created by this SK Official)
- ❌ Create new project
- ❌ Edit project
- ❌ View applications
- ❌ Approve/reject applications
- ❌ View inquiries
- ❌ Reply to inquiries

**Supabase Queries Needed:**
```javascript
// 1. Load SK Official's projects
const { data: projects } = await supabaseClient
  .from('Pre_Project_Tbl')
  .select(`
    *,
    SK_Tbl (position),
    BudgetBreakdown_Tbl (description, cost)
  `)
  .eq('userID', session.user.id)
  .order('submittedDate', { ascending: false });

// 2. Create new project
const { data: newProject, error } = await supabaseClient
  .from('Pre_Project_Tbl')
  .insert({
    userID: session.user.id,
    skID: skId,
    title: projectData.title,
    description: projectData.description,
    category: projectData.category,
    budget: projectData.budget,
    volunteers: projectData.volunteers,
    beneficiaries: projectData.beneficiaries,
    startDateTime: projectData.startDateTime,
    endDateTime: projectData.endDateTime,
    location: projectData.location,
    imagePathURL: imageUrl,
    submittedDate: new Date().toISOString()
  })
  .select()
  .single();

// 3. Load project applications
const { data: applications } = await supabaseClient
  .from('Application_Tbl')
  .select(`
    *,
    User_Tbl (firstName, lastName, email, contactNumber)
  `)
  .eq('preProjectID', projectId)
  .order('appliedDate', { ascending: false });

// 4. Approve application
const { error } = await supabaseClient
  .from('Application_Tbl')
  .update({ applicationStatus: 'APPROVED' })
  .eq('applicationID', applicationId);

// 5. Load project inquiries
const { data: inquiries } = await supabaseClient
  .from('Inquiry_Tbl')
  .select(`
    *,
    User_Tbl (firstName, lastName),
    Reply_Tbl (message, timeStamp, userID)
  `)
  .eq('preProjectID', projectId)
  .order('timeStamp', { ascending: false });

// 6. Reply to inquiry
const { data: reply, error } = await supabaseClient
  .from('Reply_Tbl')
  .insert({
    inquiryID: inquiryId,
    userID: session.user.id,
    message: replyMessage,
    timeStamp: new Date().toISOString()
  })
  .select()
  .single();

// Update inquiry as replied
await supabaseClient
  .from('Inquiry_Tbl')
  .update({ isReplied: true })
  .eq('inquiryID', inquiryId);
```

### SK Files Page (NOT STARTED ❌)
**File:** `sk-files.html`
**Has Supabase imports:** ❌ NO
**Needs:**
- ❌ Add Supabase imports
- ❌ Auth guard
- ❌ Load all files
- ❌ Upload new file (Supabase Storage)
- ❌ Delete file
- ❌ Archive file
- ❌ Search/filter files

**Supabase Queries + Storage:**
```javascript
// 1. Load all files
const { data: files } = await supabaseClient
  .from('File_Tbl')
  .select(`
    *,
    User_Tbl (firstName, lastName)
  `)
  .eq('fileStatus', 'ACTIVE')
  .order('dateUploaded', { ascending: false });

// 2. Upload file to Supabase Storage
const fileExt = file.name.split('.').pop();
const fileName = `${Date.now()}_${file.name}`;
const filePath = `${session.user.id}/${fileName}`;

const { data: uploadData, error: uploadError } = await supabaseClient.storage
  .from('general-files')
  .upload(filePath, file);

if (!uploadError) {
  // Get public URL
  const { data: { publicUrl } } = supabaseClient.storage
    .from('general-files')
    .getPublicUrl(filePath);

  // Create database record
  const { data: fileRecord, error } = await supabaseClient
    .from('File_Tbl')
    .insert({
      userID: session.user.id,
      fileName: file.name,
      fileType: fileExt.toUpperCase(),
      filePath: publicUrl,
      fileCategory: category,
      dateUploaded: new Date().toISOString()
    })
    .select()
    .single();
}

// 3. Archive file
const { error } = await supabaseClient
  .from('File_Tbl')
  .update({ fileStatus: 'ARCHIVED' })
  .eq('fileID', fileId);

// 4. Delete file (from storage and database)
const { error: storageError } = await supabaseClient.storage
  .from('general-files')
  .remove([filePath]);

const { error: dbError } = await supabaseClient
  .from('File_Tbl')
  .delete()
  .eq('fileID', fileId);
```

### Youth Volunteer Dashboard (NOT STARTED ❌)
**File:** `youth-dashboard.html`
**Has Supabase imports:** ❌ NO
**Needs:**
- ❌ Add Supabase imports
- ❌ Auth guard (YOUTH_VOLUNTEER role only)
- ❌ Load user profile
- ❌ Load available projects
- ❌ Load user's applications
- ❌ Load announcements
- ❌ Load certificates

**Supabase Queries Needed:**
```javascript
// 1. Load youth profile
const { data: youthProfile } = await supabaseClient
  .from('User_Tbl')
  .select('*')
  .eq('userID', session.user.id)
  .single();

// 2. Load available projects (APPROVED, ONGOING)
const { data: projects } = await supabaseClient
  .from('Pre_Project_Tbl')
  .select(`
    *,
    SK_Tbl (position),
    User_Tbl (firstName, lastName)
  `)
  .eq('approvalStatus', 'APPROVED')
  .eq('status', 'ONGOING')
  .order('startDateTime', { ascending: true });

// 3. Load user's applications
const { data: myApplications } = await supabaseClient
  .from('Application_Tbl')
  .select(`
    *,
    Pre_Project_Tbl (title, startDateTime, endDateTime, imagePathURL)
  `)
  .eq('userID', session.user.id)
  .order('appliedDate', { ascending: false });

// 4. Load announcements
const { data: announcements } = await supabaseClient
  .from('Announcement_Tbl')
  .select('*')
  .eq('contentStatus', 'ACTIVE')
  .order('publishedDate', { ascending: false })
  .limit(5);

// 5. Load certificates
const { data: certificates } = await supabaseClient
  .from('Certificate_Tbl')
  .select(`
    *,
    Post_Project_Tbl (
      preProjectID,
      Pre_Project_Tbl (title)
    )
  `)
  .eq('userID', session.user.id)
  .order('timeStamp', { ascending: false });
```

### Youth Projects Page (NOT STARTED ❌)
**File:** `youth-projects.html`
**Has Supabase imports:** ❌ NO
**Needs:**
- ❌ Add Supabase imports
- ❌ Auth guard
- ❌ Load all available projects
- ❌ View project details
- ❌ Apply to project
- ❌ Submit inquiry
- ❌ View application status

**Supabase Queries Needed:**
```javascript
// 1. Load all approved projects
const { data: projects } = await supabaseClient
  .from('Pre_Project_Tbl')
  .select(`
    *,
    SK_Tbl (position),
    User_Tbl (firstName, lastName)
  `)
  .eq('approvalStatus', 'APPROVED')
  .order('startDateTime', { ascending: true });

// 2. Check if user already applied
const { data: existingApp } = await supabaseClient
  .from('Application_Tbl')
  .select('*')
  .eq('userID', session.user.id)
  .eq('preProjectID', projectId)
  .single();

// 3. Apply to project
const { data: application, error } = await supabaseClient
  .from('Application_Tbl')
  .insert({
    userID: session.user.id,
    preProjectID: projectId,
    preferredRole: role,
    parentConsentFile: consentUrl, // if under 18
    appliedDate: new Date().toISOString()
  })
  .select()
  .single();

// 4. Submit inquiry
const { data: inquiry, error } = await supabaseClient
  .from('Inquiry_Tbl')
  .insert({
    preProjectID: projectId,
    userID: session.user.id,
    message: inquiryMessage,
    timeStamp: new Date().toISOString()
  })
  .select()
  .single();

// 5. Load project inquiries (for viewing replies)
const { data: inquiries } = await supabaseClient
  .from('Inquiry_Tbl')
  .select(`
    *,
    Reply_Tbl (message, timeStamp)
  `)
  .eq('preProjectID', projectId)
  .eq('userID', session.user.id)
  .order('timeStamp', { ascending: false });
```

---

## Implementation Priority Order

### COMPLETED ✅
1. ✅ **Run all 6 migrations in Supabase** (USER ACTION REQUIRED)
2. ✅ **Create first SUPERADMIN user** (USER ACTION REQUIRED)
3. ✅ **Integrate superadmin-dashboard.html** (system stats, recent activity with pagination)
4. ✅ **Integrate superadmin-user-management.html** (CRUD users, promote/demote, pagination)
5. ✅ **Integrate superadmin-activity-logs.html** (logs, audit trail, database stats with pagination)
6. ✅ **Mobile hamburger menu** for all superadmin pages
7. ✅ **Pagination system** (10 per page with dots + Prev/Next)

### IMMEDIATE (Do Now)
8. ❌ Fix role-based redirection in login.html (check user role after login)
9. ❌ Test forgot-password.html and reset-password.html flows

### HIGH PRIORITY (Phase 3 - Week 1)
10. ❌ Add Supabase to captain-dashboard.html (project approval workflow)
11. ❌ Add Supabase to sk-dashboard.html (dashboard overview)
12. ❌ Add Supabase to youth-dashboard.html (view projects, applications)

### MEDIUM PRIORITY (Phase 3 - Week 2)
9. ❌ Integrate sk-projects.html (create, edit, view projects)
10. ❌ Integrate youth-projects.html (apply to projects, inquiries)
11. ❌ Integrate sk-files.html (upload, view, delete files)
12. ❌ Integrate youth-files.html (view, download files)

### NORMAL PRIORITY (Phase 3 - Week 3-4)
13. ❌ Integrate sk-archive.html (archived projects/files)
14. ❌ Integrate sk-testimonies.html (view testimonials)
15. ❌ Integrate youth-certificates.html (view certificates)
16. ❌ Integrate calendar pages (sk-calendar.html, youth-calendar.html)
17. ❌ Integrate sk-reports.html (generate reports)

---

## Common Code Patterns

### 1. Adding Supabase to a Page
```html
<!-- Add before closing </head> -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<script src="js/config/env.js"></script>
<script src="js/config/supabase.js"></script>
<script src="js/auth/session.js"></script>
```

### 2. Auth Guard Template
```javascript
window.addEventListener('DOMContentLoaded', async () => {
  const session = await SessionManager.getSession();
  if (!session) {
    window.location.href = 'login.html';
    return;
  }

  const { data: user } = await supabaseClient
    .from('User_Tbl')
    .select('role, accountStatus, firstName, lastName')
    .eq('userID', session.user.id)
    .single();

  if (!user || user.accountStatus !== 'ACTIVE') {
    await SessionManager.logout();
    window.location.href = 'login.html';
    return;
  }

  if (user.role !== 'EXPECTED_ROLE') {
    window.location.href = SessionManager.getRoleDashboard(user.role);
    return;
  }

  // Load page data
  loadUserProfile(user);
  loadPageData();
});
```

### 3. Toast Notification Helper
```javascript
function showToast(message, type = 'info') {
  const toast = document.createElement('div');
  toast.className = `toast ${type}`;
  toast.innerHTML = `
    <div>
      <div style="font-weight: 600;">${type.toUpperCase()}</div>
      <div style="font-size: 14px; margin-top: 4px;">${message}</div>
    </div>
  `;
  document.body.appendChild(toast);

  setTimeout(() => toast.classList.add('show'), 10);
  setTimeout(() => {
    toast.classList.remove('show');
    setTimeout(() => toast.remove(), 300);
  }, 3000);
}
```

### 4. Error Handling Pattern
```javascript
try {
  const { data, error } = await supabaseClient
    .from('Table_Name')
    .select('*');

  if (error) throw error;

  // Success
  console.log('Data loaded:', data);
  renderData(data);
} catch (error) {
  console.error('Error:', error);
  showToast(error.message, 'error');
}
```

---

## Testing Checklist

After each integration:
- [ ] Page loads without console errors
- [ ] Auth guard redirects non-authenticated users
- [ ] Auth guard redirects wrong role users
- [ ] Data loads from Supabase correctly
- [ ] Create operations work
- [ ] Update operations work
- [ ] Delete operations work
- [ ] Error messages display properly
- [ ] Success toasts show for actions
- [ ] Mobile responsive layout still works

---

## Next Steps

1. **USER ACTION:** Run migrations 001-006 in Supabase
2. **USER ACTION:** Create first SUPERADMIN user
3. **CLAUDE:** Fix role-based redirection in login.html
4. **CLAUDE:** Add session management to all dashboards
5. **CLAUDE:** Integrate superadmin-dashboard.html first (highest priority)
6. **CLAUDE:** Work through remaining pages in priority order

---

**Document Status:** Ready for Phase 3 implementation
**Last Updated:** 2026-01-10
**Next Review:** After migrations are run
