-- =============================================================================
-- MIGRATION: Reset Embeddings for gemini-embedding-001
-- FILENAME: 09_reset_embeddings_for_new_model.sql
-- PURPOSE: Clear old embeddings to prepare for gemini-embedding-001 generation
-- MODEL: gemini-embedding-001 with 768 dimensions (same as old)
-- DATE: 2026-02-06
-- =============================================================================

/*
SIMPLE MIGRATION - NO SCHEMA CHANGES NEEDED!
================================================

Since we're keeping 768 dimensions (same as text-embedding-004):
- Database column: VECTOR(768) ✓ (no change needed)
- HNSW index: Already exists ✓ (no recreation needed)
- match_questions_with_solutions function: Already VECTOR(768) ✓ (no change needed)

This migration only:
1. Sets all existing embeddings to NULL
2. They will be regenerated with gemini-embedding-001 via backfill

STEPS:
1. Run this SQL to clear embeddings
2. Deploy updated code (uses gemini-embedding-001 with outputDimensionality: 768)
3. Run backfill script to regenerate all embeddings
4. Done!

NO DOWNTIME - Application continues working with NULL embeddings during backfill.
Similarity search returns empty results until backfill completes.
*/

-- =============================================================================
-- STEP 1: SAFETY CHECK
-- =============================================================================

DO $$
DECLARE
    v_count INTEGER;
BEGIN
    -- Check if questions table exists
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'questions') THEN
        RAISE EXCEPTION 'questions table does not exist';
    END IF;
    
    -- Check if embedding column exists
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'questions' AND column_name = 'embedding'
    ) THEN
        RAISE EXCEPTION 'embedding column does not exist';
    END IF;
    
    -- Get count of questions with embeddings
    SELECT COUNT(*) INTO v_count 
    FROM questions 
    WHERE embedding IS NOT NULL;
    
    RAISE NOTICE 'Questions with embeddings to clear: %', v_count;
END $$;

-- =============================================================================
-- STEP 2: CLEAR ALL EXISTING EMBEDDINGS
-- =============================================================================

-- This sets all embeddings to NULL
-- They will be regenerated with gemini-embedding-001
UPDATE questions 
SET embedding = NULL
WHERE embedding IS NOT NULL;

-- =============================================================================
-- STEP 3: VERIFICATION
-- =============================================================================

DO $$
DECLARE
    v_total INTEGER;
    v_with_embedding INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_total 
    FROM questions 
    WHERE deleted_at IS NULL;
    
    SELECT COUNT(*) INTO v_with_embedding 
    FROM questions 
    WHERE embedding IS NOT NULL;
    
    RAISE NOTICE '';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'EMBEDDINGS CLEARED - READY FOR BACKFILL';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Total questions: %', v_total;
    RAISE NOTICE 'Questions with embeddings: %', v_with_embedding;
    RAISE NOTICE '';
    RAISE NOTICE 'NEXT STEPS:';
    RAISE NOTICE '1. Deploy updated application code';
    RAISE NOTICE '2. Run embedding backfill script';
    RAISE NOTICE '   npx tsx src/scripts/backfill-embeddings.ts';
    RAISE NOTICE '========================================';
END $$;

-- =============================================================================
-- ROLLBACK (If you need to restore old embeddings)
-- =============================================================================
/*
If you need to rollback, restore from your backup:

-- Restore from backup file
psql -h <host> -U <user> -d <db> < questions_backup.sql

Or restore specific embeddings (if you exported them):

-- Example: Restore from a temp table
UPDATE questions q
SET embedding = backup.embedding
FROM questions_backup backup
WHERE q.id = backup.id;
*/
