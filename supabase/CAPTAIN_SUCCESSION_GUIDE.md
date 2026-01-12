# Barangay Captain Term Management & Succession

## Overview

The BIMS system now tracks Barangay Captain terms with automatic expiration warnings and a smooth succession process.

## Captain_Tbl Structure

```sql
Captain_Tbl
├── captainID (SERIAL PRIMARY KEY)
├── userID (UUID) - References User_Tbl
├── termStart (DATE) - When the term started
├── termEnd (DATE) - When the term expires
├── isActive (BOOLEAN) - Only ONE active Captain at a time
├── createdAt (TIMESTAMP)
└── updatedAt (TIMESTAMP)
```

## Key Features

### 1. **Only One Active Captain**
- The database enforces that only ONE Captain can be active (`isActive = TRUE`) at any time
- Prevents overlapping Captain terms

### 2. **Term Expiration Warnings**
The Admin Panel automatically checks for:
- ⚠️ **30-Day Warning**: Shown when Captain's term expires within 30 days
- 🚨 **CRITICAL Alert**: Shown when Captain's term has already expired

### 3. **Automatic Succession**
When a new Captain is designated:
1. Old Captain's term is deactivated (`isActive = FALSE`)
2. Old Captain's role changes to `YOUTH_VOLUNTEER`
3. New Captain's role changes to `CAPTAIN`
4. New Captain term is created with `isActive = TRUE`
5. Notifications sent to both users
6. Audit logs created for both changes

---

## How to Designate a New Captain

### Method 1: Via SQL (Supabase SQL Editor)

```sql
-- Designate John Doe as the new Captain
-- Term: January 1, 2026 - December 31, 2028 (3 years)
SELECT designate_new_captain(
  'user-uuid-here'::UUID,     -- New Captain's userID
  '2026-01-01'::DATE,          -- Term start date
  '2028-12-31'::DATE           -- Term end date (3 years later)
);
```

**Step-by-step:**

1. Go to Supabase Dashboard → SQL Editor
2. Get the new Captain's `userID`:
   ```sql
   SELECT userID, firstName, lastName, email, role
   FROM User_Tbl
   WHERE email = 'newcaptain@email.com';
   ```
3. Run the `designate_new_captain()` function with the userID and term dates
4. The function will automatically:
   - Deactivate the old Captain
   - Change old Captain to Youth Volunteer
   - Set new Captain role to CAPTAIN
   - Create term record
   - Send notifications
   - Create audit logs

### Method 2: Via Supabase Dashboard (Manual)

If the function doesn't work, you can do it manually:

1. **Find the Old Captain:**
   ```sql
   SELECT * FROM Captain_Tbl WHERE isActive = TRUE;
   ```

2. **Deactivate Old Captain Term:**
   ```sql
   UPDATE Captain_Tbl
   SET isActive = FALSE
   WHERE userID = 'old-captain-uuid';
   ```

3. **Change Old Captain's Role:**
   ```sql
   UPDATE User_Tbl
   SET role = 'YOUTH_VOLUNTEER'
   WHERE userID = 'old-captain-uuid';
   ```

4. **Set New Captain's Role:**
   ```sql
   UPDATE User_Tbl
   SET role = 'CAPTAIN', accountStatus = 'ACTIVE'
   WHERE userID = 'new-captain-uuid';
   ```

5. **Create New Captain Term:**
   ```sql
   INSERT INTO Captain_Tbl (userID, termStart, termEnd, isActive)
   VALUES (
     'new-captain-uuid',
     '2026-01-01',
     '2028-12-31',
     TRUE
   );
   ```

---

## Checking Captain Term Status

### Via SQL Function

```sql
-- Check current Captain's term status
SELECT * FROM check_captain_term_expiration();
```

Returns:
- Captain's name and email
- Term end date
- Days remaining until expiration
- Whether term has expired

### Via Admin Panel UI

1. Log in as Captain
2. Go to **Admin Panel** tab
3. If the Captain's term is expiring within 30 days or has expired, a **red warning banner** will appear at the top showing:
   - Captain name
   - Term end date
   - Days remaining or expiration notice

---

## Real-World Workflow

### Scenario: SK Elections Every 3 Years

**Before Election:**
1. Current Captain's term is expiring (30-day warning appears)
2. Elections are held in the barangay
3. New Captain is elected

**After Election:**
1. System administrator runs `designate_new_captain()` with:
   - New Captain's userID (from User_Tbl)
   - New term start date (e.g., January 1, 2026)
   - New term end date (3 years later: December 31, 2028)

2. System automatically:
   - Deactivates old Captain
   - Changes old Captain to Youth Volunteer (they can still use the system)
   - Activates new Captain with full admin privileges
   - Creates audit trail for transparency

**Result:**
- Smooth succession with no data loss
- Old Captain can still volunteer or become SK Official
- Historical record of all Captains preserved in Captain_Tbl

---

## Important Notes

### **Captain Cannot Be Deleted**
- Captains should NEVER be deleted from the database
- When term ends, they are automatically downgraded to `YOUTH_VOLUNTEER`
- They retain their User_Tbl record and can continue participating as volunteers
- Historical record is preserved

### **Only One Active Captain**
- Database enforces this with UNIQUE constraint on `isActive`
- If you try to have 2 active Captains, the database will reject it

### **Captain Cannot Deactivate Themselves**
- RLS policies prevent Captains from changing their own account status
- This prevents accidental self-lockout

### **Term Dates Are Important**
- Standard term: 3 years (e.g., Jan 1, 2026 - Dec 31, 2028)
- System checks these dates to show expiration warnings
- Plan succession at least 30 days before term ends

---

## Troubleshooting

### Problem: "No active Captain found"
**Solution:**
```sql
-- Check if Captain_Tbl has any records
SELECT * FROM Captain_Tbl;

-- If empty, insert first Captain manually
INSERT INTO Captain_Tbl (userID, termStart, termEnd, isActive)
VALUES (
  'first-captain-uuid',
  '2024-01-01',
  '2026-12-31',
  TRUE
);
```

### Problem: "Multiple active Captains"
**Solution:**
```sql
-- Find all active Captains
SELECT * FROM Captain_Tbl WHERE isActive = TRUE;

-- Keep only the latest one, deactivate others
UPDATE Captain_Tbl
SET isActive = FALSE
WHERE captainID != (SELECT MAX(captainID) FROM Captain_Tbl WHERE isActive = TRUE);
```

### Problem: "Captain term warning not showing"
**Solution:**
- Check if Captain_Tbl has an active record
- Verify termEnd date is within 30 days
- Refresh the Admin Panel tab
- Check browser console for JavaScript errors

---

## Summary

✅ **Captain terms are now tracked** in Captain_Tbl
✅ **Automatic expiration warnings** (30 days before)
✅ **Smooth succession process** via `designate_new_captain()`
✅ **Audit trail** for all Captain changes
✅ **Historical records** of all Captains preserved
✅ **UI warnings** in Admin Panel when term expiring

This ensures proper governance and transparency in barangay leadership transitions!
