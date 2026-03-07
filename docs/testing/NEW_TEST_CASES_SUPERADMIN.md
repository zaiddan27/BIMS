# NEW TEST CASES - SUPERADMIN (USER MANAGEMENT & ACTIVITY LOGS)

---

## USER MANAGEMENT

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
View All Registered Users
Test Case ID: SA-U1
Test Designed by: JC Ledonio
Test Priority: High
Test Designed date: December 15, 2025
Function Name: User Management - View Users
Test Executed by:
Test Title: View All Registered Users with Roles and Status
Test Execution date:
Description: Verify that the Superadmin can view all registered users with their roles, account status, and joined date.

Pre-Condition: Logged in as Superadmin and on the Superadmin Dashboard; multiple users exist in the system with various roles and statuses.
Dependencies: User_Tbl contains user records; superadmin-dashboard.html is functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Navigate to the User Management section on the Superadmin Dashboard | | User management panel loads displaying a list/table of all registered users | | | |
| 2 | Verify user details are displayed | | Each user row shows: Name, Email, Role (Youth Volunteer/SK Official/Captain/Superadmin), Account Status (Active/Inactive), and Joined Date | | | |
| 3 | Verify the total user count is accurate | | Dashboard statistics show correct counts for total users, active users, pending accounts, and deactivated users | | | |

Post-Condition: Superadmin can view the complete user list; no data is changed.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Search Users by Name or Email
Test Case ID: SA-U2
Test Designed by: JC Ledonio
Test Priority: Medium
Test Designed date: December 15, 2025
Function Name: User Management - Search Users
Test Executed by:
Test Title: Search Users by Name or Email
Test Execution date:
Description: Verify that the Superadmin can search for users by name or email with accurate results.

Pre-Condition: Logged in as Superadmin; multiple users exist.
Dependencies: Search functionality is implemented.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Click on the search field in the user management section | | Cursor appears in search input | | | |
| 2 | Type a user's name | Search: "Juan" | User list filters to show only users whose names contain "Juan" | | | |
| 3 | Clear the search and type an email | Search: "testsk1@bims.test" | User list filters to show only the user matching that email | | | |
| 4 | Type a search term that matches no users | Search: "NonExistentUser999" | User list shows empty state or "No users found" message | | | |
| 5 | Clear the search field | | Full user list is restored | | | |

Post-Condition: Search correctly filters users; clearing the search restores the full list.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Filter Users by Role and Account Status
Test Case ID: SA-U3
Test Designed by: JC Ledonio
Test Priority: Medium
Test Designed date: December 15, 2025
Function Name: User Management - Filter Users
Test Executed by:
Test Title: Filter Users by Role and Account Status
Test Execution date:
Description: Verify that the Superadmin can filter the user list by role and account status.

Pre-Condition: Logged in as Superadmin; users with various roles and statuses exist.
Dependencies: Filter dropdowns are functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Click the Role filter dropdown | | Dropdown shows role options (All, Youth Volunteer, SK Official, Captain, Superadmin) | | | |
| 2 | Select "SK Official" | Role filter: SK Official | User list shows only users with SK Official role | | | |
| 3 | Click the Status filter dropdown | | Dropdown shows status options (All, Active, Inactive) | | | |
| 4 | Select "Active" with SK Official role filter still applied | Status filter: Active | User list shows only active SK Officials | | | |
| 5 | Reset both filters to "All" | | Full user list is restored | | | |

Post-Condition: Filters correctly narrow the user list; resetting shows all users.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Promote Youth Volunteer to SK Official
Test Case ID: SA-U4
Test Designed by: JC Ledonio
Test Priority: High
Test Designed date: December 15, 2025
Function Name: User Management - Promote to SK Official
Test Executed by:
Test Title: Promote Youth Volunteer to SK Official
Test Execution date:
Description: Verify that the Superadmin can promote a Youth Volunteer to SK Official by selecting a position and setting term dates.

Pre-Condition: Logged in as Superadmin; at least one Youth Volunteer exists; the target position is not yet filled (or has not reached max count).
Dependencies: Promotion functionality is operational; SK_Tbl is functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Locate a Youth Volunteer in the user list | Juan Dela Cruz (Youth Volunteer) | User is visible with role "Youth Volunteer" | | | |
| 2 | Click the promote/action button for the user | | Promotion modal or dialog opens showing position selection and term date fields | | | |
| 3 | Select an SK position | Position: Kagawad | Position is selected from the dropdown | | | |
| 4 | Set term start and end dates | Start: January 1, 2026, End: December 31, 2028 | Dates are accepted | | | |
| 5 | Confirm the promotion (with checkbox confirmation if required) | | System updates the user's role to SK_OFFICIAL; creates record in SK_Tbl; success toast appears; user list shows updated role | | | |

Post-Condition: User role is changed to SK Official; SK_Tbl entry is created with position and term dates.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Promote User to Barangay Captain
Test Case ID: SA-U5
Test Designed by: JC Ledonio
Test Priority: High
Test Designed date: December 15, 2025
Function Name: User Management - Promote to Captain
Test Executed by:
Test Title: Promote User to Barangay Captain
Test Execution date:
Description: Verify that the Superadmin can promote a user to Barangay Captain with proper succession handling.

Pre-Condition: Logged in as Superadmin; a user eligible for promotion exists.
Dependencies: Captain succession logic is implemented.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Locate a user to promote to Captain | Maria Santos (SK Official or Youth Volunteer) | User is visible in the list | | | |
| 2 | Click the promote to Captain action | | Promotion dialog opens; if a Captain already exists, the system shows a warning about Captain succession | | | |
| 3 | Confirm the promotion | | System handles existing Captain (demotes to previous role if applicable); promotes the selected user to CAPTAIN role; success toast appears | | | |
| 4 | Verify the user list reflects the change | | The promoted user now shows "Captain" role; the previous Captain (if any) shows their new role | | | |

Post-Condition: The promoted user is now Barangay Captain; previous Captain succession is handled properly.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Enforce Position Limits
Test Case ID: SA-U6
Test Designed by: JC Ledonio
Test Priority: High
Test Designed date: December 15, 2025
Function Name: User Management - Position Limits
Test Executed by:
Test Title: Enforce SK Position Limits (1 Chairman, 1 Secretary, 1 Treasurer, Max 7 Kagawads)
Test Execution date:
Description: Verify that the system enforces position limits when promoting users to SK Official positions.

Pre-Condition: Logged in as Superadmin; SK positions are partially filled (e.g., Chairman position is already taken).
Dependencies: Position validation logic is implemented.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Attempt to promote a Youth Volunteer to "Chairman" when one already exists | Position: Chairman (already filled) | System displays an error message indicating the Chairman position is already filled; promotion is blocked | | | |
| 2 | Attempt to promote a Youth Volunteer to "Secretary" when one already exists | Position: Secretary (already filled) | System displays an error message indicating the Secretary position is already filled; promotion is blocked | | | |
| 3 | Attempt to promote a Youth Volunteer to "Kagawad" when 7 already exist | Position: Kagawad (7 already filled) | System displays an error message indicating the maximum number of Kagawads has been reached; promotion is blocked | | | |
| 4 | Promote a Youth Volunteer to "Kagawad" when fewer than 7 exist | Position: Kagawad (e.g., 5 filled) | System allows the promotion; success toast appears; Kagawad count increases | | | |

Post-Condition: Position limits are enforced; over-filled positions are rejected.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Demote SK Official or Captain to Youth Volunteer
Test Case ID: SA-U7
Test Designed by: JC Ledonio
Test Priority: Medium
Test Designed date: December 15, 2025
Function Name: User Management - Demote User
Test Executed by:
Test Title: Demote SK Official or Captain to Youth Volunteer
Test Execution date:
Description: Verify that the Superadmin can demote an SK Official or Captain back to Youth Volunteer with proper confirmation.

Pre-Condition: Logged in as Superadmin; at least one SK Official or Captain exists.
Dependencies: Demotion functionality is implemented.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Locate an SK Official in the user list | Andrea Pelias (SK Official - Kagawad) | User is visible with role "SK Official" | | | |
| 2 | Click the demote action button | | Confirmation dialog appears with a checkbox to confirm the demotion, explaining the consequences | | | |
| 3 | Check the confirmation checkbox and click "Demote" | | System demotes the user to Youth Volunteer; SK_Tbl record is updated; success toast appears; user list shows "Youth Volunteer" role | | | |

Post-Condition: User is demoted to Youth Volunteer; their SK position is vacated.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Deactivate User Account with Reason
Test Case ID: SA-U8
Test Designed by: JC Ledonio
Test Priority: High
Test Designed date: December 15, 2025
Function Name: User Management - Deactivate Account
Test Executed by:
Test Title: Deactivate User Account with Reason
Test Execution date:
Description: Verify that the Superadmin can deactivate a user account with a required reason and that the user is immediately blocked from accessing the system.

Pre-Condition: Logged in as Superadmin; at least one active user exists (not a Superadmin account).
Dependencies: Account deactivation and status update functionality are operational.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Locate an active user in the user list | Juan Dela Cruz (Active, Youth Volunteer) | User shows "Active" status | | | |
| 2 | Click the "Deactivate" action button | | Deactivation dialog opens with a reason text field and confirmation checkbox | | | |
| 3 | Enter the deactivation reason | Reason: "Violation of community guidelines" | Reason text is accepted | | | |
| 4 | Check the confirmation checkbox and click "Deactivate" | | System updates account status to INACTIVE; success toast appears; user list shows "Inactive" status for the user | | | |
| 5 | Attempt to login as the deactivated user | Email: juandelacruz@gmail.com, Password: Test@1234 | System prevents login and shows an error message about account deactivation | | | |

Post-Condition: User account is INACTIVE; user cannot log in; all sessions are invalidated.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Reactivate Previously Deactivated Account
Test Case ID: SA-U9
Test Designed by: JC Ledonio
Test Priority: Medium
Test Designed date: December 15, 2025
Function Name: User Management - Reactivate Account
Test Executed by:
Test Title: Reactivate Previously Deactivated Account
Test Execution date:
Description: Verify that the Superadmin can reactivate a deactivated user account and that the user can login again.

Pre-Condition: Logged in as Superadmin; at least one inactive user exists.
Dependencies: Reactivation functionality is operational.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Filter users by "Inactive" status | Status filter: Inactive | Only inactive users are displayed | | | |
| 2 | Locate the deactivated user | Juan Dela Cruz (Inactive) | User shows "Inactive" status | | | |
| 3 | Click the "Reactivate" action button | | Confirmation dialog appears | | | |
| 4 | Confirm the reactivation | | System updates account status to ACTIVE; success toast appears; user status changes to "Active" in the list | | | |
| 5 | Attempt to login as the reactivated user | Email: juandelacruz@gmail.com, Password: Test@1234 | User successfully logs in and is redirected to their dashboard | | | |

Post-Condition: User account is ACTIVE again; user can log in and access all authorized features.

---

## ACTIVITY LOGS & AUDIT

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
View All Activity Logs with Timestamps
Test Case ID: SA-L1
Test Designed by: JC Ledonio
Test Priority: Medium
Test Designed date: December 15, 2025
Function Name: Activity Logs - View Logs
Test Executed by:
Test Title: View All Activity Logs with User Details and Timestamps
Test Execution date:
Description: Verify that the Superadmin can view all system activity logs with user details, actions, and timestamps.

Pre-Condition: Logged in as Superadmin; system has recorded activity logs from user actions.
Dependencies: Activity logging is enabled; log records exist in the database.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Navigate to the Activity Logs section on the Superadmin Dashboard | | Activity logs panel loads displaying a list of log entries | | | |
| 2 | Verify log entry details | | Each log entry shows: User Name, Action performed, Timestamp, and relevant details | | | |
| 3 | Verify logs are in chronological order | | Most recent activities appear first (descending order) | | | |

Post-Condition: Superadmin can view all activity logs; no data is modified.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Filter Activity Logs by Date
Test Case ID: SA-L2
Test Designed by: JC Ledonio
Test Priority: Low
Test Designed date: December 15, 2025
Function Name: Activity Logs - Filter by Date
Test Executed by:
Test Title: Filter Activity Logs by Date Range
Test Execution date:
Description: Verify that the Superadmin can filter activity logs by selecting a date or date range.

Pre-Condition: Logged in as Superadmin; logs exist across multiple dates.
Dependencies: Date filter is implemented.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Locate the date filter on the Activity Logs section | | Date picker or filter control is visible | | | |
| 2 | Select a specific date or date range | Date: February 23, 2026 | Log list filters to show only logs from the selected date | | | |
| 3 | Verify filtered results | | Only log entries from February 23, 2026 are displayed | | | |
| 4 | Clear the date filter | | Full log list is restored showing all dates | | | |

Post-Condition: Date filter correctly narrows the log list; clearing restores all logs.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
View Audit Trail
Test Case ID: SA-L3
Test Designed by: JC Ledonio
Test Priority: Medium
Test Designed date: December 15, 2025
Function Name: Activity Logs - Audit Trail
Test Executed by:
Test Title: View Audit Trail for Critical System Changes
Test Execution date:
Description: Verify that the Superadmin can view the audit trail tab showing critical system changes like role changes, promotions, demotions, and status changes.

Pre-Condition: Logged in as Superadmin; critical system changes have been made (e.g., promotions, demotions, deactivations).
Dependencies: Audit trail logging is enabled.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Click on the "Audit Trail" tab in the Activity Logs section | | Audit trail view loads showing critical system changes | | | |
| 2 | Verify audit entries include role changes | | Entries for promotions and demotions are visible with old role, new role, and timestamp | | | |
| 3 | Verify audit entries include status changes | | Entries for account deactivations and reactivations are visible with reason and timestamp | | | |

Post-Condition: Superadmin can review all critical audit trail entries.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
View Database Statistics
Test Case ID: SA-L4
Test Designed by: JC Ledonio
Test Priority: Low
Test Designed date: December 15, 2025
Function Name: Activity Logs - Database Stats
Test Executed by:
Test Title: View Database Record Counts per Table
Test Execution date:
Description: Verify that the Superadmin can view database statistics showing record counts for all system tables.

Pre-Condition: Logged in as Superadmin.
Dependencies: Database statistics query is functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Click on the "Database Stats" tab | | Database statistics view loads | | | |
| 2 | Verify record counts are displayed | | Table shows record counts for key tables: User_Tbl, Pre_Project_Tbl, Application_Tbl, Announcement_Tbl, File_Tbl, Inquiry_Tbl, etc. | | | |
| 3 | Verify counts are reasonable | | Numbers reflect the actual data in the system (non-negative integers) | | | |

Post-Condition: Database statistics are displayed correctly.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
View Storage Buckets Information
Test Case ID: SA-L5
Test Designed by: JC Ledonio
Test Priority: Low
Test Designed date: December 15, 2025
Function Name: Activity Logs - Storage Buckets
Test Executed by:
Test Title: View Configured Storage Buckets
Test Execution date:
Description: Verify that the Superadmin can view the list of configured storage buckets with their access levels.

Pre-Condition: Logged in as Superadmin.
Dependencies: Storage bucket information is accessible.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Click on the "Storage" or "Buckets" section | | Storage buckets list loads | | | |
| 2 | Verify all configured buckets are listed | | Buckets shown include: general-files, project-files, consent-forms, receipts, certificates, announcement-images, user-images | | | |
| 3 | Verify access levels are displayed | | Each bucket shows whether it is public or private | | | |

Post-Condition: Storage bucket information is displayed correctly.
