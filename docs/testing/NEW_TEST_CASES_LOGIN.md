# NEW TEST CASES - LOGIN / AUTHENTICATION

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Sign Up with Complete Details
Test Case ID: LOG-7
Test Designed by: JC Ledonio
Test Priority: High
Test Designed date: November 29, 2025
Function Name: Login - Sign Up
Test Executed by:
Test Title: Sign Up with Complete Details
Test Execution date:
Description: Verify that a new user can successfully register an account with complete and valid details and is redirected to OTP verification.

Pre-Condition: User is on the Sign Up page and does not have an existing account.
Dependencies: Sign-up page is accessible; database and Supabase authentication are functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Navigate to the Sign Up page | | The Sign Up page displays with First Name, Last Name, Email, Password, Confirm Password fields, Terms checkbox, and a "Sign Up" button | | | |
| 2 | Enter valid first name | First Name: Juan | The name appears in the first name field with green border | | | |
| 3 | Enter valid last name | Last Name: Dela Cruz | The name appears in the last name field with green border | | | |
| 4 | Enter valid email address | Email: juandelacruz@gmail.com | The email appears in the email field with green border | | | |
| 5 | Enter a valid password that meets all complexity requirements | Password: Test@1234 | Password field shows masked characters; all 5 requirement checks turn green (8+ chars, uppercase, lowercase, number, special character) | | | |
| 6 | Re-enter the same password in Confirm Password | Confirm Password: Test@1234 | The confirm password field shows green border indicating match | | | |
| 7 | Check the Terms of Service & Privacy Policy checkbox | | Checkbox is checked | | | |
| 8 | Click the "Sign Up" button | | System creates the account, shows loading spinner, and redirects user to the OTP Verification page (verify-otp.html) | | | |

Post-Condition: User account is created in the database with role YOUTH_VOLUNTEER; user is on the OTP verification page waiting to verify email.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Sign Up with Missing or Invalid Details
Test Case ID: LOG-8
Test Designed by: JC Ledonio
Test Priority: High
Test Designed date: November 29, 2025
Function Name: Login - Sign Up
Test Executed by:
Test Title: Sign Up with Missing or Invalid Details
Test Execution date:
Description: Verify that the system prevents registration when required fields are missing or contain invalid data.

Pre-Condition: User is on the Sign Up page.
Dependencies: Sign-up form validation is functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Navigate to the Sign Up page | | The Sign Up page displays with all input fields | | | |
| 2 | Leave First Name empty and click elsewhere | First Name: (empty) | Field shows red border with error state | | | |
| 3 | Enter a single character in Last Name | Last Name: "D" | Field shows red border (minimum 2 characters required) | | | |
| 4 | Enter an invalid email format | Email: juangmail.com | Field shows red border indicating invalid email format | | | |
| 5 | Enter a weak password that does not meet requirements | Password: test | Password requirement checklist shows unmet requirements in red (missing uppercase, number, special char, minimum length) | | | |
| 6 | Enter a different password in Confirm Password | Confirm Password: test123 | Field shows red border indicating passwords do not match | | | |
| 7 | Leave the Terms checkbox unchecked | | Checkbox remains unchecked | | | |
| 8 | Click the "Sign Up" button | | System prevents registration and shows validation errors on all invalid fields; user remains on the Sign Up page | | | |

Post-Condition: No account is created; user remains on the Sign Up page with validation error messages displayed.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Valid OTP Verification
Test Case ID: LOG-9
Test Designed by: JC Ledonio
Test Priority: High
Test Designed date: November 29, 2025
Function Name: Login - OTP Verification
Test Executed by:
Test Title: Valid OTP Verification
Test Execution date:
Description: Verify that the user can successfully verify their email by entering the correct 6-digit OTP code within the 10-minute validity window.

Pre-Condition: User has just signed up and is on the OTP verification page (verify-otp.html); a 6-digit OTP code was sent to the registered email.
Dependencies: Email delivery service is functional; OTP generation and validation are operational.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Observe the OTP verification page | | Page displays 6 individual digit input fields, a countdown timer (starting at 10:00), and a "Verify" button | | | |
| 2 | Check the registered email inbox for the OTP code | Email: juandelacruz@gmail.com | An email with a 6-digit verification code is received | | | |
| 3 | Enter the correct 6-digit OTP code | OTP: (code from email) | Each digit appears in its respective field with green border; focus auto-advances to the next field after each digit | | | |
| 4 | Click the "Verify" button | | System validates the OTP, shows success message, and redirects user to the Complete Profile page or Login page | | | |

Post-Condition: User's email is verified; account is activated and user is redirected to complete their profile or login.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Invalid OTP Verification
Test Case ID: LOG-10
Test Designed by: JC Ledonio
Test Priority: High
Test Designed date: November 29, 2025
Function Name: Login - OTP Verification
Test Executed by:
Test Title: Invalid OTP Verification
Test Execution date:
Description: Verify that the system rejects an incorrect OTP code and displays an appropriate error message.

Pre-Condition: User has just signed up and is on the OTP verification page; a valid OTP was sent to their email.
Dependencies: OTP validation logic is functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Observe the OTP verification page | | Page displays 6 input fields and countdown timer | | | |
| 2 | Enter an incorrect 6-digit OTP code | OTP: 000000 | Each digit appears in the input fields | | | |
| 3 | Click the "Verify" button | | System displays an error message indicating the OTP is invalid; user remains on the OTP verification page | | | |
| 4 | Verify the countdown timer is still active | | Timer continues counting down; user can retry with correct code | | | |

Post-Condition: User's email is NOT verified; user remains on the OTP verification page with the error message displayed and can retry.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Expired OTP After 10-Minute Timer
Test Case ID: LOG-11
Test Designed by: JC Ledonio
Test Priority: Medium
Test Designed date: November 29, 2025
Function Name: Login - OTP Verification
Test Executed by:
Test Title: Expired OTP After 10-Minute Timer
Test Execution date:
Description: Verify that the OTP code expires after the 10-minute countdown reaches zero and the Verify button is disabled.

Pre-Condition: User is on the OTP verification page with the countdown timer active.
Dependencies: Timer functionality and OTP expiry logic are operational.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Observe the countdown timer on the OTP page | | Timer is counting down from 10:00 in MM:SS format | | | |
| 2 | Wait for the timer to reach 0:00 | | Timer displays 0:00 | | | |
| 3 | Enter the OTP code that was previously sent | OTP: (original code) | Digits appear in the input fields | | | |
| 4 | Attempt to click the "Verify" button | | The Verify button is disabled or the system shows an error message indicating the OTP has expired; user is prompted to request a new code | | | |

Post-Condition: The expired OTP is no longer valid; user must click "Resend" to receive a new code.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Resend OTP with 60-Second Cooldown
Test Case ID: LOG-12
Test Designed by: JC Ledonio
Test Priority: Medium
Test Designed date: November 29, 2025
Function Name: Login - OTP Verification
Test Executed by:
Test Title: Resend OTP with 60-Second Cooldown
Test Execution date:
Description: Verify that the user can request a new OTP via the Resend link and that a 60-second cooldown is enforced between resend requests.

Pre-Condition: User is on the OTP verification page.
Dependencies: Email delivery and OTP resend functionality are operational.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Click the "Didn't receive the code? Resend" link | | System sends a new OTP to the user's email; the Resend link is replaced with a 60-second countdown timer | | | |
| 2 | Observe the cooldown timer on the Resend button | | Button shows countdown (e.g., "Resend in 59s") and is disabled/unclickable | | | |
| 3 | Wait for the 60-second cooldown to finish | | The Resend link becomes active again | | | |
| 4 | Check email for the new OTP | | A new 6-digit OTP code is received in the email inbox | | | |
| 5 | Enter the new OTP code and click Verify | OTP: (new code from email) | System validates the new OTP and completes verification successfully | | | |

Post-Condition: User's email is verified with the newly resent OTP code; the old OTP is invalidated.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Complete Profile After First Login
Test Case ID: LOG-13
Test Designed by: JC Ledonio
Test Priority: High
Test Designed date: November 29, 2025
Function Name: Login - Complete Profile
Test Executed by:
Test Title: Complete Profile After First Login
Test Execution date:
Description: Verify that new users (email/password or Google) are redirected to the Complete Profile page after first login and can successfully fill in required personal information.

Pre-Condition: User has verified their email and is logging in for the first time with an incomplete profile (missing contact number, address, gender, birthday).
Dependencies: Complete Profile page is functional; User_Tbl can be updated.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Log in with valid credentials | Email: juandelacruz@gmail.com, Password: Test@1234 | System detects incomplete profile and redirects to complete-profile.html | | | |
| 2 | Verify the profile form loads with existing data | | First Name and Last Name are pre-filled from signup; other fields are empty | | | |
| 3 | Enter Date of Birthday | Birthday: January 15, 2005 | Date is accepted (user is at least 15 years old); field shows green border | | | |
| 4 | Enter Contact Number | Contact: 09123456789 | 11-digit number starting with 09 is accepted; field shows green border | | | |
| 5 | Select Gender | Gender: Male | Dropdown selection is accepted | | | |
| 6 | Enter Complete Address | Address: 123 Rizal St. Malanday, Marikina City | Address is accepted (minimum 10 characters); field shows green border | | | |
| 7 | Click "Complete Profile" button | | System saves the profile, shows success message, and redirects user to their role-appropriate dashboard (Youth Dashboard) | | | |

Post-Condition: User profile is complete in the database; user is on the Youth Dashboard with full access to authorized features.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Account Lockout After 5 Failed Login Attempts
Test Case ID: LOG-14
Test Designed by: JC Ledonio
Test Priority: Medium
Test Designed date: November 29, 2025
Function Name: Login - Account Lockout
Test Executed by:
Test Title: Account Lockout After 5 Failed Login Attempts
Test Execution date:
Description: Verify that the system locks an account for 15 minutes after 5 consecutive failed login attempts and displays the remaining lockout time.

Pre-Condition: User has a registered and active account; no prior lockout is in effect.
Dependencies: Login attempt tracking and lockout mechanism are functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Navigate to the login page | | Login page loads normally | | | |
| 2 | Enter valid email with wrong password (attempt 1) | Email: testsk1@bims.test, Password: Wrong@111 | Error message: "Invalid Email or Password" | | | |
| 3 | Enter valid email with wrong password (attempt 2) | Email: testsk1@bims.test, Password: Wrong@222 | Error message: "Invalid Email or Password" | | | |
| 4 | Enter valid email with wrong password (attempt 3) | Email: testsk1@bims.test, Password: Wrong@333 | Error message: "Invalid Email or Password" | | | |
| 5 | Enter valid email with wrong password (attempt 4) | Email: testsk1@bims.test, Password: Wrong@444 | Error message: "Invalid Email or Password" | | | |
| 6 | Enter valid email with wrong password (attempt 5) | Email: testsk1@bims.test, Password: Wrong@555 | System locks the account and displays message: "Account locked. Try again in X minutes" with remaining lockout time | | | |
| 7 | Attempt to login again with correct password | Email: testsk1@bims.test, Password: Test@123 | System still shows lockout message; login is prevented even with correct credentials | | | |

Post-Condition: Account is locked for 15 minutes; user must wait for the lockout period to expire before attempting login again.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Login with Inactive/Deactivated Account
Test Case ID: LOG-15
Test Designed by: JC Ledonio
Test Priority: Medium
Test Designed date: November 29, 2025
Function Name: Login - Account Status Check
Test Executed by:
Test Title: Login with Inactive/Deactivated Account
Test Execution date:
Description: Verify that the system prevents login for accounts that have been deactivated by the Superadmin and displays an appropriate error message.

Pre-Condition: A user account has been deactivated by the Superadmin (status: INACTIVE).
Dependencies: Account deactivation functionality is operational; account status check is implemented in login flow.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Navigate to the login page | | Login page loads normally | | | |
| 2 | Enter the email of the deactivated account | Email: deactivated@bims.test | Email appears in the email field | | | |
| 3 | Enter the correct password | Password: Test@123 | Password appears as masked characters | | | |
| 4 | Click the "Login" button | | System checks account status, finds it INACTIVE, and displays error message indicating the account has been deactivated; user is NOT logged in and remains on the login page | | | |

Post-Condition: No session is created; user remains on the login page with an error message about account deactivation.
