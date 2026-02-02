-- =====================================================
-- Fix Foreign Key Constraint for Reply_Tbl
-- The foreign key was created without quotes, causing
-- PostgreSQL to look for "inquiry_tbl" (lowercase)
-- instead of "Inquiry_Tbl" (exact case)
-- =====================================================

-- First, find and drop the existing foreign key constraint
-- (The constraint name might vary, so we'll use the information_schema to find it)

DO $$
DECLARE
    constraint_name TEXT;
BEGIN
    -- Find the foreign key constraint name
    SELECT tc.constraint_name INTO constraint_name
    FROM information_schema.table_constraints tc
    JOIN information_schema.constraint_column_usage ccu
        ON tc.constraint_name = ccu.constraint_name
    WHERE tc.table_name = 'Reply_Tbl'
        AND tc.constraint_type = 'FOREIGN KEY'
        AND ccu.column_name = 'inquiryID'
    LIMIT 1;

    -- Drop the constraint if it exists
    IF constraint_name IS NOT NULL THEN
        EXECUTE 'ALTER TABLE "Reply_Tbl" DROP CONSTRAINT IF EXISTS "' || constraint_name || '"';
        RAISE NOTICE 'Dropped constraint: %', constraint_name;
    ELSE
        RAISE NOTICE 'No foreign key constraint found for inquiryID';
    END IF;
END $$;

-- Recreate the foreign key with proper quoting
ALTER TABLE "Reply_Tbl"
ADD CONSTRAINT "Reply_Tbl_inquiryID_fkey"
FOREIGN KEY ("inquiryID")
REFERENCES "Inquiry_Tbl"("inquiryID")
ON DELETE CASCADE;

-- Verify the constraint was created
SELECT
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_name = 'Reply_Tbl';
