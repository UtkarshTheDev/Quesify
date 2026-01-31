-- Migration: Add Link Notification Trigger
-- Description: Creates a notification when a user links someone else's question to their bank
-- Created: 2026-02-01

CREATE OR REPLACE FUNCTION notify_on_link()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    question_owner_id UUID;
BEGIN
    -- Only notify for linked questions (not original uploads)
    IF NEW.is_owner = FALSE THEN
        -- Get the original owner of the question
        SELECT owner_id INTO question_owner_id
        FROM public.questions
        WHERE id = NEW.question_id;

        -- Don't notify if the user is linking their own question (edge case)
        -- OR if the question has no owner (shouldn't happen)
        IF question_owner_id IS NOT NULL AND question_owner_id != NEW.user_id THEN
            INSERT INTO public.notifications (recipient_id, sender_id, type, entity_id, entity_type)
            VALUES (
                question_owner_id,
                NEW.user_id,
                'link',
                NEW.question_id::uuid, -- Cast TEXT ID to UUID
                'question'
            );
        END IF;
    END IF;
    RETURN NEW;
END;
$$;

-- Drop trigger if exists to avoid errors during re-migration
DROP TRIGGER IF EXISTS trg_notify_on_link ON public.user_questions;

-- Create the trigger
CREATE TRIGGER trg_notify_on_link
    AFTER INSERT ON public.user_questions
    FOR EACH ROW
    EXECUTE FUNCTION notify_on_link();

COMMENT ON FUNCTION notify_on_link IS 'Notify question owner when someone links their question';
