-- Migration 022: Security Hardening Phase 3 (2026-03-24)
--
-- Fixes:
-- 1. Server-side login lockout (replace client-side localStorage tracking)
-- 2. Restrict anon access to User_Tbl (replace broad SELECT with RPC)
-- 3. Rate limiting on password reset requests
-- 4. Server-side file extension validation on storage buckets

-- ============================================
-- 1. SERVER-SIDE LOGIN LOCKOUT
-- ============================================

CREATE TABLE IF NOT EXISTS "Login_Attempts_Tbl" (
  "attemptID" SERIAL PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  "attemptedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_login_attempts_email_time
  ON "Login_Attempts_Tbl" (email, "attemptedAt" DESC);

ALTER TABLE "Login_Attempts_Tbl" ENABLE ROW LEVEL SECURITY;

-- Auto-cleanup: delete attempts older than 1 hour
CREATE OR REPLACE FUNCTION cleanup_old_login_attempts()
RETURNS TRIGGER AS $fn$
BEGIN
  DELETE FROM "Login_Attempts_Tbl"
  WHERE "attemptedAt" < NOW() - INTERVAL '1 hour';
  RETURN NEW;
END;
$fn$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_cleanup_login_attempts ON "Login_Attempts_Tbl";
CREATE TRIGGER trg_cleanup_login_attempts
  AFTER INSERT ON "Login_Attempts_Tbl"
  FOR EACH STATEMENT EXECUTE FUNCTION cleanup_old_login_attempts();

-- RPC: Record a failed login attempt
CREATE OR REPLACE FUNCTION record_failed_login(p_email VARCHAR)
RETURNS VOID AS $fn$
BEGIN
  IF p_email IS NULL OR length(trim(p_email)) = 0 THEN
    RAISE EXCEPTION 'Email is required';
  END IF;
  INSERT INTO "Login_Attempts_Tbl" (email, "attemptedAt")
  VALUES (lower(trim(p_email)), CURRENT_TIMESTAMP);
END;
$fn$ LANGUAGE plpgsql SECURITY DEFINER;

-- RPC: Check if login is allowed (5 attempts / 15 min)
CREATE OR REPLACE FUNCTION check_login_allowed(p_email VARCHAR)
RETURNS JSON AS $fn$
DECLARE
  v_count INTEGER;
  v_oldest TIMESTAMPTZ;
  v_lockout_end TIMESTAMPTZ;
  v_minutes_remaining INTEGER;
BEGIN
  IF p_email IS NULL OR length(trim(p_email)) = 0 THEN
    RETURN json_build_object('allowed', true);
  END IF;
  SELECT COUNT(*), MIN("attemptedAt") INTO v_count, v_oldest
  FROM "Login_Attempts_Tbl"
  WHERE email = lower(trim(p_email))
    AND "attemptedAt" > NOW() - INTERVAL '15 minutes';
  IF v_count >= 5 THEN
    v_lockout_end := v_oldest + INTERVAL '15 minutes';
    v_minutes_remaining := GREATEST(1, CEIL(EXTRACT(EPOCH FROM (v_lockout_end - NOW())) / 60));
    RETURN json_build_object(
      'allowed', false,
      'error', 'Too many failed login attempts. Please try again in ' || v_minutes_remaining || ' minute(s).',
      'minutesRemaining', v_minutes_remaining
    );
  END IF;
  RETURN json_build_object('allowed', true);
END;
$fn$ LANGUAGE plpgsql SECURITY DEFINER;

-- RPC: Clear login attempts after successful login
CREATE OR REPLACE FUNCTION clear_login_attempts(p_email VARCHAR)
RETURNS VOID AS $fn$
BEGIN
  IF p_email IS NULL OR length(trim(p_email)) = 0 THEN RETURN; END IF;
  DELETE FROM "Login_Attempts_Tbl" WHERE email = lower(trim(p_email));
END;
$fn$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION record_failed_login(VARCHAR) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION check_login_allowed(VARCHAR) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION clear_login_attempts(VARCHAR) TO anon, authenticated;


-- ============================================
-- 2. RESTRICT ANON ACCESS TO User_Tbl
-- ============================================
-- Replace broad anon SELECT with a narrow RPC that only returns accountStatus.

DROP POLICY IF EXISTS "anon_select_active_profiles" ON "User_Tbl";
DROP POLICY IF EXISTS "Public can view active user profiles" ON "User_Tbl";

-- RPC: Check account status by email (returns only status, no PII)
CREATE OR REPLACE FUNCTION check_account_status(p_email VARCHAR)
RETURNS JSON AS $fn$
DECLARE
  v_status VARCHAR;
BEGIN
  IF p_email IS NULL OR length(trim(p_email)) = 0 THEN
    RETURN json_build_object('exists', false);
  END IF;
  SELECT "accountStatus" INTO v_status
  FROM "User_Tbl" WHERE email = lower(trim(p_email)) LIMIT 1;
  IF v_status IS NULL THEN
    RETURN json_build_object('exists', false);
  END IF;
  RETURN json_build_object('exists', true, 'accountStatus', v_status);
END;
$fn$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION check_account_status(VARCHAR) TO anon, authenticated;


-- ============================================
-- 3. RATE LIMITING ON PASSWORD RESET REQUESTS
-- ============================================

CREATE TABLE IF NOT EXISTS "Password_Reset_Attempts_Tbl" (
  "attemptID" SERIAL PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  "attemptedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_password_reset_email_time
  ON "Password_Reset_Attempts_Tbl" (email, "attemptedAt" DESC);

ALTER TABLE "Password_Reset_Attempts_Tbl" ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION cleanup_old_reset_attempts()
RETURNS TRIGGER AS $fn$
BEGIN
  DELETE FROM "Password_Reset_Attempts_Tbl"
  WHERE "attemptedAt" < NOW() - INTERVAL '1 hour';
  RETURN NEW;
END;
$fn$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_cleanup_reset_attempts ON "Password_Reset_Attempts_Tbl";
CREATE TRIGGER trg_cleanup_reset_attempts
  AFTER INSERT ON "Password_Reset_Attempts_Tbl"
  FOR EACH STATEMENT EXECUTE FUNCTION cleanup_old_reset_attempts();

-- RPC: Check if password reset is allowed (max 3 per 15 min)
CREATE OR REPLACE FUNCTION check_password_reset_allowed(p_email VARCHAR)
RETURNS JSON AS $fn$
DECLARE
  v_count INTEGER;
BEGIN
  IF p_email IS NULL OR length(trim(p_email)) = 0 THEN
    RETURN json_build_object('allowed', true);
  END IF;
  SELECT COUNT(*) INTO v_count
  FROM "Password_Reset_Attempts_Tbl"
  WHERE email = lower(trim(p_email))
    AND "attemptedAt" > NOW() - INTERVAL '15 minutes';
  IF v_count >= 3 THEN
    RETURN json_build_object(
      'allowed', false,
      'error', 'Too many password reset requests. Please try again later.'
    );
  END IF;
  INSERT INTO "Password_Reset_Attempts_Tbl" (email, "attemptedAt")
  VALUES (lower(trim(p_email)), CURRENT_TIMESTAMP);
  RETURN json_build_object('allowed', true);
END;
$fn$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION check_password_reset_allowed(VARCHAR) TO anon, authenticated;


-- ============================================
-- 4. SERVER-SIDE FILE EXTENSION VALIDATION
-- ============================================

CREATE OR REPLACE FUNCTION is_valid_image_extension(filename TEXT)
RETURNS BOOLEAN AS $fn$
BEGIN
  RETURN lower(right(filename, 4)) IN ('.jpg', '.png', '.gif')
      OR lower(right(filename, 5)) IN ('.jpeg', '.webp');
END;
$fn$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION is_valid_document_extension(filename TEXT)
RETURNS BOOLEAN AS $fn$
BEGIN
  RETURN lower(right(filename, 4)) IN ('.pdf', '.doc', '.xls', '.jpg', '.png')
      OR lower(right(filename, 5)) IN ('.docx', '.xlsx', '.jpeg');
END;
$fn$ LANGUAGE plpgsql IMMUTABLE;

-- user-images: only allow image extensions
DROP POLICY IF EXISTS "Users can upload their own profile images" ON storage.objects;
CREATE POLICY "Users can upload their own profile images"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (
  bucket_id = 'user-images'
  AND (select auth.uid())::text = (storage.foldername(name))[1]
  AND is_valid_image_extension(name)
);

-- announcement-images: only allow image extensions
DROP POLICY IF EXISTS "SK Officials can upload announcement images" ON storage.objects;
CREATE POLICY "SK Officials can upload announcement images"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (
  bucket_id = 'announcement-images'
  AND EXISTS (SELECT 1 FROM public."User_Tbl" WHERE "userID" = (select auth.uid()) AND role IN ('SK_OFFICIAL', 'CAPTAIN'))
  AND is_valid_image_extension(name)
);

-- project-images: only allow image extensions
DROP POLICY IF EXISTS "SK Officials can upload project images" ON storage.objects;
CREATE POLICY "SK Officials can upload project images"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (
  bucket_id = 'project-images'
  AND EXISTS (SELECT 1 FROM public."User_Tbl" WHERE "userID" = (select auth.uid()) AND role IN ('SK_OFFICIAL', 'CAPTAIN'))
  AND is_valid_image_extension(name)
);

-- general-files: only allow document extensions
DROP POLICY IF EXISTS "SK Officials can upload general files" ON storage.objects;
CREATE POLICY "SK Officials can upload general files"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (
  bucket_id = 'general-files'
  AND EXISTS (SELECT 1 FROM public."User_Tbl" WHERE "userID" = (select auth.uid()) AND role IN ('SK_OFFICIAL', 'CAPTAIN'))
  AND is_valid_document_extension(name)
);

-- project-files: only allow document extensions
DROP POLICY IF EXISTS "SK Officials can upload project files" ON storage.objects;
CREATE POLICY "SK Officials can upload project files"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (
  bucket_id = 'project-files'
  AND EXISTS (SELECT 1 FROM public."User_Tbl" WHERE "userID" = (select auth.uid()) AND role IN ('SK_OFFICIAL', 'CAPTAIN'))
  AND is_valid_document_extension(name)
);

-- consent-forms: only allow PDF and images
DROP POLICY IF EXISTS "Users can upload consent forms" ON storage.objects;
CREATE POLICY "Users can upload consent forms"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (
  bucket_id = 'consent-forms'
  AND (select auth.uid())::text = (storage.foldername(name))[1]
  AND (lower(right(name, 4)) IN ('.pdf', '.jpg', '.png') OR lower(right(name, 5)) = '.jpeg')
);

-- receipts: only allow images
DROP POLICY IF EXISTS "SK Officials can upload receipts" ON storage.objects;
CREATE POLICY "SK Officials can upload receipts"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (
  bucket_id = 'receipts'
  AND EXISTS (SELECT 1 FROM public."User_Tbl" WHERE "userID" = (select auth.uid()) AND role IN ('SK_OFFICIAL', 'CAPTAIN'))
  AND is_valid_image_extension(name)
);

-- certificates: only allow PDF
DROP POLICY IF EXISTS "SK Officials can upload certificates" ON storage.objects;
CREATE POLICY "SK Officials can upload certificates"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (
  bucket_id = 'certificates'
  AND EXISTS (SELECT 1 FROM public."User_Tbl" WHERE "userID" = (select auth.uid()) AND role IN ('SK_OFFICIAL', 'CAPTAIN'))
  AND lower(right(name, 4)) = '.pdf'
);
