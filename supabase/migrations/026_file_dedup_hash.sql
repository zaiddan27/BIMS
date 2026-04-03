-- =====================================================
-- File Deduplication: Add hash and size columns
-- =====================================================
-- Tracks file content hash (SHA-256) and size to detect
-- duplicate uploads. If two SK officials upload the same
-- file with different names, the system reuses the existing
-- storage path instead of uploading again.
-- =====================================================

ALTER TABLE "File_Tbl"
ADD COLUMN IF NOT EXISTS "fileHash" VARCHAR(64) DEFAULT NULL;

ALTER TABLE "File_Tbl"
ADD COLUMN IF NOT EXISTS "fileSize" BIGINT DEFAULT NULL;

-- Index on hash for fast duplicate lookups
CREATE INDEX IF NOT EXISTS idx_file_hash ON "File_Tbl"("fileHash");

-- Also relax fileCategory CHECK to allow DOCUMENTS, REPORTS, MEDIA
-- (the UI uses these but the DB only had GENERAL, PROJECT)
ALTER TABLE "File_Tbl" DROP CONSTRAINT IF EXISTS "File_Tbl_fileCategory_check";
ALTER TABLE "File_Tbl" ADD CONSTRAINT "File_Tbl_fileCategory_check"
  CHECK ("fileCategory" IN ('GENERAL', 'PROJECT', 'DOCUMENTS', 'REPORTS', 'MEDIA'));
