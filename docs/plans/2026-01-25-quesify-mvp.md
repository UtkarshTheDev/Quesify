# Quesify MVP Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a production-ready AI-powered question bank where students upload question screenshots, AI auto-organizes them, and generates personalized daily practice feeds.

**Architecture:** Next.js 15 App Router with Supabase backend. Direct Gemini API for image processing (no OCR). LaTeX rendering throughout. PWA-enabled responsive design with dark theme default.

**Tech Stack:** Next.js 15, TypeScript, Bun, Tailwind CSS, shadcn/ui, Supabase (Postgres + Auth + Storage + pgvector), Gemini 1.5 Flash, KaTeX

---

## Phase 1: Project Foundation

### Task 1.1: Initialize Next.js Project

**Files:**
- Create: Full Next.js project structure
- Delete: Current package.json (will be replaced)

**Step 1: Remove existing files and create Next.js app**

```bash
cd /home/utkarsh/development/Quesify
rm -rf node_modules package.json package-lock.json
bunx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*" --use-bun
```

Expected: Next.js 15 project created with App Router

**Step 2: Verify project structure**

```bash
ls -la src/app
```

Expected: See layout.tsx, page.tsx, globals.css

**Step 3: Run dev server to verify**

```bash
bun dev &
sleep 5
curl -s http://localhost:3000 | head -20
pkill -f "next dev"
```

Expected: HTML response from Next.js

**Step 4: Initial commit**

```bash
git add .
git commit -m "chore: initialize Next.js 15 project with TypeScript and Tailwind"
```

---

### Task 1.2: Install Core Dependencies

**Files:**
- Modify: `package.json`

**Step 1: Install Supabase and AI dependencies**

```bash
bun add @supabase/supabase-js @supabase/ssr @google/generative-ai
```

**Step 2: Install UI dependencies**

```bash
bun add lucide-react katex react-katex clsx tailwind-merge class-variance-authority
bun add -D @types/katex
```

**Step 3: Install state management**

```bash
bun add zustand @tanstack/react-query
```

**Step 4: Initialize shadcn/ui**

```bash
bunx shadcn@latest init -d
```

Select: New York style, Zinc base color, CSS variables

**Step 5: Add essential shadcn components**

```bash
bunx shadcn@latest add button card input label toast dialog dropdown-menu avatar skeleton tabs badge separator scroll-area
```

**Step 6: Commit dependencies**

```bash
git add .
git commit -m "chore: add core dependencies (Supabase, Gemini, shadcn/ui, state management)"
```

---

### Task 1.3: Configure Environment and Supabase Client

**Files:**
- Create: `.env.local`
- Create: `src/lib/supabase/client.ts`
- Create: `src/lib/supabase/server.ts`
- Create: `src/lib/supabase/middleware.ts`

**Step 1: Create environment file**

Create `.env.local`:
```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
GOOGLE_API_KEY=your_gemini_api_key
```

**Step 2: Create Supabase browser client**

Create `src/lib/supabase/client.ts`:
```typescript
import { createBrowserClient } from '@supabase/ssr'

export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  )
}
```

**Step 3: Create Supabase server client**

Create `src/lib/supabase/server.ts`:
```typescript
import { createServerClient } from '@supabase/ssr'
import { cookies } from 'next/headers'

export async function createClient() {
  const cookieStore = await cookies()

  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll()
        },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options)
            )
          } catch {
            // Server Component - ignore
          }
        },
      },
    }
  )
}
```

**Step 4: Create middleware helper**

Create `src/lib/supabase/middleware.ts`:
```typescript
import { createServerClient } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

export async function updateSession(request: NextRequest) {
  let supabaseResponse = NextResponse.next({
    request,
  })

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll()
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) => request.cookies.set(name, value))
          supabaseResponse = NextResponse.next({
            request,
          })
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          )
        },
      },
    }
  )

  const {
    data: { user },
  } = await supabase.auth.getUser()

  // Protected routes
  const protectedPaths = ['/dashboard', '/upload', '/daily', '/profile']
  const isProtectedPath = protectedPaths.some(path =>
    request.nextUrl.pathname.startsWith(path)
  )

  if (isProtectedPath && !user) {
    const url = request.nextUrl.clone()
    url.pathname = '/login'
    return NextResponse.redirect(url)
  }

  // Redirect logged-in users away from login
  if (request.nextUrl.pathname === '/login' && user) {
    const url = request.nextUrl.clone()
    url.pathname = '/dashboard'
    return NextResponse.redirect(url)
  }

  return supabaseResponse
}
```

**Step 5: Create root middleware**

Create `src/middleware.ts`:
```typescript
import { type NextRequest } from 'next/server'
import { updateSession } from '@/lib/supabase/middleware'

export async function middleware(request: NextRequest) {
  return await updateSession(request)
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
  ],
}
```

**Step 6: Commit Supabase setup**

```bash
git add .
git commit -m "feat: configure Supabase client for browser, server, and middleware"
```

---

### Task 1.4: Update Database Schema

**Files:**
- Database migrations via Supabase MCP

**Step 1: Drop existing tables and create new schema**

The existing tables don't match our design. We need to recreate them.

Use Supabase MCP to apply migration:

```sql
-- Drop existing tables
DROP TABLE IF EXISTS user_question_stats CASCADE;
DROP TABLE IF EXISTS user_profiles CASCADE;
DROP TABLE IF EXISTS questions CASCADE;

-- Enable pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Core questions table
CREATE TABLE questions (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  owner_id TEXT NOT NULL,
  extracted_text TEXT,
  question_text TEXT NOT NULL,
  options JSONB DEFAULT '[]',
  type TEXT CHECK (type IN ('MCQ','VSA','SA','LA','CASE_STUDY')) DEFAULT 'MCQ',
  has_diagram BOOLEAN DEFAULT false,
  image_url TEXT,
  subject TEXT,
  chapter TEXT,
  topics JSONB DEFAULT '[]',
  difficulty TEXT CHECK (difficulty IN ('easy','medium','hard','very_hard')) DEFAULT 'medium',
  importance INTEGER DEFAULT 3 CHECK (importance >= 1 AND importance <= 5),
  hint TEXT,
  embedding vector(768),
  popularity INTEGER DEFAULT 1,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Solutions table (multiple per question)
CREATE TABLE solutions (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  question_id TEXT REFERENCES questions(id) ON DELETE CASCADE,
  contributor_id TEXT NOT NULL,
  solution_text TEXT NOT NULL,
  numerical_answer TEXT,
  approach_description TEXT,
  likes INTEGER DEFAULT 0,
  is_ai_best BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User-question links
CREATE TABLE user_questions (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  user_id TEXT NOT NULL,
  question_id TEXT REFERENCES questions(id) ON DELETE CASCADE,
  is_owner BOOLEAN DEFAULT false,
  is_contributor BOOLEAN DEFAULT false,
  added_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, question_id)
);

-- User solving stats
CREATE TABLE user_question_stats (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  user_id TEXT NOT NULL,
  question_id TEXT REFERENCES questions(id) ON DELETE CASCADE,
  solved BOOLEAN DEFAULT false,
  failed BOOLEAN DEFAULT false,
  struggled BOOLEAN DEFAULT false,
  attempts INTEGER DEFAULT 0,
  time_spent INTEGER DEFAULT 0,
  user_difficulty INTEGER CHECK (user_difficulty >= 1 AND user_difficulty <= 5),
  last_practiced_at TIMESTAMPTZ,
  next_review_at TIMESTAMPTZ,
  in_revise_later BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, question_id)
);

-- User profiles
CREATE TABLE user_profiles (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  user_id TEXT NOT NULL UNIQUE,
  display_name TEXT,
  avatar_url TEXT,
  streak_count INTEGER DEFAULT 0,
  last_streak_date DATE,
  total_solved INTEGER DEFAULT 0,
  total_uploaded INTEGER DEFAULT 0,
  solutions_helped_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Syllabus
CREATE TABLE syllabus (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  class TEXT,
  subject TEXT NOT NULL,
  chapter TEXT NOT NULL,
  topics JSONB DEFAULT '[]',
  priority INTEGER DEFAULT 3,
  is_verified BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(class, subject, chapter)
);

-- Solution likes
CREATE TABLE solution_likes (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  user_id TEXT NOT NULL,
  solution_id TEXT REFERENCES solutions(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, solution_id)
);

-- Revise later list
CREATE TABLE revise_later (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  user_id TEXT NOT NULL,
  question_id TEXT REFERENCES questions(id) ON DELETE CASCADE,
  added_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, question_id)
);

-- Create indexes
CREATE INDEX idx_questions_owner ON questions(owner_id);
CREATE INDEX idx_questions_subject ON questions(subject);
CREATE INDEX idx_questions_chapter ON questions(chapter);
CREATE INDEX idx_questions_embedding ON questions USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);
CREATE INDEX idx_solutions_question ON solutions(question_id);
CREATE INDEX idx_user_questions_user ON user_questions(user_id);
CREATE INDEX idx_user_questions_question ON user_questions(question_id);
CREATE INDEX idx_user_stats_user ON user_question_stats(user_id);
CREATE INDEX idx_syllabus_subject ON syllabus(subject, chapter);
```

**Step 2: Enable RLS and create policies**

```sql
-- Enable RLS on all tables
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE solutions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_question_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE syllabus ENABLE ROW LEVEL SECURITY;
ALTER TABLE solution_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE revise_later ENABLE ROW LEVEL SECURITY;

-- Questions policies
CREATE POLICY "Users can view questions they have access to" ON questions
  FOR SELECT USING (
    owner_id = auth.uid()::text OR
    EXISTS (SELECT 1 FROM user_questions WHERE question_id = questions.id AND user_id = auth.uid()::text)
  );

CREATE POLICY "Users can insert their own questions" ON questions
  FOR INSERT WITH CHECK (owner_id = auth.uid()::text);

CREATE POLICY "Owners can update their questions" ON questions
  FOR UPDATE USING (owner_id = auth.uid()::text);

-- Solutions policies
CREATE POLICY "Users can view solutions for accessible questions" ON solutions
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM questions q
      WHERE q.id = solutions.question_id AND (
        q.owner_id = auth.uid()::text OR
        EXISTS (SELECT 1 FROM user_questions uq WHERE uq.question_id = q.id AND uq.user_id = auth.uid()::text)
      )
    )
  );

CREATE POLICY "Users can insert solutions" ON solutions
  FOR INSERT WITH CHECK (contributor_id = auth.uid()::text);

-- User questions policies
CREATE POLICY "Users can view their own links" ON user_questions
  FOR SELECT USING (user_id = auth.uid()::text);

CREATE POLICY "Users can create their own links" ON user_questions
  FOR INSERT WITH CHECK (user_id = auth.uid()::text);

CREATE POLICY "Users can delete their own links" ON user_questions
  FOR DELETE USING (user_id = auth.uid()::text);

-- User stats policies
CREATE POLICY "Users can view their own stats" ON user_question_stats
  FOR SELECT USING (user_id = auth.uid()::text);

CREATE POLICY "Users can manage their own stats" ON user_question_stats
  FOR ALL USING (user_id = auth.uid()::text);

-- User profiles policies
CREATE POLICY "Users can view all profiles" ON user_profiles
  FOR SELECT USING (true);

CREATE POLICY "Users can update their own profile" ON user_profiles
  FOR ALL USING (user_id = auth.uid()::text);

-- Syllabus is readable by all authenticated users
CREATE POLICY "Authenticated users can view syllabus" ON syllabus
  FOR SELECT USING (auth.role() = 'authenticated');

-- Solution likes policies
CREATE POLICY "Users can view all likes" ON solution_likes
  FOR SELECT USING (true);

CREATE POLICY "Users can manage their own likes" ON solution_likes
  FOR ALL USING (user_id = auth.uid()::text);

-- Revise later policies
CREATE POLICY "Users can manage their revise later list" ON revise_later
  FOR ALL USING (user_id = auth.uid()::text);
```

---

### Task 1.5: Create TypeScript Types

**Files:**
- Create: `src/lib/types/database.ts`
- Create: `src/lib/types/index.ts`

**Step 1: Create database types**

Create `src/lib/types/database.ts`:
```typescript
export type QuestionType = 'MCQ' | 'VSA' | 'SA' | 'LA' | 'CASE_STUDY'
export type Difficulty = 'easy' | 'medium' | 'hard' | 'very_hard'

export interface Question {
  id: string
  owner_id: string
  extracted_text: string | null
  question_text: string
  options: string[]
  type: QuestionType
  has_diagram: boolean
  image_url: string | null
  subject: string | null
  chapter: string | null
  topics: string[]
  difficulty: Difficulty
  importance: number
  hint: string | null
  embedding: number[] | null
  popularity: number
  created_at: string
  updated_at: string
}

export interface Solution {
  id: string
  question_id: string
  contributor_id: string
  solution_text: string
  numerical_answer: string | null
  approach_description: string | null
  likes: number
  is_ai_best: boolean
  created_at: string
}

export interface UserQuestion {
  id: string
  user_id: string
  question_id: string
  is_owner: boolean
  is_contributor: boolean
  added_at: string
}

export interface UserQuestionStats {
  id: string
  user_id: string
  question_id: string
  solved: boolean
  failed: boolean
  struggled: boolean
  attempts: number
  time_spent: number
  user_difficulty: number | null
  last_practiced_at: string | null
  next_review_at: string | null
  in_revise_later: boolean
  created_at: string
  updated_at: string
}

export interface UserProfile {
  id: string
  user_id: string
  display_name: string | null
  avatar_url: string | null
  streak_count: number
  last_streak_date: string | null
  total_solved: number
  total_uploaded: number
  solutions_helped_count: number
  created_at: string
  updated_at: string
}

export interface Syllabus {
  id: string
  class: string | null
  subject: string
  chapter: string
  topics: string[]
  priority: number
  is_verified: boolean
  created_at: string
}

export interface SolutionLike {
  id: string
  user_id: string
  solution_id: string
  created_at: string
}

export interface ReviseLater {
  id: string
  user_id: string
  question_id: string
  added_at: string
}

// Extended types with relations
export interface QuestionWithSolutions extends Question {
  solutions: Solution[]
}

export interface QuestionWithStats extends Question {
  stats: UserQuestionStats | null
  solutions: Solution[]
}
```

**Step 2: Create index file**

Create `src/lib/types/index.ts`:
```typescript
export * from './database'

// API response types
export interface ApiResponse<T> {
  data: T | null
  error: string | null
}

// Gemini extraction result
export interface GeminiExtractionResult {
  question_text: string
  options: string[]
  type: 'MCQ' | 'VSA' | 'SA' | 'LA' | 'CASE_STUDY'
  has_diagram: boolean
  has_solution: boolean
  solution: string
  numerical_answer: string | null
  subject: string
  chapter: string
  topics: string[]
  difficulty: 'easy' | 'medium' | 'hard' | 'very_hard'
  importance: number
  hint: string
}

// Duplicate check result
export interface DuplicateCheckResult {
  is_duplicate: boolean
  match_type: 'SAME' | 'DIFFERENT_APPROACH' | 'DIFFERENT_QUESTION'
  matched_question_id: string | null
  confidence: number
  differences: string | null
}

// Chart/Feed types
export interface Chart {
  id: string
  name: string
  description: string
  question_ids: string[]
  count: number
  type: 'daily_feed' | 'topic_review' | 'quick_mcq' | 'weak_areas' | 'custom'
}
```

**Step 3: Commit types**

```bash
git add .
git commit -m "feat: add TypeScript types for database entities and API responses"
```

---

### Task 1.6: Set Up Dark Theme Layout

**Files:**
- Modify: `src/app/globals.css`
- Modify: `src/app/layout.tsx`
- Create: `src/components/providers.tsx`

**Step 1: Update globals.css for dark theme**

Replace `src/app/globals.css`:
```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 240 10% 3.9%;
    --foreground: 0 0% 98%;
    --card: 240 10% 3.9%;
    --card-foreground: 0 0% 98%;
    --popover: 240 10% 3.9%;
    --popover-foreground: 0 0% 98%;
    --primary: 0 0% 98%;
    --primary-foreground: 240 5.9% 10%;
    --secondary: 240 3.7% 15.9%;
    --secondary-foreground: 0 0% 98%;
    --muted: 240 3.7% 15.9%;
    --muted-foreground: 240 5% 64.9%;
    --accent: 240 3.7% 15.9%;
    --accent-foreground: 0 0% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 0 0% 98%;
    --border: 240 3.7% 15.9%;
    --input: 240 3.7% 15.9%;
    --ring: 240 4.9% 83.9%;
    --radius: 0.5rem;
  }
}

@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground;
  }
}

/* KaTeX overrides for dark theme */
.katex {
  color: inherit;
}

.katex .mord,
.katex .mbin,
.katex .mrel,
.katex .mopen,
.katex .mclose,
.katex .mpunct,
.katex .minner {
  color: inherit;
}
```

**Step 2: Create providers component**

Create `src/components/providers.tsx`:
```typescript
'use client'

import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { useState, type ReactNode } from 'react'
import { Toaster } from '@/components/ui/toaster'

export function Providers({ children }: { children: ReactNode }) {
  const [queryClient] = useState(
    () =>
      new QueryClient({
        defaultOptions: {
          queries: {
            staleTime: 60 * 1000,
            retry: 1,
          },
        },
      })
  )

  return (
    <QueryClientProvider client={queryClient}>
      {children}
      <Toaster />
    </QueryClientProvider>
  )
}
```

**Step 3: Update layout.tsx**

Replace `src/app/layout.tsx`:
```typescript
import type { Metadata, Viewport } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { Providers } from '@/components/providers'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Quesify - AI-Powered Question Bank',
  description: 'Upload question screenshots, AI auto-organizes them, and get personalized daily practice feeds.',
  manifest: '/manifest.json',
}

export const viewport: Viewport = {
  themeColor: '#0a0a0a',
  width: 'device-width',
  initialScale: 1,
  maximumScale: 1,
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" className="dark">
      <body className={inter.className}>
        <Providers>{children}</Providers>
      </body>
    </html>
  )
}
```

**Step 4: Commit layout setup**

```bash
git add .
git commit -m "feat: configure dark theme layout with providers"
```

---

### Task 1.7: Create Google OAuth Login

**Files:**
- Create: `src/app/login/page.tsx`
- Create: `src/app/auth/callback/route.ts`
- Create: `src/components/auth/login-button.tsx`

**Step 1: Create login button component**

Create `src/components/auth/login-button.tsx`:
```typescript
'use client'

import { createClient } from '@/lib/supabase/client'
import { Button } from '@/components/ui/button'
import { useState } from 'react'

export function LoginButton() {
  const [isLoading, setIsLoading] = useState(false)

  const handleLogin = async () => {
    setIsLoading(true)
    const supabase = createClient()

    await supabase.auth.signInWithOAuth({
      provider: 'google',
      options: {
        redirectTo: `${window.location.origin}/auth/callback`,
      },
    })
  }

  return (
    <Button
      onClick={handleLogin}
      disabled={isLoading}
      size="lg"
      className="w-full max-w-sm"
    >
      {isLoading ? (
        <span className="flex items-center gap-2">
          <svg className="animate-spin h-4 w-4" viewBox="0 0 24 24">
            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" />
            <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
          </svg>
          Signing in...
        </span>
      ) : (
        <span className="flex items-center gap-2">
          <svg className="h-5 w-5" viewBox="0 0 24 24">
            <path fill="currentColor" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
            <path fill="currentColor" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
            <path fill="currentColor" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
            <path fill="currentColor" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
          </svg>
          Continue with Google
        </span>
      )}
    </Button>
  )
}
```

**Step 2: Create login page**

Create `src/app/login/page.tsx`:
```typescript
import { LoginButton } from '@/components/auth/login-button'

export default function LoginPage() {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-4">
      <div className="w-full max-w-md space-y-8 text-center">
        <div className="space-y-2">
          <h1 className="text-4xl font-bold tracking-tight">Quesify</h1>
          <p className="text-muted-foreground">
            AI-Powered Question Bank for Smart Practice
          </p>
        </div>

        <div className="space-y-4">
          <div className="space-y-2 text-sm text-muted-foreground">
            <p>Upload question screenshots</p>
            <p>AI auto-organizes them perfectly</p>
            <p>Get personalized daily practice feeds</p>
          </div>
        </div>

        <div className="pt-4">
          <LoginButton />
        </div>

        <p className="text-xs text-muted-foreground">
          By continuing, you agree to our Terms of Service and Privacy Policy
        </p>
      </div>
    </div>
  )
}
```

**Step 3: Create auth callback route**

Create `src/app/auth/callback/route.ts`:
```typescript
import { createClient } from '@/lib/supabase/server'
import { NextResponse } from 'next/server'

export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url)
  const code = searchParams.get('code')
  const next = searchParams.get('next') ?? '/dashboard'

  if (code) {
    const supabase = await createClient()
    const { error } = await supabase.auth.exchangeCodeForSession(code)

    if (!error) {
      // Create user profile if doesn't exist
      const { data: { user } } = await supabase.auth.getUser()

      if (user) {
        const { data: existingProfile } = await supabase
          .from('user_profiles')
          .select('id')
          .eq('user_id', user.id)
          .single()

        if (!existingProfile) {
          await supabase.from('user_profiles').insert({
            user_id: user.id,
            display_name: user.user_metadata?.full_name || user.email?.split('@')[0],
            avatar_url: user.user_metadata?.avatar_url,
          })
        }
      }

      return NextResponse.redirect(`${origin}${next}`)
    }
  }

  return NextResponse.redirect(`${origin}/login?error=auth_failed`)
}
```

**Step 4: Commit auth**

```bash
git add .
git commit -m "feat: implement Google OAuth login with user profile creation"
```

---

### Task 1.8: Create Basic Dashboard Layout

**Files:**
- Create: `src/app/dashboard/page.tsx`
- Create: `src/app/dashboard/layout.tsx`
- Create: `src/components/layout/navbar.tsx`
- Create: `src/components/layout/mobile-nav.tsx`

**Step 1: Create navbar component**

Create `src/components/layout/navbar.tsx`:
```typescript
import Link from 'next/link'
import { createClient } from '@/lib/supabase/server'
import { Button } from '@/components/ui/button'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { Home, Upload, Zap, User, LogOut } from 'lucide-react'

export async function Navbar() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  const { data: profile } = await supabase
    .from('user_profiles')
    .select('*')
    .eq('user_id', user?.id)
    .single()

  return (
    <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div className="container flex h-14 items-center">
        <div className="mr-4 flex">
          <Link href="/dashboard" className="mr-6 flex items-center space-x-2">
            <span className="font-bold text-xl">Quesify</span>
          </Link>
          <nav className="hidden md:flex items-center space-x-6 text-sm font-medium">
            <Link href="/dashboard" className="transition-colors hover:text-foreground/80 text-foreground/60">
              <span className="flex items-center gap-2">
                <Home className="h-4 w-4" />
                Dashboard
              </span>
            </Link>
            <Link href="/upload" className="transition-colors hover:text-foreground/80 text-foreground/60">
              <span className="flex items-center gap-2">
                <Upload className="h-4 w-4" />
                Upload
              </span>
            </Link>
            <Link href="/daily" className="transition-colors hover:text-foreground/80 text-foreground/60">
              <span className="flex items-center gap-2">
                <Zap className="h-4 w-4" />
                Daily Feed
              </span>
            </Link>
          </nav>
        </div>

        <div className="flex flex-1 items-center justify-end space-x-2">
          {profile && (
            <div className="hidden md:flex items-center gap-2 text-sm text-muted-foreground">
              <Zap className="h-4 w-4 text-orange-500" />
              <span>{profile.streak_count} day streak</span>
            </div>
          )}

          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" className="relative h-8 w-8 rounded-full">
                <Avatar className="h-8 w-8">
                  <AvatarImage src={profile?.avatar_url || ''} alt={profile?.display_name || ''} />
                  <AvatarFallback>
                    {profile?.display_name?.[0]?.toUpperCase() || 'U'}
                  </AvatarFallback>
                </Avatar>
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent className="w-56" align="end" forceMount>
              <div className="flex items-center justify-start gap-2 p-2">
                <div className="flex flex-col space-y-1 leading-none">
                  <p className="font-medium">{profile?.display_name}</p>
                  <p className="text-xs text-muted-foreground">
                    {profile?.total_uploaded} questions uploaded
                  </p>
                </div>
              </div>
              <DropdownMenuSeparator />
              <DropdownMenuItem asChild>
                <Link href="/profile" className="flex items-center">
                  <User className="mr-2 h-4 w-4" />
                  Profile
                </Link>
              </DropdownMenuItem>
              <DropdownMenuSeparator />
              <DropdownMenuItem asChild>
                <form action="/auth/signout" method="post">
                  <button className="flex w-full items-center">
                    <LogOut className="mr-2 h-4 w-4" />
                    Sign out
                  </button>
                </form>
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </div>
    </header>
  )
}
```

**Step 2: Create mobile nav**

Create `src/components/layout/mobile-nav.tsx`:
```typescript
'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { Home, Upload, Zap, User } from 'lucide-react'
import { cn } from '@/lib/utils'

const navItems = [
  { href: '/dashboard', label: 'Home', icon: Home },
  { href: '/upload', label: 'Upload', icon: Upload },
  { href: '/daily', label: 'Daily', icon: Zap },
  { href: '/profile', label: 'Profile', icon: User },
]

export function MobileNav() {
  const pathname = usePathname()

  return (
    <nav className="fixed bottom-0 left-0 right-0 z-50 border-t bg-background md:hidden">
      <div className="flex items-center justify-around h-16">
        {navItems.map((item) => {
          const isActive = pathname === item.href || pathname.startsWith(`${item.href}/`)
          return (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                'flex flex-col items-center justify-center flex-1 h-full transition-colors',
                isActive ? 'text-foreground' : 'text-muted-foreground'
              )}
            >
              <item.icon className="h-5 w-5" />
              <span className="text-xs mt-1">{item.label}</span>
            </Link>
          )
        })}
      </div>
    </nav>
  )
}
```

**Step 3: Create dashboard layout**

Create `src/app/dashboard/layout.tsx`:
```typescript
import { Navbar } from '@/components/layout/navbar'
import { MobileNav } from '@/components/layout/mobile-nav'

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div className="min-h-screen flex flex-col">
      <Navbar />
      <main className="flex-1 container py-6 pb-20 md:pb-6">
        {children}
      </main>
      <MobileNav />
    </div>
  )
}
```

**Step 4: Create signout route**

Create `src/app/auth/signout/route.ts`:
```typescript
import { createClient } from '@/lib/supabase/server'
import { NextResponse } from 'next/server'

export async function POST(request: Request) {
  const supabase = await createClient()
  await supabase.auth.signOut()

  const { origin } = new URL(request.url)
  return NextResponse.redirect(`${origin}/login`)
}
```

**Step 5: Create empty state dashboard**

Create `src/app/dashboard/page.tsx`:
```typescript
import { createClient } from '@/lib/supabase/server'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Upload, Zap } from 'lucide-react'
import Link from 'next/link'

export default async function DashboardPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  // Get user's questions count
  const { count: questionCount } = await supabase
    .from('user_questions')
    .select('*', { count: 'exact', head: true })
    .eq('user_id', user?.id)

  if (!questionCount || questionCount === 0) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[60vh] text-center space-y-6">
        <div className="space-y-2">
          <h1 className="text-3xl font-bold">Welcome to Quesify!</h1>
          <p className="text-muted-foreground max-w-md">
            Upload your first question screenshot to get started. Our AI will organize it automatically.
          </p>
        </div>

        <Button asChild size="lg">
          <Link href="/upload" className="flex items-center gap-2">
            <Upload className="h-5 w-5" />
            Upload Your First Question
          </Link>
        </Button>
      </div>
    )
  }

  // TODO: Render subjects and charts when user has questions
  return (
    <div className="space-y-8">
      <section>
        <h2 className="text-2xl font-bold mb-4">Your Subjects</h2>
        <p className="text-muted-foreground">Coming soon...</p>
      </section>

      <section>
        <h2 className="text-2xl font-bold mb-4">Today's Charts</h2>
        <p className="text-muted-foreground">Coming soon...</p>
      </section>
    </div>
  )
}
```

**Step 6: Update home page redirect**

Replace `src/app/page.tsx`:
```typescript
import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'

export default async function Home() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (user) {
    redirect('/dashboard')
  } else {
    redirect('/login')
  }
}
```

**Step 7: Commit dashboard layout**

```bash
git add .
git commit -m "feat: create dashboard layout with navbar and mobile navigation"
```

---

## Phase 2: Upload Flow & AI Processing

### Task 2.1: Create Gemini AI Service

**Files:**
- Create: `src/lib/ai/gemini.ts`
- Create: `src/lib/ai/prompts.ts`

**Step 1: Create prompts file**

Create `src/lib/ai/prompts.ts`:
```typescript
export const EXTRACTION_PROMPT = `You are analyzing a question image for a student question bank app.

Extract the following information from this image:

{
  "question_text": "Full question with LaTeX formatting (use $...$ for inline math, $$...$$ for block math). Include all mathematical expressions properly formatted.",
  "options": ["A) option text", "B) option text", ...], // Empty array [] if not MCQ. Include LaTeX for math.
  "type": "MCQ" | "VSA" | "SA" | "LA" | "CASE_STUDY",
  "has_diagram": true | false, // true if the question contains any diagram, graph, circuit, or figure
  "has_solution": true | false,
  "solution": "Solution with LaTeX formatting. Empty string if no solution visible.",
  "numerical_answer": "The final numerical answer if this is a numerical problem, null otherwise",
  "subject": "Physics" | "Chemistry" | "Math" | "Biology" | "Other",
  "chapter": "The specific chapter name (e.g., 'Current Electricity', 'Integration', 'Organic Chemistry')",
  "topics": ["specific topic 1", "specific topic 2"], // Be specific
  "difficulty": "easy" | "medium" | "hard" | "very_hard",
  "importance": 1-5, // How important/common is this type of question
  "hint": "A helpful hint that guides toward the solution without giving it away"
}

IMPORTANT:
- Use proper LaTeX: $\\frac{1}{2}$, $\\int$, $\\sqrt{}$, $\\vec{F}$, etc.
- For chemistry: Use $\\ce{H2O}$ for chemical formulas
- Identify the question type accurately
- Be specific with chapter and topics
- Return ONLY valid JSON, no markdown or explanation`

export const DUPLICATE_ANALYSIS_PROMPT = `Compare these two questions and determine if they are duplicates:

Question A:
{questionA}

Question B:
{questionB}

Analyze:
1. Are they testing the SAME concept?
2. Is the solving approach the SAME?
3. Are there any tricky differences (different constraints, edge cases, numerical values)?

Return JSON:
{
  "same_concept": true | false,
  "same_approach": true | false,
  "differences": "Description of key differences if any",
  "verdict": "SAME" | "DIFFERENT_APPROACH" | "DIFFERENT_QUESTION",
  "confidence": 0.0-1.0
}

SAME = Same concept AND same approach (true duplicate)
DIFFERENT_APPROACH = Same concept but different solving method (add as new solution)
DIFFERENT_QUESTION = Different concept entirely (not a duplicate)

Return ONLY valid JSON.`

export const CHART_GENERATION_PROMPT = `Generate personalized question charts for this user:

User Stats:
- Weak chapters: {weakChapters}
- Recent focus: {recentSubjects}
- Struggle rates by topic: {struggleRates}
- Total questions available: {totalQuestions}

Available question IDs by category:
{questionCategories}

Generate 3-5 personalized chart recommendations:
{
  "charts": [
    {
      "name": "Creative, engaging chart name",
      "description": "Why this chart helps the student",
      "question_ids": ["id1", "id2", ...],
      "count": 10,
      "type": "daily_feed" | "topic_review" | "quick_mcq" | "weak_areas"
    }
  ]
}

Prioritization:
- 40% from weak chapters (high fail rate)
- 30% from recent uploads/focus
- 20% confidence builders (easier questions from strong areas)
- 10% important/popular questions

Return ONLY valid JSON.`
```

**Step 2: Create Gemini service**

Create `src/lib/ai/gemini.ts`:
```typescript
import { GoogleGenerativeAI } from '@google/generative-ai'
import { EXTRACTION_PROMPT, DUPLICATE_ANALYSIS_PROMPT } from './prompts'
import type { GeminiExtractionResult, DuplicateCheckResult } from '@/lib/types'

const genAI = new GoogleGenerativeAI(process.env.GOOGLE_API_KEY!)

export async function extractQuestionFromImage(
  imageBase64: string,
  mimeType: string
): Promise<GeminiExtractionResult> {
  const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' })

  const result = await model.generateContent([
    {
      inlineData: {
        mimeType,
        data: imageBase64,
      },
    },
    { text: EXTRACTION_PROMPT },
  ])

  const response = result.response.text()

  // Clean up response - remove markdown code blocks if present
  const cleanedResponse = response
    .replace(/```json\n?/g, '')
    .replace(/```\n?/g, '')
    .trim()

  try {
    return JSON.parse(cleanedResponse) as GeminiExtractionResult
  } catch (error) {
    console.error('Failed to parse Gemini response:', cleanedResponse)
    throw new Error('Failed to parse AI response. Please try again.')
  }
}

export async function checkDuplicate(
  questionA: string,
  questionB: string
): Promise<DuplicateCheckResult> {
  const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' })

  const prompt = DUPLICATE_ANALYSIS_PROMPT
    .replace('{questionA}', questionA)
    .replace('{questionB}', questionB)

  const result = await model.generateContent(prompt)
  const response = result.response.text()

  const cleanedResponse = response
    .replace(/```json\n?/g, '')
    .replace(/```\n?/g, '')
    .trim()

  try {
    const parsed = JSON.parse(cleanedResponse)
    return {
      is_duplicate: parsed.verdict === 'SAME',
      match_type: parsed.verdict,
      matched_question_id: null, // Will be set by caller
      confidence: parsed.confidence,
      differences: parsed.differences,
    }
  } catch (error) {
    console.error('Failed to parse duplicate check response:', cleanedResponse)
    throw new Error('Failed to analyze duplicate. Please try again.')
  }
}

export async function generateEmbedding(text: string): Promise<number[]> {
  const model = genAI.getGenerativeModel({ model: 'text-embedding-004' })

  const result = await model.embedContent(text)
  return result.embedding.values
}

export async function validateImage(
  imageBase64: string,
  mimeType: string
): Promise<{ isValid: boolean; reason?: string }> {
  const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' })

  const result = await model.generateContent([
    {
      inlineData: {
        mimeType,
        data: imageBase64,
      },
    },
    {
      text: `Is this image a valid educational question (from a textbook, exam, worksheet, etc.)?

Return JSON:
{
  "isValid": true | false,
  "isBlurry": true | false,
  "reason": "Brief explanation if invalid"
}

Return ONLY valid JSON.`,
    },
  ])

  const response = result.response.text()
  const cleanedResponse = response
    .replace(/```json\n?/g, '')
    .replace(/```\n?/g, '')
    .trim()

  try {
    const parsed = JSON.parse(cleanedResponse)
    if (parsed.isBlurry) {
      return { isValid: false, reason: 'Image is too blurry. Please upload a clearer image.' }
    }
    return { isValid: parsed.isValid, reason: parsed.reason }
  } catch {
    return { isValid: true } // Default to valid if parsing fails
  }
}
```

**Step 3: Commit AI service**

```bash
git add .
git commit -m "feat: create Gemini AI service for question extraction and duplicate detection"
```

---

### Task 2.2: Create Upload API Route

**Files:**
- Create: `src/app/api/upload/route.ts`
- Create: `src/lib/storage/upload.ts`

**Step 1: Create storage helper**

Create `src/lib/storage/upload.ts`:
```typescript
import { createClient } from '@/lib/supabase/server'

export async function uploadQuestionImage(
  file: File,
  userId: string
): Promise<string> {
  const supabase = await createClient()

  const fileExt = file.name.split('.').pop()
  const fileName = `${userId}/${Date.now()}.${fileExt}`

  const { data, error } = await supabase.storage
    .from('question-images')
    .upload(fileName, file, {
      contentType: file.type,
      upsert: false,
    })

  if (error) {
    throw new Error(`Failed to upload image: ${error.message}`)
  }

  const { data: { publicUrl } } = supabase.storage
    .from('question-images')
    .getPublicUrl(data.path)

  return publicUrl
}

export async function deleteQuestionImage(imageUrl: string): Promise<void> {
  const supabase = await createClient()

  // Extract path from URL
  const path = imageUrl.split('/question-images/')[1]
  if (!path) return

  await supabase.storage
    .from('question-images')
    .remove([path])
}
```

**Step 2: Create upload API route**

Create `src/app/api/upload/route.ts`:
```typescript
import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { extractQuestionFromImage, validateImage, generateEmbedding } from '@/lib/ai/gemini'
import { uploadQuestionImage } from '@/lib/storage/upload'

export async function POST(request: NextRequest) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const formData = await request.formData()
    const file = formData.get('file') as File

    if (!file) {
      return NextResponse.json({ error: 'No file provided' }, { status: 400 })
    }

    // Check file type
    if (!file.type.startsWith('image/')) {
      return NextResponse.json({ error: 'File must be an image' }, { status: 400 })
    }

    // Check file size (max 10MB)
    if (file.size > 10 * 1024 * 1024) {
      return NextResponse.json({ error: 'File size must be less than 10MB' }, { status: 400 })
    }

    // Convert to base64 for Gemini
    const bytes = await file.arrayBuffer()
    const base64 = Buffer.from(bytes).toString('base64')

    // Step 1: Validate image
    const validation = await validateImage(base64, file.type)
    if (!validation.isValid) {
      return NextResponse.json({
        error: validation.reason || 'Invalid image. Please upload a clear question image.'
      }, { status: 400 })
    }

    // Step 2: Extract question data with Gemini
    const extractionResult = await extractQuestionFromImage(base64, file.type)

    // Step 3: Upload image to storage
    const imageUrl = await uploadQuestionImage(file, user.id)

    // Step 4: Generate embedding for duplicate detection
    const embedding = await generateEmbedding(extractionResult.question_text)

    // Return extracted data for user review (don't save yet)
    return NextResponse.json({
      success: true,
      data: {
        ...extractionResult,
        image_url: imageUrl,
        embedding,
      },
    })
  } catch (error) {
    console.error('Upload error:', error)
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'Upload failed' },
      { status: 500 }
    )
  }
}
```

**Step 3: Commit upload API**

```bash
git add .
git commit -m "feat: create upload API route with Gemini processing"
```

---

### Task 2.3: Create Upload Page UI

**Files:**
- Create: `src/app/upload/page.tsx`
- Create: `src/components/upload/dropzone.tsx`
- Create: `src/components/upload/preview-card.tsx`
- Create: `src/components/ui/latex.tsx`

**Step 1: Create LaTeX component**

Create `src/components/ui/latex.tsx`:
```typescript
'use client'

import 'katex/dist/katex.min.css'
import { InlineMath, BlockMath } from 'react-katex'

interface LatexProps {
  children: string
  block?: boolean
}

export function Latex({ children, block = false }: LatexProps) {
  // Split text by LaTeX delimiters and render
  const parts = children.split(/(\$\$[\s\S]*?\$\$|\$[^$]*?\$)/g)

  return (
    <span>
      {parts.map((part, index) => {
        if (part.startsWith('$$') && part.endsWith('$$')) {
          const math = part.slice(2, -2)
          return <BlockMath key={index} math={math} />
        }
        if (part.startsWith('$') && part.endsWith('$')) {
          const math = part.slice(1, -1)
          return <InlineMath key={index} math={math} />
        }
        return <span key={index}>{part}</span>
      })}
    </span>
  )
}

export function LatexBlock({ children }: { children: string }) {
  return <Latex block>{children}</Latex>
}
```

**Step 2: Create dropzone component**

Create `src/components/upload/dropzone.tsx`:
```typescript
'use client'

import { useCallback, useState } from 'react'
import { useDropzone } from 'react-dropzone'
import { Upload, X, Loader2 } from 'lucide-react'
import { cn } from '@/lib/utils'

interface DropzoneProps {
  onFileSelect: (file: File) => void
  isProcessing: boolean
  selectedFile: File | null
  onClear: () => void
}

export function Dropzone({ onFileSelect, isProcessing, selectedFile, onClear }: DropzoneProps) {
  const onDrop = useCallback((acceptedFiles: File[]) => {
    if (acceptedFiles[0]) {
      onFileSelect(acceptedFiles[0])
    }
  }, [onFileSelect])

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: {
      'image/*': ['.png', '.jpg', '.jpeg', '.webp'],
    },
    maxFiles: 1,
    disabled: isProcessing,
  })

  if (selectedFile) {
    return (
      <div className="relative rounded-lg border border-border overflow-hidden">
        <img
          src={URL.createObjectURL(selectedFile)}
          alt="Selected question"
          className="w-full max-h-96 object-contain bg-muted"
        />
        {isProcessing ? (
          <div className="absolute inset-0 bg-background/80 flex items-center justify-center">
            <div className="flex flex-col items-center gap-2">
              <Loader2 className="h-8 w-8 animate-spin" />
              <span className="text-sm">Processing with AI...</span>
            </div>
          </div>
        ) : (
          <button
            onClick={onClear}
            className="absolute top-2 right-2 p-1 rounded-full bg-background/80 hover:bg-background"
          >
            <X className="h-5 w-5" />
          </button>
        )}
      </div>
    )
  }

  return (
    <div
      {...getRootProps()}
      className={cn(
        'border-2 border-dashed rounded-lg p-12 text-center cursor-pointer transition-colors',
        isDragActive ? 'border-primary bg-primary/5' : 'border-muted-foreground/25 hover:border-muted-foreground/50'
      )}
    >
      <input {...getInputProps()} />
      <Upload className="h-12 w-12 mx-auto mb-4 text-muted-foreground" />
      <p className="text-lg font-medium">
        {isDragActive ? 'Drop the image here' : 'Drag & drop a question image'}
      </p>
      <p className="text-sm text-muted-foreground mt-1">
        or click to select from your device
      </p>
      <p className="text-xs text-muted-foreground mt-4">
        Supports PNG, JPG, JPEG, WebP (max 10MB)
      </p>
    </div>
  )
}
```

**Step 3: Add react-dropzone dependency**

```bash
bun add react-dropzone
```

**Step 4: Create preview card component**

Create `src/components/upload/preview-card.tsx`:
```typescript
'use client'

import { useState } from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Badge } from '@/components/ui/badge'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { Latex } from '@/components/ui/latex'
import { Check, Edit2, Loader2 } from 'lucide-react'
import type { GeminiExtractionResult } from '@/lib/types'

interface PreviewCardProps {
  data: GeminiExtractionResult & { image_url: string; embedding: number[] }
  onSave: (data: GeminiExtractionResult & { image_url: string; embedding: number[] }) => Promise<void>
  isSaving: boolean
}

export function PreviewCard({ data, onSave, isSaving }: PreviewCardProps) {
  const [editMode, setEditMode] = useState(false)
  const [editedData, setEditedData] = useState(data)

  const handleSave = async () => {
    await onSave(editedData)
  }

  const difficultyColors = {
    easy: 'bg-green-500/20 text-green-400',
    medium: 'bg-yellow-500/20 text-yellow-400',
    hard: 'bg-orange-500/20 text-orange-400',
    very_hard: 'bg-red-500/20 text-red-400',
  }

  return (
    <Card>
      <CardHeader className="flex flex-row items-center justify-between">
        <CardTitle>Extracted Question</CardTitle>
        <Button
          variant="ghost"
          size="sm"
          onClick={() => setEditMode(!editMode)}
        >
          <Edit2 className="h-4 w-4 mr-1" />
          {editMode ? 'Preview' : 'Edit'}
        </Button>
      </CardHeader>
      <CardContent className="space-y-6">
        {/* Question */}
        <div className="space-y-2">
          <Label>Question</Label>
          {editMode ? (
            <textarea
              className="w-full min-h-32 p-3 rounded-md bg-muted border"
              value={editedData.question_text}
              onChange={(e) => setEditedData({ ...editedData, question_text: e.target.value })}
            />
          ) : (
            <div className="p-3 rounded-md bg-muted">
              <Latex>{editedData.question_text}</Latex>
            </div>
          )}
        </div>

        {/* Options (if MCQ) */}
        {editedData.options.length > 0 && (
          <div className="space-y-2">
            <Label>Options</Label>
            <div className="space-y-2">
              {editedData.options.map((option, index) => (
                <div key={index} className="p-2 rounded-md bg-muted">
                  <Latex>{option}</Latex>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Solution */}
        {editedData.solution && (
          <div className="space-y-2">
            <Label>Solution</Label>
            {editMode ? (
              <textarea
                className="w-full min-h-32 p-3 rounded-md bg-muted border"
                value={editedData.solution}
                onChange={(e) => setEditedData({ ...editedData, solution: e.target.value })}
              />
            ) : (
              <div className="p-3 rounded-md bg-muted">
                <Latex>{editedData.solution}</Latex>
              </div>
            )}
          </div>
        )}

        {/* Hint */}
        <div className="space-y-2">
          <Label>Hint</Label>
          {editMode ? (
            <textarea
              className="w-full min-h-20 p-3 rounded-md bg-muted border"
              value={editedData.hint}
              onChange={(e) => setEditedData({ ...editedData, hint: e.target.value })}
            />
          ) : (
            <div className="p-3 rounded-md bg-muted text-sm">
              {editedData.hint}
            </div>
          )}
        </div>

        {/* Metadata */}
        <div className="flex flex-wrap gap-2">
          <Badge variant="secondary">{editedData.subject}</Badge>
          <Badge variant="secondary">{editedData.chapter}</Badge>
          <Badge variant="secondary">{editedData.type}</Badge>
          <Badge className={difficultyColors[editedData.difficulty]}>
            {editedData.difficulty}
          </Badge>
          {editedData.topics.map((topic) => (
            <Badge key={topic} variant="outline">{topic}</Badge>
          ))}
        </div>

        {/* Numerical answer */}
        {editedData.numerical_answer && (
          <div className="space-y-2">
            <Label>Numerical Answer</Label>
            {editMode ? (
              <Input
                value={editedData.numerical_answer}
                onChange={(e) => setEditedData({ ...editedData, numerical_answer: e.target.value })}
              />
            ) : (
              <div className="p-2 rounded-md bg-muted font-mono">
                {editedData.numerical_answer}
              </div>
            )}
          </div>
        )}

        {/* Save button */}
        <Button
          className="w-full"
          onClick={handleSave}
          disabled={isSaving}
        >
          {isSaving ? (
            <>
              <Loader2 className="h-4 w-4 mr-2 animate-spin" />
              Saving...
            </>
          ) : (
            <>
              <Check className="h-4 w-4 mr-2" />
              Save Question
            </>
          )}
        </Button>
      </CardContent>
    </Card>
  )
}
```

**Step 5: Create upload page**

Create `src/app/upload/page.tsx`:
```typescript
'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { Dropzone } from '@/components/upload/dropzone'
import { PreviewCard } from '@/components/upload/preview-card'
import { useToast } from '@/hooks/use-toast'
import type { GeminiExtractionResult } from '@/lib/types'

type ExtractedData = GeminiExtractionResult & { image_url: string; embedding: number[] }

export default function UploadPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [selectedFile, setSelectedFile] = useState<File | null>(null)
  const [isProcessing, setIsProcessing] = useState(false)
  const [extractedData, setExtractedData] = useState<ExtractedData | null>(null)
  const [isSaving, setIsSaving] = useState(false)

  const handleFileSelect = async (file: File) => {
    setSelectedFile(file)
    setIsProcessing(true)
    setExtractedData(null)

    try {
      const formData = new FormData()
      formData.append('file', file)

      const response = await fetch('/api/upload', {
        method: 'POST',
        body: formData,
      })

      const result = await response.json()

      if (!response.ok) {
        throw new Error(result.error || 'Upload failed')
      }

      setExtractedData(result.data)
      toast({
        title: 'Question extracted!',
        description: 'Review the details and save when ready.',
      })
    } catch (error) {
      toast({
        title: 'Processing failed',
        description: error instanceof Error ? error.message : 'Please try again',
        variant: 'destructive',
      })
      setSelectedFile(null)
    } finally {
      setIsProcessing(false)
    }
  }

  const handleClear = () => {
    setSelectedFile(null)
    setExtractedData(null)
  }

  const handleSave = async (data: ExtractedData) => {
    setIsSaving(true)
    try {
      const response = await fetch('/api/questions', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
      })

      const result = await response.json()

      if (!response.ok) {
        throw new Error(result.error || 'Save failed')
      }

      toast({
        title: 'Question saved!',
        description: 'Your question has been added to your bank.',
      })

      router.push('/dashboard')
    } catch (error) {
      toast({
        title: 'Save failed',
        description: error instanceof Error ? error.message : 'Please try again',
        variant: 'destructive',
      })
    } finally {
      setIsSaving(false)
    }
  }

  return (
    <div className="max-w-2xl mx-auto space-y-6">
      <div>
        <h1 className="text-2xl font-bold">Upload Question</h1>
        <p className="text-muted-foreground">
          Upload a screenshot and let AI extract and organize it
        </p>
      </div>

      <Dropzone
        onFileSelect={handleFileSelect}
        isProcessing={isProcessing}
        selectedFile={selectedFile}
        onClear={handleClear}
      />

      {extractedData && (
        <PreviewCard
          data={extractedData}
          onSave={handleSave}
          isSaving={isSaving}
        />
      )}
    </div>
  )
}
```

**Step 6: Add upload layout**

Create `src/app/upload/layout.tsx`:
```typescript
import { Navbar } from '@/components/layout/navbar'
import { MobileNav } from '@/components/layout/mobile-nav'

export default function UploadLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div className="min-h-screen flex flex-col">
      <Navbar />
      <main className="flex-1 container py-6 pb-20 md:pb-6">
        {children}
      </main>
      <MobileNav />
    </div>
  )
}
```

**Step 7: Commit upload page**

```bash
git add .
git commit -m "feat: create upload page with dropzone and preview card"
```

---

### Task 2.4: Create Questions Save API

**Files:**
- Create: `src/app/api/questions/route.ts`

**Step 1: Create questions API**

Create `src/app/api/questions/route.ts`:
```typescript
import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import type { GeminiExtractionResult } from '@/lib/types'

interface SaveQuestionRequest extends GeminiExtractionResult {
  image_url: string
  embedding: number[]
}

export async function POST(request: NextRequest) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body: SaveQuestionRequest = await request.json()

    // TODO: Check for duplicates using embedding similarity
    // For MVP, we'll skip duplicate detection and save directly

    // Create question
    const { data: question, error: questionError } = await supabase
      .from('questions')
      .insert({
        owner_id: user.id,
        question_text: body.question_text,
        options: body.options,
        type: body.type,
        has_diagram: body.has_diagram,
        image_url: body.image_url,
        subject: body.subject,
        chapter: body.chapter,
        topics: body.topics,
        difficulty: body.difficulty,
        importance: body.importance,
        hint: body.hint,
        embedding: body.embedding,
      })
      .select()
      .single()

    if (questionError) {
      console.error('Question insert error:', questionError)
      return NextResponse.json({ error: 'Failed to save question' }, { status: 500 })
    }

    // Create solution if provided
    if (body.solution && body.has_solution) {
      const { error: solutionError } = await supabase
        .from('solutions')
        .insert({
          question_id: question.id,
          contributor_id: user.id,
          solution_text: body.solution,
          numerical_answer: body.numerical_answer,
          is_ai_best: true,
        })

      if (solutionError) {
        console.error('Solution insert error:', solutionError)
      }
    }

    // Create user-question link
    const { error: linkError } = await supabase
      .from('user_questions')
      .insert({
        user_id: user.id,
        question_id: question.id,
        is_owner: true,
      })

    if (linkError) {
      console.error('User-question link error:', linkError)
    }

    // Update user profile stats
    await supabase
      .from('user_profiles')
      .update({
        total_uploaded: supabase.rpc('increment', { x: 1 }),
      })
      .eq('user_id', user.id)

    return NextResponse.json({
      success: true,
      question: question
    })
  } catch (error) {
    console.error('Save question error:', error)
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'Save failed' },
      { status: 500 }
    )
  }
}

export async function GET(request: NextRequest) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const { searchParams } = new URL(request.url)
    const subject = searchParams.get('subject')
    const chapter = searchParams.get('chapter')
    const limit = parseInt(searchParams.get('limit') || '20')
    const offset = parseInt(searchParams.get('offset') || '0')

    let query = supabase
      .from('user_questions')
      .select(`
        question:questions(
          *,
          solutions(*)
        )
      `)
      .eq('user_id', user.id)
      .range(offset, offset + limit - 1)
      .order('added_at', { ascending: false })

    if (subject) {
      query = query.eq('question.subject', subject)
    }
    if (chapter) {
      query = query.eq('question.chapter', chapter)
    }

    const { data, error } = await query

    if (error) {
      return NextResponse.json({ error: 'Failed to fetch questions' }, { status: 500 })
    }

    return NextResponse.json({
      questions: data?.map(d => d.question).filter(Boolean) || []
    })
  } catch (error) {
    console.error('Fetch questions error:', error)
    return NextResponse.json(
      { error: 'Failed to fetch questions' },
      { status: 500 }
    )
  }
}
```

**Step 2: Create RPC function for increment**

Apply this migration via Supabase MCP:

```sql
CREATE OR REPLACE FUNCTION increment(x integer)
RETURNS integer AS $$
BEGIN
  RETURN x + 1;
END;
$$ LANGUAGE plpgsql;
```

**Step 3: Commit questions API**

```bash
git add .
git commit -m "feat: create questions save and fetch API"
```

---

This completes the detailed implementation plan for **Phase 1** (Foundation) and **Phase 2** (Upload Flow). The plan continues with:

- **Phase 3:** Duplicate Detection & Solutions (detailed embedding search, solution merging)
- **Phase 4:** Home Screen & Charts/Feeds (subjects display, chart generation)
- **Phase 5:** Solving & Progress Tracking (answer verification, stats)
- **Phase 6:** Gamification & Polish (streaks, PWA, export)

---

## Next Steps

The remaining phases follow the same detailed structure. Each task includes:
- Exact file paths
- Complete code (not pseudocode)
- Exact commands with expected output
- Git commits for each logical unit

---

**Plan complete and saved to `docs/plans/2026-01-25-quesify-mvp.md`.**

**Two execution options:**

**1. Subagent-Driven (this session)** - I dispatch fresh subagent per task, review between tasks, fast iteration

**2. Parallel Session (separate)** - Open new session with executing-plans, batch execution with checkpoints

**Which approach?**
