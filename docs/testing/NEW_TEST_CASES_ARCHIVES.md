# NEW TEST CASES - ARCHIVES

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
View Archived Files
Test Case ID: SK-ARC6
Test Designed by: JC Ledonio
Test Priority: Medium
Test Designed date: December 15, 2025
Function Name: Archives - View Archived Files
Test Executed by:
Test Title: View Archived Files in Archives Page
Test Execution date:
Description: Verify that an SK Official can view archived files in the Archived Files tab of the Archives page with complete file information.

Pre-Condition: Logged in as SK Official and on the Archives page (sk-archive.html); at least one file has been archived.
Dependencies: Archived files exist in File_Tbl with fileStatus = ARCHIVED.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Navigate to the Archives page (sk-archive.html) | | Archives page loads with tabs for Archived Projects and Archived Files | | | |
| 2 | Click on the "Archived Files" tab | | Tab becomes active; the archived files list/table displays | | | |
| 3 | Verify the file information displayed | | Each archived file shows: File Name, Upload Date, File Type, Uploader Name, and File Size | | | |
| 4 | Verify action buttons are available | | Each archived file has "Restore" and "Delete" action buttons | | | |

Post-Condition: SK Official can view all archived files with complete details; no data is changed.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Restore Archived File to Active Status
Test Case ID: SK-ARC7
Test Designed by: JC Ledonio
Test Priority: Medium
Test Designed date: December 15, 2025
Function Name: Archives - Restore File
Test Executed by:
Test Title: Restore Archived File to Active Status
Test Execution date:
Description: Verify that an SK Official can restore an archived file back to active status, making it visible again in the File Management page.

Pre-Condition: Logged in as SK Official; at least one archived file exists in the Archived Files tab.
Dependencies: File exists with fileStatus = ARCHIVED; restore functionality is operational.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Navigate to the Archives page and click "Archived Files" tab | | Archived files list displays | | | |
| 2 | Locate the file to restore | Budget_Report_2023.pdf | File is visible with "Restore" button | | | |
| 3 | Click the "Restore" button | Budget_Report_2023.pdf | A confirmation modal appears asking to confirm restoration | | | |
| 4 | Click "Confirm" on the modal | | System changes fileStatus from ARCHIVED to ACTIVE; success toast appears; file disappears from the archived list | | | |
| 5 | Navigate to File Management page (sk-files.html) | | The restored file (Budget_Report_2023.pdf) is now visible in the active file list with all original details intact | | | |

Post-Condition: File is restored to ACTIVE status and appears in the File Management page; it is removed from the Archives.
