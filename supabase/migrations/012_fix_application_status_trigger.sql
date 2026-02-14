-- ============================================
-- Fix: Application status trigger column casing
--
-- Problem: notify_application_status() uses unquoted column names
-- (OLD.applicationStatus) which PostgreSQL folds to lowercase.
-- The actual column is "applicationStatus" (camelCase), so the
-- trigger fails with: record "old" has no field "applicationstatus"
--
-- Fix: Quote all camelCase column references in the trigger function
-- ============================================

-- Recreate the trigger function with properly quoted column names
CREATE OR REPLACE FUNCTION public.notify_application_status()
RETURNS TRIGGER AS $$
DECLARE
  v_project_title VARCHAR(255);
BEGIN
  -- Only notify on status change
  IF OLD."applicationStatus" != NEW."applicationStatus" THEN
    -- Get project title
    SELECT title INTO v_project_title
    FROM "Pre_Project_Tbl"
    WHERE "preProjectID" = NEW."preProjectID";

    -- Create notification based on new status
    IF NEW."applicationStatus" = 'APPROVED' THEN
      PERFORM create_notification(
        NEW."userID",
        'application_approved',
        'Your application for "' || v_project_title || '" has been approved!'
      );
    ELSIF NEW."applicationStatus" = 'REJECTED' THEN
      PERFORM create_notification(
        NEW."userID",
        'application_pending',
        'Your application for "' || v_project_title || '" status has been updated'
      );
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Recreate the trigger (in case it was dropped)
DROP TRIGGER IF EXISTS on_application_status_changed ON "Application_Tbl";
CREATE TRIGGER on_application_status_changed
  AFTER UPDATE ON "Application_Tbl"
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_application_status();

-- ============================================
-- Also fix RLS policies that use unquoted applicationStatus
-- ============================================

-- Drop and recreate the policies with proper quoting
DROP POLICY IF EXISTS "Users can update pending applications" ON "Application_Tbl";
CREATE POLICY "Users can update pending applications"
ON "Application_Tbl"
FOR UPDATE
TO authenticated
USING (
  "userID" = auth.uid() AND
  "applicationStatus" = 'PENDING'
);

DROP POLICY IF EXISTS "Users can delete pending applications" ON "Application_Tbl";
CREATE POLICY "Users can delete pending applications"
ON "Application_Tbl"
FOR DELETE
TO authenticated
USING (
  "userID" = auth.uid() AND
  "applicationStatus" = 'PENDING'
);
