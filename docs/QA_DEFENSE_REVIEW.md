# QA Defense Review — What Ryan, Brian & JC Need to Prepare

**Defense Date:** Monday, April 7, 2026
**Your Role During Demo:** You do NOT narrate. You sit ready for Q&A and answer testing questions from panelists.
**Your PPT Slides:** Slide 14 (Test Methodology) + Slides 15-16 (Sample Test Cases)

---

## 1. Your Assigned Responsibilities (from Defense Prep Plan)

| QA Member | Focus Area | What You Should Know Cold |
|-----------|-----------|--------------------------|
| **Ryan Paolo Espinosa** | Test Methodology + Test Cases | Testing approach, test case format, how bugs were found and fixed, test coverage |
| **Brian Louis Ralleta** | Document Compliance | Printed docs ready (SPMP, SRS, SDD, STD x2), evaluation forms, name tags, doc consistency |
| **JC Dre Gabriel Ledonio** | Cross-Document Consistency | Requirements traceability (SRS requirement -> implemented feature -> test case), tech stack change explanation |

---

## 2. What Panelists Will Ask YOU

Prof. Estrella (web dev focus) and Mr. Ollanda (security focus) will likely direct testing questions to the QA team. Be ready for these:

### Testing Strategy Questions

**Q: "What testing strategies did you use?"**
> Manual functional testing per module (Login, Content, Files, Projects, Superadmin). Each QA member was assigned specific page pairs (SK page + corresponding Youth page) for multi-role testing. We used a shared bug report sheet with severity levels (CRITICAL/HIGH/MEDIUM/LOW), console errors, and steps to reproduce.

**Q: "How many test cases did you write?"**
> Fill in from STD: "XX test cases across 5 modules — Login & Auth, Content Management, File Management, Project Management, and Superadmin."

**Q: "Did you do automated testing?"**
> No. We used manual functional testing with standardized test case templates. Given the scope (22 pages, 4 roles), manual testing with structured bug tracking was appropriate. We verified each feature under the correct user role and tested cross-role workflows end-to-end.

**Q: "How did you handle regression testing?"**
> After each bug fix, we re-tested the affected feature plus related features. For example, after fixing the file upload error (removing non-existent columns), we re-tested upload, edit, delete, and archive flows.

### Bug-Related Questions

**Q: "What were the most critical bugs found?"**
> Here are real bugs from the commit history — memorize at least 3:

| Bug | Severity | What Happened | How It Was Fixed | Commit |
|-----|----------|--------------|-----------------|--------|
| Superadmin pages stuck loading | CRITICAL | Auth.js script was missing from superadmin pages — pages never initialized | Added missing `auth.js` script tag | `38e74bf` |
| File upload error in sk-files | HIGH | Insert query referenced columns that don't exist in File_Tbl | Removed non-existent columns from the insert | `0359876` |
| Change password was fake | HIGH | Password change showed success toast but never actually called Supabase | Replaced fake toast with real `supabase.auth.updateUser()` call | `99a9214` |
| File edit buttons not working | HIGH | Functions defined inside module scope but onclick handlers needed window scope | Exposed functions to `window.*` | `220a750` |
| Announcement RLS wrong | MEDIUM | Captain could edit announcements (should be SK Officials only) | Fixed RLS policy to restrict to SK_OFFICIAL role | `f4b652c` |
| CSP blocking WebSocket | MEDIUM | Content Security Policy blocked Supabase realtime WebSocket connections | Added `wss://*.supabase.co` to CSP connect-src | `272c031` |
| Captain dashboard approve 400 error | HIGH | Approve button returned 400 error | Fixed RLS/RPC permissions for captain approval | `ea4cdd9` |
| Login lockout was client-side | MEDIUM | Lockout stored in localStorage (easily bypassed) | Moved to server-side `check_login_allowed` RPC with `Login_Attempts_Tbl` | `44f6d18` |

**Q: "How did you track bugs?"**
> Shared Google Sheet with columns: Bug ID, Date, Reporter, File, Severity, Description, Console Error, Steps to Reproduce, Status. Each QA member filed bugs from their assigned pages. Three QA reports were filed: Espinosa report, Ralleta report, Ledonio report — each fixed a batch of bugs.

**Q: "How did you prioritize bug fixes?"**
> CRITICAL (system broken / can't load page) was fixed immediately. HIGH (feature broken) was next priority. MEDIUM (incorrect behavior) and LOW (cosmetic) were batched.

### Security Testing Questions (Mr. Ollanda will ask these)

**Q: "How did you verify RLS policies work?"**
> We tested each role's data access: logged in as Youth Volunteer and attempted to access SK-only data — Supabase returns empty results (not an error). We verified 50+ RLS policies by testing CRUD operations under each of the 4 roles.

**Q: "Did you test for XSS?"**
> Yes. We verified that `escapeHTML()` is called on all user-generated content before rendering via `innerHTML`. Tested by entering `<script>alert('xss')</script>` in announcement titles, testimony messages, and inquiry fields — all rendered as plain text, not executed.

**Q: "Did you test login lockout?"**
> Yes. Entered wrong password 5 times — system locks the account for 15 minutes. This is enforced server-side via `check_login_allowed` RPC (checks `Login_Attempts_Tbl`), not localStorage — so it can't be bypassed by clearing browser data.

**Q: "Did you test session timeout?"**
> Yes. Left the system idle for 30+ minutes — auto-logout triggered. `session.js` checks inactivity and also verifies session validity against the database on every page load.

---

## 3. Slide 14 Content — Test Methodology (Ryan presents this)

```
Testing Approach:
  - Manual functional testing per module (Login, Content, Files, Projects, Superadmin)
  - Test cases follow standardized template (Test Case ID, Steps, Expected/Actual Result, Status)
  - Role-based testing: each feature tested under correct user role (4 roles)
  - Security testing: RLS policy verification, login lockout validation, XSS testing
  - Cross-browser testing: Chrome, Firefox, Edge
  - Multi-role workflow testing: project lifecycle across SK → Captain → Youth

Test Coverage:
  - XX test cases across 5 modules
  - 3 QA bug reports filed (Espinosa, Ralleta, Ledonio)
  - Bugs tracked via shared Google Sheet with severity classification
  - Regression testing after each fix

[Reference STD Section ___, page ___]
```

---

## 4. Slides 15-16 — Sample Test Cases (Ryan presents)

### Test Case 1: SA-L2 — Filter Activity Logs by Date (PASS after fix)
```
Test Case ID: SA-L2
Module: Superadmin - Activity Logs
Pre-condition: Logged in as Superadmin; logs exist across multiple dates

Step 1: Navigate to Activity Logs page
  Expected: Page loads with log entries → Actual: PASS

Step 2: Locate and click date filter
  Expected: Date picker appears → Actual: PASS

Step 3: Select a specific date (Feb 23, 2026)
  Expected: Only logs from that date shown → Actual: PASS (was FAIL initially)

Root Cause: Logs_Tbl was empty — no code called log_action RPC.
Fix: Added 56 logAction() calls across 19 pages + updated RPC schema.
```

### Test Case 2: AUTH-L1 — Login Lockout After 5 Failed Attempts
```
Test Case ID: AUTH-L1
Module: Login & Authentication
Pre-condition: Valid account exists, not currently locked

Step 1: Enter correct email, wrong password → Click login
  Expected: "Invalid credentials" error → Actual: PASS

Step 2: Repeat wrong password 4 more times (5 total)
  Expected: Account locked, error message shows lockout → Actual: PASS

Step 3: Try correct password while locked
  Expected: Still locked (15-min cooldown) → Actual: PASS

Step 4: Wait 15 minutes, try correct password
  Expected: Login succeeds → Actual: PASS

Security Note: Lockout is server-side (Login_Attempts_Tbl + check_login_allowed RPC),
not localStorage — cannot be bypassed by clearing browser data.
```

### Test Case 3: FILE-U1 — File Upload + Publish Flow
```
Test Case ID: FILE-U1
Module: File Management (SK Official)
Pre-condition: Logged in as SK Official

Step 1: Click upload, select a PDF file
  Expected: File uploads successfully → Actual: PASS (was FAIL — fixed column mismatch)

Step 2: Verify file appears in file list with "Unpublished" status
  Expected: File listed with correct name/type → Actual: PASS

Step 3: Click "Publish" on the file, type PUBLISH to confirm
  Expected: Typing confirmation modal appears, file status changes to Published → Actual: PASS

Step 4: Login as Youth Volunteer, check Youth Files page
  Expected: Published file visible and downloadable → Actual: PASS

Step 5: Login as SK, archive the file
  Expected: File moves to archive, no longer visible to Youth → Actual: PASS
```

---

## 5. Requirements Traceability (JC presents if asked)

| SRS Requirement | Implemented Feature | Test Case | Status |
|----------------|--------------------|-----------|---------| 
| User registration with OTP | signup.html + verify-otp.html | AUTH-S1 | PASS |
| Role-based login | login.html + session.js | AUTH-L1 | PASS |
| Announcement CRUD | sk-dashboard.html | CM-A1 | PASS |
| File upload/download/publish | sk-files.html + youth-files.html | FILE-U1 | PASS |
| Project lifecycle | sk-projects → captain-dashboard → youth-projects | PROJ-L1 | PASS |
| Volunteer applications | youth-projects.html + sk-projects.html | PROJ-A1 | PASS |
| Captain approval workflow | captain-dashboard.html | PROJ-C1 | PASS |
| Activity logging + audit trail | superadmin-activity-logs.html | SA-L2 | PASS |
| Login lockout (brute force) | login.html + Login_Attempts_Tbl | AUTH-L1 | PASS |
| Idle timeout (30 min) | session.js | AUTH-T1 | PASS |
| RLS enforcement (50+ policies) | All pages via Supabase | SEC-R1 | PASS |
| XSS prevention (escapeHTML) | All pages with user content | SEC-X1 | PASS |

---

## 6. Tech Stack Change Explanation (JC — if panelists ask)

**Question:** "Your SDD says Next.js + PHP + MySQL, but the system uses Supabase. Why?"

**Answer:**
> "During SE2 implementation, we evaluated the original tech stack and chose Supabase (PostgreSQL + built-in Auth + Storage) because it provides Row Level Security at the database level, eliminating the need for a separate backend server. This decision improved security and reduced development complexity while maintaining all functional requirements."

Key points:
- Supabase = relational SQL (PostgreSQL), not NoSQL
- RLS gives us 50+ security policies enforced at the DB level
- Built-in Auth with PKCE eliminates custom auth server
- Built-in Storage with bucket-level access control
- No separate backend to maintain = less attack surface

---

## 7. Document Compliance Checklist (Brian confirms these are ready)

- [ ] **2 printed copies** of SPMP
- [ ] **2 printed copies** of SRS
- [ ] **2 printed copies** of SDD
- [ ] **2 printed copies** of STD
- [ ] **2 copies** of SE2 evaluation forms
- [ ] **2 copies** of SE2 Revisions List
- [ ] **Signed Development Form from SE1** (both panelists + client signatures)
- [ ] **Individual name tags** (large, visible font) for all 9 members
- [ ] Google Docs shared to both panelists (neestrella@ust.edu.ph, adollanda@ust.edu.ph) — **by April 4**

---

## 8. During Q&A — Who Answers What

| Question Topic | Who Answers | Backup |
|---------------|-------------|--------|
| Testing methodology, test cases | **Ryan** | Brian |
| Bug details, what broke and how it was fixed | **Ryan** | JC |
| Document compliance, printed materials | **Brian** | Ryan |
| Requirements traceability (SRS -> feature -> test) | **JC** | Ryan |
| Tech stack change justification | **JC** | Jerome |
| Security testing (RLS, XSS, lockout) | **Ryan** | Jerome |

---

## 9. Quick Cheat Sheet — Numbers to Remember

| Metric | Value |
|--------|-------|
| Total HTML pages | 22 (+2 email templates) |
| Database tables | 20+ |
| RLS policies | 50+ |
| Activity log points | 56 calls across 19 pages |
| Storage buckets | 8 (5 public, 3 private) |
| User roles | 4 (Superadmin, Captain, SK Official, Youth Volunteer) + Visitor |
| Log retention | General: 90 days, Audit: 1 year |
| Login lockout | 5 attempts / 15 min cooldown |
| Idle timeout | 30 minutes |
| Bugs found and fixed | 30+ across 3 QA reports |
| Test cases | XX (fill from STD) |
