-- Migration: Fix activity categorization and visibility
-- Description: 
-- 1. Updates log_user_activity trigger to correctly categorize contributions vs personal bank actions.
-- 2. Ensures user_activities are truly public via RLS.

-- ============================================
-- 1. CONSOLIDATE RLS POLICIES
-- ============================================

-- Ensure policy allows public selection
DROP POLICY IF EXISTS "Public user_activities are viewable by everyone" ON public.user_activities;
DROP POLICY IF EXISTS "Users can view their own activities" ON public.user_activities;

CREATE POLICY "user_activities_read_policy" 
ON public.user_activities FOR SELECT 
USING (true);

-- ============================================
-- 2. FIX ACTIVITY TRIGGER LOGIC
-- ============================================

CREATE OR REPLACE FUNCTION public.log_user_activity()
RETURNS TRIGGER AS $$
DECLARE
    v_subject TEXT;
    v_chapter TEXT;
    v_text TEXT;
    v_owner_id UUID;
BEGIN
    -- Handle Questions Table
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

    -- Handle Solutions Table
    ELSIF TG_TABLE_NAME = 'solutions' THEN
        IF TG_OP = 'INSERT' THEN
            -- Get question details
            SELECT subject, chapter, owner_id INTO v_subject, v_chapter, v_owner_id 
            FROM public.questions WHERE id = NEW.question_id;
            
            -- CONTRIBUTION LOGIC:
            -- A "contribution" is logged whenever a user adds a solution to someone ELSE'S question.
            -- This includes both:
            -- 1. Direct contributions to questions you don't own
            -- 2. Adding a solution after linking/forking someone else's question
            -- The fork action itself is logged separately as 'question_forked'.
            
            IF v_owner_id != NEW.contributor_id THEN
                INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
                VALUES (NEW.contributor_id, 'solution_contributed', NEW.id, 'solution', 
                    jsonb_build_object('subject', v_subject, 'chapter', v_chapter, 'snippet', left(NEW.solution_text, 150), 'question_id', NEW.question_id));
            END IF;
        ELSIF TG_OP = 'UPDATE' AND (OLD.solution_text IS DISTINCT FROM NEW.solution_text) THEN
            -- Get question details
            SELECT subject, chapter INTO v_subject, v_chapter
            FROM public.questions WHERE id = NEW.question_id;

            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
            VALUES (NEW.contributor_id, 'solution_updated', NEW.id, 'solution', 
                jsonb_build_object('subject', v_subject, 'chapter', v_chapter, 'snippet', left(NEW.solution_text, 150), 'question_id', NEW.question_id));
        END IF;

    -- Handle User Questions Table (Forking/Bank)
    ELSIF TG_TABLE_NAME = 'user_questions' THEN
        IF TG_OP = 'INSERT' AND NEW.is_owner = false THEN
            SELECT subject, chapter, question_text INTO v_subject, v_chapter, v_text 
            FROM public.questions WHERE id = NEW.question_id;
            
            -- LOG LINKING ACTION
            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
            VALUES (NEW.user_id, 'question_forked', NEW.question_id, 'question', 
                jsonb_build_object('subject', v_subject, 'chapter', v_chapter, 'snippet', left(v_text, 150)));
        END IF;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 3. DROP OLD DUPLICATE TRIGGERS
-- ============================================

-- Drop old triggers to prevent duplicate activity logging
DROP TRIGGER IF EXISTS trg_log_activity_on_question_link ON public.user_questions;
DROP TRIGGER IF EXISTS trg_log_activity_on_solution_create ON public.solutions;

-- ============================================
-- 4. CREATE NEW CONSOLIDATED TRIGGERS
-- ============================================

-- Trigger for questions table
DROP TRIGGER IF EXISTS trg_log_activity_questions ON public.questions;
CREATE TRIGGER trg_log_activity_questions
    AFTER INSERT OR UPDATE OR DELETE ON public.questions
    FOR EACH ROW
    EXECUTE FUNCTION public.log_user_activity();

-- Trigger for solutions table
DROP TRIGGER IF EXISTS trg_log_activity_solutions ON public.solutions;
CREATE TRIGGER trg_log_activity_solutions
    AFTER INSERT OR UPDATE ON public.solutions
    FOR EACH ROW
    EXECUTE FUNCTION public.log_user_activity();

-- Trigger for user_questions table (forking/linking)
DROP TRIGGER IF EXISTS trg_log_activity_user_questions ON public.user_questions;
CREATE TRIGGER trg_log_activity_user_questions
    AFTER INSERT ON public.user_questions
    FOR EACH ROW
    EXECUTE FUNCTION public.log_user_activity();
