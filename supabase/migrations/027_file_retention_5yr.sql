-- ============================================================================
-- Migration: File Retention Policy — 5 Years (SE2 Defense Revision #6)
-- ============================================================================
-- Panel guidance (NPC): keep uploaded documents up to 5 years, then
-- dispose/shred. Previous UI stated "Files older than 1 year will be
-- automatically archived" which did not reflect NPC guidance.
--
-- This migration:
--   1. Adds an auto-archive function that marks File_Tbl rows ARCHIVED
--      when createdAt is older than 5 years.
--   2. Provides a scheduling hint for pg_cron (run once monthly).
--
-- Files are *archived* (soft-move), not deleted. Disposal/shredding after
-- the 5-year window remains a manual decision by Captain / SuperAdmin per
-- the documented policy.
-- ============================================================================

-- 1. Auto-archive function: mark active files older than 5 years as ARCHIVED.
CREATE OR REPLACE FUNCTION public.archive_old_files()
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  archived_count integer := 0;
BEGIN
  WITH updated AS (
    UPDATE "File_Tbl"
       SET "fileStatus" = 'ARCHIVED'
     WHERE "fileStatus" = 'ACTIVE'
       AND "createdAt" < NOW() - INTERVAL '5 years'
    RETURNING "fileID"
  )
  SELECT count(*) INTO archived_count FROM updated;

  RETURN archived_count;
END;
$$;

COMMENT ON FUNCTION public.archive_old_files() IS
  'SE2 revision #6 — NPC-aligned retention. Marks File_Tbl rows older than 5 years as ARCHIVED.';

-- 2. Scheduling hint (pg_cron) — run once per month at 02:30 UTC on the 1st.
--    Enable pg_cron in Supabase (Database > Extensions) then run:
--    SELECT cron.schedule('archive-old-files', '30 2 1 * *', 'SELECT public.archive_old_files()');

-- 3. One-time backfill check (safe no-op if nothing matches).
-- SELECT public.archive_old_files();
