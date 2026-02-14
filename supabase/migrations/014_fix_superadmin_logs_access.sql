-- ============================================
-- Fix: Ensure SUPERADMIN can view Logs_Tbl
--
-- Problem: The RLS policy on Logs_Tbl may only allow SK_OFFICIAL/CAPTAIN
-- but not SUPERADMIN, causing empty Recent Activity on superadmin dashboard.
--
-- Fix: Drop and recreate SELECT policies to include both SUPERADMIN and SK roles
-- ============================================

-- Drop existing SELECT policies on Logs_Tbl
DROP POLICY IF EXISTS "SK Officials can view logs" ON "Logs_Tbl";
DROP POLICY IF EXISTS "Superadmin can view all logs" ON "Logs_Tbl";
DROP POLICY IF EXISTS "Captain can view logs" ON "Logs_Tbl";
DROP POLICY IF EXISTS "SK Officials can view their logs" ON "Logs_Tbl";

-- Create a single policy that allows SUPERADMIN, SK_OFFICIAL, and CAPTAIN to view all logs
CREATE POLICY "Authorized roles can view logs"
ON "Logs_Tbl" FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM "User_Tbl"
    WHERE "userID" = auth.uid()
    AND "role" IN ('SUPERADMIN', 'SK_OFFICIAL', 'CAPTAIN')
  )
);
