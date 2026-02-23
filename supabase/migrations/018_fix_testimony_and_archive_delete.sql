-- ============================================
-- Migration 018: Fix testimony and archive delete RLS
--
-- Problem 1: Testimonies_Tbl has no DELETE policy.
--   SK officials cannot delete testimonies from sk-testimonies.html
--   because RLS silently blocks the delete.
--
-- Problem 2: Pre_Project_Tbl DELETE policy only allows
--   is_sk_official() AND userID = auth.uid().
--   Captains who access sk-archive.html cannot delete
--   archived projects because is_captain() is not included.
-- ============================================

-- ============================================
-- PART 1: Add DELETE policy for Testimonies_Tbl
-- SK officials and Captains can delete any testimony
-- ============================================

CREATE POLICY "auth_delete_testimonies"
ON "Testimonies_Tbl" FOR DELETE
TO authenticated
USING (is_sk_official_or_captain());

-- ============================================
-- PART 2: Expand Pre_Project_Tbl DELETE policy
-- Allow Captains to delete archived projects
-- (previously only SK who created the project could delete)
-- ============================================

DROP POLICY IF EXISTS "auth_delete_projects" ON "Pre_Project_Tbl";

CREATE POLICY "auth_delete_projects"
ON "Pre_Project_Tbl" FOR DELETE
TO authenticated
USING (
  (is_sk_official() AND "userID" = (select auth.uid()))
  OR is_captain()
);
