-- ============================================
-- Check Column Names in User_Tbl
-- ============================================

-- Check User_Tbl columns (use lowercase in WHERE clause for information_schema)
SELECT
  column_name AS "Column_Name",
  data_type AS "Data_Type"
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'User_Tbl'  -- information_schema stores it as-is
ORDER BY ordinal_position;

-- Alternative: Direct query to test if columns are camelCase or lowercase
-- Try with quotes first
SELECT
  "userID",
  "email",
  "firstName",
  "lastName",
  "role",
  "accountStatus"
FROM "User_Tbl"
LIMIT 1;
