-- ============================================
-- Fix update_updated_at_column - Proper Field Reference
-- Issue: NEW.updatedAt is converted to lowercase by PostgreSQL
-- Solution: Use NEW."updatedAt" with quotes
-- ============================================

-- Drop existing function
DROP FUNCTION IF EXISTS public.update_updated_at_column() CASCADE;

-- Recreate with proper field reference using quotes
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  -- Use quoted identifier to preserve camelCase
  NEW."updatedAt" = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Recreate trigger on User_Tbl
CREATE TRIGGER update_user_updated_at
  BEFORE UPDATE ON public."User_Tbl"
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Migration complete
-- Fixed: NEW.updatedAt → NEW."updatedAt" to preserve camelCase in PL/pgSQL
