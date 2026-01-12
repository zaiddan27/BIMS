# Supabase Storage Setup for BIMS

**Date**: 2026-01-11
**Status**: 📋 Setup Required
**Critical**: This must be configured for image uploads to work

---

## ⚠️ CURRENT ISSUE

**Problem**: Image uploads failing because storage bucket doesn't exist
**Bucket Name Used in Code**: `bims-files`
**Location in Code**:

- sk-dashboard.html Lines 1939, 1952 (CREATE)
- sk-dashboard.html Lines 2130, 2143 (UPDATE/EDIT)

---

## 📦 STORAGE BUCKETS USED IN BIMS

| Bucket Name    | Purpose                              | Used By           | Public Access | Created               |
| -------------- | ------------------------------------ | ----------------- | ------------- | --------------------- |
| **bims-files** | Announcement banners/images          | sk-dashboard.html | ✅ Yes        | ❌ **NEEDS CREATION** |
| user-avatars   | User profile pictures                | (Future)          | ✅ Yes        | ❌ Not yet            |
| project-images | Project banners                      | (Future)          | ✅ Yes        | ❌ Not yet            |
| certificates   | Volunteer certificates               | (Future)          | ✅ Yes        | ❌ Not yet            |
| documents      | Uploaded documents (PDF, XLSX, etc.) | (Future)          | ✅ Yes        | ❌ Not yet            |

---

## 🛠️ STEP-BY-STEP: CREATE STORAGE BUCKET

### Step 1: Go to Supabase Storage

1. Open your Supabase dashboard: https://supabase.com/dashboard/project/vreuvpzxnvrhftafmado
2. Click on **"Storage"** in the left sidebar (🗄️ icon)
3. You should see the Storage page

### Step 2: Create the `bims-files` Bucket

1. Click the **"New bucket"** button (top right)
2. Fill in the form:
   ```
   Name: bims-files
   Public bucket: ✅ CHECKED (Important!)
   File size limit: 5 MB (or leave default 50 MB)
   Allowed MIME types: Leave empty (we validate in code)
   ```
3. Click **"Create bucket"**

### Step 3: Create Folder Structure (Optional but Recommended)

After creating the bucket, you can create folders for organization:

1. Click on the **`bims-files`** bucket
2. Click **"Upload"** → **"Create folder"**
3. Create these folders:
   - `announcement-images/` - For announcement banners (used by sk-dashboard.html)
   - `user avatars/` - For user profile pictures (future)
   - `project images/` - For project banners (future)
   - `certificates/` - For volunteer certificates (future)
   - `documents/` - For uploaded files (future)

**Note**: Folders are automatically created when you upload with paths like `announcement-images/file.jpg`, so this step is optional.

### Step 4: Verify Bucket Permissions

1. Click on the **`bims-files`** bucket
2. Click on **"Policies"** tab (or ⚙️ Settings)
3. You should see:
   ```
   Public access: Enabled
   ```

**IMPORTANT**: If public access is NOT enabled, do this:

1. Go to Storage → bims-files → Settings
2. Toggle **"Public bucket"** to ON
3. Save changes

---

## 🔐 SECURITY: ROW LEVEL SECURITY POLICIES

After creating the bucket, you need to set up storage policies.

### Option 1: Allow All Public Access (Quick Setup for Testing)

1. Go to **Storage** → **Policies** → **bims-files**
2. Click **"New policy"**
3. Select **"Get started quickly"** → **"Allow public access"**
4. This creates policies for:
   - ✅ SELECT (read/download)
   - ✅ INSERT (upload)
   - ✅ UPDATE (replace)
   - ✅ DELETE (remove)

### Option 2: Restrict Upload to Authenticated Users (Recommended for Production)

**Policy 1: Public Read Access**

```sql
-- Anyone can view/download files
CREATE POLICY "Public Access"
ON storage.objects FOR SELECT
USING ( bucket_id = 'bims-files' );
```

**Policy 2: Authenticated Users Can Upload**

```sql
-- Only logged-in users can upload
CREATE POLICY "Authenticated users can upload files"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'bims-files'
  AND auth.role() = 'authenticated'
);
```

**Policy 3: Users Can Update Their Own Files**

```sql
-- Users can update files they uploaded
CREATE POLICY "Users can update own files"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'bims-files'
  AND auth.uid() = owner
);
```

**Policy 4: Users Can Delete Their Own Files**

```sql
-- Users can delete files they uploaded
CREATE POLICY "Users can delete own files"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'bims-files'
  AND auth.uid() = owner
);
```

---

## 📁 FILE STRUCTURE IN BUCKET

When announcements are uploaded, files are stored with this structure:

```
bims-files/
├── announcement-images/
│   ├── announcement_1736605535123.jpg
│   ├── announcement_1736605535456.png
│   ├── announcement_1736605535789.webp
│   └── ...
└── (future folders)
    ├── user avatars/
    ├── project images/
    ├── certificates/
    └── documents/
```

**Naming Convention**:

- Prefix: `announcement_`
- Timestamp: `Date.now()` (milliseconds since epoch)
- Extension: Based on MIME type (`.jpg`, `.png`, `.gif`, `.webp`)

**Example**: `announcement_1736605535123.jpg`

**Folder**: `announcement-images/` (with space, not hyphen)

---

## 🔍 VERIFICATION STEPS

After setting up the bucket, verify it works:

### Test 1: Check Bucket Exists

1. Go to Storage in Supabase dashboard
2. You should see **bims-files** bucket listed
3. Click on it - should open without errors

### Test 2: Test Upload from Dashboard

1. Click on **bims-files** bucket
2. Click **"Upload"** → **"Upload files"**
3. Select a test image from your computer
4. Upload it
5. You should see the file appear in the bucket

### Test 3: Test Public Access

1. Click on the uploaded test file
2. Copy the public URL (looks like: `https://vreuvpzxnvrhftafmado.supabase.co/storage/v1/object/public/bims-files/test.jpg`)
3. Open that URL in a new browser tab
4. You should see the image (not an error)

### Test 4: Test from Application

1. Open sk-dashboard.html
2. Login as SK Official
3. Try creating an announcement with an image
4. Should upload successfully now!

---

## 🐛 TROUBLESHOOTING

### Error: "Image upload failed: The resource already exists"

**Cause**: File with same name already exists and `upsert: false` is set

**Solution**: This shouldn't happen with timestamp-based names, but if it does:

- The file will be unique because of `Date.now()` timestamp
- If you still see this, change `upsert: false` to `upsert: true` in code

### Error: "Image upload failed: new row violates row-level security policy"

**Cause**: Bucket policies not set up correctly

**Solution**:

1. Go to Storage → Policies → bims-files
2. Make sure you have INSERT policy
3. Use Option 1 (public access) for testing, or Option 2 for production

### Error: "Image upload failed: Bucket not found"

**Cause**: The `bims-files` bucket doesn't exist

**Solution**:

1. Follow Step 2 above to create the bucket
2. Make sure the name is exactly `bims-files` (lowercase, hyphen)

### Error: "Failed to load image" or 404 when viewing announcement

**Cause**: Bucket is not public

**Solution**:

1. Go to Storage → bims-files → Settings
2. Toggle **"Public bucket"** to ON
3. Save changes

---

## 📊 STORAGE USAGE MONITORING

### Check Storage Usage

1. Go to **Project Settings** → **Usage**
2. Look for **Storage** section
3. You'll see:
   - Storage used (MB/GB)
   - Number of files
   - Bandwidth used

### Free Tier Limits

- Storage: 1 GB
- Bandwidth: 2 GB/month
- File uploads: Unlimited count

---

## 🔄 UPDATING CODE FOR DIFFERENT BUCKET

If you want to use a different bucket name instead of `bims-files`:

### Files to Update:

1. **sk-dashboard.html** - Line 1939 (CREATE)
2. **sk-dashboard.html** - Line 1952 (CREATE get public URL)
3. **sk-dashboard.html** - Line 2130 (UPDATE)
4. **sk-dashboard.html** - Line 2143 (UPDATE get public URL)

### Find and Replace:

```javascript
// OLD:
.from('bims-files')

// NEW (if using different name):
.from('your-bucket-name')
```

**Recommended**: Keep using `bims-files` - it's already set up in code.

---

## 📋 QUICK SETUP CHECKLIST

- [ ] Create `bims-files` bucket in Supabase Storage
- [ ] Enable "Public bucket" option
- [ ] Set up storage policies (Option 1 for testing, Option 2 for production)
- [ ] Test upload from Supabase dashboard
- [ ] Test public URL access
- [ ] Test upload from sk-dashboard.html
- [ ] Verify image appears in announcement
- [ ] Check console for any errors

---

## 🎯 EXPECTED RESULT

After setup, when you create an announcement with image:

1. ✅ Image validates (MIME type, size, extension)
2. ✅ Image uploads to `bims-files/announcements/announcement_[timestamp].[ext]`
3. ✅ Public URL is generated
4. ✅ URL is saved in `announcement_tbl.imagepathurl`
5. ✅ Image displays in announcement card
6. ✅ Image displays in view modal

---

## 🆘 STILL NOT WORKING?

If uploads still fail after setup:

1. **Open browser console (F12)**
2. **Try creating announcement with image**
3. **Look for error messages** in console
4. **Copy the exact error message**
5. **Check these common issues**:
   - Is `bims-files` bucket created?
   - Is "Public bucket" enabled?
   - Are storage policies set up?
   - Is user authenticated (logged in)?
   - Is image under 5MB?
   - Is image a valid type (JPG/PNG/GIF/WebP)?

---

## 📚 RELATED DOCUMENTATION

- **Supabase Storage Docs**: https://supabase.com/docs/guides/storage
- **Storage Policies**: https://supabase.com/docs/guides/storage/security/access-control
- **File Upload Best Practices**: https://supabase.com/docs/guides/storage/uploads

---

**Document Version**: 1.0
**Last Updated**: 2026-01-11
**Status**: Setup Guide Ready ✅
**Next Action**: Create `bims-files` bucket in Supabase Dashboard
