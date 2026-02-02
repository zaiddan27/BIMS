-- =====================================================
-- Diagnose the inquiry_tbl relation issue
-- =====================================================

-- 1. Check if Inquiry_Tbl exists (with exact casing)
SELECT
    tablename,
    schemaname
FROM pg_tables
WHERE tablename ILIKE '%inquiry%';

-- 2. Check for any triggers on Reply_Tbl
SELECT
    trigger_name,
    event_manipulation,
    action_statement
FROM information_schema.triggers
WHERE event_object_table = 'Reply_Tbl';

-- 3. Check all foreign keys on Reply_Tbl with their actual definitions
SELECT
    conname AS constraint_name,
    conrelid::regclass AS table_name,
    confrelid::regclass AS referenced_table,
    pg_get_constraintdef(oid) AS constraint_definition
FROM pg_constraint
WHERE conrelid = '"Reply_Tbl"'::regclass
    AND contype = 'f';

-- 4. Check RLS policies on Reply_Tbl
SELECT
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE tablename = 'Reply_Tbl';

-- 5. Try a simple test insert (this will show the exact error)
-- Comment this out if you don't want to test
/*
INSERT INTO "Reply_Tbl" ("inquiryID", "userID", "message", "timeStamp", "createdAt")
VALUES (1, auth.uid(), 'Test message', NOW(), NOW());
*/
