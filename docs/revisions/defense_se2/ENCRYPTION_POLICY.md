# BIMS Encryption Policy

**Status:** Defense revision #9 (SE2 2026-04-14)
**Owner:** BIMS Development Team
**Applies to:** all data handled by the Barangay Information Management System — user accounts, project records, uploaded files, audit logs, notifications.

This document exists because the SE2 defense panel found the earlier encryption explanation unclear. It restates the policy in concrete, verifiable terms — every claim below maps to a specific component of the deployed stack (Supabase Postgres, Supabase Storage, browser client, HTTPS transport).

---

## 1. Scope

BIMS handles three categories of data that require encryption controls:

| Category | Examples | Sensitivity |
|---|---|---|
| Authentication credentials | passwords, OAuth tokens, session JWTs | **High** |
| Personally identifiable information (PII) | full name, email, contact number, birthdate | **High** |
| Operational records | project details, file metadata, audit logs, announcements | **Medium** |
| Uploaded documents | reports, photos, spreadsheets in `project-files` / `sk-files` buckets | **Medium** |

Non-sensitive (public) values such as announcement body text or published project statistics are not subject to additional encryption beyond transport TLS.

---

## 2. Encryption in Transit

**All traffic between the browser, Supabase, and Google OAuth uses HTTPS (TLS 1.2+).**

- Every Supabase endpoint (REST, Realtime, Storage, Auth) terminates on a certificate managed by Supabase and renewed automatically via their ACME pipeline.
- The BIMS client enforces HTTPS only — no HTTP fallback is configured in `js/config/env.js` or `js/config/supabase.js`.
- The page is served with a strict Content-Security-Policy meta tag that limits `connect-src` to `https://*.supabase.co` and `wss://*.supabase.co`, preventing accidental plaintext exfiltration.
- Google OAuth redirects use the documented HTTPS callback only; no client secret is ever shipped to the browser.

**Result:** third parties observing the network (school Wi-Fi, ISP, captive portals) cannot read request bodies, session tokens, or uploaded file contents.

---

## 3. Encryption at Rest

BIMS delegates at-rest encryption to its managed providers. This is deliberate — rolling our own key management on a student project would create weaker, not stronger, security.

### 3.1 Supabase Postgres (data)

All tables in the BIMS schema (`User_Tbl`, `Pre_Project_Tbl`, `File_Tbl`, `Log_Tbl`, etc.) live in Supabase Postgres. Supabase stores this database on AWS RDS-backed infrastructure with **AES-256 encryption at rest**, applied at the block-storage layer. This is a Supabase platform guarantee, not an opt-in.

### 3.2 Supabase Storage (uploaded files)

Uploaded documents and images live in Supabase Storage buckets (`project-files`, `project-images`, `profile-pictures`, `sk-files`, etc.). Supabase Storage sits on top of S3-compatible object storage with the same **AES-256 at-rest encryption** managed by the platform.

### 3.3 Backups

Point-in-time recovery snapshots are also encrypted at rest by Supabase and are retained per the project's backup tier.

---

## 4. Credential & Secret Handling

Credentials are the single most sensitive category. The policy below is stricter than the general data rules.

### 4.1 User passwords

- Never stored in plaintext anywhere in the BIMS schema.
- Password authentication is handled by **Supabase Auth (GoTrue)**, which stores passwords hashed with **bcrypt** (a password-hashing function with per-row salt and tunable cost).
- Passwords are submitted only over TLS, are never logged (the logger at `js/utils/logger.js` explicitly filters credential fields), and are never written to `Log_Tbl`, `localStorage`, or URL parameters.
- Password reset flows go through Supabase Auth's token-based email link, which is single-use and short-lived.

### 4.2 Session tokens

- Sessions are JWTs issued by Supabase Auth, stored in the browser under the `bims_session` / Supabase Auth client storage keys.
- Tokens are scoped to the BIMS origin and bound to the signed-in user; they are signed by Supabase, not by the client.
- Row-Level Security (RLS) policies in Postgres re-check every request, so a stolen token can only do what the underlying user is allowed to do.

### 4.3 Third-party keys

- The Supabase **publishable (anon) key** is the only key present in the browser. It is intentionally safe to expose — it can only act through RLS policies, which reject all dangerous operations.
- The Supabase **secret / service-role key** is **never** shipped to the client. It lives only in `.env.supabase` for local CLI work and is gitignored.
- OAuth client secrets live in the Supabase dashboard, not in this repo.

---

## 5. Access Control Reinforces Encryption

Encryption by itself is not enough — if any authenticated user could read all rows, encryption at rest adds no practical privacy. BIMS enforces data separation through **Row-Level Security** on every table (migrations `003_row_level_security.sql`, `015_comprehensive_rls_optimization.sql`, `022_security_hardening_phase3.sql`). Representative examples:

- Youth volunteers can read their own `User_Tbl` row but not other users'.
- SK officials can read/write projects in their own barangay but not other barangays' data.
- Captains can approve projects and read archived content; they cannot bypass RLS.
- Only the SuperAdmin can read `Log_Tbl` / `Audit_Log_Tbl`.

This turns "encrypted at rest" into a meaningful privacy guarantee: even with direct database access, a given authenticated user's token only decrypts the rows they are entitled to through RLS.

---

## 6. Retention, Disposal, and the Privacy Commission

Per SE2 revision #6 (this defense round), files older than **5 years** are automatically moved to `ARCHIVED` status by the `public.archive_old_files()` database function (migration `027_file_retention_5yr.sql`). Final disposal/shredding after the 5-year window is a manual decision made by the Captain / SuperAdmin, aligning with National Privacy Commission guidance.

Archived files remain encrypted at rest under the same AES-256 guarantee as active files until they are physically deleted.

---

## 7. Things BIMS Deliberately Does NOT Do

We state these explicitly so the policy is not mistaken for claims we don't make:

- **We do not perform application-level field encryption** (e.g., encrypting individual columns like `email` or `contactNumber` inside the client before insert). For a barangay-scale deployment with nine SK officials, the added operational cost (key rotation, re-encryption migrations, broken full-text search) outweighs the benefit over platform-level AES-256 + RLS.
- **We do not manage our own keys.** Key custody stays with Supabase/AWS. This avoids the single largest failure mode in small-team cryptography: key loss.
- **We do not encrypt public data** (announcements published to the transparency homepage, published project statistics) beyond transport TLS, because they are intentionally public.

---

## 8. Verifying Any Claim in This Document

| Claim | How to verify |
|---|---|
| TLS on all Supabase traffic | Browser DevTools → Network → any Supabase request → "Secure" padlock, protocol = TLS 1.3 |
| Passwords hashed, not stored | Supabase dashboard → Authentication → no password field visible; `auth.users.encrypted_password` column is a bcrypt hash |
| AES-256 at rest | Supabase platform documentation; AWS RDS / S3 underlying guarantees |
| RLS enforced | Run `SELECT tablename, policyname FROM pg_policies WHERE schemaname='public';` via `supabase/run-sql.sh` |
| 5-year archive function deployed | `SELECT routine_name FROM information_schema.routines WHERE routine_name='archive_old_files';` returns one row |
| Service-role key not in client | `grep -r "service_role" *.html js/` returns zero matches |

---

## 9. Revision History

- **2026-04-14** — Initial version written in response to SE2 defense panel feedback that the prior encryption explanation was unclear. Replaces the earlier ad-hoc wording.
