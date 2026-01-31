# Coding Conventions

**Analysis Date:** 2026-01-31

## Naming Patterns

**Files:**
- Components: `kebab-case.tsx` (e.g., `preview-card.tsx`, `profile-sidebar.tsx`)
- Pages: `page.tsx` (Next.js App Router convention)
- Layouts: `layout.tsx`
- API routes: `route.ts`
- Utilities: `kebab-case.ts` (e.g., `utils.ts`, `charts.ts`)
- Hooks: `use-kebab-case.ts` (e.g., `use-in-view.ts`)
- Types: Centralized in `lib/types/` directory
  - `database.ts` - Database schema types
  - `index.ts` - Shared API response types

**Functions:**
- camelCase for all functions (e.g., `createClient`, `generateUserCharts`, `extractQuestion`)
- Async functions use camelCase with clear verb prefixes (e.g., `validateImage`, `extractQuestion`, `generateSolution`)

**Variables:**
- camelCase for all variables (e.g., `extractedData`, `analysisStatus`, `finalizationLock`)
- React state prefixed with `is/isAre/isNot` for booleans (e.g., `isProcessing`, `isSaving`, `isOwner`)
- Constants in UPPER_SNAKE_CASE (e.g., `AI_CONFIG`, `PROMPTS`)

**Types:**
- PascalCase for interfaces (e.g., `UserProfile`, `Question`, `Solution`)
- PascalCase for type aliases (e.g., `QuestionType`, `Difficulty`, `ModelType`)
- Union types use PascalCase with `|` separator (e.g., `'MCQ' | 'VSA' | 'SA' | 'LA' | 'CASE_STUDY'`)
- Extended types use suffix pattern (e.g., `QuestionWithSolutions`, `QuestionWithStats`)

## Code Style

**Formatting:**
- Tool: ESLint (Next.js config)
- Config file: `eslint.config.mjs`
- Extends: `eslint-config-next/core-web-vitals` and `eslint-config-next/typescript`
- Strict TypeScript mode enabled
- 2-space indentation (implicit from examples)

**Linting:**
- Tool: ESLint with Next.js preset
- Key rules: Core Web Vitals, TypeScript strict mode
- No Prettier config detected (likely relying on ESLint formatting)

**Path Aliases:**
- `@/*` → `./src/*` (configured in `tsconfig.json`)
- Usage examples:
  - `@/lib/utils`
  - `@/components/ui/button`
  - `@/lib/supabase/client`

## Import Organization

**Order:**
1. React/Next.js imports
2. Third-party library imports (sorted alphabetically)
3. Internal imports (using `@/` alias, grouped by directory)
4. Type imports (intermixed or separated)

**Example pattern from `src/app/upload/page.tsx`:**
```typescript
'use client'

import { useState, useRef, useCallback } from 'react'
import { useRouter } from 'next/navigation'
import { Dropzone } from '@/components/upload/dropzone'
import { PreviewCard } from '@/components/upload/preview-card'
import { toast } from 'sonner'
import type { GeminiExtractionResult, DuplicateCheckResult } from '@/lib/types'
```

**Path Aliases:**
- `@/components/*` - UI and feature components
- `@/lib/*` - Shared utilities, services, AI logic
- `@/app/*` - Next.js App Router pages and API routes
- `@/hooks/*` - Custom React hooks

## Error Handling

**API Route Pattern:**
```typescript
export async function POST(request: NextRequest) {
  try {
    // 1. Auth check
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    // 2. Input validation
    const body = await request.json()
    if (!questionId) {
      return NextResponse.json({ error: 'Question ID is required' }, { status: 400 })
    }

    // 3. Business logic
    // ...

    return NextResponse.json({ success: true })
  } catch (error) {
    console.error('Error in route:', error)
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'Internal server error' },
      { status: 500 }
    )
  }
}
```

**Error Response Format:**
- `{ error: string }` - Error messages
- Status codes: 401 (unauthorized), 400 (bad request), 500 (internal error), 404 (not found)

**Frontend Error Handling:**
```typescript
try {
  const res = await fetch('/api/upload/extract', { method: 'POST', body: formData })
  const result = await res.json()
  if (!res.ok) throw new Error(result.error || 'Extraction failed')
  // Success
} catch (error) {
  setAnalysisStatus(prev => ({
    ...prev,
    extracting: false,
    extractError: error instanceof Error ? error.message : 'Extraction failed'
  }))
  toast.error('Extraction failed')
}
```

## Logging

**Framework:** `console` (no external logging library detected)

**Patterns:**

**Performance timing:**
```typescript
const start = performance.now()
// ... do work ...
const duration = performance.now() - start
console.log(`[Phase] Description took ${duration.toFixed(2)}ms`)
```

**Error logging:**
```typescript
console.error('Descriptive context:', error)
```

**Debug logging:**
- Conditional on `process.env.NODE_ENV === 'development'` (in `AI_CONFIG.debug`)
- AI operations log timing and model info when debug is enabled

**Time-taken only (per project requirement):**
```typescript
console.log(`[Frontend] Extraction phase took ${(performance.now() - start).toFixed(2)}ms`)
console.log(`[AI/Text] ${modelType} (${config.provider}/${config.model}) took ${duration.toFixed(2)}ms`)
```

## Comments

**When to Comment:**
- Complex algorithm explanations
- TODO markers for future work
- Inline comments for non-obvious logic

**JSDoc/TSDoc:**
- Minimal usage in codebase
- Some functions have JSDoc comments for complex operations (e.g., in `src/lib/ai/services.ts`)
- Type system largely self-documenting via TypeScript interfaces

**TODO comments:**
- Use `// TODO:` format
- Example: `// TODO: Check for duplicates using embedding similarity` in `src/app/api/questions/route.ts`

## Function Design

**Size:**
- No strict size limit enforced
- API routes tend to be 50-150 lines
- Component files vary widely (30-200 lines)
- AI services consolidated into single file (`src/lib/ai/services.ts` ~300 lines)

**Parameters:**
- Objects for multiple related params (e.g., interface props)
- Destructuring pattern common
- Example:
```typescript
async validateImage(imageBase64: string, mimeType: string): Promise<{ isValid: boolean; reason?: string }>
async generateSolution(
  questionText: string,
  questionType: string,
  subject: string,
  options: string[] = []
): Promise<SolutionGenerationResponse>
```

**Return Values:**
- Explicit return types using TypeScript interfaces
- Async functions return Promise<T>
- API routes return `NextResponse`
- Example return patterns:
```typescript
Promise<{ isValid: boolean; reason?: string }>
Promise<SolutionGenerationResponse>
NextResponse.json({ success: true })
```

## Module Design

**Exports:**
- Named exports for multiple items (e.g., `export { Button, buttonVariants }`)
- Default exports for single main export (e.g., pages, layouts, main components)
- Type exports grouped with values

**Barrel Files:**
- `src/lib/types/index.ts` - Exports all types from database and shared types
- Example:
```typescript
export * from './database'

export interface ApiResponse<T> {
  data: T | null
  error: string | null
}
```

**Singleton Pattern:**
- Used for AI client (single instance pattern in `src/lib/ai/client.ts`)
```typescript
class AIClient {
  private static instance: AIClient
  static getInstance(): AIClient {
    if (!AIClient.instance) {
      AIClient.instance = new AIClient()
    }
    return AIClient.instance
  }
}
```

**Object-based Service Pattern:**
- AI operations exported as object with methods (`src/lib/ai/services.ts`)
```typescript
export const ai = {
  async validateImage(...) { ... },
  async extractQuestion(...) { ... },
  async generateSolution(...) { ... }
}
```

---

*Convention analysis: 2026-01-31*
