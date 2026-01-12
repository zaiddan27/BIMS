-- ============================================
-- BIMS Add SUPERADMIN Role
-- Barangay Information Management System
-- ============================================

-- ============================================
-- 1. UPDATE User_Tbl role enum to include SUPERADMIN
-- ============================================

-- Drop the existing CHECK constraint
ALTER TABLE User_Tbl DROP CONSTRAINT IF EXISTS user_tbl_role_check;

-- Add new CHECK constraint with SUPERADMIN
ALTER TABLE User_Tbl
ADD CONSTRAINT user_tbl_role_check
CHECK (role IN ('SUPERADMIN', 'CAPTAIN', 'SK_OFFICIAL', 'YOUTH_VOLUNTEER'));

-- ============================================
-- 2. ADD HELPER FUNCTIONS FOR ROLE CHECKING
-- ============================================

-- Check if user is SUPERADMIN
CREATE OR REPLACE FUNCTION is_superadmin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM User_Tbl
    WHERE userID = auth.uid() AND role = 'SUPERADMIN'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Check if user is SUPERADMIN or CAPTAIN
CREATE OR REPLACE FUNCTION is_superadmin_or_captain()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM User_Tbl
    WHERE userID = auth.uid() AND role IN ('SUPERADMIN', 'CAPTAIN')
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 3. UPDATE RLS POLICIES - User Management
-- ============================================

-- DROP old Captain policies for user management
DROP POLICY IF EXISTS "Captain can change user roles" ON User_Tbl;
DROP POLICY IF EXISTS "Captain can view all users" ON User_Tbl;

-- DROP old SK Officials policy that allowed account status updates (Option A restructure)
DROP POLICY IF EXISTS "SK Officials can update account status" ON User_Tbl;

-- SUPERADMIN can view all users
CREATE POLICY "Superadmin can view all users"
ON User_Tbl FOR SELECT
TO authenticated
USING (is_superadmin());

-- SUPERADMIN can change user roles (except own role)
CREATE POLICY "Superadmin can change user roles"
ON User_Tbl FOR UPDATE
TO authenticated
USING (
  is_superadmin() AND
  userID != auth.uid()  -- Cannot change own role
)
WITH CHECK (
  is_superadmin() AND
  userID != auth.uid()
);

-- SUPERADMIN can manage SK_Tbl
DROP POLICY IF EXISTS "Captain can manage SK assignments" ON SK_Tbl;

CREATE POLICY "Superadmin can view SK assignments"
ON SK_Tbl FOR SELECT
TO authenticated
USING (is_superadmin());

CREATE POLICY "Superadmin can create SK assignments"
ON SK_Tbl FOR INSERT
TO authenticated
WITH CHECK (is_superadmin());

CREATE POLICY "Superadmin can delete SK assignments"
ON SK_Tbl FOR DELETE
TO authenticated
USING (is_superadmin());

-- ============================================
-- 4. UPDATE LOGS & AUDIT TRAIL ACCESS
-- ============================================

-- DROP old policies
DROP POLICY IF EXISTS "Captain can view logs" ON Logs_Tbl;
DROP POLICY IF EXISTS "SK Officials can view their logs" ON Logs_Tbl;

-- SUPERADMIN can view all logs
CREATE POLICY "Superadmin can view all logs"
ON Logs_Tbl FOR SELECT
TO authenticated
USING (is_superadmin());

-- Users can still create their own logs
CREATE POLICY "Users can create their own logs"
ON Logs_Tbl FOR INSERT
TO authenticated
WITH CHECK (userID = auth.uid());

-- ============================================
-- 5. CAPTAIN GETS ARCHIVE VIEW ACCESS
-- ============================================

-- Captain can view archived content (read-only)
CREATE POLICY "Captain can view archived announcements"
ON Announcement_Tbl FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM User_Tbl
    WHERE userID = auth.uid() AND role = 'CAPTAIN'
  ) AND contentStatus = 'ARCHIVED'
);

CREATE POLICY "Captain can view archived files"
ON File_Tbl FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM User_Tbl
    WHERE userID = auth.uid() AND role = 'CAPTAIN'
  ) AND fileStatus = 'ARCHIVED'
);

CREATE POLICY "Captain can view all projects"
ON Pre_Project_Tbl FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM User_Tbl
    WHERE userID = auth.uid() AND role = 'CAPTAIN'
  )
);

-- ============================================
-- 6. UPDATE NOTIFICATION TYPES
-- ============================================

-- Drop existing constraint
ALTER TABLE Notification_Tbl DROP CONSTRAINT IF EXISTS notification_tbl_notificationtype_check;

-- Add new constraint with additional notification types
ALTER TABLE Notification_Tbl
ADD CONSTRAINT notification_tbl_notificationtype_check
CHECK (notificationType IN (
  'new_announcement', 'inquiry_update', 'new_project',
  'application_approved', 'application_pending', 'project_approved',
  'project_rejected', 'revision_requested', 'new_inquiry',
  'new_application', 'project_awaiting_approval',
  'user_promoted', 'user_deactivated', 'user_reactivated',
  'captain_term_expiring', 'captain_term_expired'
));

-- ============================================
-- 7. FUNCTION TO PROMOTE USER TO SUPERADMIN
-- ============================================

-- Only existing SUPERADMIN can promote others to SUPERADMIN
CREATE OR REPLACE FUNCTION promote_to_superadmin(
  p_user_id UUID
)
RETURNS VOID AS $$
BEGIN
  -- Check if caller is SUPERADMIN
  IF NOT is_superadmin() THEN
    RAISE EXCEPTION 'Only SUPERADMIN can promote users to SUPERADMIN';
  END IF;

  -- Update user role
  UPDATE User_Tbl
  SET role = 'SUPERADMIN', accountStatus = 'ACTIVE'
  WHERE userID = p_user_id;

  -- Create notification
  INSERT INTO Notification_Tbl (userID, notificationType, title)
  VALUES (
    p_user_id,
    'user_promoted',
    'You have been promoted to System Administrator (SUPERADMIN)'
  );

  -- Log the change
  INSERT INTO Logs_Tbl (userID, action)
  VALUES (
    auth.uid(),
    '[AUDIT] Promoted user ' || p_user_id || ' to SUPERADMIN'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- COMMENTS
-- ============================================

COMMENT ON FUNCTION is_superadmin IS 'Check if current user is SUPERADMIN';
COMMENT ON FUNCTION is_superadmin_or_captain IS 'Check if current user is SUPERADMIN or CAPTAIN';
COMMENT ON FUNCTION promote_to_superadmin IS 'Promote user to SUPERADMIN role (only SUPERADMIN can call)';

-- ============================================
-- INITIAL SUPERADMIN SETUP
-- ============================================

-- NOTE: After running this migration, you need to manually promote
-- the first SUPERADMIN via SQL:
--
-- UPDATE User_Tbl
-- SET role = 'SUPERADMIN', accountStatus = 'ACTIVE'
-- WHERE email = 'admin@barangaymalanday.gov.ph';
--
-- After first SUPERADMIN is created, they can promote others via the UI.
