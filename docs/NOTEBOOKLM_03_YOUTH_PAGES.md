# BIMS Youth Volunteer Pages - Complete Guide

> Covers: youth-dashboard.html, youth-calendar.html, youth-files.html, youth-certificates.html
> (youth-projects.html is in the Project Lifecycle guide)

---

## Who is a Youth Volunteer?

Youth Volunteers are the base role for all users. Every new signup starts as YOUTH_VOLUNTEER. They can browse projects, apply to volunteer, submit feedback, view files, and earn certificates for completed projects.

---

## 1. Youth Dashboard (youth-dashboard.html)

**Purpose:** Main landing page for youth. Shows announcements, profile management, and a satisfaction feedback form.

### Profile Management (Built into Dashboard)
Unlike other pages that use the shared ProfileModal, this dashboard has its own inline profile editing:

**View/Edit Toggle:**
- enterEditMode() - Enables field editing, saves backup of current values
- cancelEdit() - Restores original values from backup
- saveProfile() - Validates all fields, uploads profile picture to storage, updates User_Tbl

**Profile Fields & Validation:**
| Field | Rules |
|-------|-------|
| First Name | Required, 2-50 chars |
| Last Name | Required, 2-50 chars |
| Middle Name | Optional, 2-50 chars |
| Contact Number | Required, Philippine format 09XXXXXXXXX |
| Address | Required, 10-200 chars |
| Gender | Required (Male/Female/Other) |
| Birthday | Required, age 13-120 years, LOCKED after first save |

**Profile Picture Upload:**
- handleProfilePictureChange(event) uploads to `user-images/{userID}/{fileName}` storage bucket
- Accepted: JPG, PNG, GIF, WebP (max 5MB)
- Falls back to initials avatar if no image

### Announcements (Read-Only)
- loadAnnouncements() fetches from Announcement_Tbl (limit 100)
- Rendered as cards with pagination (3 per page)
- Category badges: urgent (red), general (blue), update (green)
- viewAnnouncement(id) opens full detail modal
- Relative dates: "Just now", "5 minutes ago", "2 days ago", or actual date for 7+ days

### Satisfaction Feedback (Testimonies)
Youth can submit feedback about their overall BIMS experience:

1. **Star Rating:** 5 interactive stars with hover preview
   - initializeStarRating() sets up click/hover handlers
   - updateStarDisplay(rating) highlights selected stars
   - Rating text: 1=Poor, 2=Fair, 3=Good, 4=Very Good, 5=Excellent

2. **Written Feedback:** Textarea with 500 character limit
   - updateCharCount() shows live counter
   - Warning color at 90% capacity, error at 100%

3. **Submission Flow:**
   - showTestimonyConfirmation() shows preview modal before submitting
   - On confirm: inserts into Testimonies_Tbl with userID, message, rating, isFiltered=false
   - resetTestimonyForm() clears everything after success

This feedback is what SK Officials see on sk-testimonies.html and can feature on the public landing page.

### Application Status Tracking
- openApplicationDetails(id) opens a side drawer showing project application details
- Shows: project name, applied date, preferred role, status badge
- Status badges: Pending Review (yellow), Approved (green), Rejected (red), Completed (blue)

### Key Functions Summary
| Function | What it does |
|----------|-------------|
| initializePage() | Auth check, load profile + announcements |
| loadUserProfile() | Fetches user data from User_Tbl |
| enterEditMode() / saveProfile() | Profile editing with validation |
| handleProfilePictureChange() | Upload profile picture to storage |
| loadAnnouncements() | Fetch and display announcements |
| renderAnnouncements() | Paginated announcement cards |
| initializeStarRating() | Interactive 5-star rating widget |
| showTestimonyConfirmation() | Confirm before submitting feedback |

### Tables Used
| Table | Operations |
|-------|-----------|
| User_Tbl | SELECT, UPDATE (profile data + picture URL) |
| Announcement_Tbl | SELECT (read announcements) |
| Testimonies_Tbl | INSERT (submit feedback) |
| Storage: user-images | UPLOAD (profile picture) |

---

## 2. Youth Calendar (youth-calendar.html)

**Purpose:** Same calendar as SK calendar but for youth volunteers. Shows approved projects and announcements.

### How It Works
Identical calendar system to sk-calendar.html with the same three views:

**Month View** - Grid of days with event pills (max 3 per day, "+N more" overflow)
**Week View** - 7-day hourly grid (8 AM - 6 PM) with events at their time slots
**Day View** - All events for a single day with full details

### Event Sources
- **Projects (green)** - Pre_Project_Tbl where approvalStatus = 'APPROVED'
- **Announcements (blue)** - From Announcement_Tbl

### Navigation & Features
- Previous/Next navigation adapts to current view (month/week/day)
- "Today" button jumps to current date
- Event detail modal with description, location, organizer, volunteer count
- Export to .ics file (single event or all events)
- Add-to-calendar links: Google Calendar, Outlook, Office 365, Yahoo

### Sidebar
- Upcoming Projects (3 most recent by start date)
- Recent Announcements (3 most recent by published date)

### Key Functions Summary
| Function | What it does |
|----------|-------------|
| loadEventsFromDatabase() | Fetches projects + announcements |
| renderCalendar() | Month view grid |
| renderWeekView() | 7-day hourly grid |
| renderDayView() | Single day event list |
| openEventModal() | Event details + calendar links |
| exportCalendar() | Download all events as .ics |
| exportSingleEvent() | Download one event as .ics |

### Tables Used
| Table | Operations |
|-------|-----------|
| Pre_Project_Tbl | SELECT (approved projects) |
| Announcement_Tbl | SELECT (announcements) |
| SK_Tbl + User_Tbl | SELECT (organizer names) |

---

## 3. Youth Files (youth-files.html)

**Purpose:** Read-only file browser for youth volunteers. They can view and download published files.

### How It Works
- loadFiles() fetches from File_Tbl where fileStatus = 'ACTIVE'
- Youth can only VIEW and DOWNLOAD -- no upload, edit, delete, or archive
- File cards show: file name, type icon (color-coded), upload date, category

### File Preview
viewFile(id) opens a preview modal:
- **PDFs:** Rendered inline using PDF.js (first page shown on canvas)
- **Images (PNG/JPG):** Shown as img element
- **Other types (XLSX/DOC):** Message saying "Preview not available" with download option
- **Download button** always available for any file type

### Search & Filter
- **Search** by filename (real-time)
- **Category filter** dropdown
- **Pagination:** 6 files per page with dot navigation

### URL Security
sanitizeFileURL(url) validates that file URLs only come from allowed Supabase domains. Rejects anything else.

### Key Functions Summary
| Function | What it does |
|----------|-------------|
| loadFiles() | Fetches ACTIVE files from File_Tbl |
| renderFiles() | Draws file cards with type icons |
| viewFile() | Opens preview modal (PDF.js for PDFs, img for images) |
| applyFilters() | Filters by search text and category |
| sanitizeFileURL() | Validates URLs are from Supabase |

### Tables Used
| Table | Operations |
|-------|-----------|
| File_Tbl | SELECT only (read-only access) |

---

## 4. Youth Certificates (youth-certificates.html)

**Purpose:** View completed projects, fill satisfaction surveys, and download participation certificates.

### Eligibility Rules
A youth volunteer sees a project here if:
- They applied to the project AND were approved (`applicationStatus = 'approved'`)
- They were marked as attended (`attended = true`)
- The project is ONGOING or COMPLETED

### Three States Per Project

| State | Condition | What Youth Sees |
|-------|-----------|----------------|
| **Waiting for Completion** | Project still ONGOING, no survey yet | Gray "Waiting" badge, disabled button |
| **Survey Pending** | Project COMPLETED (or ongoing), survey not submitted | Yellow "Survey Pending" badge, "Complete Survey" button |
| **Certificate Ready** | Survey submitted | Green "Survey Complete" badge + satisfaction score bar, "View Certificate" button |

### Satisfaction Survey (openSurveyModal)
When a project is ready for survey:

1. Opens modal with 5 questions (Q1-Q5)
2. Each question is a **slider from 1-5**
3. calculateAverage() updates live satisfaction score as sliders change
4. Optional written comments field
5. submitSurvey() validates and inserts into Evaluation_Tbl:
   - applicationID, postProjectID
   - q1, q2, q3, q4, q5 (each 1-5)
   - message (optional comments)
   - hasCertificate = true
6. After submission, automatically opens the certificate modal

Duplicate submission handled gracefully (unique constraint prevents re-submission).

### Certificate Viewing (viewCertificate)
Opens a full-screen certificate modal with:

**Certificate Content:**
- Volunteer's full name (firstName + middleName initial + lastName from User_Tbl)
- Project title
- Issue date (current date)
- Certificate ID
- SK Malanday branding

**Zoom & Pan Controls:**
- **Desktop:** Mouse wheel to zoom, click-drag to pan when zoomed
- **Mobile:** Pinch-to-zoom with two fingers, drag to pan
- **Buttons:** Zoom In (+0.25), Zoom Out (-0.25), Reset (back to 100%)
- **Range:** 50% to 300% zoom
- Zoom level indicator displayed
- Touch hint shown briefly on first mobile access

**PDF Download:**
- downloadCertificate() uses html2canvas to capture the certificate element
- Converts to PDF via jsPDF
- Downloads as file

### Key Functions Summary
| Function | What it does |
|----------|-------------|
| loadCompletedProjects() | Fetches approved+attended applications with project data |
| renderProjects() | Draws project cards with status and action buttons |
| openSurveyModal() | Opens 5-question satisfaction survey |
| calculateAverage() | Live satisfaction score from slider values |
| submitSurvey() | Inserts evaluation into Evaluation_Tbl |
| viewCertificate() | Opens full-screen certificate with zoom controls |
| downloadCertificate() | Captures certificate as PDF via html2canvas + jsPDF |
| initializeZoomControls() | Sets up mouse wheel, touch, and button zoom |

### Tables Used
| Table | Operations |
|-------|-----------|
| Application_Tbl | SELECT (user's approved, attended applications) |
| Pre_Project_Tbl | SELECT (project details via join) |
| Post_Project_Tbl | SELECT (post-completion data) |
| Evaluation_Tbl | SELECT (check if survey done), INSERT (submit survey) |
| User_Tbl | SELECT (volunteer name for certificate) |

---

## How Youth Pages Connect Together

```
Youth Dashboard
  |-- View announcements (from SK officials)
  |-- Submit satisfaction feedback --> goes to sk-testimonies.html for featuring
  |-- Edit profile (name, contact, picture)
  |-- Track application statuses

Youth Projects (in Project Lifecycle guide)
  |-- Browse approved projects
  |-- Apply to volunteer
  |-- Send inquiries about projects
  |-- Edit pending applications

Youth Calendar
  |-- View projects and announcements on calendar
  |-- Export events to Google Calendar / Outlook / .ics

Youth Files
  |-- Browse and download published files (read-only)
  |-- Preview PDFs and images

Youth Certificates
  |-- View completed projects you volunteered for
  |-- Fill satisfaction surveys (Q1-Q5 + comments)
  |-- View and download participation certificates as PDF
```

### Data Flow: From Volunteering to Certificate

```
1. Youth applies to project (youth-projects.html)
      |
2. SK Official approves application (sk-projects.html)
      |
3. Youth attends the project event
      |
4. SK Official marks attendance (sk-projects.html)
      |
5. SK Official completes the project with evaluation (sk-projects.html)
      |
6. Project appears in youth-certificates.html with "Survey Pending" status
      |
7. Youth fills satisfaction survey (5 questions + comments)
      |
8. Certificate becomes available for viewing and PDF download
      |
9. Survey data feeds back into:
   - sk-projects.html evaluation modal (volunteer feedback component = 15% of success rate)
   - sk-testimonies.html (the written feedback)
```

---

## Quick Q&A

**Q: Can youth volunteers upload files?**
> No. Youth can only view and download files. Only SK Officials can upload, publish, archive, and delete files.

**Q: When can a youth get a certificate?**
> After three conditions: their application was approved, they were marked as attended by an SK Official, and they completed the satisfaction survey.

**Q: What are the 5 survey questions?**
> Q1-Q5 are slider-based satisfaction questions (1-5 scale). The exact questions are about their volunteering experience. The average score appears as a percentage on their project card.

**Q: Can they edit their survey after submission?**
> No. There's a unique constraint preventing duplicate submissions. Once submitted, it's final.

**Q: How does the certificate get the volunteer's name?**
> It reads firstName, middleName (first initial only), and lastName from User_Tbl. Format: "John D. Smith"

**Q: What announcements do youth see?**
> All announcements created by SK Officials on the SK Dashboard. Youth see them read-only with categories: urgent, general, update.
