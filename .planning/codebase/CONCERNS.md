# Codebase Concerns

**Analysis Date:** 2026-01-31

## Tech Debt

**Missing Test Coverage:**
- Issue: Zero application tests exist in `src/` directory
- Files: All `src/app/api/**`, `src/components/**`, `src/lib/**`
- Impact: No safety net for refactoring, regressions go undetected
- Fix approach: Add unit tests for API routes, component tests for UI, integration tests for critical flows using Bun test

**No Input Validation:**
- Issue: API routes use `await request.json()` without schema validation
- Files: `src/app/api/questions/route.ts`, `src/app/api/solutions/[id]/route.ts`, `src/app/api/upload/finalize/route.ts` (17 total routes)
- Impact: Malformed payloads can cause crashes, invalid data enters database, security vulnerabilities
- Fix approach: Add zod schemas to validate all API inputs before processing

**Debug Code in Production:**
- Issue: Debug comment and threshold change left in production code
- Files: `src/app/api/upload/finalize/route.ts:32`
- Impact: Duplicate detection uses lower threshold (0.6 instead of production value), may cause false positives
- Fix approach: Remove debug comment, restore production threshold, add environment-based configuration

**Skipped Duplicate Detection:**
- Issue: TODO comment indicates duplicate detection bypassed for new questions
- Files: `src/app/api/questions/route.ts:90`
- Impact: Duplicate questions can be created, data pollution
- Fix approach: Implement embedding-based duplicate detection before question creation

## Known Bugs

**Missing avg_solve_time on Solutions:**
- Symptoms: Some solutions may have `avg_solve_time: 0` (default)
- Files: `src/app/api/questions/route.ts:68` (new solution), `src/app/api/questions/route.ts:131` (variation solution)
- Trigger: AI generation may fail to populate `avg_solve_time` field
- Workaround: None - users cannot edit avg_solve_time
- Fix approach: Validate AI response includes avg_solve_time, require field in schema

**Streak Calculation Bug:**
- Symptoms: Streak may not reset correctly on day gaps >1
- Files: `src/app/api/questions/solve/route.ts:75-96`
- Trigger: User misses multiple days in a row
- Workaround: None visible in code
- Fix approach: Add streak reset logic that checks if last_streak_date is not yesterday (not just different date)

## Security Considerations

**Overly Permissive Storage Policies:**
- Risk: Authenticated users can delete any image in question-images bucket
- Files: `supabase/migrations/20260131_fix_storage_and_relationships.sql:43-49`
- Current mitigation: None - policy allows any authenticated user to delete
- Recommendations: Update policy to check `auth.uid()` matches image owner's user_id

**No Rate Limiting:**
- Risk: API abuse, DDoS attacks, AI API cost escalation
- Files: All API routes in `src/app/api/`
- Current mitigation: None detected
- Recommendations: Implement rate limiting using Upstash Redis (already configured in `src/lib/db/redis.ts`)

**No Payload Size Limits:**
- Risk: Memory exhaustion, large file uploads, DoS attacks
- Files: File upload routes (`src/app/api/upload/extract/route.ts`, `src/app/api/upload/finalize/route.ts`)
- Current mitigation: None visible
- Recommendations: Add max payload size middleware, validate Content-Length headers

**Missing Field Validation:**
- Risk: SQL injection through unvalidated inputs (mitigated by Supabase but still poor practice)
- Files: `src/app/api/questions/solve/route.ts:15` (questionId validation only)
- Current mitigation: Supabase RLS policies prevent unauthorized access
- Recommendations: Add comprehensive input validation using zod schemas

**Error Information Leakage:**
- Risk: Generic error messages may leak sensitive information or mask security issues
- Files: `src/app/api/solutions/[id]/route.ts:65` (returns raw error.message)
- Current mitigation: Partial - some routes return generic messages
- Recommendations: Implement error classification (validation errors vs system errors), log details server-side only

## Performance Bottlenecks

**Large Syllabus File:**
- Problem: 1278-line monolithic file loaded on every request
- Files: `src/lib/syllabus-data.ts`
- Cause: Hardcoded syllabus data embedded in TypeScript
- Improvement path: Move to database, implement caching, lazy-load by subject

**N+1 Query Pattern:**
- Problem: Fetching questions with solutions may trigger multiple queries
- Files: `src/app/api/questions/route.ts:199-226`
- Cause: Post-query filtering by subject/chapter after Supabase query
- Improvement path: Use Supabase `.filter()` in query, use Supabase joins with select syntax

**Unoptimized RLS Policies:**
- Problem: Auth.uid() called once per row in RLS policies (already partially fixed)
- Files: `supabase/migrations/00000000000006_enable_rls.sql` (some policies not optimized)
- Cause: Direct `auth.uid()` comparison in USING clauses
- Improvement path: Wrap in `(SELECT auth.uid())` pattern (migration 20260131_fix_storage_and_relationships.sql shows fix pattern)

## Fragile Areas

**Monolithic Components:**
- Files: `src/lib/syllabus-data.ts` (1278 lines), `src/components/ui/stepper.tsx` (492 lines), `src/components/questions/question-detail/question-tabs.tsx` (470 lines), `src/components/questions/solution-card.tsx` (418 lines)
- Why fragile: Large files are difficult to understand, hard to test, single change can break multiple features
- Safe modification: Extract smaller components, use composition pattern, add unit tests before refactoring
- Test coverage: None

**Complex AI Service:**
- Files: `src/lib/ai/services.ts` (305 lines), `src/lib/ai/client.ts`
- Why fragile: Multiple AI providers (Gemini, Groq), JSON parsing can fail, network dependencies
- Safe modification: Add retry logic, implement circuit breaker, add integration tests for each AI provider
- Test coverage: None

**Database Migration Complexity:**
- Files: `supabase/migrations/20260131_fix_storage_and_relationships.sql` (444 lines)
- Why fragile: Multiple schema changes in single migration, FK migrations are complex, rollback is difficult
- Safe modification: Break into smaller migrations, test migration on staging, verify data integrity after each step
- Test coverage: None

**Client-Side Auth Handling:**
- Files: `src/lib/supabase/client.ts` (browser), `src/lib/supabase/server.ts`
- Why fragile: Multiple auth entry points, no centralized error handling, tokens managed automatically by Supabase
- Safe modification: Add auth error boundary, implement token refresh monitoring, add integration tests
- Test coverage: None

## Scaling Limits

**AI API Costs:**
- Current capacity: No cost tracking visible in code
- Limit: Unbounded AI API usage could exhaust budget
- Scaling path: Implement rate limiting per user, add cost tracking, add caching for repeated queries

**Database Connection Pooling:**
- Current capacity: Unknown (managed by Supabase)
- Limit: Default connection limits may be exceeded under load
- Scaling path: Monitor connection metrics, implement connection pooling in middleware, use prepared statements

**Storage Costs:**
- Current capacity: No storage cleanup visible
- Limit: Unlimited image storage growth
- Scaling path: Implement image compression, delete orphaned images, add storage monitoring

## Dependencies at Risk

**AI Provider Lock-in:**
- Risk: Multiple providers (Gemini, Groq) but no abstraction layer for switching
- Impact: If one provider changes API, multiple files need updates
- Files: `src/lib/ai/client.ts`, `src/lib/ai/services.ts`, `src/lib/ai/config.ts`
- Migration plan: Implement provider interface pattern, add provider registry, allow runtime provider selection

**Next.js Version:**
- Risk: Using Next.js 16.1.4 (very recent, potential breaking changes)
- Impact: Framework updates may break application
- Migration plan: Pin to stable version, implement automated testing before upgrades, review release notes carefully

**React 19.2.3:**
- Risk: React 19 is very new, ecosystem may not be fully compatible
- Impact: Third-party libraries may break
- Migration plan: Test all third-party components, implement fallbacks for incompatible libraries

## Missing Critical Features

**No Monitoring/Alerting:**
- Problem: No application performance monitoring, error tracking, or uptime alerts
- Blocks: Cannot proactively detect issues, no visibility into production health
- Recommendations: Add Sentry for error tracking, add performance monitoring, set up uptime alerts

**No Backup/Restore Testing:**
- Problem: Database migrations not tested for rollback
- Blocks: Data loss risk during schema changes
- Recommendations: Test migrations on staging, implement backup verification, document rollback procedures

**No Admin Dashboard:**
- Problem: No UI for managing users, content, or reports
- Blocks: Cannot moderate content, cannot manage abusive users
- Recommendations: Build admin routes with service-role auth, implement content moderation features

**No Search Optimization:**
- Problem: Search may not handle large question bases efficiently
- Blocks: Performance degradation as question count grows
- Recommendations: Implement full-text search, add search indexing, optimize query patterns

## Test Coverage Gaps

**Untested area: All API routes**
- What's not tested: Every endpoint in `src/app/api/`
- Files: 17 API route files with 0% test coverage
- Risk: API regressions, broken integrations, security issues
- Priority: High - security and data integrity at stake

**Untested area: AI service integration**
- What's not tested: AI generation, duplicate detection, embedding generation
- Files: `src/lib/ai/services.ts`, `src/lib/ai/client.ts`, `src/lib/ai/prompts.ts`
- Risk: AI provider outages, malformed responses, cost overruns
- Priority: Medium - fallback error handling exists but untested

**Untested area: Authentication flows**
- What's not tested: User signup, login, session management, RLS policies
- Files: `src/lib/supabase/client.ts`, `src/lib/supabase/server.ts`, all API routes with auth checks
- Risk: Unauthorized access, session leaks, policy bypasses
- Priority: High - security critical

**Untested area: Database migrations**
- What's not tested: Schema changes, data migrations, RLS policy updates
- Files: All `supabase/migrations/*.sql`
- Risk: Data loss, schema corruption, migration failures in production
- Priority: Critical - data integrity at stake

**Untested area: Frontend components**
- What's not tested: All React components in `src/components/`
- Files: 100+ component files with 0% test coverage
- Risk: UI regressions, broken user flows, accessibility issues
- Priority: Medium - user experience impact

---

*Concerns audit: 2026-01-31*
