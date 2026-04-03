# BIMS System Architecture - Complete Overview

> This document covers the full system architecture: all roles, all pages, shared modules, database schema, storage, and how everything connects. Best used as the first source in NotebookLM for overall context.

---

## What is BIMS?

BIMS (Barangay Information Management System) is a web application for managing Sangguniang Kabataan (SK) community projects in a Philippine barangay. It handles the full lifecycle: user management, project creation, volunteer applications, budget tracking, attendance, evaluations, certificates, and public transparency.

**Tech Stack:**
- Frontend: HTML + Tailwind CSS + Vanilla JavaScript (no framework)
- Backend: Supabase (PostgreSQL database, Auth, Storage, RPC functions, Row-Level Security)
- Libraries: jsPDF (PDF generation), html2canvas (certificate screenshots), PDF.js (PDF preview), Cropper.js (image cropping)

---

## Four User Roles

| Role | Who they are | What they can do |
|------|-------------|------------------|
| **SUPERADMIN** | System administrator | Manage users, promote/demote roles, deactivate accounts, view all logs and database stats |
| **CAPTAIN** | Barangay Captain | Approve/reject project proposals, view project statistics, manage archives |
| **SK_OFFICIAL** | SK Council member | Create projects, manage files, post announcements, handle applications, track attendance, complete evaluations, feature testimonies |
| **YOUTH_VOLUNTEER** | Community youth (default role) | Browse projects, apply to volunteer, submit inquiries, view files, submit feedback, earn certificates |

### Role Hierarchy
```
SUPERADMIN (protected, cannot be demoted)
  |
  +-- CAPTAIN (only 1 active at a time)
  |
  +-- SK_OFFICIAL (positions: Chairman, Secretary, Treasurer, Kagawad)
  |
  +-- YOUTH_VOLUNTEER (default for all new signups)
```

---

## All 23 Pages and Who Uses Them

### Public (No Login Required)
| Page | Purpose |
|------|---------|
| index.html | Landing page: projects, testimonials, budget transparency, published files |
| login.html | Email/password login with lockout protection |
| signup.html | New account registration (always as YOUTH_VOLUNTEER) |
| verify-otp.html | 6-digit email verification after signup |
| forgot-password.html | Request password reset OTP |
| reset-password.html | Enter OTP + set new password |

### Superadmin Pages
| Page | Purpose |
|------|---------|
| superadmin-dashboard.html | System health, stats, role distribution, captain term alerts |
| superadmin-user-management.html | Promote, demote, deactivate, reactivate users |
| superadmin-activity-logs.html | All logs, audit trail, database stats |

### Captain Pages
| Page | Purpose |
|------|---------|
| captain-dashboard.html | Review and approve/reject/revise project proposals, manage archives |

### SK Official Pages
| Page | Purpose |
|------|---------|
| sk-dashboard.html | Announcements CRUD, statistics, budget management |
| sk-projects.html | Create/edit projects, manage applications, attendance, evaluations |
| sk-files.html | Upload, publish, archive, delete files |
| sk-calendar.html | Calendar view of projects and announcements |
| sk-testimonies.html | Feature/unfeature volunteer testimonies for public display |
| sk-archive.html | View/restore/delete archived projects and files, export reports |

### Youth Volunteer Pages
| Page | Purpose |
|------|---------|
| youth-dashboard.html | View announcements, edit profile, submit feedback |
| youth-projects.html | Browse projects, apply, send inquiries, track applications |
| youth-calendar.html | Calendar view of projects and announcements |
| youth-files.html | Browse and download published files (read-only) |
| youth-certificates.html | Complete surveys and download participation certificates |

### Shared
| Page | Purpose |
|------|---------|
| complete-profile.html | First-time profile completion (required before dashboard access) |

---

## Database Schema (All 15+ Tables)

### Core Tables

**User_Tbl** - All users in the system
- userID (matches Supabase auth ID)
- firstName, lastName, middleName
- email, contactNumber, address, gender, birthday
- role (SUPERADMIN/CAPTAIN/SK_OFFICIAL/YOUTH_VOLUNTEER)
- accountStatus (ACTIVE/INACTIVE/PENDING)
- imagePathURL (profile picture)
- createdAt, updatedAt

**SK_Tbl** - SK Official positions and terms
- skID, userID (foreign key to User_Tbl)
- position (SK_CHAIRMAN/SK_SECRETARY/SK_TREASURER/SK_KAGAWAD)
- termStart, termEnd
- isActive

**Captain_Tbl** - Captain role tracking
- captainID, userID
- termStart, termEnd
- isActive

### Project Tables

**Pre_Project_Tbl** - Main project record
- preProjectID
- title, description, category, location
- budget, volunteers (target count), beneficiaries (target count)
- startDateTime, endDateTime
- status (PENDING/UPCOMING/ONGOING/COMPLETED/CANCELLED)
- approvalStatus (PENDING/APPROVED/REJECTED/REVISION)
- approvalNotes, approvalDate
- imagePathURL (banner image)
- submittedDate, createdAt, updatedAt

**Post_Project_Tbl** - Completion evaluation data
- postProjectID, preProjectID
- actualVolunteer, beneficiariesReached
- timelineAdherence (on-time/slightly-delayed/delayed/significantly-delayed)
- projectAchievement (JSON array of achievement strings)
- createdAt

**Application_Tbl** - Volunteer applications
- applicationID, userID, preProjectID
- preferredRole
- applicationStatus (PENDING/APPROVED/REJECTED)
- attended (boolean)
- parentConsentFile (for under-18 applicants)
- appliedDate, createdAt

**BudgetBreakdown_Tbl** - Planned budget line items
- breakdownID, preProjectID
- description, cost

**Expenses_Tbl** - Actual expenses (filled at completion)
- expenseID, preProjectID
- description, actualCost, receiptURL

### Communication Tables

**Inquiry_Tbl** - Youth questions about projects
- inquiryID, preProjectID, userID
- message, isReplied (boolean)
- createdAt

**Reply_Tbl** - Replies to inquiries
- replyID, inquiryID, userID
- message, createdAt

**Announcement_Tbl** - SK Official announcements
- announcementID
- title, description, category
- imagePathURL, publishedDate
- createdAt

**Notification_Tbl** - In-app notifications
- notificationID, userID
- type (new_announcement/application_approved/project_approved/etc.)
- title, message
- isRead (boolean)
- referenceID
- createdAt

### Evaluation & Feedback Tables

**Evaluation_Tbl** - Volunteer satisfaction surveys
- evaluationID, applicationID, postProjectID
- q1, q2, q3, q4, q5 (each 1-5 scale)
- message (written comments)
- hasCertificate (boolean)
- createdAt

**Testimonies_Tbl** - Public feedback
- testimonyID, userID
- message, rating (1-5 stars)
- isFiltered (boolean = featured on landing page)
- createdAt

### System Tables

**File_Tbl** - Uploaded documents
- fileID
- fileName, fileType, fileCategory
- filePath (storage URL)
- fileStatus (ACTIVE/ARCHIVED)
- isPublished (boolean = visible on landing page)
- dateUploaded, createdAt

**Logs_Tbl** - Activity and audit logs
- logID, userID
- action (description, max 255 chars)
- category (general/audit/authentication/data_mutation)
- severity (INFO/WARN/ERROR/CRITICAL)
- ipAddress, userAgent, metadata
- createdAt

**Annual_Budget_Tbl** - Budget transparency
- budgetID
- expenseCategory, budget
- fiscalYear

---

## Supabase Storage Buckets

| Bucket | Access | What's stored |
|--------|--------|--------------|
| user-images | Public | Profile pictures |
| announcement-images | Public | Announcement banners |
| project-images | Public | Project banners |
| general-files | Public | Published documents |
| project-files | Public | Project-related files |
| consent-forms | Private | Parental consent for minor volunteers |
| receipts | Private | Expense receipt images |
| certificates | Private | Generated certificates |

---

## Shared JavaScript Modules

### js/config/env.js
- Exports SUPABASE_URL, SUPABASE_ANON_KEY, API_TIMEOUT

### js/config/supabase.js
- Creates and exports `window.supabaseClient` (Supabase JS client)
- PKCE auth flow for CSRF protection
- Auto-refresh tokens, localStorage persistence

### js/auth/session.js (SessionManager)
- `init(allowedRoles)` - Auth check + role verification on every protected page
- `requireAuth(allowedRoles)` - Redirects to login if no session
- `setupIdleTimeout()` - 30-minute auto-logout on inactivity
- `redirectByRole(role)` - Routes to correct dashboard
- `logout()` - Signs out + clears localStorage

### js/auth/auth.js (AuthService)
- `signUp()`, `login()`, `logout()`, `verifyOTP()`
- Server-side rate limiting via RPC (5 login attempts, 3 reset requests per 15 min)
- Password complexity enforcement

### js/auth/google-auth-handler.js
- Handles Google OAuth callback
- Auto-creates User_Tbl record for new OAuth users
- Redirects to profile completion if needed

### js/components/ProfileModal.js
- Reusable profile editing modal
- Field validation (age, phone format, name length)
- Profile picture upload to storage
- Dispatches `profileUpdated` event when saved

### js/components/NotificationModal.js
- Bell icon notification panel
- Fetches from Notification_Tbl (last 20)
- Marks as read on click
- Routes to relevant page based on notification type

### js/components/sidebar.js
- Role-based sidebar navigation
- Auto-highlights active page
- Renders different nav items per role

### js/utils/sanitize.js
- `escapeHTML(str)` - Prevents XSS by escaping HTML entities
- `handleAvatarError(img, initials)` - Fallback for broken images

### js/utils/logger.js
- `logAction(action, opts)` - Fire-and-forget logging to Logs_Tbl via RPC
- Auto-detects category and severity from action keywords
- Never blocks UI, never throws errors

### js/utils/toast.js
- `showToast(message, type)` - Temporary notification (success/error/warning/info)
- Auto-closes after 4 seconds

### js/utils/focus-trap.js
- `FocusTrap.activate(modal)` / `deactivate()` - Keyboard focus trapping for accessibility

---

## The Complete Project Lifecycle (How All Roles Interact)

```
SUPERADMIN promotes Youth to SK_OFFICIAL (superadmin-user-management.html)
    |
SK_OFFICIAL creates a project proposal (sk-projects.html)
    |
    +--> Notification sent to CAPTAIN
    |
CAPTAIN reviews and decides (captain-dashboard.html)
    |
    +-- APPROVED --> Project goes UPCOMING
    |   |
    |   +--> SK_OFFICIAL clicks "Start" --> ONGOING
    |   |
    |   +--> YOUTH_VOLUNTEER browses and applies (youth-projects.html)
    |   |
    |   +--> SK_OFFICIAL reviews applications (sk-projects.html)
    |   |       |
    |   |       +-- Approved --> Youth notified, can attend
    |   |       +-- Rejected --> Youth notified
    |   |
    |   +--> During project: SK tracks attendance
    |   |
    |   +--> SK marks complete with evaluation --> COMPLETED
    |   |       |
    |   |       +--> Success rate calculated (budget + volunteers + timeline + impact + feedback)
    |   |       +--> Post_Project_Tbl record created
    |   |       +--> Expenses_Tbl records with receipts
    |   |
    |   +--> Youth fills satisfaction survey (youth-certificates.html)
    |   |       |
    |   |       +--> Certificate becomes available for download
    |   |
    |   +--> Youth submits general feedback (youth-dashboard.html)
    |   |       |
    |   |       +--> SK can feature it on public page (sk-testimonies.html)
    |   |
    |   +--> Project archived after 3 months or manually (sk-archive.html)
    |           |
    |           +--> Can be restored, permanently deleted, or exported as PDF/CSV
    |
    +-- REJECTED --> SK notified, can edit and resubmit or archive
    |
    +-- REVISION REQUESTED --> SK edits based on captain's notes, resubmits
```

---

## Security Architecture

### Authentication
- Supabase Auth with PKCE flow (CSRF protection)
- Password: 8+ chars, uppercase, lowercase, digit, special char
- Email verification via OTP (10-min expiry)
- Login lockout: 5 failed attempts = 15-min cooldown
- Password reset: rate-limited to 3/15min server-side
- Google OAuth as alternative login
- 30-minute idle timeout

### Authorization
- Role-based access: each page checks `SessionManager.requireAuth([allowedRoles])`
- Row-Level Security (RLS) on Supabase tables
- Account status check (only ACTIVE accounts can access)
- Profile completion gate (must fill required fields first)

### Data Security
- XSS prevention: `escapeHTML()` on all user content before rendering
- URL whitelist: `sanitizeImageURL()` only allows Supabase/Google domains
- Content Security Policy (CSP) headers via meta tags
- File validation: type and size limits on all uploads
- Private storage buckets for sensitive files (consent forms, receipts)

### Audit Trail
- `logAction()` records all significant actions to Logs_Tbl
- [AUDIT] prefix for critical admin actions
- Actor ID, IP address, user agent, timestamp recorded
- Superadmin can view all logs and filter by date/category

---

## Notification System

### How Notifications Are Created
- **RPC: create_notification()** - Called directly from code (e.g., when SK approves an application)
- **Database triggers** - Auto-fire on certain table changes (e.g., `notify_project_approval` trigger on Pre_Project_Tbl approval status change)

### Notification Types
| Type | When triggered | Who receives |
|------|---------------|-------------|
| project_approved | Captain approves project | SK Official |
| project_rejected | Captain rejects project | SK Official |
| revision_requested | Captain requests revision | SK Official |
| application_approved | SK approves volunteer | Youth |
| application_rejected | SK rejects volunteer | Youth |
| new_project_created | SK creates project | Captain |
| new_announcement | SK posts announcement | Youth |
| new_inquiry | Youth asks question | SK Official |
| new_user_signup | New user registers | Superadmin |
| account_status_change | Account activated/deactivated | Affected user |
| role_change | Role promoted/demoted | Affected user |

### Notification Display
- NotificationModal.js renders bell icon with badge count
- Click bell: shows last 20 notifications
- Click notification: marks as read, routes to relevant page
- "Mark all as read" button

---

## Quick Defense Q&A

**Q: What technologies does BIMS use?**
> HTML/CSS/JavaScript frontend with Supabase backend (PostgreSQL, Auth, Storage, Edge Functions). No frontend framework -- vanilla JS with Tailwind CSS for styling.

**Q: How many user roles are there and what can each do?**
> Four roles: Superadmin (manages users/system), Captain (approves projects), SK Official (manages projects/files/announcements), Youth Volunteer (browses/applies/volunteers). Hierarchy: Superadmin > Captain > SK Official > Youth.

**Q: How is the system secured?**
> Multi-layer: password complexity, login lockout, email OTP verification, idle timeout, role-based page access, Supabase Row-Level Security, XSS prevention, Content Security Policy, URL whitelisting, audit logging.

**Q: How many database tables are there?**
> 15+ tables covering users, roles, projects, applications, budget, expenses, inquiries, replies, announcements, notifications, evaluations, testimonies, files, logs, and annual budget.

**Q: What is the project success rate?**
> A weighted formula: Budget Efficiency (25%) + Volunteer Participation (20%) + Timeline Adherence (20%) + Community Impact (20%) + Volunteer Feedback (15%). Calculated when SK Official completes a project.

**Q: How do notifications work?**
> Created via RPC calls or database triggers. Stored in Notification_Tbl. Displayed via NotificationModal.js bell icon. Each notification type routes to the relevant page when clicked.

**Q: What shared components exist?**
> SessionManager (auth), ProfileModal (profile editing), NotificationModal (notifications), Sidebar (navigation), Toast (feedback), Logger (audit trail), Sanitize (XSS prevention), FocusTrap (accessibility).
