# SE2 Presentation Guide — BIMS Defense (April 7, 2026)

**Based on:** SE2 PPT Template (Departmental), SE1 Presentation (Dec 3, 2025), Updated SPMP/SRS/SDD

**Format:** 15 minutes PPT + 15 minutes live demo (strict)

---

## Template Slide Order (Required by Department)

The SE2 template mandates this exact structure. Follow it — panelists expect this order.

| Slide # | Template Section | What to Put |
|---------|-----------------|-------------|
| 1 | **Title Slide** | "Barangay Information Management System (BIMS) for SK Malanday, Marikina City" — Group 4, 3ITA |
| 2 | **Group Members** | All 9 members with roles (reuse SE1 slide, update if roles changed for SE2) |
| 3-4 | **Project Introduction** | Client intro, problem statement, reason, purpose (reuse SE1 slides 3-5, keep short — max 2 slides per template) |
| 5 | **Project Scope** | Core features from SRS: Login, Manage Content, Manage Files, Monitor Projects + Archive |
| 6-7 | **Use Case Diagrams** | Extended use case diagrams from SDD — show all 4 modules. Add "SUPERADMIN" actor if updated. Reference SDD page numbers. |
| 8 | **System User Accounts** | List all roles: Superadmin, Captain, SK Official, Youth Volunteer, Visitor. Describe access per role. |
| 9-10 | **Swimlane Diagrams** | Swimlane/activity diagrams from SDD. Pick 2 most important (Login + Project Management). Reference page numbers. |
| 11 | **Class Diagram** | Final class diagram from SDD. Reference page number. Don't over-explain — demo will show it working. |
| 12 | **Database Diagram** | ER diagram from SDD. **Keep sample data in the DB** (template says: "Do NOT erase sample data from testing"). Reference page number. |
| 13 | **Project Requirements** | Functional + non-functional requirements list from SRS. Keep brief — 8-10 lines max per slide. |
| 14 | **Test Methodology** | Describe testing approach from STD: manual testing, test cases per module, RLS verification. |
| 15-16 | **Sample Test Cases** | Show 2-3 actual test cases using the test case template. Include SA-L2 (the one we fixed!) as a before/after example. |
| 17 | **System Demo** (transition) | "System Demo — Local Hosting" — transition to live demo |
| 18 | **Thank You + Q&A** | End slide |

---

## What Changed from SE1 to SE2 (Key Updates to Highlight)

### Slides to REUSE from SE1 (with minor updates)
- **Slide 1 (Title):** Same, just update date to April 7, 2026
- **Slide 2 (Members):** Same 9 members, same roles
- **Slides 3-4 (Project Intro):** Same problem statement, client intro, purpose — no changes needed
- **Slide 5 (Scope):** Same 4 core features. Add note about SUPERADMIN role (new in SE2)
- **Slides 6-7 (Use Case Diagrams):** Update if diagrams changed. Add Superadmin use cases if in SDD.
- **Slide 8 (User Accounts):** Add SUPERADMIN role (not in SE1). Update descriptions.
- **Slides 9-10 (Swimlane):** Reuse if unchanged. Update references to SDD page numbers.
- **Slide 11 (Class Diagram):** Update if class structure changed in implementation
- **Slide 12 (ER Diagram):** **MUST UPDATE** — DB has 20+ tables now vs original design. Show actual production schema.

### Slides that are NEW for SE2
- **Slide 13 (Requirements):** Should now show which requirements were IMPLEMENTED vs DEFERRED
- **Slides 14-16 (Testing):** NEW — SE1 had mockup test cases. SE2 has REAL test results from actual system testing.
- **Slide 17 (System Demo):** NEW — SE1 showed Figma mockups. SE2 shows the WORKING SYSTEM.

---

## Slide-by-Slide Content Draft

### Slide 1: Title
```
BARANGAY INFORMATION MANAGEMENT SYSTEM (BIMS)
for SK Malanday, Marikina City

Group 4 — 3ITA
ICS26013 Software Engineering 2
April 7, 2026
```

### Slide 2: Members
```
PROJECT MANAGER         Jerome Ancheta
SYSTEMS ANALYST         Juliana Gabriella Sergio
BUSINESS ANALYST        Andrea Marie Pelias
DEVELOPERS              Elijah Dela Vega, Kyleen Nicdao, Gavin Adrian Santos
QA OFFICERS             Ryan Paolo Espinosa, Brian Louis Ralleta, JC Dre Gabriel Ledonio
```

### Slide 3: Project Introduction
```
Client: Sangguniang Kabataan of Barangay Malanday, Marikina City
  - Primary youth governance body for community programs and volunteer coordination
  - Client representative: Ms. Cielo DG. Villaroman (SK Secretary)

Problem Statement:
  SK Malanday relies on manual coordination, scattered file storage, and unstructured
  social media communication. This makes it difficult to manage youth volunteers,
  track public documents, and coordinate projects efficiently.

  [Include Fishbone Diagram — reference SRS Figure R-1, page ___]
```

### Slide 4: Project Introduction (cont.)
```
Project Purpose:
  1. Centralize Information Management — unified secure repository
  2. Streamline Project Tracking — structured lifecycle management
  3. Enhance Communication — announcements + inquiry system
  4. Facilitate Volunteer Engagement — online applications + status tracking
  5. Support Scheduling — calendar for project timelines
  6. Strengthen Security — OTP login + role-based access control
  7. Archive Projects — 1-year shelf life, organized retrieval
```

### Slide 5: Project Scope
```
Core System Features (from SRS):
  1. Login & Authentication — Email/password + OTP, PKCE flow, role-based redirect
  2. Manage Content — Announcements CRUD, testimonies, certificates
  3. Manage Files — Upload, organize, publish, archive public documents
  4. Monitor Projects — Full lifecycle: create → approve → manage → complete → archive

Additional Features (SE2):
  + SUPERADMIN Dashboard — system-wide monitoring, user management, activity logs
  + Notification System — real-time per-user notifications with deep linking
  + Activity Logging — 56 logging points, severity classification, auto-retention
  + Calendar Module — project timeline view for all roles

User Roles: Superadmin | Captain | SK Official | Youth Volunteer | Visitor (public)
```

### Slides 6-7: Use Case Diagrams
```
[Reuse SE1 use case diagrams from SDD]
[Add note: "For complete architectural design, refer to SDD Section 2a"]
[If Superadmin use cases were added, include updated diagram]
```

### Slide 8: System User Accounts
```
SUPERADMIN (System Administrator)
  - Full system access: user management, activity logs, database stats
  - Receives auto-notifications on signups, role changes, new projects

CAPTAIN (Barangay Captain)
  - Project approval/rejection authority
  - View-only access to project details and status
  - DB-enforced: only ONE active captain allowed (unique index)

SK OFFICIAL (SK Administrators)
  - Full CRUD: projects, announcements, files, applications
  - Manage volunteers, respond to inquiries, track attendance

YOUTH VOLUNTEER (Youth Users)
  - Browse projects, submit applications, send inquiries
  - View announcements, download files, submit testimonies

VISITOR (No Account)
  - Public homepage: featured projects, announcements, transparency reports
```

### Slides 9-10: Swimlane Diagrams
```
[Reuse SE1 swimlane diagrams — Login + Project Management]
[Reference SDD page numbers]
[Template says: "Do not put too much emphasis on discussion of diagrams,
 especially process flow, as you will have your system demo later"]
```

### Slide 11: Class Diagram
```
[Updated class diagram from SDD]
[Reference SDD Section 4, page ___]
[Keep brief — demo shows it working]
```

### Slide 12: Database Diagram
```
[Updated ER diagram — 20+ tables with relationships]
[Key tables: User_Tbl, SK_Tbl, Captain_Tbl, Announcement_Tbl, File_Tbl,
 Pre_Project_Tbl, Post_Project_Tbl, Application_Tbl, Inquiry_Tbl,
 Reply_Tbl, Notification_Tbl, Logs_Tbl, Certificate_Tbl, Evaluation_Tbl,
 Testimonies_Tbl, BudgetBreakdown_Tbl, Login_Attempts_Tbl]

[Reference SDD Section 3a, page ___]

NOTE: Sample/test data is preserved in the database for panel review.
```

### Slide 13: Project Requirements
```
Functional Requirements (Implemented):
  ✓ User registration with OTP email verification
  ✓ Role-based login with session management
  ✓ Announcement CRUD with publish/archive
  ✓ File upload, download, publish, archive
  ✓ Project lifecycle: proposal → approval → completion → archive
  ✓ Volunteer application and inquiry system
  ✓ Captain approval workflow with notifications
  ✓ Calendar module for project timelines
  ✓ Activity logging with audit trail

Non-Functional Requirements (Implemented):
  ✓ Security: CSP headers, PKCE auth, RLS (50+ policies), login lockout
  ✓ Performance: Server-side pagination, optimized queries
  ✓ Usability: Responsive design (mobile + desktop), accessible navigation
  ✓ Reliability: Auto-retention policy, graceful error handling

[Reference SRS Section 4, page ___]
```

### Slide 14: Test Methodology
```
Testing Approach:
  - Manual functional testing per module (Login, Content, Files, Projects)
  - Test cases follow standardized template (Test Case ID, Steps, Expected/Actual Result)
  - Role-based testing: each feature tested under correct user role
  - Security testing: RLS policy verification, login lockout validation
  - Cross-browser testing: Chrome, Firefox, Edge

Test Coverage:
  - XX test cases across 4 core modules + Superadmin
  - Bug tracking: identified and resolved during QA phase
  - Regression testing after each fix

[Reference STD Section ___, page ___]
```

### Slides 15-16: Sample Test Cases
```
TEST CASE 1: SA-L2 — Filter Activity Logs by Date
  Test Case ID: SA-L2
  Pre-condition: Logged in as Superadmin; logs exist across multiple dates
  Step 1: Locate date filter → Expected: Date picker visible → Status: PASS
  Step 2: Select Feb 23, 2026 → Expected: Filtered logs → Status: PASS (was FAIL, fixed)
  
  Root cause found: Logs_Tbl was empty (no code called log_action RPC).
  Fix: Added 56 logAction() calls across 19 pages + updated RPC schema.

TEST CASE 2: [Pick another test case — e.g., Login lockout or Project approval]
  [Fill in from STD]

TEST CASE 3: [Pick another — e.g., File upload or Announcement CRUD]
  [Fill in from STD]
```

### Slide 17: System Demo (transition)
```
SYSTEM DEMO
Local hosting via Live Server (localhost:5500)
Backend: Supabase Cloud (PostgreSQL + Auth + Storage)

[Transition to live demo — 15 minutes]
```

### Slide 18: Thank You
```
THANK YOU

Barangay Information Management System (BIMS)
Group 4 — 3ITA
April 7, 2026

Q & A
```

---

## Template Rules (from departmental guidelines)

1. **Max 8-10 lines per slide** — don't cram text
2. **Include page numbers** for all figures/diagrams referencing documents (so panelists can look them up)
3. **Do NOT erase sample/test data** from the database
4. **Do NOT memorize** — understand the project, use script as reference only
5. **System demo is through local hosting** — not deployed
6. **Keep diagrams brief** — "Do not put too much emphasis on discussion of diagrams, especially on the process flow, as you will have your system demo later"

---

## Action Items for PPT Creation

| Task | Owner | Deadline |
|------|-------|----------|
| Update title slide + members slide | PM | Apr 2 |
| Update project intro slides (reuse SE1, minor edits) | PM | Apr 2 |
| Update/verify use case diagrams from SDD | Sergio | Apr 3 |
| Update system user accounts (add Superadmin) | PM | Apr 2 |
| Update swimlane diagrams from SDD | Sergio | Apr 3 |
| Update class diagram from SDD | Sergio | Apr 3 |
| Update ER diagram (actual 20+ table schema) | PM/Sergio | Apr 3 |
| Write project requirements slide (implemented features) | PM | Apr 3 |
| Write test methodology slide | Ryan Paolo (QA) | Apr 3 |
| Write 2-3 sample test cases | Ryan Paolo (QA) | Apr 3 |
| Create "System Demo" transition slide | PM | Apr 4 |
| Final review + rehearsal | All | Apr 5 |

---

## Key Differences: SE1 PPT vs SE2 PPT

| SE1 (Dec 3, 2025) | SE2 (Apr 7, 2026) |
|---|---|
| Showed Figma mockups | Shows **working system** (live demo) |
| Test cases were theoretical | Test cases have **real results** (pass/fail with actual data) |
| No Superadmin role | Superadmin role fully implemented |
| Original tech stack (Next.js + PHP + MySQL) | Actual tech stack (HTML + Tailwind + Supabase) |
| 4 user roles | 5 user roles (+ Superadmin) |
| Basic ER diagram | 20+ table production schema |
| No security implementation | Full security: CSP, PKCE, RLS, lockout, logging |
| No notifications | Notification system with DB triggers |
| No activity logging | 56 logging points with auto-retention |

**IMPORTANT:** If panelists ask about tech stack change (SDD says Next.js/PHP, actual system uses Supabase), explain:
> "During SE2 implementation, we evaluated the original tech stack and chose Supabase (PostgreSQL + built-in Auth + Storage) because it provides Row Level Security at the database level, eliminating the need for a separate backend server. This decision improved security and reduced development complexity while maintaining all functional requirements."
