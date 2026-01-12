# BIMS Storage Naming Reference

**Date**: 2026-01-11
**Purpose**: Official reference for all storage bucket and folder names
**Status**: ✅ Active Reference

---

## 📦 STORAGE BUCKETS

### Primary Bucket: `bims-files`

**Configuration**:
- Name: `bims-files`
- Public Access: ✅ Enabled
- Used For: All file uploads (images, documents, certificates)
- Location: Supabase Storage
- Created: Required for system operation

**Access**: https://vreuvpzxnvrhftafmado.supabase.co/storage/v1/object/public/bims-files/

---

## 📁 FOLDER STRUCTURE

### 1. Announcement Images

**Folder Name**: `announcement-images/` (with space)

**Used By**:
- sk-dashboard.html (CREATE announcement)
- sk-dashboard.html (EDIT announcement)

**File Naming Convention**:
```
announcement_[timestamp].[extension]
```

**Example Files**:
```
announcement-images/
├── announcement_1736605535123.jpg
├── announcement_1736605535456.png
├── announcement_1736605535789.webp
└── announcement_1736605535999.gif
```

**Code Location**:
- sk-dashboard.html Line 1951 (CREATE)
- sk-dashboard.html Line 2153 (EDIT)

**File Types Allowed**:
- JPG/JPEG (image/jpeg)
- PNG (image/png)
- GIF (image/gif)
- WebP (image/webp)

**Size Limit**: 5 MB

---

### 2. User Avatars (Future)

**Folder Name**: `user-avatars/` (with space)

**Used By**:
- (Not yet implemented)

**File Naming Convention**:
```
user_[userID]_[timestamp].[extension]
```

**Example Files**:
```
user-avatars/
├── user_39f5af8b-914a-448e-b6dc-a630f0938b72_1736605535123.jpg
├── user_5b2c1d9e-823a-449f-a5bc-b741f1049c83_1736605535456.png
└── ...
```

**Status**: 📋 Planned, not yet implemented

---

### 3. Project Images (Future)

**Folder Name**: `project-images/` (with space)

**Used By**:
- (Not yet implemented)

**File Naming Convention**:
```
project_[projectID]_[timestamp].[extension]
```

**Example Files**:
```
project-images/
├── project_123_1736605535123.jpg
├── project_124_1736605535456.png
└── ...
```

**Status**: 📋 Planned, not yet implemented

---

### 4. Certificates (Future)

**Folder Name**: `certificates/` (no space)

**Used By**:
- (Not yet implemented - volunteer certificates after project completion)

**File Naming Convention**:
```
certificate_[userID]_[projectID]_[timestamp].pdf
```

**Example Files**:
```
certificates/
├── certificate_39f5af8b-914a-448e-b6dc-a630f0938b72_123_1736605535123.pdf
├── certificate_5b2c1d9e-823a-449f-a5bc-b741f1049c83_124_1736605535456.pdf
└── ...
```

**Status**: 📋 Planned, not yet implemented

---

### 5. Documents (Future)

**Folder Name**: `documents/` (no space)

**Used By**:
- (Not yet implemented - file repository feature)

**File Naming Convention**:
```
document_[timestamp].[extension]
```

**Example Files**:
```
documents/
├── document_1736605535123.pdf
├── document_1736605535456.xlsx
├── document_1736605535789.docx
└── ...
```

**File Types Allowed**:
- PDF (application/pdf)
- XLSX (application/vnd.openxmlformats-officedocument.spreadsheetml.sheet)
- DOCX (application/vnd.openxmlformats-officedocument.wordprocessingml.document)
- JPG/PNG (images)

**Status**: 📋 Planned, not yet implemented

---

## 🔍 NAMING CONVENTIONS

### Timestamp Format

All timestamps use JavaScript `Date.now()`:
- Format: Milliseconds since Unix epoch
- Example: `1736605535123`
- Why: Guarantees unique filenames, sortable chronologically

### File Extensions

Extensions are derived from MIME types, not client filenames:

| MIME Type | Extension |
|-----------|-----------|
| image/jpeg | .jpg |
| image/jpg | .jpg (converted) |
| image/png | .png |
| image/gif | .gif |
| image/webp | .webp |
| application/pdf | .pdf |
| application/vnd.openxmlformats-officedocument.spreadsheetml.sheet | .xlsx |
| application/vnd.openxmlformats-officedocument.wordprocessingml.document | .docx |

### Folder Names

**Important**: All folders use **hyphens** (kebab-case) for consistency and URL compatibility

| Folder | Naming Pattern | Example Full Path |
|--------|----------------|-------------------|
| `announcement-images/` | kebab-case | announcement-images/announcement_123.jpg |
| `user-avatars/` | kebab-case | user-avatars/user_456.jpg |
| `project-images/` | kebab-case | project-images/project_789.jpg |
| `certificates/` | single-word | certificates/certificate_101.pdf |
| `documents/` | single-word | documents/document_202.pdf |

**Naming Convention**: Multi-word folders use hyphens (`-`) instead of spaces

---

## 📊 CODE USAGE

### How to Upload to Storage

**Template**:
```javascript
const fileExt = file.type.split('/')[1].replace('jpeg', 'jpg');
const fileName = `prefix_${Date.now()}.${fileExt}`;
const filePath = `folder name/${fileName}`;

const { data, error } = await supabaseClient.storage
  .from('bims-files')
  .upload(filePath, file, {
    cacheControl: '3600',
    upsert: false,
    contentType: file.type
  });

// Get public URL
const { data: urlData } = supabaseClient.storage
  .from('bims-files')
  .getPublicUrl(filePath);

const publicUrl = urlData.publicUrl;
```

### Current Implementations

**Announcement Images**:
```javascript
// sk-dashboard.html - postAnnouncement() (Line 1951)
// sk-dashboard.html - saveEdit() (Line 2153)

const filePath = `announcement-images/${fileName}`;
const { data, error } = await supabaseClient.storage
  .from('bims-files')
  .upload(filePath, image, {...});
```

---

## 🔗 PUBLIC URL FORMAT

All uploaded files get a public URL in this format:

```
https://vreuvpzxnvrhftafmado.supabase.co/storage/v1/object/public/bims-files/[folder]/[filename]
```

**Examples**:

```
https://vreuvpzxnvrhftafmado.supabase.co/storage/v1/object/public/bims-files/announcement%20images/announcement_1736605535123.jpg

https://vreuvpzxnvrhftafmado.supabase.co/storage/v1/object/public/bims-files/user%20avatars/user_39f5af8b-914a-448e-b6dc-a630f0938b72_1736605535123.jpg
```

**Note**: Spaces in folder names are URL-encoded as `%20`

---

## 🛡️ SECURITY

### File Validation

All file uploads must pass validation:

1. **MIME Type Check**: Only allowed types accepted
2. **File Size Check**: Maximum size enforced (5MB for images)
3. **Extension-MIME Match**: Prevent file spoofing

**Validation Code**: sk-dashboard.html `validateImageFile()` function (Line 1538)

### Storage Policies

**Required Policies for `bims-files` bucket**:

1. **Public Read**: Anyone can view/download files
2. **Authenticated Upload**: Only logged-in users can upload
3. **User Update/Delete**: Users can only modify their own files

**Policy Setup**: See SUPABASE_STORAGE_SETUP.md

---

## 📝 DATABASE STORAGE

File URLs are stored in database tables:

| Table | Column | Example Value |
|-------|--------|---------------|
| announcement_tbl | imagepathurl | https://vreuvpzxnvrhftafmado.supabase.co/storage/v1/object/public/bims-files/announcement%20images/announcement_1736605535123.jpg |
| user_tbl | imagepathurl | (future) |
| pre_project_tbl | imagepathurl | (future) |
| certificate_tbl | certificatefileurl | (future) |
| file_tbl | filepath | (future) |

---

## 🔄 MIGRATION NOTES

### If Changing Folder Names

If you need to change folder names in the future:

1. **Update Code**:
   - Find all instances of old folder name
   - Replace with new folder name

2. **Update Database URLs**:
   - Run SQL to update existing URLs in database
   - Example:
     ```sql
     UPDATE announcement_tbl
     SET imagepathurl = REPLACE(imagepathurl, 'old folder/', 'new folder/')
     WHERE imagepathurl LIKE '%old folder/%';
     ```

3. **Move Files in Storage**:
   - Download files from old folder
   - Upload to new folder
   - Delete old files

**Recommendation**: Don't change folder names after production launch!

---

## 📋 QUICK REFERENCE

### Current Active Paths

| Feature | Bucket | Folder | Status |
|---------|--------|--------|--------|
| Announcement Images | bims-files | announcement-images/ | ✅ Active |
| User Avatars | bims-files | user-avatars/ | 📋 Planned |
| Project Images | bims-files | project-images/ | 📋 Planned |
| Certificates | bims-files | certificates/ | 📋 Planned |
| Documents | bims-files | documents/ | 📋 Planned |

### File Naming Patterns

```
Announcements:  announcement_[timestamp].[ext]
Users:          user_[userID]_[timestamp].[ext]
Projects:       project_[projectID]_[timestamp].[ext]
Certificates:   certificate_[userID]_[projectID]_[timestamp].pdf
Documents:      document_[timestamp].[ext]
```

---

## 🚀 GETTING STARTED

**To enable file uploads**:

1. ✅ Create `bims-files` bucket in Supabase
2. ✅ Enable "Public bucket" option
3. ✅ Set up storage policies
4. ✅ Folder `announcement-images/` will be auto-created on first upload
5. ✅ Test upload from sk-dashboard.html

**See**: SUPABASE_STORAGE_SETUP.md for detailed setup instructions

---

**Document Version**: 1.0
**Last Updated**: 2026-01-11
**Status**: Official Reference ✅
**Next Update**: When new storage features are implemented
