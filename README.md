# BIMS - Barangay Information Management System

**Sangguniang Kabataan Malanday, Marikina City**

A comprehensive web-based management system for SK operations, volunteer management, and community project tracking.

---

## 🚀 Quick Links

- **📖 Complete Documentation:** [`docs/`](./docs/)
- **🔧 Development Guide:** [`docs/core/CLAUDE.md`](./docs/core/CLAUDE.md)
- **📊 Project Status:** [`docs/core/PROGRESS.md`](./docs/core/PROGRESS.md)
- **💾 Database Reference:** [`docs/database/DATABASE_TABLE_COLUMN_REFERENCE.md`](./docs/database/DATABASE_TABLE_COLUMN_REFERENCE.md)

---

## 📂 Documentation Structure

```
docs/
├── core/                    # Core project documentation
│   ├── CLAUDE.md              # Development specification & guidelines
│   ├── README.md           # Detailed project overview
│   ├── PROGRESS.md         # Project phase tracking
│   └── CHANGELOG.md        # Version history
│
├── database/               # Database documentation
│   ├── DATABASE_TABLE_COLUMN_REFERENCE.md  # Complete schema + RLS
│   ├── AUTH-SETUP.md       # Authentication configuration
│   └── SUPABASE-SETUP.md   # Supabase setup guide
│
├── verification/           # Testing & verification
│   ├── RLS_POLICIES_FINAL_VERIFICATION_2026-01-12.md
│   └── TESTING_GUIDE.md
│
└── archive/                # Historical documentation
    └── cleanup plans & verification reports
```

---

## 🛠️ Tech Stack

- **Frontend:** HTML, Tailwind CSS, Vanilla JavaScript
- **Backend:** Supabase (PostgreSQL, Authentication, Storage)
- **Deployment:** Netlify (CI/CD)
- **Database:** PostgreSQL with Row Level Security (RLS)
- **Auth:** Email/Password + OTP via Gmail API

---

## 👥 User Roles

| Role                 | Access Level  | Description                                 |
| -------------------- | ------------- | ------------------------------------------- |
| **Barangay Captain** | Approval      | Review & approve project proposals          |
| **SK Officials**     | Administrator | Full CRUD on projects, files, announcements |
| **Youth Volunteers** | User          | View projects, apply, submit testimonials   |
| **Visitors**         | Public        | View landing page, projects, testimonials   |

---

## 🚦 Getting Started

### For Developers

1. **Read the Development Guide**

   ```bash
   docs/core/CLAUDE.md
   ```

2. **Check Current Phase**

   ```bash
   docs/core/PROGRESS.md
   ```

3. **Setup Authentication**

   ```bash
   docs/database/AUTH-SETUP.md
   ```

4. **Configure Supabase**
   ```bash
   docs/database/SUPABASE-SETUP.md
   ```

### For Database Work

- **Schema Reference:** `docs/database/DATABASE_TABLE_COLUMN_REFERENCE.md`
- **RLS Policies:** `supabase/rls-policies.sql`
- **Verification Script:** `supabase/verification/verify_rls_policies.sql`

---

## 🔒 Security

- ✅ All 20 tables protected with Row Level Security (RLS)
- ✅ 80 policies enforced at database level
- ✅ Role-based access control (PUBLIC, YOUTH_VOLUNTEER, CAPTAIN, SK_OFFICIAL, SUPERADMIN)
- ✅ 100% RLS verification passed (2026-01-12)

**Full Security Documentation:** [`docs/database/DATABASE_TABLE_COLUMN_REFERENCE.md`](./docs/database/DATABASE_TABLE_COLUMN_REFERENCE.md) (RLS section)

---

## 📊 Project Status

**Current Phase:** Phase 3 - Core Features Implementation

| Phase                          | Status         |
| ------------------------------ | -------------- |
| Phase 1: Frontend Cleanup      | ✅ Complete    |
| Phase 2: Supabase Setup        | ✅ Complete    |
| Phase 3: Core Features         | 🔄 In Progress |
| Phase 4: Testing & QA          | ⏳ Not Started |
| Phase 5: Production Deployment | ⏳ Not Started |

**Detailed Progress:** [`docs/core/PROGRESS.md`](./docs/core/PROGRESS.md)

---

## 📝 Recent Updates

- **2026-01-12:** Documentation restructured, RLS policies consolidated
- **2026-01-12:** SQL files cleaned up (16 files removed/archived)
- **2026-01-12:** All markdown files organized into `docs/` folder
- **2026-01-12:** RLS verification complete (20/20 checks passed)

**Full Changelog:** [`docs/core/CHANGELOG.md`](./docs/core/CHANGELOG.md)

---

## 🤝 Contributing

1. Read [`docs/core/CLAUDE.md`](./docs/core/CLAUDE.md) for development guidelines
2. Follow naming conventions (Table: `Title_Case`, Column: `camelCase`)
3. Always create markdown files in appropriate `docs/` subfolder
4. Test RLS policies before committing database changes

---

## ⚠️ Coding Guidelines & Risk Checklist

**Review these before writing or reviewing code:**

### 🔐 Security Risks

| #   | Risk                                         | Description                                                                |
| --- | -------------------------------------------- | -------------------------------------------------------------------------- |
| 1   | **No Rate-Limiting**                         | APIs without throttling → easy target for brute force & spam               |
| 2   | **API Keys in Client Code**                  | Secrets exposed in frontend → instant key theft                            |
| 3   | **No Auth on Internal Endpoints**            | "Hidden" routes are still public → anyone can hit admin logic              |
| 4   | **Over-Permissive CORS**                     | `Access-Control-Allow-Origin: *` → any website can call your API           |
| 5   | **No Input Validation**                      | Assuming "happy paths" only → SQL injection, prompt injection & crashes    |
| 6   | **Hardcoded Credentials**                    | DB passwords, JWT secrets in source → exposed in Git history forever       |
| 7   | **Missing HTTPS Enforcement**                | HTTP endpoints left open → man-in-the-middle attacks                       |
| 8   | **No CSRF Protection**                       | Forms without tokens → malicious sites can trigger state-changing actions  |
| 9   | **Weak Password Policies**                   | No complexity, length, or breach checking → accounts compromised easily    |
| 10  | **Session Management Flaws**                 | Sessions never expire, no logout, tokens in localStorage (XSS vulnerable)  |
| 11  | **Unvalidated Redirects**                    | `redirect=user_input` → phishing attacks via your trusted domain           |
| 12  | **Mass Assignment Vulnerabilities**          | Accepting all input fields → users can modify `isAdmin`, `role`, `balance` |
| 13  | **Information Disclosure**                   | Detailed error messages expose stack traces, DB structure, `.env` files    |
| 14  | **Insecure Direct Object References (IDOR)** | `/api/user/123` with no ownership check → access anyone's data             |
| 15  | **Missing Security Headers**                 | No `X-Frame-Options`, `CSP`, `X-Content-Type-Options` → clickjacking, XSS  |

### ⚡ Code Efficiency Risks

| #   | Risk                              | Description                                                                        |
| --- | --------------------------------- | ---------------------------------------------------------------------------------- |
| 16  | **N+1 Query Problems**            | Loading related data in loops instead of joins → 1000 DB queries for 10 items      |
| 17  | **No Database Indexing**          | Queries scan entire tables → exponential slowdown as data grows                    |
| 18  | **Missing Caching Layer**         | Recalculating/refetching same data on every request → wasted CPU & bandwidth       |
| 19  | **Synchronous Heavy Operations**  | Image processing, email sending in request cycle → 30-second response times        |
| 20  | **Memory Leaks**                  | Event listeners never removed, global variables accumulating, unclosed connections |
| 21  | **Inefficient Algorithms**        | Nested loops where hash maps would work (O(n²) vs O(n)), regex backtracking        |
| 22  | **Unnecessary Re-Renders**        | Components re-rendering entire lists when one item changes                         |
| 23  | **Large Bundle Sizes**            | Importing entire libraries for one function, no code splitting, unoptimized assets |
| 24  | **Polling Instead of WebSockets** | Checking for updates every second → constant unnecessary requests                  |
| 25  | **No Pagination**                 | `SELECT * FROM users` returning 100,000 rows → browser crashes                     |

### 🛠️ Maintainability Risks

| #   | Risk                                 | Description                                                                          |
| --- | ------------------------------------ | ------------------------------------------------------------------------------------ |
| 26  | **Zero Documentation**               | No README, no comments, no API docs → "works on my machine" syndrome                 |
| 27  | **Magic Numbers & Hardcoded Values** | `if (status === 3)` scattered throughout → changing business rules breaks everything |
| 28  | **God Classes/Functions**            | 1000-line functions doing 20 things → impossible to debug                            |
| 29  | **Copy-Paste Code Duplication**      | Same logic repeated 15 times → bug fixes require changing 15 places                  |
| 30  | **Inconsistent Naming Conventions**  | `getUserData()`, `fetch_user()`, `LoadUserInfo()` in same codebase                   |
| 31  | **No Error Handling Strategy**       | try-catch wrapping everything silently → bugs hide in production                     |
| 32  | **Tight Coupling**                   | Direct dependencies between unrelated modules → changing one breaks five others      |
| 33  | **No Tests**                         | "I tested it manually" → regressions appear with every deployment                    |
| 34  | **Environment-Specific Code**        | `if (process.env.NODE_ENV === 'production')` embedded everywhere                     |
| 35  | **Mixed Concerns**                   | Database logic in UI components, business logic in controllers → spaghetti           |
| 36  | **Commented-Out Code**               | Hundreds of lines of "maybe we'll need this later" → code archaeology required       |
| 37  | **Inconsistent Error Messages**      | "Error", "Oops!", "Something went wrong" → users and devs both confused              |
| 38  | **No Version Control Discipline**    | Commits like "fix", "update", "asdfsdf"; broken master branch                        |
| 39  | **Technology Debt Accumulation**     | Using deprecated libraries with no migration plan                                    |
| 40  | **No Logging or Monitoring**         | Production issues are mysteries → "it worked yesterday, what changed?"               |

### ✅ Quick Checklist Before Committing

```
□ Input validation on all user inputs
□ Authentication check on protected endpoints
□ Error handling with proper user messages
□ No hardcoded secrets or API keys
□ Database queries use parameters (not string concatenation)
□ Loading states reset properly (success AND error)
□ Functions have single responsibility
□ Consistent naming conventions used
□ Console.log statements removed from production code
□ RLS policies tested for new database changes
```

---

## 📧 Contact

- **Email:** info@malandaybims.ph
- **Location:** Barangay Malanday, Marikina City

---

## 📄 License

© 2026 BIMS - Barangay Information Management System. All rights reserved.

---

**For complete documentation, visit the [`docs/`](./docs/) folder.**
