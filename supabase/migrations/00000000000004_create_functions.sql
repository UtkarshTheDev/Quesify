-- Migration: Create RPC Functions
-- Description: Database functions for complex operations
-- Created: 2026-01-30

-- ============================================
-- 1. MATCH_QUESTIONS_WITH_SOLUTIONS
-- Vector similarity search for duplicate detection
-- Returns questions with similarity score and their solutions
-- ============================================
CREATE OR REPLACE FUNCTION match_questions_with_solutions(
    query_embedding VECTOR(768),
    match_threshold FLOAT,
    match_count INT
)
RETURNS TABLE (
    id TEXT,
    owner_id UUID,
    question_text TEXT,
    matched_solution_text TEXT,
    similarity FLOAT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        q.id,
        q.owner_id,
        q.question_text,
        s.solution_text AS matched_solution_text,
        1 - (q.embedding <=> query_embedding) AS similarity
    FROM questions q
    LEFT JOIN solutions s ON s.question_id = q.id AND s.is_ai_best = TRUE
    WHERE 
        q.deleted_at IS NULL
        AND q.embedding IS NOT NULL
        AND 1 - (q.embedding <=> query_embedding) > match_threshold
    ORDER BY q.embedding <=> query_embedding
    LIMIT match_count;
END;
$$;

COMMENT ON FUNCTION match_questions_with_solutions IS 'Find similar questions using vector cosine similarity';

-- ============================================
-- 2. TOGGLE_SOLUTION_LIKE
-- Atomically toggle like/unlike and update count
-- ============================================
CREATE OR REPLACE FUNCTION toggle_solution_like(
    sol_id TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_user_id UUID;
    v_like_exists BOOLEAN;
    v_likes_count INTEGER;
BEGIN
    -- Get current user ID
    v_user_id := auth.uid();
    
    IF v_user_id IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'Not authenticated');
    END IF;
    
    -- Check if like already exists
    SELECT EXISTS(
        SELECT 1 FROM solution_likes 
        WHERE user_id = v_user_id AND solution_id = sol_id
    ) INTO v_like_exists;
    
    IF v_like_exists THEN
        -- Unlike: Remove the like
        DELETE FROM solution_likes 
        WHERE user_id = v_user_id AND solution_id = sol_id;
        
        -- Decrement likes count
        UPDATE solutions 
        SET likes = GREATEST(0, likes - 1)
        WHERE id = sol_id;
        
        SELECT likes INTO v_likes_count FROM solutions WHERE id = sol_id;
        RETURN jsonb_build_object('success', true, 'liked', false, 'likes', v_likes_count);
    ELSE
        -- Like: Add new like
        INSERT INTO solution_likes (user_id, solution_id)
        VALUES (v_user_id, sol_id);
        
        -- Increment likes count
        UPDATE solutions 
        SET likes = likes + 1
        WHERE id = sol_id;
        
        SELECT likes INTO v_likes_count FROM solutions WHERE id = sol_id;
        RETURN jsonb_build_object('success', true, 'liked', true, 'likes', v_likes_count);
    END IF;
END;
$$;

COMMENT ON FUNCTION toggle_solution_like IS 'Toggle like/unlike on a solution atomically';

-- ============================================
-- 3. GET_OTHER_USERS_COUNT
-- Count how many other users are linked to a question
-- SECURITY DEFINER to bypass RLS for counting
-- ============================================
CREATE OR REPLACE FUNCTION get_other_users_count(
    q_id TEXT
)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_current_user UUID;
    v_count INTEGER;
BEGIN
    v_current_user := auth.uid();
    
    SELECT COUNT(*)::INTEGER INTO v_count
    FROM user_questions
    WHERE question_id = q_id
    AND user_id != v_current_user;
    
    RETURN v_count;
END;
$$;

COMMENT ON FUNCTION get_other_users_count IS 'Count other users linked to a question (excludes current user)';

-- ============================================
-- 4. INCREMENT_SOLUTIONS_COUNT
-- Increment solution count for a question
-- ============================================
CREATE OR REPLACE FUNCTION increment_solutions_count(
    question_id TEXT
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- This is a placeholder - the actual solution count comes from COUNT in queries
    -- But we keep this for compatibility with existing code
    RETURN;
END;
$$;

COMMENT ON FUNCTION increment_solutions_count IS 'Placeholder for backward compatibility';

-- ============================================
-- 5. AUTO-UPDATE UPDATED_AT TRIGGER FUNCTION
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

COMMENT ON FUNCTION update_updated_at_column IS 'Trigger function to auto-update updated_at timestamp';