-- ============================================
-- ONE-STEP SK OFFICIAL ACCOUNT CREATION
-- ============================================
-- This script creates everything in one go
-- Run this in Supabase SQL Editor
-- ============================================

DO $$
DECLARE
  new_user_id UUID;
BEGIN
  -- Step 1: Generate a new UUID
  new_user_id := gen_random_uuid();

  RAISE NOTICE 'Creating user with UUID: %', new_user_id;

  -- Step 2: Create auth user
  INSERT INTO auth.users (
    instance_id,
    id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    invited_at,
    confirmation_token,
    confirmation_sent_at,
    recovery_token,
    recovery_sent_at,
    email_change_token_new,
    email_change,
    email_change_sent_at,
    last_sign_in_at,
    raw_app_meta_data,
    raw_user_meta_data,
    is_super_admin,
    created_at,
    updated_at,
    phone,
    phone_confirmed_at,
    phone_change,
    phone_change_token,
    phone_change_sent_at,
    email_change_token_current,
    email_change_confirm_status,
    banned_until,
    reauthentication_token,
    reauthentication_sent_at,
    is_sso_user,
    deleted_at
  ) VALUES (
    '00000000-0000-0000-0000-000000000000',
    new_user_id,
    'authenticated',
    'authenticated',
    'sk.official.test@bims.com',
    crypt('SKTest123!@#', gen_salt('bf')), -- Password hashed with bcrypt
    NOW(), -- Email confirmed (so user can login immediately)
    NULL,
    '',
    NULL,
    '',
    NULL,
    '',
    '',
    NULL,
    NULL,
    '{"provider":"email","providers":["email"]}',
    '{}',
    FALSE,
    NOW(),
    NOW(),
    NULL,
    NULL,
    '',
    '',
    NULL,
    '',
    0,
    NULL,
    '',
    NULL,
    FALSE,
    NULL
  );

  -- Step 3: Insert into user_tbl
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
  ) VALUES (
    new_user_id,
    'sk.official.test@bims.com',
    'Andrea',
    'Pelias',
    'Santos',
    'SK_OFFICIAL',
    '1998-05-15',
    '+639171234567',
    'Blk 10 Lot 5, Malanday, Marikina City',
    TRUE,
    'ACTIVE'
  );

  -- Step 4: Insert into sk_officials
  INSERT INTO sk_officials (
    userid,
    position,
    termstart,
    termend
  ) VALUES (
    new_user_id,
    'SK_CHAIRMAN',
    '2024-01-01',
    '2026-12-31'
  );

  RAISE NOTICE '✅ SUCCESS! User created with UUID: %', new_user_id;
  RAISE NOTICE '📧 Email: sk.official.test@bims.com';
  RAISE NOTICE '🔑 Password: SKTest123!@#';
  RAISE NOTICE '👤 Name: Andrea Santos Pelias';
  RAISE NOTICE '🎖️ Position: SK_CHAIRMAN';

END $$;

-- Verify the account was created
SELECT
  u.userid,
  u.email,
  u.firstname,
  u.lastname,
  u.role,
  u.accountstatus,
  so.position
FROM user_tbl u
LEFT JOIN sk_officials so ON u.userid = so.userid
WHERE u.email = 'sk.official.test@bims.com';
