# NEW TEST CASES - PROJECT APPROVAL (BARANGAY CAPTAIN)

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
View Pending Projects for Approval
Test Case ID: CAP-P1
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: High
Test Designed date: November 29, 2025
Function Name: Project Approval - View Pending
Test Executed by:
Test Title: View Pending Projects for Captain Approval
Test Execution date:
Description: Verify that the Barangay Captain can view all projects submitted for approval in the Pending Approval tab with accurate counts.

Pre-Condition: Logged in as Barangay Captain and on the Captain Dashboard; at least one project has been submitted for approval by an SK Official.
Dependencies: Projects exist with approvalStatus = PENDING; Captain Dashboard is functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Navigate to the Captain Dashboard | | Dashboard loads with the Project Approvals section visible, showing overview cards (Pending, Approved, Rejected, Total Budget) | | | |
| 2 | Verify the "Pending Approval" count card | | Card displays the correct count of pending projects | | | |
| 3 | Click on the "Pending Approval" tab | | Tab becomes active; the pending projects grid displays all projects awaiting approval with project cards | | | |
| 4 | Verify project card details | Hatid Sakay Program | Card shows project title, category, SK Project Head name, submitted date, and budget | | | |
| 5 | Click on a project card to view details | Hatid Sakay Program | Project details modal opens showing full project information including description, timeline, budget breakdown, and beneficiaries | | | |

Post-Condition: Captain can view all pending projects with complete details; no changes are made to project data.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Approve Project with Optional Notes
Test Case ID: CAP-P2
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: High
Test Designed date: November 29, 2025
Function Name: Project Approval - Approve Project
Test Executed by:
Test Title: Approve Project with Optional Approval Notes
Test Execution date:
Description: Verify that the Barangay Captain can approve a pending project with optional approval notes.

Pre-Condition: Logged in as Barangay Captain; at least one project is in "Pending Approval" status.
Dependencies: Project exists with approvalStatus = PENDING; notification system is functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Open a pending project from the Pending Approval tab | Hatid Sakay Program | Project details modal opens with Approve, Reject, and Request Revision buttons visible | | | |
| 2 | (Optional) Enter approval notes in the comments field | Notes: "Approved. Good initiative for the community." | Text appears in the notes field | | | |
| 3 | Click the "Approve" button | | A confirmation dialog appears asking to confirm the approval | | | |
| 4 | Click "Confirm" on the dialog | | System updates approvalStatus to APPROVED; approval date is recorded; success toast appears: project is approved | | | |
| 5 | Verify the project moved to the Approved tab | | The project no longer appears in Pending tab; it now appears in the Approved tab; Pending count decreases by 1, Approved count increases by 1 | | | |
| 6 | Login as SK Official | SK credentials | SK Official receives a notification about the Captain's approval decision | | | |

Post-Condition: The project is approved; SK Official is notified; the project appears in the Approved tab with approval date and notes.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Reject Project with Required Reason
Test Case ID: CAP-P3
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: High
Test Designed date: November 29, 2025
Function Name: Project Approval - Reject Project
Test Executed by:
Test Title: Reject Project with Required Rejection Reason
Test Execution date:
Description: Verify that the Captain must provide a reason when rejecting a project, and that the rejection is processed correctly.

Pre-Condition: Logged in as Barangay Captain; at least one project is in "Pending Approval" status.
Dependencies: Project exists with approvalStatus = PENDING.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Open a pending project from the Pending Approval tab | Hatid Sakay Program | Project details modal opens with action buttons | | | |
| 2 | Click the "Reject" button WITHOUT entering a reason | Notes field: (empty) | System displays a validation message requiring a reason/comment for rejection; rejection is NOT processed | | | |
| 3 | Enter a rejection reason in the comments field | Notes: "Budget exceeds allocated funds for this quarter. Please revise the budget breakdown." | Text appears in the notes field | | | |
| 4 | Click the "Reject" button again | | Confirmation dialog appears | | | |
| 5 | Click "Confirm" | | System updates approvalStatus to REJECTED with the rejection reason; error-style toast appears confirming rejection | | | |
| 6 | Verify the project moved to the Rejected tab | | Project appears in Rejected tab with rejection reason and date visible; Pending count decreases | | | |

Post-Condition: The project is rejected with a recorded reason; SK Official is notified of the rejection.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Request Project Revision with Required Details
Test Case ID: CAP-P4
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: High
Test Designed date: November 29, 2025
Function Name: Project Approval - Request Revision
Test Executed by:
Test Title: Request Project Revision with Required Details
Test Execution date:
Description: Verify that the Captain can request a revision on a pending project with required details about what needs to be changed.

Pre-Condition: Logged in as Barangay Captain; at least one project is in "Pending Approval" status.
Dependencies: Project exists with approvalStatus = PENDING.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Open a pending project from the Pending Approval tab | Community Clean-Up Drive | Project details modal opens | | | |
| 2 | Click "Request Revision" WITHOUT entering details | Notes field: (empty) | System displays a validation message requiring revision details; action is NOT processed | | | |
| 3 | Enter revision details in the comments field | Notes: "Please add more details about the waste segregation plan and update the volunteer roles section." | Text appears in the notes field | | | |
| 4 | Click "Request Revision" again | | Confirmation dialog appears | | | |
| 5 | Click "Confirm" | | System updates approvalStatus to REVISION with the revision notes; info toast appears confirming revision request | | | |
| 6 | Login as SK Official | SK credentials | SK Official sees the project with "Revision" status and can view the Captain's revision notes | | | |

Post-Condition: The project status is REVISION; SK Official is notified and can view the revision details to make changes.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Confirmation Dialog Before Approval Actions
Test Case ID: CAP-P5
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: Medium
Test Designed date: November 29, 2025
Function Name: Project Approval - Confirmation Dialog
Test Executed by:
Test Title: Confirmation Dialog Appears Before All Approval Actions
Test Execution date:
Description: Verify that a confirmation dialog appears before every approval action and that clicking Cancel aborts the action.

Pre-Condition: Logged in as Barangay Captain; at least one project is in "Pending Approval" status.
Dependencies: Confirmation dialog component is functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Open a pending project and click "Approve" | Hatid Sakay Program | A confirmation dialog appears with a message confirming the approval action and Confirm/Cancel buttons | | | |
| 2 | Click "Cancel" on the approval confirmation dialog | | Dialog closes; no changes are made; project remains in Pending status | | | |
| 3 | Enter a reason in comments and click "Reject" | Notes: "Budget too high" | A confirmation dialog appears with rejection confirmation message | | | |
| 4 | Click "Cancel" on the rejection confirmation dialog | | Dialog closes; no changes are made; project remains in Pending status | | | |
| 5 | Enter details and click "Request Revision" | Notes: "Revise timeline" | A confirmation dialog appears with revision request confirmation message | | | |
| 6 | Click "Cancel" on the revision confirmation dialog | | Dialog closes; no changes are made; project remains in Pending status | | | |

Post-Condition: All three actions show confirmation dialogs; cancelling any dialog leaves the project unchanged.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
View Approved Projects Tab
Test Case ID: CAP-P6
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: Low
Test Designed date: November 29, 2025
Function Name: Project Approval - Approved Tab
Test Executed by:
Test Title: View Approved Projects Tab
Test Execution date:
Description: Verify that the Captain can view all previously approved projects in the Approved tab with correct details.

Pre-Condition: Logged in as Barangay Captain; at least one project has been approved.
Dependencies: Projects with approvalStatus = APPROVED exist in the database.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Click on the "Approved" tab in the Project Approvals section | | Tab becomes active; the approved projects grid displays | | | |
| 2 | Verify the count badge matches the number of projects shown | | The count badge on the tab matches the actual number of approved project cards | | | |
| 3 | Click on an approved project card | Youth Sports Festival | Project details modal opens showing full details plus the approval date and any approval notes | | | |
| 4 | Close the modal | | Modal closes; user remains on the Approved tab | | | |

Post-Condition: Captain can view all approved projects with approval dates and notes.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
View Rejected Projects Tab
Test Case ID: CAP-P7
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: Low
Test Designed date: November 29, 2025
Function Name: Project Approval - Rejected Tab
Test Executed by:
Test Title: View Rejected Projects Tab
Test Execution date:
Description: Verify that the Captain can view all previously rejected projects in the Rejected tab with the rejection reasons.

Pre-Condition: Logged in as Barangay Captain; at least one project has been rejected.
Dependencies: Projects with approvalStatus = REJECTED exist in the database.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Click on the "Rejected" tab in the Project Approvals section | | Tab becomes active; the rejected projects grid displays | | | |
| 2 | Verify the count badge matches the number of projects shown | | The count badge on the tab matches the actual number of rejected project cards | | | |
| 3 | Click on a rejected project card | Hatid Sakay Program | Project details modal opens showing full details plus the rejection date and rejection reason/notes | | | |
| 4 | Verify the rejection reason is visible | | The Captain's rejection reason is clearly displayed in the project details | | | |
| 5 | Close the modal | | Modal closes; user remains on the Rejected tab | | | |

Post-Condition: Captain can view all rejected projects with rejection reasons and dates.
