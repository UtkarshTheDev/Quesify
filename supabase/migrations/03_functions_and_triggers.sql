-- Consolidated Migration 03: Functions and Triggers
-- Includes: All database functions and automated triggers

-- ============================================
-- 1. UTILITY FUNCTIONS
-- ============================================

-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

-- Auto-create user profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    INSERT INTO public.user_profiles (user_id, display_name, username, avatar_url)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'display_name', NEW.email),
        NULL,
        COALESCE(NEW.raw_user_meta_data->>'avatar_url', NEW.raw_user_meta_data->>'picture')
    )
    ON CONFLICT (user_id) DO NOTHING;
    RETURN NEW;
END;
$$;

-- ============================================
-- 2. BUSINESS LOGIC FUNCTIONS
-- ============================================

-- Vector similarity search for duplicate detection
CREATE OR REPLACE FUNCTION match_questions_with_solutions(
    query_embedding VECTOR(768),
    match_threshold FLOAT,
    match_count INT
)
RETURNS TABLE (
    id UUID,
    owner_id UUID,
    question_text TEXT,
    matched_solution_text TEXT,
    similarity FLOAT
) LANGUAGE plpgsql SECURITY DEFINER AS $$
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

-- Toggle solution like atomically
CREATE OR REPLACE FUNCTION toggle_solution_like(sol_id UUID)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    v_user_id UUID;
    v_like_exists BOOLEAN;
    v_likes_count INTEGER;
BEGIN
    v_user_id := auth.uid();
    IF v_user_id IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'Not authenticated');
    END IF;
    
    SELECT EXISTS(
        SELECT 1 FROM solution_likes 
        WHERE user_id = v_user_id AND solution_id = sol_id
    ) INTO v_like_exists;
    
    IF v_like_exists THEN
        DELETE FROM solution_likes WHERE user_id = v_user_id AND solution_id = sol_id;
        UPDATE solutions SET likes = GREATEST(0, likes - 1) WHERE id = sol_id;
        SELECT likes INTO v_likes_count FROM solutions WHERE id = sol_id;
        RETURN jsonb_build_object('success', true, 'liked', false, 'likes', v_likes_count);
    ELSE
        INSERT INTO solution_likes (user_id, solution_id) VALUES (v_user_id, sol_id);
        UPDATE solutions SET likes = likes + 1 WHERE id = sol_id;
        SELECT likes INTO v_likes_count FROM solutions WHERE id = sol_id;
        RETURN jsonb_build_object('success', true, 'liked', true, 'likes', v_likes_count);
    END IF;
END;
$$;

-- Count other users linked to a question
CREATE OR REPLACE FUNCTION get_other_users_count(q_id UUID)
RETURNS INTEGER LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*)::INTEGER INTO v_count
    FROM user_questions
    WHERE question_id = q_id
    AND user_id != auth.uid();
    RETURN v_count;
END;
$$;

-- ============================================
-- 3. ACTIVITY LOGGING TRIGGER
-- ============================================

CREATE OR REPLACE FUNCTION public.log_user_activity()
RETURNS TRIGGER AS $$
DECLARE
    v_subject TEXT;
    v_chapter TEXT;
    v_text TEXT;
    v_owner_id UUID;
BEGIN
    -- Questions Table
    IF TG_TABLE_NAME = 'questions' THEN
        IF TG_OP = 'INSERT' THEN
            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
            VALUES (NEW.owner_id, 'question_created', NEW.id, 'question', 
                jsonb_build_object('subject', NEW.subject, 'chapter', NEW.chapter, 'snippet', left(NEW.question_text, 150)));
        ELSIF TG_OP = 'UPDATE' AND (OLD.hint IS DISTINCT FROM NEW.hint) THEN
            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
            VALUES (NEW.owner_id, 'hint_updated', NEW.id, 'question', 
                jsonb_build_object('subject', NEW.subject, 'chapter', NEW.chapter, 'snippet', left(NEW.question_text, 150)));
        ELSIF TG_OP = 'DELETE' THEN
            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
            VALUES (OLD.owner_id, 'question_deleted', OLD.id, 'question', 
                jsonb_build_object('subject', OLD.subject, 'chapter', OLD.chapter, 'snippet', left(OLD.question_text, 150)));
        END IF;

    -- Solutions Table
    ELSIF TG_TABLE_NAME = 'solutions' THEN
        IF TG_OP = 'INSERT' THEN
            SELECT subject, chapter, owner_id INTO v_subject, v_chapter, v_owner_id 
            FROM public.questions WHERE id = NEW.question_id;
            
            IF v_owner_id != NEW.contributor_id THEN
                INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
                VALUES (NEW.contributor_id, 'solution_contributed', NEW.id, 'solution', 
                    jsonb_build_object('subject', v_subject, 'chapter', v_chapter, 'snippet', left(NEW.solution_text, 150), 'question_id', NEW.question_id));
            END IF;
        ELSIF TG_OP = 'UPDATE' AND (OLD.solution_text IS DISTINCT FROM NEW.solution_text) THEN
            SELECT subject, chapter INTO v_subject, v_chapter
            FROM public.questions WHERE id = NEW.question_id;

            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
            VALUES (NEW.contributor_id, 'solution_updated', NEW.id, 'solution', 
                jsonb_build_object('subject', v_subject, 'chapter', v_chapter, 'snippet', left(NEW.solution_text, 150), 'question_id', NEW.question_id));
        ELSIF TG_OP = 'DELETE' THEN
             SELECT subject, chapter INTO v_subject, v_chapter
             FROM public.questions WHERE id = OLD.question_id;

             INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
             VALUES (OLD.contributor_id, 'solution_deleted', OLD.id, 'solution', 
                 jsonb_build_object('subject', v_subject, 'chapter', v_chapter));
        END IF;

    -- User Questions Table (Forking)
    ELSIF TG_TABLE_NAME = 'user_questions' THEN
        IF TG_OP = 'INSERT' AND NEW.is_owner = false THEN
            SELECT subject, chapter, question_text INTO v_subject, v_chapter, v_text 
            FROM public.questions WHERE id = NEW.question_id;
            
            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
            VALUES (NEW.user_id, 'question_forked', NEW.question_id, 'question', 
                jsonb_build_object('subject', v_subject, 'chapter', v_chapter, 'snippet', left(v_text, 150)));
        END IF;

    -- Question Stats Table (Solving)
    ELSIF TG_TABLE_NAME = 'user_question_stats' THEN
        IF (TG_OP = 'INSERT' AND NEW.solved = true) OR 
           (TG_OP = 'UPDATE' AND NEW.solved = true AND (OLD.solved = false OR OLD.solved IS NULL)) THEN
            SELECT subject, chapter, question_text INTO v_subject, v_chapter, v_text 
            FROM public.questions WHERE id = NEW.question_id;
            
            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
            VALUES (NEW.user_id, 'question_solved', NEW.question_id, 'question', 
                jsonb_build_object('subject', v_subject, 'chapter', v_chapter, 'snippet', left(v_text, 150)));
        END IF;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Cleanup activities on question delete
CREATE OR REPLACE FUNCTION cleanup_activities_on_question_delete()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    DELETE FROM user_activities WHERE target_id = OLD.id AND target_type = 'question' AND activity_type = 'question_created';
    DELETE FROM user_activities WHERE target_id IN (SELECT id FROM solutions WHERE question_id = OLD.id) AND target_type = 'solution' AND activity_type = 'solution_contributed';
    RETURN OLD;
END;
$$;

-- ============================================
-- 4. NOTIFICATION TRIGGERS
-- ============================================

-- Unified notification logic
CREATE OR REPLACE FUNCTION create_notification()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    v_recipient_id UUID;
    v_sender_id UUID := auth.uid();
BEGIN
    CASE TG_TABLE_NAME
        WHEN 'follows' THEN
            INSERT INTO notifications (recipient_id, sender_id, type, entity_id, entity_type)
            VALUES (NEW.following_id, NEW.follower_id, 'follow', NEW.follower_id, 'user');

        WHEN 'solution_likes' THEN
            SELECT contributor_id INTO v_recipient_id FROM solutions WHERE id = NEW.solution_id;
            IF v_recipient_id != v_sender_id THEN
                INSERT INTO notifications (recipient_id, sender_id, type, entity_id, entity_type)
                VALUES (v_recipient_id, v_sender_id, 'like', NEW.solution_id, 'solution');
            END IF;

        WHEN 'solutions' THEN
            SELECT owner_id INTO v_recipient_id FROM questions WHERE id = NEW.question_id;
            IF v_recipient_id != v_sender_id THEN
                INSERT INTO notifications (recipient_id, sender_id, type, entity_id, entity_type)
                VALUES (v_recipient_id, v_sender_id, 'contribution', NEW.id, 'solution');
            END IF;

        WHEN 'user_questions' THEN
            IF NEW.is_owner = false THEN
                SELECT owner_id INTO v_recipient_id FROM questions WHERE id = NEW.question_id;
                IF v_recipient_id != v_sender_id THEN
                    INSERT INTO notifications (recipient_id, sender_id, type, entity_id, entity_type)
                    VALUES (v_recipient_id, v_sender_id, 'link', NEW.question_id, 'question');
                END IF;
            END IF;
    END CASE;
    RETURN NEW;
END;
$$;

-- ============================================
-- 5. OTHER TRIGGER FUNCTIONS
-- ============================================

-- Popularity tracking
CREATE OR REPLACE FUNCTION update_question_popularity()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE questions SET popularity = popularity + 1 WHERE id = NEW.question_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE questions SET popularity = GREATEST(0, popularity - 1) WHERE id = OLD.question_id;
        RETURN OLD;
    END IF;
END;
$$;

-- Sync revise_later to stats
CREATE OR REPLACE FUNCTION sync_revise_later()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO user_question_stats (user_id, question_id, in_revise_later)
        VALUES (NEW.user_id, NEW.question_id, TRUE)
        ON CONFLICT (user_id, question_id) DO UPDATE SET in_revise_later = TRUE, updated_at = NOW();
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE user_question_stats SET in_revise_later = FALSE, updated_at = NOW()
        WHERE user_id = OLD.user_id AND question_id = OLD.question_id;
        RETURN OLD;
    END IF;
END;
$$;

-- ============================================
-- 6. TRIGGERS ASSIGNMENT
-- ============================================

-- updated_at triggers
CREATE TRIGGER tr_updated_at_user_profiles BEFORE UPDATE ON user_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER tr_updated_at_questions BEFORE UPDATE ON questions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER tr_updated_at_solutions BEFORE UPDATE ON solutions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER tr_updated_at_user_question_stats BEFORE UPDATE ON user_question_stats FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Auth user created trigger
CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Activity triggers
CREATE TRIGGER tr_log_activity_questions AFTER INSERT OR UPDATE OR DELETE ON questions FOR EACH ROW EXECUTE FUNCTION public.log_user_activity();
CREATE TRIGGER tr_log_activity_solutions AFTER INSERT OR UPDATE OR DELETE ON solutions FOR EACH ROW EXECUTE FUNCTION public.log_user_activity();
CREATE TRIGGER tr_log_activity_user_questions AFTER INSERT ON user_questions FOR EACH ROW EXECUTE FUNCTION public.log_user_activity();
CREATE TRIGGER tr_log_activity_stats AFTER INSERT OR UPDATE ON user_question_stats FOR EACH ROW EXECUTE FUNCTION public.log_user_activity();

-- Cleanup trigger
CREATE TRIGGER tr_cleanup_activities AFTER DELETE ON questions FOR EACH ROW EXECUTE FUNCTION cleanup_activities_on_question_delete();

-- Notification triggers
CREATE TRIGGER tr_notify_follow AFTER INSERT ON follows FOR EACH ROW EXECUTE FUNCTION create_notification();
CREATE TRIGGER tr_notify_like AFTER INSERT ON solution_likes FOR EACH ROW EXECUTE FUNCTION create_notification();
CREATE TRIGGER tr_notify_solution AFTER INSERT ON solutions FOR EACH ROW EXECUTE FUNCTION create_notification();
CREATE TRIGGER tr_notify_link AFTER INSERT ON user_questions FOR EACH ROW EXECUTE FUNCTION create_notification();

-- Popularity triggers
CREATE TRIGGER tr_popularity_link AFTER INSERT OR DELETE ON user_questions FOR EACH ROW EXECUTE FUNCTION update_question_popularity();

-- Sync triggers
CREATE TRIGGER tr_sync_revise_later AFTER INSERT OR DELETE ON revise_later FOR EACH ROW EXECUTE FUNCTION sync_revise_later();
