-- ============================================
-- CLEANUP DUPLICATE ANNOUNCEMENT RLS POLICIES
-- ============================================
-- This script removes duplicate and restrictive policies
-- Keeps only the necessary policies for SK Officials to have
-- FULL CRUD access to ALL announcements
-- ============================================

-- Step 1: View current policies (before cleanup)
SELECT
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd
FROM pg_policies
WHERE tablename = 'Announcement_Tbl'
ORDER BY cmd, policyname;

-- Step 2: Drop duplicate and restrictive policies

-- Drop restrictive "their" policies (SK Officials should access ALL announcements)
DROP POLICY IF EXISTS "SK Officials can delete their announcements" ON "Announcement_Tbl";
DROP POLICY IF EXISTS "SK Officials can update their announcements" ON "Announcement_Tbl";

-- Drop duplicate INSERT policy
DROP POLICY IF EXISTS "SK Officials can create announcements" ON "Announcement_Tbl";

-- Drop duplicate UPDATE policy
DROP POLICY IF EXISTS "SK Officials can update announcements" ON "Announcement_Tbl";

-- Step 3: View final policies (after cleanup)
SELECT
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd
FROM pg_policies
WHERE tablename = 'Announcement_Tbl'
ORDER BY cmd, policyname;

-- ============================================
-- EXPECTED RESULT: 5 Policies Remaining
-- ============================================
-- SELECT Policies (2):
--   1. "Public can view all announcements" (public)
--   2. "Authenticated users can view all announcements" (authenticated)
--
-- INSERT Policies (1):
--   3. "SK Officials can insert announcements" (authenticated)
--
-- UPDATE Policies (1):
--   4. "SK Officials can update all announcements" (authenticated)
--
-- DELETE Policies (1):
--   5. "SK Officials can delete all announcements" (authenticated)
-- ============================================

-- Step 4: Test the policies work correctly
-- Try to insert as SK Official (should succeed)
-- Try to update any announcement as SK Official (should succeed)
-- Try to delete any announcement as SK Official (should succeed)

-- ============================================
-- SUMMARY OF REMOVED POLICIES:
-- ============================================
-- ❌ "SK Officials can delete their announcements" (too restrictive)
-- ❌ "SK Officials can update their announcements" (too restrictive)
-- ❌ "SK Officials can create announcements" (duplicate of insert)
-- ❌ "SK Officials can update announcements" (duplicate of update all)
-- ============================================
