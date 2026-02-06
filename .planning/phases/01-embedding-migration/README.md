# Phase 01: Embedding Model Migration (SIMPLIFIED - 768 dims)

## Overview

**SUPER SIMPLE APPROACH**: Migrate from `text-embedding-004` to `gemini-embedding-001` while **keeping 768 dimensions**.

## Why 768 Dimensions is Better

Since your database is already configured for 768 dimensions:
- ✅ **No schema changes needed** - VECTOR(768) stays as-is
- ✅ **No index recreation** - HNSW index works as-is
- ✅ **No function updates** - match_questions_with_solutions already uses VECTOR(768)
- ✅ **Simple process** - Just clear old embeddings, regenerate with new model

## What Changes

### Before
- **Model**: text-embedding-004 (768-dim, deprecated)
- **Embeddings**: All populated
- **Database**: VECTOR(768) ✓
- **Index**: HNSW on embedding ✓
- **Function**: match_questions_with_solutions(VECTOR(768)) ✓

### After
- **Model**: gemini-embedding-001 (768-dim, state-of-the-art)
- **Embeddings**: Cleared, then regenerated with new model
- **Database**: VECTOR(768) ✓ (NO CHANGE!)
- **Index**: HNSW on embedding ✓ (NO CHANGE!)
- **Function**: match_questions_with_solutions(VECTOR(768)) ✓ (NO CHANGE!)

## Execution Plan (SIMPLIFIED)

### Wave 1 - Database Reset (5 minutes)

#### Plan 01: Clear Old Embeddings
**File:** `supabase/migrations/09_reset_embeddings_for_new_model.sql`
**Duration:** ~2 minutes
**Steps:**
1. Run SQL to set all embeddings to NULL
2. Verify all cleared

**SQL:**
```sql
UPDATE questions SET embedding = NULL WHERE embedding IS NOT NULL;
```

### Wave 2 - Code & Data (Sequential)

#### Plan 02: Update AI Client
**Files:** `src/lib/ai/config.ts`, `src/lib/ai/client.ts`
**Changes:**
1. Update model from "text-embedding-004" to "gemini-embedding-001"
2. Add `outputDimensionality: 768` to embedding request
3. Add `taskType` parameter support

#### Plan 03: Backfill Embeddings
**Files:** `src/scripts/backfill-embeddings.ts`
**Duration:** 1-4 hours (depends on question count)
**Process:**
1. Fetch questions with NULL embeddings
2. Generate with gemini-embedding-001 @ 768 dimensions
3. Update database
4. Track progress

#### Plan 04: Verify
**Files:** Verification scripts
**Checks:**
1. All questions have 768-dim embeddings
2. Similarity search works
3. No NULL embeddings remaining

## Quick Production Workflow

```bash
# Phase 1: Clear old embeddings (2 minutes)
psql -f supabase/migrations/09_reset_embeddings_for_new_model.sql

# Phase 2: Deploy updated code (10 minutes)
git push origin main

# Phase 3: Backfill (1-4 hours)
npx tsx src/scripts/backfill-embeddings.ts

# Phase 4: Verify (5 minutes)
npx tsx src/scripts/verify-embeddings.ts
```

## Why This is Simpler

### Original 1536-dim Approach:
- ❌ Alter column type: VECTOR(768) → VECTOR(1536)
- ❌ Drop and recreate HNSW index
- ❌ Update function signatures
- ❌ More complex migration
- ❌ More risk

### New 768-dim Approach:
- ✅ Keep VECTOR(768) - no schema changes
- ✅ Keep existing index - no recreation
- ✅ Keep existing function - no updates
- ✅ Simple UPDATE statement
- ✅ Lower risk

## Benefits

1. **gemini-embedding-001** is still state-of-the-art (better than text-embedding-004)
2. **taskType optimization** works at any dimension
3. **768 dimensions** is sufficient for educational content
4. **Faster migration** - no schema changes
5. **Lower risk** - simpler process

## Cost

**Gemini Embedding API @ 768 dimensions:**
- Cost: ~$0.15 per 1M tokens
- Average question: ~50 tokens
- **1000 questions**: ~$0.0075
- **10000 questions**: ~$0.075

## Next Steps

Run the simplified plan:
```bash
/gsd-execute-phase 01-embedding-migration
```

Or individual plans:
```bash
/gsd-execute-phase 01-embedding-migration plan=01  # Clear embeddings
/gsd-execute-phase 01-embedding-migration plan=02  # Update code
/gsd-execute-phase 01-embedding-migration plan=03  # Backfill
/gsd-execute-phase 01-embedding-migration plan=04  # Verify
```

## Migration Complete

When done:
- ✅ All questions use gemini-embedding-001
- ✅ 768-dimension embeddings (same size, better quality)
- ✅ Task type optimization enabled
- ✅ Future-proof (no deprecated models)
