<div align="center">
  <img src="./showcase.png" alt="Quesify Showcase" style="border-radius: 20%;" />
  <h3>Quesify - AI-Powered Universal Question Bank</h3>
  <p><strong>Organize • Practice • Master</strong></p>
  
  <p>The ultimate study companion that transforms scattered screenshots into a structured, AI-driven learning engine.</p>

  <p>
    <a href="#key-features">Key Features</a> •
    <a href="#tech-stack">Tech Stack</a> •
    <a href="#getting-started">Getting Started</a> •
    <a href="#contributing">Contributing</a> •
    <a href="#license">License</a>
  </p>

  <div>
    <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License" />
    <img src="https://img.shields.io/badge/Next.js-15-black" alt="Next.js" />
    <img src="https://img.shields.io/badge/TypeScript-Strict-blue" alt="TypeScript" />
    <img src="https://img.shields.io/badge/Bun-1.3.2-f472b6" alt="Bun" />
    <img src="https://img.shields.io/badge/Supabase-Database-green" alt="Supabase" />
    <img src="https://img.shields.io/badge/AI-Gemini_2.0-8e44ad" alt="AI" />
  </div>
</div>

## Key Features

Quesify isn't just storage—it's an active learning partner. It bridges the gap between chaotic study materials and structured academic mastery.

### 🧠 Intelligent Capture
*   **Zero Typing Needed:** Upload a screenshot, and our AI instantly extracts questions, options, and diagrams into perfectly formatted LaTeX.
*   **Auto-Tagging:** Automatically detects subject, chapter, topic, and difficulty levels.
*   **Smart Deduplication:** Identifies existing questions in the global bank to prevent clutter.

### 📚 Personalized Learning
*   **Daily Practice Feeds:** A curated "Daily Mix" targeting your weak areas and spacing out revisions.
*   **Spaced Repetition:** Built-in scheduling ensures you review concepts right before you forget them.
*   **Performance Analytics:** Tracks solving speed and accuracy to adapt future recommendations.

### 🤝 Collaborative Ecosystem
*   **Community Solutions:** Explore multiple approaches to the same problem from peers worldwide.
*   **Strategic AI Hints:** Get a tactical nudge without revealing the full answer.
*   **Peer Validation:** Upvote and verify the best explanations and solutions.

### 📱 Premium Experience
*   **Aesthetic UI:** A clean, modern, and dark-themed interface designed for focus.
*   **Mobile-First & PWA:** Seamless experience on any device, installable as a native app.
*   **Fast & Scalable:** Powered by Bun and Redis for near-instant response times.

## Tech Stack

| Component | Technology |
|-----------|------------|
| **Framework** | [Next.js 15](https://nextjs.org/) (App Router) |
| **Runtime** | [Bun](https://bun.sh) |
| **Database** | [Supabase](https://supabase.com/) (Postgres + pgvector) |
| **AI Engine** | Google Gemini 2.0 Flash |
| **Caching** | Redis (Upstash) |
| **State** | Zustand + TanStack Query |
| **Styling** | Tailwind CSS + shadcn/ui + Framer Motion |
| **Math** | KaTeX (Fast LaTeX rendering) |

## Getting Started

### Prerequisites
*   **Bun** (v1.3.2 or later)
*   **Supabase** project and credentials
*   **Google AI Studio** API key (for Gemini)
*   **Upstash Redis** credentials

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/UtkarshTheDev/Quesify.git
    cd Quesify
    ```

2.  **Install dependencies**
    ```bash
    bun install
    ```

3.  **Environment Setup**
    Create a `.env.local` file in the root:
    ```bash
    cp .env.example .env.local
    ```
    Populate it with your keys:
    ```env
    NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
    NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
    SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
    GOOGLE_API_KEY=your_gemini_api_key
    UPSTASH_REDIS_REST_URL=your_redis_url
    UPSTASH_REDIS_REST_TOKEN=your_redis_token
    ```

4.  **Database Configuration**
    Run the migrations in your Supabase SQL Editor in order:
    *   `supabase/migrations/01_setup_and_enums.sql`
    *   `supabase/migrations/02_tables_and_indexes.sql`
    *   `supabase/migrations/03_functions_and_triggers.sql`
    *   `supabase/migrations/04_rls_and_seed.sql`

5.  **Run Development Server**
    ```bash
    bun run dev
    ```
    Visit `http://localhost:3000` to start practicing.

## Contributing

We love contributions! Whether you're fixing a bug, improving documentation, or proposing a new feature.

1.  Check the [Contributing Guide](CONTRIBUTING.md).
2.  Follow the **Conventional Commits** standard.
3.  Ensure code is linted and typed.

## License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

<div align="center">
  <p>Built with ❤️ by students, for students.</p>
</div>
