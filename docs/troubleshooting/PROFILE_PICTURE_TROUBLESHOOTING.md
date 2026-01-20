# Profile Picture & Profile Update Troubleshooting Guide

## Overview
This guide helps diagnose and fix issues with profile pictures not loading and profile updates not saving in the BIMS dashboards.

---

## Quick Fix Checklist

### Step 1: Set Up Storage Bucket
Run the SQL script to create the `user-images` bucket:

**Location:** `supabase/storage/user-images-bucket-setup.sql`

**Instructions:**
1. Open your Supabase project dashboard
2. Go to SQL Editor
3. Copy and paste the entire contents of `user-images-bucket-setup.sql`
4. Click "Run" to execute

**What this does:**
- Creates the `user-images` bucket with 5MB file size limit
- Sets up public read access (so profile pictures are visible)
- Creates RLS policies for upload/update/delete (users can only modify their own images)
- Configures MIME type restrictions (JPEG, PNG, GIF, WEBP only)

### Step 2: Verify RLS Policies on User_Tbl
According to `DATABASE_TABLE_COLUMN_REFERENCE.md`, the User_Tbl should have these policies:

```sql
-- Users can update own profile (including imagePathURL)
CREATE POLICY "Users can update own profile"
ON "User_Tbl" FOR UPDATE
USING ("userID" = auth.uid())
WITH CHECK ("userID" = auth.uid());

-- Users can view own profile (including imagePathURL)
CREATE POLICY "Users can view own profile"
ON "User_Tbl" FOR SELECT
USING ("userID" = auth.uid());
```

**Verify these exist:**
```sql
SELECT policyname, cmd, qual, with_check
FROM pg_policies
WHERE schemaname = 'public'
AND tablename = 'User_Tbl'
AND policyname IN ('Users can update own profile', 'Users can view own profile');
```

### Step 3: Test Profile Update
1. Open browser DevTools (F12)
2. Go to Console tab
3. Log in to either sk-dashboard.html or youth-dashboard.html
4. Open profile modal
5. Click "Edit Profile"
6. Make a change (e.g., update first name)
7. Click "Save Changes"

**Expected console output:**
```
[SAVE PROFILE] Updating database for userID: <uuid>
[SAVE PROFILE] Update result: { data: [...], error: null, count: 1 }
[SAVE PROFILE] Profile updated successfully: { firstName: "...", ... }
```

**If you see:**
- `No rows updated. Check RLS policies.` → RLS policy issue (see Step 2)
- `Database error: ...` → Check error message for details
- No console output → JavaScript error earlier in the function

### Step 4: Test Profile Picture Upload
1. Open browser DevTools (F12)
2. Go to Console tab
3. Open profile modal
4. Click "Edit Profile"
5. Click the camera icon to upload a picture
6. Select an image file (under 5MB)

**Expected console output:**
```
[PROFILE PICTURE] File selected: photo.jpg image/jpeg 123456
[PROFILE PICTURE] User ID: <uuid>
[PROFILE PICTURE] Upload path: <uuid>/photo_1234567890.jpg
[PROFILE PICTURE] Upload successful: { path: "...", ... }
[PROFILE PICTURE] Public URL: https://...supabase.co/storage/v1/object/public/user-images/...
[PROFILE PICTURE] Database updated: { userID: "...", imagePathURL: "...", ... }
```

**If you see:**
- Upload error with "Bucket not found" → Run Step 1 SQL script
- Upload error with "Access denied" → Storage bucket policy issue
- DB update error → RLS policy issue on User_Tbl

---

## Common Issues & Solutions

### Issue 1: Profile picture not displaying after upload
**Symptoms:**
- Upload succeeds with "Profile picture uploaded successfully!" toast
- Picture shows in modal preview
- Picture NOT showing in header avatar

**Root Cause:**
- The `updateProfileUI()` or `updateProfilePicture()` function isn't being called correctly
- The `userProfile.profilePicture` or `currentUserData.imagePathURL` isn't being updated

**Solution:**
Already fixed in latest code. The functions now:
1. Update local `userProfile.profilePicture`
2. Update `currentUserData.imagePathURL` (SK dashboard only)
3. Call `updateProfileUI()` or `updateProfilePicture()` to refresh the header

**Verify fix:**
Check browser console for:
```
[PROFILE PICTURE] Database updated: { ..., imagePathURL: "https://..." }
```

If this appears but image still doesn't show, check browser Network tab to see if image request is:
- Status 404 → Image URL is incorrect or file doesn't exist
- Status 403 → Storage bucket doesn't have public read access
- CORS error → Storage bucket needs CORS configuration

### Issue 2: Profile updates not saving
**Symptoms:**
- Click "Save Changes" in profile modal
- Toast shows "Profile updated successfully!"
- BUT changes don't persist (revert when you close and reopen modal)

**Root Cause:**
- Database update query returns success but doesn't actually update any rows
- Usually due to RLS policy blocking the update

**Debug Steps:**
1. Open browser console
2. Look for this message:
   ```
   [SAVE PROFILE] No rows updated. Check RLS policies.
   ```

3. If you see this, verify the RLS policy exists:
   ```sql
   SELECT policyname, cmd
   FROM pg_policies
   WHERE schemaname = 'public'
   AND tablename = 'User_Tbl'
   AND cmd = 'UPDATE';
   ```

4. If no UPDATE policy exists, create it:
   ```sql
   CREATE POLICY "Users can update own profile"
   ON "User_Tbl" FOR UPDATE
   USING ("userID" = auth.uid())
   WITH CHECK ("userID" = auth.uid());
   ```

### Issue 3: "The bucket does not exist" error during upload
**Symptoms:**
- Error toast: "Failed to upload: The bucket does not exist"
- Console shows: `[PROFILE PICTURE] Upload error: { message: "The bucket does not exist", ... }`

**Root Cause:**
- The `user-images` storage bucket hasn't been created

**Solution:**
Run the SQL script from Step 1 above (`supabase/storage/user-images-bucket-setup.sql`)

### Issue 4: "new row violates row-level security policy" error
**Symptoms:**
- Error during profile update or picture upload
- Console shows RLS policy violation error

**Root Cause:**
- RLS policy on User_Tbl doesn't allow the update
- OR the `userID` in the update query doesn't match `auth.uid()`

**Debug Steps:**
1. Check the userID being used in the update:
   ```
   [SAVE PROFILE] Updating database for userID: <uuid>
   ```

2. Verify this matches your actual user ID:
   ```sql
   SELECT auth.uid();
   ```

3. If they don't match, there's a session issue. Log out and log back in.

### Issue 5: Profile picture displays on one dashboard but not the other
**Symptoms:**
- Profile picture shows correctly in youth-dashboard.html
- Does NOT show in sk-dashboard.html (or vice versa)

**Root Cause (Fixed):**
- SK dashboard's `updateUserProfile()` function wasn't loading profile pictures
- Only displayed initials

**Solution:**
Already fixed in latest code. The SK dashboard now:
1. Checks if `currentUserData.imagePathURL` exists
2. If yes, displays the image
3. If no, displays initials as fallback

### Issue 6: Image loads in modal but not in header
**Symptoms:**
- Profile picture displays correctly in the profile modal
- Does NOT display in the dashboard header avatar

**Root Cause:**
- The header avatar element selector is incorrect
- OR the profile data isn't being loaded when the page initializes

**Debug Steps:**
1. Check if profile data loads on page load:
   ```
   [YOUTH DASHBOARD] User profile loaded successfully
   ```
   or
   ```
   [SK DASHBOARD] Authentication successful!
   ```

2. Verify `userProfile.profilePicture` or `currentUserData.imagePathURL` contains the URL:
   - In browser console, type: `userProfile.profilePicture`
   - Should return: `"https://...supabase.co/storage/v1/object/public/user-images/..."`

3. If URL is present but image doesn't show, inspect the header avatar element:
   - Right-click the avatar circle → Inspect Element
   - Check if innerHTML contains `<img src="...">` tag
   - Check if src URL is correct

---

## Verification Commands

### Check Storage Bucket Status
```sql
SELECT
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
FROM storage.buckets
WHERE id = 'user-images';
```

**Expected Result:**
| id | name | public | file_size_limit | allowed_mime_types |
|----|------|--------|-----------------|-------------------|
| user-images | user-images | true | 5242880 | {image/jpeg, image/jpg, image/png, image/gif, image/webp} |

### Check Storage Policies
```sql
SELECT
  policyname,
  cmd,
  CASE
    WHEN cmd = 'SELECT' THEN 'Public can view'
    WHEN cmd = 'INSERT' THEN 'Users can upload own'
    WHEN cmd = 'UPDATE' THEN 'Users can update own'
    WHEN cmd = 'DELETE' THEN 'Users can delete own'
  END as description
FROM pg_policies
WHERE schemaname = 'storage'
AND tablename = 'objects'
AND policyname LIKE '%user images%'
ORDER BY cmd;
```

**Expected Result:**
4 policies: SELECT, INSERT, UPDATE, DELETE

### Check User_Tbl RLS Policies
```sql
SELECT
  policyname,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE schemaname = 'public'
AND tablename = 'User_Tbl'
ORDER BY cmd, policyname;
```

**Should include:**
- Users can view own profile (SELECT)
- Users can update own profile (UPDATE)

### Test Image URL Directly
Copy the `imagePathURL` from your profile and paste it directly into a browser address bar.

**Expected:** Image displays

**If 404:** File doesn't exist in storage
**If 403:** Bucket doesn't have public read access
**If CORS error:** Need to configure CORS (see below)

---

## Advanced Configuration

### Configure CORS for Storage Bucket
If you get CORS errors when loading images:

1. Go to Supabase Dashboard → Storage → user-images
2. Click "Configuration"
3. Add CORS policy:

```json
{
  "allowedOrigins": ["*"],
  "allowedMethods": ["GET", "HEAD"],
  "allowedHeaders": ["*"],
  "maxAgeSeconds": 3600
}
```

### Clean Up Old Profile Pictures
Users can accumulate multiple profile pictures over time. To clean up old ones:

```sql
-- WARNING: This deletes ALL files except the most recent one per user
-- Test on a backup first!

WITH latest_images AS (
  SELECT
    (storage.foldername(name))[1] as user_id,
    MAX(created_at) as latest_upload
  FROM storage.objects
  WHERE bucket_id = 'user-images'
  GROUP BY (storage.foldername(name))[1]
)
DELETE FROM storage.objects
WHERE bucket_id = 'user-images'
AND created_at NOT IN (
  SELECT latest_upload FROM latest_images
  WHERE user_id = (storage.foldername(name))[1]
);
```

---

## Contact & Support

**Files Related to This Feature:**
- `sk-dashboard.html` - Lines 1505-1650 (Profile Modal), Lines 3159-3488 (Profile JS), Lines 1751-1788 (Header Update)
- `youth-dashboard.html` - Lines 779-903 (Profile Modal), Lines 1042-1322 (Profile JS), Lines 1004-1034 (Header Update)
- `supabase/storage/user-images-bucket-setup.sql` - Storage bucket setup
- `docs/database/DATABASE_TABLE_COLUMN_REFERENCE.md` - RLS policy reference

**Debugging Checklist:**
1. ✅ Run storage bucket setup SQL
2. ✅ Verify RLS policies on User_Tbl
3. ✅ Check browser console for errors
4. ✅ Test profile update with console open
5. ✅ Test profile picture upload with console open
6. ✅ Verify imagePathURL in database
7. ✅ Test image URL directly in browser

**Still Having Issues?**
1. Copy ALL console output (both errors and success messages)
2. Check Network tab for failed requests
3. Run the verification SQL commands above
4. Document exact steps to reproduce the issue

---

**Document Version:** 1.0
**Last Updated:** 2026-01-16
**Status:** Active Troubleshooting Guide
