# NEW TEST CASES - FILE MANAGEMENT

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Publish File to Homepage Transparency Section
Test Case ID: AD-F9
Test Designed by: JC Ledonio
Test Priority: High
Test Designed date: November 29, 2025
Function Name: File Management - Publish File
Test Executed by:
Test Title: Publish File to Homepage Transparency Section
Test Execution date:
Description: Verify that an SK Official can publish a file to the public homepage Transparency section using the star icon and confirmation modal.

Pre-Condition: Logged in as SK Official and on the File Management page; at least one unpublished file exists.
Dependencies: File record exists in File_Tbl with isPublished = false; homepage transparency section is functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Locate an unpublished file in the file list (star icon is empty/outline) | Budget_Report_2023.pdf | File card is visible with an empty star icon | | | |
| 2 | Click the empty star icon on the file card | Budget_Report_2023.pdf | A confirmation modal appears with the message "This will make the file visible to the public" and an info box explaining the file will appear in the Transparency section on the homepage | | | |
| 3 | Click "Confirm" on the publish modal | | System publishes the file; star icon changes to filled/solid; a success toast message appears (e.g., "File published to homepage") | | | |
| 4 | Navigate to the homepage and scroll to the Transparency & Budget Reports section | | The published file (Budget_Report_2023.pdf) is visible and downloadable in the Transparency section | | | |

Post-Condition: The file's isPublished flag is set to true in the database; the file is publicly visible on the homepage Transparency section.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Unpublish File from Homepage
Test Case ID: AD-F10
Test Designed by: JC Ledonio
Test Priority: Medium
Test Designed date: November 29, 2025
Function Name: File Management - Unpublish File
Test Executed by:
Test Title: Unpublish File from Homepage
Test Execution date:
Description: Verify that an SK Official can remove a file from public homepage display by clicking the filled star icon.

Pre-Condition: Logged in as SK Official and on the File Management page; at least one published file exists (filled star icon).
Dependencies: File exists with isPublished = true.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Locate a published file in the file list (star icon is filled/solid) | Budget_Report_2023.pdf | File card is visible with a filled star icon | | | |
| 2 | Click the filled star icon on the file card | Budget_Report_2023.pdf | System immediately unpublishes the file; star icon changes to empty/outline; a toast message appears: "File removed from homepage" | | | |
| 3 | Navigate to the homepage Transparency section | | The file (Budget_Report_2023.pdf) is no longer visible in the Transparency section | | | |

Post-Condition: The file's isPublished flag is set to false; the file is no longer publicly visible but remains accessible in the File Management page.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Archive File with Confirmation
Test Case ID: AD-F11
Test Designed by: JC Ledonio
Test Priority: High
Test Designed date: November 29, 2025
Function Name: File Management - Archive File
Test Executed by:
Test Title: Archive File with Confirmation
Test Execution date:
Description: Verify that an SK Official can archive a file from the active list with a confirmation dialog.

Pre-Condition: Logged in as SK Official and on the File Management page; at least one active file exists.
Dependencies: File exists in File_Tbl with fileStatus = ACTIVE; archive functionality is operational.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Locate a file in the active file list | Budget_Report_2023.pdf | File card is visible with an "Archive" button | | | |
| 2 | Click the "Archive" button on the file card | Budget_Report_2023.pdf | A confirmation modal appears with the message "You can restore it from the Archive page" | | | |
| 3 | Click "Confirm" on the archive modal | | System archives the file; file disappears from the active file list; a success toast message appears | | | |
| 4 | Verify the file is no longer in the active file list | | The archived file is not visible in the File Management page | | | |
| 5 | (Optional) Click "Cancel" on the archive modal instead of Confirm | Another file | The modal closes; no archiving occurs; the file remains in the active list | | | |

Post-Condition: The file's fileStatus is changed to ARCHIVED in the database; the file is no longer visible in the active File Management list but is accessible from the Archives page.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Restore Archived File
Test Case ID: AD-F12
Test Designed by: JC Ledonio
Test Priority: Medium
Test Designed date: November 29, 2025
Function Name: File Management - Restore Archived File
Test Executed by:
Test Title: Restore Archived File to Active Status
Test Execution date:
Description: Verify that an SK Official can restore an archived file back to active status from the Archives page.

Pre-Condition: Logged in as SK Official and on the Archives page (sk-archive.html); at least one archived file exists in the Archived Files tab.
Dependencies: File exists in File_Tbl with fileStatus = ARCHIVED.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Navigate to the Archives page (sk-archive.html) | | Archives page loads with tabs for Archived Projects and Archived Files | | | |
| 2 | Click on the "Archived Files" tab | | The archived files list displays with file name, upload date, file type, uploader, and action buttons | | | |
| 3 | Locate the archived file and click "Restore" | Budget_Report_2023.pdf | A confirmation modal appears asking to restore the file | | | |
| 4 | Confirm the restoration | | System restores the file; success toast message appears; file disappears from the Archived Files list | | | |
| 5 | Navigate to the File Management page (sk-files.html) | | The restored file (Budget_Report_2023.pdf) is now visible in the active file list | | | |

Post-Condition: The file's fileStatus is changed from ARCHIVED back to ACTIVE; the file is visible in the File Management page and removed from Archives.
