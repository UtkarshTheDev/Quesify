# Phase: API-Side Redis Caching Implementation

## Objective
Implement Redis caching across the API layer to improve response times, reduce database load, and provide better UX. Focus on frequently accessed data that doesn't change often.

## Purpose
This phase will:
1. Add cache middleware for API routes to cache frequently accessed data
2. Cache expensive database queries (pagination, question details, profile data)
3. Implement cache invalidation strategies for dynamic data
4. Monitor cache hit/miss rates
5. Provide graceful degradation when Redis is unavailable

## Output
- Cache utility module for API layer
- Updated API routes with caching
- Cache monitoring and instrumentation
- Environment configuration for cache settings

## Context

@.planning/codebase/ARCHITECTURE.md
@.planning/codebase/INTEGRATIONS.md
@src/lib/db/redis.ts
@src/lib/services/syllabus.ts

## Current State

**Existing Infrastructure:**
- Redis client already configured (`src/lib/db/redis.ts`)
- Graceful fallback when Redis credentials missing
- Syllabus service already has caching implementation
- TTL: 24 hours for syllabus data

**Identified Gaps:**
1. **No caching in pagination routes**: `/api/pagination/questions`, `/api/pagination/activities`, `/api/pagination/solutions`
2. **No caching in profile routes**: `/api/profile/route.ts`
3. **No caching in subjects API**: `/api/subjects/route.ts` (fetches from DB every time)
4. **No caching in question detail**: `/api/question/[id]/route.ts` (fetches fresh on every visit)
5. **No caching in solutions API**: `/api/solutions` routes
6. **No cache invalidation**: When data changes (e.g., new question added, solution posted), cache should invalidate

## Key Benefits

1. **Faster page loads**: Cached data serves in <10ms vs 100-500ms database queries
2. **Reduced database load**: 70-90% reduction in read queries for frequently accessed data
3. **Better scalability**: Cache is external to database, can handle more concurrent requests
4. **Cost optimization**: Fewer Supabase reads = lower database costs
5. **Graceful degradation**: If Redis fails, app still works (fetches from DB)

## Implementation Strategy

### Phase 1: Cache Utility Module (Priority: High)
Create `src/lib/cache/api-cache.ts` with:
- Generic caching functions for API routes
- Type-safe cache operations
- Cache key generation helpers
- TTL management
- Error handling with fallback to database

### Phase 2: Subjects API Caching (Priority: High)
Update `/api/subjects/route.ts`:
- Cache subjects list using existing syllabus cache
- Use existing `getSubjectsList()` (already has caching)
- Verify subjects list is served from cache

### Phase 3: Pagination Routes Caching (Priority: High)
Update pagination routes:
- `/api/pagination/questions/route.ts`
- `/api/pagination/activities/route.ts`
- `/api/pagination/solutions/route.ts`
- Strategy: Cache results for 5-10 minutes (short TTL for frequently changing data)
- Cache key pattern: `{entity}:{filters}:{userId}:{page}:{cursor}`
- Invalidation: Invalidate on any POST/PATCH/DELETE to user_questions, solutions, activities

### Phase 4: Profile Data Caching (Priority: Medium)
Update `/api/profile/route.ts`:
- Cache user profile data (TTL: 1 hour)
- Invalidation: Invalidate on profile update
- Cache public profile views (TTL: 30 minutes)

### Phase 5: Question Detail Caching (Priority: Medium)
Update `/api/question/[id]/route.ts`:
- Cache question + solutions (TTL: 10 minutes)
- Cache user stats (TTL: 5 minutes)
- Invalidation: Invalidate on solution add/like/update, question update

### Phase 6: Cache Monitoring (Priority: Low)
Add cache instrumentation:
- Log cache hits/misses in console
- Add cache hit rate to response headers
- Monitor cache effectiveness

## Must-Haves

### Observable Truths
1. User can view dashboard with cached data loading faster
2. Pagination requests return data significantly faster when cached
3. Subjects list loads from cache after first request
4. Profile data loads quickly from cache
5. Application works correctly when Redis is unavailable
6. Cache invalidates correctly when data changes

### Required Artifacts
- `src/lib/cache/api-cache.ts` - Cache utility module
- `src/app/api/subjects/route.ts` - Updated with cache-first approach
- `src/app/api/pagination/questions/route.ts` - Cached pagination
- `src/app/api/pagination/activities/route.ts` - Cached activities pagination
- `src/app/api/pagination/solutions/route.ts` - Cached solutions pagination
- `src/app/api/profile/route.ts` - Cached profile data

### Required Wiring
- API routes import cache utility from `@/lib/cache/api-cache`
- Cache uses existing redis client from `@/lib/db/redis`
- Cache invalidation triggers on data mutations
- Error handling with try-catch for cache operations
- Cache headers in API responses (optional for monitoring)

### Key Links
- `src/lib/cache/api-cache.ts` → `src/lib/db/redis.ts` via redis import
- API routes → `src/lib/cache/api-cache.ts` for caching functions
- Cache keys → Follow consistent naming pattern `{resource}:{identifier}`
- Cache invalidation → Hook into existing mutation endpoints

## Constraints & Considerations

1. **Cache TTL Strategy**:
   - Static data (syllabus, subjects): 24 hours
   - User data (profile): 1 hour
   - Dynamic data (questions, activities): 5-10 minutes
   - Real-time data (user stats): 5 minutes

2. **Cache Invalidation**:
   - Simple approach: Invalidate by key prefix on mutation
   - Example: Adding a solution invalidates all `solution:*` and `question:*` caches
   - Trade-off: Slightly over-invalidation vs complex invalidation logic

3. **Graceful Degradation**:
   - Cache operations wrapped in try-catch
   - On Redis error: Log warning and skip caching
   - Return data from database as fallback
   - Never fail request due to cache error

4. **Performance Budget**:
   - Cache operation: <5ms (expected)
   - Database query fallback: 100-500ms
   - Total overhead: Acceptable if cache hits > 50%

5. **Memory Considerations**:
   - Redis memory is limited in Upstash free tier
   - Monitor cache size and set appropriate TTLs
   - Use compression for large values if needed

## Testing Strategy

### Cache Hit Tests
1. Request same data twice → First hit DB, second hit cache
2. Verify cached data matches database
3. Check response time improvement
4. Verify cache headers are set

### Cache Invalidation Tests
1. Create question → Invalidate user_questions cache
2. Add solution → Invalidate question cache
3. Update profile → Invalidate profile cache
4. Verify cache invalidates on POST/PATCH/DELETE

### Degradation Tests
1. Disable Redis credentials → App should work (DB fallback)
2. Test with invalid Redis URL → App should work
3. Verify console warnings appear
4. Confirm no crashes or errors

## Success Criteria

### Performance Metrics
- Cache hit rate > 70% for frequently accessed data
- Average response time < 50ms for cached data
- P95 response time < 100ms for cached data
- Zero failed requests due to cache errors

### Functional Requirements
- All pagination routes use caching
- Subjects API uses cached data
- Profile data is cached
- Application degrades gracefully without Redis
- Cache invalidates correctly on data mutations
- Console logs cache hits/misses for monitoring

### Code Quality
- TypeScript types for cache operations
- Consistent error handling across all cached routes
- No code duplication (use shared cache utility)
- Follows existing codebase conventions
- Documentation in comments for cache strategies

## Implementation Notes

1. **Reuse Existing Infrastructure**:
   - Use `src/lib/db/redis.ts` redis client
   - Leverage existing `getSubjectsList()` pattern from syllabus service
   - Follow TTL patterns already established (24 hours for static data)

2. **Cache Key Patterns**:
   - Static data: `{resource}` (e.g., `syllabus:all`, `subjects:list`)
   - User-specific: `{resource}:{userId}` (e.g., `profile:${userId}`)
   - Paginated: `{resource}:{userId}:{filters}:{page}:{cursor}` (e.g., `questions:${userId}:subject:Physics:5:cursor:abc123`)
   - Entity-specific: `{resource}:{entityId}` (e.g., `question:${questionId}`, `solution:${solutionId}`)

3. **Invalidation Strategy**:
   - Simple pattern: Invalidate by prefix on write operations
   - POST/PATCH/DELETE to user_questions, solutions, activities → Invalidate relevant caches
   - This is simpler than tracking exact dependencies and over-invalidates less

4. **Monitoring Approach**:
   - Log cache hits with `[Cache HIT]` prefix
   - Log cache misses with `[Cache MISS]` prefix
   - Add response header `X-Cache: HIT/MISS` (optional, for debugging)
   - This helps measure effectiveness without external tools

## Dependencies

### Internal
- `src/lib/db/redis.ts` - Redis client (already exists)
- `src/lib/services/syllabus.ts` - Syllabus cache patterns (already exists)
- Cache utility module to be created

### External
- Upstash Redis - Already configured
- No new external services required

### Blocking Dependencies
- None - All dependencies already in project

## Rollback Plan

If caching causes issues:
1. Remove caching wrapper from API routes
2. Routes fall back to direct database queries (existing behavior)
3. Keep Redis configuration but set TTL to 0 (immediate expiration)
4. No database migrations needed (cache is ephemeral)
