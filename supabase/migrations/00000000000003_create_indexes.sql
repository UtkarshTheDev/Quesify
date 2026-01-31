-- Migration: Create Indexes
-- Description: Performance indexes for frequently queried columns
-- Created: 2026-01-30

-- ============================================
-- USER_PROFILES indexes
-- ============================================
CREATE INDEX idx_user_profiles_username ON user_profiles(username);
CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);

-- ============================================
-- QUESTIONS indexes
-- ============================================
CREATE INDEX idx_questions_owner_id ON questions(owner_id);
CREATE INDEX idx_questions_subject ON questions(subject);
CREATE INDEX idx_questions_chapter ON questions(chapter);
CREATE INDEX idx_questions_subject_chapter ON questions(subject, chapter);
CREATE INDEX idx_questions_type ON questions(type);
CREATE INDEX idx_questions_difficulty ON questions(difficulty);
CREATE INDEX idx_questions_deleted_at ON questions(deleted_at) WHERE deleted_at IS NULL;
CREATE INDEX idx_questions_popularity ON questions(popularity DESC);

-- HNSW index for vector similarity search (faster than IVFFlat for high-dimensional)
CREATE INDEX idx_questions_embedding ON questions 
    USING hnsw (embedding vector_cosine_ops)
    WITH (m = 16, ef_construction = 64);

COMMENT ON INDEX idx_questions_embedding IS 'HNSW index for cosine similarity search on embeddings';

-- ============================================
-- SOLUTIONS indexes
-- ============================================
CREATE INDEX idx_solutions_question_id ON solutions(question_id);
CREATE INDEX idx_solutions_contributor_id ON solutions(contributor_id);
CREATE INDEX idx_solutions_likes ON solutions(likes DESC);
CREATE INDEX idx_solutions_is_ai_best ON solutions(is_ai_best) WHERE is_ai_best = TRUE;

-- ============================================
-- USER_QUESTIONS indexes
-- ============================================
CREATE INDEX idx_user_questions_user_id ON user_questions(user_id);
CREATE INDEX idx_user_questions_question_id ON user_questions(question_id);
CREATE INDEX idx_user_questions_is_owner ON user_questions(user_id, is_owner) WHERE is_owner = TRUE;

-- ============================================
-- USER_QUESTION_STATS indexes
-- ============================================
CREATE INDEX idx_user_question_stats_user_id ON user_question_stats(user_id);
CREATE INDEX idx_user_question_stats_question_id ON user_question_stats(question_id);
CREATE INDEX idx_user_question_stats_solved ON user_question_stats(user_id, solved) WHERE solved = TRUE;
CREATE INDEX idx_user_question_stats_failed ON user_question_stats(user_id, failed) WHERE failed = TRUE;
CREATE INDEX idx_user_question_stats_revise_later ON user_question_stats(user_id, in_revise_later) WHERE in_revise_later = TRUE;
CREATE INDEX idx_user_question_stats_next_review ON user_question_stats(user_id, next_review_at) WHERE next_review_at IS NOT NULL;

-- ============================================
-- SOLUTION_LIKES indexes
-- ============================================
CREATE INDEX idx_solution_likes_solution_id ON solution_likes(solution_id);
CREATE INDEX idx_solution_likes_user_id ON solution_likes(user_id);

-- ============================================
-- REVISE_LATER indexes
-- ============================================
CREATE INDEX idx_revise_later_user_id ON revise_later(user_id);
CREATE INDEX idx_revise_later_question_id ON revise_later(question_id);

-- ============================================
-- USER_ACTIVITIES indexes
-- ============================================
CREATE INDEX idx_user_activities_user_id ON user_activities(user_id);
CREATE INDEX idx_user_activities_created_at ON user_activities(created_at DESC);
CREATE INDEX idx_user_activities_user_created ON user_activities(user_id, created_at DESC);

-- ============================================
-- SYLLABUS indexes
-- ============================================
CREATE INDEX idx_syllabus_subject ON syllabus(subject);
CREATE INDEX idx_syllabus_class ON syllabus(class);
CREATE INDEX idx_syllabus_subject_chapter ON syllabus(subject, chapter);
CREATE INDEX idx_syllabus_verified ON syllabus(is_verified) WHERE is_verified = TRUE;