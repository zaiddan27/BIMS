# SQL Files Cleanup Plan

**Date:** 2026-01-12
**Purpose:** Remove irrelevant/redundant SQL files

---

## Current State

**Total SQL files:** 29 files
- Root-level: 6 files (one-time scripts)
- supabase/migrations: 17 files
- supabase/verification: 5 files
- supabase/rls-policies.sql: 1 file (core)

---

## Files to REMOVE (16 files)

### Root-Level One-Time Scripts (6 files) 🗑️

**All root-level SQL files are one-time use and should be removed:**

1. **CHECK_NOTIFICATION_SETUP.sql** - One-time notification verification
2. **CLEAN_AND_CREATE_SAMPLE_ANNOUNCEMENTS.sql** - One-time sample data creation
3. **CLEANUP_ANNOUNCEMENT_POLICIES.sql** - One-time policy cleanup (v2.1)
4. **CREATE_DUMMY_SK_ACCOUNT.sql** - Testing/development account creation
5. **CREATE_SK_ACCOUNT_ONESTEP.sql** - Testing/development account creation
6. **REMOVE_ANNOUNCEMENT_ARCHIVE.sql** - One-time migration (removed contentStatus)

**Reason:** These were used during development/migration. No longer needed in production codebase.

---

### Redundant Migration Files (6 files) 🗑️

**Trigger fixes (migrations 012-017) - all addressing same casing issue:**

Keep only the migrations that add new functionality. Remove iterative bug fixes:

7. **012_fix_trigger_casing.sql** - First attempt at trigger fix
8. **013_fix_trigger_with_correct_casing.sql** - Second attempt
9. **014_fix_trigger_column_references.sql** - Third attempt
10. **015_simplified_trigger.sql** - Fourth attempt
11. **016_force_trigger_update.sql** - Fifth attempt
12. **017_fix_update_trigger_casing.sql** - Sixth attempt (final)

**Reason:** These are iterative bug fixes for the same trigger issue. Only the final working version (017) is needed, but since migrations are sequential and already applied, we should keep the essential ones (001-011) and document that 012-017 were trigger fixes.

**Actually, for migrations, we should keep ALL applied migrations** to maintain migration history. Let's move them to an archive folder instead.

---

### Redundant Verification Files (4 files) 🗑️

**Superseded by comprehensive verify_rls_policies.sql:**

13. **check_actual_table_names.sql** - Basic table check (superseded)
14. **check_column_names.sql** - Basic column check (superseded)
15. **check_database_structure.sql** - Basic structure check (superseded)
16. **simple_table_check.sql** - Basic table check (superseded)

**Keep:**
- ✅ **verify_rls_policies.sql** - Comprehensive 20-check verification script

**Reason:** verify_rls_policies.sql is comprehensive and covers all verification needs.

---

## Files to KEEP (13 files)

### Core Migration Files ✅
```
supabase/migrations/
├── 001_create_schema.sql                    # Initial database schema
├── 002_create_storage_buckets.sql           # Storage setup
├── 003_row_level_security.sql               # Initial RLS policies
├── 004_auth_sync_trigger.sql                # Auth synchronization
├── 005_captain_table.sql                    # Captain role
├── 006_add_superadmin_role.sql              # Superadmin functionality
├── 007_remove_sk_auditor.sql                # Role removal
├── 008_update_oauth_trigger.sql             # OAuth support
├── 009_sample_announcements.sql             # Sample data
├── 010_add_gender_column.sql                # Schema update
└── 011_add_rating_to_testimonies.sql        # Schema update
```

### Trigger Fix Migrations (Archive) 📦
```
supabase/migrations/archived/
├── 012_fix_trigger_casing.sql
├── 013_fix_trigger_with_correct_casing.sql
├── 014_fix_trigger_column_references.sql
├── 015_simplified_trigger.sql
├── 016_force_trigger_update.sql
└── 017_fix_update_trigger_casing.sql
```

### Core RLS Policies ✅
```
supabase/rls-policies.sql                    # All RLS policy definitions
```

### Verification Script ✅
```
supabase/verification/verify_rls_policies.sql  # Comprehensive RLS verification
```

---

## Proposed Action

### Phase 1: Remove Root-Level SQL Scripts (6 files)
```bash
rm CHECK_NOTIFICATION_SETUP.sql
rm CLEAN_AND_CREATE_SAMPLE_ANNOUNCEMENTS.sql
rm CLEANUP_ANNOUNCEMENT_POLICIES.sql
rm CREATE_DUMMY_SK_ACCOUNT.sql
rm CREATE_SK_ACCOUNT_ONESTEP.sql
rm REMOVE_ANNOUNCEMENT_ARCHIVE.sql
```

### Phase 2: Archive Trigger Fix Migrations (6 files)
```bash
mkdir -p supabase/migrations/archived
mv supabase/migrations/012_fix_trigger_casing.sql supabase/migrations/archived/
mv supabase/migrations/013_fix_trigger_with_correct_casing.sql supabase/migrations/archived/
mv supabase/migrations/014_fix_trigger_column_references.sql supabase/migrations/archived/
mv supabase/migrations/015_simplified_trigger.sql supabase/migrations/archived/
mv supabase/migrations/016_force_trigger_update.sql supabase/migrations/archived/
mv supabase/migrations/017_fix_update_trigger_casing.sql supabase/migrations/archived/
```

### Phase 3: Remove Redundant Verification Files (4 files)
```bash
rm supabase/verification/check_actual_table_names.sql
rm supabase/verification/check_column_names.sql
rm supabase/verification/check_database_structure.sql
rm supabase/verification/simple_table_check.sql
```

---

## Final State

**Total SQL files:** 13 files (55% reduction)
- Core migrations: 11 files
- RLS policies: 1 file
- Verification: 1 file
- Archived: 6 files (in supabase/migrations/archived/)

---

## Impact

✅ **Cleaner codebase** - Only essential SQL files remain
✅ **Clear migration history** - Core migrations preserved
✅ **Archived bug fixes** - Trigger fixes moved to archive folder
✅ **Single verification script** - One comprehensive script
✅ **Production-ready** - No test/development scripts

---

**Status:** Ready for execution
