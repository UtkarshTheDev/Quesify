# Embedding Migration - Production Execution Guide

## Overview

This guide provides step-by-step instructions for executing the embedding model migration from `text-embedding-004` (768-dim) to `gemini-embedding-001` (1536-dim) in production.

## Prerequisites

- [ ] Database backup created
- [ ] Application code ready (Plan 02 completed)
- [ ] `GEMINI_API_KEY` has sufficient quota
- [ ] Supabase SQL Editor access or psql CLI access
- [ ] Estimated 1-4 hours of maintenance window (for backfill)

## Files Created

```
supabase/migrations/
├── 09_embedding_schema_update.sql           # Main migration script
└── 09_embedding_schema_update_rollback.sql  # Emergency rollback
```

## Pre-Flight Checks

### 1. Database State Verification

Run these queries in Supabase SQL Editor before migration:

```sql
-- Check current question count
SELECT COUNT(*) as total_questions 
FROM questions 
WHERE deleted_at IS NULL;

-- Check questions with embeddings
SELECT COUNT(*) as questions_with_embeddings 
FROM questions 
WHERE embedding IS NOT NULL;

-- Verify current dimension
SELECT pg_typeof(embedding) as current_type 
FROM questions 
LIMIT 1;
-- Expected: vector(768)

-- Check index exists
SELECT indexname 
FROM pg_indexes 
WHERE indexname = 'idx_questions_embedding';
```

### 2. Create Backup

**Option A: Full Database Backup (Recommended)**
```bash
# Via Supabase Dashboard:
# Project Settings → Database → Backup → Create New Backup

# Or via psql:
pg_dump -h <host> -U <user> -d <database> > backup_pre_migration.sql
```

**Option B: Questions Table Only**
```bash
pg_dump -h <host> -U <user> -d <database> --table=questions > questions_backup.sql
```

## Migration Execution

### Step 1: Execute Schema Migration

**Method A: Supabase SQL Editor (Recommended for Production)**
1. Open Supabase Dashboard
2. Go to SQL Editor
3. Open `supabase/migrations/09_embedding_schema_update.sql`
4. Run the entire script
5. Verify output shows all checks passed

**Method B: psql CLI**
```bash
psql -h <host> -U <user> -d <database> -f supabase/migrations/09_embedding_schema_update.sql
```

**Expected Output:**
```
✓ Pre-migration checks passed
✓ Step 1 complete: Dropped dependent objects
✓ Step 2 complete: Altered embedding column to VECTOR(1536)
✓ Step 3 complete: Created HNSW index for VECTOR(1536)
✓ Step 4 complete: Recreated match_questions_with_solutions function
✓ Verification passed: embedding column is now VECTOR(1536)
✓ Verification passed: idx_questions_embedding index exists
✓ Verification passed: match_questions_with_solutions uses VECTOR(1536)

========================================
MIGRATION COMPLETE - SUMMARY
========================================
Total questions: <number>
Questions with embeddings: 0
Questions needing backfill: <number>

NEXT STEPS:
1. Deploy updated application code (Plan 02)
2. Run embedding backfill script (Plan 03)
3. Verify all questions have embeddings (Plan 04)
========================================
```

### Step 2: Verify Schema Changes

Run these verification queries:

```sql
-- Verify column type
SELECT pg_typeof(embedding) 
FROM questions 
LIMIT 1;
-- Expected: vector(1536)

-- Verify index
SELECT indexname, indexdef 
FROM pg_indexes 
WHERE indexname = 'idx_questions_embedding';

-- Test function signature
SELECT * 
FROM match_questions_with_solutions(
    NULL::VECTOR(1536), 
    0.5, 
    1
);
-- Should execute without errors
```

### Step 3: Deploy Application Code

Execute Plan 02 to update:
- `src/lib/ai/config.ts`
- `src/lib/ai/client.ts`
- `.env.example`

### Step 4: Run Backfill

Execute Plan 03 to regenerate all embeddings with new model:

```bash
# Set environment variables
export NEXT_PUBLIC_SUPABASE_URL=<your-supabase-url>
export SUPABASE_SERVICE_ROLE_KEY=<your-service-role-key>
export GEMINI_API_KEY=<your-gemini-key>

# Run backfill
npx tsx src/scripts/backfill-embeddings.ts
```

**Monitoring Progress:**
```bash
# In another terminal, run:
npx tsx src/scripts/backfill-progress.ts

# Check checkpoint file:
cat .backfill-checkpoint.json

# Check failed items:
cat .backfill-failed.json
```

### Step 5: Verify Migration

Execute Plan 04 to verify:
```bash
npx tsx src/scripts/verify-embeddings.ts
npx tsx src/scripts/test-similarity-search.ts
```

## Post-Migration Validation

### 1. Database Verification

```sql
-- Should show 1536 dimensions
SELECT pg_typeof(embedding) FROM questions LIMIT 1;

-- Should show all questions have embeddings
SELECT 
    COUNT(*) as total,
    COUNT(embedding) as with_embeddings,
    COUNT(*) - COUNT(embedding) as without_embeddings
FROM questions 
WHERE deleted_at IS NULL;

-- Verify a sample embedding has 1536 dimensions
SELECT array_length(embedding, 1) as dimensions
FROM questions 
WHERE embedding IS NOT NULL 
LIMIT 1;
```

### 2. Application Testing

Test these flows:
- [ ] Upload a new question (should generate 1536-dim embedding)
- [ ] Duplicate detection (similarity search should work)
- [ ] Question search (if using similarity search)

### 3. Performance Check

```sql
-- Check index usage
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
FROM pg_stat_user_indexes 
WHERE indexname = 'idx_questions_embedding';
```

## Rollback Procedure (Emergency)

**Only execute if critical issues arise!**

### 1. Stop Application

Prevent new writes to the database.

### 2. Execute Rollback Script

```bash
# Via Supabase SQL Editor:
# Open supabase/migrations/09_embedding_schema_update_rollback.sql
# Run the entire script

# Or via psql:
psql -h <host> -U <user> -d <database> -f supabase/migrations/09_embedding_schema_update_rollback.sql
```

### 3. Revert Application Code

```bash
git checkout src/lib/ai/config.ts src/lib/ai/client.ts
```

### 4. Regenerate Embeddings (if needed)

If you need to restore the old embeddings, restore from backup:
```bash
psql -h <host> -U <user> -d <database> < questions_backup.sql
```

## Troubleshooting

### Issue: Migration script fails

**Check:**
1. Verify questions table exists
2. Verify embedding column exists
3. Check if dependent objects exist

```sql
-- Check if objects exist
SELECT * FROM pg_indexes WHERE indexname = 'idx_questions_embedding';
SELECT * FROM pg_proc WHERE proname = 'match_questions_with_solutions';
```

### Issue: Backfill script fails

**Solutions:**
1. Check checkpoint file and resume: `cat .backfill-checkpoint.json`
2. Retry failed items: `npx tsx src/scripts/backfill-retry.ts`
3. Check API quota: Verify GEMINI_API_KEY has sufficient quota

### Issue: Similarity search returns no results

**Check:**
1. Verify embeddings exist: `SELECT COUNT(*) FROM questions WHERE embedding IS NOT NULL`
2. Check dimensions match: Should be 1536
3. Test function directly with sample data

## Cost Estimation

**Gemini Embedding API (1536 dimensions):**
- Cost: ~$0.15 per 1M tokens
- Average question: ~50 tokens
- **1000 questions**: ~$0.0075
- **10000 questions**: ~$0.075
- **100000 questions**: ~$0.75

**Storage:**
- 1536 dimensions = ~12KB per question
- 100K questions = ~1.2GB storage

## Success Criteria

- [ ] Database schema: VECTOR(1536) confirmed
- [ ] All questions have 1536-dimension embeddings
- [ ] HNSW index operational
- [ ] match_questions_with_solutions function working
- [ ] Duplicate detection functional
- [ ] Similarity search returning relevant results
- [ ] No performance degradation (<500ms p95)

## Contact & Support

If issues arise:
1. Check this guide's troubleshooting section
2. Review checkpoint files: `.backfill-checkpoint.json`
3. Review failed logs: `.backfill-failed.json`
4. Run verification scripts
5. Consider rollback if critical

---

**Migration Complete!** All questions now use gemini-embedding-001 at 1536 dimensions for optimal semantic search quality.
