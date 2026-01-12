-- ============================================
-- Find Actual Table Names (Case-Sensitive)
-- ============================================

-- 1. List ALL tables in public schema with EXACT casing
SELECT
  tablename,
  schemaname
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;

-- 2. Check if it's User_Tbl or user_tbl
SELECT
  table_name,
  table_schema
FROM information_schema.tables
WHERE table_schema = 'public'
  AND (table_name ILIKE '%user%' OR table_name ILIKE '%tbl%')
ORDER BY table_name;

-- 3. Once we know the exact name, check columns
-- Try User_Tbl first (Title Case)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'User_Tbl'
ORDER BY ordinal_position;

-- If above fails, try user_tbl (lowercase)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'user_tbl'
ORDER BY ordinal_position;

-- 4. Check auth.users column names
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'auth'
  AND table_name = 'users'
  AND column_name ILIKE '%meta%'
ORDER BY ordinal_position;
