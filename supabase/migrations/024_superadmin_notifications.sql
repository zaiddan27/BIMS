-- Migration 024: Superadmin notification triggers (2026-03-31)
--
-- Creates automatic notifications for superadmins when:
-- 1. New user signs up
-- 2. New project is created
-- 3. User account status changes
-- 4. User role changes
--
-- Also updates Notification_Tbl CHECK constraint to include new types

-- Update CHECK constraint to include superadmin notification types
ALTER TABLE "Notification_Tbl" DROP CONSTRAINT IF EXISTS notification_tbl_notificationtype_check;
ALTER TABLE "Notification_Tbl" ADD CONSTRAINT notification_tbl_notificationtype_check CHECK ("notificationType" IN (
  'new_announcement','inquiry_update','new_project','application_approved','application_pending',
  'project_approved','project_rejected','revision_requested','new_inquiry','new_application',
  'project_awaiting_approval','user_promoted','user_deactivated','user_reactivated',
  'captain_term_expiring','captain_term_expired',
  'new_user_signup','account_status_change','role_change','new_project_created','application_rejected'
));
-- 3. User account status changes
-- 4. User role changes

-- Helper: send notification to all active superadmins
CREATE OR REPLACE FUNCTION public.notify_superadmins(
  p_notification_type VARCHAR,
  p_title VARCHAR,
  p_reference_id INTEGER DEFAULT NULL
)
RETURNS VOID AS $$
DECLARE
  v_admin RECORD;
BEGIN
  FOR v_admin IN
    SELECT "userID" FROM "User_Tbl"
    WHERE role = 'SUPERADMIN' AND "accountStatus" = 'ACTIVE'
  LOOP
    INSERT INTO "Notification_Tbl" (
      "userID", "notificationType", title, "isRead", "referenceID", "createdAt"
    ) VALUES (
      v_admin."userID", p_notification_type, p_title, false, p_reference_id, CURRENT_TIMESTAMP
    );
  END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger: new user signup
CREATE OR REPLACE FUNCTION trg_notify_new_user()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.role != 'SUPERADMIN' THEN
    PERFORM notify_superadmins(
      'new_user_signup',
      'New user registered: ' || COALESCE(NEW."firstName", '') || ' ' || COALESCE(NEW."lastName", '') || ' (' || NEW.role || ')'
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_new_user_notify ON "User_Tbl";
CREATE TRIGGER trg_new_user_notify
  AFTER INSERT ON "User_Tbl"
  FOR EACH ROW EXECUTE FUNCTION trg_notify_new_user();

-- Trigger: new project created
CREATE OR REPLACE FUNCTION trg_notify_new_project()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM notify_superadmins(
    'new_project_created',
    'New project created: ' || COALESCE(NEW.title, 'Untitled'),
    NEW."preProjectID"
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_new_project_notify ON "Pre_Project_Tbl";
CREATE TRIGGER trg_new_project_notify
  AFTER INSERT ON "Pre_Project_Tbl"
  FOR EACH ROW EXECUTE FUNCTION trg_notify_new_project();

-- Trigger: account status or role change
CREATE OR REPLACE FUNCTION trg_notify_account_change()
RETURNS TRIGGER AS $$
BEGIN
  IF OLD."accountStatus" IS DISTINCT FROM NEW."accountStatus" THEN
    PERFORM notify_superadmins(
      'account_status_change',
      COALESCE(NEW."firstName", '') || ' ' || COALESCE(NEW."lastName", '') || ' status changed: ' || OLD."accountStatus" || ' → ' || NEW."accountStatus"
    );
  END IF;
  IF OLD.role IS DISTINCT FROM NEW.role THEN
    PERFORM notify_superadmins(
      'role_change',
      COALESCE(NEW."firstName", '') || ' ' || COALESCE(NEW."lastName", '') || ' role changed: ' || OLD.role || ' → ' || NEW.role
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_account_change_notify ON "User_Tbl";
CREATE TRIGGER trg_account_change_notify
  AFTER UPDATE ON "User_Tbl"
  FOR EACH ROW EXECUTE FUNCTION trg_notify_account_change();
