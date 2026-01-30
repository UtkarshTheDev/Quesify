CREATE TABLE IF NOT EXISTS public.user_follows (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    follower_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    following_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(follower_id, following_id)
);

CREATE INDEX IF NOT EXISTS idx_user_follows_follower ON public.user_follows(follower_id);
CREATE INDEX IF NOT EXISTS idx_user_follows_following ON public.user_follows(following_id);

CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    recipient_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    type TEXT NOT NULL,
    target_id UUID,
    metadata JSONB DEFAULT '{}'::jsonb,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_notifications_recipient_unread ON public.notifications(recipient_id, is_read) WHERE is_read = false;
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON public.notifications(created_at DESC);

ALTER TABLE public.user_follows ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Everyone can see follows" ON public.user_follows FOR SELECT USING (true);
CREATE POLICY "Users can manage their own follows" ON public.user_follows 
    FOR ALL USING (auth.uid() = follower_id);

CREATE POLICY "Users can see their own notifications" ON public.notifications 
    FOR SELECT USING (auth.uid() = recipient_id);
CREATE POLICY "Users can update their own notifications" ON public.notifications 
    FOR UPDATE USING (auth.uid() = recipient_id);

CREATE OR REPLACE FUNCTION public.create_notification()
RETURNS TRIGGER AS $$
DECLARE
    v_recipient_id UUID;
    v_sender_id UUID := auth.uid();
BEGIN
    CASE TG_TABLE_NAME
        WHEN 'user_follows' THEN
            v_recipient_id := NEW.following_id;
            v_sender_id := NEW.follower_id;
            
            INSERT INTO public.notifications (recipient_id, sender_id, type, target_id)
            VALUES (v_recipient_id, v_sender_id, 'follow', v_sender_id);

        WHEN 'solutions' THEN
            SELECT owner_id INTO v_recipient_id FROM public.questions WHERE id = NEW.question_id;
            IF v_recipient_id != v_sender_id THEN
                INSERT INTO public.notifications (recipient_id, sender_id, type, target_id)
                VALUES (v_recipient_id, v_sender_id, 'new_contribution', NEW.id);
            END IF;

        WHEN 'user_questions' THEN
            IF NEW.is_owner = false THEN
                SELECT owner_id INTO v_recipient_id FROM public.questions WHERE id = NEW.question_id;
                IF v_recipient_id != v_sender_id THEN
                    INSERT INTO public.notifications (recipient_id, sender_id, type, target_id)
                    VALUES (v_recipient_id, v_sender_id, 'solution_linked', NEW.question_id);
                END IF;
            END IF;
    END CASE;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS tr_notify_follow ON public.user_follows;
CREATE TRIGGER tr_notify_follow AFTER INSERT ON public.user_follows FOR EACH ROW EXECUTE FUNCTION public.create_notification();

DROP TRIGGER IF EXISTS tr_notify_solution ON public.solutions;
CREATE TRIGGER tr_notify_solution AFTER INSERT ON public.solutions FOR EACH ROW EXECUTE FUNCTION public.create_notification();

DROP TRIGGER IF EXISTS tr_notify_link ON public.user_questions;
CREATE TRIGGER tr_notify_link AFTER INSERT ON public.user_questions FOR EACH ROW EXECUTE FUNCTION public.create_notification();
