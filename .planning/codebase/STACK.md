# Technology Stack

**Analysis Date:** 2026-01-31

## Languages

**Primary:**
- TypeScript 5.x - Primary language for all application code
  - Used in: `src/**/*.ts`, `src/**/*.tsx`
  - Strict mode enabled
  - Target: ES2017

**Secondary:**
- JavaScript - Minimal usage in configuration files
  - Used in: `eslint.config.mjs`, `postcss.config.mjs`, `next.config.ts`

## Runtime

**Environment:**
- Bun - Preferred runtime and package manager
  - Use `bun install`, `bun run`, `bun test`, `bun build` instead of npm/yarn
  - Auto-loads .env files (no dotenv needed)
- Node.js - Underlying runtime for Next.js

**Package Manager:**
- Bun (primary) - Per CLAUDE.md instructions
- npm (fallback) - Standard scripts in `package.json`
- Lockfile: `bun.lock` present

## Frameworks

**Core:**
- Next.js 16.1.4 - Full-stack React framework
  - App Router architecture (`src/app/`)
  - API routes (`src/app/api/`)
  - Server and client components
  - Middleware for auth (`src/lib/supabase/middleware.ts`)
- React 19.2.3 - UI library
- React DOM 19.2.3 - DOM rendering

**UI Components:**
- Radix UI - Headless component primitives
  - @radix-ui/react-dialog - Modal/dialog components
  - @radix-ui/react-dropdown-menu - Dropdown menus
  - @radix-ui/react-avatar - User avatars
  - @radix-ui/react-label - Form labels
  - @radix-ui/react-popover - Popover components
  - @radix-ui/react-scroll-area - Custom scrollbars
  - @radix-ui/react-separator - Dividers
  - @radix-ui/react-slot - Slot composition
  - @radix-ui/react-tabs - Tab components
  - @radix-ui/react-alert-dialog - Alert dialogs
- shadcn/ui - Component library built on Radix UI
  - Config: `components.json`
  - Style: "new-york" with CSS variables
  - Base color: neutral

**Styling:**
- Tailwind CSS 4.1.18 - Utility-first CSS framework
  - Config: PostCSS plugin (`@tailwindcss/postcss`)
  - CSS Variables enabled
  - Path: `src/app/globals.css`
- tw-animate-css - Additional animations

**State Management:**
- @tanstack/react-query 5.90.20 - Server state management
  - Configured in `src/components/providers.tsx`
  - Stale time: 60s, retry: 1
- zustand 5.0.10 - Client state management

**Testing:**
- Not detected - No test files found in src/ directory
  - Only test files present in node_modules (dependency tests)

**Build/Dev:**
- TypeScript 5.x - Type checking and compilation
- ESLint 9.x - Linting with Next.js config
  - Config: `eslint.config.mjs`
  - Extends: `eslint-config-next/core-web-vitals`, `eslint-config-next/typescript`
- PostCSS - CSS processing
  - Config: `postcss.config.mjs`

## Key Dependencies

**Critical:**
- @google/generative-ai 0.24.1 - Google Gemini AI SDK
  - Used for: Text generation, image analysis, embeddings
  - Location: `src/lib/ai/client.ts`
- groq-sdk 0.37.0 - Groq AI SDK
  - Used for: Fast text generation, Llama models
  - Location: `src/lib/ai/client.ts`
- @supabase/supabase-js 2.91.1 - Supabase JavaScript client
  - Used for: Database queries, auth, storage
  - Location: `src/lib/supabase/client.ts`, `src/lib/supabase/server.ts`
- @supabase/ssr 0.8.0 - Supabase SSR utilities
  - Used for: Server-side auth, cookie handling

**Infrastructure:**
- @upstash/redis 1.36.1 - Redis HTTP client
  - Used for: Serverless caching
  - Location: `src/lib/db/redis.ts`

**UI & Rendering:**
- katex 0.16.28 - LaTeX rendering
- react-katex 3.1.0 - React wrapper for KaTeX
- react-markdown 10.1.0 - Markdown rendering
- rehype-katex 7.0.1 - KaTeX support for markdown
- remark-math 6.0.0 - Math support for markdown
- framer-motion 12.29.2 - Animation library

**Utilities:**
- clsx 2.1.1 - Conditional class names
- tailwind-merge 3.4.0 - Tailwind class merging
- class-variance-authority 0.7.1 - Component variant management
- date-fns 4.1.0 - Date manipulation
- nanoid 5.1.6 - Unique ID generation

**Form & Input:**
- react-dropzone 14.3.8 - File upload component
- cmdk 1.1.1 - Command palette

**Feedback:**
- sonner 2.0.7 - Toast notifications

**Icons:**
- lucide-react 0.563.0 - Icon library
- Used extensively across components

**Math & Science:**
- @toon-format/toon 2.1.0 - Science/math formatting

## Configuration

**Environment:**
- Bun-based runtime (preferred)
- Environment files: `.env.local`, `.env.example`
- Auto-loaded by Bun (no dotenv needed)
- Key env vars documented in `.env.example`

**Build:**
- Next.js config: `next.config.ts` (minimal, defaults used)
- TypeScript config: `tsconfig.json`
  - Path aliases: `@/*` maps to `./src/*`
  - Module resolution: bundler
  - JSX: react-jsx
- ESLint config: `eslint.config.mjs`
- PostCSS config: `postcss.config.mjs`
- Tailwind config: Built-in with PostCSS plugin

**Authentication:**
- Supabase Auth (managed service)
- Middleware: `src/lib/supabase/middleware.ts`
- Client: `src/lib/supabase/client.ts` (browser)
- Server: `src/lib/supabase/server.ts` (server components)

## Platform Requirements

**Development:**
- Bun runtime (recommended) or Node.js 20+
- TypeScript 5.x
- Modern browser for development

**Production:**
- Next.js 16.1.4 compatible hosting (Vercel, Netlify, etc.)
- Bun or Node.js 20+ runtime
- Supabase project (PostgreSQL + Auth + Storage)
- Upstash Redis instance (optional but recommended for caching)
- AI API keys: Gemini API Key, Groq API Key

---

*Stack analysis: 2026-01-31*
