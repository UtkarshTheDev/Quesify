-- MIGRATION 05: RECOMMENDATION SYSTEM (REFINED RATIO & PRACTICE FOCUS)
-- Purpose: Fix RPC error 42804 by casting TEXT IDs to UUID explicitly.
-- 3:1 Ratio: 3 questions per 1 user suggestion.
-- Practice Focus: Prioritizing questions from other users.

-- 1. CLEANUP
DROP FUNCTION IF EXISTS get_mixed_feed(uuid, int, int);
DROP FUNCTION IF EXISTS get_recommended_users(uuid, int, int);
DROP FUNCTION IF EXISTS get_recommended_questions(uuid, int, int);
DROP FUNCTION IF EXISTS get_user_avg_difficulty(uuid);
DROP FUNCTION IF EXISTS get_user_chapters(uuid);
DROP FUNCTION IF EXISTS get_user_subjects(uuid);

-- 2. HELPER FUNCTIONS
CREATE OR REPLACE FUNCTION get_user_subjects(p_user_id UUID)
RETURNS TEXT[] LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    v_subjects TEXT[];
BEGIN
    SELECT ARRAY(
        SELECT DISTINCT unnest FROM (
            SELECT unnest(COALESCE(up.subjects, ARRAY[]::TEXT[]))
            FROM user_profiles up
            WHERE up.user_id = p_user_id
            UNION
            SELECT q.subject
            FROM user_questions uq
            JOIN questions q ON q.id = uq.question_id
            WHERE uq.user_id = p_user_id
            AND q.subject IS NOT NULL
        ) AS combined_subjects
    ) INTO v_subjects;
    
    RETURN COALESCE(v_subjects, ARRAY[]::TEXT[]);
END;
$$;

CREATE OR REPLACE FUNCTION get_user_chapters(p_user_id UUID)
RETURNS TEXT[] LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    v_chapters TEXT[];
BEGIN
    SELECT ARRAY(
        SELECT DISTINCT q.chapter
        FROM user_questions uq
        JOIN questions q ON q.id = uq.question_id
        WHERE uq.user_id = p_user_id
        AND q.chapter IS NOT NULL
    ) INTO v_chapters;
    
    RETURN COALESCE(v_chapters, ARRAY[]::TEXT[]);
END;
$$;

CREATE OR REPLACE FUNCTION get_user_avg_difficulty(p_user_id UUID)
RETURNS TEXT LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    v_avg NUMERIC;
BEGIN
    SELECT AVG(CASE 
        WHEN q.difficulty = 'easy' THEN 1
        WHEN q.difficulty = 'medium' THEN 2
        WHEN q.difficulty = 'hard' THEN 3
        WHEN q.difficulty = 'very_hard' THEN 4
        ELSE 2
    END) INTO v_avg
    FROM user_question_stats uqs
    JOIN questions q ON q.id = uqs.question_id
    WHERE uqs.user_id = p_user_id
    AND uqs.solved = true;
    
    IF v_avg IS NULL THEN RETURN 'medium';
    ELSIF v_avg < 1.5 THEN RETURN 'easy';
    ELSIF v_avg < 2.5 THEN RETURN 'medium';
    ELSIF v_avg < 3.5 THEN RETURN 'hard';
    ELSE RETURN 'very_hard';
    END IF;
END;
$$;

-- 3. CORE RECOMMENDATION FUNCTIONS

CREATE OR REPLACE FUNCTION get_recommended_questions(
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
    score INT
) LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    v_user_subjects TEXT[];
    v_user_chapters TEXT[];
    v_user_difficulty TEXT;
    v_followed_users UUID[];
BEGIN
    v_user_subjects := get_user_subjects(p_user_id);
    v_user_chapters := get_user_chapters(p_user_id);
    v_user_difficulty := get_user_avg_difficulty(p_user_id);
    
    SELECT ARRAY(SELECT following_id FROM follows WHERE follower_id = p_user_id) INTO v_followed_users;
    
    RETURN QUERY
    SELECT 
        q.id::UUID AS question_id,
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
        (
            -- Scoring Logic (Refined for practice)
            CASE WHEN q.subject = ANY(v_user_subjects) THEN 30 ELSE 0 END +
            CASE WHEN q.chapter = ANY(v_user_chapters) THEN 20 ELSE 0 END +
            CASE WHEN q.owner_id = ANY(v_followed_users) THEN 25 ELSE 0 END +
            CASE WHEN q.difficulty::TEXT = v_user_difficulty THEN 15 ELSE 0 END +
            -- Practice bonus: prioritizing others' questions
            CASE WHEN q.owner_id != p_user_id THEN 20 ELSE 0 END +
            -- Freshness/Popularity
            LEAST(q.popularity, 10)::INT +
            CASE WHEN q.created_at > NOW() - INTERVAL '3 days' THEN 10 ELSE 0 END
        ) AS score
    FROM questions q
    JOIN user_profiles up ON up.user_id = q.owner_id
    WHERE q.deleted_at IS NULL
    ORDER BY score DESC, q.created_at DESC
    LIMIT p_limit OFFSET p_offset;
END;
$$;

CREATE OR REPLACE FUNCTION get_recommended_users(
    p_user_id UUID,
    p_limit INT DEFAULT 10,
    p_offset INT DEFAULT 0
)
RETURNS TABLE (
    user_id UUID,
    display_name TEXT,
    username TEXT,
    avatar_url TEXT,
    common_subjects TEXT[],
    mutual_follows_count BIGINT,
    total_questions BIGINT,
    total_solutions BIGINT,
    is_following BOOLEAN,
    last_active TIMESTAMPTZ,
    score INT
) LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    RETURN QUERY
    SELECT 
        up.user_id,
        up.display_name,
        up.username,
        up.avatar_url,
        ARRAY[]::TEXT[] AS common_subjects,
        0::BIGINT AS mutual_follows_count,
        up.total_uploaded::BIGINT AS total_questions,
        up.solutions_helped_count::BIGINT AS total_solutions,
        EXISTS(SELECT 1 FROM follows f WHERE f.follower_id = p_user_id AND f.following_id = up.user_id) AS is_following,
        up.updated_at AS last_active,
        10 AS score
    FROM user_profiles up
    WHERE up.user_id != p_user_id
    AND NOT EXISTS (SELECT 1 FROM follows f WHERE f.follower_id = p_user_id AND f.following_id = up.user_id)
    ORDER BY up.updated_at DESC
    LIMIT p_limit OFFSET p_offset;
END;
$$;

-- 4. MIXED FEED (3:1 Ratio)
CREATE OR REPLACE FUNCTION get_mixed_feed(
    p_user_id UUID,
    p_limit INT DEFAULT 20,
    p_offset INT DEFAULT 0
)
RETURNS TABLE (
    item_id UUID,
    item_type TEXT,
    item_data JSONB,
    score INT,
    created_at TIMESTAMPTZ
) LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    v_question_count INT;
    v_user_count INT;
BEGIN
    -- 3:1 ratio
    v_question_count := GREATEST(1, floor(p_limit * 0.75));
    v_user_count := GREATEST(1, floor(p_limit * 0.25));

    RETURN QUERY
    WITH 
    q_source AS (
        SELECT 
            rq.question_id::UUID AS src_id,
            'question'::TEXT AS src_type,
            jsonb_build_object(
                'id', rq.question_id,
                'question_text', rq.question_text,
                'subject', rq.subject,
                'chapter', rq.chapter,
                'difficulty', rq.difficulty,
                'uploader', jsonb_build_object(
                    'user_id', rq.uploader_user_id,
                    'display_name', rq.uploader_display_name,
                    'username', rq.uploader_username
                )
            ) AS src_data,
            rq.score::INT AS src_score,
            rq.created_at AS src_created_at,
            ROW_NUMBER() OVER (ORDER BY rq.score DESC, rq.created_at DESC) AS custom_rn
        FROM get_recommended_questions(p_user_id, v_question_count + p_offset, 0) rq
    ),
    u_source AS (
        SELECT 
            ru.user_id::UUID AS src_id,
            'user_suggestion'::TEXT AS src_type,
            jsonb_build_object(
                'user_id', ru.user_id,
                'display_name', ru.display_name,
                'username', ru.username,
                'avatar_url', ru.avatar_url,
                'is_following', ru.is_following
            ) AS src_data,
            ru.score::INT AS src_score,
            ru.last_active AS src_created_at,
            ROW_NUMBER() OVER (ORDER BY ru.score DESC) AS custom_rn
        FROM get_recommended_users(p_user_id, v_user_count + (p_offset / 3), 0) ru
    ),
    combined_source AS (
        SELECT src_id, src_type, src_data, src_score, src_created_at, custom_rn FROM q_source
        UNION ALL
        SELECT src_id, src_type, src_data, src_score, src_created_at, custom_rn FROM u_source
    ),
    ordered_feed AS (
        SELECT
            c.src_id,
            c.src_type,
            c.src_data,
            c.src_score,
            c.src_created_at,
            CASE 
                WHEN c.src_type = 'question' THEN c.custom_rn + (c.custom_rn - 1) / 3
                ELSE (c.custom_rn * 4)
            END AS sort_order
        FROM combined_source c
    )
    SELECT
        of_feed.src_id AS item_id,
        of_feed.src_type AS item_type,
        of_feed.src_data AS item_data,
        of_feed.src_score AS score,
        of_feed.src_created_at AS created_at
    FROM ordered_feed of_feed
    ORDER BY of_feed.sort_order ASC
    LIMIT p_limit
    OFFSET p_offset;
END;
$$;

-- 5. PERMISSIONS
GRANT EXECUTE ON FUNCTION get_user_subjects(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION get_user_chapters(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION get_user_avg_difficulty(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION get_recommended_questions(UUID, INT, INT) TO authenticated;
GRANT EXECUTE ON FUNCTION get_recommended_users(UUID, INT, INT) TO authenticated;
GRANT EXECUTE ON FUNCTION get_mixed_feed(UUID, INT, INT) TO authenticated;
