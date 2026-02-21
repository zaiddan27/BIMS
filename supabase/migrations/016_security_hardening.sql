-- =====================================================
-- BIMS Migration 016: Security Hardening
-- =====================================================
-- Date: 2026-02-21
-- Fixes:
--   C1: Prevent user self-role-escalation via trigger
--   H3: Restrict Notification_Tbl INSERT policy
--   H10: Restrict Inquiry_Tbl and Reply_Tbl SELECT policies
-- =====================================================

-- =====================================================
-- PART 1: PREVENT ROLE ESCALATION (C1 — CRITICAL)
-- =====================================================
-- Without this, any authenticated user can change their
-- own role/accountStatus by calling:
--   supabaseClient.from('User_Tbl').update({ role: 'SK_OFFICIAL' })
-- The trigger silently reverts protected fields unless
-- the caller is a SUPERADMIN.
-- =====================================================

CREATE OR REPLACE FUNCTION prevent_role_escalation()
RETURNS TRIGGER AS $$
BEGIN
  -- Only SUPERADMIN can change role or accountStatus
  IF (OLD."role" IS DISTINCT FROM NEW."role"
      OR OLD."accountStatus" IS DISTINCT FROM NEW."accountStatus") THEN
    IF NOT EXISTS (
      SELECT 1 FROM "User_Tbl"
      WHERE "userID" = (select auth.uid())
      AND "role" = 'SUPERADMIN'
    ) THEN
      -- Silently revert protected fields to their original values
      NEW."role" := OLD."role";
      NEW."accountStatus" := OLD."accountStatus";
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop if exists (idempotent)
DROP TRIGGER IF EXISTS enforce_role_protection ON "User_Tbl";

CREATE TRIGGER enforce_role_protection
BEFORE UPDATE ON "User_Tbl"
FOR EACH ROW EXECUTE FUNCTION prevent_role_escalation();

-- =====================================================
-- PART 2: FIX NOTIFICATION_TBL INSERT POLICY (H3)
-- =====================================================
-- Current: WITH CHECK (true) — any user can insert
-- notifications targeting ANY other user.
-- Fix: Only allow inserting notifications for yourself
-- OR if you are SK_OFFICIAL/CAPTAIN (who need to notify
-- volunteers about approvals, replies, etc.)
-- =====================================================

DROP POLICY IF EXISTS "auth_insert_notifications" ON "Notification_Tbl";

CREATE POLICY "auth_insert_notifications"
ON "Notification_Tbl" FOR INSERT TO authenticated
WITH CHECK (
  "userID" = (select auth.uid())
  OR is_sk_official_or_captain()
);

-- =====================================================
-- PART 3: FIX INQUIRY_TBL SELECT POLICY (H10)
-- =====================================================
-- Current: USING (true) — any authenticated user can
-- read ALL inquiries from ALL users.
-- Fix: Users can only see their own inquiries OR
-- inquiries related to projects (for context), OR
-- SK officials/Captain can see all.
-- =====================================================

DROP POLICY IF EXISTS "auth_select_inquiries" ON "Inquiry_Tbl";

CREATE POLICY "auth_select_inquiries"
ON "Inquiry_Tbl" FOR SELECT TO authenticated
USING (
  "userID" = (select auth.uid())
  OR is_sk_official_or_captain()
);

-- =====================================================
-- PART 4: FIX REPLY_TBL SELECT POLICY (H10)
-- =====================================================
-- Current: USING (true) — any authenticated user can
-- read ALL replies from ALL users.
-- Fix: Users can see replies to their own inquiries
-- OR replies they authored, OR SK/Captain see all.
-- =====================================================

DROP POLICY IF EXISTS "auth_select_replies" ON "Reply_Tbl";

CREATE POLICY "auth_select_replies"
ON "Reply_Tbl" FOR SELECT TO authenticated
USING (
  "userID" = (select auth.uid())
  OR is_sk_official_or_captain()
  OR EXISTS (
    SELECT 1 FROM "Inquiry_Tbl"
    WHERE "Inquiry_Tbl"."inquiryID" = "Reply_Tbl"."inquiryID"
    AND "Inquiry_Tbl"."userID" = (select auth.uid())
  )
);
