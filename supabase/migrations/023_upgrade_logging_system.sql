-- Migration 023: Upgrade logging system to industry standards (2026-03-31)
--
-- Adds: category, severity, ipAddress, userAgent, metadata columns
-- Adds: auto-retention policy (general 90 days, audit 1 year)
-- Aligns with OWASP, NIST SP 800-92, and PCI-DSS logging guidelines

-- ============================================
-- 1. ADD NEW COLUMNS
-- ============================================

ALTER TABLE "Logs_Tbl"
  ADD COLUMN IF NOT EXISTS category VARCHAR(30) NOT NULL DEFAULT 'general',
  ADD COLUMN IF NOT EXISTS severity VARCHAR(10) NOT NULL DEFAULT 'INFO',
  ADD COLUMN IF NOT EXISTS "ipAddress" INET,
  ADD COLUMN IF NOT EXISTS "userAgent" TEXT,
  ADD COLUMN IF NOT EXISTS metadata JSONB;

-- Add CHECK constraints for controlled vocabulary
ALTER TABLE "Logs_Tbl"
  ADD CONSTRAINT chk_logs_category
    CHECK (category IN ('authentication','authorization','data_mutation','data_access','configuration','audit','general','system')),
  ADD CONSTRAINT chk_logs_severity
    CHECK (severity IN ('INFO','WARN','ERROR','CRITICAL'));

-- Index on category for audit trail filtering (replaces ilike on action)
CREATE INDEX IF NOT EXISTS idx_logs_category ON "Logs_Tbl"(category);

-- Index on severity for filtering critical events
CREATE INDEX IF NOT EXISTS idx_logs_severity ON "Logs_Tbl"(severity) WHERE severity IN ('WARN','ERROR','CRITICAL');

-- Index on createdAt for retention cleanup
CREATE INDEX IF NOT EXISTS idx_logs_created_at ON "Logs_Tbl"("createdAt" DESC);

-- ============================================
-- 2. UPDATE log_action() RPC
-- ============================================

CREATE OR REPLACE FUNCTION public.log_action(
  p_action VARCHAR(255),
  p_reply_id INTEGER DEFAULT NULL,
  p_post_project_id INTEGER DEFAULT NULL,
  p_application_id INTEGER DEFAULT NULL,
  p_inquiry_id INTEGER DEFAULT NULL,
  p_notification_id INTEGER DEFAULT NULL,
  p_file_id INTEGER DEFAULT NULL,
  p_testimony_id INTEGER DEFAULT NULL,
  p_category VARCHAR(30) DEFAULT 'general',
  p_severity VARCHAR(10) DEFAULT 'INFO',
  p_ip_address INET DEFAULT NULL,
  p_user_agent TEXT DEFAULT NULL,
  p_metadata JSONB DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Authentication required';
  END IF;

  IF p_action IS NULL OR length(trim(p_action)) = 0 THEN
    RAISE EXCEPTION 'Action description is required';
  END IF;

  IF length(p_action) > 255 THEN
    RAISE EXCEPTION 'Action description too long';
  END IF;

  INSERT INTO public."Logs_Tbl" (
    "userID", action, "replyID", "postProjectID",
    "applicationID", "inquiryID", "notificationID",
    "fileID", "testimonyID", "createdAt",
    category, severity, "ipAddress", "userAgent", metadata
  ) VALUES (
    auth.uid(), p_action, p_reply_id, p_post_project_id,
    p_application_id, p_inquiry_id, p_notification_id,
    p_file_id, p_testimony_id, CURRENT_TIMESTAMP,
    COALESCE(p_category, 'general'),
    COALESCE(p_severity, 'INFO'),
    p_ip_address, p_user_agent, p_metadata
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 3. AUTO-RETENTION POLICY
-- ============================================

-- Cleanup function: deletes general logs > 90 days, audit logs > 1 year
CREATE OR REPLACE FUNCTION public.cleanup_old_logs()
RETURNS INTEGER AS $$
DECLARE
  v_deleted INTEGER := 0;
  v_count INTEGER;
BEGIN
  -- Delete general (non-audit) logs older than 90 days
  DELETE FROM "Logs_Tbl"
  WHERE category != 'audit'
    AND "createdAt" < NOW() - INTERVAL '90 days';
  GET DIAGNOSTICS v_count = ROW_COUNT;
  v_deleted := v_deleted + v_count;

  -- Delete audit logs older than 1 year
  DELETE FROM "Logs_Tbl"
  WHERE category = 'audit'
    AND "createdAt" < NOW() - INTERVAL '1 year';
  GET DIAGNOSTICS v_count = ROW_COUNT;
  v_deleted := v_deleted + v_count;

  RETURN v_deleted;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Schedule via pg_cron (runs daily at 2 AM UTC)
-- NOTE: pg_cron must be enabled in the Supabase dashboard under Database > Extensions
-- Once enabled, run: SELECT cron.schedule('cleanup-old-logs', '0 2 * * *', 'SELECT public.cleanup_old_logs()');

-- ============================================
-- 4. BACKFILL EXISTING [AUDIT] LOGS
-- ============================================

-- Migrate any existing logs with [AUDIT] prefix to use the category column
UPDATE "Logs_Tbl"
SET category = 'audit', severity = 'WARN'
WHERE action ILIKE '%[AUDIT]%'
  AND category = 'general';

-- Migrate auth-related logs
UPDATE "Logs_Tbl"
SET category = 'authentication'
WHERE (action ILIKE '%logged in%' OR action ILIKE '%logged out%' OR action ILIKE '%signed up%' OR action ILIKE '%reset password%')
  AND category = 'general';
