# Quesify - AI-Powered Universal Question Bank

## Vision

A production-ready full-stack web app where students upload question screenshots, AI auto-organizes them perfectly, and generates personalized daily practice feeds based on their solving patterns. **Not limited to any specific exam** - works for JEE, NEET, boards, or any subject.

---

## Core Concept

### Two Equal Priorities
1. **Personal Organization** - Organize scattered questions from textbooks, coaching materials, screenshots
2. **Smart Practice** - AI-driven personalized feeds based on weaknesses and patterns

### Privacy Model
- **Private by default** - User's questions belong to them
- **Community deduplication** - If same question exists, users link to canonical version
- **Popularity tracking** - Shows how many users have a question
- **Contribution credits** - Users get credit for adding new solution approaches

---

## Question Upload & Processing Flow

```
User uploads image
    ↓
Quality check (reject blurry images)
    ↓
Send directly to Gemini (NO OCR)
    ↓
Gemini extracts:
├── Question text (with LaTeX)
├── Options (with LaTeX if MCQ)
├── Solution (with LaTeX)
├── Numerical answer (if applicable)
├── has_diagram flag
├── Subject, Chapter, Topics
├── Type (MCQ/VSA/SA/LA/CASE_STUDY)
├── Difficulty (easy/medium/hard/very_hard)
└── Importance (1-5)
    ↓
User verifies/tweaks extracted data
    ↓
Search for duplicates in database
    ↓
[Duplicate Detection Flow - see below]
    ↓
Store question with LaTeX-formatted content
```

### Image Handling
- One question per image only (if multiple, AI picks the clearest one)
- Images deleted after 2 years EXCEPT if `has_diagram=true` (kept forever)
- Blurry images rejected at upload

### LaTeX Everywhere
- No OCR - Gemini extracts directly with LaTeX formatting
- App renders LaTeX in: question display, solutions, search, feeds, matching
- Use KaTeX or MathJax for rendering

---

## Duplicate Detection & Question Matching

### Multi-Stage Algorithm

```
Stage 1: Quick filters (cheap, fast)
├── Subject match
├── Question type match
└── Text length roughly similar

Stage 2: Text similarity
├── Normalize LaTeX before comparing
├── Fuzzy matching / TF-IDF score
└── Threshold: 70%+ = potential match

Stage 3: Embedding similarity
├── Generate embedding via Gemini
├── pgvector nearest neighbor search
├── Use specialized math embeddings for equations
└── Cosine similarity > threshold → candidate

Stage 4: Visual similarity (50% of questions have diagrams)
├── Perceptual image hash (pHash)
└── Catches visually similar questions

Stage 5: AI verification (only for candidates)
├── Send both questions to Gemini
├── "Same concept? Same approach? Any tricks?"
└── Final decision
```

### Matching Outcomes

```
┌─────────────────────────────────────────────────────────────┐
│ SAME concept + SAME solution approach                       │
│ → "This exists. You must use the existing one." (forced)    │
│ → User added to question, popularity +1                     │
├─────────────────────────────────────────────────────────────┤
│ SAME concept + DIFFERENT solution approach                  │
│ → Add user's solution to existing question                  │
│ → User gets "contribution" credit                           │
│ → User linked to question, popularity +1                    │
├─────────────────────────────────────────────────────────────┤
│ DIFFERENT concept                                           │
│ → Create new question, user is owner                        │
└─────────────────────────────────────────────────────────────┘
```

### Appeals Process
If user disputes "same question" decision:
1. User explains what's different (seeing the existing question)
2. AI reconsiders with user's explanation
3. AI agrees → new question created
4. AI disagrees → stays linked to existing

---

## Solution System

### Multiple Solutions Per Question
- Each question can have multiple solution approaches from different contributors
- AI validates new solutions before adding (must be valid new approach)

### Solution Display
```
2 solutions:  [Solution 1] [Solution 2]  (tabs)
3+ solutions: [Solution 1] [More Solutions]
              └── Cards with approach descriptions
```

### Solution Ranking
1. AI picks best solution initially
2. User likes determine order over time
3. Most liked solution shown first

### Numerical Answers
- Stored per solution (different approaches may have same answer)
- Tolerance: Significant figures based (match to 2-3 sig figs)

---

## Hint System

- AI generates hint at upload time
- User can tweak the hint
- Then improve with AI collaboration
- Purpose: Help with tricky concepts while solving
- Display: "Get Hint" button before attempting

---

## Home Screen Structure

```
┌─────────────────────────────────────────┐
│  SUBJECTS                               │
│  [Physics] [Chemistry] [Math] ...       │
│                                         │
│  Clicking a subject:                    │
│  └── Chapters (default view)            │
│      └── Click chapter → Topics view    │
│      └── Filters: type, difficulty,     │
│          importance, etc.               │
├─────────────────────────────────────────┤
│  CHARTS (like Spotify playlists)        │
│  [Daily Feed - 10 Qs] ← Most important  │
│  [Top 20 Physics MCQ]                   │
│  [Revise Current Electricity]           │
│  [Your Weak Organic Chemistry]          │
│  ...3+ charts daily                     │
└─────────────────────────────────────────┘
```

### Subjects Display
- Shows subjects from user's uploaded/referenced questions
- Default view: filtered by chapters
- Inside chapter: filtered by topics
- Filters available: type, difficulty, importance

---

## Charts & Feeds (Spotify-like Playlists)

### Daily Feed
- The most important chart
- 10 personalized questions
- Part of the charts system

### Chart Generation
- 3+ personalized charts per user daily
- AI-curated based on user's patterns
- Naming: Mix of fixed templates ("Top 20 [Subject] MCQ") + AI-generated creative names

### Chart Types & Question Counts
- Daily Feed: 10 questions
- Topic review: ~20 questions
- Quick MCQ: ~5 questions
- AI adjusts based on user's available time/patterns

### Feed Algorithm
```
Signals collected:
├── User: uploads, solved/failed, time spent, difficulty ratings
├── Question: subject, chapter, topics, type, difficulty, popularity
└── Patterns: weak chapters, recent focus, confidence gaps

Algorithm weights (AI-adaptive):
├── 40% weak chapters (high fail rate)
├── 30% recent uploads/focus
├── 20% confidence builders
└── 10% important questions

AI adjusts these weights based on user's learning patterns
```

### Refresh Frequency
- Daily base generation
- Real-time adjustments (fail a question → affects recommendations)

---

## Solving & Progress Tracking

### Answer Verification
- **Numerical questions:** User enters answer, system verifies (sig fig tolerance)
- **Subjective/theory:** User marks "Solved" button

### After Solving
1. Rate difficulty (affects feed and question ranking)
2. Auto-track time spent
3. Smart struggled flag calculation

### Struggled Detection
```
Struggled = TRUE if:
├── Time exceeds threshold for question type:
│   ├── MCQ: > 2 minutes
│   ├── Short answer: > 5 minutes
│   ├── Long answer: > 15 minutes
│   └── Case study: > 20 minutes
├── OR user marks "Failed"
└── Thresholds adjusted by difficulty level
```

### Session Handling
- Auto-save progress
- "Continue where you left off?" prompt on return

---

## Spaced Repetition & Revision

### Classic Schedule
1 day → 3 days → 7 days → 14 days → 30 days

### Manual "Revise Later"
- Button on each question to add to "Revise Later" list
- Separate "Revise Later" chart that user manually curates
- Tagged questions appear more frequently in feeds

---

## Syllabus Management

### Preset Syllabus
- Class 11 & 12 syllabus tables with:
  - Subject
  - Chapter
  - Topics
  - Priority (for importance tagging)

### AI Extension
- AI uses syllabus for tagging (chapter, topic, importance, difficulty)
- If AI finds NEW subject/chapter/topic not in syllabus:
  1. Create in pending/draft table
  2. Human manual review
  3. Add to main syllabus if approved

### Caching
- Syllabuses cached (both AI-generated pending and human-approved)
- Performance optimization for frequent lookups

---

## Question Ownership & Editing

### Ownership
- Original uploader is owner
- Multiple users can be linked to same question
- Popularity = count of linked users

### Editing
- Full edit allowed (text, solution, tags, everything)
- Can use AI to help edit
- **Edits affect all linked users**

### Deletion
- Owner can delete
- If other users are linked:
  1. Ownership transfers (priority: most contributions > first linked > random)
  2. Other users keep access
- Solo questions: fully deleted

### Account Deletion
- User's contributions stay (anonymized)
- Questions and solutions remain in the system

---

## Cross-Subject Questions

- Physical Chemistry, Biochemistry, etc.
- **Pick primary subject only** (no multi-subject tagging)

---

## Abuse Prevention

1. **Daily upload limit** (e.g., 50/day)
2. **AI pre-check** - Validate it's a real question before full processing
3. **Rate limiting** for bulk operations
4. **Captcha** for suspicious activity

---

## Error Handling

### Gemini Fails
- Image unclear / API down / can't understand question
- **Fallback:** Manual entry mode (user types question themselves)

### Non-Question Uploads
- AI detects and rejects with message
- Notes feature is separate (skip for MVP)

---

## User Experience

### Upload Speed
- Target: <5 seconds from upload to ready
- Strategy: Quick preview first, full details load progressively

### Cold Start (New User)
- Empty state: "Upload your first question!"
- No sample/demo questions

### Onboarding
- Minimal - empty state with upload prompt

---

## Gamification

### Streaks
- Maintain by solving at least 1 question per day
- Push notification reminders

### Contributions
- "Your solutions helped X users" stats
- Visible on profile

### Profile Page Shows
- Basic stats (questions uploaded, solved, streak)
- Contribution stats
- Achievements/badges

---

## Technical Requirements

### Platform
- Both desktop and mobile
- Properly responsive
- Mobile-first (majority of user base)
- PWA support

### Offline Support
- Cached questions work offline
- Limited functionality (view saved)
- Sync when online

### Authentication
- Google login only

### Notifications
- Push notifications for daily practice reminders

### Search
- Text search
- Filters (subject, chapter, difficulty, type)
- AI semantic search with embeddings

### Export
- Full data export (PDF/JSON)
- Includes: question, solutions, tags, difficulty, all metadata
- Excludes: social data (popularity, collaborators)

### Language
- English only (initially)

---

## Tech Stack

```
FRONTEND: Next.js 15 (App Router) + TypeScript + Bun
STYLING: Tailwind CSS + shadcn/ui + Dark theme (default)
STATE: Zustand + React Query
DATABASE: Supabase (Postgres + Auth + Storage + pgvector)
AI: Gemini 1.5 Flash (Google AI Studio - FREE)
LATEX: KaTeX or MathJax
DEPLOYMENT: Vercel (frontend + API)
BUN: All package management + dev scripts
```

---

## Database Schema

```sql
-- Core questions table
CREATE TABLE questions (
  id TEXT PRIMARY KEY,
  owner_id TEXT REFERENCES auth.users,
  extracted_text TEXT,
  question_text TEXT NOT NULL, -- LaTeX formatted
  options JSONB DEFAULT '[]', -- MCQ only, LaTeX formatted
  type TEXT CHECK (type IN ('MCQ','VSA','SA','LA','CASE_STUDY')),
  has_diagram BOOLEAN DEFAULT false,
  image_url TEXT, -- Supabase Storage, deleted after 2 years if no diagram
  subject TEXT,
  chapter TEXT,
  topics JSONB DEFAULT '[]',
  difficulty TEXT CHECK (difficulty IN ('easy','medium','hard','very_hard')),
  importance INTEGER DEFAULT 3 CHECK (importance >= 1 AND importance <= 5),
  hint TEXT, -- AI-generated, user-tweakable
  embedding VECTOR(1536), -- pgvector for matching
  popularity INTEGER DEFAULT 1,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Solutions table (multiple per question)
CREATE TABLE solutions (
  id TEXT PRIMARY KEY,
  question_id TEXT REFERENCES questions,
  contributor_id TEXT REFERENCES auth.users,
  solution_text TEXT NOT NULL, -- LaTeX formatted
  numerical_answer TEXT, -- For numerical questions
  approach_description TEXT, -- Brief description of approach
  likes INTEGER DEFAULT 0,
  is_ai_best BOOLEAN DEFAULT false, -- AI's initial pick
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User-question links (who has this question in their bank)
CREATE TABLE user_questions (
  id TEXT PRIMARY KEY,
  user_id TEXT REFERENCES auth.users,
  question_id TEXT REFERENCES questions,
  is_owner BOOLEAN DEFAULT false,
  is_contributor BOOLEAN DEFAULT false, -- Added a solution
  added_at TIMESTAMPTZ DEFAULT NOW()
);

-- User solving stats
CREATE TABLE user_question_stats (
  id TEXT PRIMARY KEY,
  user_id TEXT REFERENCES auth.users,
  question_id TEXT REFERENCES questions,
  solved BOOLEAN DEFAULT false,
  failed BOOLEAN DEFAULT false,
  struggled BOOLEAN DEFAULT false,
  attempts INTEGER DEFAULT 0,
  time_spent INTEGER DEFAULT 0, -- seconds
  user_difficulty INTEGER CHECK (user_difficulty >= 1 AND user_difficulty <= 5),
  last_practiced_at TIMESTAMPTZ,
  next_review_at TIMESTAMPTZ, -- Spaced repetition
  in_revise_later BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- User profiles
CREATE TABLE user_profiles (
  id TEXT PRIMARY KEY,
  user_id TEXT REFERENCES auth.users UNIQUE,
  display_name TEXT,
  streak_count INTEGER DEFAULT 0,
  last_streak_date DATE,
  total_solved INTEGER DEFAULT 0,
  total_uploaded INTEGER DEFAULT 0,
  solutions_helped_count INTEGER DEFAULT 0, -- How many users used their solutions
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Syllabus (preset + AI extended)
CREATE TABLE syllabus (
  id TEXT PRIMARY KEY,
  class TEXT, -- '11', '12', or NULL for universal
  subject TEXT NOT NULL,
  chapter TEXT NOT NULL,
  topics JSONB DEFAULT '[]',
  priority INTEGER DEFAULT 3, -- For importance tagging
  is_verified BOOLEAN DEFAULT true, -- false for AI-added pending review
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Solution likes
CREATE TABLE solution_likes (
  id TEXT PRIMARY KEY,
  user_id TEXT REFERENCES auth.users,
  solution_id TEXT REFERENCES solutions,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, solution_id)
);

-- Revise later list
CREATE TABLE revise_later (
  id TEXT PRIMARY KEY,
  user_id TEXT REFERENCES auth.users,
  question_id TEXT REFERENCES questions,
  added_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, question_id)
);
```

---

## AI Prompts

### Question Extraction (Gemini)
```javascript
const extractionPrompt = `
Analyze this question image. Extract:

{
  "question_text": "Full question with LaTeX formatting (use $...$ for inline, $$...$$ for block)",
  "options": ["A) ...", "B) ..."], // empty [] if not MCQ, include LaTeX
  "type": "MCQ|VSA|SA|LA|CASE_STUDY",
  "has_diagram": true/false,
  "has_solution": true/false,
  "solution": "Solution with LaTeX formatting, empty string if none",
  "numerical_answer": "Final numerical answer if applicable, null otherwise",
  "subject": "Physics|Chemistry|Math|Biology|...",
  "chapter": "Chapter name from syllabus",
  "topics": ["topic1", "topic2"],
  "difficulty": "easy|medium|hard|very_hard",
  "importance": 1-5,
  "hint": "A helpful hint for solving (don't give away answer)"
}

Return ONLY valid JSON.
`;
```

### Duplicate Analysis (Gemini)
```javascript
const duplicateAnalysisPrompt = `
Compare these two questions:

Question A:
${questionA}

Question B:
${questionB}

Analyze:
1. Are they testing the SAME concept?
2. Is the solving approach the SAME?
3. Are there any tricky differences (different constraints, edge cases)?

Response:
{
  "same_concept": true/false,
  "same_approach": true/false,
  "differences": "Description of differences if any",
  "verdict": "SAME|DIFFERENT_APPROACH|DIFFERENT_QUESTION"
}
`;
```

### Chart Generation (Gemini)
```javascript
const chartGenerationPrompt = `
Generate personalized question charts for this user:

User stats:
- Weak chapters: ${weakChapters}
- Recent focus: ${recentSubjects}
- Struggle rate by topic: ${struggleRates}
- Available questions: ${questionSummary}

Generate 3-5 chart recommendations:
{
  "charts": [
    {
      "name": "Creative chart name",
      "description": "Why this chart helps",
      "question_ids": ["id1", "id2", ...],
      "count": 10
    }
  ]
}

Prioritize: 40% weak areas, 30% recent, 20% confidence builders, 10% important
`;
```

---

## Admin & Moderation

### Human Review
- Pending syllabus additions (AI-created) need human approval
- Handle manually via database initially
- Admin panel is a later feature

---

## Success Criteria

```
✅ Upload screenshot → <5s later: structured question with LaTeX
✅ Duplicate detection works accurately
✅ Multiple solutions per question with voting
✅ Daily Feed shows personalized questions
✅ Charts refresh daily with real-time adjustments
✅ Spaced repetition scheduling works
✅ Streaks and contribution stats tracked
✅ Offline viewing works (PWA)
✅ Export functionality complete
✅ Dark theme + mobile responsive
✅ Vercel deploy ready
```

---

## Development Workflow

```
1. Use Bun for ALL package management
2. TypeScript STRICT mode everywhere
3. Commit often with conventional commits
4. Build incrementally:
   - Phase 1: Auth + Upload + Basic storage
   - Phase 2: Duplicate detection + Solutions
   - Phase 3: Feeds + Charts
   - Phase 4: Gamification + Polish
```

---

## Environment Variables

```
NEXT_PUBLIC_SUPABASE_URL=...
NEXT_PUBLIC_SUPABASE_ANON_KEY=...
SUPABASE_SERVICE_ROLE_KEY=...
GOOGLE_API_KEY=... (Gemini from ai.google.dev - FREE)
```
