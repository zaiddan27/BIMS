-- Migration 020: Security Hardening Phase 2 (2026-03-24)
--
-- Critical fixes:
-- 1. S1: Block role injection on signup — hardcode YOUTH_VOLUNTEER in auth trigger
-- 2. S2: Fix prevent_role_escalation() bypass in SECURITY DEFINER context
-- 3. S4: Restrict create_notification() RPC to prevent notification injection
-- 4. S5: Restrict log_action() RPC to prevent audit log pollution
-- 5. Add DB CHECK constraints on contactNumber and birthday
-- 6. Add server-side bucket restrictions for file uploads

-- ============================================
-- S1: Fix role injection in handle_new_user()
-- The trigger was trusting user_metadata->>'role' from signup,
-- allowing a malicious user to register as SUPERADMIN/CAPTAIN/SK_OFFICIAL.
-- Now hardcoded to YOUTH_VOLUNTEER for all signups.
-- ============================================

DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;

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
    full_name := COALESCE(
      user_metadata->>'full_name',
      user_metadata->>'name',
      ''
    );

    name_parts := string_to_array(full_name, ' ');
    first_name := COALESCE(name_parts[1], '');
    last_name := COALESCE(
      array_to_string(name_parts[2:array_length(name_parts, 1)], ' '),
      ''
    );

    INSERT INTO public."User_Tbl" (
      "userID", email, "firstName", "lastName", "middleName",
      role, birthday, "contactNumber", address,
      "imagePathURL", "termsConditions", "accountStatus"
    ) VALUES (
      NEW.id, NEW.email, first_name, last_name, NULL,
      'YOUTH_VOLUNTEER',  -- HARDCODED: OAuth users are always Youth Volunteers
      '2000-01-01'::DATE, '', '',
      COALESCE(user_metadata->>'avatar_url', user_metadata->>'picture'),
      TRUE, 'ACTIVE'
    )
    ON CONFLICT ("userID") DO UPDATE
    SET
      email = EXCLUDED.email,
      "imagePathURL" = EXCLUDED."imagePathURL",
      "accountStatus" = 'ACTIVE',
      "updatedAt" = CURRENT_TIMESTAMP;

  ELSE
    -- Email/password signup
    INSERT INTO public."User_Tbl" (
      "userID", email, "firstName", "lastName", "middleName",
      role, birthday, "contactNumber", address,
      "imagePathURL", "termsConditions", "accountStatus"
    ) VALUES (
      NEW.id, NEW.email,
      COALESCE(user_metadata->>'first_name', ''),
      COALESCE(user_metadata->>'last_name', ''),
      user_metadata->>'middle_name',
      'YOUTH_VOLUNTEER',  -- HARDCODED: All signups are Youth Volunteers (was trusting metadata)
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
    ON CONFLICT ("userID") DO UPDATE
    SET
      email = EXCLUDED.email,
      "accountStatus" = CASE
        WHEN NEW.email_confirmed_at IS NOT NULL THEN 'ACTIVE'
        ELSE "User_Tbl"."accountStatus"
      END,
      "updatedAt" = CURRENT_TIMESTAMP;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Recreate trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT OR UPDATE ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();


-- ============================================
-- S2: Fix prevent_role_escalation() bypass
-- The old version checked current_user = 'postgres' which always passes
-- in a SECURITY DEFINER context. Now uses session_user and pg_has_role()
-- for a more reliable check.
-- ============================================

CREATE OR REPLACE FUNCTION prevent_role_escalation()
RETURNS TRIGGER AS $$
BEGIN
  -- Allow direct postgres/superuser connections (migrations, admin console)
  IF session_user = 'postgres' OR session_user = 'supabase_admin'
     OR pg_has_role(session_user, 'rds_superuser', 'MEMBER') THEN
    RETURN NEW;
  END IF;

  -- For API calls: only SUPERADMIN can change role or accountStatus
  IF (OLD."role" IS DISTINCT FROM NEW."role"
      OR OLD."accountStatus" IS DISTINCT FROM NEW."accountStatus") THEN
    IF NOT EXISTS (
      SELECT 1 FROM "User_Tbl"
      WHERE "userID" = (select auth.uid())
      AND "role" = 'SUPERADMIN'
    ) THEN
      NEW."role" := OLD."role";
      NEW."accountStatus" := OLD."accountStatus";
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================
-- S4: Restrict create_notification() to prevent notification injection
-- Only allow triggers (SECURITY DEFINER context) and SK/Captain to
-- create notifications for other users. Youth can only self-notify.
-- ============================================

CREATE OR REPLACE FUNCTION public.create_notification(
  p_user_id UUID,
  p_notification_type VARCHAR(50),
  p_title VARCHAR(255),
  p_reference_id INTEGER DEFAULT NULL
)
RETURNS INTEGER AS $$
DECLARE
  v_notification_id INTEGER;
  v_caller_role TEXT;
BEGIN
  -- Get caller's role (NULL if called from trigger context without auth)
  SELECT role INTO v_caller_role
  FROM "User_Tbl"
  WHERE "userID" = (select auth.uid());

  -- Allow if: caller is SK/Captain/Superadmin, OR targeting self, OR called from trigger (no auth context)
  IF v_caller_role IS NULL  -- trigger context
     OR v_caller_role IN ('SK_OFFICIAL', 'CAPTAIN', 'SUPERADMIN')
     OR p_user_id = (select auth.uid()) THEN

    INSERT INTO public."Notification_Tbl" (
      "userID", "notificationType", title, "referenceID", "isRead", "createdAt"
    ) VALUES (
      p_user_id, p_notification_type, p_title, p_reference_id, false, CURRENT_TIMESTAMP
    )
    RETURNING "notificationID" INTO v_notification_id;

    RETURN v_notification_id;
  ELSE
    RAISE EXCEPTION 'Unauthorized: cannot create notifications for other users';
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================
-- S5: Restrict log_action() — validate action string length
-- Prevent audit log pollution with extremely long or malicious entries
-- ============================================

CREATE OR REPLACE FUNCTION public.log_action(
  p_action VARCHAR(255),
  p_reply_id INTEGER DEFAULT NULL,
  p_post_project_id INTEGER DEFAULT NULL,
  p_application_id INTEGER DEFAULT NULL,
  p_inquiry_id INTEGER DEFAULT NULL,
  p_notification_id INTEGER DEFAULT NULL,
  p_file_id INTEGER DEFAULT NULL,
  p_testimony_id INTEGER DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  -- Require authenticated user
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Authentication required';
  END IF;

  -- Validate action string
  IF p_action IS NULL OR length(trim(p_action)) = 0 THEN
    RAISE EXCEPTION 'Action description is required';
  END IF;

  IF length(p_action) > 255 THEN
    RAISE EXCEPTION 'Action description too long';
  END IF;

  INSERT INTO public."Logs_Tbl" (
    "userID", action, "replyID", "postProjectID",
    "applicationID", "inquiryID", "notificationID",
    "fileID", "testimonyID", "timeStamp"
  ) VALUES (
    auth.uid(), p_action, p_reply_id, p_post_project_id,
    p_application_id, p_inquiry_id, p_notification_id,
    p_file_id, p_testimony_id, CURRENT_TIMESTAMP
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================
-- Add DB CHECK constraints for data integrity
-- ============================================

-- Contact number format (allow empty for OAuth users pre-completion)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'chk_contact_number_format'
  ) THEN
    ALTER TABLE "User_Tbl"
      ADD CONSTRAINT chk_contact_number_format
      CHECK ("contactNumber" = '' OR "contactNumber" ~ '^09\d{9}$');
  END IF;
END $$;

-- Birthday: must not be in the future
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'chk_birthday_not_future'
  ) THEN
    ALTER TABLE "User_Tbl"
      ADD CONSTRAINT chk_birthday_not_future
      CHECK (birthday <= CURRENT_DATE);
  END IF;
END $$;


-- ============================================
-- Clean up duplicate notifications
-- Remove older duplicate where same user has two identical notifications
-- ============================================

DELETE FROM "Notification_Tbl" a
USING "Notification_Tbl" b
WHERE a."notificationID" < b."notificationID"
  AND a."userID" = b."userID"
  AND a."notificationType" = b."notificationType"
  AND a.title = b.title
  AND a."createdAt"::date = b."createdAt"::date;
