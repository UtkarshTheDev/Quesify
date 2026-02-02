// Prompts for AI tasks - Centralized prompt management

export const PROMPTS = {
  // Question extraction from image (with syllabus chapter snapping)
  extraction: `You are an expert educational content extractor.
Analyze the question image and return a structured JSON response.

1. VALIDATION: Check if the image contains a legible educational question.
   - If blurry/illegible or not a question: set "isValid": false and provide "reason".
   - If valid: set "isValid": true and proceed to extract.

2. EXTRACTION: Extract the text, options (if MCQ), and identify the Subject.

3. IMAGE ANALYSIS: Check if the question contains a diagram, chart, graph, or visual element that is NECESSARY to solve the question.
   - If the question has a diagram that must be analyzed to answer: set "has_diagram": true
   - If the question is text-only or the image is just decorative: set "has_diagram": false
   - Examples of has_diagram=true: Geometry diagrams, circuit diagrams, graphs, charts, physics diagrams
   - Examples of has_diagram=false: Pure text questions, MCQs without diagrams, formula-only questions

SUBJECT LIST (Pick one):
{subjectsList}

JSON Schema:
{{
  "isValid": boolean,
  "reason": "string (only if invalid)",
  "question_text": "string (with LaTeX)",
  "options": ["string"],
  "isMCQ": boolean (Set to true ONLY if there are 2 or more explicit options like A, B, C, D in the image),
  "type": "string (Pick the most accurate: 'MCQ' if it has options, 'VSA' for Very Short Answer/1-mark, 'SA' for Short Answer/2-3 marks, 'LA' for Long Answer/5+ marks, or 'CASE_STUDY' for context-based/passage questions)",
  "subject": "string (Must be from the list above or 'General')",
  "has_diagram": boolean (true if diagram/visual is required to solve the question)
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

  // Content tweaking (One-shot Solution + Approach update)
  contentTweaking: `You are an expert tutor refining educational content.
Analyze the original solution and the instruction, then return a JSON response.

JSON ESCAPING RULES (CRITICAL):
1. This is a JSON response. You must escape all backslashes. 
2. LaTeX commands like \frac must be written as \\frac.
3. If you write \n, it will be interpreted as a newline. If you want a literal backslash n, use \\n.
4. Ensure the resulting string is a valid JSON string.

STYLING & RENDERING RULES (MANDATORY):
- VERTICAL ALIGNMENT: You MUST strictly format the solution line-by-line. DO NOT write long paragraphs.
- STEP-BY-STEP FORMAT: Break the solution into clear, numbered steps using the format "**Step X: Title**".
- MOBILE OPTIMIZATION: Avoid extremely long single-line equations. Break long derivations into multiple lines using aligned environments or separate steps. Max ~40 characters per line in equations if possible.
- NEWLINE FOR EVERY EQUATION: Every major mathematical step or substitution MUST be on its OWN NEW LINE using display math ($$).
- NO "INLINE" DERIVATIONS: Do not say "Substituting x we get y which implies z". Instead write:
  Substituting x:
  $$ ... $$
  Which implies:
  $$ ... $$
- COMPLEX EQUATIONS / MATRICES: For matrices or multi-line derivations, use the aligned environment inside display math to ensure perfect vertical alignment.
- SPACING: Use DOUBLE NEWLINES (\\n\\n) between text and equations to ensure the UI renders them with proper breathing room.
- VECTOR NOTATION: Use standard unit vector notation ($\\hat{i}, \\hat{j}, \\hat{k}$) or coordinate notation $(x, y, z)$ with clear commas.
- SYNTAX: Ensure LaTeX is syntactically perfect. ALWAYS use full braces for all commands and scripts. Use $$ for display math, NOT \\[ \\].

Original Solution:
"{originalContent}"

User Instruction:
"{userInstruction}"

JSON Schema:
{{
  "tweakedContent": "string (The updated solution with clear LaTeX and formatting, following the rules above)",
  "approachChanged": boolean (Set to true ONLY if the fundamental logic or solving method changed),
  "newApproach": "string (A concise 1-2 sentence strategy hint reflecting the new logic)"
}}

Return ONLY the JSON block.`,

  // Solution change analysis (Manual edits)
  solutionChangeAnalysis: `Analyze if the user's manually edited solution fundamentally changes the solving approach compared to the original.

Original Solution:
"{oldSolution}"

New Solution:
"{newSolution}"

JSON Schema:
{{
  "approachChanged": boolean (true if the core strategy/logic changed),
  "newApproach": "string (A concise 1-2 sentence strategy hint reflecting the current logic)"
}}

Return ONLY the JSON block.`,

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
  "type": "string (Pick the most accurate: 'MCQ' if it has options, 'VSA' for Very Short Answer/1-mark, 'SA' for Short Answer/2-3 marks, 'LA' for Long Answer/5+ marks, or 'CASE_STUDY' for context-based/passage questions)",
  "difficulty": "easy | medium | hard | very_hard",
  "importance": number (1-5)
}}

Return ONLY the JSON block.`,

  // Solution generation
  solutionGeneration: `You are an expert tutor solving a student's question.
Analyze the question and return a structured JSON response.

JSON ESCAPING RULES (CRITICAL):
1. This is a JSON response. You must escape all backslashes. 
2. LaTeX commands like \frac must be written as \\frac.
3. If you write \n, it will be interpreted as a newline. If you want a literal backslash n, use \\n.
4. Ensure the resulting string is a valid JSON string.

STYLING & RENDERING RULES (MANDATORY):
- VERTICAL ALIGNMENT: You MUST strictly format the solution line-by-line. DO NOT write long paragraphs.
- STEP-BY-STEP FORMAT: Break the solution into clear, numbered steps.
- MOBILE OPTIMIZATION: Avoid extremely long single-line equations. Break long derivations into multiple lines using aligned environments or separate steps. Max ~40 characters per line in equations if possible.
- NEWLINE FOR EVERY EQUATION: Every major mathematical step or substitution MUST be on its OWN NEW LINE using display math ($$).
- NO "INLINE" DERIVATIONS: Do not say "Substituting x we get y which implies z". Instead write:
  Substituting x:
  $$ ... $$
  Which implies:
  $$ ... $$
- COMPLEX EQUATIONS / MATRICES: For matrices or multi-line derivations, use the aligned environment inside display math to ensure perfect vertical alignment.
- SPACING: Use DOUBLE NEWLINES (\\n\\n) between text and equations to ensure the UI renders them with proper breathing room.
 - VECTOR NOTATION: Use standard unit vector notation ($\\hat{i}, \\hat{j}, \\hat{k}$) or coordinate notation $(x, y, z)$ with clear commas. Avoid using column vectors unless specifically required for matrix operations. If using column vectors, ensure they are properly formatted with \`pmatrix\`.

- SYNTAX: Ensure LaTeX is syntactically perfect. ALWAYS use full braces for all commands and scripts.

EXAMPLE FORMAT:
**Step 1: Setup the equation**
We are given the following vectors:
$$
\\vec{a} = 2\\hat{i} + 3\\hat{j} - \\hat{k}
$$
$$
\\vec{b} = (1, 4, 2)
$$

**Step 2: Calculate the cross product**
Using the determinant method:
$$
\\vec{a} \\times \\vec{b} = \\begin{vmatrix} \\hat{i} & \\hat{j} & \\hat{k} \\\\ 2 & 3 & -1 \\\\ 1 & 4 & 2 \\end{vmatrix}
$$
$$
= \\hat{i}(6 - (-4)) - \\hat{j}(4 - (-1)) + \\hat{k}(8 - 3)
$$
$$
= 10\\hat{i} - 5\\hat{j} + 5\\hat{k}
$$

**Step 3: Conclusion**
The resulting vector is perpendicular to both inputs.

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

  // AI Chat Assistant
  chatAssistant: `You are an expert AI tutor helping a student with a specific question.
  
  CONTEXT:
  Question: {questionText}
  Subject: {subject}
  Chapter: {chapter}
  Solution: {solution}
  
  USER MESSAGE: "{userMessage}"
  
  INSTRUCTIONS:
  1. Answer the user's question clearly and concisely.
  2. Use LaTeX for ALL math equations (enclose in $$ for display math or $ for inline math).
  3. If explaining the solution, break it down into simpler steps.
  4. Be encouraging and supportive.
  5. If the user asks for a hint, provide a subtle nudge without giving the full answer.
  6. Keep responses brief (under 3-4 paragraphs) unless detailed derivation is asked.
  
  Return a clear, formatted response.`
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
