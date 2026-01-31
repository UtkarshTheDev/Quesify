-- Migration: Enable Row Level Security
-- Description: Enable RLS on all tables and create policies
-- Created: 2026-01-30

-- ============================================
-- 1. USER_PROFILES
-- Public readable, users manage own
-- ============================================
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Everyone can view profiles (needed for public profile pages)
CREATE POLICY "Profiles are viewable by everyone" 
    ON user_profiles FOR SELECT 
    USING (true);

-- Users can insert their own profile
CREATE POLICY "Users can insert their own profile" 
    ON user_profiles FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

-- Users can update their own profile
CREATE POLICY "Users can update their own profile" 
    ON user_profiles FOR UPDATE 
    USING (auth.uid() = user_id);

-- ============================================
-- 2. QUESTIONS
-- Public readable, owners manage
-- ============================================
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;

-- Everyone can view non-deleted questions
CREATE POLICY "Questions are viewable by everyone" 
    ON questions FOR SELECT 
    USING (deleted_at IS NULL);

-- Authenticated users can insert (ownership set via trigger/app)
CREATE POLICY "Authenticated users can insert questions" 
    ON questions FOR INSERT 
    WITH CHECK (auth.uid() = owner_id);

-- Owners can update their questions
CREATE POLICY "Owners can update their questions" 
    ON questions FOR UPDATE 
    USING (auth.uid() = owner_id AND deleted_at IS NULL);

-- Owners can soft delete their questions
CREATE POLICY "Owners can delete their questions" 
    ON questions FOR DELETE 
    USING (auth.uid() = owner_id);

-- ============================================
-- 3. SOLUTIONS
-- Public readable, contributors manage
-- ============================================
ALTER TABLE solutions ENABLE ROW LEVEL SECURITY;

-- Everyone can view solutions
CREATE POLICY "Solutions are viewable by everyone" 
    ON solutions FOR SELECT 
    USING (true);

-- Users can insert their own solutions
CREATE POLICY "Users can insert their own solutions" 
    ON solutions FOR INSERT 
    WITH CHECK (auth.uid() = contributor_id);

-- Contributors can update their solutions
CREATE POLICY "Contributors can update their solutions" 
    ON solutions FOR UPDATE 
    USING (auth.uid() = contributor_id);

-- Contributors can delete their solutions
CREATE POLICY "Contributors can delete their solutions" 
    ON solutions FOR DELETE 
    USING (auth.uid() = contributor_id);

-- ============================================
-- 4. USER_QUESTIONS
-- Users manage their own links only
-- ============================================
ALTER TABLE user_questions ENABLE ROW LEVEL SECURITY;

-- Users can view their own links
CREATE POLICY "Users can view their own question links" 
    ON user_questions FOR SELECT 
    USING (auth.uid() = user_id);

-- Users can insert their own links
CREATE POLICY "Users can insert their own question links" 
    ON user_questions FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

-- Users can delete their own links
CREATE POLICY "Users can delete their own question links" 
    ON user_questions FOR DELETE 
    USING (auth.uid() = user_id);

-- ============================================
-- 5. USER_QUESTION_STATS
-- Users manage their own stats only
-- ============================================
ALTER TABLE user_question_stats ENABLE ROW LEVEL SECURITY;

-- Users can view their own stats
CREATE POLICY "Users can view their own stats" 
    ON user_question_stats FOR SELECT 
    USING (auth.uid() = user_id);

-- Users can insert their own stats
CREATE POLICY "Users can insert their own stats" 
    ON user_question_stats FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

-- Users can update their own stats
CREATE POLICY "Users can update their own stats" 
    ON user_question_stats FOR UPDATE 
    USING (auth.uid() = user_id);

-- ============================================
-- 6. SOLUTION_LIKES
-- Public view, users manage own
-- ============================================
ALTER TABLE solution_likes ENABLE ROW LEVEL SECURITY;

-- Everyone can view likes
CREATE POLICY "Likes are viewable by everyone" 
    ON solution_likes FOR SELECT 
    USING (true);

-- Users can insert their own likes
CREATE POLICY "Users can insert their own likes" 
    ON solution_likes FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

-- Users can delete their own likes
CREATE POLICY "Users can delete their own likes" 
    ON solution_likes FOR DELETE 
    USING (auth.uid() = user_id);

-- ============================================
-- 7. REVISE_LATER
-- Users manage their own list only
-- ============================================
ALTER TABLE revise_later ENABLE ROW LEVEL SECURITY;

-- Users can view their own revise list
CREATE POLICY "Users can view their own revise list" 
    ON revise_later FOR SELECT 
    USING (auth.uid() = user_id);

-- Users can insert into their own revise list
CREATE POLICY "Users can insert into their own revise list" 
    ON revise_later FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

-- Users can delete from their own revise list
CREATE POLICY "Users can delete from their own revise list" 
    ON revise_later FOR DELETE 
    USING (auth.uid() = user_id);

-- ============================================
-- 8. USER_ACTIVITIES
-- Users view own, insert own
-- ============================================
ALTER TABLE user_activities ENABLE ROW LEVEL SECURITY;

-- Users can view their own activities
CREATE POLICY "Users can view their own activities" 
    ON user_activities FOR SELECT 
    USING (auth.uid() = user_id);

-- System can insert activities (via trigger)
CREATE POLICY "System can insert activities" 
    ON user_activities FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

-- ============================================
-- 9. SYLLABUS
-- Authenticated users can view
-- ============================================
ALTER TABLE syllabus ENABLE ROW LEVEL SECURITY;

-- Authenticated users can view syllabus
CREATE POLICY "Authenticated users can view syllabus" 
    ON syllabus FOR SELECT 
    USING (auth.role() = 'authenticated');

-- Note: Syllabus modifications should be done via admin API or service role