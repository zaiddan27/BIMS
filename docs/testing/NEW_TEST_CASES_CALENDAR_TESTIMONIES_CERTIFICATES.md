# NEW TEST CASES - CALENDAR, TESTIMONIES, CERTIFICATES

---

## CALENDAR EXPORTS

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Export Event to Google Calendar
Test Case ID: AD-CAL4
Test Designed by: JC Ledonio
Test Priority: Low
Test Designed date: November 29, 2025
Function Name: Calendar Management - Export to Google Calendar
Test Executed by:
Test Title: Export Calendar Event to Google Calendar
Test Execution date:
Description: Verify that a user can export a calendar event to Google Calendar with event details pre-filled.

Pre-Condition: User is logged in (SK Official or Youth Volunteer) and on the Calendar page; at least one event exists.
Dependencies: Calendar events are loaded; Google Calendar export link generation is functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Click on a calendar event | Community Clean-Up Drive (Dec 2, 2025 08:00-12:00) | Event details modal opens showing event title, date/time, location, and export options | | | |
| 2 | Click "Export to Google Calendar" or the Google Calendar icon | | Browser opens a new tab/window with Google Calendar's event creation page pre-filled with the event title, date, time, location, and description | | | |
| 3 | Verify the pre-filled details in Google Calendar | | Event title, date, time, and location match the BIMS calendar event | | | |

Post-Condition: User can save the event to their Google Calendar; BIMS event data is unchanged.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Export Event to Outlook
Test Case ID: AD-CAL5
Test Designed by: JC Ledonio
Test Priority: Low
Test Designed date: November 29, 2025
Function Name: Calendar Management - Export to Outlook
Test Executed by:
Test Title: Export Calendar Event to Outlook
Test Execution date:
Description: Verify that a user can export a calendar event to Outlook.

Pre-Condition: User is logged in and on the Calendar page; at least one event exists.
Dependencies: Outlook export functionality (ICS file or Outlook web link) is functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Click on a calendar event | Community Clean-Up Drive | Event details modal opens with export options | | | |
| 2 | Click "Export to Outlook" or the Outlook icon | | System generates an .ics file or opens Outlook web with event details; browser initiates download or opens Outlook | | | |
| 3 | Open the exported event in Outlook | | Event details (title, date, time, location) match the BIMS calendar event | | | |

Post-Condition: User can add the event to their Outlook calendar.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Export Event to iCal
Test Case ID: AD-CAL6
Test Designed by: JC Ledonio
Test Priority: Low
Test Designed date: November 29, 2025
Function Name: Calendar Management - Export to iCal
Test Executed by:
Test Title: Export Calendar Event to iCal
Test Execution date:
Description: Verify that a user can download an .ics file for a calendar event compatible with iCal and other calendar apps.

Pre-Condition: User is logged in and on the Calendar page; at least one event exists.
Dependencies: ICS file generation is functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Click on a calendar event | Community Clean-Up Drive | Event details modal opens with export options | | | |
| 2 | Click "Export to iCal" or the iCal/download icon | | Browser downloads an .ics file | | | |
| 3 | Open the downloaded .ics file | | The file opens in the default calendar application (Apple Calendar, Google Calendar, etc.) with correct event title, date, time, and location | | | |

Post-Condition: An .ics file is downloaded and can be imported into any standard calendar application.

---

## TESTIMONIES - YOUTH VOLUNTEER

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Submit Testimony with Star Rating
Test Case ID: YV-T1
Test Designed by: Brian Louis B. Ralleta
Test Priority: High
Test Designed date: December 15, 2025
Function Name: Testimonies - Submit Testimony
Test Executed by:
Test Title: Youth Volunteer Submitting a Testimony with Star Rating
Test Execution date:
Description: Verify that a Youth Volunteer who attended a completed project can submit a testimony with a star rating and written feedback.

Pre-Condition: Logged in as Youth Volunteer; user has been marked as an attended/accepted applicant for a completed project; testimony submission feature is accessible.
Dependencies: Project is completed; attendance is recorded; Testimony_Tbl is functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Navigate to the testimony submission feature (from project or dedicated page) | | Testimony form is accessible showing fields for project selection, star rating, and text feedback | | | |
| 2 | Select the project to write a testimony for | Project: Community Clean-Up Drive | Project is selected | | | |
| 3 | Click on the star rating to give a score | Rating: 5 stars | 5 stars are highlighted/filled indicating the selected rating | | | |
| 4 | Write a testimony text | "The clean-up drive was a wonderful experience! I learned so much about waste segregation and met amazing people. Highly recommend joining!" | Text appears in the testimony text field | | | |
| 5 | Click "Submit Testimony" | | System saves the testimony with star rating and text; success toast appears; testimony is submitted | | | |
| 6 | Login as SK Official and navigate to Testimonies page | | The submitted testimony appears in the All tab with the volunteer's name, project name, star rating, and submission date | | | |

Post-Condition: The testimony is saved in the database; it appears in the SK Official's Volunteer Testimonies page for review and potential featuring.

---

## CERTIFICATES - YOUTH VOLUNTEER

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Complete Satisfaction Survey After Project
Test Case ID: YV-CERT1
Test Designed by: Brian Louis B. Ralleta
Test Priority: High
Test Designed date: December 15, 2025
Function Name: Certificates - Satisfaction Survey
Test Executed by:
Test Title: Complete Satisfaction Survey After Attending a Project
Test Execution date:
Description: Verify that a Youth Volunteer can complete a satisfaction survey after attending a completed project.

Pre-Condition: Logged in as Youth Volunteer; user attended a completed project; survey is available on the Certificates page.
Dependencies: youth-certificates.html is accessible; survey questions are loaded; project is in completed status.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Navigate to the Certificates page (youth-certificates.html) | | Certificates page loads showing attended projects with survey status | | | |
| 2 | Select a completed project that requires a survey | Community Clean-Up Drive | Survey form opens with questions | | | |
| 3 | Answer all survey questions | Responses to survey questions (ratings, text feedback as required) | All responses are accepted without validation errors | | | |
| 4 | Click "Submit Survey" | | System saves the survey responses; success toast appears; the project's survey status changes to "Completed" | | | |

Post-Condition: Survey is saved; certificate becomes available for viewing and download.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
View Certificate of Participation
Test Case ID: YV-CERT2
Test Designed by: Brian Louis B. Ralleta
Test Priority: Medium
Test Designed date: December 15, 2025
Function Name: Certificates - View Certificate
Test Executed by:
Test Title: View Certificate of Participation After Survey Completion
Test Execution date:
Description: Verify that a Youth Volunteer can view their certificate of participation after completing the satisfaction survey for a completed project.

Pre-Condition: Logged in as Youth Volunteer; satisfaction survey has been completed for a project; certificate is generated.
Dependencies: Certificate generation is functional; survey is completed.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Navigate to the Certificates page | | Certificates page shows the project with a "View Certificate" option (survey completed) | | | |
| 2 | Click "View Certificate" for the completed project | Community Clean-Up Drive | Certificate preview opens showing a formatted certificate of participation | | | |
| 3 | Verify certificate details | | Certificate displays the correct volunteer name, project name, project dates, and certificate date | | | |

Post-Condition: Certificate is displayed correctly with accurate information.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Download Certificate as PDF
Test Case ID: YV-CERT3
Test Designed by: Brian Louis B. Ralleta
Test Priority: Medium
Test Designed date: December 15, 2025
Function Name: Certificates - Download PDF
Test Executed by:
Test Title: Download Certificate of Participation as PDF
Test Execution date:
Description: Verify that a Youth Volunteer can download their certificate as a PDF file.

Pre-Condition: Logged in as Youth Volunteer; certificate is viewable (survey completed).
Dependencies: PDF generation is functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | View a certificate for a completed project | Community Clean-Up Drive | Certificate preview is displayed | | | |
| 2 | Click the "Download PDF" button | | Browser initiates download of a PDF file | | | |
| 3 | Open the downloaded PDF file | | PDF displays a properly formatted certificate of participation with correct volunteer name, project name, dates, and layout matching the preview | | | |

Post-Condition: A PDF certificate file is saved to the user's device.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Zoom/Preview Controls for Certificate
Test Case ID: YV-CERT4
Test Designed by: Brian Louis B. Ralleta
Test Priority: Low
Test Designed date: December 15, 2025
Function Name: Certificates - Zoom Controls
Test Executed by:
Test Title: Zoom and Preview Controls for Certificate
Test Execution date:
Description: Verify that zoom controls work correctly when previewing a certificate.

Pre-Condition: Logged in as Youth Volunteer; certificate preview is open.
Dependencies: Zoom control functionality is implemented.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Open a certificate preview | Community Clean-Up Drive | Certificate displays at default zoom level | | | |
| 2 | Click the "Zoom In" button | | Certificate scales up, showing more detail; text remains readable | | | |
| 3 | Click the "Zoom In" button again | | Certificate scales up further | | | |
| 4 | Click the "Zoom Out" button | | Certificate scales down to a smaller view | | | |
| 5 | Verify the certificate returns to readable state | | Certificate is properly rendered at the current zoom level without distortion | | | |

Post-Condition: Zoom controls work bidirectionally; certificate remains properly rendered at all zoom levels.
