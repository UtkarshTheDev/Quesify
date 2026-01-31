# External Integrations

**Analysis Date:** 2026-01-31

## APIs & External Services

**AI / Machine Learning:**
- Google Gemini API
  - What it's used for: Text generation, image analysis, embeddings, multi-modal tasks
  - SDK/Client: `@google/generative-ai` (version 0.24.1)
  - Auth: `GEMINI_API_KEY`
  - Implementation: `src/lib/ai/client.ts` (singleton pattern)
  - Models used: gemini-2.5-flash, gemini-embedding-001
  - Config: `src/lib/ai/config.ts`

- Groq API
  - What it's used for: Fast LLM inference with Llama models
  - SDK/Client: `groq-sdk` (version 0.37.0)
  - Auth: `GROQ_API_KEY`
  - Implementation: `src/lib/ai/client.ts` (singleton pattern)
  - Models used: llama-3.1-8b-instant, llama-3.3-70b-versatile, meta-llama/llama-4-scout-17b-16e-instruct
  - Config: `src/lib/ai/config.ts`

**AI Configuration Model Categories:**
- Vision: Image analysis (Latex extraction, OCR)
  - Provider: `AI_PROVIDER_VISION` (default: groq)
  - Model: `AI_MODEL_VISION` (default: meta-llama/llama-4-maverick-17b-128e-instruct)

- Fast: Quick validations and MCQs
  - Provider: `AI_PROVIDER_FAST` (default: groq)
  - Model: `AI_MODEL_FAST` (default: llama-3.1-8b-instant)

- Reasoning: Complex reasoning, charts, LA
  - Provider: `AI_PROVIDER_REASONING` (default: groq)
  - Model: `AI_MODEL_REASONING` (default: llama-3.3-70b-versatile)

- Updates: Feedback refinement and content tweaking
  - Provider: `AI_PROVIDER_UPDATES` (default: groq)
  - Model: `AI_MODEL_UPDATES` (default: llama-3.3-70b-versatile)

- QA: User Q&A and chat
  - Provider: `AI_PROVIDER_QA` (default: groq)
  - Model: `AI_MODEL_QA` (default: meta-llama/llama-4-scout-17b-16e-instruct)

- Embedding: Semantic search embeddings
  - Provider: gemini only
  - Model: `AI_MODEL_EMBEDDING` (default: gemini-embedding-001)

## Data Storage

**Databases:**
- Supabase PostgreSQL
  - Connection: `NEXT_PUBLIC_SUPABASE_URL`
  - Client: `@supabase/supabase-js` (JS client), `@supabase/ssr` (SSR client)
  - Schema managed via migrations: `supabase/migrations/`
  - Tables: user_profiles, questions, solutions, user_questions, user_question_stats, solution_likes, revise_later, user_activities, syllabus, follows, notifications, link_notifications
  - Features: RLS (Row Level Security), functions, triggers, indexes
  - Vector search: Gemini embeddings (768 dims) stored in `questions.embedding`

**File Storage:**
- Supabase Storage
  - Bucket: 'question-images'
  - Upload function: `src/lib/storage/upload.ts`
  - Operations: uploadQuestionImage, deleteQuestionImage
  - Public URL generation for serving images

**Caching:**
- Upstash Redis (HTTP-based)
  - Connection: `UPSTASH_REDIS_REST_URL`
  - Auth: `UPSTASH_REDIS_REST_TOKEN`
  - Client: `@upstash/redis` (version 1.36.1)
  - Implementation: `src/lib/db/redis.ts`
  - Purpose: Server-side caching for serverless/Next.js environment
  - Fallback: Gracefully degrades if credentials missing (console warning)

## Authentication & Identity

**Auth Provider:**
- Supabase Auth
  - Implementation: Managed authentication service via Supabase
  - Client: `@supabase/supabase-js` + `@supabase/ssr`
  - Browser client: `src/lib/supabase/client.ts`
  - Server client: `src/lib/supabase/server.ts`
  - Middleware: `src/lib/supabase/middleware.ts`
  - Protected routes: /dashboard, /upload, /daily, /profile
  - Public routes: /, /login, /auth/callback, /api/*
  - Features: Email/password auth, session management, cookie-based auth (SSR)
  - User onboarding flow: Username requirement enforced via middleware

**Env vars:**
- `NEXT_PUBLIC_SUPABASE_URL` - Supabase project URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` - Public anonymous key
- `SUPABASE_SERVICE_ROLE_KEY` - Service role key (admin operations)

## Monitoring & Observability

**Error Tracking:**
- None detected

**Logs:**
- Console-based logging
- AI performance logging: Time taken logs for AI operations (configurable via `AI_CONFIG.debug`)
- Log location: `src/lib/ai/client.ts`
- Only logs AI operation duration when in development mode

**Debug Mode:**
- Enabled when `NODE_ENV === "development"`
- Logs AI generation time for: Text generation, Vision analysis, Embeddings

## CI/CD & Deployment

**Hosting:**
- Next.js compatible platform (Vercel, Netlify, etc. recommended)
- Build command: `bun run build` or `npm run build`
- Start command: `bun run start` or `npm run start`

**CI Pipeline:**
- None detected

## Environment Configuration

**Required env vars:**

**Supabase:**
- `NEXT_PUBLIC_SUPABASE_URL` - Supabase project URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` - Public API key
- `SUPABASE_SERVICE_ROLE_KEY` - Service role key for admin operations

**AI Services:**
- `GEMINI_API_KEY` - Google Gemini API key
- `GROQ_API_KEY` - Groq API key

**AI Model Configuration (Optional Overrides):**
- `AI_PROVIDER_VISION` - Provider for vision tasks (default: groq)
- `AI_MODEL_VISION` - Model for vision (default: meta-llama/llama-4-maverick-17b-128e-instruct)
- `AI_PROVIDER_FAST` - Provider for fast tasks (default: groq)
- `AI_MODEL_FAST` - Model for fast (default: llama-3.1-8b-instant)
- `AI_PROVIDER_REASONING` - Provider for reasoning (default: groq)
- `AI_MODEL_REASONING` - Model for reasoning (default: llama-3.3-70b-versatile)
- `AI_PROVIDER_UPDATES` - Provider for updates (default: groq)
- `AI_MODEL_UPDATES` - Model for updates (default: llama-3.3-70b-versatile)
- `AI_PROVIDER_QA` - Provider for QA (default: groq)
- `AI_MODEL_QA` - Model for QA (default: meta-llama/llama-4-scout-17b-16e-instruct)
- `AI_MODEL_EMBEDDING` - Model for embeddings (default: gemini-embedding-001)

**Caching:**
- `UPSTASH_REDIS_REST_URL` - Upstash Redis REST URL (optional)
- `UPSTASH_REDIS_REST_TOKEN` - Upstash Redis REST token (optional)

**Secrets location:**
- `.env.local` (gitignored, local development)
- `.env.example` (template, committed to git)

## Webhooks & Callbacks

**Incoming:**
- None detected

**Outgoing:**
- None detected

**External Callbacks:**
- Supabase Auth callback: `/auth/callback` route
  - Handled by Supabase automatically
  - Middleware bypass for this path

## Third-Party Libraries

**UI Components:**
- Radix UI primitives (multiple packages) - Headless UI components
- shadcn/ui - Component library registry

**Icons:**
- Lucide React - Icon set

**Fonts:**
- Google Fonts: Geist Sans, Geist Mono, Outfit
- Local fonts: Charter (stored in `public/fonts/charter/`)

**Math & Scientific:**
- KaTeX - LaTeX rendering engine
- react-katex - React wrapper
- rehype-katex - Markdown KaTeX plugin
- remark-math - Markdown math plugin

**Data Processing:**
- date-fns - Date manipulation
- nanoid - Unique ID generation

**State Management:**
- TanStack Query - Server state management
- Zustand - Client state management

**Animations:**
- Framer Motion - Animation library

---

*Integration audit: 2026-01-31*
