-- Consolidated Migration 01: Setup and Enums
-- Includes: Extensions and Enum types

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS moddatetime;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. ENUM TYPES

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
    'solution_updated',
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

-- Notification types
CREATE TYPE notification_type AS ENUM (
    'follow', 
    'like', 
    'link', 
    'contribution'
);

COMMENT ON TYPE question_type_enum IS 'Types of questions supported';
COMMENT ON TYPE difficulty_enum IS 'Difficulty levels for questions';
COMMENT ON TYPE activity_type_enum IS 'Types of user activities tracked';
COMMENT ON TYPE target_type_enum IS 'Target entity types for activities';
COMMENT ON TYPE notification_type IS 'Types of notifications';
