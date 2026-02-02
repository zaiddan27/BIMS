# BIMS DEV & QA Strategy — Road to Defense

> **Current Status:** 87% complete | **Today:** Feb 2, 2026 (Week 4)
> **Defense Week:** Week 12 (~Apr 6-11) | **Time Remaining:** ~8 weeks
> **Reference:** DeepWiki Overview — https://deepwiki.com/zaiddan27/BIMS/1-bims-overview

---

## Timeline Mapped to WCE Schedule

| Week | Dates | Class Expectations | BIMS Focus |
|------|-------|-------------------|------------|
| **4** (NOW) | Feb 2-7 | Finalize UAT questionnaire | Bug hunting + fixing (Claude-assisted) |
| **5** | Feb 9-14 | Long Quiz #1, Project Update 2 | Code Learning Week 1: Foundation Layer |
| **6** | Feb 16-21 | Testing strategies | Code Learning Week 2: Auth & Session Layer |
| **7** | Feb 23-28 | Writing test cases | Code Learning Week 3: Dashboard & Data Layer |
| **8** | Mar 2-7 | Test case consultation | Code Learning Week 4: Feature Pages |
| **9** | Mar 9-14 | Project consultation | Code Learning Week 5: Cross-Role Workflows |
| **10** | Mar 16-21 | PRELIM EXAM | Study + submit deliverables via Google Drive |
| **11** | Mar 30-Apr 5 | Easter Break | Mock defense + full system walkthrough |
| **12** | Apr 6-11 | **DEFENSE WEEK** | Defend |

---

## Week 4 — THIS WEEK (Feb 2-7)

**Theme: Bug Hunting & Fixing**

This week is dedicated to QA testing and fixing bugs using Claude. No code learning yet — just break things and fix things.

### Testing Accounts

| Role | Email | Password | Notes |
|------|-------|----------|-------|
| **Superadmin** | `malandaysk@gmail.com` | `sk.malanday2026` | Shared account |
| **Captain** | `captain.test@bims.ph` | `captain@2026` | Shared QA account (Gavin Santos) |
| **SK Official** | *Your own email* | *Your own password* | Each member creates their own, then Superadmin updates role to SK_OFFICIAL |
| **Youth Volunteer** | *Your own 2nd email* | *Your own password* | Each member creates their own, then Superadmin updates role to YOUTH_VOLUNTEER |

**Setup Steps:**
1. Create 2 accounts using your personal + UST email
2. Login as Superadmin (`malandaysk@gmail.com`)
3. Go to user management, change one account to SK_OFFICIAL
4. Change the other account to YOUTH_VOLUNTEER
5. After setup, indicate your accounts and assigned roles in the shared doc

### File Testing Assignments

Andrea Marie Pelias assigns files to each QA member. When assigning, **pair the SK page with its corresponding Youth page** for multi-role testing:

```
BIMS/
├── index.html                          # Landing page           — Assigned to: ________
├── login.html                          # Login                  — Assigned to: ________
├── signup.html                         # Registration           — Assigned to: ________
├── verify-otp.html                     # OTP verification       — Assigned to: ________
├── forgot-password.html                # Forgot password        — Assigned to: ________
├── reset-password.html                 # Reset password         — Assigned to: ________
├── complete-profile.html               # Profile completion     — Assigned to: ________
│
├── youth-dashboard.html                # Youth - Dashboard      — Assigned to: ________ ┐
├── sk-dashboard.html                   # SK - Dashboard         — Assigned to: ________ ┘ (same person)
│
├── youth-files.html                    # Youth - Files          — Assigned to: ________ ┐
├── sk-files.html                       # SK - Files             — Assigned to: ________ ┘ (same person)
│
├── youth-projects.html                 # Youth - Projects       — Assigned to: ________ ┐
├── sk-projects.html                    # SK - Projects          — Assigned to: ________ ┘ (same person)
│
├── youth-calendar.html                 # Youth - Calendar       — Assigned to: ________ ┐
├── sk-calendar.html                    # SK - Calendar          — Assigned to: ________ ┘ (same person)
│
├── youth-certificates.html             # Youth - Certificates   — Assigned to: ________
├── sk-testimonies.html                 # SK - Testimonies       — Assigned to: ________
├── sk-archive.html                     # SK - Archive           — Assigned to: ________
│
├── captain-dashboard.html              # Captain - Approvals    — Assigned to: ________
│
├── superadmin-dashboard.html           # Superadmin - Dashboard — Assigned to: ________
├── superadmin-user-management.html     # Superadmin - Users     — Assigned to: ________
├── superadmin-activity-logs.html       # Superadmin - Logs      — Assigned to: ________
```

### Bug Report Format

Use a shared Google Sheet/Doc:

| Bug ID | Date | Reporter | File | Severity | Description | Console Error (paste it) | Steps to Reproduce | Status |
|--------|------|----------|------|----------|-------------|--------------------------|-------------------|--------|
| BUG-001 | Feb 3 | Name | captain-dashboard.html | HIGH | Approve button 400 error | `Error approving project: {code: 400...}` | 1. Login as captain 2. Open project 3. Click approve | FIXED |

**Severity:** CRITICAL / HIGH / MEDIUM / LOW

---

## Code Learning Plan — Weeks 5 to 9

### How It Works

- **1 online meeting per week** — group walkthrough of that week's chunk
- **Remaining days** — async/individual study of assigned files
- **DeepWiki** as your reading companion — read the relevant section BEFORE the meeting
- **The code itself** — open each file, read it, trace the flow

### The Layered Approach

The code is learned **bottom-up**, from the foundation that everything depends on, up to the feature pages. Each week builds on the previous one. Think of it like floors of a building:

```
Week 9:  [Cross-Role Workflows]     ← How everything connects
Week 8:  [Feature Pages]            ← SK projects, youth certificates, etc.
Week 7:  [Dashboards & Data]       ← How pages load and render data
Week 6:  [Auth & Session]           ← Login, roles, protection
Week 5:  [Foundation]               ← Database, config, shared components
```

---

### Week 5 — Foundation Layer (Feb 9-14)

**Meeting Agenda:** Walk through the database schema and shared JS files together

**DeepWiki Reading:** BIMS Overview + Architecture sections

#### What to Study

| File | What It Does | Key Concepts |
|------|-------------|--------------|
| `supabase/migrations/001_create_schema.sql` | All database tables | Table relationships, column types, CHECK constraints |
| `supabase/migrations/003_row_level_security.sql` | Security policies | RLS = who can read/write what data |
| `supabase/migrations/005_captain_table.sql` | Captain term tracking | `designate_new_captain()` function |
| `js/config/env.js` | Supabase URL + API key | Environment configuration |
| `js/config/supabase.js` | Creates the Supabase client | `supabaseClient` — used by every page |
| `js/components/NotificationModal.js` | Notification bell component | ES module, `render()`, `toggle()`, fetches from `Notification_Tbl` |
| `js/components/ProfileModal.js` | Profile avatar component | ES module, `render()`, `open()`, `loadUserData()` |
| `js/mobile-nav.js` | Hamburger menu for mobile | DOM manipulation for responsive nav |

#### How to Study This Week

1. **Open `001_create_schema.sql`** — Draw a diagram of tables and their relationships:
   ```
   User_Tbl ──> SK_Tbl
            ──> Captain_Tbl
            ──> Application_Tbl ──> Pre_Project_Tbl
            ──> Inquiry_Tbl ──> Reply_Tbl
   Pre_Project_Tbl ──> Post_Project_Tbl ──> Evaluation_Tbl
                                         ──> Certificate_Tbl
   ```
2. **Open `003_row_level_security.sql`** — For each policy, ask: "Who can do what to which table?"
3. **Open `NotificationModal.js`** — Trace: Where is it imported? How does `render()` create HTML? How does `toggle()` show/hide it?
4. **Open `ProfileModal.js`** — Same approach. What does `loadUserData()` do?

#### Questions You Should Be Able to Answer After This Week

- What tables does BIMS use and how are they related?
- What is RLS and why do we need it?
- What does `supabaseClient` do and where is it created?
- How do NotificationModal and ProfileModal work as reusable components?

---

### Week 6 — Auth & Session Layer (Feb 16-21)

**Meeting Agenda:** Walk through the complete login-to-dashboard flow

**DeepWiki Reading:** Authentication section

#### What to Study

| File | What It Does | Key Concepts |
|------|-------------|--------------|
| `js/auth/auth.js` | Auth helper functions | `signUp()`, `signIn()`, `signOut()`, `getSession()` |
| `js/auth/session.js` | Session management | `SessionManager.requireAuth()`, role checking, redirect logic |
| `js/auth/google-auth-handler.js` | Google OAuth | OAuth callback handling |
| `login.html` | Login page | Form validation, calls `signIn()`, redirects by role |
| `signup.html` | Registration page | Form validation, calls `signUp()`, OTP flow |
| `verify-otp.html` | OTP verification | Token verification after email |
| `forgot-password.html` + `reset-password.html` | Password recovery | Reset flow via email |
| `complete-profile.html` | Profile completion after signup | Inserts into `User_Tbl` |
| `supabase/migrations/004_auth_sync_trigger.sql` | Auto-creates User_Tbl row on signup | Database trigger on `auth.users` |

#### How to Study This Week

1. **Trace the full flow:** signup.html → verify-otp.html → complete-profile.html → dashboard
2. **Trace the login flow:** login.html → `auth.js signIn()` → `session.js` → role-based redirect
3. **Open any dashboard page** — find `SessionManager.requireAuth(['YOUTH_VOLUNTEER'])` — understand what happens if you're not logged in or wrong role
4. **Read `session.js`** line by line — this is the most critical shared file

#### Questions You Should Be Able to Answer After This Week

- What happens step-by-step when a user signs up?
- How does `SessionManager.requireAuth()` protect a page?
- How does the system know which dashboard to redirect to?
- What happens if someone tries to access `sk-dashboard.html` as a Youth Volunteer?

---

### Week 7 — Dashboards & Data Layer (Feb 23-28)

**Meeting Agenda:** Walk through how a dashboard loads data from Supabase and renders it

**DeepWiki Reading:** Dashboard sections

#### What to Study

| File | What It Does | Key Concepts |
|------|-------------|--------------|
| `youth-dashboard.html` | Youth main page | Profile display, announcements, testimonials, stats |
| `sk-dashboard.html` | SK main page | Stats cards, project overview, announcement management |
| `captain-dashboard.html` | Captain approvals | Project approval/reject/revise workflow |
| `superadmin-dashboard.html` | System overview | Stats, system health |

#### How to Study This Week

Pick ONE dashboard (start with `youth-dashboard.html`) and trace this pattern that ALL pages follow:

```
1. <head> loads: Supabase SDK → env.js → supabase.js → auth.js → session.js
2. <script type="module"> starts
3. Import components (NotificationModal, ProfileModal)
4. SessionManager.requireAuth() — checks role
5. Load user profile into header
6. Load page-specific data from Supabase (projects, announcements, etc.)
7. Render data into HTML using template literals
8. Initialize components (notification, profile)
9. Expose functions to window.* for onclick handlers
```

Once you understand this pattern in ONE file, you understand the skeleton of ALL 15+ pages.

#### Questions You Should Be Able to Answer After This Week

- What is the common pattern every page follows? (auth → load → render → components)
- How does a dashboard query Supabase? (`.from('Table').select('*').eq(...)`)
- How does data go from database → JavaScript object → rendered HTML?
- What does `escapeHTML()` do and why is it important?

---

### Week 8 — Feature Pages (Mar 2-7)

**Meeting Agenda:** Each member presents their assigned pages (the ones they tested in Week 4)

**DeepWiki Reading:** Feature-specific sections

#### What to Study

Each member deep-dives into the **same pages they tested for bugs in Week 4**. Since you already found bugs there, you already know those pages.

**SK/Youth File Pairs:**

| Member | Pages to Master |
|--------|----------------|
| Person who tested dashboards | `youth-dashboard.html` + `sk-dashboard.html` |
| Person who tested files | `youth-files.html` + `sk-files.html` |
| Person who tested projects | `youth-projects.html` + `sk-projects.html` |
| Person who tested calendar | `youth-calendar.html` + `sk-calendar.html` |
| Person who tested the rest | `youth-certificates.html` + `sk-testimonies.html` + `sk-archive.html` |

#### How to Study This Week

For your assigned pages, answer:
1. What data does this page load from which tables?
2. What can the user DO on this page? (CRUD operations)
3. What Supabase queries are used? (find all `.from(...)` calls)
4. What onclick/event handlers exist? (find all `window.functionName =`)
5. What edge cases are handled? (empty states, errors, loading states)

#### In the Meeting: Each Person Presents

- "This page does X, Y, Z"
- "It queries these tables..."
- "The main user actions are..."
- "I found these bugs during testing and here's what the fix was..."

---

### Week 9 — Cross-Role Workflows (Mar 9-14)

**Meeting Agenda:** Walk through complete end-to-end workflows that span multiple roles

**DeepWiki Reading:** Project Lifecycle section

#### Workflows to Trace Together

**Workflow 1: Project Lifecycle**
```
SK creates project (sk-projects.html)
  → Inserts into Pre_Project_Tbl (approvalStatus: PENDING)
  → Captain sees it (captain-dashboard.html)
  → Captain approves (updates approvalStatus: APPROVED)
  → Youth sees it (youth-projects.html)
  → Youth applies (inserts into Application_Tbl)
  → SK approves application (updates applicationStatus: APPROVED)
  → Project completes (status: COMPLETED)
  → Post_Project_Tbl record created
  → Youth fills survey (Evaluation_Tbl)
  → Youth gets certificate (youth-certificates.html)
```

**Workflow 2: Notification Flow**
```
SK creates announcement → Notification_Tbl row → Youth's NotificationModal shows it
```

**Workflow 3: File Management**
```
SK uploads file (sk-files.html) → File_Tbl + Supabase Storage
  → Youth can view/download (youth-files.html)
```

**Workflow 4: Authentication & Role Protection**
```
User signs up → auth.users trigger → User_Tbl row
  → Login → SessionManager checks role
  → Redirect to correct dashboard
  → RLS enforces data access at DB level
```

#### Questions You Should Be Able to Answer After This Week

- Walk us through the complete project lifecycle from proposal to certificate
- How does data flow between SK, Captain, and Youth roles?
- If I'm a Youth Volunteer, what data can I see vs what an SK Official can see? (RLS)
- How do notifications get created and delivered across roles?

---

## Week 11 — Mock Defense (Easter Break)

By now everyone knows the code. Use this week for rehearsal.

### Mock Defense Format

1. **Round 1:** One member demos the full system (practice the demo flow)
2. **Round 2:** Other members act as panelists and ask hard questions
3. **Round 3:** Swap roles
4. **Round 4:** Rapid-fire — random questions, anyone answers

### Defense Demo Flow (Suggested Order)

1. **Landing Page** — Show public-facing features
2. **Sign Up** — Create new youth account (show OTP flow)
3. **SK Login** — Create a project proposal, manage files, post announcement
4. **Captain Login** — Approve the project just created
5. **Youth Login** — Browse projects, apply, view calendar, check certificates
6. **Superadmin Login** — Show user management, activity logs
7. **Mobile Responsive** — Quick demo on phone/tablet view
8. **Security** — Show RLS in action (explain what happens if unauthorized)

---

## Quick Reference: Key Technical Concepts

Everyone must be able to explain these:

| Concept | One-Line Answer |
|---------|----------------|
| **Tech Stack** | Vanilla JS + Tailwind CSS + Supabase (PostgreSQL + Auth + Storage) |
| **Why no framework?** | Simpler deployment, faster loads, easier debugging, fits course scope |
| **Supabase** | Open-source Firebase alternative — gives us database, auth, file storage, and APIs |
| **RLS** | Row Level Security — 80 database policies that control who can read/write which rows |
| **SessionManager** | Our custom JS class that checks if user is logged in and has the right role |
| **ES Modules** | `<script type="module">` + `import` — how we reuse NotificationModal and ProfileModal |
| **XSS Prevention** | `escapeHTML()` converts user input to safe text so it can't inject scripts |
| **Project Lifecycle** | SK proposes → Captain approves → Youth applies → Project completes → Certificates |
| **Auth Flow** | Supabase Auth → email/OTP verification → session token → SessionManager → RLS |

---

## Mock Defense Questions

### Architecture
- Why did you use vanilla JS instead of React/Vue?
- How does your authentication system work?
- Explain your database schema and relationships.
- How do you prevent unauthorized access?

### Features
- Walk us through the project approval workflow.
- How does the certificate generation work?
- How do notifications work across roles?
- What happens when a youth volunteer applies to a project?

### QA/Testing
- What testing strategies did you use?
- How did you handle edge cases?
- What were the most critical bugs found and how were they fixed?
- How do you ensure data integrity?

### Security
- What is Row Level Security and how did you implement it?
- How do you prevent XSS attacks?
- How do you handle session management?
- What happens if someone tries to access a page without proper role?

---

## Bug Tracking Template

| Bug ID | Date | Reporter | File | Severity | Description | Console Error (paste it) | Steps to Reproduce | Status |
|--------|------|----------|------|----------|-------------|--------------------------|-------------------|--------|
| BUG-001 | Feb 3 | Name | captain-dashboard.html | HIGH | Approve button 400 error | `Error approving project: {code: 400}` | 1. Login captain 2. Open project 3. Click approve | FIXED |

**Severity:** CRITICAL / HIGH / MEDIUM / LOW

---

## Deliverables Checklist (for Google Drive submission)

- [ ] Software Test Document (test plan, test cases, results)
- [ ] UAT Questionnaire (finalized online form)
- [ ] UAT Results Summary
- [ ] Product Metrics Report
- [ ] Defense Presentation Slides
- [ ] Source Code (GitHub link or zip)
- [ ] Database Schema Documentation
- [ ] User Manual / DeepWiki link
