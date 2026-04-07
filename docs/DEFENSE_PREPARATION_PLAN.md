# BIMS Defense Preparation Plan

**Defense Date:** Monday, April 7, 2026
**Room:** UST CICS
**Client:** SK Malanday, Marikina City — Ms. Cielo D. Villaroman (onsite or via GMeet)
**Panel 1:** Prof. Noel Estrella (neestrella@ust.edu.ph)
**Panel 2:** Mr. Arthur Ollanda (adollanda@ust.edu.ph)

### Official Defense Format (from Departmental Guidelines)

**SE2 (ICS26013) — 1 hour 15 minutes total:**

| Segment | Duration | Notes |
|---------|----------|-------|
| Intro + PPT Presentation | **15 min** | Strict. All 9 members present. |
| System Demo | **15 min** | Live demo of working system |
| Panel Q&A | **20 min** | Both panelists + client ask questions |
| Deliberation | **15 min** | Students leave room. Panel + client discuss revisions. |
| Verdict | **10 min** | Head panel announces result + revisions |

### Pre-Defense Checklist

- [ ] Share full Google Docs (SPMP, SRS, SDD, STD) to both panelists via email — **at least 3 days before (April 4 latest)**
- [ ] Print **2 copies** of full document set: SPMP, SRS, SDD, STD
- [ ] Print **2 copies** of SE2 evaluation forms
- [ ] Print **2 copies** of SE2 Revisions List
- [ ] Bring **Signed Development Form from SE1** (both panelists + client signatures)
- [ ] Prepare **individual name tags** (large, visible font)
- [ ] **Business attire**: Men = long sleeve + necktie + formal pants + business shoes. Ladies = blouse + blazer + business pants/skirt + business shoes
- [ ] Arrive **1 hour early** for setup (laptop, projector/TV connectors, slides)
- [ ] Prepare **own internet connection** as backup (mobile hotspot)
- [ ] Optional: assign a **scribe** to take notes during Q&A (or record video/audio)

### Team Roster (from SPMP)

**Course:** ICS26013 - Software Engineering 2
**Instructor:** Asst. Prof. Mia V. Eleazar

| Role | Name | Defense Responsibility |
|------|------|----------------------|
| **Project Manager** | Jerome Ancheta | Overall defense lead, architecture presentation, Q&A coordination |
| **Systems Analyst** | Juliana Gabriella Sergio | File Management & Activity Logs module |
| **Business Analyst** | Andrea Marie Pelias | Reviews independently (requirements traceability) |
| **Developer** | Kyleen Nicdao | Monitor Projects module |
| **Developer** | Gavin Adrian Santos | Content Management & Notifications module |
| **Developer** | Elijah Dela Vega | Login & Authentication module |
| **QA Officer** | Ryan Paolo Espinosa | Reviews independently (testing & QA) |
| **QA Officer** | Brian Louis Ralleta | Reviews independently (document compliance) |
| **QA Officer** | JC Dre Gabriel Ledonio | Reviews independently (cross-document consistency) |

**Dev team in meetings:** Elijah, Kyleen, Santos, Sergio
**QA + BA:** Ryan Paolo, Brian, JC, Andrea — review their own parts independently

---

## Module Study Assignments (for Meetings 1 & 2 — learning the code)

Each dev studies a module so they can **explain how it works in the codebase** to the rest of the team.

| Member | Module | Scope |
|--------|--------|-------|
| **PM** | System Architecture & Overview | Tech stack, database design, deployment, security, project management decisions |
| **Elijah** | Login & Authentication | Signup, login, OTP verification, forgot/reset password, session management, PKCE, login lockout, idle timeout |
| **Kyleen** | Monitor Projects | Project lifecycle (proposal > approval > completion > archive), applications, inquiries, budget tracking, Captain approval flow |
| **Santos** | Manage Content & Notifications | Announcements CRUD, homepage display, notification system, testimonies, certificates |
| **Sergio** | File Management & Activity Logs | File upload/download/archive/publish, storage buckets, activity logging system, audit trail, database stats |

---

## Meeting Schedule

### Meeting 1: Presentations — Elijah & Kyleen (April 3, Thursday)
**Duration:** ~60 minutes
**Goal:** Elijah and Kyleen present their modules, group asks questions

| Time | Activity |
|------|----------|
| 0:00 - 0:15 | **Elijah**: Login & Authentication (present + live walkthrough) |
| 0:15 - 0:25 | Group Q&A for Elijah — everyone asks questions, clarify gaps |
| 0:25 - 0:40 | **Kyleen**: Monitor Projects (present + live walkthrough) |
| 0:40 - 0:50 | Group Q&A for Kyleen |
| 0:50 - 1:00 | Feedback round — what was clear, what needs more detail for next meeting |

**Prep before Meeting 1 (Elijah & Kyleen must):**
- Read their module's section in the SRS and SDD documents
- Open the actual HTML pages and trace the code flow
- Prepare a 10-15 min walkthrough explaining: what it does, how it works, key code files
- List 3 questions a panelist might ask about your module

**Everyone else:** Read the SRS/SDD overview so you can ask good questions

---

### Meeting 2: Presentations — Santos & Sergio (April 4, Friday)
**Duration:** ~60 minutes
**Goal:** Santos and Sergio present their modules, group asks questions

| Time | Activity |
|------|----------|
| 0:00 - 0:15 | **Santos**: Content Management & Notifications (present + live walkthrough) |
| 0:15 - 0:25 | Group Q&A for Santos |
| 0:25 - 0:40 | **Sergio**: File Management & Activity Logs (present + live walkthrough) |
| 0:40 - 0:50 | Group Q&A for Sergio |
| 0:50 - 1:00 | Feedback round — identify remaining weak spots before final meeting |

**Prep before Meeting 2 (Santos & Sergio must):**
- Same prep as Meeting 1 — study module, prepare walkthrough, list panelist questions
- Learn from Meeting 1's feedback (what level of detail worked)

---

### Meeting 3: Full Team — PPT Assembly, Mock Defense & Rehearsal (April 5, Saturday)
**Duration:** ~2.5 hours
**Goal:** Assemble PPT, full team rehearsal, finalize everything. **All 9 members must attend.**

| Time | Activity |
|------|----------|
| 0:00 - 0:15 | **PM**: Presents system architecture overview (sets context for everyone) |
| 0:15 - 0:25 | Group Q&A for PM |
| 0:25 - 0:45 | **PPT briefing**: PM walks each member through their assigned slides. Each person learns what they need to say and answer about their section. |
| 0:45 - 1:05 | **QA reports**: JC presents requirements traceability + tech stack change explanation. Brian reports doc consistency issues + confirms printed materials. Ryan presents test cases. Andrea confirms client attendance. |
| 1:05 - 1:25 | **Mock defense Q&A**: PM plays panelist — asks hard cross-module questions to everyone. Focus on Prof. Estrella (web dev) and Mr. Ollanda (security) style questions. |
| 1:25 - 1:40 | **Demo rehearsal**: Practice the live demo flow end-to-end with role switching (15 min strict timer) |
| 1:40 - 2:00 | **Full PPT run-through**: Everyone presents their section back-to-back with a 15-min timer. No stops. |
| 2:00 - 2:15 | Logistics — who presents which slides, HDMI tested, demo accounts ready, printed docs confirmed, confidence check |

**PM brings to Meeting 3:**
- Completed PPT (full deck) ready to brief each member on their section
- Architecture diagrams

**QA brings to Meeting 3:**
- Printed doc status update, evaluation forms, name tags, requirements traceability checklist

---

## Study Guide Per Member

### Elijah: Login & Authentication
**Files to study:**
- `login.html`, `signup.html`, `forgot-password.html`, `reset-password.html`, `verify-otp.html`, `complete-profile.html`
- `js/auth/auth.js` - core auth logic
- `js/auth/session.js` - session management, idle timeout, role-based access
- `js/config/supabase.js` - PKCE configuration

**Key concepts to explain:**
- Auth flow: signup > email OTP > login > session > role-based redirect
- Security: PKCE flow, 5-attempt lockout (server-side via `check_login_allowed` RPC), 30-min idle timeout
- Session management: Supabase auth tokens, auto-refresh, localStorage
- Password reset: OTP-based (not email link), rate-limited
- Profile completion: required fields check on every page load
- Google OAuth integration

**Likely panelist questions:**
1. "How do you prevent brute-force attacks?" → Server-side login lockout (5 attempts / 15 min), rate limiting on password reset
2. "What is PKCE and why use it?" → Proof Key for Code Exchange, prevents authorization code interception
3. "What happens if a user's account is deactivated while they're logged in?" → `session.js` checks `accountStatus` on every page load, kicks them out

---

### Kyleen: Monitor Projects
**Files to study:**
- `sk-projects.html` - project CRUD, application management, attendance, completion
- `youth-projects.html` - browse projects, apply, inquiries
- `captain-dashboard.html` - project approval/rejection
- `sk-archive.html` - archived projects

**Key concepts to explain:**
- Project lifecycle: SK creates proposal > Captain approves/rejects > SK manages volunteers > marks complete > archive
- Applications: Youth apply, SK approves/rejects, attendance tracking
- Inquiries: Youth ask questions per project, SK replies (threaded)
- Post-project: evaluation form, budget breakdown, success metrics
- Archive: 1-year shelf life, restore or permanent delete
- Budget tracking: line-item breakdown with expenses

**Likely panelist questions:**
1. "Walk us through a project from creation to completion" → Create > Captain approval > open applications > manage volunteers > mark attendance > complete > post-project evaluation > archive
2. "How does the Captain approval work?" → Trigger sends notification to Captain, Captain views and approves/rejects from their dashboard
3. "What prevents a Youth Volunteer from approving their own application?" → RLS + role check: only SK_OFFICIAL can update application status

---

### Santos: Content Management & Notifications
**Files to study:**
- `sk-dashboard.html` - announcements CRUD (create, edit, delete)
- `youth-dashboard.html` - view announcements, submit testimonies
- `youth-certificates.html` - certificate requests
- `js/components/NotificationModal.js` - notification system
- `index.html` - public homepage (featured announcements)

**Key concepts to explain:**
- Announcements: SK Officials create/edit/delete, Youth can view, homepage shows featured
- Testimonies: Youth submit with star rating, SK officials approve/feature/reject
- Certificates: Youth request evaluation, generates certificates
- Notification system: real-time bell icon, type-based routing (click notification > goes to right page)
- Superadmin notifications: DB triggers auto-notify on signup, role change, project creation

**Likely panelist questions:**
1. "How do notifications reach the right user?" → `Notification_Tbl` stores per-user with `userID`, type, and `referenceID` for deep linking
2. "How do you prevent XSS in announcements?" → `escapeHTML()` sanitizes all dynamic content before `innerHTML`
3. "Can a Youth Volunteer edit announcements?" → No, RLS policy restricts insert/update/delete to SK_OFFICIAL role

---

### Sergio: File Management & Activity Logs
**Files to study:**
- `sk-files.html` - file upload, archive, delete, publish/unpublish
- `youth-files.html` - view/download files
- `superadmin-activity-logs.html` - all logs, audit trail, database stats
- `js/utils/logger.js` - logging utility
- `supabase/migrations/023_upgrade_logging_system.sql` - logging schema

**Key concepts to explain:**
- File management: SK uploads to Supabase Storage, DB tracks metadata in `File_Tbl`
- Storage buckets: public (general-files, project-files) vs private (consent-forms, receipts, certificates)
- File lifecycle: upload > publish/unpublish > archive > permanent delete
- Activity logging: 56 `logAction()` calls across 19 pages, fire-and-forget
- Log schema: `category` (auth/audit/data_mutation), `severity` (INFO/WARN/ERROR/CRITICAL), `userAgent`, `metadata` JSONB
- Auto-retention: pg_cron daily cleanup, general logs 90 days, audit logs 1 year
- Audit trail: `category = 'audit'` for role changes, account changes (indexed, not string matching)

**Likely panelist questions:**
1. "How do you ensure file uploads are secure?" → Server-side extension validation, RLS on storage buckets, file size limits
2. "How long are logs retained?" → General 90 days, audit 1 year (NIST SP 800-92 / PCI-DSS aligned)
3. "Can a user delete their own activity logs?" → No, `Logs_Tbl` has no DELETE policy for authenticated users, only SELECT/INSERT

---

### PM: System Architecture & Overview
**PPT presentation is 15 min total shared across the team. PM covers slides 1-6 (~5 min), then each dev covers their module slides (~2 min each). See [`SE2_PPT_GUIDE.md`](SE2_PPT_GUIDE.md) for slide-by-slide content.**

**PM's slides (1-6) should cover:**
- Problem statement + Fishbone diagram (from SRS)
- Tech stack: HTML/Tailwind/Vanilla JS + Supabase (PostgreSQL, Auth, Storage, RPC)
- Why Supabase: built-in auth, RLS, no backend server needed
- Database design: 20+ tables, 50+ RLS policies, SECURITY DEFINER functions
- Security: CSP on all 22 pages, PKCE, lockout, idle timeout, activity logging
- User roles: SUPERADMIN > CAPTAIN > SK_OFFICIAL > YOUTH_VOLUNTEER

### Defense Day: Who PRESENTS Which Slides (STRICT 15 MIN)

PM builds the entire PPT. Each member just needs to **know their section** so they can present it and answer follow-up questions. PM briefs everyone at Meeting 3.

| PPT Section | Presenter | Time | Priority | Notes |
|-------------|-----------|------|----------|-------|
| Project Introduction (client, problem) | **Andrea** (BA) | 1.5 min | Keep short — panelists read the docs already | Client intro, problem statement, fishbone |
| Project Purpose & Scope | **Jerome** (PM) | 1.5 min | Keep short — just list objectives | 7 objectives, scope boundaries |
| Detailed Use Case Diagrams | **Gavin Santos** (Dev) | 2 min | **Needs more time** — 4 modules to cover | Walk through each module's use case quickly. Say "refer to SDD page X" for details. |
| System User Accounts | **Andrea** (BA) | 1 min | Quick — just read the role matrix | 5 roles, 1 sentence each |
| Swimlane Diagrams | **Elijah** (Dev) | 1.5 min | Show 1-2 key swimlanes, skip the rest | Pick Login + Project Management. Don't over-explain — demo shows it. |
| ER Diagram | **Sergio** (SA) | 1.5 min | **Needs more time** — 20+ tables | Highlight key relationships. Don't list every table — point to the diagram. |
| Class Diagram | **Kyleen** (Dev) | 1 min | Quick overview | Point out main classes and relationships |
| Functional & Non-Functional Req. | **Sergio** (SA) | 1 min | Just the list — panelists have the SRS | Read highlights, don't explain each one |
| Test Methodology | **JC + Brian** (QA) | 1.5 min | Keep concise — 1 person talks | Approach, tools, coverage. Other person stands ready for Q&A. |
| Sample Test Cases (2-3) | **Ryan Paolo** (QA) | 1.5 min | **Show real results** — panelists care about this | Pick test cases with actual pass/fail. Mention bugs found and fixed. |
| System Demo (transition) | **Jerome** (PM) | 0.5 min | Just say "We'll now demonstrate the system" | Transition to demo |
| **TOTAL** | | **15 min** | | **Rehearse with timer. If over, cut User Accounts + Class Diagram to 30s each.** |

**If running over time, cut these first:**
1. User Accounts — panelists can read the slide
2. Class Diagram — just point and move on
3. Swimlane — say "refer to SDD" and skip

**Never cut these:**
1. Use Case Diagrams — panelists need the system overview
2. ER Diagram — they'll ask about DB design
3. Test Cases — shows the system actually works

> **Module study (Meetings 1-2) ≠ PPT presenting.** Meetings are for devs to learn the code. PPT presenting is based on document knowledge (SDD/SRS/STD).

---

> **PPT slide-by-slide guide is in a separate document:** [`docs/SE2_PPT_GUIDE.md`](SE2_PPT_GUIDE.md)

---

## QA + BA Tasks (Apr 1-4, while devs do Meetings 1 & 2)

While the 4 devs focus on their module presentations (Apr 3-4), the QA team and BA work independently on defense materials. Bring outputs to Meeting 3 (Apr 5).

### Ryan Paolo (QA Lead)
**Deadline: Bring to Meeting 3 (Apr 5)**
- [ ] Write **test methodology** slide content — describe testing approach, tools, coverage strategy
- [ ] Prepare **2-3 sample test cases** using the STD template format — pick ones with real pass/fail results (e.g., SA-L2 Filter Activity Logs which was fixed)
- [ ] Review all **STD test cases** — verify actual results are documented, statuses updated
- [ ] Prepare to answer: "How did you test?", "What was your test coverage?", "What bugs did you find and how were they fixed?"
- [ ] Know the **security testing** you performed — RLS verification, login lockout test, role-based access testing

### Brian Louis (QA - Document Compliance)
**Deadline: Bring to Meeting 3 (Apr 5)**
- [ ] Cross-check **SPMP, SRS, SDD, STD** for consistency — same terminology, same feature names, same table names
- [ ] Verify all **page number references** in diagrams match the actual documents (panelists will look them up)
- [ ] Check that the **SDD diagrams** (use case, swimlane, class, ER) match the actual implementation — flag any differences for the team to address in the PPT
- [ ] Prepare the **2 printed copies** of all documents (SPMP, SRS, SDD, STD)
- [ ] Prepare **2 copies of SE2 evaluation forms** + **2 copies of SE2 Revisions List**
- [ ] Locate the **Signed Development Form from SE1**

### JC Ledonio (QA - Cross-Document Consistency)
**Deadline: Bring to Meeting 3 (Apr 5)**
- [ ] Verify **SRS requirements traceability** — every SRS requirement should map to an implemented feature. Create a quick checklist: requirement → implemented (yes/no)
- [ ] Verify **SDD architecture vs actual system** — flag if class diagram, ER diagram, or use cases differ from what was built (tech stack change: SDD says Next.js/PHP → actual is Supabase)
- [ ] Prepare **individual name tags** for all 9 members (large, visible font)
- [ ] Prepare the **tech stack change explanation** — why we switched from Next.js + PHP + MySQL (in SDD) to HTML + Tailwind + Supabase. Draft a 2-3 sentence answer.
- [ ] Know the answer to: "Does your system match your SDD?" — be honest about changes, explain rationale

### Andrea Marie (Business Analyst)
**Deadline: Bring to Meeting 3 (Apr 5)**
- [ ] Review **client requirements** from interviews — verify all pain points from Ms. Villaroman are addressed in the system
- [ ] Prepare to explain the **Fishbone Diagram** and **Validation Board** from SRS if panelists ask
- [ ] Coordinate with client (Ms. Cielo Villaroman) — confirm her attendance (onsite or GMeet) for April 7
- [ ] If client is onsite: fill out the Google Form for CICS coordination (was due Mar 27 — verify this was done)
- [ ] Prepare to answer: "How did you validate requirements?", "Did the client sign off?", "What did the client request that you didn't implement?"

---

## Panelist Profiles

### Prof. Noel E. Estrella (IT Department Chair)
- **Title:** Associate Professor, Doctor of Information Technology
- **Expertise:** Web & mobile app development, software engineering, document management systems
- **Notable projects:** UNESCO web app (content management for sustainable agriculture), "Sentinel" telehealth web/mobile app, "FEDesk" document management system, "Nabi" mental health social platform
- **What he'll likely focus on:** He builds real web applications. Expect questions about your **architecture decisions, database design, web security, and scalability**. He'll know if your tech stack makes sense. He may also probe **UX design** and **real-world deployment** concerns.
- **Prep tip:** Be ready to explain WHY you chose Supabase (he'll compare it to other BaaS). Know your RLS policies well — he understands DB-level security. If he asks about deployment, know your hosting setup.

### Mr. Arthur D. Ollanda (Network Security / Cisco)
- **Title:** Faculty, Department of Information Technology, BSCS
- **Expertise:** Network security, data communications, Cisco networking (CCNA/CCNP), cybersecurity fundamentals
- **Teaches:** Data Communications, Network Security, Cisco Networking Academy courses
- **What he'll likely focus on:** He's a **security-first** thinker. Expect deep questions about **authentication security, encryption, network-level protections, HTTPS, CSP headers, session management, access control models, data protection, and vulnerability mitigation**. He'll probe whether your system is hardened against real attacks.
- **Prep tip:** Know your security stack cold: PKCE, CSP headers, RLS, login lockout, idle timeout, SRI hashes, HTTPS. Be ready to explain what happens if someone tries to bypass frontend auth (answer: RLS blocks them at DB level). Know the difference between authentication and authorization. If he asks about OWASP Top 10, map your protections to each category.

**Likely questions from Mr. Ollanda:**
1. "How do you secure data in transit?" → All Supabase connections use HTTPS/TLS. CDN scripts use SRI hashes to prevent tampering.
2. "What happens if someone steals a JWT token?" → Token expires (Supabase default 1hr), idle timeout logs out after 30 min, RLS still restricts by role.
3. "How do you prevent clickjacking?" → CSP `frame-ancestors 'none'` on all 22 pages — the site cannot be embedded in any iframe.
4. "What is your access control model?" → Role-Based Access Control (RBAC) with 4 roles enforced at 3 layers: frontend route guards, session manager role check, and PostgreSQL RLS policies.
5. "How do you protect against brute force?" → Server-side login lockout: 5 failed attempts = 15 min lockout, tracked in DB (not localStorage). Rate limiting on password reset.
6. "What logging do you have for security events?" → Activity logging with severity levels (INFO/WARN/ERROR/CRITICAL), audit category for role/account changes, auto-retention (90 days general, 1 year audit). 56 logging points across the app.
7. "How do you handle input validation?" → HTML escaping via `escapeHTML()` on all dynamic content. Supabase SDK uses parameterized queries (prevents SQL injection). Server-side file extension validation on uploads. CHECK constraints on DB columns.
8. "What are your Content Security Policy headers?" → `default-src 'self'`, script/style from trusted CDNs only, `frame-ancestors 'none'`, `form-action 'self'`, `base-uri 'self'`. Applied to all 22 pages.

### Asst. Prof. Mia V. Eleazar (Course Instructor)
- **Your SE1 instructor** — she knows your SRS, SDD, and SPMP documents
- **What she'll likely focus on:** Consistency between documents and implementation. Did you follow your SPMP timeline? Does the system match the SDD architecture? Are all SRS requirements implemented?
- **Prep tip:** Know the gaps between your original documents and the final system. Be honest about what changed and why.

---

## Common Panelist Questions to Prepare For

### Architecture (Prof. Estrella will likely ask these)
1. "Why not use React/Angular/Vue?" → Simplicity, no build step, faster loading, team skill level, vanilla JS is sufficient for this scope
2. "Why Supabase over Firebase?" → PostgreSQL (relational data, RLS, joins), SQL-based policies, open-source, self-hostable
3. "How do you handle concurrent edits?" → Supabase uses optimistic concurrency; last write wins. For critical operations (captain promotion), DB constraints prevent invalid states
4. "What if Supabase goes down?" → Static frontend still loads; graceful error handling shows "connection issue" status

### Security (Prof. Estrella will likely ask these)
5. "How do you prevent SQL injection?" → Supabase SDK uses parameterized queries; no raw SQL from client
6. "How do you prevent unauthorized access to admin pages?" → Triple layer: session check, role verification from DB (not localStorage), RLS on every table
7. "What is Row Level Security?" → PostgreSQL feature that adds WHERE clauses to every query based on the authenticated user's role. We have 50+ RLS policies across all tables.
8. "How do you handle CSRF?" → PKCE flow eliminates CSRF on auth; Supabase handles SameSite cookies
9. "What security headers do you use?" → CSP with frame-ancestors on all 22 pages, X-Content-Type-Options nosniff, strict referrer policy

### Data & Database (Prof. Estrella / Mr. Ollanda)
10. "How many tables and what are the relationships?" → 20+ tables with FK constraints, cascade deletes where appropriate
11. "How do you back up data?" → Supabase provides automatic daily backups; point-in-time recovery on paid plans
12. "How do you ensure only one Captain exists?" → DB-level unique partial index on active Captain role — enforced at database level, not just frontend

### Process & Requirements (Prof. Eleazar / Mr. Ollanda will likely ask these)
13. "What development methodology did you use?" → Waterfall (as per SPMP), with iterative improvements during implementation
14. "How did you test?" → Manual testing with test cases (SA-L1, SA-L2, etc.), RLS verification scripts, QA team reviewed independently
15. "What was the biggest challenge?" → Implementing proper RLS for 4 different roles across 20+ tables while keeping the system usable
16. "Does the system match your SRS requirements?" → All 4 core functions implemented: Login, Content Management, File Management, Project Monitoring. Each SRS requirement is traceable to implemented features.
17. "What changed from your original SDD?" → Added Superadmin role (not in original spec), added activity logging system, added notification system with DB triggers. Document these as scope additions with justification.

### Prof. Estrella-Specific Questions (he builds web apps)
18. "How would you scale this system?" → Supabase supports connection pooling, read replicas. Static frontend can be served via CDN. Activity logs have auto-retention to prevent DB bloat.
19. "Have you considered real-time features?" → Supabase supports real-time subscriptions. Currently not needed — notification badge refreshes on page load. Could add real-time notifications as future enhancement.
20. "How do you handle file storage security?" → Supabase Storage with bucket-level RLS. Server-side file extension validation. Public vs private buckets for different document types.

---

## Demo Setup: 2 Laptops + TV (STRICT 15 MINUTES)

### Hardware Setup

| Laptop | Person | What's open | Connection |
|--------|--------|------------|------------|
| **Laptop 1 (HDMI to TV)** | **Jerome (PM)** | Chrome: Superadmin. Firefox/Edge: Captain. Incognito: Login demo page. | HDMI to TV — panelists watch this |
| **Laptop 2** | **Elijah** | Chrome: SK Official (logged in). Incognito: live signup. Firefox/Edge: Youth Volunteer (logged in). | Sits beside Jerome, shares screen via Google Meet when it's his turn |

Jerome controls Superadmin + Captain + Login demo. Elijah controls SK Official + Youth Volunteer + does the live signup.
Each assigned member stands and **narrates their section** while Jerome or Elijah clicks.
To avoid swapping HDMI cables: Jerome hosts Google Meet on his laptop (HDMI to TV), Elijah joins and shares screen when it's his turn. Panelists see everything on the TV regardless of which laptop is active.

### Demo Flow — 15 Minutes, 5 Phases

The demo walks through each portal **one at a time**: Public → Auth → SK Official → Captain → Youth → Superadmin. Each portal is shown completely before moving to the next.

> **Timing principle:** Project lifecycle (Kyleen) and Login security (Jerome) get the most time — these are what Prof. Estrella and Mr. Ollanda will scrutinize. Testimonies, Calendar, and Certificates are shown quickly (10-15s each) as supplementary features.

---

#### Phase 1: Public + Authentication (0:00–3:00) — 3 min

| # | Time | Dur | What happens | Laptop | Narrator | Pages shown |
|---|------|-----|-------------|--------|----------|-------------|
| 1 | 0:00–0:30 | 30s | **Homepage** — landing page, featured announcements, transparency section | L1 | **Pelias** | `index.html` |
| 2 | 0:30–2:00 | **90s** | **Login** — show login form, explain PKCE flow, attempt wrong password to trigger lockout warning, explain idle timeout. **Security-heavy: take your time.** | L1 (incognito) | **Jerome** | `login.html` |
| 3 | 2:00–3:00 | 60s | **Sign Up** — live signup with fresh email, receive OTP, verify, complete profile | L2 (incognito) | **Elijah** | `signup.html` → `verify-otp.html` → `complete-profile.html` |

**Security notes for Mr. Ollanda (Phase 1):**
| Feature | Security mechanism |
|---------|-------------------|
| Homepage | CSP `frame-ancestors 'none'` (anti-clickjacking), SRI hashes on all CDN scripts, `X-Content-Type-Options: nosniff` |
| Login | **PKCE flow** (prevents auth code interception), **5-attempt/15min server-side lockout** via `check_login_allowed` RPC (not localStorage — tamper-proof), **30-min idle timeout** with DB session check, JWT 1hr expiry with auto-refresh |
| Sign Up | Email OTP verification (not magic link — harder to phish), rate-limited password reset, CHECK constraints on profile fields, Google OAuth as alternative |

---

#### Phase 2: SK Official Portal (3:00–7:15) — 4 min 15s

*Switch to Elijah's laptop — SK Official account pre-logged in.*

| # | Time | Dur | What happens | Laptop | Narrator | Pages shown |
|---|------|-----|-------------|--------|----------|-------------|
| 4 | 3:00–3:40 | 40s | **Announcement** — create announcement, show it on dashboard | L2 (SK) | **Gavin** | `sk-dashboard.html` |
| 5 | 3:40–4:20 | 40s | **SK Files** — upload document, publish it, show file management | L2 (SK) | **Juliana** | `sk-files.html` |
| 6 | 4:20–6:00 | **100s** | **Project** — create project proposal, set budget line items, manage volunteers, submit for Captain approval. **Key demo moment — show full project creation + management.** | L2 (SK) | **Kyleen** | `sk-projects.html` |
| 7 | 6:00–6:15 | 15s | **Calendar** — quick view: events and project deadlines on calendar | L2 (SK) | **Kyleen** | `sk-calendar.html` |
| 8 | 6:15–6:30 | 15s | **Testimonies** — quick view: manage panel (approve/feature/reject) | L2 (SK) | **Gavin** | `sk-testimonies.html` |
| 9 | 6:30–7:15 | 45s | **Archive** — archived projects (Kyleen narrates, 25s) + archived files (Juliana narrates, 20s) | L2 (SK) | **Kyleen + Juliana** | `sk-archive.html` |

**Security notes for Mr. Ollanda (Phase 2):**
| Feature | Security mechanism |
|---------|-------------------|
| Announcements | `escapeHTML()` sanitizes all dynamic content before rendering (XSS prevention), RLS: only `SK_OFFICIAL` role can INSERT/UPDATE/DELETE |
| Files | Supabase Storage with **bucket-level RLS** (public vs private buckets), server-side file extension validation, file size limits, download activity logged |
| Projects | RLS enforces per-role CRUD — Youth can't create projects, only SK can. FK constraints ensure data integrity. **Captain-only approval gate** enforced at DB level. Parameterized queries via Supabase SDK (SQL injection prevention) |
| Calendar | Read-only display — data fetched through RLS-protected queries, no write access from calendar view |
| Testimonies | RLS: SK can manage (approve/reject), Youth can only submit their own. `escapeHTML()` on all testimony content |
| Archive | Soft-delete pattern (not permanent), 1-year shelf life policy, RLS restricts permanent delete to authorized roles only |

---

#### Phase 3: Captain Portal (7:15–8:25) — 1 min 10s

*Switch to Jerome's laptop — Captain tab pre-logged in.*

| # | Time | Dur | What happens | Laptop | Narrator | Pages shown |
|---|------|-----|-------------|--------|----------|-------------|
| 10 | 7:15–7:30 | 15s | **Announcement** — Captain's view of announcements | L1 (Captain) | **Gavin** | `captain-dashboard.html` |
| 11 | 7:30–8:10 | 40s | **Project** — approve/reject the pending project, show approval flow | L1 (Captain) | **Kyleen** | `captain-dashboard.html` (projects tab) |
| 12 | 8:10–8:25 | 15s | **Archive** — quick view: archived projects from Captain's perspective | L1 (Captain) | **Kyleen** | `captain-archive.html` |

**Security notes for Mr. Ollanda (Phase 3):**
| Feature | Security mechanism |
|---------|-------------------|
| Announcements | Role-based dashboard — session role verified from DB on every page load (not localStorage). If role changes mid-session, user is redirected. |
| Project Approval | **Only CAPTAIN role can approve/reject** — enforced by RLS policy + `SECURITY DEFINER` function. DB triggers auto-notify SK Official of decision. Unique partial index ensures only 1 active Captain exists. |
| Archive | Same RLS as SK archive, scoped to Captain's permissions |

---

#### Phase 4: Youth Volunteer Portal (8:25–10:50) — 2 min 25s

*Switch to Elijah's laptop — Youth Volunteer tab pre-logged in.*

| # | Time | Dur | What happens | Laptop | Narrator | Pages shown |
|---|------|-----|-------------|--------|----------|-------------|
| 13 | 8:25–8:40 | 15s | **Announcement** — Youth's view of announcements | L2 (Youth) | **Gavin** | `youth-dashboard.html` |
| 14 | 8:40–9:05 | 25s | **Youth Files** — browse published files, download one | L2 (Youth) | **Juliana** | `youth-files.html` |
| 15 | 9:05–10:25 | **80s** | **Project** — browse approved projects, submit application, send inquiry. **Key demo moment — show the Youth side of the project lifecycle.** | L2 (Youth) | **Kyleen** | `youth-projects.html` |
| 16 | 10:25–10:35 | 10s | **Calendar** — quick view: events and project dates | L2 (Youth) | **Kyleen** | `youth-calendar.html` |
| 17 | 10:35–10:50 | 15s | **Certificate** — quick view: show a pre-existing certificate, download | L2 (Youth) | **Kyleen** | `youth-certificates.html` |

**Security notes for Mr. Ollanda (Phase 4):**
| Feature | Security mechanism |
|---------|-------------------|
| Announcements | Read-only RLS — Youth has no write access. Notification data scoped to `userID` (can't see other users' notifications). |
| Files | Only **published** files visible via RLS policy (unpublished/archived hidden). Download action logged via `logAction()`. |
| Projects | RLS: Youth can only view **approved** projects, can only see **own** applications, can only edit **own** inquiries. Cannot apply twice to same project (DB unique constraint). |
| Calendar | Read-only display, no direct data manipulation |
| Certificate | Client-side PDF generation via jsPDF (no server storage of generated certs). Certificate data verified against `Evaluation_Tbl` records. |

---

#### Phase 5: Superadmin Portal (10:50–15:00) — 4 min 10s

*Switch to Jerome's laptop — Superadmin account.*

| # | Time | Dur | What happens | Laptop | Narrator | Pages shown |
|---|------|-----|-------------|--------|----------|-------------|
| 18 | 10:50–11:50 | 60s | **System Overview** — dashboard stats, charts, user counts, project metrics. Show everything updated from demo actions. | L1 (Superadmin) | **Jerome + Juliana** | `superadmin-dashboard.html` |
| 19 | 11:50–12:50 | 60s | **User Management** — promote the signup from Phase 1 to SK Official, show role matrix, deactivation. Show unique Captain constraint. | L1 (Superadmin) | **Jerome + Juliana** | `superadmin-user-management.html` |
| 20 | 12:50–14:20 | **90s** | **Activity Logs** — show ALL actions just performed during demo, filter by category (auth/audit/data_mutation), filter by severity, show audit trail for role change. **Key demo moment: proof that everything is logged.** | L1 (Superadmin) | **Jerome + Juliana** | `superadmin-activity-logs.html` |
| 21 | 14:20–15:00 | 40s | **Wrap-up** — "As you saw, every action across all roles was captured in the audit trail." Transition to Q&A. | L1 | **Jerome** | — |

**Security notes for Mr. Ollanda (Phase 5):**
| Feature | Security mechanism |
|---------|-------------------|
| Dashboard | Superadmin-only RLS — no other role can access these views. Aggregated data (no PII exposed in stats). |
| User Management | RBAC enforcement at DB level. **Unique partial index** ensures only 1 active Captain. Role changes trigger audit log entry (`category: 'audit'`). Deactivated users immediately kicked from active sessions via `session.js` check. |
| Activity Logs | **56 `logAction()` calls across 19 pages** — fire-and-forget pattern (doesn't block UI). Severity levels: INFO/WARN/ERROR/CRITICAL. `Logs_Tbl` has **no DELETE policy** for authenticated users (tamper-proof). Auto-retention: general 90 days, audit 1 year (aligned with NIST SP 800-92 / PCI-DSS). Indexed by category (not string matching). |

---

### Time Budget Per Person

| Member | Total time | Sections narrated | Priority features |
|--------|-----------|-------------------|-------------------|
| **Kyleen** | **~5 min** | SK Project (100s), SK Calendar (15s), SK Archive-projects (25s), Captain Project (40s), Captain Archive (15s), Youth Project (80s), Youth Calendar (10s), Youth Certificate (15s) | Project lifecycle is the **core feature** — gets most time across 3 portals |
| **Jerome** | **~3 min 50s** | Login security (90s), SA Dashboard (shared 30s), SA User Mgmt (shared 30s), SA Activity Logs (shared 45s), Wrap-up (40s) | Login security emphasis for Mr. Ollanda + Superadmin overview |
| **Juliana** | **~2 min 55s** | SK Files (40s), SK Archive-files (20s), Youth Files (25s), SA Dashboard (shared 30s), SA User Mgmt (shared 30s), SA Activity Logs (shared 45s) | File management + Superadmin co-narrator |
| **Gavin** | **~1 min 25s** | SK Announcements (40s), SK Testimonies (15s), Captain Announcements (15s), Youth Announcements (15s) | Content management across all portals |
| **Elijah** | **~1 min** | Sign Up + OTP (60s) — also operates L2 for all SK/Youth clicks | Auth flow |
| **Pelias** | **~30s** | Homepage (30s) | Public-facing introduction |
| **Ryan/JC/Brian** | — | Don't narrate during demo — ready for Q&A | QA answers testing questions from panelists |

### Laptop Swap Sequence (by phase)
```
Phase 1:  L1 (Jerome — homepage + login) → L2 (Elijah — signup)
Phase 2:  L2 (Elijah — SK Official)  — stays on L2 entire phase
Phase 3:  L1 (Jerome — Captain tab)
Phase 4:  L2 (Elijah — Youth tab)
Phase 5:  L1 (Jerome — Superadmin)
```
**Only 4 screen swaps total** (L1→L2→L1→L2→L1). Google Meet screen share eliminates HDMI cable swapping.

### Project Lifecycle Thread (Kyleen's arc across portals)

Even though each portal is demoed separately, the project lifecycle connects across phases:

```
Phase 2 (4:20)  SK creates project + sets budget + submits for approval
    ↓
Phase 3 (7:30)  Captain approves the project
    ↓
Phase 4 (9:05)  Youth browses project, applies, sends inquiry
```

> **Tip for Kyleen:** When narrating Captain approval (Phase 3), say *"This is the project we just created."* When narrating Youth (Phase 4), say *"This is the same project, now from the Youth's perspective."* This connects the dots for panelists across portals.

### Security Summary for Mr. Ollanda (quick reference)

During Q&A, the team should be ready to map demo features to these security layers:

| Layer | What it protects | Where shown in demo |
|-------|-----------------|-------------------|
| **CSP Headers** | XSS, clickjacking, script injection | All 22 pages (mentioned in Phase 1) |
| **PKCE Auth Flow** | Authorization code interception | Login (Phase 1) |
| **Server-side Login Lockout** | Brute force attacks | Login — 5 attempts/15min (Phase 1) |
| **Idle Timeout (30 min)** | Unattended sessions | Login (Phase 1) |
| **Row Level Security (50+ policies)** | Unauthorized data access | Every phase — each role sees only their data |
| **`escapeHTML()` Sanitization** | XSS in user content | Announcements, testimonies, inquiries |
| **Parameterized Queries** | SQL injection | All Supabase SDK calls |
| **Storage Bucket RLS** | Unauthorized file access | SK Files (Phase 2), Youth Files (Phase 4) |
| **Activity Logging (56 points)** | Audit trail, accountability | Activity Logs (Phase 5) |
| **No DELETE on Logs_Tbl** | Log tampering | Activity Logs (Phase 5) |
| **Auto-retention (90d/1yr)** | Compliance (NIST/PCI-DSS) | Activity Logs (Phase 5) |
| **Unique Captain Constraint** | Privilege escalation | User Management (Phase 5) |
| **Triple-layer Access Control** | Unauthorized page access | All pages: frontend guard + session role check + RLS |

### Demo Prep (do this April 6)
- [ ] Create test accounts: Superadmin (pre-existing), Captain (pre-existing), 1 SK Official (pre-logged in), 1 Youth Volunteer (pre-logged in)
- [ ] Pre-populate: at least 2 existing projects (1 approved, 1 completed), 3 announcements, 5 files, 2 testimonies (1 approved, 1 pending) — so the system doesn't look empty
- [ ] Pre-populate: 1 completed project with evaluation so Youth Certificate page has data to show
- [ ] L2 incognito window ready for live signup (use a fresh email)
- [ ] L1 incognito window ready for login security demo (wrong password attempts)
- [ ] Both laptops: browser zoom 80-90%, disable notifications/popups
- [ ] Test HDMI to TV + Google Meet screen share (arrive 1 hr early)
- [ ] Mobile hotspot ready as backup internet
- [ ] Prepare a "wrong password" to type during login demo (to trigger lockout warning visually)

### If Demo Fails
- Stay calm. Explain the issue briefly, refresh and retry.
- If internet is down, switch to mobile hotspot.
- If a specific feature breaks, skip it and move to the next step — address it during Q&A if asked.
- **If running over 15 min:** Cut Youth Calendar, Youth Certificate, and Captain Archive first (saves ~40s). Never cut SK Projects, Activity Logs, or Login security.

---

## Timeline

### Track A: Understanding the System (Meetings 1 & 2 — devs only)
The devs didn't code the system. These meetings are for them to **learn how it works** by presenting modules to each other.

### Track B: PPT + QA Preparation (parallel with Track A)
PM prepares the full PPT. Each member just needs to **know their assigned section** so they can present and answer questions about it on defense day.

| Date | Track A: System Study (Devs) | Track B: PPT + QA (Everyone) | PM (Jerome) |
|------|------------------------------|------------------------------|-------------|
| **Mar 31 (Mon)** | Plan distributed. Start studying assigned module code. | Plan distributed. QA starts reviewing documents. | Distribute plan. Start building PPT. |
| **Apr 1 (Tue)** | Read SRS + SDD for your module. Open HTML files, trace code flow. | Ryan: review STD. Brian: cross-check docs. JC: requirements traceability. Andrea: contact client. | Continue PPT. Prepare architecture diagrams. |
| **Apr 2 (Wed)** | Elijah & Kyleen: prepare 15-min module walkthrough. Santos & Sergio: continue studying. | QA continues doc review. | Finalize PPT draft. |
| **Apr 3 (Thu)** | **Meeting 1**: Elijah & Kyleen present modules (online, ~60 min) | QA optional: attend Meeting 1 to listen. | Attend Meeting 1, ask questions. |
| **Apr 4 (Fri)** | **Meeting 2**: Santos & Sergio present modules (online, ~60 min) | **All QA deliverables due.** Optional: attend Meeting 2. | Attend Meeting 2. **Share docs to panelists by email today.** PPT done. |
| **Apr 5 (Sat)** | — | **Meeting 3 (ALL 9)**: PM briefs everyone on their PPT section + QA reports + mock defense + demo rehearsal (~2.5 hrs) | Lead Meeting 3. Brief each member on their PPT slides. |
| **Apr 6 (Sun)** | Prepare demo accounts + test data. Review your PPT section. | Rest. Brian: confirm printed docs ready. | Rest. Final PPT check. Prepare demo accounts. |
| **Apr 7 (Mon)** | **DEFENSE DAY** — arrive 1 hour early, business attire | **DEFENSE DAY** — Brian brings 2 printed copies of all docs + forms + name tags | **DEFENSE DAY** — lead presentation + coordinate team |
