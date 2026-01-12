-- ============================================
-- Simple Query to Find Exact Table Names
-- ============================================

-- This will show ALL table names with exact casing
SELECT
  table_name,
  table_schema,
  table_type
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- This will show us if we need quotes
SELECT
  tablename AS "Actual_Table_Name"
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;
