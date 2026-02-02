-- =====================================================
-- Fix RLS Policy for Reply_Tbl
-- Allow users to insert replies to their own inquiries
-- =====================================================

-- First, drop existing policies if they exist
DROP POLICY IF EXISTS "Authenticated users can insert replies" ON "Reply_Tbl";
DROP POLICY IF EXISTS "Anyone can read replies" ON "Reply_Tbl";
DROP POLICY IF EXISTS "Users can update own replies" ON "Reply_Tbl";
DROP POLICY IF EXISTS "Users can delete own replies" ON "Reply_Tbl";
DROP POLICY IF EXISTS "Users can insert replies" ON "Reply_Tbl";

-- Create policy to allow authenticated users to insert replies
-- Users can reply to any inquiry (both SK officials and youth volunteers)
CREATE POLICY "Authenticated users can insert replies"
ON "Reply_Tbl"
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = "userID");

-- Allow users to read all replies
CREATE POLICY "Anyone can read replies"
ON "Reply_Tbl"
FOR SELECT
TO authenticated
USING (true);

-- Allow users to update their own replies
CREATE POLICY "Users can update own replies"
ON "Reply_Tbl"
FOR UPDATE
TO authenticated
USING (auth.uid() = "userID")
WITH CHECK (auth.uid() = "userID");

-- Allow users to delete their own replies
CREATE POLICY "Users can delete own replies"
ON "Reply_Tbl"
FOR DELETE
TO authenticated
USING (auth.uid() = "userID");

-- =====================================================
-- Also fix Inquiry_Tbl policies if needed
-- =====================================================

-- Drop existing policies first
DROP POLICY IF EXISTS "Authenticated users can insert inquiries" ON "Inquiry_Tbl";
DROP POLICY IF EXISTS "Anyone can read inquiries" ON "Inquiry_Tbl";

-- Allow authenticated users to insert inquiries
CREATE POLICY "Authenticated users can insert inquiries"
ON "Inquiry_Tbl"
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = "userID");

-- Allow users to read all inquiries
CREATE POLICY "Anyone can read inquiries"
ON "Inquiry_Tbl"
FOR SELECT
TO authenticated
USING (true);

-- =====================================================
-- Also fix Application_Tbl policies if needed
-- =====================================================

-- Drop existing policies first
DROP POLICY IF EXISTS "Authenticated users can insert applications" ON "Application_Tbl";
DROP POLICY IF EXISTS "Users can read own applications" ON "Application_Tbl";
DROP POLICY IF EXISTS "SK Officials can read all applications" ON "Application_Tbl";

-- Allow authenticated users to insert applications
CREATE POLICY "Authenticated users can insert applications"
ON "Application_Tbl"
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = "userID");

-- Allow users to read their own applications
CREATE POLICY "Users can read own applications"
ON "Application_Tbl"
FOR SELECT
TO authenticated
USING (auth.uid() = "userID");

-- Allow SK Officials to read all applications
CREATE POLICY "SK Officials can read all applications"
ON "Application_Tbl"
FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM "User_Tbl"
    WHERE "User_Tbl"."userID" = auth.uid()
    AND "User_Tbl"."role" IN ('SK_OFFICIAL', 'SUPERADMIN', 'CAPTAIN')
  )
);
