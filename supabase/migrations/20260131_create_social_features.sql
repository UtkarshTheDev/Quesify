-- Migration: Create Social Features
-- Description: Create follows and notifications tables with automated triggers
-- Created: 2026-01-31

-- ============================================
-- 1. FOLLOWS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS follows (
    follower_id UUID REFERENCES user_profiles(user_id) ON DELETE CASCADE,
    following_id UUID REFERENCES user_profiles(user_id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (follower_id, following_id)
);

-- RLS Policies
ALTER TABLE follows ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can view follows" ON follows;
CREATE POLICY "Anyone can view follows" 
    ON follows FOR SELECT 
    USING (true);

DROP POLICY IF EXISTS "Users can follow others" ON follows;
CREATE POLICY "Users can follow others" 
    ON follows FOR INSERT 
    WITH CHECK (auth.uid() = follower_id);

DROP POLICY IF EXISTS "Users can unfollow" ON follows;
CREATE POLICY "Users can unfollow" 
    ON follows FOR DELETE 
    USING (auth.uid() = follower_id);

-- ============================================
-- 2. NOTIFICATIONS TABLE
-- ============================================
DO $$ BEGIN
    CREATE TYPE notification_type AS ENUM (
        'follow', 
        'like', 
        'link', 
        'contribution'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    recipient_id UUID REFERENCES user_profiles(user_id) ON DELETE CASCADE,
    sender_id UUID REFERENCES user_profiles(user_id) ON DELETE CASCADE,
    type notification_type NOT NULL,
    entity_id UUID, -- Can link to user_profile (for follow) or solution/question
    entity_type TEXT, -- 'user', 'solution', 'question'
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for fast queries
CREATE INDEX IF NOT EXISTS idx_notifications_recipient ON notifications(recipient_id);
CREATE INDEX IF NOT EXISTS idx_notifications_unread ON notifications(recipient_id) WHERE is_read = FALSE;

-- RLS Policies
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users view their own notifications" ON notifications;
CREATE POLICY "Users view their own notifications" 
    ON notifications FOR SELECT 
    USING (auth.uid() = recipient_id);

DROP POLICY IF EXISTS "Users update their own notifications" ON notifications;
CREATE POLICY "Users update their own notifications" 
    ON notifications FOR UPDATE 
    USING (auth.uid() = recipient_id);

-- ============================================
-- 3. AUTOMATION TRIGGERS
-- ============================================

-- A. New Follower Notification
CREATE OR REPLACE FUNCTION notify_on_follow()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    INSERT INTO notifications (recipient_id, sender_id, type, entity_id, entity_type)
    VALUES (
        NEW.following_id,
        NEW.follower_id,
        'follow',
        NEW.follower_id::UUID,
        'user'
    );
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_notify_on_follow ON follows;
CREATE TRIGGER trg_notify_on_follow
    AFTER INSERT ON follows
    FOR EACH ROW
    EXECUTE FUNCTION notify_on_follow();

-- B. Solution Liked Notification
CREATE OR REPLACE FUNCTION notify_on_solution_like()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    solution_author_id UUID;
BEGIN
    -- Get solution author
    SELECT contributor_id INTO solution_author_id
    FROM solutions
    WHERE id = NEW.solution_id;

    -- Don't notify if liking own solution
    IF solution_author_id != NEW.user_id THEN
        INSERT INTO notifications (recipient_id, sender_id, type, entity_id, entity_type)
        VALUES (
            solution_author_id,
            NEW.user_id,
            'like',
            NEW.solution_id::UUID,
            'solution'
        );
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_notify_on_solution_like ON solution_likes;
CREATE TRIGGER trg_notify_on_solution_like
    AFTER INSERT ON solution_likes
    FOR EACH ROW
    EXECUTE FUNCTION notify_on_solution_like();

-- C. New Contribution Notification (to question owner)
CREATE OR REPLACE FUNCTION notify_on_contribution()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    question_owner_id UUID;
BEGIN
    -- Get question owner
    SELECT owner_id INTO question_owner_id
    FROM questions
    WHERE id = NEW.question_id;

    -- Don't notify if contributing to own question
    IF question_owner_id != NEW.contributor_id THEN
        INSERT INTO notifications (recipient_id, sender_id, type, entity_id, entity_type)
        VALUES (
            question_owner_id,
            NEW.contributor_id,
            'contribution',
            NEW.id::UUID, -- Linking to the solution
            'solution'
        );
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_notify_on_contribution ON solutions;
CREATE TRIGGER trg_notify_on_contribution
    AFTER INSERT ON solutions
    FOR EACH ROW
    EXECUTE FUNCTION notify_on_contribution();

-- D. New Link Notification (to question owner)
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
                NEW.question_id::UUID,
                'question'
            );
        END IF;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_notify_on_link ON public.user_questions;
CREATE TRIGGER trg_notify_on_link
    AFTER INSERT ON public.user_questions
    FOR EACH ROW
    EXECUTE FUNCTION notify_on_link();

