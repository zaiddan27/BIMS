# BIMS Superadmin System - Complete Guide

> Covers: superadmin-dashboard.html, superadmin-user-management.html, superadmin-activity-logs.html

---

## Who is the Superadmin?

The SUPERADMIN is the highest-level system administrator. They manage users, roles, and monitor system health. Superadmin accounts are protected and cannot be demoted by anyone.

---

## 1. Superadmin Dashboard (superadmin-dashboard.html)

**Purpose:** System overview with real-time statistics, health monitoring, and alerts.

### System Health Check (checkSystemStatus)
- Pings User_Tbl to measure database response time
- Displays: "Online" with latency in ms, or "Connection Issue" if ping fails
- Runs on page load

### Dashboard Statistics (8 Cards)
loadDashboard() runs 8 parallel count queries:

| Stat | Source | Query |
|------|--------|-------|
| Total Users | User_Tbl | Count all |
| Active Users | User_Tbl | Count where accountStatus = 'ACTIVE' |
| Pending Users | User_Tbl | Count where accountStatus = 'PENDING' |
| Deactivated Users | User_Tbl | Count where accountStatus = 'INACTIVE' |
| Projects | Pre_Project_Tbl | Count all |
| Applications | Application_Tbl | Count all |
| Total Logs | Logs_Tbl | Count all |
| Today's Logs | Logs_Tbl | Count where createdAt = today |

All use `count: 'exact', head: true` for efficiency (no actual data transferred).

### Users by Role (loadUsersByRole)
Counts active users per role and displays horizontal progress bars:
- SUPERADMIN (purple)
- CAPTAIN (red)
- SK_OFFICIAL (blue)
- YOUTH_VOLUNTEER (green)

### Captain Term Expiration Alert (checkCaptainTermExpiration)
- Queries Captain_Tbl for active captain
- If term ends within 30 days: shows yellow warning
- If term already expired: shows red critical alert
- Alert includes captain's name and term end date

### Recent Audit Events (loadRecentAuditEvents)
- Fetches last 3 logs where category = 'audit'
- Shows: action description, actor name, timestamp
- These are critical actions like promotions, demotions, deactivations

### Recent Activity Timeline (loadRecentActivity)
- Fetches 5 most recent logs (any category)
- Shows: action, user name, role, timestamp
- Formatted with relative time ("2m ago", "3h ago")

### Key Functions Summary
| Function | What it does |
|----------|-------------|
| checkSystemStatus() | Pings DB, shows latency and connection status |
| loadDashboard() | 8 parallel count queries for stat cards |
| loadUsersByRole() | Role distribution with progress bars |
| checkCaptainTermExpiration() | Warns if captain term expiring soon |
| loadRecentAuditEvents() | Last 3 audit-tagged logs |
| loadRecentActivity() | Last 5 system actions timeline |

### Tables Used
| Table | Operations |
|-------|-----------|
| User_Tbl | SELECT (counts by role + status) |
| Pre_Project_Tbl | SELECT (count) |
| Application_Tbl | SELECT (count) |
| Logs_Tbl | SELECT (counts + recent entries) |
| Captain_Tbl | SELECT (term expiration check) |

---

## 2. User Management (superadmin-user-management.html)

**Purpose:** Full user administration -- promote, demote, deactivate, and reactivate users.

### User List (loadUsers)
- Fetches ALL users from User_Tbl with SK_Tbl join
- Sorted by createdAt (newest first)
- Displayed in a paginated table (10 per page)
- Shows: name, role, SK position, account status, joined date, action buttons

### Statistics Cards (updateUserStats)
5 cards showing:
- Total Users
- SK Officials (count)
- Youth Volunteers (count)
- Pending (count)
- Inactive (count)

### Search & Filter (filterUsers)
- **Search:** by name or email (real-time, case-insensitive)
- **Role filter:** dropdown (All, SK_OFFICIAL, YOUTH_VOLUNTEER, CAPTAIN)
- **Status filter:** dropdown (All, ACTIVE, INACTIVE, PENDING)
- All filtering is client-side on the loaded array

### Action Buttons Per Role
| User's Current Role | Available Actions |
|--------------------|-------------------|
| SUPERADMIN | "Protected" label (no actions allowed) |
| CAPTAIN | "Remove Captain Role" button |
| SK_OFFICIAL | "Remove SK Role" + "Deactivate" buttons |
| YOUTH_VOLUNTEER (active) | "Promote" + "Deactivate" buttons |
| Any (inactive) | "Reactivate" button |

---

### Promotion Flow

**Step 1: Choose promotion type** (promoteToSK)
- Opens modal: "Promote as SK Official" or "Promote as Captain"

**Promoting to SK Official** (confirmPromote):
1. Select SK position from dropdown:
   - SK_CHAIRMAN (max 1 active)
   - SK_SECRETARY (max 1 active)
   - SK_TREASURER (max 1 active)
   - SK_KAGAWAD (max 7 active)
2. Set term start and end dates
3. System checks position limits:
   - If Chairman/Secretary/Treasurer already has someone: auto-deactivates previous holder
   - If Kagawad count is already 7: blocks with error
4. On confirm:
   - Updates User_Tbl: role = 'SK_OFFICIAL', accountStatus = 'ACTIVE'
   - Inserts into SK_Tbl: position, termStart, termEnd
   - Logs audit action

**Promoting to Captain** (promoteToCaptain):
1. System checks for existing active captains
2. Shows warning: "This will deactivate all current Captains"
3. On confirm:
   - Deactivates ALL existing captains (there can only be 1 active)
   - Updates User_Tbl: role = 'CAPTAIN', accountStatus = 'ACTIVE'
   - Logs audit action

---

### Demotion Flow

**Demoting SK Official** (confirmDemote for SK_OFFICIAL):
1. Opens modal with consequences listed:
   - Position will be removed
   - Role reverts to YOUTH_VOLUNTEER
   - All SK privileges lost
2. Requires confirmation checkbox
3. On confirm:
   - Deletes from SK_Tbl (removes position record)
   - Updates User_Tbl: role = 'YOUTH_VOLUNTEER'
   - Logs audit action

**Demoting Captain** (confirmDemote for CAPTAIN):
1. Similar modal with consequences
2. Requires confirmation checkbox
3. On confirm:
   - Deletes from Captain_Tbl
   - Updates User_Tbl: role = 'YOUTH_VOLUNTEER'
   - Logs audit action

---

### Deactivation Flow (deactivateUser --> confirmDeactivate)
1. Opens modal with:
   - **Reason dropdown** (required):
     - Policy Violation
     - Inappropriate Behavior
     - Inactivity
     - Duplicate Account
     - User Request
     - Other
   - **Notes textarea** (optional)
   - **Confirmation checkbox** (required)
2. On confirm:
   - Updates User_Tbl: accountStatus = 'INACTIVE'
   - Logs audit action with reason
   - Deactivated users cannot log in

### Reactivation Flow (reactivateUser)
1. Shows confirmation dialog
2. On confirm:
   - Updates User_Tbl: accountStatus = 'ACTIVE'
   - User can log in again

---

### Role Hierarchy

```
SUPERADMIN (System Admin)
  |-- Protected: cannot be demoted or deactivated
  |-- Can manage ALL other roles
  |
  +-- CAPTAIN (Barangay Captain)
  |     |-- Only 1 active at a time
  |     |-- Promoting new captain auto-deactivates old ones
  |     |-- Can be demoted to YOUTH_VOLUNTEER
  |     |-- Approves/rejects project proposals
  |
  +-- SK_OFFICIAL (SK Council Member)
  |     |-- Positions: Chairman(1), Secretary(1), Treasurer(1), Kagawad(max 7)
  |     |-- Term tracking: start and end dates
  |     |-- Can be demoted to YOUTH_VOLUNTEER
  |     |-- Manages projects, files, announcements
  |
  +-- YOUTH_VOLUNTEER (Base Role)
        |-- Default for all new signups
        |-- Can be promoted to SK_OFFICIAL or CAPTAIN
        |-- Can be deactivated
        |-- Browses projects, applies, submits feedback
```

### Key Functions Summary
| Function | What it does |
|----------|-------------|
| loadUsers() | Fetches all users with SK position data |
| renderUsers() | Paginated table with role-based action buttons |
| filterUsers() | Client-side search + role + status filtering |
| promoteToSK() | Opens promotion type chooser modal |
| confirmPromote() | Validates position limits, creates SK_Tbl record |
| promoteToCaptain() | Deactivates existing captains, promotes user |
| confirmDemote() | Deletes SK/Captain record, reverts to YOUTH_VOLUNTEER |
| deactivateUser() / confirmDeactivate() | Sets accountStatus to INACTIVE with reason |
| reactivateUser() | Sets accountStatus back to ACTIVE |

### Tables Used
| Table | Operations |
|-------|-----------|
| User_Tbl | SELECT (all users), UPDATE (role, accountStatus) |
| SK_Tbl | SELECT (positions), INSERT (on promote), DELETE (on demote) |
| Captain_Tbl | SELECT (active captains), DELETE (on demote) |

---

## 3. Activity Logs (superadmin-activity-logs.html)

**Purpose:** System-wide audit trail and database monitoring. Three tabs: All Logs, Audit Trail, Database Stats.

### Tab 1: All Activity Logs (fetchLogs)
- Fetches from Logs_Tbl with User_Tbl join
- **Server-side pagination:** 20 logs per page (uses Supabase `.range()`)
- Optional date filter (single date picker)
- Each log entry shows:
  - Severity dot (color-coded)
  - Action description
  - Category label
  - User name + role
  - Timestamp

**Severity Color Coding:**
| Severity | Color | When used |
|----------|-------|-----------|
| CRITICAL | Red | Major system events |
| ERROR | Red (lighter) | Failed operations |
| WARN | Yellow | Destructive actions (delete, deactivate) |
| INFO | Blue | Normal operations |

### Tab 2: Audit Trail (loadAuditTrail)
- Same as All Logs but filtered to `category = 'audit'` only
- Shows critical administrative actions:
  - User promotions/demotions
  - Account deactivations/reactivations
  - Role changes
  - Password resets
- Alert-style boxes with colored left borders based on severity
- Server-side pagination (20 per page)

### Tab 3: Database Stats (loadDatabaseStats)
- Runs 15 parallel count queries across all tables:
  - User_Tbl, SK_Tbl, Captain_Tbl, Announcement_Tbl, File_Tbl
  - Pre_Project_Tbl, Post_Project_Tbl, Application_Tbl
  - Inquiry_Tbl, Reply_Tbl, Notification_Tbl
  - Certificate_Tbl, Evaluation_Tbl, Testimonies_Tbl, Logs_Tbl
- Shows record count per table
- Also lists Supabase Storage buckets:
  - **Public:** user-images, announcement-images, project-images, general-files, project-files
  - **Private:** consent-forms, receipts, certificates

### Lazy Loading
- Tabs load data only when first clicked (not all on page load)
- Subsequent tab switches use cached data unless refreshed

### Key Functions Summary
| Function | What it does |
|----------|-------------|
| switchTab() | Shows/hides tab content, lazy-loads data |
| fetchLogs() | All activity logs with optional date filter |
| renderLogs() | Log entries with severity colors and categories |
| loadAuditTrail() | Audit-only logs (critical actions) |
| renderAudit() | Alert-style audit entries |
| loadDatabaseStats() | 15 parallel count queries for all tables |

### Tables Used
| Table | Operations |
|-------|-----------|
| Logs_Tbl | SELECT (with filters, pagination) |
| User_Tbl (joined) | SELECT (actor names for logs) |
| All 15 tables | SELECT (count only, for database stats) |

---

## How the Logging System Works (Across All Pages)

### The Logger Utility (js/utils/logger.js)
Every page can call `logAction(action, opts)` to record user actions.

**Auto-Detection Rules:**
| Keyword in action | Auto-assigned category | Auto-assigned severity |
|-------------------|----------------------|----------------------|
| `[AUDIT]` prefix | audit | WARN |
| login/password/signup | authentication | INFO |
| delete/deactivate | data_mutation | WARN |
| create/upload/submit | data_mutation | INFO |
| update/edit/archive | data_mutation | INFO |

**What gets logged:**
- p_action: Description (max 255 chars)
- p_category: auto-detected or manual
- p_severity: auto-detected or manual
- p_ip_address, p_user_agent: browser info
- p_metadata: optional extra data
- Foreign keys: can link to specific reply, project, application, inquiry

**Design:** Fire-and-forget. Never blocks UI. Errors are silently swallowed (logging failure should never break the app).

### What Creates Audit Logs
Actions prefixed with `[AUDIT]` are the critical ones:
- User promoted to SK Official
- User promoted to Captain
- User demoted
- Account deactivated (with reason)
- Account reactivated
- Previous position holder deactivated (cascade)

These appear in the Audit Trail tab and the dashboard's Recent Audit Events.

---

## Cross-Page Summary

```
Superadmin Dashboard
  |-- System health (DB ping + latency)
  |-- 8 stat cards (users, projects, apps, logs)
  |-- Role distribution chart
  |-- Captain term expiration alert
  |-- Recent audit events (top 3)
  |-- Recent activity timeline (top 5)

User Management
  |-- User table with search/filter
  |-- Promote youth to SK Official or Captain
  |-- Demote SK/Captain back to youth
  |-- Deactivate accounts (with reason tracking)
  |-- Reactivate accounts
  |-- SK position limit enforcement

Activity Logs
  |-- All Logs tab (full history, date filter, paginated)
  |-- Audit Trail tab (critical actions only)
  |-- Database Stats tab (record counts for all 15 tables + storage buckets)
```

---

## Quick Q&A

**Q: Can a Superadmin be demoted?**
> No. SUPERADMIN accounts are marked "Protected" with no action buttons. This is enforced in the UI.

**Q: What happens when a new Captain is promoted?**
> All existing active Captains are automatically deactivated. Only 1 Captain can be active at a time.

**Q: What are SK position limits?**
> Chairman: 1, Secretary: 1, Treasurer: 1, Kagawad: max 7. If someone already holds Chairman/Secretary/Treasurer, the previous holder is auto-deactivated when a new one is promoted.

**Q: How do deactivated accounts work?**
> Their accountStatus becomes INACTIVE. They cannot log in (blocked at login.html). A reason is recorded (policy violation, inactivity, etc.). Only a Superadmin can reactivate them.

**Q: What's the difference between All Logs and Audit Trail?**
> All Logs shows everything (page views, data changes, auth events). Audit Trail filters to only `category = 'audit'` which are critical admin actions like promotions, demotions, and deactivations.

**Q: How many records does each table have?**
> The Database Stats tab shows real-time counts for all 15 tables. Superadmin can use this to monitor system size and detect anomalies.

**Q: What storage buckets exist?**
> Public: user-images, announcement-images, project-images, general-files, project-files. Private: consent-forms, receipts, certificates.
