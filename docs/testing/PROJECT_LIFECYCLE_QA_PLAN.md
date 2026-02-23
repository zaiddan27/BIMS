# BIMS Project Life Cycle — QA Testing Plan

**Date:** 2026-02-21 (Updated: 2026-02-24)
**Deadline:** Tuesday (2026-02-25)
**Scope:** End-to-end testing of the project lifecycle from creation to archive

---

## PRE-REQUISITES (Before Any Testing)

**Database migrations must be applied in order:**

| # | Migration | Purpose |
|---|-----------|---------|
| 1 | `017_notification_deep_linking.sql` | Adds `referenceID` column to `Notification_Tbl`, updates all triggers for deep linking, adds `notify_new_inquiry` trigger |
| 2 | `018_fix_testimony_and_archive_delete.sql` | Adds DELETE policies for testimonies (SK/Captain) and expands archive delete to Captain |

> **These must be applied before testing Phases B–L. Without them, notifications will not include deep links and testimony/archive deletes will silently fail.**

---

## GENERAL CREDENTIALS

| Role | Login Method | Email | Password |
|------|-------------|-------|----------|
| **Superadmin** | Login as Google | malandaysk@gmail.com | sk.malanday2026 |
| **Barangay Captain** | Type in login inputs (NOT Google) | captain.test@bims.ph | captain@2026 |
| **SK Official** | *(use assigned SK test account)* | | |
| **Youth Volunteers** | *(create via Phase A signup)* | | |

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

> **IMPORTANT — Password Complexity:** Passwords now require ALL of the following: 8+ characters, 1 uppercase letter, 1 lowercase letter, 1 number, 1 special character (`!@#$%^&*` etc.). The password `Test@1234` meets all requirements.

**Steps per account:**

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| A1 | Sign up with email + password | `signup.html` | Form accepts input, no errors, redirects to OTP page | ☐ |
| A1.1 | Verify **password complexity checklist** appears below password field | `signup.html` | Five requirement items shown (length, uppercase, lowercase, number, special char); each toggles green checkmark independently as you type | ☐ |
| A1.2 | Test weak password (e.g., `password123`) | `signup.html` | Form should REJECT it — error: "Password does not meet all complexity requirements" | ☐ |
| A1.3 | Verify **confirm password cross-validation** | `signup.html` | Type password, then confirm, then change password — confirm field immediately shows error state | ☐ |
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
| B2.1 | Log in as Captain (type credentials in login inputs, NOT Google) | `login.html` | Redirects to `captain-dashboard.html` | ☐ |
| B2.2 | Check notification bell | `captain-dashboard.html` | Notification about new project pending approval (from `notify_new_project` trigger), notification includes `referenceID` for deep linking | ☐ |
| B2.2a | **Click the notification** | `captain-dashboard.html` | **Deep links:** auto-switches to Approvals section and opens the project details modal for that specific project | ☐ |
| B2.3 | Click "Approvals" in sidebar | `captain-dashboard.html` → Approvals section | Pending tab shows the "Youth Clean-Up Drive 2026" project card | ☐ |
| B2.4 | Click "View Details" on the project | Approval Modal | Modal displays: **Project Information Card** (Submitted By, Date, Budget ₱15,000, Volunteers 10, Start/End Dates), **Budget Breakdown** table (3+ items with costs), **Beneficiaries**, **Description** | ☐ |
| B2.5 | Click **"Approve"** button | Approval Modal | Confirm dialog appears, click confirm | ☐ |
| B2.6 | Verify project moves to "Approved" tab | Approvals section → Approved tab | Project card now shows green "Approved" badge, approval date recorded | ☐ |
| B2.7 | Check that SK (Ledonio) received notification | (Ledonio checks `sk-dashboard.html`) | Notification about project approval appears (from `notify_project_approval` trigger) | ☐ |
| B2.7a | **SK clicks the approval notification** | `sk-projects.html` | **Deep links:** auto-opens the approved project details modal | ☐ |
| B2.8 | SK verifies project status changed | `sk-projects.html` | Project card now shows **"Upcoming"** status (green) instead of "Pending Approval" | ☐ |

> **Also test REJECTION flow** (optional second project):
> - Captain clicks "Reject" → must type mandatory rejection notes → project shows "Rejected" badge
> - SK sees "Rejected" status with Captain's notes in the project detail modal under "Captain's Decision" section
> - SK receives rejection notification with deep link to the rejected project

#### B3: SK Starts the Project (Ledonio) — NEW

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| B3.1 | Open the approved project (status: "Upcoming") | `sk-projects.html` → Project card | **"Start Project"** button visible (only for project head) | ☐ |
| B3.2 | Verify "Start Project" button does NOT appear for non-head SK officials | `sk-projects.html` | Button hidden if logged-in SK is not a project head | ☐ |
| B3.3 | Click **"Start Project"** | `sk-projects.html` | Confirm dialog appears, click confirm | ☐ |
| B3.4 | Verify status changes to **"Ongoing"** | `sk-projects.html` | Project card shows blue "Ongoing" badge, `startDateTime` set to current time | ☐ |
| B3.5 | Verify **"Mark as Complete"** button now appears | `sk-projects.html` | Button visible only for Ongoing projects (NOT Upcoming) | ☐ |

---

### Phase C — Volunteer Applications (Pelias + Ledonio)

#### C1: Volunteers Apply to the Project (Pelias — all 5 accounts)

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| C1.1 | Log in as Volunteer 1 | `login.html` | Redirects to `youth-dashboard.html` | ☐ |
| C1.2 | Navigate to Projects | `youth-projects.html` | Project grid loads, "Youth Clean-Up Drive 2026" visible with "Ongoing" status | ☐ |
| C1.3 | Click on the project card | Project Details Modal | **Details tab:** Shows category, status badge, duration, location, project heads, description | ☐ |
| C1.4 | Click **"Apply"** button | Apply Modal | Form opens pre-filled with profile data (name, birthday, contact, email, address) | ☐ |
| C1.5 | Fill in **Preferred Role** (optional — no longer required) | Apply Modal | Role field accepts input but form submits even if left blank | ☐ |
| C1.6 | **If under 18:** Parental Consent section appears | Apply Modal | Upload field visible with text: *"Required for applicants under 18 years old"*; accepts PDF, JPG, PNG formats; uploads to `consent-forms` bucket | ☐ |
| C1.7 | **If 18+:** Parental Consent section disabled/dimmed | Apply Modal | Section is grayed out with disabled inputs | ☐ |
| C1.8 | Click **Submit Application** | Apply Modal | Toast: "Application submitted successfully", modal closes | ☐ |
| C1.8a | **Verify SK receives notification** about new application | (Ledonio checks `sk-projects.html`) | Notification of type `new_application` received with applicant name and project title | ☐ |
| C1.9 | Check application in dashboard | `youth-dashboard.html` → My Applications | Application card shows: project name, applied date, selected role, **"Pending Review"** status (yellow badge) | ☐ |
| C1.10 | Repeat for Volunteers 2–5 | Same flow | All 5 applications submitted successfully | ☐ |

#### C1-Edit: Volunteer Edits Application (Pelias) — NEW

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| C1-E1 | Open "My Applications" and click **Edit** on an existing application | Edit Application Modal | Form pre-fills with existing data (name, birthday, contact, email, address, role) | ☐ |
| C1-E2 | **Verify consent file display** (for under-18 volunteer) | Edit Application Modal | Custom file input shows existing consent filename (e.g., `1708123456_consent.pdf`) instead of "No file selected." | ☐ |
| C1-E3 | Click "View" on the green "Current file uploaded" banner | Edit Application Modal | Opens the consent file via signed URL in a new tab | ☐ |
| C1-E4 | Click the file input "Browse..." to upload a new consent file | Edit Application Modal | File picker opens, newly selected filename replaces the old one in the display | ☐ |
| C1-E5 | Save changes | Edit Application Modal | Toast: "Application updated successfully! Parental consent uploaded.", modal closes | ☐ |

#### C2: SK Reviews Applications (Ledonio)

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| C2.1 | Open the project in SK Projects | `sk-projects.html` → click project | Project Details modal opens | ☐ |
| C2.1a | **Click notification about new application** | `sk-projects.html` | **Deep links:** auto-opens project and switches to Applicants tab | ☐ |
| C2.2 | Switch to **"Applicants"** tab | Applicants tab | Shows **5 applicant cards**, each with: name, role, "Pending" status, apply date | ☐ |
| C2.3 | Use filter dropdown → **"All"** | Applicants tab | All 5 visible | ☐ |
| C2.4 | Use filter dropdown → **"Pending"** | Applicants tab | All 5 visible (all pending) | ☐ |
| C2.5 | Click **"View Details"** on Volunteer 1 | Application Detail | Shows full application: name, birthday, contact, email, address, preferred role, parental consent link (if minor) — **3-column layout** | ☐ |
| C2.6 | **Mark attendance** checkbox for Volunteers 1–4 | Applicants tab | Checkbox toggles, **persists to database** (reload page and verify checkbox state is preserved) | ☐ |
| C2.7 | Click **"Update Status" → Approve** for Volunteers 1, 2, 3, 4 | Applicants tab | Status changes to **"Approved"** (green badge) for each | ☐ |
| C2.8 | Click **"Update Status" → Reject** for Volunteer 5 | Applicants tab | Status changes to **"Rejected"** (red badge) | ☐ |
| C2.9 | Use filter dropdown → **"Approved"** | Applicants tab | Shows 4 approved volunteers | ☐ |
| C2.10 | Use filter dropdown → **"Rejected"** | Applicants tab | Shows 1 rejected volunteer | ☐ |
| C2.11 | Applicant count badges update | Applicants tab | Badge shows correct counts per status | ☐ |

#### C3: Volunteers Check Their Application Status (Pelias)

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| C3.1 | Log in as Volunteer 1 (approved) | `youth-dashboard.html` | Notification received about approval (from `notify_application_status` trigger) | ☐ |
| C3.1a | **Click the approval notification** | `youth-projects.html` | **Deep links:** auto-opens the project details modal | ☐ |
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
| D2a | **Verify SK receives notification** about new inquiry | (Ledonio checks notifications) | Notification of type `new_inquiry` received (from `notify_new_inquiry` trigger) | ☐ |
| D2b | **SK clicks the inquiry notification** | `sk-projects.html` | **Deep links:** auto-opens project and switches to Inquiries tab | ☐ |
| D3 | Volunteer 2 posts another inquiry: "Is there parking available at the venue?" | `youth-projects.html` | Second inquiry appears | ☐ |
| D4 | SK (Ledonio) opens project → **"Inquiries"** tab | `sk-projects.html` → Inquiries tab | Both inquiries visible with sender name, message, timestamp | ☐ |
| D5 | SK replies to Inquiry 1: "Please bring gloves and water bottles" | `sk-projects.html` → Reply textarea | Reply appears below the inquiry, reply count badge updates to 1 | ☐ |
| D6 | SK replies to Inquiry 2: "Yes, parking is available at the covered court" | `sk-projects.html` | Reply saved, `isReplied` status updated in DB | ☐ |
| D7 | Volunteer 1 checks inquiry tab | `youth-projects.html` → Inquiries tab | SK's reply visible under their inquiry | ☐ |
| D8 | Volunteer 1 checks notifications | `youth-dashboard.html` | Notification about inquiry reply (from `notify_inquiry_reply` trigger) | ☐ |
| D8a | **Volunteer clicks the reply notification** | `youth-projects.html` | **Deep links:** auto-opens project and switches to Inquiries tab | ☐ |

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
| F3a | Verify **event pills are not cut off** in calendar cells | `sk-calendar.html` | Event pill text fully visible within the taller calendar cells (110px height) | ☐ |
| F3b | Verify **calendar rows match the month** | `sk-calendar.html` | Months that only need 4 or 5 rows no longer show an empty 6th row | ☐ |
| F4 | Volunteer checks calendar | `youth-calendar.html` | Same project events visible on volunteer's calendar view, event pills not cut off | ☐ |

---

### Phase G — Project Completion & Evaluation (Ledonio)

> **Prerequisite:** The project must be in **"Ongoing"** status (use Phase B3 "Start Project" first). "Mark as Complete" only appears for Ongoing projects.

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| G1 | SK opens project and clicks **"Mark as Complete"** button | `sk-projects.html` → Project card | Evaluation Modal opens. **Note:** button only appears for Ongoing projects, NOT Upcoming | ☐ |
| G2 | Fill **Budget Efficiency** (25% weight): | Evaluation Modal | | ☐ |
| | — Actual Spent: ₱12,000 | | Auto-calculates efficiency vs planned ₱15,000 using **deviation formula**: `max(0, (1 - abs(actual-planned)/planned) * 100)` — spending ₱12K of ₱15K = 80% efficiency | ☐ |
| | — Add Budget Breakdown items with actual amounts | | Planned vs Actual comparison visible, **totals update in real-time as you type** (not just on blur) | ☐ |
| | — Upload receipt(s) | | Receipt uploads to `receipts` Supabase bucket. Removing a receipt deletes from storage. Deleting a budget row also removes its receipt from storage | ☐ |
| G3 | Fill **Volunteer Participation** (20% weight): | Evaluation Modal | | ☐ |
| | — Target: 10, Actual: 4 | | Auto-calculates participation rate | ☐ |
| G4 | Fill **Timeline Adherence** (20% weight): | Evaluation Modal | | ☐ |
| | — Select timeline status from dropdown | | Dropdown options available | ☐ |
| G5 | Fill **Community Impact** (20% weight): | Evaluation Modal | | ☐ |
| | — Type achievements or use quick achievement buttons | | Suggestions appear (environmental, social, education-focused) | ☐ |
| G6 | **Volunteer Feedback** (15% weight) auto-populates | Evaluation Modal | Shows average satisfaction score and count from volunteer surveys. **Score scale is 1–5** (not 1–4). Individual volunteer feedback cards with per-question scores are displayed | ☐ |
| G7 | Verify **Success Rate** calculation | Evaluation Modal | Overall success rate % displays with progress bar (weighted average of all 5 metrics). Budget efficiency uses deviation formula (penalizes both over- AND under-spending) | ☐ |
| G8 | Submit evaluation | Evaluation Modal | Toast success, project status changes to **"Completed"**, success rate badge appears on project card | ☐ |

---

### Phase H — Certificates & Satisfaction Survey (Espinosa + Pelias)

> **IMPORTANT CHANGE:** Volunteers marked as "attended" can now submit satisfaction surveys while the project is still **Ongoing**. Certificates are only available after the project is **Completed**.

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| H0 | **(Before project completion)** Volunteer 1 navigates to Certificates | `youth-certificates.html` | Ongoing project appears (if volunteer is marked as attended). Info text: *"Projects where you were marked as attended... You can fill out the satisfaction survey while the project is ongoing or after completion."* | ☐ |
| H0a | Verify **three card states**: | `youth-certificates.html` | (a) Yellow "Complete Satisfaction Survey" button if survey not done; (b) Score shown + gray "certificate available once completed" if survey done but project still Ongoing; (c) Score shown + green "View Certificate" button if survey done and project Completed | ☐ |
| H0b | Submit survey **while project is Ongoing** | `youth-certificates.html` → Survey Modal | Survey saves successfully, card updates to show score + "certificate available once completed" message. Status badge shows "Ongoing" (blue) | ☐ |
| H1 | SK (Espinosa) generates certificates for approved volunteers | Certificate generation flow | Certificates created in `Certificate_Tbl`, uploaded to `certificates` bucket | ☐ |
| H2 | Volunteer 1 logs in → navigates to Certificates | `youth-certificates.html` | Certificate for "Youth Clean-Up Drive 2026" appears in list with "Survey Complete" (green) status badge | ☐ |
| H3 | Volunteer 1 clicks **"View Certificate"** | Certificate Modal | Certificate displays in landscape format with: participant name, project name, date of completion | ☐ |
| H4 | Test **zoom controls**: Zoom In, Zoom Out, Reset Zoom | Certificate Modal | Zoom level % updates (up to 3x, minimum 0.5x), certificate scales correctly, pan/drag works when zoomed | ☐ |
| H5 | Click **"Download Certificate"** | Certificate Modal | PDF downloads in landscape A4 format. Filename: `Certificate_[Name]_[Project].pdf`. Opens correctly in PDF reader | ☐ |
| H6 | Volunteer 1 clicks **"Rate this project"** / Survey button (if not already done in H0b) | Survey Modal | Star rating (1–5 scale) and comments textarea visible | ☐ |
| H7 | Submit survey: 5 stars, "Great experience!" | Survey Modal | Toast success, satisfaction score saved to DB | ☐ |
| H8 | Repeat H2–H7 for Volunteers 2, 3, 4 (approved only) | Same flow | All 4 approved volunteers can view/download certificates and submit surveys | ☐ |
| H9 | Volunteer 5 (rejected) checks certificates | `youth-certificates.html` | **No certificate** should appear for the rejected volunteer | ☐ |

---

### Phase H2 — SK Feedback Tab (Ledonio) — NEW

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| H2.1 | SK opens the project details modal | `sk-projects.html` → click project | **4 tabs visible:** Details, Applicants, Inquiries, **Feedback** | ☐ |
| H2.2 | Click **"Feedback"** tab | Feedback tab | Tab shows count badge (e.g., "Feedback (4)") | ☐ |
| H2.3 | Verify **summary section** | Feedback tab | Per-question averages displayed: Overall, Skills, Teamwork, Impact, Recommend. Overall average bar shown | ☐ |
| H2.4 | Verify **individual response cards** | Feedback tab | Each volunteer's response shown with: name, date, per-question scores, optional message | ☐ |
| H2.5 | Verify **satisfaction score badge** on applicant cards | Applicants tab | Approved volunteers who submitted surveys show a purple star badge (e.g., "4.2") next to their name | ☐ |
| H2.6 | Click "View Details" on applicant who submitted survey | Application Detail modal | **"Survey Feedback" section** visible with per-question scores and feedback message | ☐ |
| H2.7 | Open project with **no surveys submitted** | Feedback tab | Shows "No survey feedback yet" empty state | ☐ |

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
| J3 | Navigate to Archive page | `sk-archive.html` → Archived Projects tab | Archived project appears in grid with: title, status, dates, budget. **All data is live from Supabase** (not hardcoded) | ☐ |
| J3a | Verify **dynamic stats cards** | `sk-archive.html` | Total Reports, Archived Projects, Total Budget, Volunteers, Success Rate all computed from actual data | ☐ |
| J3b | Verify **year filter defaults** | `sk-archive.html` | Default filter is "All Years" (not 2025). Year 2026 is available in dropdown | ☐ |
| J3c | Verify **success rate** in archive | `sk-archive.html` | Uses same weighted 5-factor formula. Budget efficiency uses deviation formula | ☐ |
| J4 | Open archived project details | `sk-archive.html` → click project | Modal shows full project details with sticky action footer (Unarchive/Delete/Download/Close buttons stay fixed at bottom when scrolling) | ☐ |
| J4a | Click **"Unarchive"** button | `sk-archive.html` → Project Detail Modal | Confirm dialog appears. Project restores to previous status (COMPLETED/ONGOING) and disappears from archive. Verify it reappears in `sk-projects.html` | ☐ |
| J4b | Click **"Permanent Delete"** | `sk-archive.html` → Project Detail Modal | Must type "DELETE" to confirm. Project is **permanently removed from database** | ☐ |
| J5 | Captain checks Archives section | `captain-dashboard.html` → Archives section | Captain can see archived project in their archives view | ☐ |
| J5a | **Captain tries permanent delete** | `captain-dashboard.html` | Captain should now be able to delete archived projects (Migration 018 expanded RLS policy) | ☐ |
| J6 | Volunteer checks Projects page | `youth-projects.html` | Project **no longer appears** in active project list | ☐ |

---

### Phase K — Testimonies (Pelias + Ledonio)

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| K1 | Volunteer 1 submits a testimony about the project | Testimony submission flow | Testimony saved with `isFiltered = false` (visible to public) | ☐ |
| K2 | SK views all testimonies | `sk-testimonies.html` | All submitted testimonies visible, SK can filter/manage them | ☐ |
| K2a | **SK deletes a testimony** | `sk-testimonies.html` | Delete succeeds (Migration 018 added `auth_delete_testimonies` RLS policy). Previously deletes silently failed | ☐ |
| K3 | Public landing page shows testimony | `index.html` | Unfiltered testimonies display in testimonials section | ☐ |

---

### Phase L — Superadmin Oversight (Ralleta)

| # | Action | Page | What to Verify | ☐ |
|---|--------|------|---------------|---|
| L1 | Log in as Superadmin (Login as Google: malandaysk@gmail.com / sk.malanday2026) | `login.html` | Redirects to `superadmin-dashboard.html` | ☐ |
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

| Trigger | When | Who Gets Notified | Deep Link Target | ☐ |
|---------|------|-------------------|-----------------|---|
| `notify_new_project` | SK creates a project | Captain gets notification | `captain-dashboard.html?projectId=X` | ☐ |
| `notify_project_approval` | Captain approves/rejects | SK (project creator) gets notification | `sk-projects.html?projectId=X` | ☐ |
| `notify_application_status` | SK approves/rejects application | Volunteer gets notification | `youth-projects.html?projectId=X` | ☐ |
| `notify_inquiry_reply` | SK replies to inquiry | Volunteer (inquiry author) gets notification | `youth-projects.html?projectId=X&tab=inquiries` | ☐ |
| `notify_new_inquiry` | Volunteer submits inquiry | SK (project owner) gets notification | `sk-projects.html?projectId=X&tab=inquiries` | ☐ |
| `notify_new_application` *(client-side)* | Volunteer submits application | SK (project head) gets notification | `sk-projects.html?projectId=X&tab=applications` | ☐ |

> **Deep linking test:** For each notification, click it and verify it navigates to the correct page AND auto-opens the relevant project/tab. Legacy notifications (without `referenceID`) should still navigate to the page but skip auto-opening.

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
| Pre-req | Apply Migrations 017 + 018 | Developer | ☐ |
| Step 1 | Fix Verification | All | ☐ |
| Phase A | Account Setup (5 volunteers) + Password Complexity | Pelias | ☐ |
| Phase B | Project Creation, Captain Approval & Start Project | Ledonio + Ralleta | ☐ |
| Phase C | Volunteer Applications (apply, edit, consent display, review, attendance, PDF) | Pelias + Ledonio | ☐ |
| Phase D | Inquiries, Replies & Deep Linking | Pelias + Ledonio | ☐ |
| Phase E | File Upload & Management | Ledonio + Pelias | ☐ |
| Phase F | Calendar Events (taller cells, dynamic rows) | Espinosa + Pelias | ☐ |
| Phase G | Project Completion & Evaluation (new budget formula, receipts) | Ledonio | ☐ |
| Phase H | Certificates, Satisfaction Survey (ongoing survey support) & SK Feedback Tab | Espinosa + Pelias + Ledonio | ☐ |
| Phase I | Download Project Report (PDF/Excel) | Ledonio | ☐ |
| Phase J | Project Archive (live data, unarchive, permanent delete) | Espinosa/Ledonio + Ralleta | ☐ |
| Phase K | Testimonies (with delete support) | Pelias + Ledonio | ☐ |
| Phase L | Superadmin Oversight | Ralleta | ☐ |

**Total test steps: 110+**
**Deadline: Tuesday 2026-02-25**
