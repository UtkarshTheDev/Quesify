-- MIGRATION 06: GLOBAL SEARCH FEATURE (v3 - Type Fixes)
-- Purpose: Implement fuzzy text search for questions and users with strict type casting to avoid RPC errors.

-- 1. SCHEMA CLEANUP
ALTER TABLE questions DROP COLUMN IF EXISTS extracted_text;

-- 2. EXTENSION SETUP
CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;

-- 3. INDEXING
CREATE INDEX IF NOT EXISTS idx_questions_text_gin ON questions USING gin (question_text gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_users_username_gin ON user_profiles USING gin (username gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_users_display_name_gin ON user_profiles USING gin (display_name gin_trgm_ops);

-- 4. SEARCH FUNCTIONS

-- Search Questions (Rich Data for QuestionFeedCard)
DROP FUNCTION IF EXISTS search_questions(TEXT, UUID, INT, INT);

CREATE OR REPLACE FUNCTION search_questions(
    p_query TEXT,
    p_user_id UUID,
    p_limit INT DEFAULT 20,
    p_offset INT DEFAULT 0
)
RETURNS TABLE (
    question_id UUID,
    question_text TEXT,
    subject TEXT,
    chapter TEXT,
    topics JSONB,
    difficulty difficulty_enum,
    popularity INT,
    created_at TIMESTAMPTZ,
    image_url TEXT,
    type question_type_enum,
    has_diagram BOOLEAN,
    uploader_user_id UUID,
    uploader_display_name TEXT,
    uploader_username TEXT,
    uploader_avatar_url TEXT,
    solutions_count BIGINT,
    is_in_bank BOOLEAN,
    due_for_review BOOLEAN,
    similarity_score DOUBLE PRECISION
) LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    RETURN QUERY
    SELECT
        q.id::UUID, -- Explicit cast to UUID
        q.question_text,
        q.subject,
        q.chapter,
        q.topics,
        q.difficulty,
        q.popularity,
        q.created_at,
        q.image_url,
        q.type,
        q.has_diagram,
        q.owner_id AS uploader_user_id,
        up.display_name AS uploader_display_name,
        up.username AS uploader_username,
        up.avatar_url AS uploader_avatar_url,
        (SELECT COUNT(*) FROM solutions s WHERE s.question_id = q.id)::BIGINT AS solutions_count,
        EXISTS(SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id) AS is_in_bank,
        COALESCE(EXISTS(SELECT 1 FROM user_question_stats uqs WHERE uqs.user_id = p_user_id AND uqs.question_id = q.id AND uqs.next_review_at <= NOW()), false) AS due_for_review,
        similarity(q.question_text, p_query)::DOUBLE PRECISION AS sim_score -- Explicit cast to DOUBLE PRECISION
    FROM questions q
    JOIN user_profiles up ON up.user_id = q.owner_id
    WHERE 
        q.deleted_at IS NULL
        AND (
            q.question_text % p_query 
            OR q.question_text ILIKE '%' || p_query || '%'
            OR q.chapter % p_query
            OR q.chapter ILIKE '%' || p_query || '%'
            OR q.topics::text ILIKE '%' || p_query || '%'
        )
    ORDER BY 
        (EXISTS(SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id)) DESC,
        sim_score DESC,
        q.created_at DESC
    LIMIT p_limit OFFSET p_offset;
END;
$$;

-- Search Users (Rich Data)
DROP FUNCTION IF EXISTS search_users(TEXT, INT);
DROP FUNCTION IF EXISTS search_users(TEXT, UUID, INT);

CREATE OR REPLACE FUNCTION search_users(
    p_query TEXT,
    p_viewer_id UUID,
    p_limit INT DEFAULT 10
)
RETURNS TABLE (
    user_id UUID,
    username TEXT,
    display_name TEXT,
    avatar_url TEXT,
    common_subjects TEXT[],
    mutual_follows_count BIGINT,
    total_questions BIGINT,
    total_solutions BIGINT,
    is_following BOOLEAN,
    similarity_score DOUBLE PRECISION
) LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    RETURN QUERY
    SELECT
        up.user_id::UUID, -- Explicit cast to UUID
        up.username,
        up.display_name,
        up.avatar_url,
        ARRAY[]::TEXT[] as common_subjects, 
        0::BIGINT as mutual_follows_count,
        up.total_uploaded::BIGINT AS total_questions,
        up.solutions_helped_count::BIGINT AS total_solutions,
        EXISTS(SELECT 1 FROM follows f WHERE f.follower_id = p_viewer_id AND f.following_id = up.user_id) AS is_following,
        GREATEST(similarity(up.username, p_query), similarity(up.display_name, p_query))::DOUBLE PRECISION AS sim_score -- Explicit cast to DOUBLE PRECISION
    FROM user_profiles up
    WHERE 
        (
            up.username % p_query 
            OR up.display_name % p_query
            OR up.username ILIKE '%' || p_query || '%'
            OR up.display_name ILIKE '%' || p_query || '%'
        )
        AND up.user_id != p_viewer_id 
    ORDER BY sim_score DESC
    LIMIT p_limit;
END;
$$;

-- 5. PERMISSIONS
GRANT EXECUTE ON FUNCTION search_questions(TEXT, UUID, INT, INT) TO authenticated;
-- Explore Questions (For empty search state)
DROP FUNCTION IF EXISTS get_explore_questions(UUID, INT);

CREATE OR REPLACE FUNCTION get_explore_questions(
    p_user_id UUID,
    p_limit INT DEFAULT 6
)
RETURNS TABLE (
    question_id UUID,
    question_text TEXT,
    subject TEXT,
    chapter TEXT,
    topics JSONB,
    difficulty difficulty_enum,
    popularity INT,
    created_at TIMESTAMPTZ,
    image_url TEXT,
    type question_type_enum,
    has_diagram BOOLEAN,
    uploader_user_id UUID,
    uploader_display_name TEXT,
    uploader_username TEXT,
    uploader_avatar_url TEXT,
    solutions_count BIGINT,
    is_in_bank BOOLEAN,
    due_for_review BOOLEAN,
    similarity_score DOUBLE PRECISION
) LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    RETURN QUERY
    SELECT
        q.id::UUID,
        q.question_text,
        q.subject,
        q.chapter,
        q.topics,
        q.difficulty,
        q.popularity,
        q.created_at,
        q.image_url,
        q.type,
        q.has_diagram,
        q.owner_id AS uploader_user_id,
        up.display_name AS uploader_display_name,
        up.username AS uploader_username,
        up.avatar_url AS uploader_avatar_url,
        (SELECT COUNT(*) FROM solutions s WHERE s.question_id = q.id)::BIGINT AS solutions_count,
        FALSE AS is_in_bank, -- By definition, these are not in bank
        FALSE AS due_for_review,
        0::DOUBLE PRECISION AS sim_score
    FROM questions q
    JOIN user_profiles up ON up.user_id = q.owner_id
    WHERE 
        q.deleted_at IS NULL
        AND q.owner_id != p_user_id -- Exclude own questions
        AND NOT EXISTS (SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id)
    ORDER BY 
        q.popularity DESC, 
        q.created_at DESC
    LIMIT p_limit;
END;
$$;

GRANT EXECUTE ON FUNCTION get_explore_questions(UUID, INT) TO authenticated;

