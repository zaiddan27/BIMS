-- ============================================
-- Fix Auth Trigger - Ensure All Names Are Lowercase
-- ============================================
-- This migration fixes any camelCase/Title Case issues in the trigger

-- Drop existing trigger and function
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;

-- Create corrected trigger function with ALL LOWERCASE names
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  user_metadata JSONB;
  full_name TEXT;
  name_parts TEXT[];
  first_name TEXT;
  last_name TEXT;
BEGIN
  user_metadata := NEW.raw_user_meta_data;

  -- Check if user is from OAuth (Google)
  IF NEW.raw_app_meta_data->>'provider' = 'google' THEN
    -- Extract name from Google profile
    full_name := COALESCE(
      user_metadata->>'full_name',
      user_metadata->>'name',
      ''
    );

    -- Split name into parts
    name_parts := string_to_array(full_name, ' ');
    first_name := COALESCE(name_parts[1], '');
    last_name := COALESCE(
      array_to_string(name_parts[2:array_length(name_parts, 1)], ' '),
      ''
    );

    -- Insert OAuth user with placeholder data (ALL LOWERCASE)
    INSERT INTO public.user_tbl (
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
      accountstatus
    ) VALUES (
      NEW.id,
      NEW.email,
      first_name,
      last_name,
      NULL,
      'YOUTH_VOLUNTEER',
      '2000-01-01'::DATE,
      '',
      '',
      COALESCE(
        user_metadata->>'avatar_url',
        user_metadata->>'picture'
      ),
      TRUE,
      'ACTIVE'
    )
    ON CONFLICT (userid) DO UPDATE
    SET
      email = EXCLUDED.email,
      imagepathurl = EXCLUDED.imagepathurl,
      accountstatus = 'ACTIVE',
      updatedat = CURRENT_TIMESTAMP;

  ELSE
    -- Handle email/password signup (ALL LOWERCASE)
    INSERT INTO public.user_tbl (
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
      accountstatus
    ) VALUES (
      NEW.id,
      NEW.email,
      COALESCE(user_metadata->>'first_name', ''),
      COALESCE(user_metadata->>'last_name', ''),
      user_metadata->>'middle_name',
      COALESCE(user_metadata->>'role', 'YOUTH_VOLUNTEER'),
      COALESCE((user_metadata->>'birthday')::DATE, CURRENT_DATE),
      COALESCE(user_metadata->>'contact_number', ''),
      COALESCE(user_metadata->>'address', ''),
      user_metadata->>'image_path_url',
      COALESCE((user_metadata->>'terms_conditions')::BOOLEAN, false),
      CASE
        WHEN NEW.email_confirmed_at IS NOT NULL THEN 'ACTIVE'
        ELSE 'PENDING'
      END
    )
    ON CONFLICT (userid) DO UPDATE
    SET
      email = EXCLUDED.email,
      accountstatus = CASE
        WHEN NEW.email_confirmed_at IS NOT NULL THEN 'ACTIVE'
        ELSE user_tbl.accountstatus
      END,
      updatedat = CURRENT_TIMESTAMP;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Recreate trigger
CREATE TRIGGER on_auth_user_created
  AFTER INSERT OR UPDATE ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- Also fix the update_user_profile function to use lowercase
DROP FUNCTION IF EXISTS public.update_user_profile(VARCHAR, VARCHAR, VARCHAR, DATE, VARCHAR, TEXT, TEXT);

CREATE OR REPLACE FUNCTION public.update_user_profile(
  p_first_name VARCHAR(100),
  p_last_name VARCHAR(100),
  p_middle_name VARCHAR(100),
  p_birthday DATE,
  p_contact_number VARCHAR(13),
  p_address TEXT,
  p_image_path_url TEXT
)
RETURNS VOID AS $$
BEGIN
  UPDATE public.user_tbl
  SET
    firstname = p_first_name,
    lastname = p_last_name,
    middlename = p_middle_name,
    birthday = p_birthday,
    contactnumber = p_contact_number,
    address = p_address,
    imagepathurl = p_image_path_url,
    updatedat = CURRENT_TIMESTAMP
  WHERE userid = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Migration complete
-- All trigger functions now use correct lowercase table and column names
