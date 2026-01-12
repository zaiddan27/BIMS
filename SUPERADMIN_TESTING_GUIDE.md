# Superadmin Dashboard Testing Guide

## Overview
This guide provides step-by-step testing procedures for the superadmin dashboard functionality, including OAuth login, role management, and the new demote modal feature.

---

## Test Environment Setup

**Test Account**: malandaysk@gmail.com
**Role**: SUPERADMIN
**Account Status**: ACTIVE

**Prerequisites**:
1. Clear browser cache and cookies
2. Ensure Supabase migrations 015, 016, and 017 are applied
3. Verify database has correct casing (User_Tbl, userID, firstName, accountStatus)

---

## Test Suite 1: Google OAuth Login Flow

### Test 1.1: OAuth Redirect to Superadmin Dashboard

**Objective**: Verify SUPERADMIN users are redirected to superadmin-dashboard.html after OAuth login

**Steps**:
1. Open login.html in browser
2. Click "Continue with Google"
3. Select malandaysk@gmail.com account
4. Complete Google authentication

**Expected Results**:
- ✅ User authenticates successfully
- ✅ Redirects to superadmin-dashboard.html
- ✅ Dashboard loads with user data
- ✅ No redirect to youth-dashboard.html or index.html

**Files Involved**:
- `complete-profile.html` (lines 322-348): Role-based redirection logic

**Database Verification**:
```sql
SELECT "userID", "email", "role", "accountStatus"
FROM "User_Tbl"
WHERE "email" = 'malandaysk@gmail.com';
```

---

## Test Suite 2: Demote Modal Functionality

### Test 2.1: Demote SK Official

**Objective**: Test the demote modal for removing SK Official position

**Precondition**: Have at least one user with SK_OFFICIAL role

**Steps**:
1. Navigate to superadmin-user-management.html
2. Locate an SK Official in the user list
3. Click "Remove SK Role" button
4. Verify modal opens with orange gradient theme
5. Check that user name and role are displayed correctly
6. Read the warning messages
7. **DO NOT** check the confirmation checkbox yet
8. Click "Confirm Demotion" button

**Expected Results**:
- ✅ Modal displays with orange theme
- ✅ Shows user name and "Current Role: SK Official"
- ✅ Warning lists 4 consequences
- ❌ Toast appears: "Please confirm that you understand the consequences"
- ✅ Modal remains open

**Steps (Continued)**:
9. Check the confirmation checkbox
10. Click "Confirm Demotion" button
11. Wait for database operation to complete

**Expected Results**:
- ✅ Modal closes automatically
- ✅ Toast appears: "[User Name] demoted to Youth Volunteer"
- ✅ User list refreshes
- ✅ User role changes to YOUTH_VOLUNTEER in the table
- ✅ User now has "Promote" button instead of "Remove SK Role"

**Database Verification**:
```sql
-- Check User_Tbl role updated
SELECT "userID", "firstName", "lastName", "role"
FROM "User_Tbl"
WHERE "userID" = '[demoted-user-id]';
-- Should show role = 'YOUTH_VOLUNTEER'

-- Check SK_Tbl record deleted
SELECT * FROM "SK_Tbl"
WHERE "userID" = '[demoted-user-id]';
-- Should return 0 rows
```

### Test 2.2: Demote Captain

**Objective**: Test the demote modal for removing Captain position

**Precondition**: Have at least one user with CAPTAIN role

**Steps**:
1. Navigate to superadmin-user-management.html
2. Locate the Captain in the user list
3. Verify "Remove Captain Role" button is visible (NOT "Protected")
4. Click "Remove Captain Role" button
5. Verify modal opens with orange gradient theme
6. Check that user name shows "Current Role: Barangay Captain"
7. Read the warning messages
8. Check the confirmation checkbox
9. Click "Confirm Demotion" button

**Expected Results**:
- ✅ Modal displays with user info
- ✅ Shows "Current Role: Barangay Captain"
- ✅ Database operations succeed
- ✅ Toast appears: "[Captain Name] demoted to Youth Volunteer"
- ✅ Captain role changes to YOUTH_VOLUNTEER
- ✅ User list refreshes

**Database Verification**:
```sql
-- Check User_Tbl role updated
SELECT "userID", "firstName", "lastName", "role"
FROM "User_Tbl"
WHERE "userID" = '[demoted-captain-id]';
-- Should show role = 'YOUTH_VOLUNTEER'

-- Check Captain_Tbl record deleted
SELECT * FROM "Captain_Tbl"
WHERE "userID" = '[demoted-captain-id]';
-- Should return 0 rows

-- Verify Captain_Tbl constraint (only one active captain)
SELECT COUNT(*) FROM "Captain_Tbl" WHERE "isActive" = TRUE;
-- Should return 0 (no active captain after demotion)
```

### Test 2.3: Cancel Demote Operation

**Objective**: Verify cancel functionality in demote modal

**Steps**:
1. Click "Remove SK Role" or "Remove Captain Role" on any user
2. Modal opens
3. Check the confirmation checkbox
4. Click "Cancel" button OR click X button in top-right

**Expected Results**:
- ✅ Modal closes
- ✅ No database changes occur
- ✅ User role remains unchanged
- ✅ No toast messages appear

### Test 2.4: Close Modal via Outside Click

**Objective**: Verify modal does NOT close when clicking outside (expected behavior)

**Steps**:
1. Open demote modal
2. Click on the dark overlay outside the modal

**Expected Results**:
- ✅ Modal remains open (clicking outside should NOT close it)
- ✅ User must use Cancel or X button to close

---

## Test Suite 3: Database Casing Verification

### Test 3.1: User List Display

**Objective**: Verify all user data displays correctly with proper casing

**Steps**:
1. Navigate to superadmin-user-management.html
2. Inspect user list table
3. Verify all columns display data correctly:
   - Name column shows firstName + lastName
   - Email column shows email
   - Role column shows role badge
   - Status column shows account status
   - Actions column shows appropriate buttons

**Expected Results**:
- ✅ No "undefined" values in any column
- ✅ Names display with proper capitalization
- ✅ Account status shows "Active", "Inactive", or "Pending"
- ✅ Role badges show correct colors and labels

### Test 3.2: Filter Functions

**Objective**: Test search and filter functionality with correct casing

**Steps**:
1. Use search box to search by name
2. Filter by role (SK Official, Captain, Youth Volunteer)
3. Filter by status (Active, Inactive, Pending)
4. Combine multiple filters

**Expected Results**:
- ✅ Search returns correct results
- ✅ Filters work properly
- ✅ No console errors about undefined properties
- ✅ Results update in real-time

**Console Check**:
Open browser DevTools Console and verify:
- ❌ No errors like "Cannot read property 'firstname' of undefined"
- ❌ No warnings about case mismatches

---

## Test Suite 4: Protected Roles

### Test 4.1: Superadmin Protection

**Objective**: Verify SUPERADMIN role cannot be demoted

**Steps**:
1. Locate a SUPERADMIN user in the list
2. Check the Actions column

**Expected Results**:
- ✅ Shows "Protected" text in gray
- ❌ NO "Remove" button visible
- ✅ No way to demote SUPERADMIN

### Test 4.2: Captain Removability

**Objective**: Verify Captain CAN be removed (as per CLAUDE.md)

**Steps**:
1. Locate Captain user in the list
2. Check the Actions column

**Expected Results**:
- ✅ Shows "Remove Captain Role" button
- ❌ Does NOT show "Protected" label
- ✅ Button is orange-colored
- ✅ Clicking opens demote modal

**Reference**: CLAUDE.md lines 132-134
```
Captain Role Constraint:
- Only ONE active CAPTAIN account allowed in the system
- Promoting a new Captain automatically deactivates the existing active Captain
```

---

## Test Suite 5: Browser Console Validation

### Test 5.1: Check for JavaScript Errors

**Objective**: Verify no JavaScript errors occur during normal operation

**Steps**:
1. Open browser DevTools (F12)
2. Go to Console tab
3. Perform all actions: load page, open modal, demote user, close modal

**Expected Results**:
- ❌ No red error messages
- ❌ No "undefined" or "null" property access errors
- ✅ Only info/success logs should appear

### Test 5.2: Network Tab Verification

**Objective**: Verify API calls use correct table/column names

**Steps**:
1. Open DevTools Network tab
2. Filter by "supabase" or "XHR"
3. Perform demote action
4. Inspect request payload and response

**Expected Results**:
- ✅ Requests use "User_Tbl", "SK_Tbl", "Captain_Tbl"
- ✅ Responses include camelCase fields (userID, firstName, accountStatus)
- ✅ No 400/500 errors
- ✅ All requests return 200 status

---

## Test Suite 6: Edge Cases

### Test 6.1: Demote Last SK Official

**Objective**: Test system behavior when demoting the last SK Official

**Steps**:
1. Ensure only one SK_OFFICIAL user exists
2. Demote that user
3. Check SK statistics

**Expected Results**:
- ✅ Demotion succeeds
- ✅ SK Officials count shows 0
- ✅ System continues to function

### Test 6.2: Rapid Modal Actions

**Objective**: Test system stability with rapid open/close actions

**Steps**:
1. Quickly open and close modal multiple times
2. Open modal, check checkbox, cancel, reopen
3. Open modal for different users back-to-back

**Expected Results**:
- ✅ No UI glitches
- ✅ Correct user info displays each time
- ✅ Checkbox resets properly
- ✅ No stale data from previous modal

### Test 6.3: Concurrent User Changes

**Objective**: Test behavior when user data changes during modal interaction

**Scenario**: Open modal, then another admin changes the user's role in different tab

**Steps**:
1. Open demote modal for User A
2. In another tab/window, change User A's role
3. Return to first tab and confirm demotion

**Expected Results**:
- ✅ System handles race condition gracefully
- ✅ Either succeeds with warning or fails with clear error
- ✅ No database inconsistencies

---

## Success Criteria

### Critical Requirements
- [✓] OAuth login redirects SUPERADMIN to correct dashboard
- [✓] Demote modal opens and displays correctly
- [✓] SK Official demotion works (removes SK_Tbl record + updates role)
- [✓] Captain demotion works (removes Captain_Tbl record + updates role)
- [✓] Modal requires checkbox confirmation
- [✓] Cancel button works without side effects
- [✓] Database uses correct casing (User_Tbl, userID, firstName, etc.)
- [✓] No toast notifications (replaced with modal)
- [✓] Captain is NOT protected (has Remove button)

### Nice-to-Have
- [ ] Smooth animations
- [ ] Responsive design on mobile
- [ ] Keyboard shortcuts (Esc to close modal)
- [ ] Focus management in modal

---

## Troubleshooting

### Issue: Modal doesn't open
**Check**:
- Console for JavaScript errors
- Modal ID matches function call: `demoteModal`
- Functions are in global scope: `window.demoteUser`, `window.demoteCaptain`

### Issue: Database update fails
**Check**:
- RLS policies allow SUPERADMIN to update User_Tbl
- Foreign key constraints are satisfied
- Supabase connection is active

### Issue: User list doesn't refresh
**Check**:
- `loadUsers()` function is called after modal closes
- No errors in database query
- Data is being returned from Supabase

### Issue: "undefined" in user list
**Check**:
- Database column names use camelCase (firstName, not firstname)
- JavaScript accesses properties with correct casing
- Query includes all necessary fields in SELECT

---

## Files Modified in This Implementation

1. **complete-profile.html** (lines 322-348)
   - Added role-based redirection logic

2. **superadmin-user-management.html**
   - Lines 434-510: Demote Modal HTML
   - Lines 723-733: Captain "Remove" button (not protected)
   - Lines 863-868, 893-898: Fixed lowercase property access in filters
   - Lines 958: Fixed Captain name display in confirmation
   - Lines 1208-1292: Demote functions (demoteUser, demoteCaptain, confirmDemote)

---

## Next Steps After Testing

After all tests pass:
1. Mark "Test superadmin dashboard functionality" as completed
2. Move to next task: "Implement 6-digit OTP password reset"
3. Document any bugs found during testing
4. Update PROGRESS.md with completion status

---

## Test Execution Checklist

**Authentication**:
- [ ] OAuth login redirects SUPERADMIN correctly
- [ ] Dashboard displays user data properly
- [ ] Session persists across page reloads

**Demote Modal - SK Official**:
- [ ] Modal opens with orange theme
- [ ] User info displays correctly
- [ ] Confirmation required
- [ ] Database updates successfully
- [ ] SK_Tbl record deleted
- [ ] User role changes to YOUTH_VOLUNTEER

**Demote Modal - Captain**:
- [ ] "Remove Captain Role" button visible
- [ ] Modal opens with correct user info
- [ ] Database updates successfully
- [ ] Captain_Tbl record deleted
- [ ] User role changes to YOUTH_VOLUNTEER

**Database Casing**:
- [ ] User list displays all fields correctly
- [ ] No "undefined" values
- [ ] Filters work properly
- [ ] No console errors about casing

**Protected Roles**:
- [ ] SUPERADMIN shows "Protected"
- [ ] Captain shows "Remove Captain Role"
- [ ] Captain is removable

**Browser Console**:
- [ ] No JavaScript errors
- [ ] API calls use correct table/column names
- [ ] All requests return 200 status

---

## Report Template

After completing tests, report results using this format:

```
SUPERADMIN DASHBOARD TEST RESULTS
Date: [YYYY-MM-DD]
Tester: [Name]
Browser: [Chrome/Firefox/Edge] [Version]

PASSED TESTS:
- [✓] Test 1.1: OAuth Redirect
- [✓] Test 2.1: Demote SK Official
- ...

FAILED TESTS:
- [✗] Test X.X: [Description]
  Issue: [Details]
  Console Error: [Error message]
  Expected: [Expected behavior]
  Actual: [Actual behavior]

BUGS FOUND:
1. [Bug description]
   - Severity: [Critical/High/Medium/Low]
   - Steps to reproduce: [Steps]
   - Suggested fix: [If known]

OVERALL STATUS: [PASS/FAIL]
```
