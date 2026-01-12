-- ============================================
-- BIMS Captain Table & Term Tracking
-- Barangay Information Management System
-- ============================================

-- Captain_Tbl: Track Barangay Captain terms
-- Similar to SK_Tbl but for Captain position
CREATE TABLE Captain_Tbl (
  captainID SERIAL PRIMARY KEY,
  userID UUID NOT NULL REFERENCES User_Tbl(userID) ON DELETE CASCADE,
  termStart DATE NOT NULL,
  termEnd DATE NOT NULL,
  isActive BOOLEAN NOT NULL DEFAULT TRUE,
  createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  -- Only one active Captain at a time
  CONSTRAINT check_only_one_active_captain UNIQUE NULLS NOT DISTINCT (isActive),
  -- Prevent overlapping terms
  EXCLUDE USING gist (
    tsrange(termStart, termEnd) WITH &&
  ) WHERE (isActive = TRUE)
);

CREATE INDEX idx_captain_user ON Captain_Tbl(userID);
CREATE INDEX idx_captain_term ON Captain_Tbl(termStart, termEnd);
CREATE INDEX idx_captain_active ON Captain_Tbl(isActive);

-- Trigger for updatedAt
CREATE TRIGGER update_captain_updated_at BEFORE UPDATE ON Captain_Tbl
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- FUNCTION: Check if Captain term has expired
-- ============================================

CREATE OR REPLACE FUNCTION check_captain_term_expiration()
RETURNS TABLE (
  userID UUID,
  firstName VARCHAR(100),
  lastName VARCHAR(100),
  email VARCHAR(255),
  termEnd DATE,
  daysRemaining INTEGER,
  hasExpired BOOLEAN
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    u.userID,
    u.firstName,
    u.lastName,
    u.email,
    c.termEnd,
    (c.termEnd - CURRENT_DATE)::INTEGER AS daysRemaining,
    (c.termEnd < CURRENT_DATE) AS hasExpired
  FROM Captain_Tbl c
  JOIN User_Tbl u ON c.userID = u.userID
  WHERE c.isActive = TRUE;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- FUNCTION: Designate new Captain
-- ============================================

CREATE OR REPLACE FUNCTION designate_new_captain(
  p_new_captain_user_id UUID,
  p_term_start DATE,
  p_term_end DATE
)
RETURNS VOID AS $$
DECLARE
  v_old_captain_user_id UUID;
BEGIN
  -- Get current active Captain
  SELECT userID INTO v_old_captain_user_id
  FROM Captain_Tbl
  WHERE isActive = TRUE
  LIMIT 1;

  -- Deactivate old Captain term
  IF v_old_captain_user_id IS NOT NULL THEN
    UPDATE Captain_Tbl
    SET isActive = FALSE
    WHERE userID = v_old_captain_user_id AND isActive = TRUE;

    -- Change old Captain's role to YOUTH_VOLUNTEER
    UPDATE User_Tbl
    SET role = 'YOUTH_VOLUNTEER'
    WHERE userID = v_old_captain_user_id;

    -- Log the change
    INSERT INTO Logs_Tbl (userID, action)
    VALUES (
      v_old_captain_user_id,
      '[AUDIT] Captain term ended and role changed to YOUTH_VOLUNTEER'
    );
  END IF;

  -- Set new Captain role
  UPDATE User_Tbl
  SET role = 'CAPTAIN', accountStatus = 'ACTIVE'
  WHERE userID = p_new_captain_user_id;

  -- Create Captain term record
  INSERT INTO Captain_Tbl (userID, termStart, termEnd, isActive)
  VALUES (p_new_captain_user_id, p_term_start, p_term_end, TRUE);

  -- Create notification for new Captain
  INSERT INTO Notification_Tbl (userID, notificationType, title)
  VALUES (
    p_new_captain_user_id,
    'new_announcement',
    'You have been designated as Barangay Captain'
  );

  -- Log the change
  INSERT INTO Logs_Tbl (userID, action)
  VALUES (
    p_new_captain_user_id,
    '[AUDIT] Designated as new Barangay Captain'
  );
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- RLS POLICIES for Captain_Tbl
-- ============================================

ALTER TABLE Captain_Tbl ENABLE ROW LEVEL SECURITY;

-- Captain and SK Officials can view Captain records
CREATE POLICY "Captain and SK Officials can view Captain records"
ON Captain_Tbl FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM User_Tbl
    WHERE userID = auth.uid() AND role IN ('CAPTAIN', 'SK_OFFICIAL')
  )
);

-- Only system admin can insert/update Captain records
-- (This should be done via the designate_new_captain function)
CREATE POLICY "System function can manage Captain records"
ON Captain_Tbl FOR ALL
TO authenticated
USING (FALSE)
WITH CHECK (FALSE);

-- ============================================
-- COMMENTS
-- ============================================

COMMENT ON TABLE Captain_Tbl IS 'Tracks Barangay Captain terms and succession';
COMMENT ON COLUMN Captain_Tbl.isActive IS 'Only one Captain can be active at a time';
COMMENT ON FUNCTION designate_new_captain IS 'Handles Captain succession: deactivate old, activate new';
COMMENT ON FUNCTION check_captain_term_expiration IS 'Check if current Captain term has expired or is expiring soon';
