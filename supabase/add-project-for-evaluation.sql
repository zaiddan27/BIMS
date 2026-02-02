-- =====================================================
-- Add a project that is ready for completion/evaluation
-- This project is ONGOING (approved, started, not yet completed)
-- The SK Official can click "Mark as Complete" to fill out the evaluation form
-- =====================================================

-- Insert an ongoing project that needs to be completed and evaluated
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
    'Digital Literacy Training for Senior Citizens',
    E'A comprehensive digital literacy program designed to teach senior citizens basic computer and smartphone skills.\n\nProgram Highlights:\n• Basic smartphone operation (calls, messages, camera)\n• Social media basics (Facebook, Messenger)\n• Online safety and scam awareness\n• Video calling with family members\n• Basic internet browsing\n\nSession Schedule:\n• 4 weekly sessions (every Saturday)\n• 2 hours per session\n• Small group learning (5 seniors per volunteer)\n\nThis project has been successfully conducted and is ready for completion evaluation.',
    'Education',
    18000,
    15,
    40,
    'ONGOING',
    '2025-01-04 09:00:00+08',  -- Started in the past
    '2025-01-25 12:00:00+08',  -- Ended recently
    'Barangay Hall Computer Room',
    NULL,
    '2024-12-20 10:00:00+08',
    'APPROVED',
    '2024-12-22 14:00:00+08',
    'Excellent initiative! Helping our senior citizens adapt to technology is very important. Approved.',
    NOW() - INTERVAL '1 month',
    NOW()
);

-- Budget breakdown for this project
INSERT INTO "BudgetBreakdown_Tbl" ("preProjectID", "description", "cost", "createdAt")
SELECT
    "preProjectID",
    unnest(ARRAY[
        'Training materials and handouts',
        'Snacks for participants (4 sessions)',
        'Certificates and tokens',
        'Internet connection upgrade',
        'Technical support and equipment',
        'Documentation'
    ]),
    unnest(ARRAY[3000, 6000, 2000, 2500, 3500, 1000])::BIGINT,
    NOW()
FROM "Pre_Project_Tbl"
WHERE "title" = 'Digital Literacy Training for Senior Citizens';


