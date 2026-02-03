-- Fix profile stats counts (total_uploaded, total_solved)
-- This migration adds triggers to automatically keep user_profiles stats in sync
-- and recalculates existing stats to fix any discrepancies.

-- 1. Function to recalculate stats for a specific user
CREATE OR REPLACE FUNCTION recalculate_user_stats(user_uuid UUID)
RETURNS VOID LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    v_total_uploaded INTEGER;
    v_total_solved INTEGER;
BEGIN
    -- Count uploaded questions (non-deleted)
    SELECT COUNT(*)::INTEGER INTO v_total_uploaded
    FROM questions
    WHERE owner_id = user_uuid AND deleted_at IS NULL;

    -- Count contributed solutions
    SELECT COUNT(*)::INTEGER INTO v_total_solved
    FROM solutions
    WHERE contributor_id = user_uuid;

    -- Update user profile
    UPDATE user_profiles
    SET 
        total_uploaded = v_total_uploaded,
        total_solved = v_total_solved,
        updated_at = NOW()
    WHERE user_id = user_uuid;
END;
$$;

-- 2. Trigger function to call recalculate_user_stats
CREATE OR REPLACE FUNCTION trigger_recalc_stats()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    IF TG_TABLE_NAME = 'questions' THEN
        IF TG_OP = 'INSERT' THEN
            PERFORM recalculate_user_stats(NEW.owner_id);
            RETURN NEW;
        ELSIF TG_OP = 'DELETE' THEN
            PERFORM recalculate_user_stats(OLD.owner_id);
            RETURN OLD;
        END IF;
    ELSIF TG_TABLE_NAME = 'solutions' THEN
        IF TG_OP = 'INSERT' THEN
            PERFORM recalculate_user_stats(NEW.contributor_id);
            RETURN NEW;
        ELSIF TG_OP = 'DELETE' THEN
            PERFORM recalculate_user_stats(OLD.contributor_id);
            RETURN OLD;
        END IF;
    END IF;
    RETURN NULL;
END;
$$;

-- 3. Attach triggers
-- Questions: Update on INSERT (creation) and DELETE (removal)
DROP TRIGGER IF EXISTS tr_stats_questions ON questions;
CREATE TRIGGER tr_stats_questions
AFTER INSERT OR DELETE ON questions
FOR EACH ROW EXECUTE FUNCTION trigger_recalc_stats();

-- Solutions: Update on INSERT (creation) and DELETE (removal)
DROP TRIGGER IF EXISTS tr_stats_solutions ON solutions;
CREATE TRIGGER tr_stats_solutions
AFTER INSERT OR DELETE ON solutions
FOR EACH ROW EXECUTE FUNCTION trigger_recalc_stats();

-- 4. Initial Recalculation for all users (Fix existing data)
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN SELECT user_id FROM user_profiles LOOP
        PERFORM recalculate_user_stats(r.user_id);
    END LOOP;
END;
$$;
