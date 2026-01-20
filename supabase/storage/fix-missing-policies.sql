-- ============================================================================
-- Fix Missing Storage Policies for user-images Bucket
-- ============================================================================
-- Run this to check and create the missing storage policies
-- ============================================================================

-- Step 1: Check ALL existing policies on storage.objects
-- ============================================================================
SELECT
  policyname,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE schemaname = 'storage'
AND tablename = 'objects'
ORDER BY cmd, policyname;

-- Step 2: Drop existing policies if they have wrong names (optional)
-- ============================================================================
-- Uncomment these if you want to start fresh:
-- DROP POLICY IF EXISTS "Public can view user images" ON storage.objects;
-- DROP POLICY IF EXISTS "Users can upload own images" ON storage.objects;
-- DROP POLICY IF EXISTS "Users can update own images" ON storage.objects;
-- DROP POLICY IF EXISTS "Users can delete own images" ON storage.objects;

-- Step 3: Create the missing policies
-- ============================================================================

-- Policy 1: Public can view (should already exist, but including for completeness)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'storage'
    AND tablename = 'objects'
    AND policyname = 'Public can view user images'
  ) THEN
    CREATE POLICY "Public can view user images"
    ON storage.objects FOR SELECT
    USING (bucket_id = 'user-images');
  END IF;
END $$;

-- Policy 2: Users can upload their own images
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'storage'
    AND tablename = 'objects'
    AND policyname = 'Users can upload own images'
  ) THEN
    CREATE POLICY "Users can upload own images"
    ON storage.objects FOR INSERT
    WITH CHECK (
      bucket_id = 'user-images' AND
      (storage.foldername(name))[1] = auth.uid()::text
    );
  END IF;
END $$;

-- Policy 3: Users can update their own images
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'storage'
    AND tablename = 'objects'
    AND policyname = 'Users can update own images'
  ) THEN
    CREATE POLICY "Users can update own images"
    ON storage.objects FOR UPDATE
    USING (
      bucket_id = 'user-images' AND
      (storage.foldername(name))[1] = auth.uid()::text
    )
    WITH CHECK (
      bucket_id = 'user-images' AND
      (storage.foldername(name))[1] = auth.uid()::text
    );
  END IF;
END $$;

-- Policy 4: Users can delete their own images
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'storage'
    AND tablename = 'objects'
    AND policyname = 'Users can delete own images'
  ) THEN
    CREATE POLICY "Users can delete own images"
    ON storage.objects FOR DELETE
    USING (
      bucket_id = 'user-images' AND
      (storage.foldername(name))[1] = auth.uid()::text
    );
  END IF;
END $$;

-- Step 4: Verify all policies were created
-- ============================================================================
SELECT
  policyname,
  cmd,
  CASE
    WHEN cmd = 'SELECT' THEN '✅ Public can view'
    WHEN cmd = 'INSERT' THEN '✅ Users can upload own'
    WHEN cmd = 'UPDATE' THEN '✅ Users can update own'
    WHEN cmd = 'DELETE' THEN '✅ Users can delete own'
  END as description
FROM pg_policies
WHERE schemaname = 'storage'
AND tablename = 'objects'
AND policyname LIKE '%user images%'
ORDER BY cmd;

-- Expected result: 4 rows
-- SELECT  | ✅ Public can view
-- INSERT  | ✅ Users can upload own
-- UPDATE  | ✅ Users can update own
-- DELETE  | ✅ Users can delete own

-- ============================================================================
-- Alternative: Simpler policies (if the above doesn't work)
-- ============================================================================
-- If the folder name check causes issues, use these simpler versions:

-- DROP POLICY IF EXISTS "Users can upload own images" ON storage.objects;
-- CREATE POLICY "Users can upload own images"
-- ON storage.objects FOR INSERT
-- WITH CHECK (
--   bucket_id = 'user-images' AND
--   auth.uid()::text IS NOT NULL
-- );

-- DROP POLICY IF EXISTS "Users can update own images" ON storage.objects;
-- CREATE POLICY "Users can update own images"
-- ON storage.objects FOR UPDATE
-- USING (
--   bucket_id = 'user-images' AND
--   auth.uid()::text IS NOT NULL
-- );

-- DROP POLICY IF EXISTS "Users can delete own images" ON storage.objects;
-- CREATE POLICY "Users can delete own images"
-- ON storage.objects FOR DELETE
-- USING (
--   bucket_id = 'user-images' AND
--   auth.uid()::text IS NOT NULL
-- );
