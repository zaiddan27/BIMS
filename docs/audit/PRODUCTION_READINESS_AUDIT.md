# BIMS Production Readiness Audit

**Date:** 2026-02-21
**Auditor:** Claude (AI-assisted comprehensive audit)
**Scope:** Full codebase — Security, Performance, Maintainability, Accessibility
**Verdict:** NOT READY for production. 7 critical, 14 high, 19 medium, 12 low findings.

---

## TABLE OF CONTENTS

1. [Executive Summary](#1-executive-summary)
2. [CRITICAL Findings (Fix Before Deploy)](#2-critical-findings)
3. [HIGH Findings (Fix Before Deploy)](#3-high-findings)
4. [MEDIUM Findings (Fix Soon After Deploy)](#4-medium-findings)
5. [LOW Findings (Improve Over Time)](#5-low-findings)
6. [Positive Findings (Things Done Well)](#6-positive-findings)
7. [Implementation Plan](#7-implementation-plan)

---

## 1. EXECUTIVE SUMMARY

| Category | Critical | High | Medium | Low | Total |
|----------|----------|------|--------|-----|-------|
| Security | 3 | 6 | 5 | 2 | 16 |
| Performance | 2 | 3 | 4 | 2 | 11 |
| Maintainability | 2 | 3 | 3 | 2 | 10 |
| Accessibility | 0 | 2 | 2 | 2 | 6 |
| **Total** | **7** | **14** | **14** | **8** | **43** |

### Files Audited
- 22 HTML application pages
- 4 test HTML files (to be deleted)
- 1 demo file (to be deleted)
- 8 JavaScript modules (`js/` directory)
- 1 CSS file (`css/responsive.css`)
- 16 SQL migration files
- 1 RLS reference file

### Codebase Size
- ~47,000 lines total across all files
- Largest files: `responsive.css` (6,210), `sk-archive.html` (4,744), `sk-projects.html` (4,631)

---

## 2. CRITICAL FINDINGS

> These MUST be fixed before deploying to production.

---

### C1. Users Can Self-Escalate Their Own Role
**Category:** Security — RLS Privilege Escalation
**File:** `supabase/rls-policies.sql` lines 136–144

The `User_Tbl` UPDATE policy allows users to update their own row with NO column restrictions. A malicious user can open the browser console and run:

```javascript
// Any youth volunteer can promote themselves to SK_OFFICIAL or CAPTAIN
supabaseClient.from('User_Tbl').update({ role: 'SK_OFFICIAL' }).eq('userID', myId)
// Or bypass admin approval:
supabaseClient.from('User_Tbl').update({ accountStatus: 'ACTIVE' }).eq('userID', myId)
```

The `role` and `accountStatus` columns have CHECK constraints that validate the VALUE is valid, but nothing prevents the USER from changing them.

**Fix:** Create a PostgreSQL trigger that prevents non-admin users from changing `role` or `accountStatus`:

```sql
CREATE OR REPLACE FUNCTION prevent_role_escalation()
RETURNS TRIGGER AS $$
BEGIN
  -- Only SUPERADMIN can change role or accountStatus
  IF (OLD."role" IS DISTINCT FROM NEW."role" OR OLD."accountStatus" IS DISTINCT FROM NEW."accountStatus") THEN
    IF NOT EXISTS (
      SELECT 1 FROM "User_Tbl" WHERE "userID" = auth.uid() AND "role" = 'SUPERADMIN'
    ) THEN
      NEW."role" := OLD."role";
      NEW."accountStatus" := OLD."accountStatus";
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER enforce_role_protection
BEFORE UPDATE ON "User_Tbl"
FOR EACH ROW EXECUTE FUNCTION prevent_role_escalation();
```

---

### C2. Test Files Deployed to Production
**Category:** Security — Information Disclosure
**Files:**
- `test-auth.html` — Full interactive auth testing (signup, login, OTP, reset)
- `test-supabase-connection.html` — Probes database connection
- `test-projects.html` — Queries project data
- `test-image-load.html` — Tests storage access
- `DEMO_INSTRUCTIONS.html` — Internal demo guide
- `js/test/test-database.js` — Runs automated DB queries (SELECT * on tables, lists storage buckets)

Anyone who visits these URLs on your live site can probe your authentication system, database structure, and storage buckets.

**Fix:** Delete all test files and add exclusions to `.gitignore`.

---

### C3. NODE_ENV Permanently Set to 'development'
**Category:** Security — Debug Mode in Production
**File:** `js/config/env.js` line 18

```javascript
NODE_ENV: 'development', // 'development' or 'production'
```

This is a static file — there is no build step to swap this. Every page runs in "development" mode forever, which may affect logging behavior and exposes debug information.

**Fix:** Change to `'production'`.

---

### C4. Tailwind CSS Loaded via Development CDN
**Category:** Performance — Not Production-Ready
**Found in:** All 25 HTML files

```html
<script src="https://cdn.tailwindcss.com"></script>
```

The Tailwind team explicitly says this is for development only. It:
- Downloads and compiles the ENTIRE Tailwind framework (~300KB JS) on every page load
- Compiles all CSS at runtime in the browser
- Causes visible Flash of Unstyled Content (FOUC)
- Cannot be cached effectively

**Fix:** Use the Tailwind CLI to generate a compiled CSS file:
```bash
npx tailwindcss -o css/tailwind.min.css --minify
```
Then replace the CDN script with:
```html
<link href="css/tailwind.min.css" rel="stylesheet">
```

---

### C5. Zero SRI Hashes on Any CDN Resource
**Category:** Security — Supply Chain Attack Vulnerability
**Found in:** All HTML files

None of the 7 CDN libraries have Subresource Integrity (SRI) hashes:

| Library | CDN | Version |
|---------|-----|---------|
| Tailwind CSS | cdn.tailwindcss.com | Unversioned (floating) |
| Supabase JS | cdn.jsdelivr.net | @2 (floating major) |
| jsPDF | cdnjs.cloudflare.com | 2.5.1 |
| html2canvas | cdnjs.cloudflare.com | 1.4.1 |
| PDF.js | cdnjs.cloudflare.com | 3.11.174 |
| Cropper.js | cdnjs.cloudflare.com | 1.5.12 |
| Google Fonts | fonts.googleapis.com | N/A |

If any CDN is compromised, malicious JavaScript runs on every page of your app.

**Fix:** Add `integrity` and `crossorigin` attributes to all CDN `<script>` tags:
```html
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2.49.1"
        integrity="sha384-XXXX..."
        crossorigin="anonymous"></script>
```
Pin ALL versions (no `@2`, use `@2.49.1`). Generate hashes at srihash.org.

---

### C6. Massive Code Duplication (~5,000+ Lines)
**Category:** Maintainability — Unsustainable Codebase
**Scope:** Project-wide

| Duplicated Code | Copies | Lines Each | Total Wasted |
|----------------|--------|------------|-------------|
| `showToast()` function | 22 files | ~50 lines | ~1,100 lines |
| `escapeHTML()` function | 13 files | ~15 lines | ~195 lines |
| Sidebar navigation HTML | 14 files | ~100 lines | ~1,400 lines |
| Auth check boilerplate | 22 files | ~20 lines | ~440 lines |
| Avatar/profile loading | 10 files | ~40 lines | ~400 lines |
| Tailwind config block | 25 files | ~15 lines | ~375 lines |
| **Total** | | | **~3,910+ lines** |

A bug in `showToast()` must be fixed in 22 places. The XSS vulnerability in the toast function (see H1) exists in 22 separate copies.

**Fix:** Extract shared utilities into JS modules:
- `js/utils/toast.js` — single XSS-safe toast implementation
- `js/utils/sanitize.js` — `escapeHTML()`, `sanitizeImageURL()`
- `js/utils/logger.js` — production-aware logging
- `js/components/sidebar.js` — dynamic sidebar rendering per role

---

### C7. All Application Logic is Inline (Not Cacheable)
**Category:** Performance — Monolithic Files
**Scope:** Every HTML page

Every page contains 800–2,900 lines of inline `<script>`. This means:
- **Zero browser caching** of JavaScript between pages
- **Impossible to code-split** or lazy-load
- **Files are enormous:** sk-projects.html (4,631 lines), sk-archive.html (4,744 lines)

**Fix:** Extract page-specific logic into external JS files:
```
js/pages/sk-projects.js
js/pages/captain-dashboard.js
js/pages/youth-projects.js
...etc
```

---

## 3. HIGH FINDINGS

---

### H1. XSS via innerHTML in showToast() — 22 Files
**Category:** Security — Cross-Site Scripting
**Files:** All auth pages + all dashboard pages

```javascript
// Pattern in every showToast:
toast.innerHTML = `
  ${icon}
  <span class="flex-1">${message}</span>  // ← unescaped!
`;
```

The `message` parameter is injected into `innerHTML` without escaping. If an error message from Supabase contains HTML, it executes. Only `index.html` properly uses `escapeHTML(message)`.

**Fix:** Use `textContent` for the message, or escape it:
```javascript
<span class="flex-1">${escapeHTML(message)}</span>
```

---

### H2. XSS via innerHTML with User Data — Multiple Pages
**Category:** Security — Cross-Site Scripting (Stored)
**Files and examples:**

| File | Line | Vulnerable Data |
|------|------|----------------|
| `captain-dashboard.html` | 1272 | `captainProfile.imagePathURL` in innerHTML |
| `captain-dashboard.html` | 2631 | `User_Tbl.firstName`/`lastName` in innerHTML |
| `sk-archive.html` | 3615, 3654 | `userProfile.profilePicture` in innerHTML |
| `youth-certificates.html` | 761 | `profileImageUrl` in innerHTML |
| `superadmin-user-management.html` | 1484 | toast `${message}` |
| `superadmin-dashboard.html` | 666 | toast `${message}` |
| `superadmin-activity-logs.html` | 726 | toast `${message}` |
| `ProfileModal.js` | 329 | `this.userProfile.profilePicture` in innerHTML |

If a malicious user registers with name `<img src=x onerror=alert(document.cookie)>`, it executes wherever that name is rendered via innerHTML.

**Fix:** Apply `escapeHTML()` to ALL user-derived data before innerHTML. For image URLs, use `createElement('img')` + `setAttribute('src', url)` instead of string interpolation.

---

### H3. Notification_Tbl INSERT Allows Targeting Any User
**Category:** Security — RLS Abuse
**File:** `supabase/rls-policies.sql` line 336

```sql
CREATE POLICY "auth_insert_notifications"
ON "Notification_Tbl" FOR INSERT TO authenticated
WITH CHECK (true);  -- ← Any user can notify ANY other user
```

A malicious authenticated user can spam every other user's notification inbox.

**Fix:**
```sql
WITH CHECK (
  "userID" = (select auth.uid())
  OR is_sk_official_or_captain()
)
```
Or remove direct INSERT access and use a `SECURITY DEFINER` function for creating notifications.

---

### H4. Supabase Debug Logging on Every Page Load
**Category:** Security — Information Disclosure
**File:** `js/config/supabase.js` lines 45–68, 72

```javascript
console.log('Project URL:', ENV.SUPABASE_URL);
console.log('API Key configured:', ENV.SUPABASE_ANON_KEY ? 'Yes' : 'No');
window.testSupabaseConnection = testSupabaseConnection; // ← globally callable
```

Every page load prints infrastructure details. Anyone can call `testSupabaseConnection()` from the console.

**Fix:** Delete the `testSupabaseConnection` function and remove all `console.log` statements from `supabase.js`.

---

### H5. 500+ Console.log Statements Across Codebase
**Category:** Security — Information Disclosure
**Scope:** All JS files + all HTML inline scripts

| Location | Count | Sensitive Data Logged |
|----------|-------|-----------------------|
| `js/components/ProfileModal.js` | 39 | Profile data, upload URLs |
| `js/auth/auth.js` | 23 | Login attempts, emails |
| `js/auth/session.js` | 20 | User IDs, emails, roles, account status |
| `js/auth/google-auth-handler.js` | 17 | OAuth tokens, redirect info |
| `js/config/supabase.js` | 10 | Project URL, API key status |
| `js/components/NotificationModal.js` | 8 | Notification data |
| Inline JS (all HTML files) | 345+ | Query results, user data, errors |
| `js/test/test-database.js` | 45 | Full table dumps |
| **Total** | **~507** | |

Examples of sensitive data logged:
```javascript
console.log('[AUTH] Fetching user data for:', user.id, user.email);
console.log('[AUTH] User role:', userRole, '| Status:', accountStatus);
console.log('[AUTH] Required roles:', allowedRoles);
```

**Fix:** Remove all console.log/warn/error statements, or create a logger utility:
```javascript
// js/utils/logger.js
const Logger = {
  debug: ENV.NODE_ENV === 'development' ? console.log.bind(console) : () => {},
  error: console.error.bind(console),
};
```

---

### H6. Client-Side Login Lockout is Bypassable
**Category:** Security — Brute Force Protection
**File:** `js/auth/auth.js` lines 335–386

The 5-attempt lockout uses `localStorage`. Cleared by: incognito window, clearing localStorage, different browser, or a single DevTools command.

**Fix:** Supabase Auth has built-in server-side rate limiting. Document this reliance. The client-side lockout can remain for UX but should not be considered a security measure.

---

### H7. sk-archive.html Has No Authentication Guard
**Category:** Security — Missing Auth Check
**File:** `sk-archive.html`

The page includes `session.js` but never calls `SessionManager.init()` or `requireAuth()`. The page UI renders for anyone, though RLS still protects data.

**Fix:** Add auth check in the DOMContentLoaded handler:
```javascript
await SessionManager.init(['SK_OFFICIAL', 'CAPTAIN']);
```

---

### H8. Render-Blocking Scripts in Every Page
**Category:** Performance — Slow Page Load
**Found in:** All 22 application pages

Every page loads 6 synchronous scripts in `<head>` before any HTML paints:

```html
<script src="https://cdn.tailwindcss.com"></script>          <!-- ~300KB -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>  <!-- ~80KB -->
<script src="js/config/env.js"></script>
<script src="js/config/supabase.js"></script>
<script src="js/auth/auth.js"></script>
<script src="js/auth/session.js"></script>
```

**Fix:** Add `defer` to scripts that don't need to run before DOM parse. Move non-critical scripts to before `</body>`.

---

### H9. N+1 Query Pattern in sk-projects.html
**Category:** Performance — Excessive API Calls
**File:** `sk-projects.html` lines 1994–2002

```javascript
// For EACH project, fires 3 additional API calls:
projects = await Promise.all(projectsData.map(async (project) => {
  const applications = await loadProjectApplications(project.preProjectID);
  const inquiries = await loadProjectInquiries(project.preProjectID);
  const budgetBreakdown = await loadProjectBudgetBreakdown(project.preProjectID);
}));
```

20 projects = 60+ API calls instead of using Supabase's built-in JOIN syntax:
```javascript
.from('Pre_Project_Tbl')
.select('*, Application_Tbl(*), Inquiry_Tbl(*), BudgetBreakdown_Tbl(*)')
```

**Fix:** Use Supabase's nested `select()` for joins. Also fix sequential INSERT loops (lines 3560–3569, 4443–4453) — use single batch inserts.

---

### H10. Inquiry_Tbl and Reply_Tbl Readable by All Authenticated Users
**Category:** Security — Data Exposure
**File:** `supabase/rls-policies.sql` lines 297–299, 309–311

```sql
-- Any logged-in user can read ALL inquiries from ALL users
CREATE POLICY "auth_select_inquiries"
ON "Inquiry_Tbl" FOR SELECT TO authenticated
USING (true);
```

A youth volunteer can read every other volunteer's private inquiries.

**Fix:**
```sql
USING (
  "userID" = (select auth.uid())
  OR is_sk_official_or_captain()
)
```

---

### H11. No ARIA Attributes on Any Modal
**Category:** Accessibility — Screen Reader Inaccessible
**Scope:** All 22 pages with modals

Zero instances of `role="dialog"`, `aria-modal`, `aria-hidden`, or `aria-labelledby`. Every modal is a plain `<div class="hidden">`.

**Fix:** Add to every modal:
```html
<div role="dialog" aria-modal="true" aria-labelledby="modalTitle" ...>
```

---

### H12. No Focus Trapping or Keyboard Navigation
**Category:** Accessibility — Keyboard Inaccessible
**Scope:** All modals project-wide

When modals open, keyboard focus is not trapped within them. Users can Tab into background content. Escape key doesn't close modals.

**Fix:** Implement a focus trap utility for all modals.

---

### H13. User Role Trusted from localStorage
**Category:** Security — Trust Boundary
**File:** `js/auth/session.js` lines 122–125, 289, 316

Role is stored in `localStorage` and read back by `getUserRole()` and `hasRole()`. While `SessionManager.init()` verifies from DB on page load, any code that calls `getUserRole()` without first calling `init()` gets the potentially tampered localStorage value.

**Fix:** Add a comment documenting that localStorage values are for display only. Ensure every page calls `init()` before any role-based logic. All authorization is enforced by RLS (server-side), which is the real security boundary.

---

### H14. 1,822 `!important` Declarations in responsive.css
**Category:** Maintainability — CSS Specificity War
**File:** `css/responsive.css` (6,210 lines)

Nearly every rule uses `!important` to override Tailwind's utility classes. This makes maintenance extremely difficult and indicates the responsive approach is fighting the framework rather than working with it.

**Fix:** After moving to compiled Tailwind (C4), use Tailwind's responsive prefixes (`sm:`, `md:`, `lg:`) instead of a separate responsive stylesheet. This could replace most of the 6,210 lines.

---

## 4. MEDIUM FINDINGS

---

### M1. Google OAuth Auto-Activates Accounts
**File:** `js/auth/google-auth-handler.js` line 127
Google OAuth users get `accountStatus: 'ACTIVE'` immediately, bypassing the PENDING approval that email users go through.
**Fix:** Set to `'PENDING'` if admin approval is required, or document as an intentional design choice.

### M2. Inconsistent Logout Cleanup
**File:** `js/auth/auth.js` lines 198–200 vs `session.js` lines 272–274
`AuthService.logout()` only removes 2 of 4 localStorage items. `setupAuthListener` SIGNED_OUT handler misses `userID`.
**Fix:** Use `localStorage.clear()` consistently in all logout paths.

### M3. No Input Validation in signUp()
**File:** `js/auth/auth.js` lines 34–44
Only checks if fields are non-empty. No email format regex, no password complexity rules (beyond Supabase minimum), no phone format validation.
**Fix:** Add client-side validators for email, phone, and password strength.

### M4. Announcement_Tbl Public SELECT Has No Status Filter
**File:** `supabase/rls-policies.sql` lines 177–179
`USING (true)` exposes ALL announcements including drafts/archived. The original policy filtered by `contentStatus = 'ACTIVE'`.
**Fix:** If the table has a status column, re-add the filter. If not, this is acceptable.

### M5. Public Storage Buckets for Sensitive Documents
**File:** `supabase/migrations/002_create_storage_buckets.sql`
`general-files` and `project-files` buckets are `public = true`. Sensitive documents are accessible via URL without authentication.
**Fix:** Consider making these private if they may contain sensitive content.

### M6. 18 Instances of SELECT * Instead of Specific Columns
**Scope:** Multiple HTML files
Fetches all columns when only a subset is needed. `User_Tbl` queries fetch `contactNumber`, `address`, `birthday` unnecessarily for auth checks.
**Fix:** Replace with specific column lists.

### M7. Client-Side-Only Pagination on Data-Heavy Pages
**Files:** `sk-projects.html`, `sk-archive.html`, `youth-projects.html`, `sk-files.html`
Load ALL records then paginate in the browser. Only `superadmin-activity-logs.html` uses server-side `.range()`.
**Fix:** Implement server-side pagination with Supabase `.range(from, to)`.

### M8. Memory Leaks from Uncleared Intervals
**Files:** `sk-calendar.html:1239`, `youth-calendar.html:1213`, `sk-projects.html:4533`
`setInterval` calls never have matching `clearInterval`. The calendar pages run interval checks forever.
**Fix:** Store interval IDs and clear them on page unload.

### M9. Fragile onerror Handlers with Nested innerHTML
**Found in:** 9 HTML files
Pattern: `onerror="this.parentElement.innerHTML='<span>...</span>'"` — nesting innerHTML in HTML attributes is error-prone.
**Fix:** Use a separate JS function: `onerror="handleAvatarError(this, 'AB')"`.

### M10. Massive Inline `<style>` Blocks
**Worst offenders:** `sk-calendar.html` (~805 lines of CSS), `youth-calendar.html` (~805 lines)
Duplicated CSS that should be in external files.
**Fix:** Extract to `css/calendar.css`, `css/dashboard.css`, etc.

### M11. 201 Inline `style=""` Attributes
**Scope:** 20 HTML files (excluding email templates where inline styles are required)
**Fix:** Convert to Tailwind utility classes or CSS classes.

### M12. Color Contrast Concerns
`text-gray-400` on white backgrounds may fail WCAG AA. Certificate text `color: #6a5a4a` on parchment background needs verification.
**Fix:** Run an automated contrast checker (e.g., axe-core) and adjust colors.

### M13. env.js with Real Anon Key Committed to Git
**File:** `js/config/env.js`, `.gitignore`
The anon key is designed for client-side use (protected by RLS), but it's in git history permanently.
**Fix:** Add `js/config/env.js` to `.gitignore`, create `js/config/env.example.js` with placeholders, document setup in README.

### M14. Stale TODO Comments
**Files:** `sk-dashboard.html` line 1649, `env.js` line 9
Unresolved or misleading TODO comments left in code.
**Fix:** Resolve or remove.

---

## 5. LOW FINDINGS

---

### L1. No `<meta name="description">` on any page — Poor SEO
### L2. No `loading="lazy"` on any images — Unnecessary bandwidth
### L3. No skip-to-content navigation links — Accessibility
### L4. Mixed coding style (quotes, indentation) — Consistency
### L5. Role redirect mapping duplicated 3 times — `session.js` + `google-auth-handler.js`
### L6. No `package.json` — Cannot run dependency vulnerability scanning
### L7. `.gitignore` missing `test-*.html`, `js/test/`, `DEMO_INSTRUCTIONS.html`
### L8. Debug logging in HTML onerror attributes — `youth-dashboard.html` line 1239

---

## 6. POSITIVE FINDINGS (Things Done Well)

1. **No service_role key exposure** — Well-documented and enforced
2. **RLS enabled on ALL 19 tables** — No unprotected tables
3. **Helper functions use SECURITY DEFINER** — Proper privilege separation
4. **InitPlan optimization** — `(select auth.uid())` wrapping for performance
5. **Passwords never in public schema** — Handled by Supabase Auth
6. **Role verification queries the database** — Not relying solely on JWT
7. **Account status checks** — INACTIVE/PENDING users blocked at session level
8. **Profile picture validation** — File type and 5MB size limit enforced
9. **File upload path isolation** — `{userID}/{filename}` prevents overwrites
10. **DELETE policies well-restricted** — Applications only deletable when PENDING
11. **Captain_Tbl locked down** — `USING (false)` prevents direct modification
12. **No eval() or document.write()** — None found anywhere
13. **IIFE pattern in mobile-nav.js** — Proper encapsulation
14. **Object.freeze(ENV)** — Runtime modification prevented
15. **Supabase auto-refresh tokens** — `autoRefreshToken: true` configured

---

## 7. IMPLEMENTATION PLAN

### Phase 1: Security Hardening (MUST DO — Before Deploy)

**Estimated effort: 2–3 days**

| # | Task | Priority | Findings |
|---|------|----------|----------|
| 1.1 | Delete test files (`test-*.html`, `DEMO_INSTRUCTIONS.html`, `js/test/`) | CRITICAL | C2 |
| 1.2 | Update `.gitignore` to exclude test files and `env.js` | CRITICAL | C2, L7, M13 |
| 1.3 | Set `NODE_ENV` to `'production'` in `env.js` | CRITICAL | C3 |
| 1.4 | Create `prevent_role_escalation` trigger (SQL migration 016) | CRITICAL | C1 |
| 1.5 | Fix `Notification_Tbl` INSERT policy (SQL migration 016) | HIGH | H3 |
| 1.6 | Fix `Inquiry_Tbl` and `Reply_Tbl` SELECT policies (SQL migration 016) | HIGH | H10 |
| 1.7 | Add auth guard to `sk-archive.html` | HIGH | H7 |
| 1.8 | Remove `testSupabaseConnection` global export + all console.logs from `supabase.js` | HIGH | H4 |
| 1.9 | Remove ALL console.log/warn statements from production code | HIGH | H5 |
| 1.10 | Fix all showToast XSS — escape `${message}` in all 22 files | HIGH | H1 |
| 1.11 | Fix all innerHTML XSS with user data (names, image URLs) | HIGH | H2 |
| 1.12 | Fix inconsistent logout cleanup | MEDIUM | M2 |

### Phase 2: Performance Optimization (MUST DO — Before Deploy)

**Estimated effort: 3–4 days**

| # | Task | Priority | Findings |
|---|------|----------|----------|
| 2.1 | Install Tailwind CLI, compile to static CSS, replace CDN script in all 25 files | CRITICAL | C4 |
| 2.2 | Add SRI hashes + pin versions on ALL remaining CDN scripts | CRITICAL | C5 |
| 2.3 | Add `defer` attribute to non-critical `<script>` tags | HIGH | H8 |
| 2.4 | Fix N+1 queries — use Supabase nested select joins | HIGH | H9 |
| 2.5 | Replace `select('*')` with specific columns in 18 locations | MEDIUM | M6 |
| 2.6 | Add server-side pagination with `.range()` on data-heavy pages | MEDIUM | M7 |
| 2.7 | Fix memory leaks — clear intervals on page unload | MEDIUM | M8 |

### Phase 3: Code Cleanup & Maintainability (Should Do — Before/During Deploy)

**Estimated effort: 3–5 days**

| # | Task | Priority | Findings |
|---|------|----------|----------|
| 3.1 | Create `js/utils/toast.js` — single XSS-safe implementation | CRITICAL | C6, H1 |
| 3.2 | Create `js/utils/sanitize.js` — `escapeHTML()`, `sanitizeImageURL()` | CRITICAL | C6, H2 |
| 3.3 | Create `js/utils/logger.js` — production-aware logging utility | HIGH | H5 |
| 3.4 | Extract inline `<script>` blocks to external `js/pages/*.js` files | CRITICAL | C7 |
| 3.5 | Extract shared sidebar HTML into `js/components/sidebar.js` | HIGH | C6 |
| 3.6 | Extract shared `<style>` blocks to external CSS files | MEDIUM | M10 |
| 3.7 | Refactor `responsive.css` to use Tailwind responsive prefixes | HIGH | H14 |
| 3.8 | Remove stale TODO comments | LOW | M14 |
| 3.9 | Standardize coding style (quotes, indentation) | LOW | L4 |

### Phase 4: Accessibility & Polish (Should Do — After Deploy)

**Estimated effort: 1–2 days**

| # | Task | Priority | Findings |
|---|------|----------|----------|
| 4.1 | Add `role="dialog"`, `aria-modal`, `aria-labelledby` to all modals | HIGH | H11 |
| 4.2 | Implement focus trapping utility for modals | HIGH | H12 |
| 4.3 | Add `<meta name="description">` to all pages | LOW | L1 |
| 4.4 | Add `loading="lazy"` to dynamic images | LOW | L2 |
| 4.5 | Add skip-to-content links | LOW | L3 |
| 4.6 | Run color contrast audit with axe-core | MEDIUM | M12 |

### Phase 5: Deployment Setup

**Estimated effort: 1 day**

| # | Task | Priority | Notes |
|---|------|----------|-------|
| 5.1 | Create `env.example.js` with placeholder values | Required | For onboarding new devs |
| 5.2 | Create `package.json` with Tailwind as dev dependency | Required | For build step |
| 5.3 | Configure Netlify build command: `npx tailwindcss -o css/tailwind.min.css --minify` | Required | Automated CSS compilation |
| 5.4 | Configure Netlify `_redirects` for SPA-like behavior | Optional | Clean URLs |
| 5.5 | Set up Netlify environment variables if needed | Optional | Future configuration |
| 5.6 | Create `tailwind.config.js` (single source of truth) | Required | Replace 25 inline configs |

---

## DEPLOYMENT CHECKLIST

Before going live, every item must be checked:

- [ ] All test files deleted from repository
- [ ] `NODE_ENV` set to `production`
- [ ] `prevent_role_escalation` trigger deployed to Supabase
- [ ] `Notification_Tbl` INSERT policy fixed
- [ ] `Inquiry_Tbl`/`Reply_Tbl` SELECT policies fixed
- [ ] `sk-archive.html` has auth guard
- [ ] All `console.log` statements removed
- [ ] All `showToast()` functions escape HTML
- [ ] All `innerHTML` with user data uses `escapeHTML()`
- [ ] Tailwind compiled to static CSS (CDN script removed)
- [ ] SRI hashes on all CDN resources
- [ ] CDN library versions pinned (not floating)
- [ ] `testSupabaseConnection` removed from global scope
- [ ] `.gitignore` updated with test files, `env.js`
- [ ] Netlify deployment tested and verified
