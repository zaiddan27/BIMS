-- ============================================
-- Fix Trigger Column References - FINAL FIX
-- Issue: Line 114 referenced user_tbl.accountstatus without quotes
-- Should be: "User_Tbl"."accountStatus" with proper quoting
-- ============================================

-- Drop existing trigger and function
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;

-- Create corrected trigger function with ALL proper quoting
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

    -- Insert OAuth user with placeholder data
    INSERT INTO public."User_Tbl" (
      "userID",
      "email",
      "firstName",
      "lastName",
      "middleName",
      "role",
      "birthday",
      "contactNumber",
      "address",
      "imagePathURL",
      "termsConditions",
      "accountStatus",
      "createdAt",
      "updatedAt"
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
      'ACTIVE',
      CURRENT_TIMESTAMP,
      CURRENT_TIMESTAMP
    )
    ON CONFLICT ("userID") DO UPDATE
    SET
      "email" = EXCLUDED."email",
      "imagePathURL" = EXCLUDED."imagePathURL",
      "accountStatus" = 'ACTIVE',
      "updatedAt" = CURRENT_TIMESTAMP;

  ELSE
    -- Handle email/password signup
    INSERT INTO public."User_Tbl" (
      "userID",
      "email",
      "firstName",
      "lastName",
      "middleName",
      "role",
      "birthday",
      "contactNumber",
      "address",
      "imagePathURL",
      "termsConditions",
      "accountStatus",
      "createdAt",
      "updatedAt"
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
      END,
      CURRENT_TIMESTAMP,
      CURRENT_TIMESTAMP
    )
    ON CONFLICT ("userID") DO UPDATE
    SET
      "email" = EXCLUDED."email",
      "accountStatus" = CASE
        WHEN NEW.email_confirmed_at IS NOT NULL THEN 'ACTIVE'
        ELSE "User_Tbl"."accountStatus"  -- FIXED: Added quotes around table and column
      END,
      "updatedAt" = CURRENT_TIMESTAMP;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Recreate trigger
CREATE TRIGGER on_auth_user_created
  AFTER INSERT OR UPDATE ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- Migration complete
-- Fixed: Line 114 now uses "User_Tbl"."accountStatus" with proper quoting
-- Added explicit createdAt and updatedAt in INSERT statements
