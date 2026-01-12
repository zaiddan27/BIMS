-- ============================================
-- CLEAN AND CREATE SAMPLE ANNOUNCEMENTS
-- ============================================
-- This script will:
-- 1. Archive all existing announcements
-- 2. Create 5 new sample announcements
-- ============================================

-- Step 1: Archive ALL existing announcements
-- (Soft delete - sets contentStatus to 'ARCHIVED')
UPDATE "Announcement_Tbl"
SET
  "contentStatus" = 'ARCHIVED',
  "updatedAt" = NOW()
WHERE "contentStatus" = 'ACTIVE';

-- Verify all announcements are archived
SELECT
  "announcementID",
  "title",
  "contentStatus",
  "publishedDate"
FROM "Announcement_Tbl"
WHERE "contentStatus" = 'ACTIVE';
-- Should return 0 rows

-- Step 2: Create 5 NEW sample announcements
-- Get the current SK Official's userID first
-- Replace 'YOUR_USER_ID' with your actual userID from the session

-- Sample 1: URGENT - Youth Summit 2026
INSERT INTO "Announcement_Tbl" (
  "userID",
  "title",
  "category",
  "contentStatus",
  "description",
  "imagePathURL",
  "publishedDate",
  "createdAt",
  "updatedAt"
) VALUES (
  '39f5af8b-914a-448e-b6dc-a630f0938b72', -- Replace with your actual userID
  'Youth Leadership Summit 2026',
  'URGENT',
  'ACTIVE',
  'Join us for the annual Youth Leadership Summit! Network with fellow leaders, attend workshops, and develop your leadership skills. Registration deadline: January 31, 2026.',
  NULL,
  NOW(),
  NOW(),
  NOW()
);

-- Sample 2: UPDATE - Community Cleanup Success
INSERT INTO "Announcement_Tbl" (
  "userID",
  "title",
  "category",
  "contentStatus",
  "description",
  "imagePathURL",
  "publishedDate",
  "createdAt",
  "updatedAt"
) VALUES (
  '39f5af8b-914a-448e-b6dc-a630f0938b72', -- Replace with your actual userID
  'Community Cleanup Drive - Success!',
  'UPDATE',
  'ACTIVE',
  'Thank you to all 45 volunteers who participated in last Saturday''s community cleanup drive! Together, we collected 200kg of waste and planted 30 trees. See photos on our Facebook page.',
  NULL,
  NOW() - INTERVAL '2 days',
  NOW(),
  NOW()
);

-- Sample 3: GENERAL - Free Skills Workshop
INSERT INTO "Announcement_Tbl" (
  "userID",
  "title",
  "category",
  "contentStatus",
  "description",
  "imagePathURL",
  "publishedDate",
  "createdAt",
  "updatedAt"
) VALUES (
  '39f5af8b-914a-448e-b6dc-a630f0938b72', -- Replace with your actual userID
  'Free Digital Skills Workshop - February 2026',
  'GENERAL',
  'ACTIVE',
  'Learn web design, social media marketing, and basic programming! Open to all youth ages 15-30. Limited slots available. Workshop runs every Saturday for 4 weeks starting February 8.',
  NULL,
  NOW() - INTERVAL '5 days',
  NOW(),
  NOW()
);

-- Sample 4: URGENT - Basketball League Registration
INSERT INTO "Announcement_Tbl" (
  "userID",
  "title",
  "category",
  "contentStatus",
  "description",
  "imagePathURL",
  "publishedDate",
  "createdAt",
  "updatedAt"
) VALUES (
  '39f5af8b-914a-448e-b6dc-a630f0938b72', -- Replace with your actual userID
  'SK Basketball League 2026 - Register Now!',
  'URGENT',
  'ACTIVE',
  'The annual SK Basketball League is back! Form your teams and register before January 25. Games start February 1. Age categories: 13-15, 16-18, 19-21. Championship prize: ₱10,000!',
  NULL,
  NOW() - INTERVAL '1 hour',
  NOW(),
  NOW()
);

-- Sample 5: UPDATE - Scholarship Applications Open
INSERT INTO "Announcement_Tbl" (
  "userID",
  "title",
  "category",
  "contentStatus",
  "description",
  "imagePathURL",
  "publishedDate",
  "createdAt",
  "updatedAt"
) VALUES (
  '39f5af8b-914a-448e-b6dc-a630f0938b72', -- Replace with your actual userID
  'SK Scholarship Program - Applications Now Open',
  'UPDATE',
  'ACTIVE',
  'We are now accepting applications for the SK Scholarship Program 2026! Available for college students with GPA of 2.5 or higher. Deadline: February 15, 2026. Download application form from our website.',
  NULL,
  NOW() - INTERVAL '3 days',
  NOW(),
  NOW()
);

-- Step 3: Verify new announcements were created
SELECT
  "announcementID",
  "title",
  "category",
  "publishedDate",
  "contentStatus"
FROM "Announcement_Tbl"
WHERE "contentStatus" = 'ACTIVE'
ORDER BY "publishedDate" DESC;
-- Should return 5 rows

-- ============================================
-- DONE! You should now have 5 fresh sample announcements
-- ============================================
