-- ============================================
-- STORAGE VERIFICATION QUERIES
-- Run these in Supabase SQL Editor
-- ============================================

-- 1. Check if announcement-images bucket exists
SELECT
    id,
    name,
    public,
    created_at
FROM storage.buckets
WHERE id = 'announcement-images';

-- Expected: Should return 1 row with public = true

-- ============================================

-- 2. Check all storage buckets
SELECT
    id,
    name,
    public,
    created_at
FROM storage.buckets
ORDER BY created_at DESC;

-- ============================================

-- 3. Check RLS policies for announcement-images bucket
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies
WHERE tablename = 'objects'
AND policyname ILIKE '%announcement%';

-- Expected: Should return 4 policies:
-- - SK Officials can upload announcement images (INSERT)
-- - SK Officials can update announcement images (UPDATE)
-- - SK Officials can delete announcement images (DELETE)
-- - Public can view announcement images (SELECT)

-- ============================================

-- 4. Check if current user has correct role for upload
SELECT
    userID,
    email,
    role,
    accountStatus
FROM public.User_Tbl
WHERE userID = auth.uid();

-- Expected: role should be 'SK_OFFICIAL' or 'CAPTAIN'

-- ============================================

-- 5. List all files in announcement-images bucket
SELECT
    name,
    bucket_id,
    created_at,
    metadata->>'size' as size_bytes,
    metadata->>'mimetype' as mime_type
FROM storage.objects
WHERE bucket_id = 'announcement-images'
ORDER BY created_at DESC
LIMIT 10;

-- ============================================

-- 6. Test upload permission (dry run - doesn't actually upload)
-- This checks if your current user can upload to the bucket
SELECT
    EXISTS (
        SELECT 1 FROM public.User_Tbl
        WHERE userID = auth.uid()
        AND role IN ('SK_OFFICIAL', 'CAPTAIN')
        AND accountStatus = 'ACTIVE'
    ) as can_upload_announcement_images;

-- Expected: should return true

-- ============================================

-- 7. Check all storage policies (comprehensive)
SELECT
    policyname,
    cmd,
    permissive,
    roles,
    substring(qual, 1, 100) as condition_preview
FROM pg_policies
WHERE tablename = 'objects'
AND schemaname = 'storage'
ORDER BY policyname;

-- ============================================

-- 8. Verify bucket is public (alternative check)
SELECT
    b.id,
    b.name,
    b.public,
    COUNT(o.name) as file_count
FROM storage.buckets b
LEFT JOIN storage.objects o ON b.id = o.bucket_id
WHERE b.id = 'announcement-images'
GROUP BY b.id, b.name, b.public;

-- ============================================
-- TROUBLESHOOTING
-- ============================================

-- If bucket doesn't exist, create it:
/*
INSERT INTO storage.buckets (id, name, public)
VALUES ('announcement-images', 'announcement-images', true)
ON CONFLICT (id) DO NOTHING;
*/

-- If policies are missing, they might have different names
-- Check all policies:
/*
SELECT policyname
FROM pg_policies
WHERE tablename = 'objects'
AND schemaname = 'storage';
*/
