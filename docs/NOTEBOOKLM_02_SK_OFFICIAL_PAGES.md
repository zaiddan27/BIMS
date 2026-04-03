# BIMS SK Official Pages - Complete Guide

> Covers: sk-dashboard.html, sk-files.html, sk-testimonies.html, sk-calendar.html
> (sk-projects.html and sk-archive.html are in the Project Lifecycle guide)

---

## Who is an SK Official?

SK Officials are Sangguniang Kabataan members with positions like Chairman, Secretary, Treasurer, or Kagawad. They manage community projects, files, announcements, and calendars. They are promoted from YOUTH_VOLUNTEER by a SUPERADMIN.

---

## 1. SK Dashboard (sk-dashboard.html)

**Purpose:** Main landing page for SK Officials. Shows announcements, statistics, budget, and project metrics.

### Dashboard Statistics (loadDashboardStatistics)
Runs 4 parallel count queries on page load:
- **Active Files** - Count from File_Tbl where fileStatus = 'ACTIVE'
- **Announcements** - Count from Announcement_Tbl
- **Active Projects** - Count from Pre_Project_Tbl where approvalStatus = 'APPROVED'
- **Active Volunteers** - Count from User_Tbl where role = 'YOUTH_VOLUNTEER' and accountStatus = 'ACTIVE'

### Announcement Management (Full CRUD)

**Creating an Announcement:**
1. Click "Create" button --> openCreateModal()
2. Fill in: title, category, description
3. Optionally upload an image (JPG/PNG, max 10MB) with Cropper.js for editing
4. postAnnouncement() runs:
   - Uploads image to `announcement-images` storage bucket
   - Inserts record into `Announcement_Tbl` with title, category, description, imagePathURL, publishedDate
   - Reloads announcements

**Viewing:** viewAnnouncement(id) opens modal with full details

**Editing:** openEditModal(id) opens form pre-filled with current data, saveEdit() updates database

**Deleting:** confirmDelete(id) shows confirmation, deleteAnnouncement() hard-deletes from database

**Pagination:** 3 announcements per page with dot navigation and prev/next buttons

### Budget Management
- Budget stored in **localStorage** (not database) with categories and amounts
- editBudgetAllocation() opens modal to add/remove/edit budget categories
- Each category has a name and amount
- Total auto-calculated
- saveBudgetAllocation() persists to localStorage
- Visual display with progress bars per category

### Project Metrics (loadProjectMetrics)
- Queries Pre_Project_Tbl for current year's approved projects
- Calculates: total projects, completed count, ongoing count, average success rate
- Displayed as metric cards on dashboard

### Key Functions Summary
| Function | What it does |
|----------|-------------|
| initializeDashboard() | Auth check, loads all data in parallel |
| loadAnnouncements() | Fetches announcements from Announcement_Tbl |
| renderAnnouncements() | Draws announcement cards with pagination |
| postAnnouncement() | Creates new announcement with image upload |
| saveEdit() | Updates existing announcement |
| deleteAnnouncement() | Permanently removes announcement |
| loadDashboardStatistics() | 4 parallel count queries for stat cards |
| loadProjectMetrics() | Current year project stats and success rate |
| openCropperModal() | Image cropping via Cropper.js before upload |
| updateCharCount() | Live character counter for text inputs |

### Tables Used
| Table | Operations |
|-------|-----------|
| Announcement_Tbl | SELECT, INSERT, UPDATE, DELETE |
| File_Tbl | SELECT (count) |
| Pre_Project_Tbl | SELECT (count + metrics) |
| User_Tbl | SELECT (count volunteers) |
| Storage: announcement-images | UPLOAD, GET PUBLIC URL |

---

## 2. SK Files (sk-files.html)

**Purpose:** File management system where SK Officials upload, organize, publish, and archive documents.

### File Upload Flow
1. openUploadModal() --> select file + enter name + choose category
2. File validation: max 50MB, supported types (PDF, XLSX, JPG, PNG, DOC)
3. uploadFile() runs:
   - Uploads to Supabase storage bucket (organized by category)
   - Gets public URL
   - Inserts into File_Tbl: fileName, fileType, filePath, fileCategory, dateUploaded, fileStatus='ACTIVE'
   - Shows simulated progress bar
4. Reloads file grid

### File Categories
- DOCUMENTS
- REPORTS
- MEDIA

### File Operations
| Operation | Function | What happens |
|-----------|----------|-------------|
| **View** | openFileModal(id) | Opens preview modal (PDF rendered via PDF.js, images shown directly) |
| **Download** | downloadFile(url, name) | Browser download triggered |
| **Publish** | togglePublish(id) | Toggles `isPublished` boolean. Published files appear on the public landing page (index.html) |
| **Unpublish** | confirmUnpublish(id) | Sets isPublished = false |
| **Archive** | confirmArchiveFile() | Sets fileStatus = 'ARCHIVED' (soft delete, file goes to sk-archive.html) |
| **Delete** | deleteFile() | Permanently removes from storage AND database |

### Search & Filter
- **Search:** by filename, real-time filtering
- **Category filter:** dropdown to show only DOCUMENTS, REPORTS, or MEDIA
- **Pagination:** 6 files per page with dot navigation

### Key Functions Summary
| Function | What it does |
|----------|-------------|
| loadFiles() | Fetches ACTIVE files from File_Tbl |
| renderFiles() | Draws file cards grid with type icons |
| uploadFile() | Uploads to storage + inserts DB record |
| openFileModal() | PDF.js preview for PDFs, img tag for images |
| togglePublish() | Makes file visible on public landing page |
| confirmArchiveFile() | Soft-deletes file (ACTIVE --> ARCHIVED) |
| deleteFile() | Hard delete from storage + database |
| applyFilters() | Filters by search text and category |

### Tables Used
| Table | Operations |
|-------|-----------|
| File_Tbl | SELECT, INSERT, UPDATE, DELETE |
| Supabase Storage | UPLOAD, GET PUBLIC URL, DELETE |

---

## 3. SK Testimonies (sk-testimonies.html)

**Purpose:** Manage volunteer feedback/testimonies. SK Officials can feature testimonies to show on the public landing page.

### How Testimonies Get Here
Youth volunteers submit satisfaction feedback from their dashboard (youth-dashboard.html). Those testimonies appear here for SK Officials to manage.

### Testimony Management

**Viewing:** viewTestimony(id) opens modal showing:
- Volunteer name and avatar
- Star rating (1-5)
- Full testimony text
- Date submitted
- Feature/delete action buttons

**Featuring:** toggleFeature()
- If not featured: showFeatureInfoModal() first (educates about what featuring does), then on confirm sets `Testimonies_Tbl.isFiltered = true`
- If already featured: directly sets isFiltered = false (unfeatures)
- Featured testimonies appear on index.html (public landing page) in the testimonials carousel

**Deleting:** deleteTestimony() permanently removes from database after confirmation

### Search & Filter
- **Search:** by volunteer name, project name, or testimony text
- **Filter tabs:** "All" or "Featured" (shows only isFiltered = true)
- **Pagination:** configurable per-page count with dot navigation

### Stats Display (updateStats)
- Total testimonies count
- Featured testimonies count
- Displayed as stat badges at the top

### Key Functions Summary
| Function | What it does |
|----------|-------------|
| loadTestimonies() | Fetches from Testimonies_Tbl with User_Tbl join |
| renderTestimonies() | Draws testimony cards with search/filter applied |
| viewTestimony() | Opens detail modal with full text and actions |
| toggleFeature() | Features/unfeatures testimony for public display |
| showFeatureInfoModal() | Educational modal before first feature action |
| deleteTestimony() | Permanently removes testimony |
| filterTestimonies() | Switches between "All" and "Featured" view |
| searchTestimonies() | Filters by name/project/text |

### Tables Used
| Table | Operations |
|-------|-----------|
| Testimonies_Tbl | SELECT, UPDATE (isFiltered), DELETE |
| User_Tbl (joined) | SELECT (volunteer name, image) |

---

## 4. SK Calendar (sk-calendar.html)

**Purpose:** Visual calendar showing approved projects and announcements with multiple views and external calendar integration.

### Event Sources
Two types of events loaded from database:
1. **Projects** - From Pre_Project_Tbl where approvalStatus = 'APPROVED' (shown in green)
2. **Announcements** - From Announcement_Tbl (shown in blue)

### Three Calendar Views

**Month View (default)** - renderCalendar()
- Traditional month grid with day cells
- Events shown as colored pills in each day
- Max 3 events per cell, "+N more" indicator if overflow
- Click a day to see all events

**Week View** - renderWeekView()
- 7-day horizontal grid
- Hourly time slots from 8 AM to 6 PM
- Events positioned at their start hour
- Good for seeing time conflicts

**Day View** - renderDayView()
- Single day with all events listed
- Shows full event details (time, location, volunteers, organizer)

### Navigation
- **previousMonth() / nextMonth()** - Navigate based on current view (month, week, or day)
- **goToToday()** - Jump back to current date
- **setView(view)** - Switch between month/week/day

### Calendar Export Features
- **exportCalendar()** - Generates .ics file with ALL events for download
- **exportSingleEvent(eventId)** - Generates .ics file for one event
- **getAddToCalendarLinks(event)** - Generates URLs for:
  - Google Calendar
  - Outlook
  - Office 365
  - Yahoo Calendar
- **generateICS() / generateEventICS()** - Creates proper iCalendar format with VEVENT blocks, timezone (Asia/Manila), UIDs

### Sidebar Widgets
- **Upcoming Projects** - 3 most recent projects sorted by start date
- **Recent Announcements** - 3 most recent announcements sorted by published date

### Event Detail Modal
openEventModal(eventId) shows:
- Event title, date/time, location
- Organizer name (for projects)
- Volunteer count needed
- Description
- "Add to Calendar" buttons (Google, Outlook, Office365)
- "Export as .ics" button

### Key Functions Summary
| Function | What it does |
|----------|-------------|
| loadEventsFromDatabase() | Fetches approved projects + announcements |
| renderCalendar() | Draws month view grid |
| renderWeekView() | Draws 7-day hourly grid |
| renderDayView() | Draws single day event list |
| setView() | Switches between month/week/day |
| openEventModal() | Shows event details with calendar links |
| exportCalendar() | Downloads all events as .ics file |
| getAddToCalendarLinks() | Generates Google/Outlook/Office365 URLs |
| renderUpcomingProjects() | Sidebar: 3 upcoming projects |
| renderRecentAnnouncements() | Sidebar: 3 recent announcements |

### Tables Used
| Table | Operations |
|-------|-----------|
| Pre_Project_Tbl | SELECT (approved projects for calendar) |
| Announcement_Tbl | SELECT (announcements for calendar) |
| SK_Tbl + User_Tbl | SELECT (project organizer names) |

---

## Cross-Page Patterns for SK Officials

### Shared Components on Every SK Page
- **SessionManager** - Auth check for SK_OFFICIAL role on every page load
- **ProfileModal** - Click profile icon to edit name, contact, address, picture
- **NotificationModal** - Bell icon shows notifications (project approvals, inquiries, etc.)
- **Sidebar** - Navigation: Dashboard, Manage Files, Project Monitoring, Calendar, Testimonies, Archives
- **showToast()** - Success/error/warning/info toast messages
- **escapeHTML()** - XSS prevention on all user content
- **sanitizeImageURL()** - Only allows Supabase and Google image domains
- **logAction()** - Audit trail logging

### How SK Pages Connect
```
SK Dashboard
  |-- Announcements (CRUD) --> visible on index.html landing page
  |-- Statistics --> counts from File_Tbl, Pre_Project_Tbl, User_Tbl
  |-- Budget --> local tracking with categories
  
SK Files
  |-- Upload/manage documents
  |-- Publish to landing page --> index.html shows published files
  |-- Archive --> files go to sk-archive.html files tab

SK Testimonies
  |-- Youth submit feedback from youth-dashboard.html
  |-- SK features testimonies --> appear in index.html carousel
  
SK Calendar
  |-- Shows approved projects from Pre_Project_Tbl
  |-- Shows announcements from Announcement_Tbl (created on SK Dashboard)
  |-- Export to Google Calendar / Outlook / .ics
```

---

## Quick Q&A

**Q: What can SK Officials do that Youth Volunteers cannot?**
> Create/edit/delete announcements, upload/publish/archive files, manage volunteer applications, feature testimonies, track attendance, complete projects with evaluations, and manage budget breakdowns.

**Q: Where do announcements show up?**
> Created on sk-dashboard.html, visible on youth-dashboard.html (youth see them), on the calendar, and on index.html (public landing page).

**Q: What does "publishing" a file mean?**
> Setting isPublished=true makes the file downloadable on the public landing page (index.html). Unpublished files are only visible to SK Officials.

**Q: What does "featuring" a testimony mean?**
> Setting isFiltered=true makes the testimony appear in the testimonials carousel on the public landing page (index.html).

**Q: How does the calendar get its events?**
> Two sources: approved projects (from Pre_Project_Tbl) and announcements (from Announcement_Tbl). Both auto-populate the calendar.
