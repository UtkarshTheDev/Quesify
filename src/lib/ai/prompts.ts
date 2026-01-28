// Prompts for AI tasks - Centralized prompt management

export const PROMPTS = {
  // Question extraction from image (with syllabus chapter snapping)
  extraction: `You are an expert educational content extractor.
Analyze the question image and return a structured JSON response.

1. VALIDATION: Check if the image contains a legible educational question.
   - If blurry/illegible or not a question: set "isValid": false and provide "reason".
   - If valid: set "isValid": true and proceed to extract.

2. EXTRACTION: Extract the text, options (if MCQ), and identify the Subject.

SUBJECT LIST (Pick one):
{subjectsList}

JSON Schema:
{{
  "isValid": boolean,
  "reason": "string (only if invalid)",
  "question_text": "string (with LaTeX)",
  "options": ["string"],
  "type": "MCQ | VSA | SA | LA | CASE_STUDY",
  "subject": "string (Must be from the list above or 'General')"
}}

Return ONLY the JSON block.`,

  // Duplicate detection between two questions
  duplicateAnalysis: `Compare these two questions and their solution approaches to determine if they are duplicates.
Return a JSON response.

QUESTION A:
{questionA}

SOLUTION A:
{solutionA}

QUESTION B:
{questionB}

SOLUTION B:
{solutionB}

JSON Schema:
{{
  "same_concept": boolean,
  "same_approach": boolean,
  "differences": "string (Explain EXACTLY what is different. If identical, say 'Both question and solution are identical.')",
  "verdict": "SAME | DIFFERENT_APPROACH | DIFFERENT_QUESTION",
  "confidence": number (0-1)
}}

VERDICT RULES:
- SAME: Questions are identical or effectively identical (even with minor phrasing changes), and the solution approach is the same.
- DIFFERENT_APPROACH: The question is the same (identical concept and parameters), but the solution approach (the logic, steps, or method) is fundamentally different.
- DIFFERENT_QUESTION: The questions themselves are different (different numbers, different constraints, or different concepts).

Return ONLY the JSON block.`,

  // Image validation
  imageValidation: `Analyze if this image is a valid educational question.
Return a JSON response.

JSON Schema:
{{
  "isValid": boolean,
  "isBlurry": boolean,
  "reason": "string"
}}

Return ONLY the JSON block.`,

  // Content tweaking
  contentTweaking: `You are an expert tutor refining educational content.

Original Content ({contentType}):
"{originalContent}"

User Instruction: "{userInstruction}"

Task: Rewrite the content according to the instruction.
Maintain clear LaTeX formatting and generous whitespace.

Return ONLY the rewritten content text.`,

  // Chart/feed generation
  chartGeneration: `Generate personalized question recommendations.
Return a JSON response.

User Context:
- Weak: {weakChapters}
- Focus: {recentSubjects}

Available IDs:
{questionCategories}

JSON Schema:
{{
  "charts": [
    {{
      "name": "string",
      "description": "string",
      "question_ids": ["string"],
      "count": number,
      "type": "daily_feed | topic_review | quick_mcq | weak_areas"
    }}
  ]
}}

Return ONLY the JSON block.`,

  // Classification & Metadata
  classification: `Map the question to the syllabus and estimate levels.
Return a JSON response.

QUESTION TEXT:
{questionText}

SYLLABUS DATA:
{syllabusChapters}

JSON Schema:
{{
  "subject": "string",
  "chapter": "string",
  "topics": ["string"],
  "difficulty": "easy | medium | hard | very_hard",
  "importance": number (1-5)
}}

Return ONLY the JSON block.`,

  // Solution generation
  solutionGeneration: `You are an expert tutor solving a student's question.
Analyze the question and return a structured JSON response.

JSON ESCAPING RULES (CRITICAL):
1. All backslashes for LaTeX MUST be double-escaped (e.g., use "\\\\int" instead of "\\int" and "\\\\pi" instead of "\\pi").
2. Use "\\n" for newline within the solution text.

STYLING & RENDERING RULES (MANDATORY):
- OPTION NUMBERING: In the "solution_text", always refer to options starting from 1 (e.g., **Option 1**, **Option 2**). Never use "Option 0".
- RESULTS: Provide ONLY the raw mathematical result (or the most simplified form) within the "numerical_answer" field. NEVER use \\\\boxed{{}} anywhere. 
- BOLD: Put major headings, step titles (e.g., **Step 1:**), and key properties in **bold**.
- MATH: ALWAYS wrap ALL mathematical expressions, variables, formulas, and results in valid LaTeX delimiters ($ or $$).
- SYNTAX: Ensure LaTeX is syntactically perfect. ALWAYS use full braces for all commands and scripts (e.g., \\\\frac{{a}}{{b}} NOT \\\\frac ab, and \\\\log_{{e}} NOT \\\\log_e).

QUESTION TEXT:
{questionText}

OPTIONS (if MCQ):
{options}

QUESTION TYPE: {questionType}
SUBJECT: {subject}

JSON Schema:
{{
  "solution_text": "string (Detailed step-by-step with LaTeX)",
  "numerical_answer": "string | null",
  "correct_option": number | null (CRITICAL: 0-indexed integer of correct option for code processing),
  "avg_solve_time": number (Estimated time in SECONDS for an average student to solve this question),
  "approach_description": "string (Short summary of strategy used)"
}}

Return ONLY the JSON block.`,

  // Sync approach from solution
  approachSync: `Based on this detailed solution, write a concise "Strategy Hint" (1-2 sentences) that explains the core concept or the "trick" used to solve it. 
Do not give away the final answer.

SOLUTION:
"{solutionText}"

Return ONLY the concise hint text.`,
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
