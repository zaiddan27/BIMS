defense-in-depth across 15 security domains: authentication (email/password + Google OAuth with PKCE), 80+ RLS policies
on all 20 tables, database-level role escalation prevention, 30-min idle
timeout, server-side rate limiting, CSP headers, XSS sanitization,  
 comprehensive audit logging, and automatic superadmin notifications.

# BIMS Security Features — Defense Preparation Guide

> A foundational overview of every security layer in the system. Designed for defense preparation — know what exists, where it lives, and why it matters.

---

## 1. Authentication

### Email/Password Login

- Users sign up with email and password, verified via **6-digit OTP** (10-minute expiry)
- New accounts are set to **PENDING** status until approved by an admin
- **File:** `js/auth/auth.js` — `AuthService.signUp()`, `AuthService.login()`

### Google OAuth

- Users can log in via Google OAuth 2.0
- OAuth users are **auto-activated** (email already verified by Google)
- Default role assigned: `YOUTH_VOLUNTEER`
- Incomplete profiles are redirected to `complete-profile.html`
- **File:** `js/auth/google-auth-handler.js`

### PKCE (Proof Key for Code Exchange)

- Enabled in Supabase client config: `flowType: 'pkce'`
- Prevents **authorization code interception attacks** — a stolen auth code is useless without the original secret that only the browser holds
- **File:** `js/config/supabase.js`

---

## 2. Brute-Force & Login Lockout

- **5 failed login attempts** within 15 minutes triggers a **15-minute account lockout**
- Enforced **server-side** via PostgreSQL RPC functions — cannot be bypassed by modifying client-side JS
- **Key RPCs:**
  - `check_login_allowed(p_email)` — checks if login is permitted before password attempt
  - `record_failed_login(p_email)` — increments failed attempt counter
  - `clear_login_attempts(p_email)` — resets counter on successful login
- **Table:** `Login_Attempts_Tbl` with auto-cleanup of attempts older than 1 hour
- **Migration:** `supabase/migrations/022_security_hardening_phase3.sql`

---

## 3. Password Policy

- Minimum **8 characters**
- At least 1 uppercase letter (A-Z)
- At least 1 lowercase letter (a-z)
- At least 1 number (0-9)
- At least 1 special character (`!@#$%^&*` etc.)
- Enforced on both signup and password reset
- **File:** `js/auth/auth.js` — `AuthService.signUp()`, `AuthService.updatePassword()`

### Password Reset Rate Limiting

- Maximum **3 reset requests per 15 minutes** per email
- Enforced via `check_password_reset_allowed(p_email)` RPC
- **Table:** `Password_Reset_Attempts_Tbl`

---

## 4. Session Management

### Idle Timeout (Auto-Logout)

- Users are automatically logged out after **30 minutes of inactivity**
- Tracked events: `mousemove`, `keydown`, `click`, `scroll`, `touchstart`
- Any activity resets the 30-minute timer
- **File:** `js/auth/session.js` — `SessionManager.setupIdleTimeout()`

### Session Validation (on every protected page)

- Checks user is authenticated (valid Supabase session)
- Checks user exists in `User_Tbl`
- Checks account status is **ACTIVE** (blocks PENDING and INACTIVE)
- Checks user role is allowed for that page
- Checks profile is complete (redirects to `complete-profile.html` if not)
- **File:** `js/auth/session.js` — `SessionManager.init(allowedRoles)`

### Auth State Listener

- Listens for `SIGNED_OUT` events from Supabase
- Clears localStorage and redirects to login
- **File:** `js/auth/session.js` — `SessionManager.setupAuthListener()`

---

## 5. Role-Based Access Control (RBAC)

### Four Roles

| Role              | Description          | Access Level                            |
| ----------------- | -------------------- | --------------------------------------- |
| `SUPERADMIN`      | System Administrator | Full access to everything               |
| `CAPTAIN`         | Barangay Captain     | Approval authority (projects, accounts) |
| `SK_OFFICIAL`     | SK Official          | Administrative (manage content, users)  |
| `YOUTH_VOLUNTEER` | Youth Volunteer      | Basic user access                       |

### Enforcement

- **Frontend:** `SessionManager.requireAuth(['SK_OFFICIAL', 'CAPTAIN'])` on every protected page
- **Backend:** RLS policies on every table restrict data access by role
- **Database Triggers:** `prevent_role_escalation()` — only SUPERADMIN can change roles or account status; unauthorized changes are silently reverted

---

## 6. Row-Level Security (RLS)

- **All tables** have RLS enabled — no table is unprotected
- **80+ RLS policies** across 20 tables
- **Helper functions:** `is_sk_official_or_captain()`, `is_captain()`, `is_superadmin()`, `get_user_role()`
- **Migration:** `supabase/migrations/003_row_level_security.sql`

### Key Table Access Rules

| Table              | Who Can Access                                       |
| ------------------ | ---------------------------------------------------- |
| `User_Tbl`         | Users see own profile; SK/Captain/Superadmin see all |
| `Pre_Project_Tbl`  | Public sees approved; Captain approves; SK manages   |
| `Application_Tbl`  | Users see own; SK/Captain see all                    |
| `Notification_Tbl` | Users see own notifications only                     |
| `Logs_Tbl`         | Only SK_OFFICIAL, CAPTAIN, SUPERADMIN can view       |
| `Certificate_Tbl`  | Users see own; SK manages                            |

---

## 7. Content Security Policy (CSP)

Applied via `<meta>` tag in **all HTML pages**:

| Directive         | Value                   | Purpose                                                        |
| ----------------- | ----------------------- | -------------------------------------------------------------- |
| `default-src`     | `'self'`                | Only load resources from same origin                           |
| `script-src`      | `'self'` + trusted CDNs | Restricts where scripts can load from                          |
| `frame-ancestors` | `'none'`                | **Prevents clickjacking** — page cannot be embedded in iframes |
| `form-action`     | `'self'`                | Forms can only submit to same origin                           |
| `base-uri`        | `'self'`                | Prevents base tag injection                                    |
| `connect-src`     | `'self'` + Supabase     | Restricts API/fetch destinations                               |

Additional headers: `X-Content-Type-Options: nosniff`, `Referrer-Policy: strict-origin-when-cross-origin`

---

## 8. XSS Prevention (Input Sanitization)

- **`escapeHTML(str)`** — converts `<`, `>`, `&`, `"`, `'` to HTML entities before rendering user input
- Used throughout the system wherever user-generated content is displayed
- **File:** `js/utils/sanitize.js`

---

## 9. Activity Logging & Audit Trail

### Logging System

- Every significant user action is logged to `Logs_Tbl`
- **File:** `js/utils/logger.js` — `logAction()`
- **Migration:** `supabase/migrations/023_upgrade_logging_system.sql`

### Log Fields

- `userID`, `action`, `category`, `severity`, `ipAddress`, `userAgent`, `metadata` (JSONB)

### Auto-Category Detection

| Action Pattern            | Category         | Severity |
| ------------------------- | ---------------- | -------- |
| Login/logout/password/OTP | `authentication` | INFO     |
| Role or status changes    | `audit`          | WARN     |
| Delete operations         | `data_mutation`  | WARN     |
| Create/update operations  | `data_mutation`  | INFO     |
| `[AUDIT]` prefix          | `audit`          | WARN     |

### Log Retention

- General logs: **90 days** auto-cleanup
- Audit logs: **1 year** auto-cleanup
- Cleanup via `cleanup_old_logs()` RPC

---

## 10. Superadmin Notifications

- Superadmins receive automatic notifications for key system events:
  - New user signups
  - New project creation
  - Account status changes (ACTIVE/INACTIVE)
  - User role changes
- Implemented via **database triggers** that fire on INSERT/UPDATE
- **Migration:** `supabase/migrations/024_superadmin_notifications.sql`

---

## 11. File Upload Security

### Storage Buckets

| Bucket                | Visibility  | Who Uploads            |
| --------------------- | ----------- | ---------------------- |
| `user-images`         | Public      | User (own folder only) |
| `announcement-images` | Public      | SK Officials           |
| `project-images`      | Public      | SK Officials           |
| `consent-forms`       | **Private** | User (own folder only) |
| `receipts`            | **Private** | SK Officials only      |
| `certificates`        | **Private** | SK Officials only      |

### File Extension Validation (Server-Side)

- **Images:** `.jpg`, `.jpeg`, `.png`, `.gif`, `.webp`
- **Documents:** `.pdf`, `.doc`, `.docx`, `.xls`, `.xlsx`, `.jpg`, `.jpeg`, `.png`
- Enforced at Supabase storage policy level — cannot be bypassed from the frontend
- **Migration:** `supabase/migrations/022_security_hardening_phase3.sql`

---

## 12. Secure Redirects

### Post-Login Redirect Allowlist

- Only **pre-approved pages** can be stored as redirect targets after login
- Prevents **open redirect attacks** — attacker cannot craft a login URL that redirects to a malicious site
- **File:** `js/auth/session.js` — lines 202-211

### Role-Based Redirection

- After login, users are redirected to their role's dashboard — no user input in redirect URL
- **File:** `js/auth/session.js` — `SessionManager.redirectByRole()`

---

## 13. Environment & Client Configuration

- Supabase **anon key** is safe for client-side use — all data is protected by RLS
- `Object.freeze(ENV)` — prevents runtime modification of environment config
- `NODE_ENV` set to `'production'`
- **File:** `js/config/env.js`

---

## 14. Account Status Management

| Status     | Meaning                  | Can Access System?   |
| ---------- | ------------------------ | -------------------- |
| `PENDING`  | Awaiting admin approval  | No — auto-logged out |
| `ACTIVE`   | Approved and operational | Yes                  |
| `INACTIVE` | Deactivated by admin     | No — auto-logged out |

- Status checked on **every page load** via `SessionManager.init()`
- OAuth users auto-set to ACTIVE; email/password users start as PENDING

---

## Security Architecture Summary

```
User (Browser)
  │
  ├─ CSP Headers ─── Blocks clickjacking, XSS, unauthorized scripts
  ├─ escapeHTML() ─── Sanitizes user input before rendering
  ├─ PKCE Flow ────── Protects OAuth login from interception
  ├─ Idle Timeout ─── Auto-logout after 30 min inactivity
  │
  ▼
Supabase Client (JS SDK)
  │
  ├─ Auth Service ─── Email/password, OTP, Google OAuth
  ├─ Session Mgr ──── Role validation, status checks, redirect allowlist
  │
  ▼
Supabase Server (PostgreSQL)
  │
  ├─ RLS Policies (80+) ──── Row-level data access control
  ├─ Login Lockout RPCs ──── Brute-force prevention (server-enforced)
  ├─ Role Escalation Trigger ── Prevents unauthorized role changes
  ├─ File Extension Validation ── Server-side upload restrictions
  ├─ Activity Logging ─────── Full audit trail with auto-categorization
  └─ Superadmin Triggers ──── Auto-notifications for critical events
```

**Key principle:** Client-side security (JS) provides user experience. Server-side security (RLS, RPCs, triggers) provides actual protection. Even if all client-side code is modified, the database enforces every rule.
