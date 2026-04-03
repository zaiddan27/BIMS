# PM Study Guide: System Architecture

> For Jerome — tech stack, DB, security, decisions.

---

## Numbers to Remember

22 HTML pages · 13 JS files · 22 tables · 233 RLS policies · 31 migrations · 56 log points · 4 roles

---

## Tech Stack

| Layer | What | Why |
|-------|------|-----|
| Frontend | HTML + Tailwind + Vanilla JS | No build step, fast loads, scope-appropriate |
| Backend | Supabase (PostgreSQL) | Auth + RLS + Storage + RPC in one platform |
| Auth | Supabase Auth + PKCE | Built-in email, OTP, Google OAuth |
| Storage | Supabase Storage | Public + private buckets with RLS |

**Why not React?** — Our pages are forms and tables. No complex state. No build pipeline needed. Team learned Supabase instead.

**Why not Firebase?** — Our data is relational (users → projects → applications). PostgreSQL gives us joins, FK constraints, and RLS. Firebase is NoSQL — bad fit.

**Why the tech stack change from SDD?** — Original SDD said Next.js + PHP + MySQL. Supabase replaced all three: RLS replaces PHP middleware, PostgreSQL replaces MySQL, static HTML replaces Next.js. Simpler, more secure, all SRS requirements still met.

---

## Database — 22 Tables

```
USERS:     User_Tbl, SK_Tbl, Captain_Tbl
PROJECTS:  Pre_Project_Tbl, Post_Project_Tbl, Application_Tbl,
           Evaluation_Tbl, Expenses_Tbl, Report_Tbl,
           Annual_Budget_Tbl, BudgetBreakdown_Tbl
CONTENT:   Announcement_Tbl, File_Tbl, Testimonies_Tbl, Certificate_Tbl
COMMS:     Inquiry_Tbl, Reply_Tbl, Notification_Tbl
SECURITY:  Login_Attempts_Tbl, Password_Reset_Attempts_Tbl, Logs_Tbl
```

**Key decisions:**
- userID = Supabase auth UUID (no separate ID)
- Role stored in User_Tbl (SUPERADMIN can change it without touching auth)
- One active Captain enforced by DB unique partial index
- Logs insert via RPC — users can read/write logs but never delete
- CHECK constraints on all enums (role, status, type)
- Cascade deletes on project → applications, expenses, evaluations

---

## Security — 5 Layers

1. **Network** — HTTPS/TLS, SRI hashes on CDN scripts, CSP on all 22 pages
2. **Auth** — PKCE, password complexity (5 rules), OTP (10-min expiry), login lockout (5 attempts → 15-min block, server-side), password reset rate limit (3/15min)
3. **Session** — JWT (1hr expiry), 30-min idle timeout, role checked from DB on every page load
4. **Authorization** — 233 RLS policies on all 22 tables. Even curl/Postman blocked if role doesn't match.
5. **Input/Output** — escapeHTML() on all content, parameterized queries (no SQL injection), sanitizeImageURL(), DB CHECK constraints

### OWASP Top 10

| # | Category | Protection |
|---|----------|------------|
| 1 | Broken Access Control | 233 RLS + session checks + route guards |
| 2 | Crypto Failures | bcrypt + HTTPS |
| 3 | Injection | Parameterized queries |
| 4 | Insecure Design | Least privilege, YOUTH_VOLUNTEER default |
| 5 | Misconfiguration | CSP on all pages |
| 6 | Vulnerable Components | SRI hashes |
| 7 | Auth Failures | PKCE + lockout + OTP + idle timeout |
| 8 | Data Integrity | DB constraints + server validation |
| 9 | Logging Failures | 56 log points, audit retention |
| 10 | SSRF | N/A (no server-side requests) |

---

## Logging

- `logAction()` — fire-and-forget, never blocks UI
- Auto-detects category: auth actions → authentication, deletes → WARN, creates → data_mutation
- Retention: general 90 days, audit 1 year (pg_cron auto-cleanup)

---

## Deployment

- **Frontend**: static HTML files (GitHub Pages or similar)
- **Backend**: Supabase Cloud
- **Migrations**: `npx supabase db push` (31 files, git-versioned)
- **If Supabase goes down**: frontend still loads, graceful error messages, daily auto-backups

---

## Scope Additions (not in original SDD)

| What | Why |
|------|-----|
| SUPERADMIN role | Client needed user management |
| Activity logging | Audit trail for accountability |
| Notifications + DB triggers | Real-time awareness of events |
| Login lockout (server-side) | Brute force prevention |
| CSP headers | XSS/clickjacking defense |
| Idle timeout | Unattended session protection |

---

## Quick Q&A

**Q: Why not React?**
> Forms and tables don't need it. No build step, faster loads, team focused on Supabase.

**Q: Why Supabase over Firebase?**
> Relational data needs joins and FK constraints. RLS is more powerful. Open-source.

**Q: What is RLS?**
> PostgreSQL adds WHERE clauses to every query based on user role. 233 policies, all 22 tables. Bypassing frontend doesn't help — DB blocks it.

**Q: How many tables?**
> 22 tables with FK constraints. User → Projects → Applications → Evaluations. Enums enforced via CHECK.

**Q: What if Supabase goes down?**
> Frontend still loads. Error messages shown. Auto daily backups.

**Q: How would you scale?**
> CDN for frontend, connection pooling + read replicas for DB, auto-retention for logs.

**Q: What methodology?**
> Waterfall per SPMP. Fixed requirements, fixed deadline.

**Q: Does it match the SRS?**
> All 4 core functions implemented. Scope additions documented with justification.

**Q: What changed from SDD?**
> Tech stack (Next.js/PHP/MySQL → HTML/Supabase). Added SUPERADMIN, logging, notifications, CSP. Core requirements unchanged.

**Q: Biggest challenge?**
> 233 RLS policies for 4 roles across 22 tables. One wrong policy = data leak.

**Q: How do you prevent concurrent data issues?**
> Last write wins for general edits. DB constraints prevent invalid states (e.g., unique Captain).

**Q: Data integrity?**
> FK constraints, CHECK constraints, unique indexes, NOT NULL, DB triggers.