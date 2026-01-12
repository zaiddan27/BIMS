# BIMS Authentication & Dashboard Testing Guide

**Date:** 2026-01-10
**Phase:** Phase 3 - Core Features Implementation
**Status:** Testing Authentication System

---

## Test 1: Superadmin Login & Redirection

### Prerequisites
- You have a SUPERADMIN user in your database
- You know the email and password

### Steps
1. Open `login.html` in your browser
2. Enter your SUPERADMIN email and password
3. Click "Sign In"

### Expected Results
✅ Login successful toast message shows
✅ Should display: "Welcome back, [YourName]! Redirecting..."
✅ Automatically redirects to `superadmin-dashboard.html`
✅ Dashboard loads without errors

### Check Browser Console
Open Developer Tools (F12) → Console tab. You should see:
```
🚀 Initializing Superadmin Dashboard...
✅ Session initialized: SUPERADMIN
✅ User profile loaded
📊 Loading dashboard statistics...
✅ Dashboard statistics loaded
✅ Superadmin Dashboard loaded successfully!
```

### If Login Fails
**Error: "User profile not found"**
- Check that user exists in User_Tbl with matching userID
- Verify User_Tbl has firstName, lastName, role, accountStatus columns

**Error: "Account is pending approval"**
- Your SUPERADMIN account status is PENDING or INACTIVE
- Run this SQL in Supabase SQL Editor:
```sql
UPDATE "User_Tbl"
SET "accountStatus" = 'ACTIVE'
WHERE email = 'your-email@example.com';
```

**Error: "Could not fetch user data from database"**
- RLS policies might be blocking access
- Check Supabase logs for detailed error

---

## Test 2: Dashboard Data Loading

### Check Statistics Cards
After login, verify the dashboard shows real numbers:

1. **Total Users Card** (Blue)
   - Should show actual count of users in User_Tbl
   - Check with SQL: `SELECT COUNT(*) FROM "User_Tbl";`

2. **Total Projects Card** (Green)
   - Should show actual count of projects in Pre_Project_Tbl
   - Check with SQL: `SELECT COUNT(*) FROM "Pre_Project_Tbl";`

3. **Active Announcements Card** (Orange)
   - Should show count of active announcements
   - Check with SQL: `SELECT COUNT(*) FROM "Announcement_Tbl" WHERE "contentStatus" = 'ACTIVE';`

4. **Total Logs Card** (Purple)
   - Should show count of logs
   - Check with SQL: `SELECT COUNT(*) FROM "Logs_Tbl";`

### Expected Results
✅ All cards show numbers (even if 0)
✅ Numbers match database counts
✅ No "NaN" or "undefined" displayed

### If Data Doesn't Load
**Shows 0 but you have data:**
- Check browser console for errors
- RLS policies might be blocking SELECT queries
- Verify table names match exactly (case-sensitive)

**Shows "undefined" or "NaN":**
- Element IDs might not match
- Check that these IDs exist in HTML:
  - `statsUsers`
  - `statsProjects`
  - `statsAnnouncements`
  - `statsLogs`

---

## Test 3: Auth Guard Protection

### Test Direct Access (Not Logged In)
1. Open a new incognito/private browser window
2. Try to access `superadmin-dashboard.html` directly
3. Paste URL: `http://localhost:PORT/superadmin-dashboard.html`

### Expected Results
✅ Should NOT see dashboard
✅ Should automatically redirect to `login.html`
✅ Console shows: "⚠️ No active session. Redirecting to login..."

### Test Wrong Role Access
If you have a YOUTH_VOLUNTEER account:
1. Login with youth volunteer credentials
2. Manually change URL to `superadmin-dashboard.html`

### Expected Results
✅ Should redirect to `youth-dashboard.html` (correct dashboard for role)
✅ Console shows: "⚠️ Access denied. User role: YOUTH_VOLUNTEER, Required: SUPERADMIN"

---

## Test 4: User Profile Display

### Check Header Profile
After logging in to superadmin dashboard:

1. Look for profile section in header (usually top-right)
2. Should show your name
3. Should show "System Administrator" as role

### Expected Results
✅ Displays your first and last name
✅ Displays "System Administrator"
✅ No "undefined" or "null" text

### If Profile Doesn't Show
- Element selectors might not match your HTML structure
- Check console for errors in `loadUserProfile()` function
- Profile elements might have different IDs/classes

---

## Test 5: Session Persistence

### Test Page Refresh
1. Login to superadmin dashboard
2. Refresh the page (F5 or Ctrl+R)

### Expected Results
✅ Stays logged in
✅ Dashboard reloads successfully
✅ Data loads again
✅ No redirect to login

### Test Browser Restart
1. Close ALL browser windows
2. Reopen browser
3. Go to `superadmin-dashboard.html`

### Expected Results
✅ Should stay logged in (Supabase session persists)
✅ Dashboard loads normally

---

## Common Issues & Solutions

### Issue: "supabaseClient is not defined"
**Solution:** Check that these scripts are loaded in order:
```html
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<script src="js/config/env.js"></script>
<script src="js/config/supabase.js"></script>
<script src="js/auth/session.js"></script>
```

### Issue: "SessionManager is not defined"
**Solution:** session.js must load before the auth guard code runs

### Issue: Infinite redirect loop
**Solution:**
- Check that User_Tbl role matches expected role
- Verify accountStatus is 'ACTIVE', not 'PENDING'
- Check browser console for specific error

### Issue: CORS errors
**Solution:**
- Must access via http://localhost, not file://
- Check Supabase URL and anon key in env.js

### Issue: RLS "permission denied" errors
**Solution:**
- RLS policies might be too restrictive
- Check Supabase → Authentication → Policies
- Verify policies allow authenticated users to read their own data

---

## Success Checklist

Mark each item as you verify:

- [ ] Login redirects to correct dashboard
- [ ] Statistics show real numbers (not 0 if data exists)
- [ ] User profile displays name and role
- [ ] Direct access when logged out redirects to login
- [ ] Wrong role access redirects to correct dashboard
- [ ] Page refresh keeps user logged in
- [ ] No console errors
- [ ] All data loads without warnings

---

## Next Steps After Testing

If all tests pass:
✅ Authentication system is working correctly
✅ Ready to add auth guards to remaining dashboards
✅ Can proceed with Phase 3 implementation

If tests fail:
⚠️ Review error messages in console
⚠️ Check TESTING_GUIDE.md troubleshooting section
⚠️ Verify database migrations ran correctly
⚠️ Check RLS policies in Supabase

---

**Last Updated:** 2026-01-10
**Document Status:** Active - Phase 3 Testing
