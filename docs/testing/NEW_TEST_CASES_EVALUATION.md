# NEW TEST CASES - PROJECT EVALUATION & REPORTING (SK OFFICIAL)

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Submit Project Evaluation with 5 Weighted Criteria
Test Case ID: SK-P16
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: High
Test Designed date: November 29, 2025
Function Name: Project Monitoring - Submit Evaluation
Test Executed by:
Test Title: Submit Project Evaluation with 5 Weighted Criteria
Test Execution date:
Description: Verify that an SK Official can complete and submit a project evaluation using all 5 weighted criteria.

Pre-Condition: Logged in as SK Official; a project is in a state ready for evaluation (approved and completed/ongoing).
Dependencies: Evaluation modal and Evaluation_Tbl are functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Open a project and click "Evaluate Project" or the evaluation option | Community Clean-Up Drive | Evaluation modal opens showing 5 evaluation criteria sections | | | |
| 2 | Rate Budget Efficiency (25% weight) | Rating: 4/5 | Slider or input accepts the rating; percentage weight is displayed | | | |
| 3 | Rate Volunteer Participation (20% weight) | Rating: 5/5 | Rating is accepted and displayed | | | |
| 4 | Rate Timeline Adherence (20% weight) | Rating: 3/5 | Rating is accepted and displayed | | | |
| 5 | Rate Community Impact (20% weight) | Rating: 5/5 | Rating is accepted and displayed | | | |
| 6 | Rate Volunteer Feedback (15% weight) | Rating: 4/5 | Rating is accepted and displayed | | | |
| 7 | Click "Submit Evaluation" | | System calculates weighted average score, saves the evaluation, shows success toast, and the project shows the evaluation score | | | |

Post-Condition: The evaluation is saved in the database with individual criteria ratings and weighted overall score.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Upload Receipts for Budget Breakdown
Test Case ID: SK-P17
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: Medium
Test Designed date: November 29, 2025
Function Name: Project Monitoring - Upload Receipts
Test Executed by:
Test Title: Upload Receipt Images for Budget Breakdown Items
Test Execution date:
Description: Verify that an SK Official can upload receipt images for each budget breakdown item during project evaluation.

Pre-Condition: Logged in as SK Official; evaluation modal is open for a project with budget breakdown items.
Dependencies: Receipts storage bucket is configured; budget breakdown section is functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | In the evaluation modal, navigate to the Budget Breakdown section | | Budget breakdown table is visible with planned items and fields for actual amounts | | | |
| 2 | Click "Load from Planned Budget" to auto-fill items | | Planned budget items populate the actual breakdown table with item names and planned amounts | | | |
| 3 | Enter actual spent amount for a budget item | Item: "Materials", Actual: ₱15,000 | Amount is accepted in the input field | | | |
| 4 | Click the "Upload Receipt" button for that item | receipt_materials.jpg (under 5MB) | File upload dialog opens; after selecting the file, the receipt image uploads and a preview/thumbnail is displayed | | | |
| 5 | Verify the receipt is attached | | Receipt icon or thumbnail shows next to the budget item confirming successful upload | | | |
| 6 | (Optional) Click "Remove Receipt" | | Receipt is removed from the item; upload button reappears | | | |

Post-Condition: Receipt images are uploaded to storage and linked to their respective budget breakdown items.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Generate Attendance Sheet PDF
Test Case ID: SK-P18
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: Medium
Test Designed date: November 29, 2025
Function Name: Project Monitoring - Generate Attendance PDF
Test Executed by:
Test Title: Generate Attendance Sheet PDF
Test Execution date:
Description: Verify that an SK Official can generate and download a PDF attendance sheet for a project's applicants.

Pre-Condition: Logged in as SK Official; a project has accepted applicants with attendance data.
Dependencies: PDF generation library is functional; applicant data exists.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Open a project with applicants | Community Clean-Up Drive | Project details modal opens | | | |
| 2 | Click "Generate Attendance PDF" button | | System processes the request and generates a PDF file | | | |
| 3 | Verify the PDF is downloaded | | Browser downloads a PDF file named with the project title and "Attendance" | | | |
| 4 | Open the downloaded PDF | | PDF contains a formatted attendance sheet listing all applicants with their name, status, and attendance checkbox/mark | | | |

Post-Condition: Attendance PDF is downloaded to user's device with accurate applicant and attendance data.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Add Project Achievements
Test Case ID: SK-P19
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: Low
Test Designed date: November 29, 2025
Function Name: Project Monitoring - Add Achievements
Test Executed by:
Test Title: Add Project Achievements During Evaluation
Test Execution date:
Description: Verify that an SK Official can add quick achievements and custom achievements during project evaluation.

Pre-Condition: Logged in as SK Official; evaluation modal is open.
Dependencies: Achievement tracking section is functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | In the evaluation modal, navigate to the Achievements section | | Quick achievement buttons are visible: Environmental Impact, Community Benefit, Volunteer Growth, Educational Value, Project Impact | | | |
| 2 | Click "Environmental Impact" quick achievement button | | Achievement row is added to the list with "Environmental Impact" as the title | | | |
| 3 | Click "Community Benefit" quick achievement button | | Another achievement row is added below | | | |
| 4 | Click "Add Custom Achievement" | | A new empty row appears with an editable text field | | | |
| 5 | Enter a custom achievement text | "50 trees planted along the riverbank" | Text is accepted in the custom achievement field | | | |
| 6 | (Optional) Delete an achievement row by clicking the remove button | | The selected achievement row is removed from the list | | | |

Post-Condition: Project achievements are recorded and will be included in the project evaluation/report.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Download Project Report (PDF Format)
Test Case ID: SK-P20
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: Medium
Test Designed date: November 29, 2025
Function Name: Project Monitoring - Download Report PDF
Test Executed by:
Test Title: Download Project Report in PDF Format
Test Execution date:
Description: Verify that an SK Official can download a complete project report as a PDF file.

Pre-Condition: Logged in as SK Official; project has evaluation data, budget breakdown, and applicant information.
Dependencies: PDF report generation is functional; project data is complete.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Open a project and click "Download Report" | Community Clean-Up Drive | Download Report modal opens with format options | | | |
| 2 | Select "PDF" format | | PDF format is selected | | | |
| 3 | Click "Download" | | System generates the report and initiates the download | | | |
| 4 | Open the downloaded PDF file | | PDF contains complete project report: project details, evaluation scores, budget breakdown with transparency, attendance info, achievements, and volunteer list | | | |

Post-Condition: A complete PDF project report is downloaded to the user's device.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Download Project Report (Excel Format)
Test Case ID: SK-P21
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: Medium
Test Designed date: November 29, 2025
Function Name: Project Monitoring - Download Report Excel
Test Executed by:
Test Title: Download Project Report in Excel Format
Test Execution date:
Description: Verify that an SK Official can download a project report as an Excel file.

Pre-Condition: Logged in as SK Official; project has evaluation data and budget data.
Dependencies: Excel export functionality is operational.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Open a project and click "Download Report" | Community Clean-Up Drive | Download Report modal opens | | | |
| 2 | Select "Excel" format | | Excel format is selected | | | |
| 3 | Click "Download" | | System generates and downloads an Excel file | | | |
| 4 | Open the downloaded Excel file | | File contains project data in spreadsheet format with applicant lists, budget breakdown, and evaluation data | | | |

Post-Condition: An Excel project report is downloaded with project data in tabular format.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Start Project (Change Status)
Test Case ID: SK-P22
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: Medium
Test Designed date: November 29, 2025
Function Name: Project Monitoring - Start Project
Test Executed by:
Test Title: Start Project and Change Status
Test Execution date:
Description: Verify that an SK Official can start an approved project, changing its status and recording the start date.

Pre-Condition: Logged in as SK Official; a project has been approved by the Captain and is ready to start.
Dependencies: Project has approvalStatus = APPROVED.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Locate an approved project on the Monitor Projects page | Hatid Sakay Program | Project card shows "Approved" status | | | |
| 2 | Click "Start Project" | | Confirmation dialog appears | | | |
| 3 | Confirm the action | | System updates the project status to reflect it has started; start date/time is recorded; success toast appears | | | |
| 4 | Verify the project status is updated | | Project card now shows the updated status (e.g., "Ongoing") | | | |

Post-Condition: The project status is updated; the project timeline begins.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Archive Completed Project
Test Case ID: SK-P23
Test Designed by: Ryan Paolo C. Espinosa
Test Priority: Medium
Test Designed date: November 29, 2025
Function Name: Project Monitoring - Archive Project
Test Executed by:
Test Title: Archive a Completed Project
Test Execution date:
Description: Verify that an SK Official can archive a completed project, moving it from the active projects list to the Archives section with all evaluation data preserved.

Pre-Condition: Logged in as SK Official; a project has been completed and evaluated.
Dependencies: Project evaluation is complete; archive functionality is operational.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Locate a completed/evaluated project | Community Clean-Up Drive | Project card is visible with completed status | | | |
| 2 | Click "Archive Project" | | Confirmation dialog appears | | | |
| 3 | Confirm the archiving | | System archives the project; success toast appears; project is removed from the active projects list | | | |
| 4 | Navigate to the Archives page (sk-archive.html) | | The archived project appears in the Archived Projects tab with all evaluation metrics and financial summaries preserved | | | |

Post-Condition: The project is moved to Archives with all data intact; it no longer appears in the active Monitor Projects list.
