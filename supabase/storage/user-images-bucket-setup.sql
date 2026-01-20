-- ============================================================================
-- BIMS Storage Bucket Setup: user-images
-- ============================================================================
-- This script sets up the storage bucket for user profile pictures
-- Run this in your Supabase SQL Editor
-- ============================================================================

-- Step 1: Create the user-images bucket
-- ============================================================================
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'user-images',
  'user-images',
  true,  -- Public bucket (images are publicly accessible)
  5242880,  -- 5MB file size limit
  ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp']
)
ON CONFLICT (id) DO UPDATE SET
  public = true,
  file_size_limit = 5242880,
  allowed_mime_types = ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];

-- Step 2: Create storage policies for user-images bucket
-- ============================================================================

-- Policy 1: Public can view all images (for profile pictures to be visible)
CREATE POLICY "Public can view user images"
ON storage.objects FOR SELECT
USING (bucket_id = 'user-images');

-- Policy 2: Authenticated users can upload their own images
CREATE POLICY "Users can upload own images"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'user-images' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

-- Policy 3: Users can update their own images
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

-- Policy 4: Users can delete their own images
CREATE POLICY "Users can delete own images"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'user-images' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

-- ============================================================================
-- Verification Queries
-- ============================================================================

-- Verify bucket was created
SELECT
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
FROM storage.buckets
WHERE id = 'user-images';

-- Verify storage policies
SELECT
  policyname,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE schemaname = 'storage'
AND tablename = 'objects'
AND policyname LIKE '%user images%';

-- ============================================================================
-- Test Queries (Optional - for debugging)
-- ============================================================================

-- Check if you can read images from the bucket
-- SELECT * FROM storage.objects WHERE bucket_id = 'user-images' LIMIT 10;

-- Check current user's images
-- SELECT
--   name,
--   metadata,
--   created_at,
--   updated_at
-- FROM storage.objects
-- WHERE bucket_id = 'user-images'
-- AND (storage.foldername(name))[1] = auth.uid()::text;

-- ============================================================================
-- Notes
-- ============================================================================
-- 1. File structure: user-images/{userID}/{filename}
-- 2. Public read access allows profile pictures to be displayed without authentication
-- 3. Upload/Update/Delete restricted to file owner (folder name must match user ID)
-- 4. Maximum file size: 5MB
-- 5. Allowed formats: JPEG, JPG, PNG, GIF, WEBP
-- ============================================================================
