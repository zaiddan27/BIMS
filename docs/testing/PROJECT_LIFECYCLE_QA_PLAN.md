# BIMS Project Life Cycle — QA Testing Plan

**Date:** 2026-02-21
**Deadline:** Tuesday (2026-02-25)
**Scope:** End-to-end testing of the project lifecycle from creation to archive

---

## ROLE ASSIGNMENTS

| Role | Assigned To | Account | Pages to Test |
|------|-------------|---------|---------------|
| **SK Official (Creator)** | Ledonio | SK account | sk-projects.html, sk-dashboard.html, sk-files.html, sk-calendar.html, sk-archive.html, sk-testimonies.html |
| **SK Official (Certs/Calendar)** | Espinosa | SK account | sk-certificates.html, sk-calendar.html, sk-archive.html |
| **Barangay Captain** | Ralleta | Captain account | captain-dashboard.html (Dashboard, Approvals, Archives sections) |
| **Superadmin** | Ralleta | Superadmin account | superadmin-dashboard.html, superadmin-user-management.html, superadmin-activity-logs.html |
| **Youth Volunteers (5)** | Pelias | 5 test accounts | youth-projects.html, youth-dashboard.html, youth-certificates.html, youth-files.html, youth-calendar.html |

---

## STEP 1: FIX VERIFICATION (Before Life Cycle Testing)

Each person checks their assigned HTML pages from the previous bug fix reports.
Mark each fix as **ACCEPTED** or **REJECTED** with notes.

| Tester | Pages to Verify | Status |
|--------|----------------|--------|
| Espinosa | sk-archive.html, sk-certificates.html, sk-calendar.html, index.html | ☐ |
| Pelias | captain-dashboard.html, superadmin pages, superadmin-activity-logs.html | ☐ |
| Ledonio | youth-dashboard.html, sk-dashboard.html, sk-projects.html | ☐ |
| Ralleta | captain-dashboard.html, superadmin pages | ☐ |

> **Report format:** Page name → Bug description → ACCEPTED / REJECTED (with screenshot if rejected)
> **Complete Step 1 before starting Step 2.**

---

## STEP 2: PROJECT LIFE CYCLE TESTING

### Phase A — Account Setup (Pelias)

Create **5 volunteer accounts** through the full signup flow:

| Account | Email | Password |
|---------|-------|----------|
| Volunteer 1 | volunteer1@test.com | Test@1234 |
| Volunteer 2 | volunteer2@test.com | Test@1234 |
| Volunteer 3 | volunteer3@test.com | Test@1234 |
| Volunteer 4 | volunteer4@test.com | Test@1234 |
| Volunteer 5 | volunteer5@test.com | Test@1234 |

> **Note:** Make at least 1 volunteer under 18 years old (to test parental consent flow in Phase C).

**Steps per account:**

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| A1 | Sign up with email + password | `signup.html` | Form accepts input, no errors, redirects to OTP page | ☐ |
| A2 | Verify OTP code from email | `verify-otp.html` | OTP accepted, account activated, redirects to login | ☐ |
| A3 | Log in with credentials | `login.html` | Successful login, redirects to `complete-profile.html` | ☐ |
| A4 | Complete profile: fill first name, last name, middle name, birthday, contact number, address, gender, upload photo | `complete-profile.html` | All fields save correctly, profile photo uploads to `user-images` bucket, redirects to `youth-dashboard.html` | ☐ |
| A5 | Confirm profile appears in dashboard | `youth-dashboard.html` | Name and photo display correctly in sidebar/header | ☐ |

**Expected result:** 5 active volunteer accounts with completed profiles.

---

### Phase B — Project Creation & Captain Approval

#### B1: SK Creates a Project (Ledonio)

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| B1.1 | Log in as SK Official | `login.html` | Redirects to `sk-dashboard.html` | ☐ |
| B1.2 | Navigate to Projects page | `sk-projects.html` | Project grid loads, "Create Project" button visible | ☐ |
| B1.3 | Click "Create Project" → Fill the form: | `sk-projects.html` (Create Modal) | Modal opens with all fields | ☐ |
| | — **Title:** "Youth Clean-Up Drive 2026" | | Title field accepts text | ☐ |
| | — **Category:** select from dropdown | | Dropdown options load | ☐ |
| | — **Proposed Budget:** ₱15,000 | | Accepts numeric input with peso sign | ☐ |
| | — **Expected Volunteers:** 10 | | Accepts numeric input | ☐ |
| | — **Budget Breakdown:** Add 3+ items (e.g., "Cleaning supplies ₱5,000", "Snacks ₱3,000", "Transportation ₱2,000") | | Items add to table, remaining budget auto-calculates (₱15,000 - total = remaining) | ☐ |
| | — **Start Date/Time & End Date/Time** | | Date pickers work, end date must be after start date | ☐ |
| | — **Location:** "Barangay Malanday covered court" | | Text field accepts input | ☐ |
| | — **Description:** full project description | | Textarea accepts multiline text | ☐ |
| | — **Beneficiaries:** "Youth of Barangay Malanday" | | Field accepts input | ☐ |
| | — **Project Heads:** Select SK officials from dropdown | | SK officials populate in dropdown, can select multiple | ☐ |
| B1.4 | Submit the project | `sk-projects.html` | Toast success notification, project appears in grid with **"Pending Approval"** status badge (orange) | ☐ |
| B1.5 | Verify project card shows: title, status badge, date, budget | `sk-projects.html` | All data matches what was entered | ☐ |

> **Note:** Status is automatically "Pending Approval" — SK cannot change this. The note in the form says: *"Status will be 'Pending Approval' until Barangay Captain approves"*

#### B2: Captain Reviews & Approves the Project (Ralleta)

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| B2.1 | Log in as Captain | `login.html` | Redirects to `captain-dashboard.html` | ☐ |
| B2.2 | Check notification bell | `captain-dashboard.html` | Notification about new project pending approval (from `notify_new_project` trigger) | ☐ |
| B2.3 | Click "Approvals" in sidebar | `captain-dashboard.html` → Approvals section | Pending tab shows the "Youth Clean-Up Drive 2026" project card | ☐ |
| B2.4 | Click "View Details" on the project | Approval Modal | Modal displays: **Project Information Card** (Submitted By, Date, Budget ₱15,000, Volunteers 10, Start/End Dates), **Budget Breakdown** table (3+ items with costs), **Beneficiaries**, **Description** | ☐ |
| B2.5 | Click **"Approve"** button | Approval Modal | Confirm dialog appears, click confirm | ☐ |
| B2.6 | Verify project moves to "Approved" tab | Approvals section → Approved tab | Project card now shows green "Approved" badge, approval date recorded | ☐ |
| B2.7 | Check that SK (Ledonio) received notification | (Ledonio checks `sk-dashboard.html`) | Notification about project approval appears (from `notify_project_approval` trigger) | ☐ |
| B2.8 | SK verifies project status changed | `sk-projects.html` | Project card now shows **"Upcoming"** status (green) instead of "Pending Approval" | ☐ |

> **Also test REJECTION flow** (optional second project):
> - Captain clicks "Reject" → must type mandatory rejection notes → project shows "Rejected" badge
> - SK sees "Rejected" status with Captain's notes in the project detail modal under "Captain's Decision" section

---

### Phase C — Volunteer Applications (Pelias + Ledonio)

#### C1: Volunteers Apply to the Project (Pelias — all 5 accounts)

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| C1.1 | Log in as Volunteer 1 | `login.html` | Redirects to `youth-dashboard.html` | ☐ |
| C1.2 | Navigate to Projects | `youth-projects.html` | Project grid loads, "Youth Clean-Up Drive 2026" visible with "Upcoming" status | ☐ |
| C1.3 | Click on the project card | Project Details Modal | **Details tab:** Shows category, status badge, duration, location, project heads, description | ☐ |
| C1.4 | Click **"Apply"** button | Apply Modal | Form opens pre-filled with profile data (name, birthday, contact, email, address) | ☐ |
| C1.5 | Select **Preferred Role** from dropdown | Apply Modal | Dropdown shows options: Event Volunteer, Court Marshal, Assistant Instructor, Volunteer, etc. | ☐ |
| C1.6 | **If under 18:** Parental Consent section appears | Apply Modal | Upload field visible with text: *"Required for applicants under 18 years old"*; accepts PDF, JPG, PNG formats; uploads to `consent-forms` bucket | ☐ |
| C1.7 | **If 18+:** Parental Consent section hidden | Apply Modal | Section is not visible | ☐ |
| C1.8 | Click **Submit Application** | Apply Modal | Toast: "Application submitted successfully", modal closes | ☐ |
| C1.9 | Check application in dashboard | `youth-dashboard.html` → My Applications | Application card shows: project name, applied date, selected role, **"Pending Review"** status (yellow badge) | ☐ |
| C1.10 | Repeat for Volunteers 2–5 | Same flow | All 5 applications submitted successfully | ☐ |

#### C2: SK Reviews Applications (Ledonio)

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| C2.1 | Open the project in SK Projects | `sk-projects.html` → click project | Project Details modal opens | ☐ |
| C2.2 | Switch to **"Applicants"** tab | Applicants tab | Shows **5 applicant cards**, each with: name, role, "Pending" status, apply date | ☐ |
| C2.3 | Use filter dropdown → **"All"** | Applicants tab | All 5 visible | ☐ |
| C2.4 | Use filter dropdown → **"Pending"** | Applicants tab | All 5 visible (all pending) | ☐ |
| C2.5 | Click **"View Details"** on Volunteer 1 | Application Detail | Shows full application: name, birthday, contact, email, address, preferred role, parental consent link (if minor) | ☐ |
| C2.6 | Click **"Update Status" → Approve** for Volunteers 1, 2, 3, 4 | Applicants tab | Status changes to **"Approved"** (green badge) for each | ☐ |
| C2.7 | Click **"Update Status" → Reject** for Volunteer 5 | Applicants tab | Status changes to **"Rejected"** (red badge) | ☐ |
| C2.8 | Use filter dropdown → **"Approved"** | Applicants tab | Shows 4 approved volunteers | ☐ |
| C2.9 | Use filter dropdown → **"Rejected"** | Applicants tab | Shows 1 rejected volunteer | ☐ |
| C2.10 | Applicant count badges update | Applicants tab | Badge shows correct counts per status | ☐ |

#### C3: Volunteers Check Their Application Status (Pelias)

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| C3.1 | Log in as Volunteer 1 (approved) | `youth-dashboard.html` | Notification received about approval (from `notify_application_status` trigger) | ☐ |
| C3.2 | Check My Applications section | `youth-dashboard.html` | Status changed from "Pending Review" → **"Approved"** (green badge) | ☐ |
| C3.3 | Log in as Volunteer 5 (rejected) | `youth-dashboard.html` | Status shows **"Rejected"** (red badge), notification received | ☐ |

#### C4: Generate Attendance Sheet PDF (Ledonio)

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| C4.1 | In Applicants tab, click **"Generate Attendance PDF"** | `sk-projects.html` → Applicants tab | PDF generates and downloads | ☐ |
| C4.2 | Open the downloaded PDF | Local file | PDF shows **only approved volunteers (4)**, not the rejected one. Columns: Name, Role, Signature (blank), Time In (blank), Time Out (blank) | ☐ |

---

### Phase D — Inquiries (Pelias + Ledonio)

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| D1 | Volunteer 1 opens project → **"Inquiries"** tab | `youth-projects.html` → Inquiries tab | Tab loads, shows empty or existing inquiries | ☐ |
| D2 | Volunteer 1 posts an inquiry: "What should we bring to the clean-up drive?" | `youth-projects.html` → Inquiries tab | Inquiry appears in list with sender name and timestamp | ☐ |
| D3 | Volunteer 2 posts another inquiry: "Is there parking available at the venue?" | `youth-projects.html` | Second inquiry appears | ☐ |
| D4 | SK (Ledonio) opens project → **"Inquiries"** tab | `sk-projects.html` → Inquiries tab | Both inquiries visible with sender name, message, timestamp | ☐ |
| D5 | SK replies to Inquiry 1: "Please bring gloves and water bottles" | `sk-projects.html` → Reply textarea | Reply appears below the inquiry, reply count badge updates to 1 | ☐ |
| D6 | SK replies to Inquiry 2: "Yes, parking is available at the covered court" | `sk-projects.html` | Reply saved, `isReplied` status updated in DB | ☐ |
| D7 | Volunteer 1 checks inquiry tab | `youth-projects.html` → Inquiries tab | SK's reply visible under their inquiry | ☐ |
| D8 | Volunteer 1 checks notifications | `youth-dashboard.html` | Notification about inquiry reply (from `notify_inquiry_reply` trigger) | ☐ |

---

### Phase E — Files (Ledonio + Pelias)

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| E1 | SK (Ledonio) uploads a file (e.g., "Clean-Up Guidelines.pdf") | `sk-files.html` → Upload button | Upload progress bar shows, file appears in list with name, date, size, uploader | ☐ |
| E2 | SK uploads a second file (e.g., "Volunteer Waiver.docx") | `sk-files.html` | Second file appears in list | ☐ |
| E3 | SK previews the PDF file | `sk-files.html` → Preview button | PDF renders in preview modal | ☐ |
| E4 | SK downloads the file | `sk-files.html` → Download button | File downloads correctly | ☐ |
| E5 | Volunteer checks files page | `youth-files.html` | Active files visible (files with `fileStatus = 'ACTIVE'`), can download | ☐ |
| E6 | SK archives a file | `sk-files.html` | File status changes, file removed from active list | ☐ |
| E7 | Verify archived file appears in archive | `sk-archive.html` → Archived Files tab | File appears in archive table with name, upload date, size, uploader | ☐ |

---

### Phase F — Calendar Events (Espinosa + Pelias)

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| F1 | SK (Espinosa) opens calendar | `sk-calendar.html` | Monthly calendar loads, today highlighted with gradient, navigation arrows work | ☐ |
| F2 | Navigate months using arrows | `sk-calendar.html` | Previous/Next month loads correctly, "Today" button returns to current month | ☐ |
| F3 | Verify project dates appear on calendar | `sk-calendar.html` | "Youth Clean-Up Drive 2026" start/end dates show as events on the calendar grid | ☐ |
| F4 | Volunteer checks calendar | `youth-calendar.html` | Same project events visible on volunteer's calendar view | ☐ |

---

### Phase G — Project Completion & Evaluation (Ledonio)

> **Prerequisite:** The project's scheduled end date must have passed, OR change the project status to simulate completion.

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| G1 | SK opens project and clicks **"Mark as Complete"** button | `sk-projects.html` → Project card | Evaluation Modal opens | ☐ |
| G2 | Fill **Budget Efficiency** (25% weight): | Evaluation Modal | | ☐ |
| | — Actual Spent: ₱12,000 | | Auto-calculates efficiency vs planned ₱15,000 | ☐ |
| | — Add Budget Breakdown items with actual amounts | | Planned vs Actual comparison visible | ☐ |
| | — Upload receipt(s) | | Receipt uploads to `receipts` bucket | ☐ |
| G3 | Fill **Volunteer Participation** (20% weight): | Evaluation Modal | | ☐ |
| | — Target: 10, Actual: 4 | | Auto-calculates participation rate | ☐ |
| G4 | Fill **Timeline Adherence** (20% weight): | Evaluation Modal | | ☐ |
| | — Select timeline status from dropdown | | Dropdown options available | ☐ |
| G5 | Fill **Community Impact** (20% weight): | Evaluation Modal | | ☐ |
| | — Type achievements or use quick achievement buttons | | Suggestions appear (environmental, social, education-focused) | ☐ |
| G6 | **Volunteer Feedback** (15% weight) auto-populates | Evaluation Modal | Shows average satisfaction score and count from volunteer surveys (if any submitted) | ☐ |
| G7 | Verify **Success Rate** calculation | Evaluation Modal | Overall success rate % displays with progress bar (weighted average of all 5 metrics) | ☐ |
| G8 | Submit evaluation | Evaluation Modal | Toast success, project status changes to **"Completed"**, success rate badge appears on project card | ☐ |

---

### Phase H — Certificates & Satisfaction Survey (Espinosa + Pelias)

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| H1 | SK (Espinosa) generates certificates for approved volunteers | Certificate generation flow | Certificates created in `Certificate_Tbl`, uploaded to `certificates` bucket | ☐ |
| H2 | Volunteer 1 logs in → navigates to Certificates | `youth-certificates.html` | Certificate for "Youth Clean-Up Drive 2026" appears in list | ☐ |
| H3 | Volunteer 1 clicks **"View Certificate"** | Certificate Modal | Certificate displays in landscape format with: participant name, project name, date of completion | ☐ |
| H4 | Test **zoom controls**: Zoom In, Zoom Out, Reset Zoom | Certificate Modal | Zoom level % updates (up to 3x, minimum 0.5x), certificate scales correctly, pan/drag works when zoomed | ☐ |
| H5 | Click **"Download Certificate"** | Certificate Modal | PDF downloads in landscape A4 format. Filename: `Certificate_[Name]_[Project].pdf`. Opens correctly in PDF reader | ☐ |
| H6 | Volunteer 1 clicks **"Rate this project"** / Survey button | Survey Modal | Star rating (1–4 scale) and comments textarea visible | ☐ |
| H7 | Submit survey: 4 stars, "Great experience!" | Survey Modal | Toast success, satisfaction score saved to DB | ☐ |
| H8 | Repeat H2–H7 for Volunteers 2, 3, 4 (approved only) | Same flow | All 4 approved volunteers can view/download certificates and submit surveys | ☐ |
| H9 | Volunteer 5 (rejected) checks certificates | `youth-certificates.html` | **No certificate** should appear for the rejected volunteer | ☐ |

---

### Phase I — Project Download Report (Ledonio)

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| I1 | SK opens completed project → clicks **"Download Report"** | `sk-projects.html` → Download Report Modal | Modal shows format options: **PDF** and **Excel** | ☐ |
| I2 | Download as **PDF** | Download Report Modal | PDF contains: success rate breakdown (5 metrics with weights), volunteer list (4 approved), budget details (planned vs actual), achievements, timeline info | ☐ |
| I3 | Download as **Excel** | Download Report Modal | Excel file downloads with same data in spreadsheet format | ☐ |

---

### Phase J — Project Archive (Espinosa/Ledonio)

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| J1 | SK clicks **"Archive"** button on the completed project | `sk-projects.html` | Archive button only appears for projects with status: Completed, Rejected, or Pending for Revision | ☐ |
| J2 | Confirm archive action | Dialog | Project removed from active project grid | ☐ |
| J3 | Navigate to Archive page | `sk-archive.html` → Archived Projects tab | Archived project appears in grid with: title, status, dates, budget | ☐ |
| J4 | Captain checks Archives section | `captain-dashboard.html` → Archives section | Captain can see archived project in their archives view | ☐ |
| J5 | Volunteer checks Projects page | `youth-projects.html` | Project **no longer appears** in active project list | ☐ |

---

### Phase K — Testimonies (Pelias + Ledonio)

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| K1 | Volunteer 1 submits a testimony about the project | Testimony submission flow | Testimony saved with `isFiltered = false` (visible to public) | ☐ |
| K2 | SK views all testimonies | `sk-testimonies.html` | All submitted testimonies visible, SK can filter/manage them | ☐ |
| K3 | Public landing page shows testimony | `index.html` | Unfiltered testimonies display in testimonials section | ☐ |

---

### Phase L — Superadmin Oversight (Ralleta)

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| L1 | Log in as Superadmin | `login.html` | Redirects to `superadmin-dashboard.html` | ☐ |
| L2 | **Dashboard** — Check system stats | `superadmin-dashboard.html` | Total users count includes the 5 new volunteers, active projects count accurate, total volunteers count accurate | ☐ |
| L3 | **User Management** — Verify volunteer accounts | `superadmin-user-management.html` | All 5 test volunteers appear in user table with: name, email, role = "Youth Volunteer", status = "Active" | ☐ |
| L4 | Filter users by role | `superadmin-user-management.html` | Filter dropdown works: Captain, SK Official, Youth Volunteer, System Administrator | ☐ |
| L5 | Search for a specific volunteer | `superadmin-user-management.html` | Search finds the volunteer by name or email | ☐ |
| L6 | **Activity Logs** — Tab 1: Activity Logs | `superadmin-activity-logs.html` | Logs show all lifecycle actions: project created, project approved, applications submitted, applications approved/rejected, inquiries posted, replies sent, project completed, archived | ☐ |
| L7 | Filter logs by date (today's date) | `superadmin-activity-logs.html` | Date picker filters correctly, shows only today's actions | ☐ |
| L8 | **Activity Logs** — Tab 2: Audit Trail | `superadmin-activity-logs.html` | Chronological audit records of all changes with user info and timestamps | ☐ |
| L9 | **Activity Logs** — Tab 3: Database Stats | `superadmin-activity-logs.html` | Shows table row counts, user statistics, project statistics, storage usage | ☐ |
| L10 | Pagination on logs works | `superadmin-activity-logs.html` | Previous/Next page buttons navigate through log entries | ☐ |

---

## NOTIFICATION TRIGGERS CHECKLIST

These database triggers should fire automatically. Verify each:

| Trigger | When | Who Gets Notified | ☐ |
|---------|------|-------------------|---|
| `notify_new_project` | SK creates a project | Captain gets notification | ☐ |
| `notify_project_approval` | Captain approves/rejects | SK (project creator) gets notification | ☐ |
| `notify_application_status` | SK approves/rejects application | Volunteer gets notification | ☐ |
| `notify_inquiry_reply` | SK replies to inquiry | Volunteer (inquiry author) gets notification | ☐ |

---

## BUG REPORT TEMPLATE

When reporting issues, use this format:

```
Page: [page-name.html]
Phase: [Phase letter + step number, e.g., B1.4]
Severity: CRITICAL / MAJOR / MINOR
Description: [What happened]
Expected: [What should have happened]
Steps to reproduce:
1. ...
2. ...
Screenshot: [attach]
Status: ACCEPTED / REJECTED
```

---

## COMPLETION CHECKLIST

| Phase | Description | Assigned | Status |
|-------|------------|----------|--------|
| Step 1 | Fix Verification | All | ☐ |
| Phase A | Account Setup (5 volunteers) | Pelias | ☐ |
| Phase B | Project Creation & Captain Approval | Ledonio + Ralleta | ☐ |
| Phase C | Volunteer Applications (apply, review, PDF) | Pelias + Ledonio | ☐ |
| Phase D | Inquiries & Replies | Pelias + Ledonio | ☐ |
| Phase E | File Upload & Management | Ledonio + Pelias | ☐ |
| Phase F | Calendar Events | Espinosa + Pelias | ☐ |
| Phase G | Project Completion & Evaluation | Ledonio | ☐ |
| Phase H | Certificates & Satisfaction Survey | Espinosa + Pelias | ☐ |
| Phase I | Download Project Report (PDF/Excel) | Ledonio | ☐ |
| Phase J | Project Archive | Espinosa/Ledonio + Ralleta | ☐ |
| Phase K | Testimonies | Pelias + Ledonio | ☐ |
| Phase L | Superadmin Oversight | Ralleta | ☐ |

**Total test steps: 80+**
**Deadline: Tuesday 2026-02-25**
