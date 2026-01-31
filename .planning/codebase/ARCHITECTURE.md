# Architecture

**Analysis Date:** 2026-01-31

## Pattern Overview

**Overall:** Next.js 16 App Router with Supabase Backend + Multi-Provider AI Integration

**Key Characteristics:**
- Full-stack React with server/client component separation
- Supabase as unified backend (Postgres + Auth + Storage)
- Multi-provider AI abstraction (Gemini, Groq) with singleton client
- React Query for client-side data fetching, Zustand for state
- Type-safe data layer with comprehensive TypeScript definitions
- API routes for external operations, Server Actions for internal mutations

## Layers

**Presentation Layer (Client Components):**
- Purpose: Interactive UI, user interactions, client-side logic
- Location: `src/components/`
- Contains: Page components, feature components, UI components
- Depends on: API routes, Server Actions, React Query hooks, Supabase client
- Used by: Next.js pages and layouts

**API Layer (Server-Side):**
- Purpose: Handle HTTP requests, coordinate services, enforce security
- Location: `src/app/api/`
- Contains: Route handlers (`route.ts`) for external operations
- Depends on: Supabase server client, AI services, storage services
- Used by: Client components, external clients

**Service Layer (Business Logic):**
- Purpose: Abstract external integrations and AI operations
- Location: `src/lib/`
- Contains:
  - AI service (`src/lib/ai/`)
  - Storage service (`src/lib/storage/`)
  - Database utilities (`src/lib/db/`)
  - Supabase client helpers (`src/lib/supabase/`)
- Depends on: External APIs (Gemini, Groq), Supabase SDK
- Used by: API routes, Server Actions, Server Components

**Data Layer:**
- Purpose: Persistent storage, authentication, type definitions
- Location: Supabase (managed) + `src/lib/types/`
- Contains: Postgres database, auth system, file storage, TypeScript schemas
- Depends on: Supabase infrastructure
- Used by: All layers via Supabase clients

## Data Flow

**Question Upload Flow:**

1. User uploads image via dropzone (`src/components/upload/dropzone.tsx`)
2. Client validates image and sends to `/api/upload/extract`
3. API route calls `ai.extractQuestion()` for OCR + classification
4. AI returns structured question data with embedding
5. Data saved to Supabase via `/api/questions` (POST)
6. Storage service uploads image to Supabase Storage bucket
7. Client receives response, user can edit before final save

**Solution Generation Flow:**

1. User triggers "Ask AI" on question detail page
2. Client sends question data to `/api/upload/solve`
3. API route calls `ai.generateSolution()` with question text, type, options
4. AI service selects appropriate model based on task type (`reasoning`)
5. AI returns structured solution with approach description
6. Response displayed to user, can be saved to database

**Question Viewing Flow:**

1. Server component `src/app/question/[id]/page.tsx` loads on navigation
2. Server creates Supabase client with `createClient()` (server)
3. Queries question with related solutions and author profiles
4. Data passed as props to client components
5. Client components use React Query for any additional data fetching (e.g., user stats)

**Authentication Flow:**

1. User signs in via Supabase Auth (OAuth or email)
2. Supabase redirects to `/auth/callback` with auth code
3. Callback handler exchanges code for session
4. Creates `user_profiles` record if not exists
5. Middleware `src/lib/supabase/middleware.ts` validates session on every request
6. Protected routes redirect to `/login` if not authenticated
7. Users without username redirected to `/onboarding`

## Key Abstractions

**AI Service Abstraction:**
- Purpose: Centralized interface for all AI operations across multiple providers
- Examples: `src/lib/ai/services.ts`, `src/lib/ai/client.ts`
- Pattern: Singleton client with model type abstraction. All AI operations go through `ai.generateSolution()`, `ai.extractQuestion()`, etc. Model selection is configuration-driven via `AI_CONFIG.models[modelType]`

**Supabase Client Abstraction:**
- Purpose: Separate server and browser client creation with proper cookie handling
- Examples: `src/lib/supabase/server.ts`, `src/lib/supabase/client.ts`, `src/lib/supabase/middleware.ts`
- Pattern: Factory functions that handle cookie management for SSR. Server clients use `await cookies()` from next/headers, browser clients use standard localStorage.

**Data Type Abstraction:**
- Purpose: Single source of truth for database schema and API contracts
- Examples: `src/lib/types/database.ts`, `src/lib/types/index.ts`
- Pattern: Interface definitions that mirror Supabase tables, with join helpers like `extractQuestion()` for handling Supabase's flexible return types.

**Storage Abstraction:**
- Purpose: Encapsulate file upload/deletion operations
- Examples: `src/lib/storage/upload.ts`
- Pattern: Helper functions that abstract Supabase Storage API calls with error handling and URL generation.

## Entry Points

**Root Layout:**
- Location: `src/app/layout.tsx`
- Triggers: On application load
- Responsibilities: Sets up Providers (React Query, Toaster), configures fonts (Geist, Outfit, Charter), applies global styles

**Dashboard Page:**
- Location: `src/app/dashboard/page.tsx`
- Triggers: Navigation to `/dashboard`
- Responsibilities: Fetches user's recent questions, subject distribution, and renders AI-powered charts section. Shows welcome state if no questions.

**Upload Flow:**
- Location: `src/app/upload/page.tsx`, `src/components/upload/`
- Triggers: Navigation to `/upload`
- Responsibilities: Manages question image upload, AI extraction, preview, and final save. Coordinates multiple API calls for extraction, classification, and storage.

**Question Detail Page:**
- Location: `src/app/question/[id]/page.tsx`
- Triggers: Navigation to `/question/:id`
- Responsibilities: Server component that loads question with solutions, user stats. Delegates to client components for interactions.

**API Routes:**
- Location: `src/app/api/**/route.ts`
- Triggers: HTTP requests to `/api/*`
- Responsibilities: Handle CRUD operations for questions, solutions, user profiles, AI generation, and file operations. Always validate authentication via Supabase.

**Server Actions:**
- Location: `src/app/actions/*.ts`
- Triggers: Invoked from client components
- Responsibilities: Perform server-side mutations and paginated data fetching (e.g., `getMoreActivities`, `getMoreQuestions`, `getMoreSolutions` in `src/app/actions/profile.ts`)

## Error Handling

**Strategy:** Try-catch at API route level, return JSON error responses with appropriate status codes

**Patterns:**
- API routes wrap operations in try-catch, returning `{ error: string }` on failure
- Server actions log errors and return safe fallbacks (e.g., `{ items: [], hasMore: false }`)
- Client components use React Query's error boundary or try-catch for optimistic updates
- Toast notifications via Sonner for user-facing errors

## Cross-Cutting Concerns

**Logging:** Performance timing logs using `performance.now()` for AI operations. Error logging with `console.error`. Environment-based debug mode for AI (`AI_CONFIG.debug`).

**Validation:** Image validation via AI before extraction. Subject/chapter classification with fallback to "General". Form validation at component level.

**Authentication:** Supabase Auth with session validation in middleware. User creation on first login. Username requirement enforced via middleware redirect to onboarding.

**Authorization:** Row-level security via Supabase RLS policies (not visible in code, enforced in database). API routes check `user.id` before allowing mutations. Solution edit restriction: users can only edit solutions they created.

**Caching:** React Query with 60s stale time for queries. React Query cache for client-side data. Supabase connection pooling via `@supabase/ssr` cookie management.

---

*Architecture analysis: 2026-01-31*
