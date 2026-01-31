-- Migration: Initialize Required Extensions
-- Description: Install pgvector and other required extensions
-- Created: 2026-01-30

-- Enable pgvector extension for embedding similarity search
CREATE EXTENSION IF NOT EXISTS vector;

-- Enable moddatetime for automatic updated_at tracking
CREATE EXTENSION IF NOT EXISTS moddatetime;

-- Enable uuid-ossp for UUID generation (if not already enabled by Supabase)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

COMMENT ON EXTENSION vector IS 'Vector similarity search for question matching';
COMMENT ON EXTENSION moddatetime IS 'Automatic updated_at timestamp management';