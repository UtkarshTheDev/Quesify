# Quesify - Project Overview

## Project Description

Quesify is an AI-powered universal question bank platform that transforms scattered study materials into a structured, intelligent learning engine.

## Core Features

- 🤖 **AI Question Extraction**: Upload screenshots, get structured LaTeX questions
- 🔍 **Semantic Search**: Find similar questions using embeddings
- 💡 **AI Solutions**: Generate solutions with step-by-step explanations
- 📚 **Personalized Practice**: Daily feeds targeting weak areas
- 🏆 **Community**: Collaborative solutions and peer validation

## Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | Next.js 15 (App Router) |
| Runtime | Bun |
| Database | Supabase (Postgres + pgvector) |
| AI Engine | Google Gemini / Groq |
| Caching | Upstash Redis |
| State | Zustand + TanStack Query |
| Styling | Tailwind CSS + shadcn/ui |
| Math | KaTeX |

## Architecture Overview

```
Frontend (Next.js)
  ├── AI Client (Gemini/Groq)
  ├── Supabase Client
  ├── State Management (Zustand)
  └── UI Components

Backend (Next.js API Routes)
  ├── Question Upload & Processing
  ├── Solution Generation
  ├── Semantic Search
  └── User Management

Database (Supabase)
  ├── Questions (with embeddings)
  ├── Solutions
  ├── User Profiles
  └── User Statistics

External Services
  ├── Google Gemini (AI/Embeddings)
  ├── Groq (Fast Inference)
  └── Upstash Redis (Caching)
```

## Key Decisions

### AI Provider Strategy
- **Vision/Fast tasks**: Groq (Llama 3.3 70B) - Speed priority
- **Reasoning/Updates**: Gemini (Gemini 2.5 Flash) - Quality priority
- **Embeddings**: Gemini (gemini-embedding-001) - Best semantic quality

### Database Design
- pgvector for embedding storage
- HNSW indexes for fast similarity search
- Row-level security for data protection

### Embedding Strategy
- 3072 dimensions (gemini-embedding-001)
- Task type optimization (document vs query)
- Cosine similarity for matching

## Current Status

See `.planning/ROADMAP.md` for current phase and progress.

## Documentation

- `.planning/ROADMAP.md` - Project roadmap and phases
- `.planning/phases/` - Detailed phase plans
- `.planning/codebase/` - Architecture and conventions

## Conventions

- **Commits**: Conventional commits format
- **Code Style**: Strict TypeScript, ESLint enforced
- **Styling**: Tailwind with shadcn/ui components
- **Testing**: Manual verification for features
