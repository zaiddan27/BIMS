# Project Lifecycle System - Defense Guide

> Quick-reference guide for the BIMS project lifecycle: from creation to archive.
> Covers `sk-projects.html`, `youth-projects.html`, `captain-dashboard.html`, `sk-archive.html`.

---

## The Big Picture (How Everything Connects)

```
SK Official creates project (sk-projects.html)
        |
        v
Captain reviews & decides (captain-dashboard.html)
   /       |         \
APPROVED  REJECTED  REVISION_REQUESTED
   |         |            |
   v         v            v
Project    Stays in     SK Official
goes       rejected     edits &
UPCOMING   state        resubmits
   |
   v
SK Official clicks "Start Project" --> ONGOING
   |
   v
Youth browse & apply (youth-projects.html)
   |
   v
SK Official approves/rejects volunteers (sk-projects.html)
   |
   v
Project runs --> SK marks attendance, handles inquiries
   |
   v
SK clicks "Mark as Complete" --> fills evaluation --> COMPLETED
   |
   v
Archive (sk-archive.html) -- auto after 3 months, or manual
```

### Key Database Tables

| Table | What it stores |
|-------|---------------|
| `Pre_Project_Tbl` | The main project record (title, budget, status, dates, approval info) |
| `Application_Tbl` | Youth volunteer applications (status, attendance, consent file) |
| `Inquiry_Tbl` | Questions from youth about projects |
| `Reply_Tbl` | Replies to inquiries (from SK officials or youth follow-ups) |
| `BudgetBreakdown_Tbl` | Planned budget line items (description + cost) |
| `Expenses_Tbl` | Actual expenses with receipt URLs (filled at completion) |
| `Post_Project_Tbl` | Completion evaluation data (achievements, actual volunteers, timeline) |
| `Evaluation_Tbl` | Volunteer satisfaction surveys (q1-q5 ratings + message) |
| `SK_Tbl` | SK officials info (linked to User_Tbl) |
| `File_Tbl` | Uploaded documents (used in archive for file management) |

### Project Status Values (`Pre_Project_Tbl.status`)

| Status | Meaning |
|--------|---------|
| `PENDING` | Just created, waiting for captain |
| `UPCOMING` | Approved, hasn't started yet |
| `ONGOING` | Currently running |
| `COMPLETED` | Finished with evaluation |
| `CANCELLED` | Archived |

### Approval Status Values (`Pre_Project_Tbl.approvalStatus`)

| Status | Meaning |
|--------|---------|
| `PENDING` | Awaiting captain's decision |
| `APPROVED` | Captain approved |
| `REJECTED` | Captain rejected (notes required) |
| `REVISION` / `REVISION_REQUESTED` | Captain wants changes (notes required) |

---

## 1. sk-projects.html (SK Official's Command Center)

**Who uses it:** SK Officials (the ones who create and manage projects)

### What This Page Does
This is the most feature-heavy page. SK Officials can:
- Create/edit projects
- Manage volunteer applications (approve/reject)
- Track attendance
- Handle inquiries from youth
- View volunteer feedback
- Complete projects with full evaluation
- Generate attendance PDFs and project reports

### Core Flow

#### A. Creating a Project
1. SK Official fills out the project form (title, category, dates, budget, description, banner image, location)
2. Selects project heads from SK officials dropdown
3. Adds budget breakdown items (each item = description + cost)
4. On save:
   - Project inserted into `Pre_Project_Tbl` with `approvalStatus = 'PENDING'`
   - Budget items saved to `BudgetBreakdown_Tbl`
   - Notification sent to Captain via `create_notification` RPC
   - Banner uploaded to `project-images` storage bucket

#### B. Managing Applicants
Once approved and running, youth will apply. The SK Official:
1. Opens a project --> "Applicants" tab
2. Sees cards for each applicant with status badge (Pending/Approved/Rejected)
3. Can filter applicants by status
4. Clicks an applicant card --> sees their details + parental consent file (if under 18)
5. Clicks **Approve** or **Reject**:
   - Updates `Application_Tbl.applicationStatus`
   - Sends notification to the volunteer via `create_notification` RPC
6. For approved volunteers during ongoing projects: **attendance checkbox** appears
   - Toggles `Application_Tbl.attended` (boolean)

#### C. Handling Inquiries
1. Youth submit inquiries from their side (youth-projects.html)
2. SK Official sees them in project --> "Inquiries" tab
3. Types a reply --> inserts into `Reply_Tbl`, marks `Inquiry_Tbl.isReplied = true`

#### D. Completing a Project
When project is ONGOING, SK Official clicks "Mark as Complete":
1. **Evaluation modal** opens with:
   - **Actual budget breakdown** (pre-filled from planned, editable costs, receipt uploads)
   - **Volunteer count** (target vs actual)
   - **Beneficiary count** (target vs actual)
   - **Timeline adherence** (dropdown: on-time / slightly-delayed / delayed / significantly-delayed)
   - **Achievements** (free text entries)
   - **Volunteer feedback** (auto-loaded from `Evaluation_Tbl`)
2. On submit:
   - `Pre_Project_Tbl.status` --> `COMPLETED`
   - New row in `Post_Project_Tbl` with achievements, timeline, beneficiary data
   - Each expense saved to `Expenses_Tbl` with receipt URLs
   - **Success rate** calculated (see below)

#### E. Success Rate Formula (Weighted)
| Component | Weight | How it's calculated |
|-----------|--------|-------------------|
| Budget Efficiency | 25% | `(1 - |actual - planned| / planned) * 100` |
| Volunteer Participation | 20% | `(actualVolunteers / targetVolunteers) * 100` |
| Timeline Adherence | 20% | on-time=100%, slightly-delayed=70%, delayed=40%, significantly-delayed=10% |
| Community Impact | 20% | `(actualBeneficiaries / targetBeneficiaries) * 100` |
| Volunteer Feedback | 15% | Average of q1-q5 survey scores, normalized to 100 |

#### F. Archiving
- Manual: click "Archive" on completed/rejected projects --> sets `status = 'CANCELLED'`
- Auto: `checkAutoArchive()` runs hourly, archives projects completed > 3 months ago

### Key Functions at a Glance

| Function | What it does |
|----------|-------------|
| `initializePage()` | Boots everything: auth check, load projects, SK officials, URL params |
| `loadProjects()` | Fetches all projects with nested applications, inquiries, budget data |
| `renderProjects()` | Draws project cards in a paginated grid (3 per page) |
| `viewProject()` | Opens the big detail modal with 4 tabs |
| `editProject()` | Opens create/edit form (checks if user is project head) |
| `updateStatus()` | Approves or rejects a volunteer application + sends notification |
| `toggleAttendance()` | Marks volunteer as attended/not attended |
| `sendInquiryReply()` | Posts reply to youth's inquiry |
| `submitEvaluation()` | Completes the project with all metrics |
| `calculateSuccessRate()` | Computes the weighted success percentage |
| `generateAttendancePDF()` | Creates downloadable attendance sheet via jsPDF |
| `startProject()` | Changes UPCOMING --> ONGOING |
| `archiveProject()` | Changes status --> CANCELLED |
| `saveBudgetBreakdownItems()` | Saves planned budget items to DB |
| `uploadReceipt()` | Uploads receipt image for actual expenses |
| `createCaptainNotification()` | Sends notification to captain about new/updated project |

---

## 2. youth-projects.html (Youth/Volunteer Side)

**Who uses it:** Youth residents who want to volunteer for projects

### What This Page Does
Youth can:
- Browse approved projects
- Search and filter by category
- View project details and inquiries
- Apply to volunteer
- Track their application status
- Ask questions (inquiries) and follow up

### Core Flow

#### A. Browsing Projects
1. Page loads --> `loadProjects()` fetches from `Pre_Project_Tbl` where `approvalStatus = 'APPROVED'` and `status != 'CANCELLED'`
2. Projects shown as cards in a paginated grid (3 per page)
3. Can search by title/description/location or filter by category dropdown

#### B. Applying to a Project
1. Youth clicks "Apply Now" on a project card
2. Apply modal opens, **pre-filled with their profile data** (name, birthday, contact, address)
3. They choose a **preferred role**
4. If under 18: **parental consent file** required (PDF/JPG/PNG, max 5MB)
   - Uploaded to `consent-forms` storage bucket
5. On submit:
   - `User_Tbl` updated with latest profile info (keeps profile in sync)
   - New row inserted into `Application_Tbl` with `applicationStatus = 'PENDING'`
   - Card now shows "Already Applied" badge instead of "Apply Now"

#### C. Tracking Applications
- "My Applications" grid below the projects shows all their applications
- Each card shows: project name, applied date, preferred role, status badge
- **Status badges**: Pending (yellow), Approved (green), Rejected (red), Archived (gray)
- Can **edit** pending applications (change role or upload new consent file)
- Personal details are locked (read-only) -- must change via profile settings

#### D. Inquiry System
1. Click "Send Inquiry" on any project --> modal opens --> type question
2. Inserts into `Inquiry_Tbl` with `isReplied = false`
3. In project detail modal, "Inquiries" tab shows all Q&A threads
4. Youth can reply to their own inquiry threads (creates `Reply_Tbl` entries)
5. **Notification badge** on bell icon shows count of new replies to their inquiries

### Key Functions at a Glance

| Function | What it does |
|----------|-------------|
| `initializePage()` | Auth check, load projects + applications, setup UI |
| `loadProjects()` | Fetches approved, non-cancelled projects with inquiry data |
| `renderProjects()` | Draws browsable project cards with apply/inquiry buttons |
| `openApplyModal()` | Opens application form pre-filled with profile data |
| `submitApplication()` | Validates, uploads consent if needed, inserts application |
| `loadMyApplications()` | Fetches user's applications from `Application_Tbl` |
| `renderMyApplicationsGrid()` | Shows compact application status cards |
| `submitInquiry()` | Posts a new question about a project |
| `sendInquiryReply()` | Continues an inquiry conversation |
| `applyFilters()` | Filters projects by search text + category |
| `handleURLParameters()` | Deep-links to specific project from notifications |

---

## 3. captain-dashboard.html (Captain's Approval Center)

**Who uses it:** Barangay Captain (the authority who approves/rejects project proposals)

### What This Page Does
The captain:
- Reviews pending project proposals
- Approves, rejects, or requests revision
- Sees project statistics (pending/approved/rejected counts, total budget)
- Can revisit and change previous decisions

### Core Flow

#### A. Reviewing Projects
1. `loadProjectApprovals()` fetches projects with status in `['PENDING', 'APPROVED', 'REJECTED', 'REVISION', 'REVISION_REQUESTED']`
2. Projects organized into tabs: **Pending**, **Approved**, **Rejected** (5 per page)
3. Each card shows: title, category, submitter name, budget, volunteer count, start date
4. Captain clicks "Review Project" --> detail modal opens

#### B. What the Captain Sees in the Modal
- Project name, submitter, submission date
- Proposed budget + itemized budget breakdown table
- Expected volunteers, target beneficiaries
- Start/end dates, full description, location
- **For PENDING projects**: action buttons (Approve / Reject / Request Revision)
- **For already-decided projects**: previous decision + "Review Decision" button to change it

#### C. The Three Decisions

| Action | Function | Notes Required? | DB Update |
|--------|----------|----------------|-----------|
| **Approve** | `approveProject()` | Optional (defaults to "Approved by Barangay Captain.") | `approvalStatus = 'APPROVED'` |
| **Reject** | `rejectProject()` | **Required** (validated) | `approvalStatus = 'REJECTED'` |
| **Request Revision** | `requestRevision()` | **Required** (validated) | `approvalStatus = 'REVISION'` |

All three also set `approvalNotes` and `approvalDate`, then:
- Trigger database notification to the SK Official who submitted
- Reload the project list
- Show a toast confirmation

#### D. Statistics Dashboard
`updateStatistics()` shows:
- Pending count
- Approved count
- Rejected count
- Total budget across all projects (formatted as "PHP X.XM")

### Key Functions at a Glance

| Function | What it does |
|----------|-------------|
| `loadProjectApprovals()` | Fetches projects for captain review with budget data |
| `renderProjects()` | Renders project cards organized by status tabs |
| `viewProjectDetails()` | Opens review modal with full project info |
| `approveProject()` | Sets approvalStatus to APPROVED + notifies SK |
| `rejectProject()` | Sets approvalStatus to REJECTED (requires notes) + notifies SK |
| `requestRevision()` | Sets approvalStatus to REVISION (requires notes) + notifies SK |
| `reviewDecision()` | Switches already-decided project back to edit mode |
| `updateStatistics()` | Recalculates dashboard counters and budget total |
| `showConfirm()` | Generic confirmation modal before any decision |

---

## 4. sk-archive.html (Archive & Reports)

**Who uses it:** SK Officials and Captain

### What This Page Does
- View all archived (CANCELLED) projects with metrics
- Restore projects back to active status
- Permanently delete projects
- Export project reports (PDF/CSV/TXT)
- Bulk-select and generate reports for multiple projects
- Manage archived files separately

### Core Flow

#### A. Viewing Archived Projects
1. `loadArchivedProjects()` fetches from `Pre_Project_Tbl` where `status = 'CANCELLED'`
2. For each project, computes:
   - **Success rate** (weighted from budget, timeline, evaluations)
   - **Budget efficiency** (planned vs actual spending)
   - **Impact score** (beneficiaries + volunteer engagement)
   - **Participation rate** (approved / total applicants)
3. Cards show: title, success badge (color-coded), period, quarter, budget, volunteers
4. Dashboard overview: total projects, total budget, total volunteers, avg success rate

#### B. Filtering
- **Search** by project name
- **Year** dropdown
- **Quarter** dropdown (Q1-Q4)
- Quarter summary updates dynamically with selected quarter's stats

#### C. Restoring a Project
`unarchiveProject()`:
- Shows confirmation modal
- Updates `Pre_Project_Tbl.status` from `CANCELLED` back to:
  - `COMPLETED` (if it was approved)
  - `ONGOING` (if it was rejected/revision)
- Project disappears from archive, reappears in sk-projects

#### D. Permanently Deleting
`confirmPermanentDelete()` --> `executeDelete()`:
- **Safety**: requires typing "DELETE" character-by-character (6-input OTP-style)
- Deletes from `Pre_Project_Tbl` (cascade handles related records)
- **Irreversible** -- data is gone

#### E. Exporting
Three formats available per project:
- **PDF** (`exportAsPDF()`): Full formatted report with sections, metrics, volunteer list, budget breakdown
- **CSV** (`exportAsCSV()`): Spreadsheet-compatible data
- **Text** (`exportAsText()`): Plain text summary

**Bulk reports**: select multiple projects via checkboxes --> `generateBulkReports()` downloads PDFs for all selected

#### F. Archived Files Tab
Separate tab (`switchArchiveType('files')`) for managing archived uploaded files:
- Loads from `File_Tbl` where `fileStatus = 'ARCHIVED'`
- Can preview files (images directly, PDFs via pdf.js)
- Can **restore** file back to ACTIVE status
- Can **permanently delete** file (removes from storage bucket + database)

### Key Functions at a Glance

| Function | What it does |
|----------|-------------|
| `loadArchivedProjects()` | Fetches CANCELLED projects with all metrics |
| `renderProjects()` | Draws archive cards with success badges and metrics |
| `viewProject()` | Opens detailed modal with scores, volunteers, budget |
| `unarchiveProject()` | Restores project to COMPLETED/ONGOING status |
| `confirmPermanentDelete()` | Opens "type DELETE" confirmation |
| `executeDelete()` | Permanently removes project from database |
| `exportAsPDF/CSV/Text()` | Exports project data in chosen format |
| `generateBulkReports()` | PDF export for multiple selected projects |
| `updateOverviewStats()` | Dashboard totals (projects, budget, volunteers, success) |
| `applyFilters()` | Filters by search, year, quarter |
| `loadArchivedFiles()` | Fetches archived files from File_Tbl |
| `confirmRestoreFile()` | Restores file to ACTIVE status |
| `confirmDeleteArchivedFile()` | Permanently deletes file from storage + DB |

---

## Cross-Page Data Flow Summary

Here's how data moves between the four pages:

```
sk-projects.html                          captain-dashboard.html
+-----------------------+                 +-------------------------+
| SK creates project    |---notification->| Captain sees pending    |
| status=PENDING        |                 | project in review queue |
|                       |<--notification--| Captain approves/       |
| Status updates to     |                 | rejects/requests revision|
| APPROVED/REJECTED/    |                 +-------------------------+
| REVISION              |
|                       |
| If APPROVED:          |    youth-projects.html
| SK starts project --> |    +-------------------------+
| status=ONGOING        |    | Youth browse APPROVED   |
|                       |<---| projects & apply        |
| SK approves/rejects   |    | Youth send inquiries    |
| volunteers            |--->| Youth see app status    |
|                       |    +-------------------------+
| SK tracks attendance  |
| SK handles inquiries  |
| SK completes project  |
| status=COMPLETED      |
|                       |
| Archive (manual/auto) |    sk-archive.html
| status=CANCELLED      |--->+-------------------------+
+-----------------------+    | View archived projects  |
                             | Restore / Delete / Export|
                             +-------------------------+
```

### Notification Flow
- **SK creates project** --> `create_notification` RPC --> Captain gets notified
- **Captain decides** --> DB trigger `notify_project_approval` --> SK gets notified
- **SK approves/rejects volunteer** --> `create_notification` RPC --> Youth gets notified
- **SK replies to inquiry** --> Youth sees reply in inquiries tab + notification badge

### Shared Components (imported across pages)
- `SessionManager` -- auth & session handling
- `ProfileModal` -- user profile editing
- `NotificationModal` -- notification bell & panel
- `showToast()` -- toast notifications
- `logAction()` -- audit trail logging
- `escapeHTML()` -- XSS prevention (from sanitize.js)
- `sanitizeImageURL()` -- validates Supabase URLs

---

## Quick Defense Q&A Prep

**Q: How does a project go from idea to completion?**
> Created by SK Official --> Captain approves --> Goes UPCOMING --> SK starts it (ONGOING) --> Youth apply & volunteer --> SK tracks attendance --> SK completes with evaluation --> Gets archived

**Q: What happens when a project is rejected?**
> Captain must provide notes explaining why. SK Official gets notified. They can edit and resubmit, or archive the rejected project.

**Q: How does the budget system work?**
> Planned budget is broken into line items in `BudgetBreakdown_Tbl`. At completion, SK fills in actual costs per item and uploads receipts. System calculates budget efficiency as part of the success rate.

**Q: How are volunteers managed?**
> Youth apply via youth-projects.html. SK Official reviews each application, can view parental consent for minors, then approves or rejects. Approved volunteers get attendance tracking during the project.

**Q: What's the success rate?**
> A weighted score: Budget Efficiency (25%) + Volunteer Participation (20%) + Timeline Adherence (20%) + Community Impact (20%) + Volunteer Feedback (15%). Calculated at project completion.

**Q: What does archiving do?**
> Sets `status = 'CANCELLED'`. Project moves to sk-archive.html where it can be viewed with full metrics, exported as PDF/CSV/TXT, restored, or permanently deleted.

**Q: How do inquiries work?**
> Youth ask questions on projects. SK Officials reply. Both sides can continue the thread. Youth get notified when their inquiry gets a reply.
