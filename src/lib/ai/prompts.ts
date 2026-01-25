// Prompts for AI tasks - Centralized prompt management

export const PROMPTS = {
  // Question extraction from image
  extraction: `You are analyzing a question image for a student question bank app.

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
- Return ONLY valid JSON, no markdown or explanation`,

  // Duplicate detection between two questions
  duplicateAnalysis: `Compare these two questions and determine if they are duplicates:

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

Return ONLY valid JSON.`,

  // Image validation
  imageValidation: `Is this image a valid educational question (from a textbook, exam, worksheet, etc.)?

Return JSON:
{
  "isValid": true | false,
  "isBlurry": true | false,
  "reason": "Brief explanation if invalid"
}

Return ONLY valid JSON.`,

  // Chart/feed generation
  chartGeneration: `Generate personalized question charts for this user:

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

Return ONLY valid JSON.`,

  // Solution generation
  solutionGeneration: `You are an expert tutor solving a student's question.

Question:
{questionText}

Type: {questionType}
Subject: {subject}

Provide a clear, step-by-step solution.

Return JSON:
{
  "solution_text": "Full explanation in LaTeX. Break down into steps. Use $...$ for inline math and $$...$$ for block math.",
  "numerical_answer": "Final numerical value if applicable, or null",
  "approach_description": "One sentence summary of the strategy used (e.g. 'Conservation of Energy', 'Integration by parts')"
}

IMPORTANT:
- Use proper LaTeX for all math
- Be educational - explain the 'why', not just the 'how'
- Return ONLY valid JSON`,
} as const

// Helper to replace placeholders in prompts
export function formatPrompt(
  prompt: string,
  replacements: Record<string, string>
): string {
  let formatted = prompt
  for (const [key, value] of Object.entries(replacements)) {
    formatted = formatted.replace(new RegExp(`\\{${key}\\}`, 'g'), value)
  }
  return formatted
}
