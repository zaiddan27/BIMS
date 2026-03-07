# SRS Reconstructed Sections - Copy-Paste Ready

Below are the sections from the SRS that need to be replaced. Copy-paste these directly into the SRS document, replacing the corresponding old sections.

---

## Section 3.3 Software Interfaces (Replace entirely)

The Barangay Information Management System interfaces with a minimal set of external software systems to maintain simplicity and reduce dependencies. The primary software interface is Supabase, a Backend-as-a-Service (BaaS) platform built on PostgreSQL. The application communicates with Supabase via HTTPS REST API using the Supabase JavaScript client library (`@supabase/supabase-js`) for storing and retrieving barangay records, user data, project information, and document metadata. All database queries are executed through Supabase's auto-generated REST endpoints with Row Level Security (RLS) enforced at the database level.

The system is compatible with modern, up-to-date web browsers including Google Chrome, Mozilla Firefox, Microsoft Edge, and Safari, communicating via standard HTTPS protocols to render the web-based user interface and handle client-server interactions. Users should ensure their browsers are updated to the latest version for optimal security and performance.

For email functionality, the system utilizes the Gmail API to send two-factor authentication codes (OTP) through secure HTTPS connections. OTP codes are generated server-side and delivered to the user's registered email address for account verification, password recovery, and login authentication. These interfaces represent the complete set of external software dependencies required for system operation, ensuring a self-contained architecture with minimal third-party dependencies and reduced complexity for maintenance and support.

---

## Section 4.1.1 Sub-functions — Login Lockout (Verify this text matches)

A maximum of 5 failed login attempts is allowed before the user is temporarily locked out for 15 minutes. Lockout data is tracked per email address using browser localStorage. When the user has 1–2 attempts remaining, a warning toast notification is displayed. Once locked out, a toast message shows the remaining lockout time in minutes.

---

## Section 4.1.2 Non-Functional Requirements (Replace entirely)

Passwords are securely managed through Supabase Auth, which uses bcrypt hashing. Two-factor authentication via OTP is mandatory for registration and password recovery. The system logs both successful and unsuccessful login attempts. A maximum of five failed login attempts is allowed before access is temporarily restricted for 15 minutes, with lockout state tracked per email address in browser localStorage.

The system must reliably authenticate users and handle concurrent login requests without performance degradation. Supabase Auth manages JWT-based session tokens with automatic refresh.

Clear error messages are displayed when credentials are incorrect, without exposing sensitive system information. Input validation is enforced for email addresses and passwords to prevent invalid or malicious entries. Console error messages in production are sanitized to string-only format (no error objects exposed).

---

## Section 5 Business Rules — System Users and Roles (Replace entirely)

**System Users and Roles**

#### Primary Users

**Barangay Captain**

- Granted project oversight and approval access
- Serves as the primary authority for project approval
- Holds final decision-making authority on project proposals
- Reviews project proposals and issues Approve, Reject, or Request Revision decisions
- Provides written feedback when rejecting or requesting revision
- Views consolidated project statistics and budget summaries
- Cannot create or modify project details directly
- Cannot manage volunteer applications at the operational level
- Stored in Captain_Tbl with term start/end dates
- Only ONE active CAPTAIN account allowed in the system

**SK Chairman**

- Granted full system access as SK_OFFICIAL role
- Leads the SK council and oversees all SK operations
- Authorized to manage projects, files, and announcements
- Position tracked in SK_Tbl as SK_CHAIRMAN
- Only ONE active SK_CHAIRMAN allowed at a time
- Note: The SK Chairman and Barangay Captain are two separate individuals in Philippine local government

**SK Kagawad**

- Authorized to create and manage projects within their respective committees
- Responsible for volunteer coordination and supervision
- Permitted to manage and upload files relevant to assigned projects
- Position tracked in SK_Tbl as SK_KAGAWAD
- Maximum of 7 active SK_KAGAWAD accounts allowed

**SK Secretary**

- Responsible for document management and administrative support within the system
- Assists in system administration tasks
- Position tracked in SK_Tbl as SK_SECRETARY
- Only ONE active SK_SECRETARY allowed

**SK Treasurer**

- Responsible for budget and financial tracking
- Position tracked in SK_Tbl as SK_TREASURER
- Only ONE active SK_TREASURER allowed

#### Secondary Users

**Youth Volunteers**

- Allowed to view available and approved projects
- Authorized to register for upcoming projects
- Permitted to submit inquiries regarding projects and post replies within inquiry threads
- Can view announcements, public files, and project schedules
- Can submit testimonies with ratings (1-5 stars) for completed projects
- Can view and download certificates of participation
- Cannot access administrative features or dashboards
- Cannot view or modify other volunteers' personal information

#### System Administrators

**SUPERADMIN**

- Responsible for user account management across all roles
- Can promote users to CAPTAIN or SK_OFFICIAL roles
- Can activate and deactivate user accounts
- Can view all system users and their statuses
- Oversees system-wide configuration
- Role escalation is protected by `prevent_role_escalation()` database trigger — only SUPERADMIN can change user roles or account status

---

## Data Dictionary Tables (SRS references SDD for schema, but if any inline schema mentions exist, update these values)

### User_Tbl — Corrected role values
```
role: VARCHAR(20) — Values: 'SUPERADMIN', 'CAPTAIN', 'SK_OFFICIAL', 'YOUTH_VOLUNTEER'
```
(Old value was: `ENUM(SK_OFFICIAL, YOUTH_VOLUNTEER)` — missing SUPERADMIN and CAPTAIN)

### User_Tbl — Add missing column
```
gender: VARCHAR(20) (NULLABLE)
```

### Application_Tbl — Add missing column
```
attended: BOOLEAN (DEFAULT: FALSE) — Tracks whether applicant attended the project
```

### Notification_Tbl — Add missing column and types
```
referenceID: INTEGER (NULLABLE) — Deep link to related entity (e.g., preProjectID)
```

Additional notification types to add:
- `user_promoted` — When a user's role is changed
- `user_deactivated` — When a user account is deactivated
- `user_reactivated` — When a user account is reactivated
- `captain_term_expiring` — Warning before captain term expires
- `captain_term_expired` — When captain term has expired

### Testimonies_Tbl — Add missing column
```
rating: INTEGER (NULLABLE, 1-5 stars, CHECK rating BETWEEN 1 AND 5)
```

### OTP_Tbl — Corrected purpose values
```
purpose: VARCHAR(20) — Values: 'LOGIN', 'FORGOT_PASSWORD', 'SIGN_UP'
```
(Old value was: `ENUM(LOGIN, FORGET, SIGN-UP)` — FORGET should be FORGOT_PASSWORD, SIGN-UP should be SIGN_UP)

### Evaluation_Tbl — Corrected foreign key
```
postProjectID: INTEGER (NULLABLE, FOREIGN KEY → Post_Project_Tbl.postProjectID)
```
(Old value was: `projectID` — should reference Post_Project_Tbl, not a generic projectID, and is NULLABLE)

### Expenses_Tbl — Corrected column name
```
receiptURL: TEXT (NULLABLE)
```
(Old value was: `receiptSet`)

### Pre_Project_Tbl — Corrected values
```
approvalStatus: VARCHAR(20) — Values: 'PENDING', 'APPROVED', 'REJECTED', 'REVISION'
approvalNotes: TEXT (NULLABLE)
```
(Old values were: `APPROVE`, `REJECT` instead of `APPROVED`, `REJECTED`; `approvalnotes` instead of `approvalNotes`)

### Post_Project_Tbl — Corrected column name
```
timelineAdherence: VARCHAR(30) — Values: 'Completed_On_Time', 'Slightly_Delayed', 'Delayed', 'Significantly_Delayed'
```
(Old value was: `timelineAdherance` — typo)

### SK_Tbl — Remove SK_AUDITOR
```
position: VARCHAR(20) — Values: 'SK_CHAIRMAN', 'SK_SECRETARY', 'SK_TREASURER', 'SK_KAGAWAD'
```
(Old value included `SK_AUDITOR` which does not exist in the current system)

### Application_Tbl — Corrected status values
```
applicationStatus: VARCHAR(20) — Values: 'PENDING', 'APPROVED', 'REJECTED'
```
(Old value had typo: `APPROVIED` instead of `APPROVED`)
