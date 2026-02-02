-- =====================================================
-- BIMS Sample Projects Data
-- Run this after setting up the database schema
-- =====================================================

-- Using Zaiddan Sy (SK_OFFICIAL) as the project creator
-- userID: ebc07d27-ba05-41d6-86cb-b7bbaa88e82c

-- =====================================================
-- PROJECT 1: ONGOING - APPROVED
-- Community Clean-Up Drive (Active project accepting volunteers)
-- =====================================================
INSERT INTO "Pre_Project_Tbl" (
    "userID",
    "skID",
    "title",
    "description",
    "category",
    "budget",
    "volunteers",
    "beneficiaries",
    "status",
    "startDateTime",
    "endDateTime",
    "location",
    "imagePathURL",
    "submittedDate",
    "approvalStatus",
    "approvalDate",
    "approvalNotes",
    "createdAt",
    "updatedAt"
) VALUES (
    'ebc07d27-ba05-41d6-86cb-b7bbaa88e82c',
    (SELECT "skID" FROM "SK_Tbl" LIMIT 1),
    'Community Clean-Up Drive 2025: Malanday River Rehabilitation',
    E'A comprehensive environmental initiative focused on rehabilitating the Malanday River system through weekly clean-up activities, waste segregation education, and community involvement.\n\nObjectives:\n• Remove accumulated waste from river and riverbanks\n• Educate residents on proper waste disposal\n• Plant trees along riverbanks\n• Establish monitoring system for illegal dumping\n\nVolunteer Roles Needed:\n• Event Coordinators\n• Documentation Team\n• Logistics Support\n• Community Educators',
    'Environment',
    35000,
    40,
    250,
    'ONGOING',
    '2025-02-01 07:00:00+08',
    '2025-03-15 17:00:00+08',
    'Malanday River and surrounding areas',
    NULL,
    '2025-01-10 10:00:00+08',
    'APPROVED',
    '2025-01-12 14:00:00+08',
    'Great initiative! The project proposal is well-structured and the budget is reasonable. Approved for implementation. Please ensure all safety protocols are followed during the event.',
    NOW(),
    NOW()
);

-- Budget breakdown for Project 1
INSERT INTO "BudgetBreakdown_Tbl" ("preProjectID", "description", "cost", "createdAt")
SELECT
    "preProjectID",
    unnest(ARRAY['Cleaning supplies and equipment', 'Trash bags and waste bins', 'Refreshments for volunteers', 'Tree saplings and planting materials', 'Signage and educational materials', 'First aid supplies', 'Transportation and logistics', 'Documentation (photos/videos)']),
    unnest(ARRAY[8000, 3500, 5000, 7500, 4000, 2000, 3000, 2000])::BIGINT,
    NOW()
FROM "Pre_Project_Tbl"
WHERE "title" = 'Community Clean-Up Drive 2025: Malanday River Rehabilitation';

-- =====================================================
-- PROJECT 2: ONGOING - APPROVED
-- Youth Sports Festival (Active sports event)
-- =====================================================
INSERT INTO "Pre_Project_Tbl" (
    "userID",
    "skID",
    "title",
    "description",
    "category",
    "budget",
    "volunteers",
    "beneficiaries",
    "status",
    "startDateTime",
    "endDateTime",
    "location",
    "imagePathURL",
    "submittedDate",
    "approvalStatus",
    "approvalDate",
    "approvalNotes",
    "createdAt",
    "updatedAt"
) VALUES (
    'ebc07d27-ba05-41d6-86cb-b7bbaa88e82c',
    (SELECT "skID" FROM "SK_Tbl" LIMIT 1),
    'Youth Sports Festival 2025',
    E'A multi-sport festival for barangay youth including basketball and volleyball tournaments.\n\nEvent Features:\n• Basketball 3v3 and 5v5 tournaments\n• Volleyball mixed teams competition\n• Fun games and activities\n• Food stalls and refreshments\n• First aid station on site\n\nRegistration required for teams. Open to all youth ages 15-30.',
    'Sports',
    25000,
    30,
    200,
    'ONGOING',
    '2025-02-15 08:00:00+08',
    '2025-02-28 18:00:00+08',
    'Barangay Covered Court',
    NULL,
    '2025-01-15 09:00:00+08',
    'APPROVED',
    '2025-01-17 11:00:00+08',
    'Approved. Great way to promote youth fitness and camaraderie. Ensure proper safety measures during games.',
    NOW(),
    NOW()
);

-- Budget breakdown for Project 2
INSERT INTO "BudgetBreakdown_Tbl" ("preProjectID", "description", "cost", "createdAt")
SELECT
    "preProjectID",
    unnest(ARRAY['Trophies and medals', 'Sports equipment', 'Venue setup and decoration', 'Refreshments', 'First aid supplies', 'Sound system rental']),
    unnest(ARRAY[5000, 8000, 4000, 5000, 1500, 1500])::BIGINT,
    NOW()
FROM "Pre_Project_Tbl"
WHERE "title" = 'Youth Sports Festival 2025';

-- =====================================================
-- PROJECT 3: COMPLETED - APPROVED
-- Scholarship Program (Finished project)
-- =====================================================
INSERT INTO "Pre_Project_Tbl" (
    "userID",
    "skID",
    "title",
    "description",
    "category",
    "budget",
    "volunteers",
    "beneficiaries",
    "status",
    "startDateTime",
    "endDateTime",
    "location",
    "imagePathURL",
    "submittedDate",
    "approvalStatus",
    "approvalDate",
    "approvalNotes",
    "createdAt",
    "updatedAt"
) VALUES (
    'ebc07d27-ba05-41d6-86cb-b7bbaa88e82c',
    (SELECT "skID" FROM "SK_Tbl" LIMIT 1),
    'SK Scholarship Program 2024',
    E'Educational assistance program for deserving students in Barangay Malanday.\n\nProgram Details:\n• Financial assistance for tuition and school supplies\n• Monthly allowance for transportation\n• Mentorship program with SK Officials\n• Academic monitoring and support\n\nEligibility:\n• Resident of Barangay Malanday\n• Enrolled in recognized school\n• Maintaining good academic standing\n• From low-income family',
    'Education',
    50000,
    10,
    25,
    'COMPLETED',
    '2024-11-01 08:00:00+08',
    '2024-12-31 17:00:00+08',
    'SK Office, Barangay Hall',
    NULL,
    '2024-10-15 10:00:00+08',
    'APPROVED',
    '2024-10-18 14:00:00+08',
    'Approved. Excellent program to support our youth education.',
    NOW() - INTERVAL '3 months',
    NOW()
);

-- Post-project record for completed project
INSERT INTO "Post_Project_Tbl" (
    "preProjectID",
    "actualVolunteer",
    "timelineAdherence",
    "beneficiariesReached",
    "projectAchievement",
    "createdAt",
    "updatedAt"
)
SELECT
    "preProjectID",
    12,
    'Completed_On_Time',
    25,
    E'Successfully provided scholarships to 25 deserving students.\n• 100% of scholars maintained passing grades\n• Distributed school supplies to all beneficiaries\n• Conducted 3 mentorship sessions\n• All scholars expressed gratitude and commitment to continue education',
    NOW(),
    NOW()
FROM "Pre_Project_Tbl"
WHERE "title" = 'SK Scholarship Program 2024';

-- =====================================================
-- PROJECT 4: PENDING APPROVAL
-- Leadership Training (Awaiting captain approval)
-- =====================================================
INSERT INTO "Pre_Project_Tbl" (
    "userID",
    "skID",
    "title",
    "description",
    "category",
    "budget",
    "volunteers",
    "beneficiaries",
    "status",
    "startDateTime",
    "endDateTime",
    "location",
    "imagePathURL",
    "submittedDate",
    "approvalStatus",
    "approvalDate",
    "approvalNotes",
    "createdAt",
    "updatedAt"
) VALUES (
    'ebc07d27-ba05-41d6-86cb-b7bbaa88e82c',
    (SELECT "skID" FROM "SK_Tbl" LIMIT 1),
    'Youth Leadership Training Workshop',
    E'A three-day intensive leadership training workshop designed to empower young leaders in our community.\n\nWorkshop Highlights:\n• Leadership fundamentals and team building\n• Effective communication and public speaking\n• Project planning and execution\n• Community engagement strategies\n• Networking with local youth leaders\n\nVolunteer Opportunities:\n• Workshop Facilitators\n• Registration Team\n• Documentation and Media Coverage\n• Logistics and Venue Coordination\n\nAll participants will receive certificates of completion.',
    'Education',
    20000,
    15,
    50,
    'ONGOING',
    '2025-03-10 08:00:00+08',
    '2025-03-12 17:00:00+08',
    'Barangay Hall Conference Room',
    NULL,
    NOW(),
    'PENDING',
    NULL,
    NULL,
    NOW(),
    NOW()
);

-- Budget breakdown for Project 4
INSERT INTO "BudgetBreakdown_Tbl" ("preProjectID", "description", "cost", "createdAt")
SELECT
    "preProjectID",
    unnest(ARRAY['Training materials and handouts', 'Certificates and tokens', 'Meals and snacks (3 days)', 'Speaker honorarium', 'Venue decoration', 'Documentation']),
    unnest(ARRAY[3000, 2000, 10000, 3000, 1000, 1000])::BIGINT,
    NOW()
FROM "Pre_Project_Tbl"
WHERE "title" = 'Youth Leadership Training Workshop';

-- =====================================================
-- PROJECT 5: PENDING REVISION
-- Health Awareness Campaign (Needs revisions)
-- =====================================================
INSERT INTO "Pre_Project_Tbl" (
    "userID",
    "skID",
    "title",
    "description",
    "category",
    "budget",
    "volunteers",
    "beneficiaries",
    "status",
    "startDateTime",
    "endDateTime",
    "location",
    "imagePathURL",
    "submittedDate",
    "approvalStatus",
    "approvalDate",
    "approvalNotes",
    "createdAt",
    "updatedAt"
) VALUES (
    'ebc07d27-ba05-41d6-86cb-b7bbaa88e82c',
    (SELECT "skID" FROM "SK_Tbl" LIMIT 1),
    'Mental Health Awareness Campaign',
    E'A community-wide campaign to raise awareness about mental health issues affecting youth.\n\nActivities:\n• Mental health seminar with licensed psychologist\n• Peer counseling training\n• Social media awareness campaign\n• Distribution of informational materials',
    'Health',
    15000,
    20,
    100,
    'ONGOING',
    '2025-04-01 09:00:00+08',
    '2025-04-30 17:00:00+08',
    'Various locations in Barangay Malanday',
    NULL,
    NOW() - INTERVAL '5 days',
    'REVISION',
    NULL,
    E'The project proposal needs more details:\n\n1. Provide specific eligibility criteria for peer counselors\n2. Include detailed budget breakdown\n3. Add timeline for each activity\n4. Specify partnership details with health professionals\n\nPlease revise and resubmit within 5 working days.',
    NOW() - INTERVAL '5 days',
    NOW()
);

-- =====================================================
-- PROJECT 6: REJECTED
-- International Exchange Program (Budget too high)
-- =====================================================
INSERT INTO "Pre_Project_Tbl" (
    "userID",
    "skID",
    "title",
    "description",
    "category",
    "budget",
    "volunteers",
    "beneficiaries",
    "status",
    "startDateTime",
    "endDateTime",
    "location",
    "imagePathURL",
    "submittedDate",
    "approvalStatus",
    "approvalDate",
    "approvalNotes",
    "createdAt",
    "updatedAt"
) VALUES (
    'ebc07d27-ba05-41d6-86cb-b7bbaa88e82c',
    (SELECT "skID" FROM "SK_Tbl" LIMIT 1),
    'International Youth Exchange Program',
    E'Youth exchange program with sister barangay in another country to promote cultural exchange and global exposure.\n\nProgram Details:\n• 2-week cultural immersion program\n• Homestay with host families\n• Community service activities\n• Cultural presentations and workshops',
    'Education',
    250000,
    5,
    10,
    'ONGOING',
    '2025-06-01 08:00:00+08',
    '2025-06-15 18:00:00+08',
    'Various International Venues',
    NULL,
    NOW() - INTERVAL '10 days',
    'REJECTED',
    NOW() - INTERVAL '7 days',
    E'After careful review, this project cannot be approved due to:\n\n1. Budget of ₱250,000 exceeds our Q1 allocation\n2. Not aligned with current barangay priorities\n3. Limited direct benefit to the community\n4. High costs for small participant pool\n\nWe suggest focusing on local programs that can benefit more residents. You may consider a local cultural exchange with nearby barangays instead, which would be more cost-effective and accessible.',
    NOW() - INTERVAL '10 days',
    NOW() - INTERVAL '7 days'
);

-- =====================================================
-- PROJECT 7: UPCOMING - APPROVED
-- Community Outreach (Approved but not yet started)
-- =====================================================
INSERT INTO "Pre_Project_Tbl" (
    "userID",
    "skID",
    "title",
    "description",
    "category",
    "budget",
    "volunteers",
    "beneficiaries",
    "status",
    "startDateTime",
    "endDateTime",
    "location",
    "imagePathURL",
    "submittedDate",
    "approvalStatus",
    "approvalDate",
    "approvalNotes",
    "createdAt",
    "updatedAt"
) VALUES (
    'ebc07d27-ba05-41d6-86cb-b7bbaa88e82c',
    (SELECT "skID" FROM "SK_Tbl" LIMIT 1),
    'Barangay Fiesta Community Outreach',
    E'Annual barangay fiesta celebration with community outreach activities.\n\nEvent Highlights:\n• Free medical and dental checkup\n• Distribution of relief goods to indigent families\n• Games and entertainment for all ages\n• Cultural performances by local groups\n• Food fair featuring local delicacies\n\nVolunteer Roles:\n• Medical mission assistants\n• Food distribution team\n• Games and activities facilitators\n• Stage crew and performers',
    'Community',
    45000,
    50,
    500,
    'ONGOING',
    '2025-05-15 06:00:00+08',
    '2025-05-15 22:00:00+08',
    'Barangay Plaza and Covered Court',
    NULL,
    NOW() - INTERVAL '3 days',
    'APPROVED',
    NOW() - INTERVAL '1 day',
    'Approved! This is a wonderful tradition. Make sure to coordinate with the health center for the medical mission.',
    NOW() - INTERVAL '3 days',
    NOW()
);

-- Budget breakdown for Project 7
INSERT INTO "BudgetBreakdown_Tbl" ("preProjectID", "description", "cost", "createdAt")
SELECT
    "preProjectID",
    unnest(ARRAY['Relief goods packages', 'Medical supplies', 'Stage and sound system', 'Food for volunteers', 'Decorations and banners', 'Prizes for games', 'Contingency']),
    unnest(ARRAY[15000, 8000, 7000, 5000, 3000, 4000, 3000])::BIGINT,
    NOW()
FROM "Pre_Project_Tbl"
WHERE "title" = 'Barangay Fiesta Community Outreach';

-- =====================================================
-- SAMPLE APPLICATIONS
-- =====================================================
-- Using Jerome Ancheta (YOUTH_VOLUNTEER): d03ea09e-cd5e-4c3e-a65a-a787a89582bd
-- Uncomment to add sample volunteer applications

/*
INSERT INTO "Application_Tbl" (
    "userID",
    "preProjectID",
    "preferredRole",
    "parentConsentFile",
    "applicationStatus",
    "appliedDate",
    "createdAt"
)
SELECT
    'd03ea09e-cd5e-4c3e-a65a-a787a89582bd',
    "preProjectID",
    'Event Volunteer',
    NULL,
    'PENDING',
    NOW(),
    NOW()
FROM "Pre_Project_Tbl"
WHERE "title" = 'Community Clean-Up Drive 2025: Malanday River Rehabilitation';
*/

-- =====================================================
-- SAMPLE INQUIRIES
-- =====================================================
-- Uncomment to add sample inquiries and replies

/*
INSERT INTO "Inquiry_Tbl" (
    "preProjectID",
    "userID",
    "message",
    "isReplied",
    "timeStamp",
    "createdAt"
)
SELECT
    "preProjectID",
    'd03ea09e-cd5e-4c3e-a65a-a787a89582bd',
    'What time po magsisimula? And do we need to bring our own cleaning materials?',
    TRUE,
    NOW() - INTERVAL '2 hours',
    NOW() - INTERVAL '2 hours'
FROM "Pre_Project_Tbl"
WHERE "title" = 'Community Clean-Up Drive 2025: Malanday River Rehabilitation';

-- Sample reply to inquiry
INSERT INTO "Reply_Tbl" (
    "inquiryID",
    "userID",
    "message",
    "timeStamp",
    "createdAt"
)
SELECT
    "inquiryID",
    'ebc07d27-ba05-41d6-86cb-b7bbaa88e82c',
    'Good day! The clean-up drive will start at 7:00 AM. Please arrive 15 minutes earlier for registration. We will provide all cleaning materials, but feel free to bring gloves if you have them. Thank you!',
    NOW() - INTERVAL '1 hour',
    NOW() - INTERVAL '1 hour'
FROM "Inquiry_Tbl"
WHERE "message" LIKE '%What time po magsisimula%';
*/

-- =====================================================
-- VERIFICATION QUERIES
-- Run these to verify the data was inserted correctly
-- =====================================================

-- Check all projects
-- SELECT "preProjectID", "title", "status", "approvalStatus", "category" FROM "Pre_Project_Tbl" ORDER BY "createdAt" DESC;

-- Check budget breakdowns
-- SELECT p."title", b."description", b."cost" FROM "BudgetBreakdown_Tbl" b JOIN "Pre_Project_Tbl" p ON b."preProjectID" = p."preProjectID";

-- Check completed projects
-- SELECT p."title", post."actualVolunteer", post."beneficiariesReached", post."timelineAdherence" FROM "Post_Project_Tbl" post JOIN "Pre_Project_Tbl" p ON post."preProjectID" = p."preProjectID";

-- Project count by status
-- SELECT "approvalStatus", COUNT(*) FROM "Pre_Project_Tbl" GROUP BY "approvalStatus";
