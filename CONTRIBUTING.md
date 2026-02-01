# Contributing to Quesify

Thank you for considering contributing to Quesify! It's people like you that make Quesify a great tool for students.

## How Can I Contribute?

### Reporting Bugs
*   Ensure the bug was not already reported by searching on GitHub under [Issues](https://github.com/UtkarshTheDev/Quesify/issues).
*   If you're unable to find an open issue addressing the problem, [open a new one](https://github.com/UtkarshTheDev/Quesify/issues/new).

### Suggesting Enhancements
*   Check if the enhancement has already been suggested.
*   Clearly describe the suggestion, including why it would be useful.

### Pull Requests
1.  **Fork** the repo and create your branch from `main`.
2.  If you've added code that should be tested, **add tests**.
3.  Ensure the test suite passes.
4.  Make sure your code follows the **Strict TypeScript** guidelines.
5.  Use **Conventional Commits**.

## Development Workflow

### 1. Setup
```bash
git clone https://github.com/your-username/quesify.git
cd quesify
bun install
```

### 2. Branching
```bash
git checkout -b feat/your-awesome-feature
# OR
git checkout -b fix/some-annoying-bug
```

### 3. Commit Style
We use [Conventional Commits](https://www.conventionalcommits.org/):
*   `feat: ...` for new features.
*   `fix: ...` for bug fixes.
*   `docs: ...` for documentation changes.
*   `refactor: ...` for code changes that neither fix a bug nor add a feature.

## Coding Standards

*   **Strict Types:** No `any`. Use interfaces and types for everything.
*   **Aesthetic UI:** Follow the project's minimalist, dark-themed design language.
*   **Mobile First:** Ensure every component looks and works great on small screens.
*   **Performance:** Optimize database queries and leverage Redis caching where appropriate.

## Tech Stack Reminder
*   **Runtime:** Bun
*   **Framework:** Next.js 15
*   **Database:** Supabase
*   **AI:** Gemini 2.0
*   **Styling:** Tailwind CSS + Framer Motion

Thank you for being part of the community! 🚀
