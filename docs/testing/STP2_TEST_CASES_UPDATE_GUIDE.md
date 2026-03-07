# STP-2 Test Cases - Update Guide

**Reference:** `STP1_FUNCTIONS_UPDATED.txt` (120 test items)
**Source PDF:** SE1 ICS26010 - GROUP 4 - STP-2 - ALL THE TEST CASES (78 pages)
**Date:** March 3, 2026

---

## Table of Contents

1. [Inventory of Existing Test Cases](#1-inventory-of-existing-test-cases)
2. [Issues in Existing Test Cases (Needs Updating)](#2-issues-in-existing-test-cases-needs-updating)
3. [New Test Cases Needed](#3-new-test-cases-needed)
4. [Coverage Summary](#4-coverage-summary)

---

## 1. Inventory of Existing Test Cases

### LOGIN (7 test cases, Pages 1-8)

| Test Case ID | Title | STP-1 Item # | Status |
|---|---|---|---|
| LOG-1 | Successful Login with Valid Credentials | #1 | OK |
| LOG-2 | Failed Login with Incorrect Email | #2 | OK |
| LOG-3 | Failed Login with Incorrect Password | #3 | OK |
| LOG-3 (DUPLICATE ID) | Login with Google Account | #6 | **NEEDS FIX** - Duplicate ID, should be LOG-4 |
| LOG-8 | Successful Password Reset | #7 | **NEEDS UPDATE** - Uses old email link flow, now OTP |
| LOG-8 (DUPLICATE ID) | Unsuccessful Password Reset (Unequal Password) | #9 | **NEEDS FIX** - Duplicate ID + update to OTP flow |
| LOG-8 (DUPLICATE ID) | Unsuccessful Password Reset (Non-existent email) | #8 | **NEEDS FIX** - Duplicate ID |

### FILE - SK OFFICIAL (8 test cases, Pages 9-16)

| Test Case ID | Title | STP-1 Item # | Status |
|---|---|---|---|
| AD-F1 | Upload file below 10MB | #17 | OK |
| AD-F2 | Upload file exceeding size limit | #18 | OK |
| AD-F3 | Submit upload form with empty fields | Extra | OK (keep, good coverage) |
| AD-F4 | Viewing Files / Preview | #24 | OK |
| AD-F5 | Deleting Files | #20 | OK |
| AD-F6 | Searching Files | #22 | OK |
| AD-F7 | Filter Files by Category | #23 | OK |
| AD-F8 | Uploading Invalid Files | #19 | OK |

### FILE - YOUTH VOLUNTEER (3 test cases, Pages 17-19)

| Test Case ID | Title | STP-1 Item # | Status |
|---|---|---|---|
| YV-F1 | Viewing Files | #29 (partial) | OK |
| YV-F2 | Searching Files | #29 (partial) | OK |
| YV-F3 | Filtering Files | #29 (partial) | OK |

### CONTENT - SK OFFICIAL (5 test cases, Pages 20-24)

| Test Case ID | Title | STP-1 Item # | Status |
|---|---|---|---|
| AD-C1 | Create Announcement | #30 | OK |
| AD-C2 | View Announcement | #35 | OK |
| AD-C3 | Delete Announcement | #34 | OK |
| AD-C4 | Edit Announcement | #32 | OK |
| AD-C5 | Save without changes | Extra | OK (keep, good edge case) |

### CONTENT - YOUTH VOLUNTEER (1 test case, Page 25)

| Test Case ID | Title | STP-1 Item # | Status |
|---|---|---|---|
| YV-C1 | Viewing Announcements | #38 | OK |

### PROJECT - SK OFFICIAL (10 test cases, Pages 26-36)

| Test Case ID | Title | STP-1 Item # | Status |
|---|---|---|---|
| SK-P1 | Creating New Project | #39 | OK |
| SK-P2 | Creating Project Missing Title | Extra | OK (keep, good validation test) |
| SK-P3 | Viewing Projects | #41 | OK |
| SK-P4 | Viewing Project Applicants | #57 | OK |
| SK-P5 | Approving Project Applicants | #58 | OK |
| SK-P6 | Viewing/Replying to Inquiries | #49 | OK |
| SK-P7 | Search Projects | #42 | OK |
| SK-P8 | Filter Projects | #43 | OK |
| SK-P9 | Edit Project | #40 | OK |
| SK-P10 | Delete Project | #44 | OK |

### PROJECT - YOUTH VOLUNTEER (8 test cases, Pages 37-46)

| Test Case ID | Title | STP-1 Item # | Status |
|---|---|---|---|
| YV-P1 | Viewing Project | #41 (YV perspective) | OK |
| YV-P2 | Project Inquiry Reply | #50 | OK |
| YV-P3 | Search Projects | #42 (YV perspective) | OK |
| YV-P4 | Filter Projects | #43 (YV perspective) | OK |
| YV-P5 | Project Application (Apply) | #52 | OK |
| YV-P6 (first) | Application Missing Last Name | Extra | OK (keep, validation) |
| YV-P6 (DUPLICATE ID) | Application Missing Consent Form | #53 (negative) | **NEEDS FIX** - Duplicate ID |
| YV-P7 | Edit Application | #54 | OK |

### CALENDAR - SK OFFICIAL (3 test cases, Pages 46-50)

| Test Case ID | Title | STP-1 Item # | Status |
|---|---|---|---|
| AD-CAL1 | Send Event Notification | Extra | OK (keep, system feature) |
| AD-CAL2 | View Calendar Dashboard | #77, #78, #79 | **NOTE** - Week view failed during testing |
| AD-CAL1 (DUPLICATE ID) | Send Notification Missing Message | Extra | **NEEDS FIX** - Duplicate ID |

### CALENDAR - YOUTH VOLUNTEER (1 test case, Page 51)

| Test Case ID | Title | STP-1 Item # | Status |
|---|---|---|---|
| YV-CAL1 | Viewing Calendar | #77 | OK |

### TESTIMONIES - SK OFFICIAL (5 test cases, Pages 52-57)

| Test Case ID | Title | STP-1 Item # | Status |
|---|---|---|---|
| SK-T1 | View Testimony Details | #84 | OK |
| SK-T2 | Delete Testimony | Extra | OK (keep) |
| SK-T3 | Feature Testimony | #86 | OK |
| SK-T4 | Unfeature Testimony | #87 | OK |
| SK-T5 | Search Testimonies | #85 | OK |

### ARCHIVE - SK OFFICIAL (5 test cases, Pages 58-64)

| Test Case ID | Title | STP-1 Item # | Status |
|---|---|---|---|
| SK-ARC1 | View archive statistics overview | #92 | OK |
| SK-ARC2 | Search/filter by year and quarter | #94 | OK |
| SK-ARC3 | Select and download bulk reports | #95 | OK |
| SK-ARC4 | View archived project details + download | #92, #95 | OK |
| SK-ARC5 | Permanently delete archived project | Extra | OK (keep) |

### HOMEPAGE (20 test cases, Pages 64-78)

| Test Case ID | Title | STP-1 Item # | Status |
|---|---|---|---|
| HP-N1 | Header - Home | Extra | OK |
| HP-N2 | Header - Features | Extra | OK |
| HP-N3 | Header - Projects | Extra | OK |
| HP-N4 | Header - Testimonials | Extra | OK |
| HP-N5 | Header - Transparency | Extra | OK |
| HP-N6 | Header - Login Redirect | Extra | OK |
| HP-N7 | Header - Sign Up Redirect | Extra | OK |
| HP-N8 | Home Section - Join as Volunteer | Extra | OK |
| HP-N9 | Home Section - Browse Projects | Extra | OK |
| HP-N10 | Projects Section - Filtering | Extra | OK |
| HP-N11 | Testimonials Section - Carousel | Extra | OK |
| HP-N12 | Transparency Section - File Download | Extra | OK |
| HP-N13 | CTA - View Transparency Report | Extra | OK |
| HP-N14 | CTA - Login Redirect | Extra | OK |
| HP-N15 | CTA - Sign Up Redirect | Extra | OK |
| HP-N16 | Footer - Home | Extra | OK |
| HP-N2 (DUPLICATE) | Footer - Features | Extra | **NEEDS FIX** - Duplicate ID |
| HP-N3 (DUPLICATE) | Footer - Projects | Extra | **NEEDS FIX** - Duplicate ID |
| HP-N4 (DUPLICATE) | Footer - Testimonials | Extra | **NEEDS FIX** - Duplicate ID |
| HP-N5 (DUPLICATE) | Footer - Transparency | Extra | **NEEDS FIX** - Duplicate ID |

---

## 2. Issues in Existing Test Cases (Needs Updating)

### CRITICAL: Duplicate Test Case IDs to Fix

| Current ID | Test Case Title | Suggested New ID |
|---|---|---|
| LOG-3 (2nd) | Login with Google Account | **LOG-4** |
| LOG-8 (2nd) | Unsuccessful Password Reset (Unequal Password) | **LOG-5** |
| LOG-8 (3rd) | Unsuccessful Password Reset (Non-existent email) | **LOG-6** |
| YV-P6 (2nd) | Application Missing Consent Form | **YV-P8** (rename current YV-P8 to YV-P9) |
| AD-CAL1 (2nd) | Send Notification Missing Message | **AD-CAL3** |
| HP-N2 (footer) | Footer - Features | **HP-F2** |
| HP-N3 (footer) | Footer - Projects | **HP-F3** |
| HP-N4 (footer) | Footer - Testimonials | **HP-F4** |
| HP-N5 (footer) | Footer - Transparency | **HP-F5** |

### CRITICAL: Password Reset Test Cases Need OTP Flow Update

The system's forgot password flow was changed from **email link** to **OTP verification**. The following test cases reference the old flow and must be updated:

**LOG-8 (Successful Password Reset)** - Currently says:
- Step 2: "click Send Reset Link" / "receives email with link attached"
- Step 3: "Open email inbox and click the password reset link"

**Should be updated to:**
- Step 2: Enter registered email, click "Send OTP" → System sends 6-digit OTP to email
- Step 3: Enter the 6-digit OTP code in the verification fields
- Step 4: OTP is validated, user sees New Password form
- Step 5: Enter new password + confirm password
- Step 6: Click Reset Password → success, redirect to login

**LOG-5 (Unsuccessful Password Reset - Unequal Password)** - Same OTP flow update needed.

**LOG-6 (Unsuccessful Password Reset - Non-existent email)** - Update:
- Step 2: Enter non-registered email → System shows generic message "If an active account exists with this email, a verification code has been sent"
- Remove steps about checking email inbox for link

### MINOR: Pre-Condition Wording Fixes

| Test Case | Issue | Fix |
|---|---|---|
| AD-F1 | Says "Logged in as SK volunteer" | Should be "Logged in as SK Official" |
| AD-F2 | Says "Logged in as SK volunteer" | Should be "Logged in as SK Official" |
| AD-F3 | Says "Logged in as an SK volunteer" | Should be "Logged in as SK Official" |
| YV-P5 | Title says "SK Officials Applying" | Should be "Youth Volunteers Applying" |
| YV-P6 | Title says "SK Officials Applying" | Should be "Youth Volunteers Applying" |
| YV-P7 | Title says "SK Officials Applying" | Should be "Youth Volunteers Applying" |

---

## 3. New Test Cases Needed

### FUNCTION 1: LOGIN / AUTHENTICATION (9 new test cases)

| Suggested ID | STP-1 # | Test Case Title | Priority | Description |
|---|---|---|---|---|
| **LOG-7** | #4 | Sign up with complete details | High | Verify new user can register with valid first name, last name, email, password (meeting complexity: 8+ chars, upper, lower, number, special), confirm password, and accept Terms. User is redirected to OTP verification. |
| **LOG-8** | #5 | Sign up with missing or invalid details | High | Verify system rejects signup when fields are missing or invalid (short name, bad email format, weak password, mismatched confirm password, unchecked Terms). |
| **LOG-9** | #10 | Valid OTP verification | High | After signup, enter correct 6-digit OTP within 10 minutes. Account is verified and user is redirected to complete-profile or login page. |
| **LOG-10** | #11 | Invalid OTP verification | High | Enter incorrect 6-digit OTP code. System shows error message, user remains on OTP page. |
| **LOG-11** | #12 | Expired OTP (after 10-minute timer) | Medium | Wait for the 10-minute countdown to reach 0:00. Verify the Verify button becomes disabled and system shows expiration message. |
| **LOG-12** | #13 | Resend OTP with 60-second cooldown | Medium | Click "Resend" link. Verify new code is sent, 60-second cooldown timer appears on button, and button is disabled during cooldown. |
| **LOG-13** | #14 | Complete Profile after first login | High | After first login (email/password or Google), verify redirect to complete-profile page. Fill in birthday, contact number (09xxxxxxxxx), gender, address. Verify redirect to dashboard after completion. |
| **LOG-14** | #15 | Account lockout after 5 failed login attempts | Medium | Attempt login with wrong password 5 times. Verify system locks account for 15 minutes and displays lockout message with remaining time. |
| **LOG-15** | #16 | Login with inactive/deactivated account | Medium | Attempt login with an account that has been deactivated by Superadmin. System shows error message and prevents access. |

> **Note:** Since existing LOG-8 IDs need renumbering (see Section 2), the new signup/OTP test cases start from LOG-7. Alternatively, renumber existing password reset tests first, then add new ones sequentially.

### FUNCTION 2: MANAGE FILES (4 new test cases)

| Suggested ID | STP-1 # | Test Case Title | Priority | Description |
|---|---|---|---|---|
| **AD-F9** | #25 | Publish file to homepage transparency | High | On sk-files page, click the star icon on an unpublished file. Confirm the publish modal ("This will make the file visible to the public"). Verify star becomes filled and file appears in homepage Transparency section. |
| **AD-F10** | #26 | Unpublish file from homepage | Medium | Click the filled star icon on a published file. Verify star becomes empty, toast says "File removed from homepage", and file is removed from homepage Transparency section. |
| **AD-F11** | #27 | Archive file with confirmation | High | Click the "Archive" button on a file card. Confirm in the modal ("You can restore it from the Archive page"). Verify file disappears from active list. |
| **AD-F12** | #28 | Restore archived file | Medium | Go to sk-archive.html, find archived file, click "Restore". Confirm in modal. Verify file returns to active status in sk-files.html. |

### FUNCTION 3: MANAGE CONTENT (4 new test cases)

| Suggested ID | STP-1 # | Test Case Title | Priority | Description |
|---|---|---|---|---|
| **AD-C6** | #31 | Create announcement with image upload (16:9 cropper) | Medium | Create announcement and upload an image. Verify cropper modal opens with 16:9 aspect ratio. Crop and confirm. Verify image appears in announcement card after posting. |
| **AD-C7** | #33 | Edit announcement image | Medium | Edit an existing announcement, upload a new image via cropper. Save. Verify the announcement card displays the updated image. |
| **AD-C8** | #36 | Announcement pagination | Low | With more than 3 announcements, verify pagination dots appear. Click next/prev arrows and pagination dots. Verify correct announcements display per page (3 per page). |
| **CAP-C1** | #37 | View announcements as Captain (read-only) | Low | Login as Captain. Verify announcements display on captain-dashboard.html. Verify NO create/edit/delete buttons are visible. Can only view details in modal. |

### FUNCTION 4A: PROJECT MANAGEMENT - SK (3 new test cases)

| Suggested ID | STP-1 # | Test Case Title | Priority | Description |
|---|---|---|---|---|
| **SK-P11** | #45 | Submit project for Captain approval | High | On sk-projects page, click "Submit for Approval" on a project. Verify confirmation dialog. After confirming, project status changes to "Pending Approval" and Captain receives notification. |
| **SK-P12** | #46 | Cancel project approval request | Medium | On a project with "Pending Approval" status, click "Cancel Approval". Confirm in modal. Verify status reverts and project is editable again. |
| **SK-P13** | #47 | Resubmit project after revision request | Medium | After Captain requests revision, edit the project details and resubmit for approval. Verify status changes back to "Pending Approval". |

### FUNCTION 4B: PROJECT INQUIRIES (1 new test case)

| Suggested ID | STP-1 # | Test Case Title | Priority | Description |
|---|---|---|---|---|
| **YV-P9** | #48 | Submit new project inquiry | Medium | On youth-projects page, open a project, go to Inquiries tab, click "Send Inquiry". Type message and submit. Verify inquiry appears in thread with timestamp. SK Official receives notification. |

> Note: YV-P2 already covers replying to inquiries. This new case covers the INITIAL inquiry submission.

### FUNCTION 4C: VOLUNTEER APPLICATION (1 new test case)

| Suggested ID | STP-1 # | Test Case Title | Priority | Description |
|---|---|---|---|---|
| **YV-P10** | #55 | Track application status | Low | After applying to a project, go to "My Applications" section. Verify application card shows correct status badge (Pending Review / Accepted / Rejected) with color coding. |

### FUNCTION 4D: APPLICATION MANAGEMENT - SK (2 new test cases)

| Suggested ID | STP-1 # | Test Case Title | Priority | Description |
|---|---|---|---|---|
| **SK-P14** | #59 | Revert application to pending status | Medium | In applicants tab, select an Accepted or Rejected applicant. Click revert to pending. Verify status badge changes back to "Pending Review". |
| **SK-P15** | #60 | Toggle attendance for applicants | Medium | In applicants tab, check the attendance checkbox for an accepted applicant. Verify attendance is recorded. Uncheck and verify it's removed. |

### FUNCTION 4E: PROJECT APPROVAL - CAPTAIN (7 new test cases)

| Suggested ID | STP-1 # | Test Case Title | Priority | Description |
|---|---|---|---|---|
| **CAP-P1** | #62 | View pending projects for approval | High | Login as Captain. On captain-dashboard, verify the Pending Approval tab shows projects submitted by SK Officials with correct count badge. |
| **CAP-P2** | #63 | Approve project with optional notes | High | Open a pending project. Type optional approval notes. Click "Approve". Confirm in dialog. Verify project moves to Approved tab, SK Official receives notification, and success toast appears. |
| **CAP-P3** | #64 | Reject project with required reason | High | Open a pending project. Click "Reject" without entering a reason. Verify system requires a reason. Enter reason, click Reject, confirm. Verify project moves to Rejected tab. |
| **CAP-P4** | #65 | Request project revision with required details | High | Open a pending project. Click "Request Revision" without details. Verify system requires details. Enter revision notes, confirm. Verify status changes to Revision. |
| **CAP-P5** | #66 | Confirmation dialog before approval actions | Medium | For each action (approve, reject, revision), verify a confirmation dialog appears before the action is finalized. Verify clicking Cancel aborts the action. |
| **CAP-P6** | #67 | View approved projects tab | Low | Click the Approved tab. Verify it shows all previously approved projects with correct count, approval date, and notes. |
| **CAP-P7** | #68 | View rejected projects tab | Low | Click the Rejected tab. Verify it shows all previously rejected projects with correct count, rejection reason, and date. |

### FUNCTION 4F: PROJECT EVALUATION & REPORTING (8 new test cases)

| Suggested ID | STP-1 # | Test Case Title | Priority | Description |
|---|---|---|---|---|
| **SK-P16** | #69 | Submit project evaluation (5 weighted criteria) | High | Open evaluation modal for a project. Rate all 5 criteria (Budget Efficiency 25%, Volunteer Participation 20%, Timeline Adherence 20%, Community Impact 20%, Volunteer Feedback 15%). Submit. Verify success. |
| **SK-P17** | #70 | Upload receipts for budget breakdown | Medium | In evaluation modal, add actual budget breakdown items. Upload receipt images for each item (within 5MB). Verify receipts display correctly. |
| **SK-P18** | #71 | Generate attendance sheet PDF | Medium | Click "Generate Attendance PDF". Verify a PDF file is downloaded containing the list of applicants with attendance status. |
| **SK-P19** | #72 | Add project achievements | Low | In evaluation modal, add achievements using quick buttons (Environmental Impact, Community Benefit, etc.) and custom achievements. Verify they appear in the list. |
| **SK-P20** | #73 | Download project report (PDF) | Medium | Click "Download Report" and select PDF format. Verify a complete PDF report is downloaded with project details, evaluation, budget, and volunteer info. |
| **SK-P21** | #74 | Download project report (Excel) | Medium | Click "Download Report" and select Excel format. Verify an Excel file is downloaded with project data. |
| **SK-P22** | #75 | Start project (change status) | Medium | Click "Start Project" on an approved project. Verify project status changes and start date is recorded. |
| **SK-P23** | #76 | Archive completed project | Medium | After evaluation is complete, click "Archive Project". Verify project moves to Archives section with evaluation data preserved. |

### FUNCTION 5: CALENDAR (3 new test cases)

| Suggested ID | STP-1 # | Test Case Title | Priority | Description |
|---|---|---|---|---|
| **AD-CAL4** | #80 | Export event to Google Calendar | Low | Click on a calendar event, click "Export to Google Calendar". Verify Google Calendar opens with event details pre-filled. |
| **AD-CAL5** | #81 | Export event to Outlook | Low | Click on a calendar event, click "Export to Outlook". Verify an .ics or calendar invite is generated for Outlook. |
| **AD-CAL6** | #82 | Export event to iCal | Low | Click on a calendar event, click "Export to iCal". Verify an .ics file is downloaded with correct event details. |

### FUNCTION 6: TESTIMONIES (1 new test case)

| Suggested ID | STP-1 # | Test Case Title | Priority | Description |
|---|---|---|---|---|
| **YV-T1** | #83 | Submit testimony with star rating (Youth) | High | Login as Youth Volunteer who attended a completed project. Navigate to submit testimony. Select star rating (1-5), write testimony text. Submit. Verify success message and testimony appears in SK's testimonies page. |

### FUNCTION 7: CERTIFICATES (4 new test cases)

| Suggested ID | STP-1 # | Test Case Title | Priority | Description |
|---|---|---|---|---|
| **YV-CERT1** | #88 | Complete satisfaction survey after project | High | Login as Youth Volunteer. Navigate to youth-certificates.html. Select a completed project. Fill in satisfaction survey questions. Submit. Verify success. |
| **YV-CERT2** | #89 | View certificate of participation | Medium | After survey completion, verify certificate of participation is viewable in the certificates page with correct volunteer name, project name, and date. |
| **YV-CERT3** | #90 | Download certificate as PDF | Medium | Click "Download PDF" button on the certificate. Verify a properly formatted PDF certificate is downloaded to local device. |
| **YV-CERT4** | #91 | Zoom/preview controls for certificate | Low | Use zoom in/out controls on the certificate preview. Verify certificate scales properly and remains readable. |

### FUNCTION 8: ARCHIVES (2 new test cases)

| Suggested ID | STP-1 # | Test Case Title | Priority | Description |
|---|---|---|---|---|
| **SK-ARC6** | #93 | View archived files | Medium | Navigate to sk-archive.html. Switch to "Archived Files" tab. Verify archived files display with file name, upload date, file type, uploader, and file size. |
| **SK-ARC7** | #96 | Restore archived file to active status | Medium | On archived files tab, click "Restore" on a file. Confirm in modal. Verify file status changes from ARCHIVED to ACTIVE and file reappears in sk-files.html. |

### FUNCTION 9: USER MANAGEMENT - SUPERADMIN (9 new test cases)

| Suggested ID | STP-1 # | Test Case Title | Priority | Description |
|---|---|---|---|---|
| **SA-U1** | #97 | View all registered users | High | Login as Superadmin. Navigate to user management. Verify all users display with name, email, role, status, and joined date. |
| **SA-U2** | #98 | Search users by name or email | Medium | Type a name or email in search field. Verify list filters to show only matching users. |
| **SA-U3** | #99 | Filter users by role and status | Medium | Use role dropdown and status dropdown to filter. Verify list updates to show only users matching selected criteria. |
| **SA-U4** | #100 | Promote Youth to SK Official | High | Select a Youth Volunteer. Click promote. Choose SK position (e.g., Kagawad) and set term dates. Confirm. Verify role changes. |
| **SA-U5** | #101 | Promote user to Barangay Captain | High | Select a user. Click promote to Captain. Verify system handles existing Captain succession. Confirm. Verify role changes. |
| **SA-U6** | #102 | Enforce position limits | High | Try to promote a user to Chairman when one already exists. Verify system rejects with message about position already filled. Test for Secretary, Treasurer, and max 7 Kagawads. |
| **SA-U7** | #103 | Demote SK Official or Captain | Medium | Select an SK Official or Captain. Click demote. Confirm with checkbox. Verify role reverts to Youth Volunteer. |
| **SA-U8** | #104 | Deactivate user account | High | Select an active user. Click deactivate. Enter reason. Confirm. Verify account status changes to INACTIVE and user cannot login. |
| **SA-U9** | #105 | Reactivate deactivated account | Medium | Select an inactive user. Click reactivate. Confirm. Verify account status changes to ACTIVE and user can login again. |

### FUNCTION 10: ACTIVITY LOGS & AUDIT - SUPERADMIN (5 new test cases)

| Suggested ID | STP-1 # | Test Case Title | Priority | Description |
|---|---|---|---|---|
| **SA-L1** | #106 | View all activity logs | Medium | Navigate to activity logs. Verify logs display with user name, action, and timestamp in chronological order. |
| **SA-L2** | #107 | Filter activity logs by date | Low | Select a date range. Verify only logs within that range are displayed. |
| **SA-L3** | #108 | View audit trail | Medium | Click audit trail tab. Verify critical changes (role changes, promotions, demotions, status changes) are listed clearly. |
| **SA-L4** | #109 | View database statistics | Low | Click database stats tab. Verify record counts for all system tables display correctly. |
| **SA-L5** | #110 | View storage buckets | Low | Click storage section. Verify all configured buckets (general-files, project-files, consent-forms, etc.) are listed. |

### FUNCTION 11: NOTIFICATIONS (4 new test cases)

| Suggested ID | STP-1 # | Test Case Title | Priority | Description |
|---|---|---|---|---|
| **NTF-1** | #111 | Receive notification for relevant updates | Medium | Perform an action that triggers a notification (e.g., submit project for approval). Login as target user. Verify notification appears. |
| **NTF-2** | #112 | View notification bell with unread count | Low | Verify the header notification bell shows the correct unread count. Open notification modal. Verify list of notifications with timestamps. |
| **NTF-3** | #113 | Mark notifications as read | Low | Click on unread notifications. Verify they are marked as read and unread count decreases. |
| **NTF-4** | #114 | Click notification to navigate | Medium | Click a notification. Verify the system navigates to the relevant section (e.g., project details, application). |

### FUNCTION 12: PROFILE MANAGEMENT (3 new test cases)

| Suggested ID | STP-1 # | Test Case Title | Priority | Description |
|---|---|---|---|---|
| **PRF-1** | #115 | View and update profile information | Medium | Open profile modal from dashboard. Update name, address, contact number. Save. Verify changes are reflected in header and profile. |
| **PRF-2** | #116 | Change password from dashboard | Medium | Open change password modal. Enter current password, new password (meeting complexity), confirm. Submit. Verify success. Logout and login with new password. |
| **PRF-3** | #117 | Upload/change profile picture | Low | In profile modal, upload a new profile picture. Verify it displays in the header avatar and profile modal. |

### FUNCTION 13: DASHBOARD (3 new test cases)

| Suggested ID | STP-1 # | Test Case Title | Priority | Description |
|---|---|---|---|---|
| **DSH-1** | #118 | View dashboard statistics per role | Medium | Login as each role (SK, Youth, Captain, Superadmin). Verify dashboard shows correct role-specific statistics (file count, project count, volunteer count, etc.). |
| **DSH-2** | #119 | Pages and modals load without noticeable delays | Low | Navigate through all main pages and open key modals. Verify loading is smooth with no errors or excessive delay. |
| **DSH-3** | #120 | Role-based redirect after login | Medium | Login as each role. Verify redirect goes to correct dashboard (SK → sk-dashboard, Youth → youth-dashboard, Captain → captain-dashboard, Superadmin → superadmin-dashboard). |

---

## 4. Coverage Summary

### Existing vs New Test Cases

| Category | Existing | New Needed | Total After Update |
|---|---|---|---|
| Login / Authentication | 7 | 9 | 16 |
| File Management - SK | 8 | 4 | 12 |
| File Management - YV | 3 | 0 | 3 |
| Content Management - SK | 5 | 4 | 9 |
| Content Management - YV | 1 | 0 | 1 |
| Content Management - Captain | 0 | 1 | 1 |
| Project Monitoring - SK | 10 | 11 | 21 |
| Project Monitoring - YV | 8 | 2 | 10 |
| Project Approval - Captain | 0 | 7 | 7 |
| Calendar - SK | 3 | 3 | 6 |
| Calendar - YV | 1 | 0 | 1 |
| Testimonies - SK | 5 | 0 | 5 |
| Testimonies - YV | 0 | 1 | 1 |
| Certificates - YV | 0 | 4 | 4 |
| Archives - SK | 5 | 2 | 7 |
| User Management - SA | 0 | 9 | 9 |
| Activity Logs - SA | 0 | 5 | 5 |
| Notifications | 0 | 4 | 4 |
| Profile Management | 0 | 3 | 3 |
| Dashboard | 0 | 3 | 3 |
| Homepage | 20 | 0 | 20 |
| **TOTAL** | **76** | **72** | **148** |

### Action Items Checklist

- [ ] Fix 9 duplicate test case IDs (see Section 2)
- [ ] Update 3 password reset test cases to OTP flow (see Section 2)
- [ ] Fix 6 pre-condition wording issues (see Section 2)
- [ ] Create 9 new Login/Auth test cases
- [ ] Create 4 new File Management test cases
- [ ] Create 4 new Content Management test cases
- [ ] Create 3 new SK Project Management test cases
- [ ] Create 3 new YV Project test cases
- [ ] Create 7 new Captain Project Approval test cases
- [ ] Create 8 new Project Evaluation test cases
- [ ] Create 3 new Calendar export test cases
- [ ] Create 1 new Youth Testimony test case
- [ ] Create 4 new Certificate test cases
- [ ] Create 2 new Archive test cases
- [ ] Create 9 new Superadmin User Management test cases
- [ ] Create 5 new Superadmin Activity Log test cases
- [ ] Create 4 new Notification test cases
- [ ] Create 3 new Profile Management test cases
- [ ] Create 3 new Dashboard test cases
