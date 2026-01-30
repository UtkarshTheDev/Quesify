-- Create User Activities Table
CREATE TABLE IF NOT EXISTS public.user_activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    activity_type TEXT NOT NULL,
    target_id UUID,
    target_type TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.user_activities ENABLE ROW LEVEL SECURITY;

-- Policy: Everyone can read public activities
CREATE POLICY "Public user_activities are viewable by everyone" 
ON public.user_activities FOR SELECT 
USING (true);

-- Index for performance
CREATE INDEX IF NOT EXISTS idx_user_activities_user_id_created_at 
ON public.user_activities (user_id, created_at DESC);

-- Trigger Function to Log Activity
CREATE OR REPLACE FUNCTION public.log_user_activity()
RETURNS TRIGGER AS $$
DECLARE
    target_metadata JSONB := '{}'::jsonb;
    target_user_id UUID;
    v_subject TEXT;
    v_chapter TEXT;
    v_text TEXT;
BEGIN
    -- Handle Questions
    IF TG_TABLE_NAME = 'questions' THEN
        IF TG_OP = 'INSERT' THEN
            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
            VALUES (NEW.owner_id, 'question_created', NEW.id, 'question', 
                jsonb_build_object('subject', NEW.subject, 'chapter', NEW.chapter, 'snippet', left(NEW.question_text, 150)));
        ELSIF TG_OP = 'UPDATE' THEN
            IF (OLD.hint IS DISTINCT FROM NEW.hint) THEN
                INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
                VALUES (NEW.owner_id, 'hint_updated', NEW.id, 'question', 
                    jsonb_build_object('subject', NEW.subject, 'chapter', NEW.chapter, 'snippet', left(NEW.question_text, 150)));
            END IF;
        ELSIF TG_OP = 'DELETE' THEN
            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
            VALUES (OLD.owner_id, 'question_deleted', OLD.id, 'question', 
                jsonb_build_object('subject', OLD.subject, 'chapter', OLD.chapter, 'snippet', left(OLD.question_text, 150)));
        END IF;

    -- Handle Solutions
    ELSIF TG_TABLE_NAME = 'solutions' THEN
        IF TG_OP = 'INSERT' THEN
            -- Only log if not contributing to own question
            SELECT subject, chapter, owner_id INTO v_subject, v_chapter, target_user_id 
            FROM public.questions WHERE id = NEW.question_id;
            
            IF target_user_id != NEW.contributor_id THEN
                INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
                VALUES (NEW.contributor_id, 'solution_contributed', NEW.id, 'solution', 
                    jsonb_build_object('subject', v_subject, 'chapter', v_chapter, 'snippet', left(NEW.solution_text, 150)));
            END IF;
        ELSIF TG_OP = 'DELETE' THEN
             SELECT subject, chapter, owner_id INTO v_subject, v_chapter, target_user_id 
             FROM public.questions WHERE id = OLD.question_id;

             INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
             VALUES (OLD.contributor_id, 'solution_deleted', OLD.id, 'solution', 
                 jsonb_build_object('subject', v_subject, 'chapter', v_chapter));
        END IF;

    -- Handle Question Stats (Solving)
    ELSIF TG_TABLE_NAME = 'user_question_stats' THEN
        IF TG_OP = 'UPDATE' AND NEW.solved = true AND (OLD.solved = false OR OLD.solved IS NULL) THEN
            SELECT subject, chapter, question_text INTO v_subject, v_chapter, v_text 
            FROM public.questions WHERE id = NEW.question_id;
            
            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
            VALUES (NEW.user_id, 'question_solved', NEW.question_id, 'question', 
                jsonb_build_object('subject', v_subject, 'chapter', v_chapter, 'snippet', left(v_text, 150)));
        END IF;

    -- Handle User Questions (Forking/Bank)
    ELSIF TG_TABLE_NAME = 'user_questions' THEN
        IF TG_OP = 'INSERT' AND NEW.is_owner = false THEN
            SELECT subject, chapter, question_text INTO v_subject, v_chapter, v_text 
            FROM public.questions WHERE id = NEW.question_id;
            
            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
            VALUES (NEW.user_id, 'question_forked', NEW.question_id, 'question', 
                jsonb_build_object('subject', v_subject, 'chapter', v_chapter, 'snippet', left(v_text, 150)));
        END IF;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create Triggers
DROP TRIGGER IF EXISTS tr_log_question_activity ON public.questions;
CREATE TRIGGER tr_log_question_activity
AFTER INSERT OR UPDATE OR DELETE ON public.questions
FOR EACH ROW EXECUTE FUNCTION public.log_user_activity();

DROP TRIGGER IF EXISTS tr_log_solution_activity ON public.solutions;
CREATE TRIGGER tr_log_solution_activity
AFTER INSERT OR DELETE ON public.solutions
FOR EACH ROW EXECUTE FUNCTION public.log_user_activity();

DROP TRIGGER IF EXISTS tr_log_solve_activity ON public.user_question_stats;
CREATE TRIGGER tr_log_solve_activity
AFTER UPDATE ON public.user_question_stats
FOR EACH ROW EXECUTE FUNCTION public.log_user_activity();

DROP TRIGGER IF EXISTS tr_log_fork_activity ON public.user_questions;
CREATE TRIGGER tr_log_fork_activity
AFTER INSERT ON public.user_questions
FOR EACH ROW EXECUTE FUNCTION public.log_user_activity();
