-- ============================================
-- REMOVE ANNOUNCEMENT ARCHIVE FUNCTIONALITY
-- ============================================
-- This script will:
-- 1. Delete all archived announcements (if any exist)
-- 2. Drop RLS policies that depend on contentStatus
-- 3. Remove the contentStatus column from Announcement_Tbl
-- 4. Create new RLS policies without contentStatus
-- ============================================

-- Step 1: View all announcements (to see what will be deleted)
SELECT
  "announcementID",
  "title",
  "contentStatus",
  "publishedDate",
  "createdAt"
FROM "Announcement_Tbl"
ORDER BY "contentStatus", "publishedDate" DESC;

-- Step 2: Delete all ARCHIVED announcements permanently
-- This is a safety step before removing the column
DELETE FROM "Announcement_Tbl"
WHERE "contentStatus" = 'ARCHIVED';

-- Verify all archived announcements are deleted
SELECT COUNT(*) as archived_count
FROM "Announcement_Tbl"
WHERE "contentStatus" = 'ARCHIVED';
-- Should return 0

-- Step 3: Drop RLS policies that depend on contentStatus
-- These policies must be dropped before we can remove the column

-- Drop the policy that allows public to view active announcements
DROP POLICY IF EXISTS "Public can view active announcements" ON "Announcement_Tbl";

-- Drop the policy that allows captain to view archived announcements
DROP POLICY IF EXISTS "Captain can view archived announcements" ON "Announcement_Tbl";

-- Drop any other policies that might reference contentStatus
DROP POLICY IF EXISTS "SK Officials can view all announcements" ON "Announcement_Tbl";
DROP POLICY IF EXISTS "Youth volunteers can view active announcements" ON "Announcement_Tbl";

-- Step 4: Remove the contentStatus column from Announcement_Tbl
ALTER TABLE "Announcement_Tbl"
DROP COLUMN IF EXISTS "contentStatus";

-- Step 5: Create NEW RLS policies without contentStatus

-- Public can view all announcements (no contentStatus filter)
CREATE POLICY "Public can view all announcements"
ON "Announcement_Tbl"
FOR SELECT
TO public
USING (true);

-- Authenticated users can view all announcements
CREATE POLICY "Authenticated users can view all announcements"
ON "Announcement_Tbl"
FOR SELECT
TO authenticated
USING (true);

-- SK Officials can insert announcements
CREATE POLICY "SK Officials can insert announcements"
ON "Announcement_Tbl"
FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM "User_Tbl"
    WHERE "userID" = auth.uid()
    AND "role" = 'SK_OFFICIAL'
    AND "accountStatus" = 'ACTIVE'
  )
);

-- SK Officials can update ALL announcements (regardless of who posted them)
CREATE POLICY "SK Officials can update all announcements"
ON "Announcement_Tbl"
FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM "User_Tbl"
    WHERE "userID" = auth.uid()
    AND "role" = 'SK_OFFICIAL'
    AND "accountStatus" = 'ACTIVE'
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM "User_Tbl"
    WHERE "userID" = auth.uid()
    AND "role" = 'SK_OFFICIAL'
    AND "accountStatus" = 'ACTIVE'
  )
);

-- SK Officials can delete ALL announcements (regardless of who posted them)
CREATE POLICY "SK Officials can delete all announcements"
ON "Announcement_Tbl"
FOR DELETE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM "User_Tbl"
    WHERE "userID" = auth.uid()
    AND "role" = 'SK_OFFICIAL'
    AND "accountStatus" = 'ACTIVE'
  )
);

-- Step 6: Verify the column is removed
-- This query should show all columns in Announcement_Tbl (contentStatus should NOT be listed)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'Announcement_Tbl'
ORDER BY ordinal_position;

-- Step 7: View final table structure
SELECT
  "announcementID",
  "userID",
  "title",
  "category",
  "description",
  "imagePathURL",
  "publishedDate",
  "createdAt",
  "updatedAt"
FROM "Announcement_Tbl"
ORDER BY "publishedDate" DESC
LIMIT 10;

-- Step 8: Verify RLS policies are created
SELECT
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd
FROM pg_policies
WHERE tablename = 'Announcement_Tbl'
ORDER BY policyname;

-- ============================================
-- IMPORTANT NOTES:
-- ============================================
-- 1. This permanently deletes all archived announcements
-- 2. The contentStatus column will be removed - this cannot be undone
-- 3. RLS policies are recreated without contentStatus references
-- 4. After running this, announcements will only support hard delete
-- 5. All users (public, authenticated) can view ALL announcements
-- 6. SK Officials have FULL CRUD on ALL announcements (regardless of who posted them)
-- ============================================

-- ============================================
-- ROLLBACK PLAN (if needed):
-- ============================================
-- If you need to rollback and restore the archive functionality:
--
-- 1. Add contentStatus column back:
-- ALTER TABLE "Announcement_Tbl"
-- ADD COLUMN "contentStatus" VARCHAR(20) DEFAULT 'ACTIVE';
--
-- 2. Update existing rows:
-- UPDATE "Announcement_Tbl"
-- SET "contentStatus" = 'ACTIVE'
-- WHERE "contentStatus" IS NULL;
--
-- 3. Drop new policies and recreate old ones with contentStatus filters
-- 4. Update frontend code to use soft delete again
-- ============================================
