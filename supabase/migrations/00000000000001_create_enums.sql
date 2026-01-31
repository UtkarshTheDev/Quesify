-- Migration: Create ENUM Types
-- Description: Define all enumerated types for the application
-- Created: 2026-01-30

-- Question types: MCQ, Very Short Answer, Short Answer, Long Answer, Case Study
CREATE TYPE question_type_enum AS ENUM (
    'MCQ',
    'VSA',
    'SA',
    'LA',
    'CASE_STUDY'
);

-- Difficulty levels
CREATE TYPE difficulty_enum AS ENUM (
    'easy',
    'medium',
    'hard',
    'very_hard'
);

-- Activity types for user activity feed
CREATE TYPE activity_type_enum AS ENUM (
    'question_created',
    'solution_contributed',
    'question_solved',
    'question_forked',
    'hint_updated',
    'question_deleted',
    'solution_deleted'
);

-- Target types for activities
CREATE TYPE target_type_enum AS ENUM (
    'question',
    'solution'
);

COMMENT ON TYPE question_type_enum IS 'Types of questions supported';
COMMENT ON TYPE difficulty_enum IS 'Difficulty levels for questions';
COMMENT ON TYPE activity_type_enum IS 'Types of user activities tracked';
COMMENT ON TYPE target_type_enum IS 'Target entity types for activities';