-- Migration: Create Triggers
-- Description: Automatic triggers for updated_at and computed fields
-- Created: 2026-01-30

-- ============================================
-- 1. AUTO-UPDATE UPDATED_AT TRIGGERS
-- ============================================

-- user_profiles
CREATE TRIGGER update_user_profiles_updated_at
    BEFORE UPDATE ON user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- questions
CREATE TRIGGER update_questions_updated_at
    BEFORE UPDATE ON questions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- solutions
CREATE TRIGGER update_solutions_updated_at
    BEFORE UPDATE ON solutions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- user_question_stats
CREATE TRIGGER update_user_question_stats_updated_at
    BEFORE UPDATE ON user_question_stats
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 2. AUTO-INCREMENT QUESTION POPULARITY
-- When a user links to a question, increment popularity
-- ============================================
CREATE OR REPLACE FUNCTION increment_question_popularity()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE questions 
    SET popularity = popularity + 1
    WHERE id = NEW.question_id;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_increment_popularity_on_link
    AFTER INSERT ON user_questions
    FOR EACH ROW
    EXECUTE FUNCTION increment_question_popularity();

COMMENT ON FUNCTION increment_question_popularity IS 'Increment question popularity when a new user links to it';

-- ============================================
-- 3. AUTO-DECREMENT QUESTION POPULARITY
-- When a user unlinks from a question, decrement popularity
-- ============================================
CREATE OR REPLACE FUNCTION decrement_question_popularity()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE questions 
    SET popularity = GREATEST(0, popularity - 1)
    WHERE id = OLD.question_id;
    RETURN OLD;
END;
$$;

CREATE TRIGGER trg_decrement_popularity_on_unlink
    AFTER DELETE ON user_questions
    FOR EACH ROW
    EXECUTE FUNCTION decrement_question_popularity();

COMMENT ON FUNCTION decrement_question_popularity IS 'Decrement question popularity when a user unlinks';

-- ============================================
-- 4. AUTO-LOG ACTIVITY ON QUESTION CREATE
-- ============================================
CREATE OR REPLACE FUNCTION log_question_created_activity()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    INSERT INTO user_activities (user_id, activity_type, target_id, target_type, metadata)
    VALUES (
        NEW.user_id,
        'question_created',
        NEW.question_id,
        'question',
        jsonb_build_object(
            'is_owner', NEW.is_owner
        )
    );
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_log_activity_on_question_link
    AFTER INSERT ON user_questions
    FOR EACH ROW
    WHEN (NEW.is_owner = TRUE)
    EXECUTE FUNCTION log_question_created_activity();

COMMENT ON FUNCTION log_question_created_activity IS 'Log activity when user creates a question';

-- ============================================
-- 5. AUTO-LOG ACTIVITY ON SOLUTION CREATE
-- ============================================
CREATE OR REPLACE FUNCTION log_solution_contributed_activity()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    INSERT INTO user_activities (user_id, activity_type, target_id, target_type, metadata)
    VALUES (
        NEW.contributor_id,
        'solution_contributed',
        NEW.id,
        'solution',
        jsonb_build_object(
            'question_id', NEW.question_id,
            'approach_description', NEW.approach_description
        )
    );
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_log_activity_on_solution_create
    AFTER INSERT ON solutions
    FOR EACH ROW
    EXECUTE FUNCTION log_solution_contributed_activity();

COMMENT ON FUNCTION log_solution_contributed_activity IS 'Log activity when user contributes a solution';

-- ============================================
-- 6. SYNC REVISE_LATER WITH USER_QUESTION_STATS
-- When added to revise_later, update the stats table
-- ============================================
CREATE OR REPLACE FUNCTION sync_revise_later_to_stats()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    INSERT INTO user_question_stats (user_id, question_id, in_revise_later)
    VALUES (NEW.user_id, NEW.question_id, TRUE)
    ON CONFLICT (user_id, question_id)
    DO UPDATE SET in_revise_later = TRUE, updated_at = NOW();
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_sync_revise_later_insert
    AFTER INSERT ON revise_later
    FOR EACH ROW
    EXECUTE FUNCTION sync_revise_later_to_stats();

COMMENT ON FUNCTION sync_revise_later_to_stats IS 'Sync revise_later insert to user_question_stats';

-- ============================================
-- 7. SYNC REVISE_LATER DELETE WITH USER_QUESTION_STATS
-- ============================================
CREATE OR REPLACE FUNCTION sync_revise_later_delete_to_stats()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE user_question_stats
    SET in_revise_later = FALSE, updated_at = NOW()
    WHERE user_id = OLD.user_id AND question_id = OLD.question_id;
    RETURN OLD;
END;
$$;

CREATE TRIGGER trg_sync_revise_later_delete
    AFTER DELETE ON revise_later
    FOR EACH ROW
    EXECUTE FUNCTION sync_revise_later_delete_to_stats();

COMMENT ON FUNCTION sync_revise_later_delete_to_stats IS 'Sync revise_later delete to user_question_stats';