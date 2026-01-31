-- Consolidated Migration 02: Tables and Indexes
-- Includes: All application tables and performance indexes

-- 1. USER PROFILES
CREATE TABLE user_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    display_name TEXT,
    username TEXT UNIQUE,
    avatar_url TEXT,
    subjects TEXT[],
    streak_count INTEGER DEFAULT 0,
    last_streak_date DATE,
    total_solved INTEGER DEFAULT 0,
    total_uploaded INTEGER DEFAULT 0,
    solutions_helped_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    CONSTRAINT unique_user_id UNIQUE (user_id),
    CONSTRAINT username_format CHECK (username ~* '^[a-z0-9_]+$'),
    CONSTRAINT username_length CHECK (LENGTH(username) >= 3)
);

-- 2. QUESTIONS
CREATE TABLE questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL REFERENCES user_profiles(user_id) ON DELETE CASCADE,
    extracted_text TEXT,
    question_text TEXT NOT NULL,
    options JSONB DEFAULT '[]'::JSONB,
    type question_type_enum DEFAULT 'MCQ',
    has_diagram BOOLEAN DEFAULT FALSE,
    image_url TEXT,
    subject TEXT,
    chapter TEXT,
    topics JSONB DEFAULT '[]'::JSONB,
    difficulty difficulty_enum DEFAULT 'medium',
    importance INTEGER DEFAULT 3 CHECK (importance >= 1 AND importance <= 5),
    hint TEXT,
    embedding VECTOR(768),
    popularity INTEGER DEFAULT 1,
    deleted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. SOLUTIONS
CREATE TABLE solutions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    contributor_id UUID NOT NULL REFERENCES user_profiles(user_id) ON DELETE CASCADE,
    solution_text TEXT NOT NULL,
    numerical_answer TEXT,
    approach_description TEXT,
    correct_option INTEGER,
    avg_solve_time INTEGER DEFAULT 0,
    likes INTEGER DEFAULT 0,
    is_ai_best BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. USER_QUESTIONS
CREATE TABLE user_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES user_profiles(user_id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    is_owner BOOLEAN DEFAULT FALSE,
    is_contributor BOOLEAN DEFAULT FALSE,
    added_at TIMESTAMPTZ DEFAULT NOW(),
    
    CONSTRAINT unique_user_question UNIQUE (user_id, question_id)
);

-- 5. USER_QUESTION_STATS
CREATE TABLE user_question_stats (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES user_profiles(user_id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    solved BOOLEAN DEFAULT FALSE,
    failed BOOLEAN DEFAULT FALSE,
    struggled BOOLEAN DEFAULT FALSE,
    attempts INTEGER DEFAULT 0,
    time_spent INTEGER DEFAULT 0,
    user_difficulty INTEGER CHECK (user_difficulty >= 1 AND user_difficulty <= 5),
    last_practiced_at TIMESTAMPTZ,
    next_review_at TIMESTAMPTZ,
    in_revise_later BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    CONSTRAINT unique_user_question_stats UNIQUE (user_id, question_id)
);

-- 6. SOLUTION_LIKES
CREATE TABLE solution_likes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES user_profiles(user_id) ON DELETE CASCADE,
    solution_id UUID NOT NULL REFERENCES solutions(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    CONSTRAINT unique_user_solution_like UNIQUE (user_id, solution_id)
);

-- 7. REVISE_LATER
CREATE TABLE revise_later (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES user_profiles(user_id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    added_at TIMESTAMPTZ DEFAULT NOW(),
    
    CONSTRAINT unique_user_revise_later UNIQUE (user_id, question_id)
);

-- 8. USER_ACTIVITIES
CREATE TABLE user_activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES user_profiles(user_id) ON DELETE CASCADE,
    activity_type activity_type_enum NOT NULL,
    target_id UUID,
    target_type target_type_enum,
    metadata JSONB DEFAULT '{}'::JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 9. SYLLABUS
CREATE TABLE syllabus (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    class TEXT,
    subject TEXT NOT NULL,
    chapter TEXT NOT NULL,
    topics JSONB DEFAULT '[]'::JSONB,
    priority INTEGER DEFAULT 3 CHECK (priority >= 1 AND priority <= 5),
    is_verified BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 10. FOLLOWS
CREATE TABLE follows (
    follower_id UUID NOT NULL REFERENCES user_profiles(user_id) ON DELETE CASCADE,
    following_id UUID NOT NULL REFERENCES user_profiles(user_id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (follower_id, following_id)
);

-- 11. NOTIFICATIONS
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    recipient_id UUID NOT NULL REFERENCES user_profiles(user_id) ON DELETE CASCADE,
    sender_id UUID REFERENCES user_profiles(user_id) ON DELETE SET NULL,
    type notification_type NOT NULL,
    entity_id UUID,
    entity_type TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- INDEXES
-- ============================================

-- user_profiles
CREATE INDEX idx_user_profiles_username ON user_profiles(username);
CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);

-- questions
CREATE INDEX idx_questions_owner_id ON questions(owner_id);
CREATE INDEX idx_questions_subject ON questions(subject);
CREATE INDEX idx_questions_chapter ON questions(chapter);
CREATE INDEX idx_questions_subject_chapter ON questions(subject, chapter);
CREATE INDEX idx_questions_type ON questions(type);
CREATE INDEX idx_questions_difficulty ON questions(difficulty);
CREATE INDEX idx_questions_deleted_at ON questions(deleted_at) WHERE deleted_at IS NULL;
CREATE INDEX idx_questions_popularity ON questions(popularity DESC);
CREATE INDEX idx_questions_embedding ON questions USING hnsw (embedding vector_cosine_ops) WITH (m = 16, ef_construction = 64);

-- solutions
CREATE INDEX idx_solutions_question_id ON solutions(question_id);
CREATE INDEX idx_solutions_contributor_id ON solutions(contributor_id);
CREATE INDEX idx_solutions_likes ON solutions(likes DESC);
CREATE INDEX idx_solutions_is_ai_best ON solutions(is_ai_best) WHERE is_ai_best = TRUE;

-- user_questions
CREATE INDEX idx_user_questions_user_id ON user_questions(user_id);
CREATE INDEX idx_user_questions_question_id ON user_questions(question_id);
CREATE INDEX idx_user_questions_is_owner ON user_questions(user_id, is_owner) WHERE is_owner = TRUE;

-- user_question_stats
CREATE INDEX idx_user_question_stats_user_id ON user_question_stats(user_id);
CREATE INDEX idx_user_question_stats_question_id ON user_question_stats(question_id);
CREATE INDEX idx_user_question_stats_solved ON user_question_stats(user_id, solved) WHERE solved = TRUE;
CREATE INDEX idx_user_question_stats_next_review ON user_question_stats(user_id, next_review_at) WHERE next_review_at IS NOT NULL;

-- solution_likes
CREATE INDEX idx_solution_likes_solution_id ON solution_likes(solution_id);
CREATE INDEX idx_solution_likes_user_id ON solution_likes(user_id);

-- user_activities
CREATE INDEX idx_user_activities_user_id_created_at ON user_activities(user_id, created_at DESC);

-- follows
CREATE INDEX idx_follows_follower ON follows(follower_id);
CREATE INDEX idx_follows_following ON follows(following_id);

-- notifications
CREATE INDEX idx_notifications_recipient_unread ON notifications(recipient_id, is_read) WHERE is_read = false;
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);

-- syllabus
CREATE INDEX idx_syllabus_subject_chapter ON syllabus(subject, chapter);
