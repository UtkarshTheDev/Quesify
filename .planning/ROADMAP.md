# Quesify Roadmap

## Project Vision

Build the most intelligent question bank platform for students, powered by state-of-the-art AI.

## Current Phase

### Phase 01: Embedding Model Migration 🔄

**Status:** Planning Complete | **Priority:** High | **Urgency:** Critical

Migrate from deprecated `text-embedding-004` to `gemini-embedding-001` before February 14, 2026 sunset date.

**Goal:** Upgrade embedding infrastructure for better semantic search quality and future-proofing.

**Plans:** 4 plans in 2 waves

**Wave 1 - Foundation (Parallel):**
- [ ] **01-01** - Clear Old Embeddings (keep VECTOR(768))
- [ ] **01-02** - AI Client & Configuration Updates

**Wave 2 - Data Migration:**
- [ ] **01-03** - Embeddings Backfill (all questions)
- [ ] **01-04** - Verification & Quality Testing

**Key Changes:**
- Database: `VECTOR(768)` ✓ (NO CHANGE - keep existing!)
- Model: `text-embedding-004` → `gemini-embedding-001`
- Dimension: **768** (matching database - NO SCHEMA MIGRATION!)
- Features: Task type optimization (`retrieval_document` vs `retrieval_query`)

**Next Step:** Execute `/gsd-execute-phase 01-embedding-migration`

---

## Upcoming Phases

### Phase 02: Solution Enhancement (Planned)
- Add avg_solve_time to solutions
- Improve solution ranking (likes > is_ai_best)
- Enhanced solution editing security

### Phase 03: Performance Optimization (Planned)
- Redis caching implementation
- Query optimization
- Bundle size reduction

### Phase 04: User Experience (Planned)
- Improved question upload flow
- Better mobile experience
- Enhanced search interface

---

## Completed Phases

### Phase 00: Foundation ✅
- [x] Project setup and configuration
- [x] Database schema design
- [x] Authentication system
- [x] Basic question upload
- [x] AI integration (Gemini/Groq)

---

## Phase Details

### Phase 01: Embedding Model Migration
**Directory:** `.planning/phases/01-embedding-migration/`

See `README.md` in phase directory for detailed migration plan.

**Why This Matters:**
- text-embedding-004 deprecated Feb 14, 2026
- gemini-embedding-001: state-of-the-art replacement
- Keeping 768 dimensions: NO SCHEMA CHANGES NEEDED!
- Still gets task type optimization for better search
- Much simpler migration process

**Migration Strategy (SIMPLIFIED):**
1. Clear old embeddings (simple UPDATE statement)
2. Deploy updated code (new model with 768 dimensions)
3. Backfill all questions with gemini-embedding-001
4. Verify all embeddings regenerated

**Risk Level:** Low
- NO schema changes needed
- NO breaking changes
- Database stays compatible throughout
- Downtime: None

---

## How to Navigate

1. **Planning Phase:** `/gsd-plan-phase <phase-name>`
2. **Execute Phase:** `/gsd-execute-phase <phase-number>`
3. **Check Progress:** Read `.planning/STATE.md`
4. **Phase Details:** See `.planning/phases/<phase>/README.md`

## Success Metrics

- ✅ All phases complete with passing verification
- ✅ Zero breaking changes to user experience
- ✅ Performance meets or exceeds baseline
- ✅ Code quality maintained (ESLint, TypeScript)

## Notes

- Phases are designed to be independent where possible
- Each phase has its own plans, tasks, and verification
- Rollback plans included for critical migrations
- Documentation updated throughout execution
