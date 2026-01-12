-- ============================================
-- Migration: Remove SK_AUDITOR Position
-- ============================================
-- This migration removes SK_AUDITOR from the SK position constraint
-- Note: SK_AUDITOR position has been deprecated and removed from the system
-- Date: 2026-01-10

-- Step 1: Update any existing SK_AUDITOR records to SK_KAGAWAD
-- This ensures no orphaned data before constraint change
UPDATE SK_Tbl SET position = 'SK_KAGAWAD' WHERE position = 'SK_AUDITOR';

-- Step 2: Drop the old CHECK constraint
ALTER TABLE SK_Tbl DROP CONSTRAINT sk_tbl_position_check;

-- Step 3: Add new CHECK constraint without SK_AUDITOR
ALTER TABLE SK_Tbl ADD CONSTRAINT sk_tbl_position_check CHECK (position IN ('SK_CHAIRMAN', 'SK_SECRETARY', 'SK_TREASURER', 'SK_KAGAWAD'));

-- Migration completed successfully
-- SK_AUDITOR position is no longer valid in the system
