# BIMS Authentication System - Complete Guide

> Covers: login.html, signup.html, verify-otp.html, forgot-password.html, reset-password.html, complete-profile.html, index.html (landing page)

---

## Overall Auth Flow (The Journey of a User)

```
New User: signup --> verify OTP --> login --> complete profile --> dashboard
Returning User: login --> dashboard
Forgot Password: forgot-password --> reset-password (OTP + new password) --> login
Google OAuth: login/signup via Google --> complete profile (if new) --> dashboard
```

---

## 1. Signup (signup.html)

**What happens:** A new user creates an account. All new users start as YOUTH_VOLUNTEER.

### Functions

- **isValidEmail(email)** - Checks email format with regex
- **isValidPassword(password)** - Enforces 5 requirements: 8+ characters, uppercase, lowercase, digit, special character
- **isValidName(name)** - Minimum 2 characters
- **formatName(name)** - Converts to Title Case (e.g., "john doe" becomes "John Doe")
- **updatePasswordRequirements(password)** - Shows real-time checklist of 5 password requirements with checkmark icons as user types
- **signUpWithGoogle()** - Starts Google OAuth flow via Supabase

### What gets saved

- Supabase Auth creates the auth user (email + password)
- Metadata stored: first_name, last_name, middle_name, role='YOUTH_VOLUNTEER', terms_conditions
- A database trigger auto-creates a row in `User_Tbl` from the auth user

### Validation Rules

- First/Last name: minimum 2 characters
- Email: valid format
- Password: must pass ALL 5 requirements (length, uppercase, lowercase, number, special char)
- Confirm password: must match
- Terms & Privacy checkbox: required

### After successful signup

- Email stored in `sessionStorage.verification_email`
- User redirected to verify-otp.html

---

## 2. Email Verification (verify-otp.html)

**What happens:** User enters the 6-digit code sent to their email.

### Functions

- **OTP input handlers** - Auto-focus next input on digit entry, backspace goes back, paste support fills all 6 inputs
- **updateTimer()** - 10-minute countdown timer (600 seconds, shown as MM:SS)
- **Form submission** - Calls `supabaseClient.auth.verifyOtp({email, token, type: 'email'})`
- **Resend handler** - Calls `supabaseClient.auth.resend({type: 'signup', email})` with 60-second cooldown

### Security

- Code expires in 10 minutes
- Can only resend every 60 seconds
- Email pulled from sessionStorage (prevents URL tampering)

### After successful verification

- Clears email from sessionStorage
- Redirects to login.html

---

## 3. Login (login.html)

**What happens:** User signs in with email + password. System checks multiple conditions before granting access.

### Functions

- **isValidEmail(email)** - Email format validation
- **isValidPassword(password)** - Minimum 8 characters
- **setInputState(inputElement, isValid, message)** - Shows green check or red X on inputs
- **signInWithGoogle()** - Starts Google OAuth

### Login Process (Step by Step)

1. Validate email and password format
2. Check lockout status (localStorage tracks failed attempts per email)
3. Call `supabaseClient.auth.signInWithPassword()`
4. If failed: increment attempt counter (5 max before 15-min lockout)
5. If successful:
   - Check `email_confirmed_at` exists (email verified?)
   - Fetch user from `User_Tbl` to get role and account status
   - Check `accountStatus === 'ACTIVE'`
   - Check profile completeness (contactNumber, address, gender, birthday)
   - Redirect to appropriate dashboard based on role

### Login Lockout System

- Stored in `localStorage` as `login_attempts_{email}`
- 5 failed attempts trigger 15-minute lockout
- Shows warning at 2 attempts remaining
- Lockout timer displayed to user
- Resets on successful login

### Role-Based Redirects

| Role            | Dashboard                 |
| --------------- | ------------------------- |
| SUPERADMIN      | superadmin-dashboard.html |
| CAPTAIN         | captain-dashboard.html    |
| SK_OFFICIAL     | sk-dashboard.html         |
| YOUTH_VOLUNTEER | youth-dashboard.html      |

### If profile incomplete

- Missing any of: contactNumber, address, gender, birthday (or birthday = 2000-01-01 placeholder)
- Redirects to complete-profile.html instead of dashboard

---

## 4. Complete Profile (complete-profile.html)

**What happens:** First-time users (or those with incomplete profiles) must fill in required fields before accessing the system.

### Functions

- **loadUserData()** - Gets current session, populates form from User_Tbl
- **Age validation** - Calculates age from birthday, minimum 15 years old
- **formatName(name)** - Title Case formatting
- **Form submission** - Updates User_Tbl with all profile fields

### Required Fields & Validation

| Field          | Validation Rule                                         |
| -------------- | ------------------------------------------------------- |
| First Name     | Min 2 characters                                        |
| Last Name      | Min 2 characters                                        |
| Birthday       | Must be 15+ years old                                   |
| Contact Number | Exactly 11 digits, starts with "09" (Philippine format) |
| Gender         | Required (Male, Female, Other, Prefer not to say)       |
| Address        | Minimum 10 characters                                   |

### After completion

- Updates User_Tbl with all fields
- Clears `profile_incomplete` flag from sessionStorage
- Logs action: "User completed profile setup"
- Redirects to role-appropriate dashboard

---

## 5. Forgot Password (forgot-password.html)

**What happens:** User requests a password reset code.

### Functions

- **isValidEmail(email)** - Email validation
- **Form submission** - Calls two RPCs then sends reset email

### Security Features

- **Rate limiting (server-side):** `check_password_reset_allowed(p_email)` RPC - max 3 requests per 15 minutes
- **Account check:** `check_account_status(p_email)` RPC - verifies account exists and is ACTIVE
- **Email enumeration prevention:** Shows generic "If an account exists, we've sent a code" message regardless of whether email exists

### After submission

- Stores email in `sessionStorage.reset_email`
- Redirects to reset-password.html

---

## 6. Reset Password (reset-password.html)

**What happens:** Two-step process: verify OTP code, then set new password.

### Step 1: OTP Verification

- 6-digit code input with auto-focus navigation
- 10-minute countdown timer
- Resend button with 60-second cooldown
- Calls `supabaseClient.auth.verifyOtp({email, token, type: 'recovery'})`

### Step 2: New Password

- Same 5-requirement complexity rules as signup
- Real-time checklist with visual feedback
- Confirm password must match
- Calls `supabaseClient.auth.updateUser({password})`

### After successful reset

- Logs action: "User reset password"
- Signs out the user (forces re-login with new password)
- Clears reset_email from sessionStorage
- Redirects to login.html

---

## 7. Public Landing Page (index.html)

**What happens:** The public-facing page anyone can see without logging in.

### Functions

- **loadProjects()** - Fetches APPROVED projects from Pre_Project_Tbl
- **filterProjects(status)** - Filters by 'all', 'ongoing', 'completed'
- **renderProjectPage()** - Displays 3 projects per page with pagination
- **createProjectCard(project)** - Builds project card with status badge
- **loadTestimonials()** - Fetches featured testimonies (isFiltered=true) with user info
- **createTestimonyCard(t)** - Builds testimony card with avatar, rating, text preview
- **openTestimonyModal(testimonyId)** - Opens full testimony in modal
- **initCarousel(testimonies)** - Responsive carousel (1/2/3 items based on screen size, auto-slides every 5 seconds)
- **loadBudgetData()** - Fetches annual budget by category with progress bars
- **loadProjectMetrics()** - Calculates project stats (total, completed, success rate)
- **loadPublishedFiles()** - Fetches downloadable public files (from File_Tbl where isPublished=true)
- **downloadFile(filePath, fileName)** - Downloads file from Supabase storage
- **sanitizeImageURL(url)** - Only allows Supabase and Google image domains

### Tables Used

| Table             | What it shows                    |
| ----------------- | -------------------------------- |
| Pre_Project_Tbl   | Approved community projects      |
| Testimonies_Tbl   | Featured user testimonials       |
| Annual_Budget_Tbl | Budget transparency data         |
| File_Tbl          | Published downloadable documents |

### Security

- No authentication required
- Image URL whitelist (only Supabase + Google domains)
- All user content HTML-escaped
- Content Security Policy (CSP) headers in meta tag

---

## Google OAuth Flow

1. User clicks "Sign in with Google" on login.html or signup.html
2. `supabaseClient.auth.signInWithOAuth({provider: 'google'})` starts OAuth
3. Google authenticates, redirects back to index.html
4. `handleGoogleAuthCallback()` runs:
   - Checks if user exists in User_Tbl
   - **New user:** Creates User_Tbl row with Google avatar, placeholder birthday (2000-01-01), auto-accepted terms, role=YOUTH_VOLUNTEER
   - **Existing user:** Validates account status and profile completeness
5. Redirects to complete-profile.html (if new/incomplete) or dashboard (if complete)

---

## Session Management (SessionManager - js/auth/session.js)

The SessionManager is the gatekeeper imported on every protected page.

### Key Functions

- **init(allowedRoles)** - Checks auth, verifies role, handles redirects
- **requireAuth(allowedRoles)** - Enforces authentication (redirects to login if no session)
- **setupIdleTimeout()** - Auto-logout after 30 minutes of inactivity
- **redirectByRole(role)** - Sends user to their role's dashboard
- **logout()** - Signs out, clears all localStorage, redirects to login
- **hasRole(roles)** - Checks if user has any of the specified roles

### What it checks on every page load

1. Is there an active Supabase session?
2. Does the user exist in User_Tbl?
3. Is accountStatus = 'ACTIVE'?
4. Is the user's role in the allowed roles for this page?
5. Is the profile complete?

If any check fails, the user is redirected appropriately.

### Idle Timeout

- 30 minutes of no mouse/keyboard/scroll activity
- Automatically logs out the user
- Clears localStorage

---

## Security Summary

| Feature                      | How it works                                                        |
| ---------------------------- | ------------------------------------------------------------------- |
| Password Complexity          | 5 requirements: 8+ chars, uppercase, lowercase, digit, special char |
| Login Lockout                | 5 failed attempts = 15-minute lockout (localStorage per email)      |
| Email Verification           | 6-digit OTP, 10-minute expiry, 60-second resend cooldown            |
| Password Reset Rate Limit    | Max 3 requests per 15 minutes (server-side RPC)                     |
| Email Enumeration Prevention | Generic success message regardless of email existence               |
| Session Timeout              | 30 minutes idle = auto-logout                                       |
| Profile Completion Gate      | Must fill all required fields before accessing dashboard            |
| Age Restriction              | Minimum 15 years old                                                |
| Role-Based Access            | Each page checks allowed roles on load                              |
| XSS Prevention               | escapeHTML() on all user content, sanitizeImageURL() for images     |
| CSP Headers                  | Content Security Policy restricts what can load on pages            |
| PKCE Auth Flow               | Supabase PKCE flow for CSRF protection                              |

---

## Database Tables Involved in Auth

| Table                    | Role in Auth                                                                              |
| ------------------------ | ----------------------------------------------------------------------------------------- |
| Supabase Auth (built-in) | Stores email, password hash, session tokens, email_confirmed_at                           |
| User_Tbl                 | Profile data: name, birthday, contact, gender, address, role, accountStatus, imagePathURL |
| SK_Tbl                   | SK Official position and term dates (linked to User_Tbl)                                  |
| Captain_Tbl              | Captain role tracking (linked to User_Tbl)                                                |

### User_Tbl Key Fields

- **userID** - Matches Supabase auth user ID
- **role** - SUPERADMIN, CAPTAIN, SK_OFFICIAL, or YOUTH_VOLUNTEER
- **accountStatus** - ACTIVE, INACTIVE, or PENDING
- **firstName, lastName, middleName** - Stored in Title Case
- **birthday** - Date, must be 15+ years old, placeholder 2000-01-01 means "not set"
- **contactNumber** - 11-digit Philippine format starting with 09
- **gender** - Male, Female, Other, Prefer not to say
- **address** - Min 10 characters
- **imagePathURL** - Profile picture URL (Supabase storage or Google avatar)

---

## Quick Q&A

**Q: What role does a new user get?**

> Always YOUTH_VOLUNTEER. Only a SUPERADMIN can promote to SK_OFFICIAL or CAPTAIN.

**Q: What if someone forgets their password?**

> forgot-password.html sends a 6-digit OTP (max 3 requests per 15 min). They enter the code on reset-password.html, then set a new password meeting all 5 complexity requirements.

**Q: What stops brute force attacks?**

> Login lockout after 5 failed attempts (15-minute cooldown). Password reset rate-limited to 3 per 15 min server-side. OTP codes expire in 10 minutes.

**Q: How does Google login work?**

> OAuth flow via Supabase. New Google users auto-get a User_Tbl row with placeholder data, then must complete their profile before accessing anything.

**Q: What is the idle timeout?**

> 30 minutes of no activity = automatic logout. SessionManager monitors mouse, keyboard, and scroll events.

**Q: What happens if an account is deactivated?**

> Login check reads accountStatus from User_Tbl. INACTIVE accounts are blocked at login with an error message. Only SUPERADMIN can reactivate.

---

### Security Deep Dives (Mr. Ollanda - Network Security)

**Q: What is PKCE and why did you use it instead of the standard OAuth flow?**

> PKCE (Proof Key for Code Exchange) prevents authorization code interception attacks. In a browser-based app with no backend server, the standard OAuth flow is vulnerable because the authorization code travels through the browser. PKCE adds a code_verifier/code_challenge pair so even if an attacker intercepts the code, they can't exchange it for a token without the verifier. Supabase enables PKCE by default for our client-side auth.

**Q: What happens if someone steals a user's JWT token?**

> The token has a limited lifetime (Supabase default 1 hour), and our 30-minute idle timeout logs the user out even sooner. Even with a stolen token, RLS policies still restrict what data they can access based on the role embedded in the token. The attacker cannot escalate privileges because role is read from the DB-level `auth.jwt()` claim, not from anything the client controls.

**Q: Your login lockout uses localStorage — can't an attacker just clear it?**

> The lockout is actually enforced server-side via the `check_login_allowed` RPC function in the database. The localStorage display is just for UX (showing the countdown timer to the user). Even if someone clears localStorage, the database still blocks the login attempt until the lockout period expires.

**Q: How do you prevent clickjacking?**

> Every one of our 22 pages includes a Content Security Policy meta tag with `frame-ancestors 'none'`, which prevents the site from being embedded in any iframe. This blocks clickjacking attacks where an attacker overlays our login page inside a malicious site.

**Q: How do you protect passwords at rest and in transit?**

> In transit: all communication with Supabase uses HTTPS/TLS encryption. In rest: Supabase Auth uses bcrypt hashing for passwords — we never store or see plaintext passwords. The hash is stored in Supabase's internal `auth.users` table, which is not accessible through our client or even through RLS policies.

**Q: What if someone tries to bypass the frontend and call your Supabase API directly?**

> Every table has Row Level Security (RLS) policies that check the authenticated user's role from the JWT. Even if someone uses Postman or curl with a valid token, they can only access data their role permits. A YOUTH_VOLUNTEER token cannot update `User_Tbl.role` or delete other users' data — the DB rejects it regardless of how the request is made.

**Q: How do you prevent session hijacking?**

> Supabase tokens use secure, HttpOnly attributes when possible. Our SessionManager validates the session against the database on every page load — checking that the user still exists, is still ACTIVE, and still has the correct role. If any of these change (e.g., SUPERADMIN deactivates the account), the session is immediately invalidated even if the token hasn't expired.

**Q: Can you map your auth protections to the OWASP Top 10?**

> Yes: (1) Broken Access Control → RLS + role checks at 3 layers; (2) Cryptographic Failures → bcrypt + HTTPS; (3) Injection → parameterized queries via Supabase SDK; (4) Insecure Design → principle of least privilege, YOUTH_VOLUNTEER default role; (5) Security Misconfiguration → CSP headers on all pages; (6) Vulnerable Components → SRI hashes on CDN scripts; (7) Authentication Failures → PKCE, lockout, OTP expiry; (8) Data Integrity Failures → server-side validation, DB constraints; (9) Logging Failures → 56 log points, audit trail with retention; (10) SSRF → not applicable (no server-side requests from our frontend).

---

### Architecture & Design (Prof. Estrella - Web Dev Expert)

**Q: Why did you use OTP codes instead of email magic links for verification?**

> OTP codes are more user-friendly — the user stays on our site and just enters 6 digits. Magic links require switching to email, clicking a link, and dealing with potential link expiry or spam filter issues. OTPs also work better on mobile where switching apps is disruptive. Supabase supports both; we chose OTP for better UX.

**Q: Why vanilla JavaScript instead of a framework like React for auth forms?**

> Our auth pages are straightforward forms with validation — they don't have complex state management or component reuse that would justify a framework. Vanilla JS means zero build step, faster page loads, and the team could focus on learning Supabase rather than a framework. For this project scope, a framework would add complexity without proportional benefit.

**Q: How does your session management scale if you had thousands of users?**

> SessionManager checks are lightweight — one Supabase `getSession()` call (local token check) and one `User_Tbl` query per page load. Supabase handles connection pooling and token validation at scale. The idle timeout is purely client-side (event listeners), so it adds zero server load. The main scaling concern would be the `User_Tbl` lookup, which is indexed on the primary key (userID).

**Q: What happens if a user opens multiple tabs — do they share session state?**

> Yes. Supabase stores the session token in localStorage, which is shared across tabs on the same origin. If one tab logs out, all tabs lose the session on their next page load or API call. The idle timeout runs independently per tab, but since logout clears localStorage, all tabs are affected.

**Q: Why do you check profile completeness on every login instead of just once?**

> A SUPERADMIN could update a user's record (e.g., clear their contact number), or a database migration could add new required fields. Checking on every login ensures no user accesses the dashboard with an incomplete profile, regardless of how the data changed. It's a single query that adds negligible overhead.

**Q: How would you add two-factor authentication (2FA) in the future?**

> Supabase Auth supports TOTP-based MFA (authenticator apps). We would enable it in Supabase config, add an enrollment page where users scan a QR code, and add a TOTP verification step after password login. The OTP infrastructure we already built (6-digit input, timer, verification flow) could be reused for the TOTP entry screen.

---

### Requirements & Process (Prof. Eleazar - Course Instructor)

**Q: Does your implementation match the auth flow described in your SDD?**

> The core flow matches: signup, email verification, login, role-based redirect. We added features not in the original SDD: login lockout system, idle timeout, profile completion gate, and the SUPERADMIN role. These were added based on security best practices and client feedback. We documented these as scope additions.

**Q: Why is the minimum age 15? Is that a client requirement?**

> Yes. The system is for SK (Sangguniang Kabataan) which serves youth aged 15-30. The 15-year minimum is a real-world constraint from our client, Ms. Villaroman, based on the SK Reform Act (RA 11768) age requirement for youth participation.

**Q: How did you handle the tech stack change from your original SDD?**

> The original SDD specified Next.js + PHP + MySQL. We switched to HTML + Vanilla JS + Supabase (PostgreSQL) because: (1) Supabase provides built-in auth, RLS, and storage — eliminating the need for a custom backend; (2) the team had limited time and Supabase reduced development effort significantly; (3) PostgreSQL RLS gives us database-level security that PHP middleware cannot match. All auth features from the SRS are still fully implemented.

**Q: What SRS requirements does the auth system fulfill?**

> The auth system covers: user registration (SRS FR-01), login/authentication (SRS FR-02), password recovery (SRS FR-03), role-based access control (SRS FR-04), session management (SRS NFR-01 security), and profile management. Every functional requirement related to user access has a corresponding implementation in our auth pages.

**Q: What would you improve about the auth system if you had more time?**

> Three things: (1) Add TOTP-based 2FA for higher-privilege accounts (SUPERADMIN, CAPTAIN); (2) Move login lockout tracking to a dedicated DB table with IP address logging for better audit trails; (3) Add email notifications when suspicious activity is detected (e.g., login from new device, multiple failed attempts).
