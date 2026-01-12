-- ============================================
-- Database Structure Verification
-- Run these queries to understand the current state
-- ============================================

-- 1. Check what columns exist in auth.users table
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'auth'
  AND table_name = 'users'
ORDER BY ordinal_position;

-- 2. Check the current trigger definition
SELECT
  t.tgname AS trigger_name,
  p.proname AS function_name,
  pg_get_triggerdef(t.oid) AS trigger_definition
FROM pg_trigger t
JOIN pg_proc p ON t.tgfoid = p.oid
WHERE t.tgname = 'on_auth_user_created';

-- 3. Check the current trigger function source code
SELECT
  p.proname AS function_name,
  pg_get_functiondef(p.oid) AS function_definition
FROM pg_proc p
WHERE p.proname = 'handle_new_user';

-- 4. Check actual column names in user_tbl (case-sensitive)
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'User_Tbl'
ORDER BY ordinal_position;

-- 5. Check if there are any existing users with Google provider
SELECT
  id,
  email,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at
FROM auth.users
WHERE email = 'malandaysk@gmail.com'
LIMIT 1;

-- 6. Check corresponding user_tbl record
SELECT
  userid,
  email,
  firstname,
  lastname,
  role,
  accountstatus,
  birthday,
  contactnumber,
  address
FROM user_tbl
WHERE email = 'malandaysk@gmail.com';

-- 7. Verify all table names in public schema (check casing)
SELECT tablename
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;

-- 8. Sample one Google OAuth user's metadata structure (if exists)
SELECT
  email,
  raw_app_meta_data,
  raw_user_meta_data
FROM auth.users
WHERE raw_app_meta_data IS NOT NULL
LIMIT 1;
