// Prompts for AI tasks - Centralized prompt management

export const PROMPTS = {
  // Question extraction from image (with syllabus chapter snapping)
  extraction: `You are an expert educational content extractor.
Analyze the question image and return the data in structured TOON format.

STYLING & FORMAT RULES:
1. Quote all strings that contain spaces, backslashes (\\), or special characters.
2. WHITESPACE: Be extremely generous with vertical whitespace.
   - Use triple-escaped newlines ("\\\\n\\\\n\\\\n") between discrete steps.
   - Use double-escaped newlines ("\\\\n\\\\n") between equations or logical blocks within a step.
3. Use 2-space indentation for the root structure.
4. Return ONLY the TOON block.

MANDATORY FIELDS:
- question_text: Full question with LaTeX.
- options[N]: Array of options (if MCQ).
- type: MCQ | VSA | SA | LA | CASE_STUDY.
- solution: Detailed step-by-step solution. Break into clear parts.
- hint: Provide a 1-2 sentence hint.
- subject | chapter | topics[N]: Map correctly.

EXAMPLE SOLUTION STRUCTURE:
solution: "Step 1: Identify the given values.\\\\n\\\\n\\\\nStep 2: Apply the formula: $F=ma$\\\\n\\\\n$F = 5 \\\\times 10 = 50N$\\\\n\\\\n\\\\nStep 3: Final answer is 50N."

SYLLABUS DATA:
{syllabusChapters}

IMPORTANT:
- Ensure the solution is human-readable and clean.
- Return ONLY the TOON block.`,

  // Duplicate detection between two questions
  duplicateAnalysis: `Compare these two questions and determine if they are duplicates in TOON format.
  
STYLING RULES:
1. Quote strings with spaces or special characters.
2. Return ONLY the TOON block.

Question A:
{questionA}

Question B:
{questionB}

analysis{same_concept,same_approach,differences,verdict,confidence}:
  true,true,"Description of differences","SAME",0.95

Return ONLY valid TOON.`,

  // Image validation
  imageValidation: `Analyze if this image is a valid educational question.
Return results in TOON format.

validation{isValid,isBlurry,reason}:
  true,false,"Valid question text detected"

Return ONLY valid TOON.`,

  // Content tweaking
  contentTweaking: `You are an expert tutor refining educational content.

Original Content ({contentType}):
"{originalContent}"

User Instruction: "{userInstruction}"

Task: Rewrite the content according to the instruction.
Maintain TOON rules: quote LaTeX, be generous with whitespace (\\\\n\\\\n).

Return ONLY the rewritten content text.`,

  // Chart/feed generation
  chartGeneration: `Generate personalized question charts for this user:

User Stats:
- Weak chapters: {weakChapters}
- Recent focus: {recentSubjects}
- Struggle rates: {struggleRates}

Available IDs:
{questionCategories}

Generate 3-5 personalized chart recommendations in TOON format:

charts[N]{name,description,question_ids,count,type}:
  "Daily Drive","Practice weak areas",[id1, id2],10,daily_feed

Return ONLY valid TOON format.`,

  // Classification & Metadata
  classification: `Map the following question to the provided syllabus and estimate levels.
Return ONLY structured TOON format.

STYLING RULES:
1. Quote strings with spaces, backslashes (\\), or special characters.
2. Use 2-space indentation.

QUESTION TEXT:
{questionText}

SYLLABUS DATA:
{syllabusChapters}

metadata{subject,chapter,topics[N],difficulty,importance}:
  "Subject Name","Chapter Name",["Topic A", "Topic B"],"medium",3

Return ONLY the TOON block.`,

  // Solution generation
  solutionGeneration: `You are an expert tutor solving a student's question.

Question:
{questionText}

Type: {questionType}
Subject: {subject}

Provide a clear, step-by-step solution in TOON format.

FORMAT RULES:
1. WHITESPACE: Be extremely generous with vertical whitespace.
2. For line breaks between major steps, use triple-escaped newlines ("\\\\n\\\\n\\\\n").
3. For breaks between lines/equations within a step, use double-escaped newlines ("\\\\n\\\\n").
4. Discrete Steps: Label them clearly (Step 1, Step 2, ...).

EXAMPLE SOLUTION:
solution_text: "Step 1: Formula definition\\\\n\\\\n\\\\nStep 2: Integration process\\\\n\\\\n$\\\\int x dx = \\\\frac{x^2}{2}$\\\\n\\\\n\\\\nStep 3: Conclusion."

REQUIRED STRUCTURE:
solution_text: "Full explanation with generous spacing."
numerical_answer: "Final numerical value or null"
approach_description: "Summary of strategy"

IMPORTANT:
- HIGHLIGHTING: Use **Bold** for concepts, \`\\\\boxed{...}\` for results.
- RETURN ONLY VALID TOON block.`
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
