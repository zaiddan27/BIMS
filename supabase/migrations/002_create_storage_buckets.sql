-- ============================================
-- BIMS Storage Buckets Configuration
-- Barangay Information Management System
-- ============================================

-- ============================================
-- CREATE STORAGE BUCKETS
-- ============================================

-- Bucket for user profile images
INSERT INTO storage.buckets (id, name, public)
VALUES ('user-images', 'user-images', true)
ON CONFLICT (id) DO NOTHING;

-- Bucket for announcement images
INSERT INTO storage.buckets (id, name, public)
VALUES ('announcement-images', 'announcement-images', true)
ON CONFLICT (id) DO NOTHING;

-- Bucket for project images
INSERT INTO storage.buckets (id, name, public)
VALUES ('project-images', 'project-images', true)
ON CONFLICT (id) DO NOTHING;

-- Bucket for general files (PDFs, Excel, Word documents)
INSERT INTO storage.buckets (id, name, public)
VALUES ('general-files', 'general-files', true)
ON CONFLICT (id) DO NOTHING;

-- Bucket for project files
INSERT INTO storage.buckets (id, name, public)
VALUES ('project-files', 'project-files', true)
ON CONFLICT (id) DO NOTHING;

-- Bucket for parental consent forms
INSERT INTO storage.buckets (id, name, public)
VALUES ('consent-forms', 'consent-forms', false)
ON CONFLICT (id) DO NOTHING;

-- Bucket for expense receipts
INSERT INTO storage.buckets (id, name, public)
VALUES ('receipts', 'receipts', false)
ON CONFLICT (id) DO NOTHING;

-- Bucket for volunteer certificates
INSERT INTO storage.buckets (id, name, public)
VALUES ('certificates', 'certificates', false)
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- STORAGE POLICIES - user-images bucket
-- ============================================

-- Allow authenticated users to upload their own profile images
CREATE POLICY "Users can upload their own profile images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'user-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Allow users to update their own profile images
CREATE POLICY "Users can update their own profile images"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'user-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Allow users to delete their own profile images
CREATE POLICY "Users can delete their own profile images"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'user-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Allow public read access to profile images
CREATE POLICY "Public can view profile images"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'user-images');

-- ============================================
-- STORAGE POLICIES - announcement-images bucket
-- ============================================

-- Allow SK Officials to upload announcement images
CREATE POLICY "SK Officials can upload announcement images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'announcement-images' AND
  EXISTS (
    SELECT 1 FROM public.User_Tbl
    WHERE userID = auth.uid() AND role IN ('SK_OFFICIAL', 'CAPTAIN')
  )
);

-- Allow SK Officials to update announcement images
CREATE POLICY "SK Officials can update announcement images"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'announcement-images' AND
  EXISTS (
    SELECT 1 FROM public.User_Tbl
    WHERE userID = auth.uid() AND role IN ('SK_OFFICIAL', 'CAPTAIN')
  )
);

-- Allow SK Officials to delete announcement images
CREATE POLICY "SK Officials can delete announcement images"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'announcement-images' AND
  EXISTS (
    SELECT 1 FROM public.User_Tbl
    WHERE userID = auth.uid() AND role IN ('SK_OFFICIAL', 'CAPTAIN')
  )
);

-- Allow public read access to announcement images
CREATE POLICY "Public can view announcement images"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'announcement-images');

-- ============================================
-- STORAGE POLICIES - project-images bucket
-- ============================================

-- Allow SK Officials to upload project images
CREATE POLICY "SK Officials can upload project images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'project-images' AND
  EXISTS (
    SELECT 1 FROM public.User_Tbl
    WHERE userID = auth.uid() AND role IN ('SK_OFFICIAL', 'CAPTAIN')
  )
);

-- Allow SK Officials to update project images
CREATE POLICY "SK Officials can update project images"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'project-images' AND
  EXISTS (
    SELECT 1 FROM public.User_Tbl
    WHERE userID = auth.uid() AND role IN ('SK_OFFICIAL', 'CAPTAIN')
  )
);

-- Allow SK Officials to delete project images
CREATE POLICY "SK Officials can delete project images"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'project-images' AND
  EXISTS (
    SELECT 1 FROM public.User_Tbl
    WHERE userID = auth.uid() AND role IN ('SK_OFFICIAL', 'CAPTAIN')
  )
);

-- Allow public read access to project images
CREATE POLICY "Public can view project images"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'project-images');

-- ============================================
-- STORAGE POLICIES - general-files bucket
-- ============================================

-- Allow SK Officials to upload general files
CREATE POLICY "SK Officials can upload general files"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'general-files' AND
  EXISTS (
    SELECT 1 FROM public.User_Tbl
    WHERE userID = auth.uid() AND role IN ('SK_OFFICIAL', 'CAPTAIN')
  )
);

-- Allow SK Officials to delete general files
CREATE POLICY "SK Officials can delete general files"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'general-files' AND
  EXISTS (
    SELECT 1 FROM public.User_Tbl
    WHERE userID = auth.uid() AND role IN ('SK_OFFICIAL', 'CAPTAIN')
  )
);

-- Allow public read access to general files
CREATE POLICY "Public can view general files"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'general-files');

-- ============================================
-- STORAGE POLICIES - project-files bucket
-- ============================================

-- Allow SK Officials to upload project files
CREATE POLICY "SK Officials can upload project files"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'project-files' AND
  EXISTS (
    SELECT 1 FROM public.User_Tbl
    WHERE userID = auth.uid() AND role IN ('SK_OFFICIAL', 'CAPTAIN')
  )
);

-- Allow SK Officials to delete project files
CREATE POLICY "SK Officials can delete project files"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'project-files' AND
  EXISTS (
    SELECT 1 FROM public.User_Tbl
    WHERE userID = auth.uid() AND role IN ('SK_OFFICIAL', 'CAPTAIN')
  )
);

-- Allow public read access to project files
CREATE POLICY "Public can view project files"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'project-files');

-- ============================================
-- STORAGE POLICIES - consent-forms bucket (PRIVATE)
-- ============================================

-- Allow authenticated users to upload consent forms
CREATE POLICY "Users can upload consent forms"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'consent-forms' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Allow SK Officials and file owners to view consent forms
CREATE POLICY "SK Officials and owners can view consent forms"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'consent-forms' AND (
    auth.uid()::text = (storage.foldername(name))[1] OR
    EXISTS (
      SELECT 1 FROM public.User_Tbl
      WHERE userID = auth.uid() AND role IN ('SK_OFFICIAL', 'CAPTAIN')
    )
  )
);

-- ============================================
-- STORAGE POLICIES - receipts bucket (PRIVATE)
-- ============================================

-- Allow SK Officials to upload receipts
CREATE POLICY "SK Officials can upload receipts"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'receipts' AND
  EXISTS (
    SELECT 1 FROM public.User_Tbl
    WHERE userID = auth.uid() AND role IN ('SK_OFFICIAL', 'CAPTAIN')
  )
);

-- Allow SK Officials and Captain to view receipts
CREATE POLICY "SK Officials can view receipts"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'receipts' AND
  EXISTS (
    SELECT 1 FROM public.User_Tbl
    WHERE userID = auth.uid() AND role IN ('SK_OFFICIAL', 'CAPTAIN')
  )
);

-- ============================================
-- STORAGE POLICIES - certificates bucket (PRIVATE)
-- ============================================

-- Allow SK Officials to upload certificates
CREATE POLICY "SK Officials can upload certificates"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'certificates' AND
  EXISTS (
    SELECT 1 FROM public.User_Tbl
    WHERE userID = auth.uid() AND role IN ('SK_OFFICIAL', 'CAPTAIN')
  )
);

-- Allow certificate owners and SK Officials to view certificates
CREATE POLICY "Users can view their own certificates"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'certificates' AND (
    auth.uid()::text = (storage.foldername(name))[1] OR
    EXISTS (
      SELECT 1 FROM public.User_Tbl
      WHERE userID = auth.uid() AND role IN ('SK_OFFICIAL', 'CAPTAIN')
    )
  )
);
