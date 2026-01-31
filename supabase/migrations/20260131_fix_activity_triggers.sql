-- Migration: Fix Activity Triggers and Data Consistency
-- Description: Update triggers to capture proper metadata and add cleanup for deleted questions
-- Created: 2026-01-31

-- ============================================
-- 1. UPDATE QUESTION CREATED ACTIVITY TRIGGER
-- Add subject, chapter, and snippet metadata
-- ============================================
CREATE OR REPLACE FUNCTION log_question_created_activity()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    question_subject TEXT;
    question_chapter TEXT;
    question_snippet TEXT;
BEGIN
    SELECT subject, chapter,
           LEFT(question_text, 100) || CASE WHEN LENGTH(question_text) > 100 THEN '...' ELSE '' END
    INTO question_subject, question_chapter, question_snippet
    FROM questions
    WHERE id = NEW.question_id;

    INSERT INTO user_activities (user_id, activity_type, target_id, target_type, metadata)
    VALUES (
        NEW.user_id,
        'question_created',
        NEW.question_id,
        'question',
        jsonb_build_object(
            'is_owner', NEW.is_owner,
            'subject', COALESCE(question_subject, 'General'),
            'chapter', COALESCE(question_chapter, 'Unknown'),
            'snippet', COALESCE(question_snippet, 'No preview available')
        )
    );
    RETURN NEW;
END;
$$;

COMMENT ON FUNCTION log_question_created_activity IS 'Log activity when user creates a question with full metadata';

-- ============================================
-- 2. UPDATE SOLUTION CONTRIBUTED ACTIVITY TRIGGER
-- Add subject and snippet from the related question
-- ============================================
CREATE OR REPLACE FUNCTION log_solution_contributed_activity()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    question_subject TEXT;
    question_chapter TEXT;
    question_snippet TEXT;
BEGIN
    SELECT subject, chapter,
           LEFT(question_text, 100) || CASE WHEN LENGTH(question_text) > 100 THEN '...' ELSE '' END
    INTO question_subject, question_chapter, question_snippet
    FROM questions
    WHERE id = NEW.question_id;

    INSERT INTO user_activities (user_id, activity_type, target_id, target_type, metadata)
    VALUES (
        NEW.contributor_id,
        'solution_contributed',
        NEW.id,
        'solution',
        jsonb_build_object(
            'question_id', NEW.question_id,
            'approach_description', NEW.approach_description,
            'subject', COALESCE(question_subject, 'General'),
            'chapter', COALESCE(question_chapter, 'Unknown'),
            'snippet', COALESCE(question_snippet, 'No preview available')
        )
    );
    RETURN NEW;
END;
$$;

COMMENT ON FUNCTION log_solution_contributed_activity IS 'Log activity when user contributes a solution with full metadata';

-- ============================================
-- 3. CREATE TRIGGER TO CLEAN UP ACTIVITIES WHEN QUESTION IS DELETED
-- Remove related activities when a question is permanently deleted
-- ============================================
CREATE OR REPLACE FUNCTION cleanup_activities_on_question_delete()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    DELETE FROM user_activities
    WHERE target_id = OLD.id
    AND target_type = 'question'
    AND activity_type = 'question_created';

    DELETE FROM user_activities
    WHERE target_id IN (
        SELECT id FROM solutions WHERE question_id = OLD.id
    )
    AND target_type = 'solution'
    AND activity_type = 'solution_contributed';

    RETURN OLD;
END;
$$;

DROP TRIGGER IF EXISTS trg_cleanup_activities_on_question_delete ON questions;

CREATE TRIGGER trg_cleanup_activities_on_question_delete
    AFTER DELETE ON questions
    FOR EACH ROW
    EXECUTE FUNCTION cleanup_activities_on_question_delete();

COMMENT ON FUNCTION cleanup_activities_on_question_delete IS 'Clean up related activities when a question is permanently deleted';

-- ============================================
-- 4. CLEAN UP EXISTING ORPHANED ACTIVITIES
-- Remove activities that reference non-existent questions or solutions
-- ============================================

DELETE FROM user_activities ua
WHERE ua.target_type = 'question'
AND ua.activity_type = 'question_created'
AND NOT EXISTS (
    SELECT 1 FROM questions q WHERE q.id = ua.target_id
);

DELETE FROM user_activities ua
WHERE ua.target_type = 'solution'
AND ua.activity_type = 'solution_contributed'
AND NOT EXISTS (
    SELECT 1 FROM solutions s WHERE s.id = ua.target_id
);

-- ============================================
-- 5. BACKFILL MISSING METADATA FOR EXISTING ACTIVITIES
-- Update existing activities with proper subject/chapter/snippet
-- ============================================

UPDATE user_activities ua
SET metadata = jsonb_build_object(
    'is_owner', COALESCE((ua.metadata->>'is_owner')::boolean, true),
    'subject', COALESCE(q.subject, 'General'),
    'chapter', COALESCE(q.chapter, 'Unknown'),
    'snippet', COALESCE(LEFT(q.question_text, 100) || CASE WHEN LENGTH(q.question_text) > 100 THEN '...' ELSE '' END, 'No preview available')
)
FROM questions q
WHERE ua.target_id = q.id
AND ua.target_type = 'question'
AND ua.activity_type = 'question_created';

UPDATE user_activities ua
SET metadata = jsonb_build_object(
    'question_id', s.question_id,
    'approach_description', s.approach_description,
    'subject', COALESCE(q.subject, 'General'),
    'chapter', COALESCE(q.chapter, 'Unknown'),
    'snippet', COALESCE(LEFT(q.question_text, 100) || CASE WHEN LENGTH(q.question_text) > 100 THEN '...' ELSE '' END, 'No preview available')
)
FROM solutions s
JOIN questions q ON q.id = s.question_id
WHERE ua.target_id = s.id
AND ua.target_type = 'solution'
AND ua.activity_type = 'solution_contributed';
