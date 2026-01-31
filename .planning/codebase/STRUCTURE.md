# Codebase Structure

**Analysis Date:** 2026-01-31

## Directory Layout

```
quesify/
├── .agent/               # Agent configuration files
├── .claude/              # Claude AI skill files
├── .cursor/              # Cursor AI configuration
├── .gemini/              # Gemini AI configuration
├── .next/                # Next.js build output (generated, not committed)
├── .opencode/            # OpenCode agent files
├── docs/                 # Project documentation
│   └── plans/            # Feature planning documents
├── node_modules/         # Node.js dependencies (not committed)
├── public/               # Static assets served by Next.js
│   └── fonts/            # Custom font files
├── scripts/              # Build and utility scripts
├── src/                  # Application source code
│   ├── actions/          # Server Actions for mutations
│   ├── app/              # Next.js App Router pages and routes
│   │   ├── actions/      # Server actions
│   │   ├── api/          # API route handlers
│   │   ├── auth/         # Authentication callbacks
│   │   ├── dashboard/    # Dashboard pages
│   │   ├── login/        # Login page
│   │   ├── onboarding/   # Username setup page
│   │   ├── question/     # Question detail pages
│   │   ├── upload/       # Upload flow pages
│   │   └── u/            # User profile pages
│   ├── components/       # React components
│   │   ├── ai/           # AI assistant components
│   │   ├── auth/         # Authentication UI
│   │   ├── dashboard/    # Dashboard-specific components
│   │   ├── layout/       # Layout components (header, nav)
│   │   ├── onboarding/   # Onboarding components
│   │   ├── profile/      # Profile page components
│   │   ├── questions/    # Question-related components
│   │   ├── ui/           # Reusable UI primitives (Radix UI)
│   │   └── upload/       # Upload flow components
│   ├── hooks/            # Custom React hooks
│   ├── lib/              # Library and utility code
│   │   ├── ai/           # AI integration (client, config, services, prompts)
│   │   ├── db/           # Database utilities
│   │   ├── services/     # Business logic services
│   │   ├── storage/      # File storage helpers
│   │   ├── supabase/     # Supabase client factories
│   │   ├── types/        # TypeScript type definitions
│   │   └── utils.ts      # Utility functions
│   ├── proxy.ts          # Development proxy
│   ├── types/            # Global type declarations
│   ├── app.css           # Global styles (deprecated, use globals.css)
│   ├── app.css.map       # Source map (generated)
│   ├── app.d.ts          # Global type definitions
│   └── app.tsx           # Legacy entry point (unused)
├── supabase/             # Supabase configuration
│   ├── .temp/            # Temporary migration files
│   └── migrations/       # Database migrations
├── .env.example          # Environment variable template
├── .env.local            # Local environment variables (not committed)
├── .eslintrc.js          # ESLint configuration
├── .gitignore            # Git ignore rules
├── .mcp.json             # MCP server configuration
├ bun.lock                # Bun package lockfile
├ components.json         # shadcn/ui component configuration
├ eslint.config.mjs       # ESLint config (modern format)
├ MIGRATION.md            # Migration notes
├ next.config.ts          # Next.js configuration
├ next-env.d.ts           # Next.js type definitions
├ package.json            # Package manifest
├ postcss.config.mjs      # PostCSS configuration
├ PROJECT.md              # Project documentation
├ README.md               # Project README
├ syllabus.md             # Syllabus data documentation
└── tsconfig.json         # TypeScript configuration
```

## Directory Purposes

**`src/app/`:**
- Purpose: Next.js App Router structure - pages, layouts, and API routes
- Contains: Page components (`page.tsx`), route handlers (`route.ts`), layouts (`layout.tsx`), server actions
- Key files: `src/app/layout.tsx` (root layout), `src/app/api/questions/route.ts` (questions CRUD)

**`src/components/`:**
- Purpose: Reusable React components organized by feature
- Contains: Feature-specific subdirectories, UI primitives, layout components
- Key files: `src/components/providers.tsx` (React Query provider), `src/components/questions/question-card.tsx`

**`src/lib/`:**
- Purpose: Business logic, external service integrations, and utilities
- Contains: AI module, Supabase clients, storage helpers, type definitions
- Key files: `src/lib/ai/services.ts` (AI service interface), `src/lib/supabase/server.ts` (server client factory)

**`src/types/`:**
- Purpose: Global TypeScript type declarations
- Contains: Third-party library type augmentations (e.g., react-katex)
- Key files: `src/types/react-katex.d.ts`

**`src/hooks/`:**
- Purpose: Custom React hooks
- Contains: Reusable stateful logic hooks
- Key files: `src/hooks/use-in-view.ts`

**`public/`:**
- Purpose: Static assets served directly
- Contains: Fonts, images, favicon
- Key files: `public/fonts/charter/` (custom fonts)

**`supabase/`:**
- Purpose: Supabase-specific configuration and migrations
- Contains: Database schema definitions, migration history
- Key files: `supabase/migrations/` (SQL migration files)

**`.planning/`:**
- Purpose: GSD workflow planning documents
- Contains: Codebase analysis, phase plans, project configuration
- Key files: `.planning/codebase/` (architecture, structure, conventions docs)

## Key File Locations

**Entry Points:**
- `src/app/layout.tsx`: Root application layout with providers and fonts
- `src/app/page.tsx`: Landing page (home)
- `src/app/dashboard/page.tsx`: Main dashboard after login
- `src/app/upload/page.tsx`: Question upload flow
- `src/middleware.ts`: Not found - middleware is at `src/lib/supabase/middleware.ts`

**Configuration:**
- `next.config.ts`: Next.js build and runtime configuration
- `tsconfig.json`: TypeScript compiler configuration
- `package.json`: Dependencies and scripts
- `components.json`: shadcn/ui component registry
- `.env.example`: Environment variable template

**Core Logic:**
- `src/lib/ai/services.ts`: AI service operations (generateSolution, extractQuestion, etc.)
- `src/lib/supabase/server.ts`: Server-side Supabase client factory
- `src/lib/supabase/client.ts`: Client-side Supabase client factory
- `src/lib/storage/upload.ts`: File upload/delete operations
- `src/app/api/`: All API route handlers grouped by feature

**Testing:**
- Not detected - No test files found in codebase

## Naming Conventions

**Files:**
- Page components: `page.tsx` (App Router convention)
- API routes: `route.ts` (App Router convention)
- React components: `kebab-case.tsx` or `PascalCase.tsx` (both used)
- UI components: `kebab-case.tsx` (e.g., `button.tsx`, `card.tsx`)
- Feature components: `kebab-case.tsx` (e.g., `question-card.tsx`, `upload-dropzone.tsx`)
- Server actions: `kebab-case.ts` (e.g., `profile.ts`)
- Utility files: `kebab-case.ts` (e.g., `utils.ts`, `upload.ts`)
- Type definition files: `*.d.ts`

**Directories:**
- Feature-based: lowercase (e.g., `questions/`, `upload/`, `dashboard/`)
- API routes: lowercase with segments (e.g., `api/questions/[id]/like/`)
- Dynamic routes: brackets around parameter (e.g., `[id]`, `[username]`)

## Where to Add New Code

**New Feature:**
- Primary code: Add feature directory under `src/components/` if it has UI, or `src/lib/` if it's service logic
- Pages: Add to `src/app/[feature-name]/page.tsx`
- API routes: Add to `src/app/api/[resource]/route.ts`

**New Component/Module:**
- Implementation: `src/components/[feature-name]/[component-name].tsx`
- If component is reusable across features: `src/components/ui/[component-name].tsx`

**Utilities:**
- Shared helpers: `src/lib/utils.ts` for pure functions
- Service utilities: Add to appropriate `src/lib/` subdirectory (e.g., `src/lib/storage/` for storage helpers)

**New API Endpoint:**
- Route handler: `src/app/api/[resource]/route.ts`
- Sub-resources: `src/app/api/[resource]/[id]/route.ts` or actions like `src/app/api/[resource]/[id]/like/route.ts`

**New Server Action:**
- Action file: `src/app/actions/[feature].ts`
- Export async functions with `'use server'` directive

**New AI Operation:**
- Add method to `src/lib/ai/services.ts` in the `ai` export object
- Add prompt to `src/lib/ai/prompts.ts` if needed
- Configure model in `src/lib/ai/config.ts` if new model type needed

## Special Directories

**`.next/`:**
- Purpose: Next.js build output directory
- Generated: Yes, by `next build` or dev server
- Committed: No (in `.gitignore`)

**`node_modules/`:**
- Purpose: Installed npm/Bun packages
- Generated: Yes, by package manager
- Committed: No (in `.gitignore`)

**`supabase/migrations/`:**
- Purpose: Database schema migrations
- Generated: Yes, by Supabase CLI
- Committed: Yes (version controlled)

**`supabase/.temp/`:**
- Purpose: Temporary Supabase files
- Generated: Yes, by Supabase CLI
- Committed: No

**`.planning/`:**
- Purpose: GSD workflow planning artifacts
- Generated: Yes, by GSD commands
- Committed: Yes (part of development workflow)

**`public/`:**
- Purpose: Static assets served at root URL
- Generated: No
- Committed: Yes (fonts, images, etc.)

---

*Structure analysis: 2026-01-31*
