-- ============================================
-- Add Rating Column to Testimonies_Tbl
-- ============================================
-- This migration adds a rating column to store star ratings (1-5)

-- Add rating column to testimonies table
ALTER TABLE testimonies_tbl
ADD COLUMN IF NOT EXISTS rating INTEGER;

-- Add check constraint to ensure rating is between 1 and 5
ALTER TABLE testimonies_tbl
ADD CONSTRAINT check_rating_range CHECK (rating >= 1 AND rating <= 5);

-- Add index for rating queries (useful for filtering/sorting by rating)
CREATE INDEX IF NOT EXISTS idx_testimonies_rating ON testimonies_tbl(rating);

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ Successfully added rating column to testimonies_tbl';
  RAISE NOTICE 'Valid values: 1, 2, 3, 4, or 5 stars';
  RAISE NOTICE 'Column is optional (NULL allowed for testimonies without ratings)';
END $$;
