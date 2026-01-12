# Step-by-Step Guide: Create Dummy SK Official Account

**Purpose**: Create a test SK Official account for development and testing
**Time Required**: 5-10 minutes
**Difficulty**: Easy

---

## Prerequisites

- ✅ Access to Supabase Dashboard
- ✅ Database tables created (user_tbl, sk_officials)
- ✅ Admin/Owner access to the Supabase project

---

## Method 1: Using Supabase Dashboard (RECOMMENDED)

This is the easiest and safest method.

### Step 1: Create Authentication User

1. Open your Supabase Dashboard
2. Navigate to **Authentication** → **Users**
3. Click the **"Add User"** button
4. Fill in the form:
   - **Email**: `sk.official.test@bims.com`
   - **Password**: `SKTest123!@#` (or your choice)
   - **Auto Confirm User**: ✅ **YES** (check this box)
5. Click **"Create User"**
6. **IMPORTANT**: Copy the **User UID** (UUID) from the created user
   - It looks like: `a1b2c3d4-e5f6-7890-abcd-ef1234567890`
   - Save it somewhere, you'll need it in the next steps

### Step 2: Add User to user_tbl

1. In Supabase Dashboard, go to **SQL Editor**
2. Click **"New Query"**
3. Paste the following SQL (replace `YOUR_USER_UUID_HERE` with the UUID from Step 1):

```sql
INSERT INTO user_tbl (
  userid,
  email,
  firstname,
  lastname,
  middlename,
  role,
  birthday,
  contactnumber,
  address,
  termsconditions,
  accountstatus
)
VALUES (
  'YOUR_USER_UUID_HERE', -- Replace with actual UUID
  'sk.official.test@bims.com',
  'Andrea',
  'Pelias',
  'Santos',
  'SK_OFFICIAL',
  '1998-05-15',
  '+639171234567',
  'Blk 10 Lot 5, Malanday, Marikina City',
  true,
  'ACTIVE'
);
```

4. Click **"Run"** or press `Ctrl + Enter`
5. You should see: **"Success. No rows returned"**

### Step 3: Add SK Official Record

1. In the same SQL Editor, create a new query
2. Paste the following SQL (use the same UUID):

```sql
INSERT INTO sk_officials (
  userid,
  position,
  termstart,
  termend
)
VALUES (
  'YOUR_USER_UUID_HERE', -- Same UUID as Step 2
  'SK_CHAIRMAN',
  '2024-01-01',
  '2026-12-31'
);
```

3. Click **"Run"**
4. You should see: **"Success. No rows returned"**

### Step 4: Verify Account Creation

Run this verification query:

```sql
SELECT
  u.userid,
  u.email,
  u.firstname,
  u.lastname,
  u.role,
  u.accountstatus,
  so.position,
  so.termstart,
  so.termend
FROM user_tbl u
LEFT JOIN sk_officials so ON u.userid = so.userid
WHERE u.email = 'sk.official.test@bims.com';
```

**Expected Result**:
```
userid: a1b2c3d4-e5f6-7890-abcd-ef1234567890
email: sk.official.test@bims.com
firstname: Andrea
lastname: Pelias
role: SK_OFFICIAL
accountstatus: ACTIVE
position: SK_CHAIRMAN
termstart: 2024-01-01
termend: 2026-12-31
```

### Step 5: Test Login

1. Open your BIMS application
2. Go to login page
3. Enter credentials:
   - **Email**: `sk.official.test@bims.com`
   - **Password**: `SKTest123!@#` (or whatever you set)
4. Click **Login**
5. You should be redirected to **SK Dashboard**

---

## Method 2: Using SQL Only (Advanced)

⚠️ **Warning**: This method requires admin privileges and may not work if RLS policies are strict.

### Single SQL Script

```sql
-- Create auth user
DO $$
DECLARE
  new_user_id UUID;
BEGIN
  -- Generate UUID
  new_user_id := gen_random_uuid();

  -- Insert into auth.users
  INSERT INTO auth.users (
    id,
    email,
    encrypted_password,
    email_confirmed_at,
    created_at,
    updated_at,
    raw_app_meta_data,
    raw_user_meta_data,
    is_super_admin,
    role
  )
  VALUES (
    new_user_id,
    'sk.official.test@bims.com',
    crypt('SKTest123!@#', gen_salt('bf')),
    now(),
    now(),
    now(),
    '{"provider":"email","providers":["email"]}',
    '{}',
    false,
    'authenticated'
  );

  -- Insert into user_tbl
  INSERT INTO user_tbl (
    userid,
    email,
    firstname,
    lastname,
    middlename,
    role,
    birthday,
    contactnumber,
    address,
    termsconditions,
    accountstatus
  )
  VALUES (
    new_user_id,
    'sk.official.test@bims.com',
    'Andrea',
    'Pelias',
    'Santos',
    'SK_OFFICIAL',
    '1998-05-15',
    '+639171234567',
    'Blk 10 Lot 5, Malanday, Marikina City',
    true,
    'ACTIVE'
  );

  -- Insert into sk_officials
  INSERT INTO sk_officials (
    userid,
    position,
    termstart,
    termend
  )
  VALUES (
    new_user_id,
    'SK_CHAIRMAN',
    '2024-01-01',
    '2026-12-31'
  );

  RAISE NOTICE 'User created with ID: %', new_user_id;
END $$;
```

---

## Create Multiple Test Accounts

### SK Secretary

**Step 1**: Create auth user in Dashboard
- Email: `sk.secretary.test@bims.com`
- Password: `SKTest123!@#`
- Auto Confirm: YES
- Copy UUID

**Step 2**: Run SQL (replace UUID):
```sql
INSERT INTO user_tbl (
  userid, email, firstname, lastname, middlename, role, birthday,
  contactnumber, address, termsconditions, accountstatus
)
VALUES (
  'YOUR_UUID_HERE',
  'sk.secretary.test@bims.com',
  'Maria', 'Cruz', 'Lopez',
  'SK_OFFICIAL', '1999-08-22',
  '+639181234568', 'Blk 15 Lot 3, Malanday, Marikina City',
  true, 'ACTIVE'
);

INSERT INTO sk_officials (userid, position, termstart, termend)
VALUES ('YOUR_UUID_HERE', 'SK_SECRETARY', '2024-01-01', '2026-12-31');
```

### SK Treasurer

**Step 1**: Create auth user
- Email: `sk.treasurer.test@bims.com`
- Password: `SKTest123!@#`

**Step 2**: Run SQL:
```sql
INSERT INTO user_tbl (
  userid, email, firstname, lastname, middlename, role, birthday,
  contactnumber, address, termsconditions, accountstatus
)
VALUES (
  'YOUR_UUID_HERE',
  'sk.treasurer.test@bims.com',
  'Juan', 'Reyes', 'Santos',
  'SK_OFFICIAL', '1997-12-10',
  '+639191234569', 'Blk 20 Lot 8, Malanday, Marikina City',
  true, 'ACTIVE'
);

INSERT INTO sk_officials (userid, position, termstart, termend)
VALUES ('YOUR_UUID_HERE', 'SK_TREASURER', '2024-01-01', '2026-12-31');
```

---

## Test Account Credentials

| Email | Password | Role | Position |
|-------|----------|------|----------|
| sk.official.test@bims.com | SKTest123!@# | SK_OFFICIAL | SK_CHAIRMAN |
| sk.secretary.test@bims.com | SKTest123!@# | SK_OFFICIAL | SK_SECRETARY |
| sk.treasurer.test@bims.com | SKTest123!@# | SK_OFFICIAL | SK_TREASURER |

---

## Troubleshooting

### Error: "User with this email already exists"

**Solution 1**: Use a different email
```sql
-- Change the email in all queries
'sk.official.test2@bims.com'
```

**Solution 2**: Delete existing user
```sql
-- In SQL Editor
DELETE FROM sk_officials WHERE userid IN (
  SELECT userid FROM user_tbl WHERE email = 'sk.official.test@bims.com'
);
DELETE FROM user_tbl WHERE email = 'sk.official.test@bims.com';
-- Then delete from Authentication > Users in Dashboard
```

### Error: "Foreign key constraint violation"

**Cause**: The userid doesn't exist in auth.users

**Solution**: Make sure you created the auth user FIRST (Step 1) before running the SQL inserts

### Error: "Permission denied for table user_tbl"

**Cause**: RLS (Row Level Security) policies are blocking the insert

**Solution**: Temporarily disable RLS (use with caution):
```sql
ALTER TABLE user_tbl DISABLE ROW LEVEL SECURITY;
ALTER TABLE sk_officials DISABLE ROW LEVEL SECURITY;

-- Run your INSERT statements

ALTER TABLE user_tbl ENABLE ROW LEVEL SECURITY;
ALTER TABLE sk_officials ENABLE ROW LEVEL SECURITY;
```

### Error: "Cannot login with test account"

**Checklist**:
- [ ] Is `accountstatus` set to `'ACTIVE'`?
- [ ] Is email confirmed in auth.users?
- [ ] Is the password correct?
- [ ] Does the role match `'SK_OFFICIAL'`?
- [ ] Is there a matching record in sk_officials table?

**Verification Query**:
```sql
SELECT
  u.userid,
  u.email,
  u.accountstatus,
  u.role,
  so.position,
  au.email_confirmed_at,
  au.last_sign_in_at
FROM user_tbl u
LEFT JOIN sk_officials so ON u.userid = so.userid
LEFT JOIN auth.users au ON u.userid = au.id
WHERE u.email = 'sk.official.test@bims.com';
```

### Cannot access sk-dashboard.html

**Cause**: Session not recognizing SK_OFFICIAL role

**Solution**:
1. Clear browser cache and localStorage
2. Logout completely
3. Login again with test account
4. Check browser console for errors

---

## Cleanup / Delete Test Accounts

When you're done testing and want to remove test accounts:

### Step 1: Delete from sk_officials
```sql
DELETE FROM sk_officials
WHERE userid IN (
  SELECT userid FROM user_tbl WHERE email LIKE '%test@bims.com'
);
```

### Step 2: Delete from user_tbl
```sql
DELETE FROM user_tbl
WHERE email LIKE '%test@bims.com';
```

### Step 3: Delete from Authentication
1. Go to Dashboard → Authentication → Users
2. Find users with email containing "test@bims.com"
3. Click the three dots → Delete User
4. Confirm deletion

---

## Quick Reference

### Account Structure
```
auth.users (Supabase Auth)
    ↓ (userid)
user_tbl (User Profile)
    ↓ (userid)
sk_officials (SK Official Data)
```

### Required Fields

**user_tbl**:
- userid (UUID, from auth.users)
- email (unique)
- firstname, lastname (Title Case)
- role ('SK_OFFICIAL')
- birthday (YYYY-MM-DD)
- contactnumber (+639XXXXXXXXX)
- address (text)
- termsconditions (true)
- accountstatus ('ACTIVE')

**sk_officials**:
- userid (FK to user_tbl)
- position (SK_CHAIRMAN, SK_SECRETARY, SK_TREASURER, SK_KAGAWAD)
- termstart (DATE)
- termend (DATE)

---

## Position Constraints

### Single Active Account (Only ONE at a time):
- SK_CHAIRMAN ⚠️
- SK_SECRETARY ⚠️
- SK_TREASURER ⚠️

### Multiple Active Accounts:
- SK_KAGAWAD (Maximum 7) ✅

**Note**: If creating a second SK_CHAIRMAN, set the old one's accountstatus to 'INACTIVE' first.

---

## Security Notes

⚠️ **Development Only**: These test accounts should ONLY be used in development/staging environments.

⚠️ **Never in Production**: Delete all test accounts before deploying to production.

⚠️ **Password Security**: Use strong passwords for production accounts.

⚠️ **RLS Policies**: Ensure Row Level Security is enabled in production.

---

## Next Steps After Creating Account

1. ✅ Login to SK Dashboard
2. ✅ Test creating announcements
3. ✅ Test image upload
4. ✅ Verify user profile displays correctly
5. ✅ Test logout functionality
6. ✅ Test session persistence (refresh page)

---

## Support

If you encounter issues not covered in this guide:

1. Check the browser console for JavaScript errors
2. Check Supabase logs in Dashboard → Logs
3. Verify database schema matches CLAUDE.md specifications
4. Check RLS policies are not blocking operations
5. Review SK_DASHBOARD_INTEGRATION.md for implementation details

---

**Last Updated**: 2026-01-11
**Status**: Ready to Use ✅
