# NEW TEST CASES - NOTIFICATIONS, PROFILE MANAGEMENT, DASHBOARD

---

## NOTIFICATIONS

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Receive Notification for Relevant Updates
Test Case ID: NTF-1
Test Designed by: Brian Louis B. Ralleta
Test Priority: Medium
Test Designed date: December 15, 2025
Function Name: Notifications - Receive Notification
Test Executed by:
Test Title: Receive Notification for Relevant System Updates
Test Execution date:
Description: Verify that users receive notifications when relevant actions are performed (e.g., project submitted for approval, application status changed, inquiry received).

Pre-Condition: Two user accounts exist (e.g., SK Official and Captain); notification system is enabled.
Dependencies: Notification_Tbl is functional; notification triggers are implemented.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Login as SK Official and submit a project for Captain approval | Project: Hatid Sakay Program | System sends a notification to the Barangay Captain | | | |
| 2 | Logout and login as Barangay Captain | Captain credentials | Captain Dashboard loads | | | |
| 3 | Observe the notification bell icon in the header | | The notification bell shows a badge with the unread notification count (e.g., "1") | | | |
| 4 | Click the notification bell | | Notification modal/dropdown opens showing the new notification: "New project submitted for approval: Hatid Sakay Program" with timestamp | | | |

Post-Condition: The Captain received the notification; the notification is displayed with correct details.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
View Notification Bell with Unread Count
Test Case ID: NTF-2
Test Designed by: Brian Louis B. Ralleta
Test Priority: Low
Test Designed date: December 15, 2025
Function Name: Notifications - View Unread Count
Test Executed by:
Test Title: View Notification Bell with Correct Unread Count
Test Execution date:
Description: Verify that the notification bell in the header displays the correct unread notification count and opens the notification list.

Pre-Condition: Logged in as any role; at least one unread notification exists.
Dependencies: Notification system is functional; notification modal component is loaded.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Observe the notification bell icon in the header | | Bell icon is visible with a numbered badge showing unread count (e.g., "3") | | | |
| 2 | Click the notification bell | | Notification modal opens showing a list of notifications, each with a title, description, and timestamp | | | |
| 3 | Verify unread notifications are visually distinct | | Unread notifications have a different background color or visual indicator compared to read notifications | | | |
| 4 | Close the notification modal | | Modal closes; user returns to the dashboard | | | |

Post-Condition: Notification list displays correctly; unread count is accurate.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Mark Notifications as Read
Test Case ID: NTF-3
Test Designed by: Brian Louis B. Ralleta
Test Priority: Low
Test Designed date: December 15, 2025
Function Name: Notifications - Mark as Read
Test Executed by:
Test Title: Mark Notifications as Read
Test Execution date:
Description: Verify that clicking on or interacting with a notification marks it as read and updates the unread count.

Pre-Condition: Logged in with at least 2 unread notifications.
Dependencies: Mark-as-read functionality is implemented.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Open the notification modal | | Notification list shows with unread count badge (e.g., "2") | | | |
| 2 | Click on an unread notification | First unread notification | The notification's visual styling changes to "read" state; unread count badge decreases by 1 (e.g., "1") | | | |
| 3 | Click on the second unread notification | Second unread notification | The notification is marked as read; badge decreases to 0 or the badge disappears | | | |

Post-Condition: All clicked notifications are marked as read; unread count reflects the actual number of unread notifications.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Click Notification to Navigate to Relevant Section
Test Case ID: NTF-4
Test Designed by: Brian Louis B. Ralleta
Test Priority: Medium
Test Designed date: December 15, 2025
Function Name: Notifications - Navigate on Click
Test Executed by:
Test Title: Click Notification to Navigate to Relevant Section
Test Execution date:
Description: Verify that clicking a notification navigates the user to the relevant section or page related to that notification.

Pre-Condition: Logged in with at least one notification linked to a specific page/section (e.g., project approval notification).
Dependencies: Notification navigation links are implemented.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Open the notification modal | | Notification list displays | | | |
| 2 | Click on a project-related notification | "New project submitted for approval: Hatid Sakay Program" | System navigates to the project details or the relevant section (e.g., Captain's Pending Approval tab or SK's project page) | | | |
| 3 | Verify the correct page/section is displayed | | The target page loads with the relevant project or item visible/highlighted | | | |

Post-Condition: User is on the relevant page; notification is marked as read.

---

## PROFILE MANAGEMENT

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
View and Update Profile Information
Test Case ID: PRF-1
Test Designed by: Brian Louis B. Ralleta
Test Priority: Medium
Test Designed date: December 15, 2025
Function Name: Profile - Update Information
Test Executed by:
Test Title: View and Update Profile Information
Test Execution date:
Description: Verify that a user can view their profile information and update editable fields from the dashboard.

Pre-Condition: Logged in as any role; profile modal component is loaded.
Dependencies: ProfileModal.js is functional; User_Tbl is updatable.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Click on the profile icon or name in the header/sidebar | | Profile modal opens showing current user information (name, email, contact number, address, birthday, gender) | | | |
| 2 | Verify current information is displayed correctly | | All fields show the correct data matching what was entered during registration/profile completion | | | |
| 3 | Update the contact number | New Contact: 09987654321 | The new number is accepted in the field (11-digit format starting with 09) | | | |
| 4 | Update the address | New Address: 456 Sampaguita St. Malanday, Marikina City | Address is accepted (minimum 10 characters) | | | |
| 5 | Click "Save" or "Update Profile" | | System saves the changes; success toast appears; the profile modal and header display the updated information | | | |

Post-Condition: Profile information is updated in the database; the header reflects the changes.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Change Password from Dashboard
Test Case ID: PRF-2
Test Designed by: Brian Louis B. Ralleta
Test Priority: Medium
Test Designed date: December 15, 2025
Function Name: Profile - Change Password
Test Executed by:
Test Title: Change Password from Dashboard
Test Execution date:
Description: Verify that a user can change their password from the dashboard using the change password modal.

Pre-Condition: Logged in as any role.
Dependencies: Change password modal is functional; password update API works.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Open the profile modal and click "Change Password" | | Change Password modal opens with fields: Current Password, New Password, Confirm New Password | | | |
| 2 | Enter the current password | Current Password: Test@1234 | Password appears as masked characters | | | |
| 3 | Enter a new password meeting complexity requirements | New Password: NewPass@5678 | Password requirements checklist shows all checks passed (8+ chars, uppercase, lowercase, number, special char) | | | |
| 4 | Re-enter the new password | Confirm: NewPass@5678 | Confirm field shows green border indicating match | | | |
| 5 | Click "Update Password" | | System updates the password; success toast appears; modal closes | | | |
| 6 | Logout and login with the new password | Email: (current email), Password: NewPass@5678 | User successfully logs in with the new password | | | |

Post-Condition: Password is updated; old password no longer works; new password grants access.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Upload/Change Profile Picture
Test Case ID: PRF-3
Test Designed by: Brian Louis B. Ralleta
Test Priority: Low
Test Designed date: December 15, 2025
Function Name: Profile - Profile Picture
Test Executed by:
Test Title: Upload or Change Profile Picture
Test Execution date:
Description: Verify that a user can upload or change their profile picture and it displays correctly in the header and profile modal.

Pre-Condition: Logged in as any role; profile modal is accessible.
Dependencies: User-images storage bucket is configured; avatar upload is functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Open the profile modal | | Profile modal opens; current avatar shows either initials fallback or existing photo | | | |
| 2 | Click on the profile picture/avatar area or "Change Photo" button | | File picker dialog opens | | | |
| 3 | Select a new profile image | profile_photo.jpg (valid image, under 5MB) | Image is uploaded and the profile picture updates in the modal | | | |
| 4 | Close the modal and check the header avatar | | The header avatar displays the new profile picture | | | |

Post-Condition: Profile picture is updated in storage and database; it displays correctly in the header and profile modal.

---

## DASHBOARD

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
View Dashboard Statistics Per Role
Test Case ID: DSH-1
Test Designed by: Brian Louis B. Ralleta
Test Priority: Medium
Test Designed date: December 15, 2025
Function Name: Dashboard - View Statistics
Test Executed by:
Test Title: View Dashboard Statistics Per Role
Test Execution date:
Description: Verify that each role's dashboard displays accurate role-specific statistics.

Pre-Condition: Multiple users exist with different roles; system has data (files, announcements, projects, volunteers).
Dependencies: Dashboard statistics queries are functional for all roles.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Login as SK Official and observe the dashboard | SK credentials | SK Dashboard shows stats: Total Files, Total Announcements, Total Projects, Total Volunteers, Budget Allocation | | | |
| 2 | Login as Youth Volunteer and observe the dashboard | Youth credentials | Youth Dashboard shows: Announcements section, application status updates, and relevant information for Youth role | | | |
| 3 | Login as Barangay Captain and observe the dashboard | Captain credentials | Captain Dashboard shows: Project Approvals overview (Pending, Approved, Rejected counts, Total Budget), Announcements section | | | |
| 4 | Login as Superadmin and observe the dashboard | Superadmin credentials | Superadmin Dashboard shows: Total Users, Active Users, Pending Accounts, Deactivated Users, Total Projects, Total Applications, System Health | | | |

Post-Condition: Each role's dashboard displays accurate, role-specific statistics.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Pages and Modals Load Without Noticeable Delays
Test Case ID: DSH-2
Test Designed by: Brian Louis B. Ralleta
Test Priority: Low
Test Designed date: December 15, 2025
Function Name: Dashboard - Performance
Test Executed by:
Test Title: Pages and Modals Load Without Noticeable Delays
Test Execution date:
Description: Verify that all main pages and modals load smoothly without errors or excessive delays.

Pre-Condition: Logged in as any role; system has data loaded.
Dependencies: All pages and components are deployed and functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Navigate to the Dashboard | | Dashboard loads without errors; no blank screens or excessive loading spinners | | | |
| 2 | Navigate to the Files page | | Files page loads with file cards displayed; skeleton loaders show briefly then content appears | | | |
| 3 | Navigate to the Projects page | | Projects page loads with project cards displayed | | | |
| 4 | Navigate to the Calendar page | | Calendar page loads with events rendered | | | |
| 5 | Open a project details modal | | Modal opens quickly with all tabs and content loaded | | | |
| 6 | Open the profile modal | | Profile modal opens with user data pre-filled | | | |

Post-Condition: All pages and modals load within acceptable time; no errors or broken layouts.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Role-Based Redirect After Login
Test Case ID: DSH-3
Test Designed by: Brian Louis B. Ralleta
Test Priority: Medium
Test Designed date: December 15, 2025
Function Name: Dashboard - Role-Based Redirect
Test Executed by:
Test Title: Role-Based Redirect After Login
Test Execution date:
Description: Verify that each role is redirected to their correct dashboard after successful login.

Pre-Condition: User accounts exist for each role; login page is accessible.
Dependencies: Role-based redirect logic in login flow is functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Login as SK Official | Email: testsk1@bims.test, Password: Test@123 | User is redirected to sk-dashboard.html | | | |
| 2 | Logout and login as Youth Volunteer | Email: testyouth1@bims.test, Password: Test@123 | User is redirected to youth-dashboard.html | | | |
| 3 | Logout and login as Barangay Captain | Email: testcaptain@bims.test, Password: Test@123 | User is redirected to captain-dashboard.html | | | |
| 4 | Logout and login as Superadmin | Email: superadmin@bims.test, Password: Test@123 | User is redirected to superadmin-dashboard.html | | | |

Post-Condition: Each role is correctly redirected to their designated dashboard page.
