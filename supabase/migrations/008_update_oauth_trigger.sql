-- ============================================
-- Update Auth Trigger for Google OAuth Support
-- ============================================
-- This migration updates the handle_new_user() trigger to properly
-- handle both email/password and Google OAuth authentication

-- Drop existing trigger function
DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;

-- Create updated trigger function
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
  IF NEW.app_metadata->>'provider' = 'google' THEN
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

    -- Insert OAuth user with placeholder data
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
      'YOUTH_VOLUNTEER', -- Default role for OAuth users
      '2000-01-01'::DATE, -- Placeholder - must be updated
      '', -- Empty - must be updated
      '', -- Empty - must be updated
      COALESCE(
        user_metadata->>'avatar_url',
        user_metadata->>'picture'
      ),
      TRUE, -- Auto-accept terms for OAuth
      'ACTIVE' -- Auto-activate OAuth users (Google already verified email)
    )
    ON CONFLICT (userid) DO UPDATE
    SET
      email = EXCLUDED.email,
      imagepathurl = EXCLUDED.imagepathurl,
      accountstatus = 'ACTIVE',
      updatedat = CURRENT_TIMESTAMP;

  ELSE
    -- Handle email/password signup (existing logic)
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

-- Recreate trigger on auth.users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT OR UPDATE ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- Migration completed successfully
-- OAuth users will now be properly created with placeholder data
-- and will be prompted to complete their profile
