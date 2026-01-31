# Infinite Scroll Implementation Plan

## Overview
Add infinite scroll with pagination across dashboard questions and profile pages (activity, questions, solutions).

## Requirements

### Infinite Scroll Triggers
1. **Immediate load** - Load first 20 items on page render (already exists)
2. **90% scroll trigger** - Detect when user scrolls to 90% of page height
3. **Reset scroll** - On filter change, reset to top and load fresh
4. **Touch-specific** - On mobile, use pull-to-refresh pattern + threshold-based loading

### Performance Features
- **Debounced scroll events** - Prevent excessive scroll handler calls
- **Virtualization** - Only render visible items (react-virtual or similar)
- **Memoization** - Memoize expensive computations in list items
- **Image lazy loading** - Lazy load avatars and question images
- **Request deduplication** - Prevent duplicate API calls
- **Backpressure handling** - Cancel in-flight requests on rapid scrolls
- **Intersection Observer** - Efficient scroll detection (not scroll event listeners)

### Pages to Update
1. `/dashboard/questions` - Infinite scroll for filtered question list
2. `/u/[username]` - Profile page with:
   - Activity feed infinite scroll
   - Questions tab infinite scroll  
   - Solutions tab infinite scroll

---

## Phase 1: API Layer - Cursor-Based Pagination

### Strategy: Modify Existing, Add Generic Endpoints

Instead of creating separate "infinite" endpoints, we'll:

1. **Create ONE reusable pagination API route** for each entity type
2. **Modify server components** to support cursor parameter
3. **Maintain backward compatibility** with page-based pagination

### New Reusable Endpoints

**`src/app/api/pagination/questions/route.ts`**

```typescript
GET ?user_id=xxx&subject=Physics&cursor=xxx&limit=20

Response:
{
  "data": Question[],
  "next_cursor": "uuid-of-last-item" | null,
  "has_more": boolean,
  "total_count": number  // For "Showing X of Y" display
}
```

**`src/app/api/pagination/activities/route.ts`**

```typescript
GET ?user_id=xxx&cursor=xxx&limit=20

Response:
{
  "data": ActivityItem[],
  "next_cursor": "uuid-of-last-item" | null,
  "has_more": boolean
}
```

**`src/app/api/pagination/solutions/route.ts`**

```typescript
GET ?user_id=xxx&cursor=xxx&limit=20

Response:
{
  "data": Solution[],
  "next_cursor": "uuid-of-last-item" | null,
  "has_more": boolean
}
```

### Server Component Updates

**`src/app/dashboard/questions/page.tsx`**

Current code:
```typescript
const page = Number(params.page) || 1
const limit = 20
const offset = (page - 1) * limit
// ... range query
.range(offset, offset + limit - 1)
```

Updated code:
```typescript
// Support BOTH cursor and page for backward compatibility
const cursor = params.cursor || null
const page = Number(params.page) || 1

if (cursor) {
  // Cursor-based query for infinite scroll
  const { data, error } = await supabase
    .from('user_questions')
    .select('..., question:questions!inner(...)')
    .eq('user_id', user.id)
    .order('added_at', { ascending: false })
    .lt('id', cursor)  // Cursor is the last item's ID
    .limit(limit + 1)  // Fetch one extra to check hasMore
} else if (page === 1) {
  // First page - same as before, just use .limit(20)
} else {
  // Fallback to offset-based for page param (backward compatibility)
  const offset = (page - 1) * limit
  // ...
}
```

**Benefits of this approach:**
- ✅ Single endpoint per entity type
- ✅ Backward compatible with existing page-based URLs
- ✅ Cursor-based = better performance for deep pagination
- ✅ Less code than creating "infinite" versions of everything

---

## Phase 2: React Hook - useInfiniteScroll

**`src/hooks/use-infinite-scroll.ts`**

```typescript
interface InfiniteScrollOptions {
  threshold?: number        // Default: 0.9 (90% scroll)
  debounceMs?: number       // Default: 100ms
  enabled?: boolean         // Enable/disable scrolling
  onLoadMore?: () => void   // Callback when threshold reached
}

interface InfiniteScrollReturn {
  sentinelRef: RefObject<HTMLDivElement>
  isLoading: boolean
  hasMore: boolean
  reset: () => void
}

function useInfiniteScroll(options: InfiniteScrollOptions): InfiniteScrollReturn
```

**Features:**
- Uses Intersection Observer API (not scroll events)
- Configurable threshold (0.9 = 90% scroll)
- Debounced callbacks (prevents rapid-fire requests)
- Reset function for filter changes
- Touch support for mobile

---

## Phase 3: Dashboard Questions Page

### Update `src/app/dashboard/questions/page.tsx`

**Changes:**
1. Add `useInfiniteScroll` hook
2. Maintain local state: `questions[]`, `cursor|null`, `hasMore`
3. Initial load: Fetch 20 items, store cursor
4. On scroll to 90%: Call API with cursor, append results
5. On filter change: Reset state, cursor, scroll to top
6. Add loading skeleton at bottom
7. Show "End of results" when `!hasMore`

**State Management:**
```typescript
const [questions, setQuestions] = useState<Question[]>([])
const [cursor, setCursor] = useState<string | null>(null)
const [hasMore, setHasMore] = useState(true)
const { sentinelRef, isLoading, reset } = useInfiniteScroll({
  threshold: 0.9,
  enabled: hasMore && !isInitialLoading,
  onLoadMore: loadMore
})
```

---

## Phase 4: Profile Page Components

### 4.1 PaginatedActivityFeed → InfiniteActivityFeed

**`src/components/profile/infinite-activity-feed.tsx`**

```typescript
interface InfiniteActivityFeedProps {
  userId: string
}

export function InfiniteActivityFeed({ userId }: InfiniteActivityFeedProps)
```

**Updates:**
- Add `useInfiniteScroll` hook
- API call to `/api/pagination/activities`
- Append new activities to existing list
- Track cursor for pagination

### 4.2 PaginatedQuestionList → InfiniteQuestionList

**`src/components/profile/infinite-questions.tsx`**

**Updates:**
- Add `useInfiniteScroll` hook
- API call to `/api/pagination/questions`
- Merge created + forked questions
- Track cursor separately for each source

### 4.3 PaginatedSolutionList → InfiniteSolutionList

**`src/components/profile/infinite-solutions.tsx`**

**Updates:**
- Add `useInfiniteScroll` hook
- API call to `/api/pagination/solutions`
- Append solutions to list
- Track cursor

---

## Phase 5: Update Profile Page

**`src/app/u/[username]/page.tsx`**

```typescript
// Replace:
<PaginatedActivityFeed initialItems={activityItems} userId={profile.user_id} />
<PaginatedQuestionList initialQuestions={allQuestions} userId={profile.user_id} />
<PaginatedSolutionList initialSolutions={filteredSolutions} userId={profile.user_id} currentUserId={currentUser?.id || null} />

// With:
<InfiniteActivityFeed userId={profile.user_id} />
<InfiniteQuestions userId={profile.user_id} />
<InfiniteSolutions userId={profile.user_id} currentUserId={currentUser?.id || null} />
```

**Changes:**
- Remove initial data fetching (components handle it)
- Pass only `userId` and `currentUserId`
- Components manage their own loading state

---

## Phase 6: Mobile-Specific Optimizations

### Touch Event Handlers

**For mobile, add pull-to-refresh at top:**
```typescript
const [isPulling, setIsPulling] = useState(false)
const pullProgress = useSpring(0, { stiffness: 300, damping: 30 })

function handleTouchStart(e: TouchEvent) {
  if (scrollTop > 0) return
  startY = e.touches[0].clientY
}

function handleTouchMove(e: TouchEvent) {
  if (scrollTop > 0 || !startY) return
  const delta = e.touches[0].clientY - startY
  if (delta > 60) {
    setIsPulling(true)
    pullProgress.set(Math.min((delta - 60) / 40, 1))
  }
}

function handleTouchEnd() {
  if (pullProgress.get() >= 1) {
    reset()
  }
  setIsPulling(false)
  pullProgress.set(0)
}
```

### Performance Optimizations

1. **Virtualization** - Use `react-virtual` for long lists
2. **Memoized list items** - `React.memo` on QuestionCard, ActivityItem
3. **Lazy images** - Add `loading="lazy"` to avatars
4. **Request deduplication** - Use `AbortController` for in-flight requests
5. **Backpressure** - Cancel previous request when new one starts

```typescript
// Example: Request cancellation
const abortControllerRef = useRef<AbortController | null>(null)

async function loadMore() {
  if (abortControllerRef.current) {
    abortControllerRef.current.abort()
  }
  abortControllerRef.current = new AbortController()
  
  const response = await fetch('/api/...', {
    signal: abortControllerRef.current.signal
  })
}
```

---

## Phase 7: Component Optimization

### Memoized Question Card

**`src/components/questions/question-card.tsx`**

```typescript
export const QuestionCard = React.memo(function QuestionCard({ 
  question,
  onDelete 
}: QuestionCardProps) {
  // Component code
})
```

### Lazy Loaded Avatars

```tsx
<Avatar className="h-10 w-10">
  <AvatarImage src={avatarUrl} loading="lazy" />
  <AvatarFallback>{name[0]}</AvatarFallback>
</Avatar>
```

---

## File Changes Summary

### New Files
- `.planning/INFINITE-SCROLL-PLAN.md` (this file)
- `src/app/api/pagination/questions/route.ts`
- `src/app/api/pagination/activities/route.ts`
- `src/app/api/pagination/solutions/route.ts`
- `src/hooks/use-infinite-scroll.ts`
- `src/components/profile/infinite-activity-feed.tsx`
- `src/components/profile/infinite-questions.tsx`
- `src/components/profile/infinite-solutions.tsx`

### Modified Files
- `src/app/dashboard/questions/page.tsx` - Add infinite scroll
- `src/app/u/[username]/page.tsx` - Use infinite components
- `src/components/profile/paginated-activity-feed.tsx` - Archive or refactor
- `src/components/profile/paginated-questions.tsx` - Archive or refactor
- `src/components/profile/paginated-solutions.tsx` - Archive or refactor
- `src/components/questions/question-card.tsx` - Add React.memo

### Removed Files
- Old pagination UI (Previous/Next buttons) from dashboard questions

---

## API Response Format

All pagination endpoints return:

```typescript
interface PaginationResponse<T> {
  data: T[]
  next_cursor: string | null  // ID of last item for next page
  has_more: boolean
  total_count?: number        // Optional, for displaying "Showing X of Y"
}
```

**Cursor strategy:** Use the last item's ID as cursor for efficient indexing.

---

## Estimated Effort

- Phase 1 (API): 1-2 hours
- Phase 2 (Hook): 1 hour
- Phase 3 (Dashboard): 1-2 hours
- Phase 4 (Profile Components): 2-3 hours
- Phase 5 (Profile Page): 30 min
- Phase 6 (Mobile): 1-2 hours
- Phase 7 (Optimization): 1 hour

**Total: 8-12 hours**

---

## Next Steps

1. ✅ Create branch `feature/infinite-scroll`
2. ⬜ Create pagination API endpoints (modify existing approach)
3. ⬜ Build `useInfiniteScroll` hook
4. ⬜ Update dashboard questions page
5. ⬜ Create infinite scroll profile components
6. ⬜ Update profile page to use new components
7. ⬜ Add mobile-specific optimizations
8. ⬜ Performance optimizations (memoization, virtualization)
9. ⬜ Test on mobile and desktop
10. ⬜ Merge to main

---

*Plan created: 2026-02-01*
*Updated: 2026-02-01 - Changed from creating new endpoints to modifying existing + generic pagination endpoints*
