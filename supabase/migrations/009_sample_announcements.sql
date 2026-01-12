-- ============================================
-- Sample Announcements Migration
-- ============================================
-- This migration adds 7 sample announcements for initial testing
-- These announcements will appear on the youth volunteer dashboard

-- Note: We need a valid SK Official userID to be the creator
-- The query below automatically selects the first SK Official or Superadmin
-- If no SK Official or Superadmin exists, the insert will fail

-- To verify you have a valid user, first run:
-- SELECT userid, email, role FROM user_tbl WHERE role IN ('SK_OFFICIAL', 'SUPERADMIN');
-- If no results, you need to create an SK Official or Superadmin user first

-- Sample Announcements (7 total)
INSERT INTO announcement_tbl (
  userid,
  title,
  category,
  contentstatus,
  description,
  imagepathurl,
  publisheddate
) VALUES
-- 1. Youth Sports Festival 2025 (URGENT)
(
  (SELECT userid FROM user_tbl WHERE role IN ('SK_OFFICIAL', 'SUPERADMIN') LIMIT 1),
  'Youth Sports Festival 2025',
  'URGENT',
  'ACTIVE',
  'Join us for basketball, volleyball, and more. Open to youth aged 15–30. This is a great opportunity to showcase your athletic skills, meet other young athletes, and represent SK Malanday. Registration opens November 18, 2025. Don''t miss out on this exciting event!',
  NULL,
  '2025-11-18'
),

-- 2. Free Skills Training Workshop (GENERAL)
(
  (SELECT userid FROM user_tbl WHERE role IN ('SK_OFFICIAL', 'SUPERADMIN') LIMIT 1),
  'Free Skills Training Workshop',
  'GENERAL',
  'ACTIVE',
  'Digital marketing, design, and programming basics. Limited slots available! This workshop is designed to help youth develop in-demand digital skills that can boost their career prospects. Topics include social media marketing, graphic design with Canva, and introduction to web development. Register now as seats are limited to 30 participants!',
  NULL,
  '2025-11-25'
),

-- 3. Scholarship Program Now Open (UPDATE)
(
  (SELECT userid FROM user_tbl WHERE role IN ('SK_OFFICIAL', 'SUPERADMIN') LIMIT 1),
  'Scholarship Program Now Open',
  'UPDATE',
  'ACTIVE',
  'Apply now — deadline December 15, 2025. The SK Malanday Scholarship Program provides financial assistance to deserving youth volunteers who have demonstrated commitment to community service. Scholarship covers tuition fees for one semester. Eligibility requirements and application form available at the SK office.',
  NULL,
  '2025-11-15'
),

-- 4. Community Clean-Up Drive (URGENT)
(
  (SELECT userid FROM user_tbl WHERE role IN ('SK_OFFICIAL', 'SUPERADMIN') LIMIT 1),
  'Community Clean-Up Drive',
  'URGENT',
  'ACTIVE',
  'Help clean up our community parks and rivers. Volunteers needed! Join us on December 5, 2025 at 6:00 AM for our quarterly clean-up drive. We will be cleaning Malanday River and surrounding parks. Bring gloves, face masks, and your commitment to a cleaner Malanday. Breakfast and certificates will be provided to all volunteers.',
  NULL,
  '2025-12-05'
),

-- 5. Youth Leadership Summit 2025 (GENERAL)
(
  (SELECT userid FROM user_tbl WHERE role IN ('SK_OFFICIAL', 'SUPERADMIN') LIMIT 1),
  'Youth Leadership Summit 2025',
  'GENERAL',
  'ACTIVE',
  'Develop your leadership skills at our annual summit. The Youth Leadership Summit brings together young leaders from across Marikina City for a day of workshops, networking, and inspiration. Topics include public speaking, project management, and community organizing. This is your chance to learn from experienced leaders and connect with fellow youth volunteers. December 10, 2025 at Marikina Sports Center.',
  NULL,
  '2025-12-10'
),

-- 6. Christmas Gift-Giving Project (URGENT)
(
  (SELECT userid FROM user_tbl WHERE role IN ('SK_OFFICIAL', 'SUPERADMIN') LIMIT 1),
  'Christmas Gift-Giving Project',
  'URGENT',
  'ACTIVE',
  'Bring joy to children this Christmas. Donate or volunteer! SK Malanday is organizing a gift-giving program for 200 underprivileged children in our barangay. We need volunteers to help wrap gifts, organize the event, and distribute presents on December 20, 2025. You can also donate toys, books, or school supplies. Let''s spread Christmas cheer together!',
  NULL,
  '2025-12-20'
),

-- 7. New Year Planning Meeting (UPDATE)
(
  (SELECT userid FROM user_tbl WHERE role IN ('SK_OFFICIAL', 'SUPERADMIN') LIMIT 1),
  'New Year Planning Meeting',
  'UPDATE',
  'ACTIVE',
  'Planning for 2026 projects and initiatives. All youth volunteers are invited to join our first planning meeting of 2026 on January 3rd. We will be discussing upcoming projects, gathering ideas from volunteers, and setting goals for the new year. Your input matters! This is your chance to shape the direction of SK Malanday programs. Meeting will be held at the Barangay Hall, 2:00 PM.',
  NULL,
  '2026-01-03'
);

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ Successfully inserted 7 sample announcements';
  RAISE NOTICE 'Note: All announcements are set to ACTIVE status';
  RAISE NOTICE 'Categories: 3 URGENT, 2 GENERAL, 2 UPDATE';
END $$;
