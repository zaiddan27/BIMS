-- ============================================
-- Add Gender Column to User_Tbl
-- ============================================
-- This migration adds a gender column to the user_tbl table

-- Add gender column (optional field)
ALTER TABLE user_tbl
ADD COLUMN IF NOT EXISTS gender VARCHAR(20);

-- Add check constraint for valid gender values
ALTER TABLE user_tbl
ADD CONSTRAINT check_gender CHECK (gender IN ('Male', 'Female', 'Other', NULL));

-- Create index for gender queries (optional, useful for reporting)
CREATE INDEX IF NOT EXISTS idx_user_gender ON user_tbl(gender);

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ Successfully added gender column to user_tbl';
  RAISE NOTICE 'Valid values: Male, Female, Other, or NULL';
END $$;
