-- ===========================
-- Check Notification Setup for NotificationModal.js Component
-- ===========================

-- 1. Check Notification_Tbl table structure
SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'Notification_Tbl'
ORDER BY ordinal_position;

-- Expected columns:
-- notificationID (SERIAL PRIMARY KEY)
-- userID (UUID FOREIGN KEY)
-- notificationType (VARCHAR(50))
-- title (VARCHAR(255))
-- isRead (BOOLEAN DEFAULT FALSE)
-- createdAt (TIMESTAMPTZ DEFAULT NOW())

-- 2. Check RLS policies on Notification_Tbl
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE tablename = 'Notification_Tbl'
ORDER BY policyname;

-- Expected policies:
-- - Users can view own notifications (SELECT)
-- - Users can update own notifications (UPDATE for isRead)
-- - SK Officials/Captain can insert notifications (INSERT)
-- - Users can delete own notifications (DELETE - optional)

-- 3. Check if RLS is enabled
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public' AND tablename = 'Notification_Tbl';

-- Should return: rowsecurity = true

-- 4. Check sample notifications (test data)
SELECT
    notificationID,
    userID,
    notificationType,
    title,
    isRead,
    createdAt
FROM "Notification_Tbl"
ORDER BY createdAt DESC
LIMIT 10;

-- 5. Check notification types in use
SELECT
    notificationType,
    COUNT(*) as count,
    COUNT(*) FILTER (WHERE isRead = false) as unread_count
FROM "Notification_Tbl"
GROUP BY notificationType
ORDER BY count DESC;

-- ===========================
-- Create Sample Notifications (Optional)
-- ===========================

/*
-- Sample notification for SK Official
INSERT INTO "Notification_Tbl" (userID, notificationType, title, isRead, createdAt)
VALUES
    ('<YOUR_SK_OFFICIAL_USER_ID>', 'new_application', 'New volunteer application received for Community Clean-up Drive', false, NOW()),
    ('<YOUR_SK_OFFICIAL_USER_ID>', 'new_inquiry', 'New inquiry posted on Youth Sports Fest project', false, NOW() - INTERVAL '1 hour'),
    ('<YOUR_SK_OFFICIAL_USER_ID>', 'project_awaiting_approval', 'Project "Summer Reading Program" is awaiting captain approval', false, NOW() - INTERVAL '2 hours');

-- Sample notification for Youth Volunteer
INSERT INTO "Notification_Tbl" (userID, notificationType, title, isRead, createdAt)
VALUES
    ('<YOUR_YOUTH_USER_ID>', 'new_announcement', 'New announcement: Community Meeting this Saturday', false, NOW()),
    ('<YOUR_YOUTH_USER_ID>', 'application_approved', 'Your application for "Tree Planting Activity" has been approved', false, NOW() - INTERVAL '30 minutes'),
    ('<YOUR_YOUTH_USER_ID>', 'new_project', 'New project posted: Skills Training Workshop', false, NOW() - INTERVAL '1 day');

-- Sample notification for Captain
INSERT INTO "Notification_Tbl" (userID, notificationType, title, isRead, createdAt)
VALUES
    ('<YOUR_CAPTAIN_USER_ID>', 'project_awaiting_approval', 'Project "Basketball League 2026" requires your approval', false, NOW()),
    ('<YOUR_CAPTAIN_USER_ID>', 'new_announcement', 'SK Officials posted: Budget Allocation Update', false, NOW() - INTERVAL '2 hours');
*/

-- ===========================
-- Verify Helper Functions for RLS
-- ===========================

-- Check if is_sk_official() function exists
SELECT routine_name, routine_type
FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_name IN ('is_sk_official', 'is_captain', 'is_sk_official_or_captain');
