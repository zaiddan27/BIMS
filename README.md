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
│   ├── CLAUDE.md           # Development specification & guidelines
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

| Role | Access Level | Description |
|------|--------------|-------------|
| **Barangay Captain** | Approval | Review & approve project proposals |
| **SK Officials** | Administrator | Full CRUD on projects, files, announcements |
| **Youth Volunteers** | User | View projects, apply, submit testimonials |
| **Visitors** | Public | View landing page, projects, testimonials |

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

| Phase | Status |
|-------|--------|
| Phase 1: Frontend Cleanup | ✅ Complete |
| Phase 2: Supabase Setup | ✅ Complete |
| Phase 3: Core Features | 🔄 In Progress |
| Phase 4: Testing & QA | ⏳ Not Started |
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

## 📧 Contact

- **Email:** info@malandaybims.ph
- **Location:** Barangay Malanday, Marikina City

---

## 📄 License

© 2026 BIMS - Barangay Information Management System. All rights reserved.

---

**For complete documentation, visit the [`docs/`](./docs/) folder.**
