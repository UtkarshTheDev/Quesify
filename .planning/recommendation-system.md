# Plan: Personalized Dashboard Recommendations

## Objective
Implement a recommendation system for "Suggested Users" and "Recommended Questions" on the dashboard, similar to modern social media feeds. These suggestions will be personalized based on the user's chosen subjects and activity patterns.

## Algorithm Design

### 1. Suggested Users ("People to Follow")
**Goal:** Recommend active users who share similar academic interests.

**Scoring Factors:**
1.  **Subject Overlap (High Weight):**
    *   Compare `current_user.subjects` vs `candidate.subjects`.
    *   Score = `(Intersection Count / Union Count) * 100`. (Jaccard Index)
2.  **Activity Level (Medium Weight):**
    *   Boost for `total_uploaded`: Active contributors are more valuable to follow.
    *   Boost for `streak_count`: Consistent users are good role models.
3.  **Social Graph (Future):**
    *   Currently, we don't have a deep follow graph, so we rely on shared interests.

**Filtering Rules:**
*   Exclude current user.
*   Exclude users already followed (`follows` table).
*   Minimum threshold: Candidate must have at least 1 upload or >0 streak.

**Recommendation Logic:**
`Score = (SubjectOverlap * 1.5) + (Log(TotalUploaded + 1) * 10) + (Log(Streak + 1) * 5)`

### 2. Suggested Questions ("For You")
**Goal:** Recommend relevant, high-quality questions the user hasn't solved yet.

**Scoring Factors:**
1.  **Subject Relevance (Critical):**
    *   MUST match one of `current_user.subjects`.
2.  **Popularity (High Weight):**
    *   Higher `popularity` (views/saves) implies quality.
    *   Higher `solutions` count implies solveability/engagement.
3.  **Difficulty Match (Medium Weight):**
    *   (Future enhancement) Match question difficulty to user's average success rate. For now, mixed difficulty is fine.
4.  **Recency (Low Weight):**
    *   Boost slightly for newer questions to keep feed fresh.

**Filtering Rules:**
*   Exclude questions owned by the current user.
*   Exclude questions already marked as `solved` or `failed` in `user_question_stats`.

**Recommendation Logic:**
`Score = (Popularity * 1.0) + (SolutionCount * 2.0) + (IsNew * 10)`
*Filter by User Subjects.*

## Implementation Steps

### Phase 1: Backend & API
1.  **New Service:** `src/lib/services/recommendations.ts`
    *   `getSuggestedUsers(userId, limit)`
    *   `getSuggestedQuestions(userId, limit)`
2.  **API Endpoint:** `/api/dashboard/suggestions`
    *   GET request.
    *   Returns `{ users: UserProfile[], questions: Question[] }`.
    *   **Logic:**
        *   Check `total_users > 10` and `total_questions > 20`. If not, return empty or generic "popular" lists.
        *   Run recommendation algorithms.
        *   Implement **Redis Caching** (TTL: 1 hour per user) to reduce DB load.

### Phase 2: Frontend Components
1.  **`SuggestionsSidebar` Component:**
    *   Right-side column on desktop, or a section between feed items on mobile.
2.  **`UserSuggestionCard`:**
    *   Avatar, Name, "Math & Physics" badge.
    *   "Follow" button (optimistic UI).
3.  **`QuestionSuggestionCard`:**
    *   Compact version of Question Card.
    *   Subject/Chapter badges.
    *   "Solve" action.

### Phase 3: Integration
1.  Add `SuggestionsSidebar` to `src/app/dashboard/page.tsx`.
2.  Ensure it degrades gracefully (doesn't show if no recommendations).

## Data Requirements (Thresholds)
To ensure quality suggestions:
*   **Users:** Show suggestions only if > 5 other users exist in the DB with matching subjects.
*   **Questions:** Show suggestions only if > 10 unsolved questions exist in user's subjects.

## Confirm?
Please confirm if this algorithm and plan align with your vision. I will proceed with:
1.  Creating the recommendation service.
2.  Creating the API route.
3.  Building the frontend components.
