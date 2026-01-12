-- ============================================
-- Force Trigger Update - Complete Cleanup
-- Issue: Trigger still points to old handle_new_user function
-- Solution: Drop everything, create fresh with v3
-- ============================================

-- Step 1: Drop trigger explicitly (releases function dependency)
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Step 2: Drop ALL old function versions
DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;
DROP FUNCTION IF EXISTS public.handle_new_user_v2() CASCADE;

-- Step 3: Create brand new function (v3 for absolute clarity)
CREATE OR REPLACE FUNCTION public.handle_new_user_v3()
RETURNS TRIGGER AS $$
DECLARE
  user_metadata JSONB;
  v_first_name TEXT;
  v_last_name TEXT;
BEGIN
  user_metadata := NEW.raw_user_meta_data;

  -- Check if user is from OAuth (Google)
  IF NEW.raw_app_meta_data->>'provider' = 'google' THEN
    -- Extract first and last name from full_name
    v_first_name := COALESCE(SPLIT_PART(COALESCE(user_metadata->>'full_name', user_metadata->>'name', ''), ' ', 1), '');
    v_last_name := COALESCE(SPLIT_PART(COALESCE(user_metadata->>'full_name', user_metadata->>'name', ''), ' ', 2), '');

    -- Insert OAuth user
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
      v_first_name,
      v_last_name,
      NULL,
      'YOUTH_VOLUNTEER',
      '2000-01-01'::DATE,
      '',
      '',
      COALESCE(user_metadata->>'avatar_url', user_metadata->>'picture'),
      TRUE,
      'ACTIVE',
      CURRENT_TIMESTAMP,
      CURRENT_TIMESTAMP
    )
    ON CONFLICT ("userID") DO UPDATE SET
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
    ON CONFLICT ("userID") DO UPDATE SET
      "email" = EXCLUDED."email",
      "accountStatus" = CASE
        WHEN NEW.email_confirmed_at IS NOT NULL THEN 'ACTIVE'
        ELSE "User_Tbl"."accountStatus"
      END,
      "updatedAt" = CURRENT_TIMESTAMP;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Step 4: Create trigger pointing to NEW function
CREATE TRIGGER on_auth_user_created
  AFTER INSERT OR UPDATE ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user_v3();

-- Migration complete
-- This should now properly update the trigger to use handle_new_user_v3
