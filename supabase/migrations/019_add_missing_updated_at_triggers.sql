-- Migration 019: Add missing updatedAt triggers + audit fixes (2026-03-07)
--
-- Tables with updatedAt column but no auto-update trigger:
-- Pre_Project_Tbl, Post_Project_Tbl, Captain_Tbl, Announcement_Tbl, Report_Tbl
--
-- Data fixes:
-- 1. Fixed Zaiddan Sy role from CAPTAIN to SK_OFFICIAL (he is SK_CHAIRMAN)
-- 2. Fixed RYAN PAOLO name casing to Title Case
-- 3. Updated prevent_role_escalation to allow postgres superuser bypass

-- Fix prevent_role_escalation to allow postgres admin changes
CREATE OR REPLACE FUNCTION prevent_role_escalation()
RETURNS TRIGGER AS $$
BEGIN
  IF current_user = 'postgres' THEN
    RETURN NEW;
  END IF;
  IF (OLD."role" IS DISTINCT FROM NEW."role"
      OR OLD."accountStatus" IS DISTINCT FROM NEW."accountStatus") THEN
    IF NOT EXISTS (
      SELECT 1 FROM "User_Tbl"
      WHERE "userID" = (select auth.uid())
      AND "role" = 'SUPERADMIN'
    ) THEN
      NEW."role" := OLD."role";
      NEW."accountStatus" := OLD."accountStatus";
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Add updatedAt triggers
CREATE TRIGGER update_preproject_updated_at
  BEFORE UPDATE ON "Pre_Project_Tbl"
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_postproject_updated_at
  BEFORE UPDATE ON "Post_Project_Tbl"
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_captain_updated_at
  BEFORE UPDATE ON "Captain_Tbl"
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_announcement_updated_at
  BEFORE UPDATE ON "Announcement_Tbl"
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_report_updated_at
  BEFORE UPDATE ON "Report_Tbl"
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
