# NEW TEST CASES - PROJECT MONITORING

---

## PROJECT MANAGEMENT - SK OFFICIAL

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Submit Project for Captain Approval
Test Case ID: SK-P11
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: High
Test Designed date: November 29, 2025
Function Name: Project Monitoring - Submit for Approval
Test Executed by:
Test Title: Submit Project for Barangay Captain Approval
Test Execution date:
Description: Verify that an SK Official can submit a project for Barangay Captain approval and the Captain receives a notification.

Pre-Condition: Logged in as SK Official and on the Monitor Projects page; at least one project exists that has not yet been submitted for approval.
Dependencies: Project exists in Pre_Project_Tbl; Captain account is active; notification system is functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Locate a project that has not been submitted for approval | Hatid Sakay Program | Project card is visible with a "Submit for Approval" option | | | |
| 2 | Click "Submit for Approval" | Hatid Sakay Program | A confirmation dialog appears asking to confirm submission to the Barangay Captain | | | |
| 3 | Click "Confirm" on the dialog | | System updates the project's approvalStatus to "PENDING"; a success toast appears; the project card status updates to "Pending Approval" | | | |
| 4 | Login as Barangay Captain | Captain credentials | Captain dashboard shows the project in the Pending Approval tab with the correct count | | | |

Post-Condition: The project is pending Captain approval; the Captain has a notification about the new submission.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Cancel Project Approval Request
Test Case ID: SK-P12
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: Medium
Test Designed date: November 29, 2025
Function Name: Project Monitoring - Cancel Approval
Test Executed by:
Test Title: Cancel Project Approval Request
Test Execution date:
Description: Verify that an SK Official can cancel a pending approval request, reverting the project to an editable state.

Pre-Condition: Logged in as SK Official; a project has "Pending Approval" status.
Dependencies: Project exists with approvalStatus = PENDING.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Locate a project with "Pending Approval" status | Hatid Sakay Program | Project card shows "Pending Approval" badge | | | |
| 2 | Click "Cancel Approval" on the project | Hatid Sakay Program | A confirmation modal appears asking to confirm cancellation | | | |
| 3 | Click "Confirm" | | System reverts the project's approvalStatus; the project is now editable again; a success toast appears | | | |
| 4 | Verify the project is editable | | Edit and Delete buttons are available again on the project card | | | |

Post-Condition: The project approval request is cancelled; the project is editable and no longer appears in the Captain's pending queue.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Resubmit Project After Revision Request
Test Case ID: SK-P13
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: Medium
Test Designed date: November 29, 2025
Function Name: Project Monitoring - Resubmit After Revision
Test Executed by:
Test Title: Resubmit Project After Captain Revision Request
Test Execution date:
Description: Verify that after the Captain requests a revision, the SK Official can edit the project and resubmit it for approval.

Pre-Condition: Logged in as SK Official; a project has "Revision" status from the Captain's revision request with notes.
Dependencies: Project has approvalStatus = REVISION with Captain's notes.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Locate a project with "Revision" status | Hatid Sakay Program | Project card shows "Revision" badge; Captain's revision notes are visible in the project details | | | |
| 2 | Click "Edit" on the project | | Edit Project modal opens with current details pre-filled | | | |
| 3 | Update the project details based on Captain's feedback | Updated Description: "Revised scope and budget as per Captain's request" | Changes are accepted in the form fields | | | |
| 4 | Click "Save" | | System saves the edited project; success toast appears | | | |
| 5 | Click "Submit for Approval" again | | Confirmation dialog appears; after confirming, project status changes to "Pending Approval" | | | |

Post-Condition: The revised project is resubmitted for Captain approval with updated details.

---

## PROJECT INQUIRIES - YOUTH VOLUNTEER

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Submit New Project Inquiry
Test Case ID: YV-P9
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: Medium
Test Designed date: November 29, 2025
Function Name: Projects - Submit Inquiry
Test Executed by:
Test Title: Youth Volunteer Submitting a New Project Inquiry
Test Execution date:
Description: Verify that a Youth Volunteer can submit an initial inquiry about a project and that the SK Official receives a notification.

Pre-Condition: Logged in as Youth Volunteer; on the Projects page; at least one project is available.
Dependencies: Project exists; Inquiry_Tbl and notification system are functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Open a project by clicking "View Details" | Community Clean-Up Drive | Project Details modal opens | | | |
| 2 | Click on the "Inquiries" tab inside the modal | | Inquiries tab loads showing existing inquiries (if any) and a "Send Inquiry" button | | | |
| 3 | Click "Send Inquiry" | | Inquiry modal opens with a message text field | | | |
| 4 | Type an inquiry message | Message: "Hello po, what time should we arrive for the clean-up drive?" | Message appears in the text field | | | |
| 5 | Click "Submit" | | System saves the inquiry; success toast appears; the inquiry appears in the thread with the volunteer's name and timestamp | | | |

Post-Condition: The inquiry is saved in the database; the SK Official receives a notification about the new inquiry.

---

## VOLUNTEER APPLICATION - YOUTH VOLUNTEER

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Track Application Status
Test Case ID: YV-P10
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: Low
Test Designed date: November 29, 2025
Function Name: Projects - Track Application Status
Test Executed by:
Test Title: Youth Volunteer Tracking Application Status
Test Execution date:
Description: Verify that a Youth Volunteer can view their submitted applications and track the status of each (Pending Review, Accepted, Rejected).

Pre-Condition: Logged in as Youth Volunteer; at least one application has been submitted.
Dependencies: Application records exist in Application_Tbl with various statuses.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Navigate to the Projects page | | Projects page loads | | | |
| 2 | Click on "My Applications" section/button | | The My Applications view displays showing application cards for all submitted applications | | | |
| 3 | Verify a pending application displays correct status | Application to: Community Clean-Up Drive | Card shows "Pending Review" status badge in yellow/orange color | | | |
| 4 | Verify an accepted application displays correct status | Application to: Youth Sports Festival | Card shows "Accepted" status badge in green color | | | |
| 5 | Verify a rejected application displays correct status | Application to: Scholarship Program | Card shows "Rejected" status badge in red color | | | |

Post-Condition: Youth Volunteer can see all application statuses clearly; no data is changed.

---

## APPLICATION MANAGEMENT - SK OFFICIAL

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Revert Application to Pending Status
Test Case ID: SK-P14
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: Medium
Test Designed date: November 29, 2025
Function Name: Project Monitoring - Revert Application Status
Test Executed by:
Test Title: Revert Applicant Status to Pending
Test Execution date:
Description: Verify that an SK Official can revert an Accepted or Rejected applicant back to Pending Review status.

Pre-Condition: Logged in as SK Official; a project has at least one applicant with "Accepted" or "Rejected" status.
Dependencies: Application record exists in Application_Tbl.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Open a project and go to the Applicants tab | Community Clean-Up Drive | Applicants list loads with status indicators | | | |
| 2 | Click on an applicant with "Accepted" status | Dela Cruz, Juan R. | Applicant details modal opens showing current status "Accepted" | | | |
| 3 | Click the "Revert to Pending" button | | A confirmation dialog appears | | | |
| 4 | Confirm the action | | System updates the status to "Pending Review"; the applicant's status badge changes; success toast appears | | | |

Post-Condition: The applicant's status is reverted to Pending Review in the database and UI.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Toggle Attendance for Applicants
Test Case ID: SK-P15
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: Medium
Test Designed date: November 29, 2025
Function Name: Project Monitoring - Toggle Attendance
Test Executed by:
Test Title: Toggle Attendance Checkbox for Applicants
Test Execution date:
Description: Verify that an SK Official can mark and unmark attendance for accepted applicants using the attendance checkbox.

Pre-Condition: Logged in as SK Official; a project has at least one accepted applicant.
Dependencies: Attendance tracking is implemented in the applicants tab.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Open a project and go to the Applicants tab | Community Clean-Up Drive | Applicants list loads with attendance checkboxes visible for accepted applicants | | | |
| 2 | Check the attendance checkbox for an accepted applicant | Dela Cruz, Juan R. | Checkbox becomes checked; attendance is recorded in the system | | | |
| 3 | Verify the attendance is saved by refreshing the page | | After refresh, the checkbox for the same applicant remains checked | | | |
| 4 | Uncheck the attendance checkbox | Dela Cruz, Juan R. | Checkbox becomes unchecked; attendance record is removed | | | |

Post-Condition: Attendance records are accurately saved and can be toggled on/off.
