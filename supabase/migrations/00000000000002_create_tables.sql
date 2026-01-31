-- Migration: Create Core Tables
-- Description: Create all application tables with constraints
-- Created: 2026-01-30

-- ============================================
-- 1. USER PROFILES
-- Extended user data linked to auth.users
-- ============================================
CREATE TABLE user_profiles (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    display_name TEXT,
    username TEXT UNIQUE,
    avatar_url TEXT,
    subjects TEXT[], -- Array of subjects user studies
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

COMMENT ON TABLE user_profiles IS 'Extended user profile information';
COMMENT ON COLUMN user_profiles.user_id IS 'Reference to auth.users';
COMMENT ON COLUMN user_profiles.username IS 'Unique public handle (lowercase, numbers, underscores)';
COMMENT ON COLUMN user_profiles.subjects IS 'Array of subjects the user is studying';

-- ============================================
-- 2. QUESTIONS
-- Core question data with soft delete support
-- ============================================
CREATE TABLE questions (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    owner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    extracted_text TEXT, -- Raw OCR/extracted text before formatting
    question_text TEXT NOT NULL, -- LaTeX formatted question
    options JSONB DEFAULT '[]'::JSONB, -- MCQ options with LaTeX
    type question_type_enum DEFAULT 'MCQ',
    has_diagram BOOLEAN DEFAULT FALSE,
    image_url TEXT, -- Supabase Storage URL
    subject TEXT,
    chapter TEXT,
    topics JSONB DEFAULT '[]'::JSONB, -- Array of topic strings
    difficulty difficulty_enum DEFAULT 'medium',
    importance INTEGER DEFAULT 3 CHECK (importance >= 1 AND importance <= 5),
    hint TEXT, -- AI-generated hint
    embedding VECTOR(768), -- Gemini embedding for similarity search
    popularity INTEGER DEFAULT 1, -- Count of users who have this question
    deleted_at TIMESTAMPTZ, -- Soft delete timestamp
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE questions IS 'Core question bank with soft delete';
COMMENT ON COLUMN questions.extracted_text IS 'Raw text extracted from image';
COMMENT ON COLUMN questions.question_text IS 'Formatted question with LaTeX';
COMMENT ON COLUMN questions.embedding IS 'Gemini embedding (768 dims) for similarity';
COMMENT ON COLUMN questions.popularity IS 'Number of users linked to this question';
COMMENT ON COLUMN questions.deleted_at IS 'Soft delete - NULL means active';

-- ============================================
-- 3. SOLUTIONS
-- Multiple solutions per question
-- ============================================
CREATE TABLE solutions (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    question_id TEXT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    contributor_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    solution_text TEXT NOT NULL, -- LaTeX formatted solution
    numerical_answer TEXT, -- For numerical questions
    approach_description TEXT, -- Brief description of approach
    correct_option INTEGER, -- 0-indexed correct option for MCQ
    avg_solve_time INTEGER DEFAULT 0, -- Estimated time in seconds
    likes INTEGER DEFAULT 0,
    is_ai_best BOOLEAN DEFAULT FALSE, -- AI's initial pick as best solution
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE solutions IS 'Multiple solutions per question';
COMMENT ON COLUMN solutions.correct_option IS '0-indexed correct option for MCQ (0=A, 1=B, etc.)';
COMMENT ON COLUMN solutions.avg_solve_time IS 'Estimated solve time in seconds';
COMMENT ON COLUMN solutions.is_ai_best IS 'Flag for AI-selected best solution';

-- ============================================
-- 4. USER_QUESTIONS
-- Links users to questions (ownership/forking)
-- ============================================
CREATE TABLE user_questions (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    question_id TEXT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    is_owner BOOLEAN DEFAULT FALSE,
    is_contributor BOOLEAN DEFAULT FALSE, -- User added a solution
    added_at TIMESTAMPTZ DEFAULT NOW(),
    
    CONSTRAINT unique_user_question UNIQUE (user_id, question_id)
);

COMMENT ON TABLE user_questions IS 'Links users to questions they own or have forked';
COMMENT ON COLUMN user_questions.is_owner IS 'True if user created this question';
COMMENT ON COLUMN user_questions.is_contributor IS 'True if user added a solution';

-- ============================================
-- 5. USER_QUESTION_STATS
-- Per-user solving statistics
-- ============================================
CREATE TABLE user_question_stats (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    question_id TEXT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    solved BOOLEAN DEFAULT FALSE,
    failed BOOLEAN DEFAULT FALSE,
    struggled BOOLEAN DEFAULT FALSE,
    attempts INTEGER DEFAULT 0,
    time_spent INTEGER DEFAULT 0, -- Total time in seconds
    user_difficulty INTEGER CHECK (user_difficulty >= 1 AND user_difficulty <= 5),
    last_practiced_at TIMESTAMPTZ,
    next_review_at TIMESTAMPTZ, -- For spaced repetition
    in_revise_later BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    CONSTRAINT unique_user_question_stats UNIQUE (user_id, question_id)
);

COMMENT ON TABLE user_question_stats IS 'Per-user statistics for each question';
COMMENT ON COLUMN user_question_stats.struggled IS 'True if time exceeded threshold or marked failed';
COMMENT ON COLUMN user_question_stats.next_review_at IS 'Next spaced repetition review date';

-- ============================================
-- 6. SOLUTION_LIKES
-- User likes on solutions
-- ============================================
CREATE TABLE solution_likes (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    solution_id TEXT NOT NULL REFERENCES solutions(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    CONSTRAINT unique_user_solution_like UNIQUE (user_id, solution_id)
);

COMMENT ON TABLE solution_likes IS 'Tracks which users liked which solutions';

-- ============================================
-- 7. REVISE_LATER
-- User's revise later list
-- ============================================
CREATE TABLE revise_later (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    question_id TEXT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    added_at TIMESTAMPTZ DEFAULT NOW(),
    
    CONSTRAINT unique_user_revise_later UNIQUE (user_id, question_id)
);

COMMENT ON TABLE revise_later IS 'Questions user wants to revise later';

-- ============================================
-- 8. USER_ACTIVITIES
-- Activity feed log
-- ============================================
CREATE TABLE user_activities (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    activity_type activity_type_enum NOT NULL,
    target_id TEXT, -- question_id or solution_id
    target_type target_type_enum,
    metadata JSONB DEFAULT '{}'::JSONB, -- Additional context (subject, chapter, snippet)
    created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE user_activities IS 'Activity feed for user profiles';
COMMENT ON COLUMN user_activities.metadata IS 'JSON with subject, chapter, snippet, etc.';

-- ============================================
-- 9. SYLLABUS
-- Preset Class 11/12 syllabus
-- ============================================
CREATE TABLE syllabus (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    class TEXT, -- '11', '12', or NULL for universal
    subject TEXT NOT NULL,
    chapter TEXT NOT NULL,
    topics JSONB DEFAULT '[]'::JSONB,
    priority INTEGER DEFAULT 3 CHECK (priority >= 1 AND priority <= 5),
    is_verified BOOLEAN DEFAULT TRUE, -- FALSE for AI-added pending review
    created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE syllabus IS 'Preset syllabus with AI extension support';
COMMENT ON COLUMN syllabus.priority IS 'Importance level for exam weightage (1-5)';
COMMENT ON COLUMN syllabus.is_verified IS 'FALSE if AI added and pending human review';