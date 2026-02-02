-- ============================================
-- Create Captain Test Account for QA
-- Run this in the Supabase SQL Editor
-- ============================================

-- Step 1: Create the auth user
-- Go to Supabase Dashboard > Authentication > Users > Add User
-- Email:    captain.test@bims.ph
-- Password: captain@2026
-- Click "Auto Confirm User" checkbox

-- Step 2: After creating the auth user, get the UUID and insert into User_Tbl + Captain_Tbl
-- Replace 'YOUR_UUID_HERE' with the UUID from Step 1

DO $$
DECLARE
  v_user_id UUID;
BEGIN
  -- Get the UUID of the auth user just created
  SELECT id INTO v_user_id
  FROM auth.users
  WHERE email = 'captain.test@bims.ph';

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Auth user captain.test@bims.ph not found. Create it in Authentication > Users first.';
  END IF;

  -- Insert into User_Tbl
  INSERT INTO "User_Tbl" (
    "userID", email, "firstName", "lastName", "middleName",
    role, birthday, "contactNumber", address,
    "termsConditions", "accountStatus"
  ) VALUES (
    v_user_id,
    'captain.test@bims.ph',
    'Gavin',
    'Santos',
    NULL,
    'CAPTAIN',
    '1985-06-15',
    '09171234567',
    'Barangay Malanday, Marikina City',
    TRUE,
    'ACTIVE'
  )
  ON CONFLICT ("userID") DO UPDATE SET
    role = 'CAPTAIN',
    "accountStatus" = 'ACTIVE';

  -- Insert into Captain_Tbl
  INSERT INTO "Captain_Tbl" ("userID", "termStart", "termEnd", "isActive")
  VALUES (
    v_user_id,
    '2025-01-01'::DATE,
    '2028-12-31'::DATE,
    TRUE
  )
  ON CONFLICT DO NOTHING;

  RAISE NOTICE 'Captain test account created successfully! UUID: %', v_user_id;
END $$;

-- Step 3: Verify
SELECT
  u."userID",
  u.email,
  u."firstName" || ' ' || u."lastName" AS full_name,
  u.role,
  u."accountStatus",
  c."captainID",
  c."termStart",
  c."termEnd",
  c."isActive"
FROM "User_Tbl" u
LEFT JOIN "Captain_Tbl" c ON u."userID" = c."userID"
WHERE u.email = 'captain.test@bims.ph';

-- ============================================
-- QA Login Credentials:
--   Email:    captain.test@bims.ph
--   Password: captain@2026
--   Role:     CAPTAIN
-- ============================================
