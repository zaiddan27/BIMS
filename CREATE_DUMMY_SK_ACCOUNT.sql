-- ============================================
-- CREATE DUMMY SK OFFICIAL ACCOUNT
-- ============================================
-- Run this in Supabase SQL Editor
-- This creates a test SK Official account for development/testing
-- ============================================

-- STEP 1: Create Auth User (via Supabase Auth - Use Dashboard or API)
-- You MUST create the auth user first using Supabase Dashboard or Auth API
-- Go to: Authentication > Users > Add User
-- Email: sk.official.test@bims.com
-- Password: SKTest123!@# (or your choice)
-- After creating, note down the UUID (will be used below)

-- OR use this SQL to create auth user (requires admin privileges):
-- This creates the user in auth.users table
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
  gen_random_uuid(), -- Generates a random UUID
  'sk.official.test@bims.com',
  crypt('SKTest123!@#', gen_salt('bf')), -- Hashed password using bcrypt
  now(),
  now(),
  now(),
  '{"provider":"email","providers":["email"]}',
  '{}',
  false,
  'authenticated'
)
RETURNING id;

-- ============================================
-- ALTERNATIVE: Simpler method using Supabase Dashboard
-- ============================================
-- 1. Go to Supabase Dashboard > Authentication > Users
-- 2. Click "Add User"
-- 3. Enter:
--    Email: sk.official.test@bims.com
--    Password: SKTest123!@#
--    Auto Confirm: YES
-- 4. Copy the UUID from the created user
-- 5. Replace 'YOUR_USER_UUID_HERE' below with the actual UUID

-- ============================================
-- STEP 2: Insert into user_tbl
-- ============================================
-- Replace 'YOUR_USER_UUID_HERE' with the UUID from Step 1

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
  imagepathurl,
  termsconditions,
  accountstatus,
  createdat,
  updatedat
)
VALUES (
  'YOUR_USER_UUID_HERE', -- Replace with actual UUID from auth.users
  'sk.official.test@bims.com',
  'Andrea', -- First name (Title Case)
  'Pelias', -- Last name (Title Case)
  'Santos', -- Middle name (Title Case)
  'SK_OFFICIAL', -- Role enum
  '1998-05-15', -- Birthday (YYYY-MM-DD)
  '+639171234567', -- Contact number (Philippine format)
  'Blk 10 Lot 5, Malanday, Marikina City', -- Address
  NULL, -- Image path (optional)
  true, -- Terms and conditions accepted
  'ACTIVE', -- Account status (ACTIVE for immediate use)
  now(),
  now()
);

-- ============================================
-- STEP 3: Insert into sk_officials (SK_Tbl)
-- ============================================
-- Creates SK Official record linking to the user

INSERT INTO sk_officials (
  userid,
  position,
  termstart,
  termend,
  createdat,
  updatedat
)
VALUES (
  'YOUR_USER_UUID_HERE', -- Same UUID as above
  'SK_CHAIRMAN', -- Position: SK_CHAIRMAN, SK_SECRETARY, SK_TREASURER, SK_KAGAWAD
  '2024-01-01', -- Term start date
  '2026-12-31', -- Term end date (usually 3 years)
  now(),
  now()
);

-- ============================================
-- VERIFICATION QUERIES
-- ============================================
-- Run these to verify the account was created successfully

-- Check if user exists in user_tbl
SELECT
  userid,
  email,
  firstname,
  lastname,
  role,
  accountstatus
FROM user_tbl
WHERE email = 'sk.official.test@bims.com';

-- Check if SK official record exists
SELECT
  so.skid,
  so.userid,
  so.position,
  so.termstart,
  so.termend,
  u.firstname,
  u.lastname,
  u.email
FROM sk_officials so
JOIN user_tbl u ON so.userid = u.userid
WHERE u.email = 'sk.official.test@bims.com';

-- ============================================
-- CREATE MULTIPLE SK OFFICIALS (OPTIONAL)
-- ============================================
-- If you need multiple SK officials for testing

-- SK Secretary
-- First create auth user in Dashboard, then run:
INSERT INTO user_tbl (
  userid, email, firstname, lastname, middlename, role, birthday,
  contactnumber, address, termsconditions, accountstatus
)
VALUES (
  'YOUR_SECRETARY_UUID_HERE',
  'sk.secretary.test@bims.com',
  'Maria', 'Cruz', 'Lopez',
  'SK_OFFICIAL', '1999-08-22',
  '+639181234568', 'Blk 15 Lot 3, Malanday, Marikina City',
  true, 'ACTIVE'
);

INSERT INTO sk_officials (userid, position, termstart, termend)
VALUES ('YOUR_SECRETARY_UUID_HERE', 'SK_SECRETARY', '2024-01-01', '2026-12-31');

-- SK Treasurer
INSERT INTO user_tbl (
  userid, email, firstname, lastname, middlename, role, birthday,
  contactnumber, address, termsconditions, accountstatus
)
VALUES (
  'YOUR_TREASURER_UUID_HERE',
  'sk.treasurer.test@bims.com',
  'Juan', 'Reyes', 'Santos',
  'SK_OFFICIAL', '1997-12-10',
  '+639191234569', 'Blk 20 Lot 8, Malanday, Marikina City',
  true, 'ACTIVE'
);

INSERT INTO sk_officials (userid, position, termstart, termend)
VALUES ('YOUR_TREASURER_UUID_HERE', 'SK_TREASURER', '2024-01-01', '2026-12-31');

-- SK Kagawad 1
INSERT INTO user_tbl (
  userid, email, firstname, lastname, middlename, role, birthday,
  contactnumber, address, termsconditions, accountstatus
)
VALUES (
  'YOUR_KAGAWAD1_UUID_HERE',
  'sk.kagawad1.test@bims.com',
  'Pedro', 'Garcia', 'Fernandez',
  'SK_OFFICIAL', '2000-03-18',
  '+639201234570', 'Blk 25 Lot 12, Malanday, Marikina City',
  true, 'ACTIVE'
);

INSERT INTO sk_officials (userid, position, termstart, termend)
VALUES ('YOUR_KAGAWAD1_UUID_HERE', 'SK_KAGAWAD', '2024-01-01', '2026-12-31');

-- ============================================
-- CLEANUP QUERIES (if needed)
-- ============================================
-- Use these to delete test accounts if needed

-- Delete SK official record
DELETE FROM sk_officials
WHERE userid IN (
  SELECT userid FROM user_tbl WHERE email LIKE '%test@bims.com'
);

-- Delete user record
DELETE FROM user_tbl
WHERE email LIKE '%test@bims.com';

-- Note: You must also delete from auth.users manually via Dashboard
-- Or use: DELETE FROM auth.users WHERE email LIKE '%test@bims.com';

-- ============================================
-- POSITION CONSTRAINTS REFERENCE
-- ============================================
-- Single Active Account Positions (Only ONE active at a time):
--   - SK_CHAIRMAN
--   - SK_SECRETARY
--   - SK_TREASURER
--
-- Multiple Active Account Position:
--   - SK_KAGAWAD (Maximum 7 active accounts)
--
-- If creating duplicate positions, set older accounts to:
--   accountstatus = 'INACTIVE'

-- ============================================
-- TROUBLESHOOTING
-- ============================================

-- Q: "Cannot insert duplicate key" error?
-- A: User with that email already exists. Use different email or delete existing user.

-- Q: "Foreign key violation" error?
-- A: The userid doesn't exist in auth.users. Create auth user first.

-- Q: "Permission denied" error?
-- A: Check RLS policies. You may need to temporarily disable RLS:
--    ALTER TABLE user_tbl DISABLE ROW LEVEL SECURITY;
--    (Run your inserts)
--    ALTER TABLE user_tbl ENABLE ROW LEVEL SECURITY;

-- Q: Can't login with test account?
-- A: Ensure accountstatus is 'ACTIVE' and email is confirmed in auth.users

-- ============================================
-- NOTES
-- ============================================
-- 1. All names (firstname, lastname, middlename) are stored in Title Case
-- 2. Email must be unique across all users
-- 3. Contact number format: +639XXXXXXXXX (Philippine mobile)
-- 4. Account status must be 'ACTIVE' to allow login
-- 5. Birthday format: YYYY-MM-DD
-- 6. Terms & conditions must be true
-- 7. Role must match ENUM: 'SK_OFFICIAL', 'YOUTH_VOLUNTEER', 'CAPTAIN'

-- ============================================
-- RECOMMENDED: Use Supabase Dashboard Method
-- ============================================
-- The easiest and safest way:
-- 1. Create user in Authentication > Users (auto-generates UUID and hashes password)
-- 2. Copy the UUID
-- 3. Run only the user_tbl and sk_officials INSERT statements
-- 4. Verify with SELECT queries
