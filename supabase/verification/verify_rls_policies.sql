-- =====================================================
-- BIMS - Complete RLS Policy Verification Script
-- =====================================================
-- Purpose: Verify all Row Level Security policies are correctly configured
-- Run this script in Supabase SQL Editor
-- Date: 2026-01-12
-- =====================================================

-- =====================================================
-- CHECK 1: Verify RLS is enabled on all tables
-- =====================================================
-- All 20 tables should have rowsecurity = true

SELECT
    'CHECK 1: RLS Status' as check_name,
    schemaname,
    tablename,
    CASE
        WHEN rowsecurity = true THEN '✅ ENABLED'
        ELSE '❌ DISABLED'
    END as rls_status
FROM pg_tables
WHERE schemaname = 'public'
AND tablename IN (
    'User_Tbl',
    'SK_Tbl',
    'Captain_Tbl',
    'Announcement_Tbl',
    'File_Tbl',
    'Pre_Project_Tbl',
    'Post_Project_Tbl',
    'Application_Tbl',
    'Inquiry_Tbl',
    'Reply_Tbl',
    'Notification_Tbl',
    'OTP_Tbl',
    'Certificate_Tbl',
    'Evaluation_Tbl',
    'Testimonies_Tbl',
    'BudgetBreakdown_Tbl',
    'Expenses_Tbl',
    'Annual_Budget_Tbl',
    'Report_Tbl',
    'Logs_Tbl'
)
ORDER BY tablename;

-- Expected: All 20 tables should show rls_status = '✅ ENABLED'

-- =====================================================
-- CHECK 2: Verify helper functions exist
-- =====================================================
-- Should have 4 helper functions for role checking

SELECT
    'CHECK 2: Helper Functions' as check_name,
    routine_name,
    routine_type,
    data_type as return_type,
    '✅ EXISTS' as status
FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_name IN (
    'is_sk_official',
    'is_captain',
    'is_sk_official_or_captain',
    'is_superadmin'
)
ORDER BY routine_name;

-- Expected: 4 functions should exist, all returning BOOLEAN

-- =====================================================
-- CHECK 3: List all RLS policies by table
-- =====================================================
-- Summary of policy counts per table

SELECT
    'CHECK 3: Policy Counts' as check_name,
    tablename,
    COUNT(*) as policy_count,
    STRING_AGG(cmd::text, ', ' ORDER BY cmd) as operations
FROM pg_policies
WHERE schemaname = 'public'
GROUP BY tablename
ORDER BY tablename;

-- Review: Each table should have appropriate number of policies
-- Most tables should have 3-6 policies covering SELECT, INSERT, UPDATE, DELETE

-- =====================================================
-- CHECK 4: Detailed policy inspection (All Tables)
-- =====================================================
-- Full list of all policies with their logic

SELECT
    'CHECK 4: All Policies' as check_name,
    tablename,
    policyname,
    cmd as operation,
    permissive,
    roles,
    SUBSTRING(qual::text, 1, 100) as using_expression_preview,
    SUBSTRING(with_check::text, 1, 100) as with_check_preview
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, cmd, policyname;

-- Review: Verify policy logic matches specification

-- =====================================================
-- CHECK 5: Announcement_Tbl Policies (Post v2.1)
-- =====================================================
-- Should have exactly 5 policies after v2.1 cleanup

SELECT
    'CHECK 5: Announcement Policies' as check_name,
    policyname,
    cmd as operation,
    CASE
        WHEN cmd = 'SELECT' AND policyname ILIKE '%public%' THEN '✅ Public SELECT'
        WHEN cmd = 'SELECT' AND policyname ILIKE '%authenticated%' THEN '✅ Authenticated SELECT'
        WHEN cmd = 'INSERT' AND policyname ILIKE '%sk%' THEN '✅ SK INSERT'
        WHEN cmd = 'UPDATE' AND policyname ILIKE '%sk%' THEN '✅ SK UPDATE'
        WHEN cmd = 'DELETE' AND policyname ILIKE '%sk%' THEN '✅ SK DELETE'
        ELSE '⚠️ Unexpected Policy'
    END as validation
FROM pg_policies
WHERE schemaname = 'public'
AND tablename = 'Announcement_Tbl'
ORDER BY cmd, policyname;

-- Expected: 5 policies (2 SELECT, 1 INSERT, 1 UPDATE, 1 DELETE)

-- =====================================================
-- CHECK 6: Verify contentStatus column was removed
-- =====================================================
-- Post v2.1, contentStatus should NOT exist

SELECT
    'CHECK 6: Announcement Schema' as check_name,
    column_name,
    data_type,
    CASE
        WHEN column_name = 'contentStatus' THEN '❌ SHOULD BE REMOVED'
        ELSE '✅ OK'
    END as status
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name = 'Announcement_Tbl'
AND column_name = 'contentStatus';

-- Expected: No results (column removed in v2.1)
-- If this returns rows, the column still exists and should be removed

-- =====================================================
-- CHECK 7: User_Tbl Policies
-- =====================================================
-- Verify user access control

SELECT
    'CHECK 7: User Policies' as check_name,
    policyname,
    cmd as operation,
    SUBSTRING(qual::text, 1, 80) as condition
FROM pg_policies
WHERE schemaname = 'public'
AND tablename = 'User_Tbl'
ORDER BY cmd, policyname;

-- Expected policies:
-- - Public can view active user profiles (SELECT)
-- - Users can view own profile (SELECT)
-- - SK Officials can view all profiles (SELECT)
-- - Users can update own profile (UPDATE)

-- =====================================================
-- CHECK 8: Captain Restrictions
-- =====================================================
-- Captain should NOT be able to INSERT announcements

SELECT
    'CHECK 8: Captain Announcement INSERT' as check_name,
    policyname,
    cmd as operation,
    CASE
        WHEN qual::text ILIKE '%is_captain%' THEN '❌ CAPTAIN SHOULD NOT INSERT'
        ELSE '✅ OK'
    END as validation
FROM pg_policies
WHERE schemaname = 'public'
AND tablename = 'Announcement_Tbl'
AND cmd = 'INSERT';

-- Expected: No policies allow Captain to INSERT
-- Only SK Officials should be able to INSERT

-- =====================================================
-- CHECK 9: File_Tbl Policies
-- =====================================================
-- Verify file access control

SELECT
    'CHECK 9: File Policies' as check_name,
    policyname,
    cmd as operation,
    SUBSTRING(qual::text, 1, 80) as condition
FROM pg_policies
WHERE schemaname = 'public'
AND tablename = 'File_Tbl'
ORDER BY cmd, policyname;

-- Expected policies:
-- - Public/authenticated can view ACTIVE files (SELECT)
-- - Captain can view ALL files (SELECT)
-- - SK Officials have full CRUD (INSERT, UPDATE, DELETE)

-- =====================================================
-- CHECK 10: Pre_Project_Tbl Policies
-- =====================================================
-- Verify project proposal access control

SELECT
    'CHECK 10: Project Policies' as check_name,
    policyname,
    cmd as operation,
    SUBSTRING(qual::text, 1, 80) as condition
FROM pg_policies
WHERE schemaname = 'public'
AND tablename = 'Pre_Project_Tbl'
ORDER BY cmd, policyname;

-- Expected policies:
-- - Public can view APPROVED projects (SELECT)
-- - Captain can view ALL projects (SELECT)
-- - SK Officials can create/update/delete projects (INSERT, UPDATE, DELETE)
-- - Captain can UPDATE projects (for approval/rejection)

-- =====================================================
-- CHECK 11: Application_Tbl Policies
-- =====================================================
-- Verify volunteer application access

SELECT
    'CHECK 11: Application Policies' as check_name,
    policyname,
    cmd as operation,
    SUBSTRING(qual::text, 1, 80) as condition
FROM pg_policies
WHERE schemaname = 'public'
AND tablename = 'Application_Tbl'
ORDER BY cmd, policyname;

-- Expected policies:
-- - Users can view own applications (SELECT)
-- - SK Officials can view all applications (SELECT)
-- - Users can create applications (INSERT)
-- - Users can update PENDING applications only (UPDATE)
-- - SK Officials can update application status (UPDATE)

-- =====================================================
-- CHECK 12: Notification_Tbl Policies
-- =====================================================
-- Verify notification access

SELECT
    'CHECK 12: Notification Policies' as check_name,
    policyname,
    cmd as operation,
    SUBSTRING(qual::text, 1, 80) as condition
FROM pg_policies
WHERE schemaname = 'public'
AND tablename = 'Notification_Tbl'
ORDER BY cmd, policyname;

-- Expected policies:
-- - Users can view own notifications (SELECT)
-- - System can create notifications (INSERT, WITH CHECK true)
-- - Users can update own notifications (UPDATE)
-- - Users can delete own notifications (DELETE)

-- =====================================================
-- CHECK 13: Find tables WITHOUT policies
-- =====================================================
-- Security risk if tables have RLS enabled but no policies

SELECT
    'CHECK 13: Missing Policies' as check_name,
    t.tablename,
    '❌ NO POLICIES DEFINED' as status
FROM pg_tables t
LEFT JOIN pg_policies p ON t.tablename = p.tablename
WHERE t.schemaname = 'public'
AND t.rowsecurity = true
AND p.policyname IS NULL;

-- Expected: No results (all tables should have policies)
-- If this returns rows, those tables need policies!

-- =====================================================
-- CHECK 14: Find duplicate policy names
-- =====================================================
-- Potential conflicts if same policy name appears multiple times

SELECT
    'CHECK 14: Duplicate Policies' as check_name,
    tablename,
    policyname,
    COUNT(*) as duplicate_count,
    '⚠️ DUPLICATE FOUND' as status
FROM pg_policies
WHERE schemaname = 'public'
GROUP BY tablename, policyname
HAVING COUNT(*) > 1;

-- Expected: No results (no duplicate policy names)
-- If this returns rows, there are conflicting policies

-- =====================================================
-- CHECK 15: Policy count per table
-- =====================================================
-- Verify expected minimum policy counts

SELECT
    'CHECK 15: Policy Count Analysis' as check_name,
    tablename,
    COUNT(*) as policy_count,
    CASE
        WHEN COUNT(*) = 0 THEN '❌ NO POLICIES'
        WHEN COUNT(*) < 2 THEN '⚠️ TOO FEW POLICIES'
        WHEN COUNT(*) BETWEEN 2 AND 10 THEN '✅ NORMAL'
        ELSE '⚠️ TOO MANY POLICIES'
    END as status
FROM pg_policies
WHERE schemaname = 'public'
GROUP BY tablename
ORDER BY policy_count DESC, tablename;

-- Review: Most tables should have 2-10 policies
-- Tables with 0 or 1 policy may have security gaps

-- =====================================================
-- CHECK 16: Role-based access summary
-- =====================================================
-- Count policies by role-checking function

SELECT
    'CHECK 16: Role Access' as check_name,
    CASE
        WHEN qual::text ILIKE '%is_sk_official%' THEN 'SK_OFFICIAL'
        WHEN qual::text ILIKE '%is_captain%' THEN 'CAPTAIN'
        WHEN qual::text ILIKE '%is_sk_official_or_captain%' THEN 'SK_OFFICIAL_OR_CAPTAIN'
        WHEN qual::text ILIKE '%is_superadmin%' THEN 'SUPERADMIN'
        WHEN qual::text ILIKE '%auth.uid%' THEN 'AUTHENTICATED_USER'
        WHEN qual::text = 'true' THEN 'PUBLIC'
        ELSE 'OTHER'
    END as access_type,
    COUNT(*) as policy_count
FROM pg_policies
WHERE schemaname = 'public'
GROUP BY access_type
ORDER BY policy_count DESC;

-- Review: Distribution of policies across role types

-- =====================================================
-- CHECK 17: Tables missing critical operations
-- =====================================================
-- Find tables that might be missing SELECT, INSERT, UPDATE, or DELETE policies

WITH policy_ops AS (
    SELECT
        tablename,
        ARRAY_AGG(DISTINCT cmd::text) as operations
    FROM pg_policies
    WHERE schemaname = 'public'
    GROUP BY tablename
)
SELECT
    'CHECK 17: Missing Operations' as check_name,
    tablename,
    operations,
    CASE
        WHEN NOT ('SELECT' = ANY(operations)) THEN '⚠️ Missing SELECT'
        WHEN NOT ('INSERT' = ANY(operations)) THEN '⚠️ Missing INSERT'
        ELSE '✅ Has basic operations'
    END as status
FROM policy_ops
ORDER BY tablename;

-- Review: Most tables should at least have SELECT and INSERT policies

-- =====================================================
-- CHECK 18: Verify OTP_Tbl security
-- =====================================================
-- OTP codes should only be accessible to the user they belong to

SELECT
    'CHECK 18: OTP Security' as check_name,
    policyname,
    cmd as operation,
    SUBSTRING(qual::text, 1, 80) as condition,
    CASE
        WHEN qual::text ILIKE '%auth.uid%' THEN '✅ User-scoped'
        WHEN qual::text ILIKE '%is_sk_official%' OR qual::text ILIKE '%is_captain%' THEN '❌ SHOULD BE USER-ONLY'
        ELSE '⚠️ Review needed'
    END as validation
FROM pg_policies
WHERE schemaname = 'public'
AND tablename = 'OTP_Tbl'
ORDER BY cmd, policyname;

-- Expected: OTP access should be limited to owning user only

-- =====================================================
-- CHECK 19: Verify Testimonies_Tbl filtering
-- =====================================================
-- Public should only see unfiltered testimonies

SELECT
    'CHECK 19: Testimony Filtering' as check_name,
    policyname,
    cmd as operation,
    SUBSTRING(qual::text, 1, 80) as condition,
    CASE
        WHEN cmd = 'SELECT' AND qual::text ILIKE '%isFiltered%false%' THEN '✅ Filtered for public'
        WHEN cmd = 'SELECT' AND qual::text ILIKE '%is_sk_official%' THEN '✅ SK can see all'
        ELSE '⚠️ Review needed'
    END as validation
FROM pg_policies
WHERE schemaname = 'public'
AND tablename = 'Testimonies_Tbl'
AND cmd = 'SELECT'
ORDER BY policyname;

-- Expected: Public sees isFiltered=false, SK Officials see all

-- =====================================================
-- CHECK 20: Verify Budget/Expenses policies
-- =====================================================
-- Budget data should be viewable by public but manageable only by SK Officials

SELECT
    'CHECK 20: Budget Policies' as check_name,
    tablename,
    policyname,
    cmd as operation,
    SUBSTRING(qual::text, 1, 60) as condition
FROM pg_policies
WHERE schemaname = 'public'
AND tablename IN ('BudgetBreakdown_Tbl', 'Expenses_Tbl', 'Annual_Budget_Tbl')
ORDER BY tablename, cmd, policyname;

-- Expected: Public SELECT allowed, SK Officials have full CRUD

-- =====================================================
-- VERIFICATION SUMMARY
-- =====================================================

SELECT
    '🎯 VERIFICATION COMPLETE' as status,
    'Review the results above to identify any RLS policy issues' as instructions,
    'All tables should have RLS enabled and appropriate policies' as expectation,
    'Run individual checks again if issues are found' as next_steps;

-- =====================================================
-- End of RLS Verification Script
-- =====================================================
