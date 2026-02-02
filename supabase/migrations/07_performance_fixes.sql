-- Migration 07: Performance Fixes (RLS & Indexes)
-- Based on perfDB-advisor.json recommendations

-- ============================================
-- 1. FIX DUPLICATE INDEXES
-- ============================================

-- Drop redundant indexes that are identical to others
DROP INDEX IF EXISTS idx_questions_owner_id_user_profiles;
DROP INDEX IF EXISTS idx_solutions_contributor_id_user_profiles;
DROP INDEX IF EXISTS idx_user_question_stats_review_due;

-- ============================================
-- 2. FIX DUPLICATE POLICIES
-- ============================================

-- "Users can insert own profile" is a duplicate of "Users can insert their own profile"
DROP POLICY IF EXISTS "Users can insert own profile" ON user_profiles;

-- Ensure the correct optimized policy exists (idempotent re-creation)
DROP POLICY IF EXISTS "Users can insert their own profile" ON user_profiles;
CREATE POLICY "Users can insert their own profile" ON user_profiles 
    FOR INSERT WITH CHECK ((SELECT auth.uid()) = user_id);

-- ============================================
-- 3. OPTIMIZE RLS (Wrap auth functions in SELECT)
-- ============================================

-- Syllabus: Prevent re-evaluation of auth.role()
DROP POLICY IF EXISTS "Authenticated users can view syllabus" ON syllabus;
CREATE POLICY "Authenticated users can view syllabus" ON syllabus 
    FOR SELECT USING ((SELECT auth.role()) = 'authenticated');

-- Notifications: Prevent re-evaluation of auth.uid()
DROP POLICY IF EXISTS "Users update their own notifications" ON notifications;
CREATE POLICY "Users update their own notifications" ON notifications 
    FOR UPDATE USING ((SELECT auth.uid()) = recipient_id);

-- Consolidate/Fix legacy notification view policies
DROP POLICY IF EXISTS "Users view their own notifications" ON notifications;
DROP POLICY IF EXISTS "Users can see their own notifications" ON notifications;
CREATE POLICY "Users can see their own notifications" ON notifications 
    FOR SELECT USING ((SELECT auth.uid()) = recipient_id);

-- Follows: Consolidate split policies into one optimized policy
DROP POLICY IF EXISTS "Users can follow others" ON follows;
DROP POLICY IF EXISTS "Users can unfollow" ON follows;
DROP POLICY IF EXISTS "Users can manage their own follows" ON follows;

CREATE POLICY "Users can manage their own follows" ON follows 
    FOR ALL USING ((SELECT auth.uid()) = follower_id);
