-- Migration: Fix Storage RLS and User Profile Relationships
-- Created: 2026-01-31
-- 
-- This migration addresses critical issues following Supabase/Postgres best practices:
-- 1. Storage RLS policies for question-images bucket uploads
-- 2. Foreign key relationships for user profile joins (solutions & questions)
-- 3. Indexes on foreign key columns (per best practices - 10-100x faster JOINs)
-- 4. Auto-create user_profiles trigger on auth.users insert
-- 5. Optimized RLS policies with proper patterns

-- ============================================================================
-- FIX 1: Storage RLS Policies for question-images bucket
-- ============================================================================
-- Issue: RLS was enabled on storage.objects but no policies existed, causing
-- "new row violates row-level security policy" error on image uploads
-- Best Practice: Apply principle of least privilege - only grant needed permissions

-- Drop existing policies first (to avoid conflicts), then recreate
DROP POLICY IF EXISTS "Allow authenticated uploads to question-images" ON storage.objects;
DROP POLICY IF EXISTS "Allow authenticated reads from question-images" ON storage.objects;
DROP POLICY IF EXISTS "Allow authenticated deletes from question-images" ON storage.objects;
DROP POLICY IF EXISTS "Allow public reads from question-images" ON storage.objects;

-- Policy: Allow authenticated users to upload (INSERT) to question-images bucket
CREATE POLICY "Allow authenticated uploads to question-images"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'question-images'
);

-- Policy: Allow authenticated users to read (SELECT) from question-images bucket
CREATE POLICY "Allow authenticated reads from question-images"
ON storage.objects
FOR SELECT
TO authenticated
USING (
    bucket_id = 'question-images'
);

-- Policy: Allow authenticated users to delete from question-images bucket
CREATE POLICY "Allow authenticated deletes from question-images"
ON storage.objects
FOR DELETE
TO authenticated
USING (
    bucket_id = 'question-images'
);

-- Policy: Allow public read access (since bucket is public)
CREATE POLICY "Allow public reads from question-images"
ON storage.objects
FOR SELECT
TO anon
USING (
    bucket_id = 'question-images'
);

-- ============================================================================
-- FIX 2: Foreign Key Relationship for Solutions → User Profiles
-- ============================================================================
-- Issue: Code queries use syntax `author:user_profiles!contributor_id` but no
-- FK relationship existed, causing PGRST200 error:
-- "Could not find a relationship between 'solutions' and 'user_profiles'"
-- Best Practice: Index foreign key columns for 10-100x faster JOINs

-- Add foreign key: solutions.contributor_id → user_profiles.user_id
-- This enables Supabase PostgREST to understand the join relationship
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'solutions_contributor_id_user_profiles_fkey'
    ) THEN
        ALTER TABLE solutions
        ADD CONSTRAINT solutions_contributor_id_user_profiles_fkey
        FOREIGN KEY (contributor_id) 
        REFERENCES user_profiles(user_id)
        ON DELETE CASCADE;
    END IF;
END $$;

-- Best Practice: Index the FK column for fast JOINs and CASCADE operations
CREATE INDEX IF NOT EXISTS idx_solutions_contributor_id_user_profiles 
ON solutions(contributor_id);

COMMENT ON CONSTRAINT solutions_contributor_id_user_profiles_fkey ON solutions 
IS 'Enables author:user_profiles!contributor_id joins';

-- ============================================================================
-- FIX 3: Foreign Key Relationship for Questions → User Profiles  
-- ============================================================================
-- Issue: Code queries use syntax `author:user_profiles!owner_id` but no
-- FK relationship existed to user_profiles, only to auth.users
-- This prevents efficient joins for question owner profile data

-- Add foreign key: questions.owner_id → user_profiles.user_id
-- This enables Supabase PostgREST to understand the join relationship
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'questions_owner_id_user_profiles_fkey'
    ) THEN
        ALTER TABLE questions
        ADD CONSTRAINT questions_owner_id_user_profiles_fkey
        FOREIGN KEY (owner_id) 
        REFERENCES user_profiles(user_id)
        ON DELETE CASCADE;
    END IF;
END $$;

-- Best Practice: Index the FK column for fast JOINs and CASCADE operations
CREATE INDEX IF NOT EXISTS idx_questions_owner_id_user_profiles 
ON questions(owner_id);

COMMENT ON CONSTRAINT questions_owner_id_user_profiles_fkey ON questions 
IS 'Enables author:user_profiles!owner_id joins';

-- ============================================================================
-- FIX 4: Additional Foreign Key Indexes (Best Practice Compliance)
-- ============================================================================
-- Per Postgres best practices: Always index foreign key columns
-- This ensures fast JOINs and efficient ON DELETE CASCADE operations

-- Index for questions.owner_id (auth.users FK) - already exists as idx_questions_owner_id
-- But we need to ensure it's optimized

-- Index for solutions.question_id - already exists as idx_solutions_question_id ✓
-- Index for solutions.contributor_id (auth.users FK) - already exists as idx_solutions_contributor_id ✓

-- Additional optimized indexes for common query patterns:

-- Composite index for questions by subject + chapter (common filter pattern)
-- Already exists: idx_questions_subject_chapter ✓

-- Partial index for active (non-deleted) questions - already exists ✓
-- idx_questions_deleted_at WHERE deleted_at IS NULL

-- ============================================================================
-- FIX 5: Auto-Create User Profile Trigger
-- ============================================================================
-- Issue: New users don't have user_profiles rows, causing "profile not found" errors
-- Best Practice: Use trigger to maintain data consistency automatically

-- Function to create user profile on auth.users insert
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    -- Insert new user profile with defaults
    INSERT INTO public.user_profiles (user_id, display_name, username)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email),
        NULL  -- Username must be set manually during onboarding
    )
    ON CONFLICT (user_id) DO NOTHING;  -- Prevent duplicates if already exists
    
    RETURN NEW;
END;
$$;

COMMENT ON FUNCTION public.handle_new_user() 
IS 'Automatically creates user_profiles row when new user signs up';

-- Trigger to call function on auth.users insert
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- ============================================================================
-- FIX 6: Migrate ALL User FKs from auth.users to user_profiles
-- ============================================================================
-- CRITICAL: All user-related foreign keys should point to user_profiles, not auth.users
-- This ensures consistent joins and follows the established pattern
-- 
-- Tables being updated:
-- 1. user_questions.user_id
-- 2. user_question_stats.user_id  
-- 3. solution_likes.user_id
-- 4. revise_later.user_id
-- 5. user_activities.user_id
--
-- NOTE: user_profiles.user_id correctly stays as auth.users (root link)

-- Function to safely migrate FK with data preservation
CREATE OR REPLACE FUNCTION migrate_fk_to_user_profiles(
    p_table TEXT,
    p_column TEXT,
    p_existing_fk_name TEXT
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    -- Drop existing FK to auth.users if exists
    EXECUTE format(
        'ALTER TABLE %I DROP CONSTRAINT IF EXISTS %I',
        p_table,
        p_existing_fk_name
    );
    
    -- Add new FK to user_profiles
    EXECUTE format(
        'ALTER TABLE %I ADD CONSTRAINT %I FOREIGN KEY (%I) REFERENCES user_profiles(user_id) ON DELETE CASCADE',
        p_table,
        p_table || '_' || p_column || '_user_profiles_fkey',
        p_column
    );
EXCEPTION
    WHEN duplicate_table THEN
        NULL;  -- Constraint already exists, ignore
END;
$$;

-- Migrate user_questions.user_id
SELECT migrate_fk_to_user_profiles('user_questions', 'user_id', 'user_questions_user_id_fkey');

-- Migrate user_question_stats.user_id
SELECT migrate_fk_to_user_profiles('user_question_stats', 'user_id', 'user_question_stats_user_id_fkey');

-- Migrate solution_likes.user_id
SELECT migrate_fk_to_user_profiles('solution_likes', 'user_id', 'solution_likes_user_id_fkey');

-- Migrate revise_later.user_id
SELECT migrate_fk_to_user_profiles('revise_later', 'user_id', 'revise_later_user_id_fkey');

-- Migrate user_activities.user_id
SELECT migrate_fk_to_user_profiles('user_activities', 'user_id', 'user_activities_user_id_fkey');

-- Drop the helper function
DROP FUNCTION migrate_fk_to_user_profiles(TEXT, TEXT, TEXT);

-- Best Practice: Ensure indexes exist on all user_id FK columns
CREATE INDEX IF NOT EXISTS idx_user_questions_user_id ON user_questions(user_id);
CREATE INDEX IF NOT EXISTS idx_user_question_stats_user_id ON user_question_stats(user_id);
CREATE INDEX IF NOT EXISTS idx_solution_likes_user_id ON solution_likes(user_id);
CREATE INDEX IF NOT EXISTS idx_revise_later_user_id ON revise_later(user_id);
CREATE INDEX IF NOT EXISTS idx_user_activities_user_id ON user_activities(user_id);

-- ============================================================================
-- FIX 7: Optimized RLS Policies (Performance Best Practice)
-- ============================================================================
-- Best Practice: Wrap auth.uid() in SELECT for 100x+ faster RLS on large tables
-- This ensures auth.uid() is called once per query, not once per row

-- Drop and recreate policies with optimized patterns

-- User Profiles: Update policy with optimized pattern
DROP POLICY IF EXISTS "Users can update their own profile" ON user_profiles;
CREATE POLICY "Users can update their own profile" 
    ON user_profiles FOR UPDATE 
    USING ((SELECT auth.uid()) = user_id);

-- User Profiles: Insert policy with optimized pattern  
DROP POLICY IF EXISTS "Users can insert their own profile" ON user_profiles;
CREATE POLICY "Users can insert their own profile" 
    ON user_profiles FOR INSERT 
    WITH CHECK ((SELECT auth.uid()) = user_id);

-- Questions: Update policy with optimized pattern
DROP POLICY IF EXISTS "Owners can update their questions" ON questions;
CREATE POLICY "Owners can update their questions" 
    ON questions FOR UPDATE 
    USING ((SELECT auth.uid()) = owner_id AND deleted_at IS NULL);

-- Questions: Delete policy with optimized pattern
DROP POLICY IF EXISTS "Owners can delete their questions" ON questions;
CREATE POLICY "Owners can delete their questions" 
    ON questions FOR DELETE 
    USING ((SELECT auth.uid()) = owner_id);

-- Questions: Insert policy with optimized pattern
DROP POLICY IF EXISTS "Authenticated users can insert questions" ON questions;
CREATE POLICY "Authenticated users can insert questions" 
    ON questions FOR INSERT 
    WITH CHECK ((SELECT auth.uid()) = owner_id);

-- Solutions: Update policy with optimized pattern
DROP POLICY IF EXISTS "Contributors can update their solutions" ON solutions;
CREATE POLICY "Contributors can update their solutions" 
    ON solutions FOR UPDATE 
    USING ((SELECT auth.uid()) = contributor_id);

-- Solutions: Delete policy with optimized pattern
DROP POLICY IF EXISTS "Contributors can delete their solutions" ON solutions;
CREATE POLICY "Contributors can delete their solutions" 
    ON solutions FOR DELETE 
    USING ((SELECT auth.uid()) = contributor_id);

-- Solutions: Insert policy with optimized pattern
DROP POLICY IF EXISTS "Users can insert their own solutions" ON solutions;
CREATE POLICY "Users can insert their own solutions" 
    ON solutions FOR INSERT 
    WITH CHECK ((SELECT auth.uid()) = contributor_id);

-- User Questions: All policies with optimized pattern
DROP POLICY IF EXISTS "Users can view their own question links" ON user_questions;
CREATE POLICY "Users can view their own question links" 
    ON user_questions FOR SELECT 
    USING ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can insert their own question links" ON user_questions;
CREATE POLICY "Users can insert their own question links" 
    ON user_questions FOR INSERT 
    WITH CHECK ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can delete their own question links" ON user_questions;
CREATE POLICY "Users can delete their own question links" 
    ON user_questions FOR DELETE 
    USING ((SELECT auth.uid()) = user_id);

-- User Question Stats: All policies with optimized pattern
DROP POLICY IF EXISTS "Users can view their own stats" ON user_question_stats;
CREATE POLICY "Users can view their own stats" 
    ON user_question_stats FOR SELECT 
    USING ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can insert their own stats" ON user_question_stats;
CREATE POLICY "Users can insert their own stats" 
    ON user_question_stats FOR INSERT 
    WITH CHECK ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can update their own stats" ON user_question_stats;
CREATE POLICY "Users can update their own stats" 
    ON user_question_stats FOR UPDATE 
    USING ((SELECT auth.uid()) = user_id);

-- Solution Likes: Insert/Delete policies with optimized pattern
DROP POLICY IF EXISTS "Users can insert their own likes" ON solution_likes;
CREATE POLICY "Users can insert their own likes" 
    ON solution_likes FOR INSERT 
    WITH CHECK ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can delete their own likes" ON solution_likes;
CREATE POLICY "Users can delete their own likes" 
    ON solution_likes FOR DELETE 
    USING ((SELECT auth.uid()) = user_id);

-- Revise Later: All policies with optimized pattern
DROP POLICY IF EXISTS "Users can view their own revise list" ON revise_later;
CREATE POLICY "Users can view their own revise list" 
    ON revise_later FOR SELECT 
    USING ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can insert into their own revise list" ON revise_later;
CREATE POLICY "Users can insert into their own revise list" 
    ON revise_later FOR INSERT 
    WITH CHECK ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can delete from their own revise list" ON revise_later;
CREATE POLICY "Users can delete from their own revise list" 
    ON revise_later FOR DELETE 
    USING ((SELECT auth.uid()) = user_id);

-- User Activities: Policies with optimized pattern
DROP POLICY IF EXISTS "Users can view their own activities" ON user_activities;
CREATE POLICY "Users can view their own activities" 
    ON user_activities FOR SELECT 
    USING ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS "System can insert activities" ON user_activities;
CREATE POLICY "System can insert activities" 
    ON user_activities FOR INSERT 
    WITH CHECK ((SELECT auth.uid()) = user_id);

-- ============================================================================
-- VERIFICATION QUERIES (Run manually to verify all fixes):
-- ============================================================================

/*
-- Check all storage policies:
SELECT policyname, cmd, roles 
FROM pg_policies 
WHERE schemaname = 'storage' AND tablename = 'objects';

-- Check all foreign keys on solutions:
SELECT 
    tc.constraint_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu ON ccu.constraint_name = tc.constraint_name
WHERE tc.table_name = 'solutions' AND tc.constraint_type = 'FOREIGN KEY';

-- Check all foreign keys on questions:
SELECT 
    tc.constraint_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu ON ccu.constraint_name = tc.constraint_name
WHERE tc.table_name = 'questions' AND tc.constraint_type = 'FOREIGN KEY';

-- Check indexes on FK columns:
SELECT 
    tablename, 
    indexname, 
    indexdef
FROM pg_indexes
WHERE tablename IN ('questions', 'solutions', 'user_questions', 'user_question_stats', 'solution_likes', 'revise_later')
AND schemaname = 'public'
ORDER BY tablename, indexname;

-- Check trigger on auth.users:
SELECT 
    trigger_name,
    event_manipulation,
    action_timing,
    action_statement
FROM information_schema.triggers
WHERE event_object_table = 'users' AND event_object_schema = 'auth';

-- Check RLS policies (sample):
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
WHERE tablename IN ('user_profiles', 'questions', 'solutions')
ORDER BY tablename, policyname;

-- Test the user profile auto-creation (run after migration):
-- 1. Create a test user in auth.users
-- 2. Check if user_profiles row was auto-created
SELECT * FROM user_profiles WHERE user_id = 'test-user-id';
*/
