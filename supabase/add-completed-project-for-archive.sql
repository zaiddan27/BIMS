-- =====================================================
-- Add a COMPLETED project that is ready to be archived
-- This project has been fully evaluated and can now be archived
-- =====================================================

-- Insert a completed project
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
    (SELECT "userID" FROM "User_Tbl" WHERE "role" = 'SK_OFFICIAL' LIMIT 1),
    (SELECT "skID" FROM "SK_Tbl" LIMIT 1),
    'Youth Basketball Tournament 2024',
    E'An inter-purok basketball tournament promoting sportsmanship and camaraderie among the youth of Barangay Malanday.\n\nTournament Details:\n• 8 teams participated (one per purok)\n• Double elimination format\n• 3-day event with finals on the last day\n• Awards ceremony with trophies and medals\n\nHighlights:\n• Over 150 youth participants\n• Strong community turnout for games\n• Successfully promoted youth engagement\n• Zero incidents reported',
    'Sports',
    30000,
    25,
    150,
    'COMPLETED',
    '2024-12-01 08:00:00+08',
    '2024-12-03 20:00:00+08',
    'Barangay Covered Court',
    NULL,
    '2024-11-15 10:00:00+08',
    'APPROVED',
    '2024-11-17 14:00:00+08',
    'Approved. Great initiative to keep our youth active and engaged in sports.',
    NOW() - INTERVAL '2 months',
    NOW()
);

-- Budget breakdown for completed project
INSERT INTO "BudgetBreakdown_Tbl" ("preProjectID", "description", "cost", "createdAt")
SELECT
    "preProjectID",
    unnest(ARRAY[
        'Trophies and medals',
        'Basketballs and equipment',
        'Referee fees (3 days)',
        'First aid supplies',
        'Refreshments for players',
        'Sound system rental',
        'Banners and tarpaulins',
        'Certificates for participants'
    ]),
    unnest(ARRAY[6000, 5000, 4500, 1500, 6000, 3000, 2500, 1500])::BIGINT,
    NOW()
FROM "Pre_Project_Tbl"
WHERE "title" = 'Youth Basketball Tournament 2024';

-- Insert Post_Project_Tbl entry (evaluation record) - this marks it as fully completed
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
    28,  -- Actual volunteers (exceeded target of 25)
    'Completed_On_Time',
    165,  -- Beneficiaries reached (exceeded target of 150)
    E'The Youth Basketball Tournament 2024 was a resounding success!\n\nKey Achievements:\n• 8 teams with 80+ players participated\n• Over 165 youth beneficiaries engaged\n• 28 volunteers helped organize the event\n• Championship won by Purok 3 team\n• Best Player: Juan Dela Cruz (Purok 3)\n• MVP: Maria Santos (Purok 5)\n\nCommunity Impact:\n• Strengthened inter-purok relations\n• Promoted healthy lifestyle among youth\n• Identified talented players for municipal league\n• Zero incidents or injuries reported\n\nRecommendations for Future:\n• Increase budget for better equipment\n• Add volleyball division next year\n• Consider night games for working youth',
    NOW() - INTERVAL '1 month',
    NOW() - INTERVAL '1 month'
FROM "Pre_Project_Tbl"
WHERE "title" = 'Youth Basketball Tournament 2024';

-- Verify the project was created with evaluation
SELECT
    p."preProjectID",
    p."title",
    p."status",
    p."approvalStatus",
    post."actualVolunteer",
    post."beneficiariesReached",
    post."timelineAdherence"
FROM "Pre_Project_Tbl" p
LEFT JOIN "Post_Project_Tbl" post ON p."preProjectID" = post."preProjectID"
WHERE p."title" = 'Youth Basketball Tournament 2024';
