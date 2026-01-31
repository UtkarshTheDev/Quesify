-- Fix solve activity trigger to handle INSERT (first-time solves)

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
            -- Get question details
            SELECT subject, chapter, owner_id INTO v_subject, v_chapter, target_user_id 
            FROM public.questions WHERE id = NEW.question_id;
            
            IF target_user_id != NEW.contributor_id THEN
                INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
                VALUES (NEW.contributor_id, 'solution_contributed', NEW.id, 'solution', 
                    jsonb_build_object('subject', v_subject, 'chapter', v_chapter, 'snippet', left(NEW.solution_text, 150), 'question_id', NEW.question_id));
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
        -- Check for INSERT with solved=true OR UPDATE with solved becoming true
        IF (TG_OP = 'INSERT' AND NEW.solved = true) OR 
           (TG_OP = 'UPDATE' AND NEW.solved = true AND (OLD.solved = false OR OLD.solved IS NULL)) THEN
            
            SELECT subject, chapter, question_text INTO v_subject, v_chapter, v_text 
            FROM public.questions WHERE id = NEW.question_id;
            
            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
            VALUES (NEW.user_id, 'question_solved', NEW.question_id, 'question', 
                jsonb_build_object('subject', v_subject, 'chapter', v_chapter, 'snippet', left(v_text, 150)));
        END IF;

    -- Handle User Questions (Forking/Bank)
    ELSIF TG_TABLE_NAME = 'user_questions' THEN
        -- Only log if the user is NOT the owner (i.e., they are linking someone else's question)
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

-- Recreate trigger for user_question_stats to include INSERT
DROP TRIGGER IF EXISTS tr_log_solve_activity ON public.user_question_stats;
CREATE TRIGGER tr_log_solve_activity
AFTER INSERT OR UPDATE ON public.user_question_stats
FOR EACH ROW EXECUTE FUNCTION public.log_user_activity();
