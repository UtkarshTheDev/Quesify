/**
 * TOON (Token-Oriented Object Notation) Utility Layer
 *
 * TOON is a compact, human-readable encoding for JSON that:
 * - Reduces token usage by 30-60% vs JSON
 * - Uses YAML-style indentation for objects
 * - Uses CSV-style tabular layout for arrays
 * - Has explicit [N] length markers and {fields} headers as guardrails
 */

import { encode, decode } from '@toon-format/toon'

/**
 * Encode data to TOON format for LLM input
 * Saves ~40% tokens compared to JSON
 */
export function toToon(data: unknown): string {
  return encode(data)
}

/**
 * Decode TOON format response from LLM to JSON
 * Uses strict mode to catch malformed output
 */
export function fromToon<T>(toonString: string, strict = true): T {
  return decode(toonString, { strict }) as T
}

/**
 * Extract TOON block from LLM response
 * Handles both fenced code blocks and raw TOON
 */
export function extractToonBlock(response: string): string {
  // 1. Try to extract from fenced code block
  const toonMatch = response.match(/```(?:toon|yaml|json|csv)?\s*\n?([\s\S]*?)```/)
  if (toonMatch) {
    return toonMatch[1].trim()
  }

  // 2. Try to find the first line that looks like a TOON key/header
  // Look for "key: ..." or "collection[N]{...}:"
  const lines = response.split('\n')
  const toonStartIndex = lines.findIndex(line =>
    /^[a-zA-Z_][a-zA-Z0-9_]*(?:\[[0-9]+\](?:\{[^}]+\})?)?:/.test(line.trim())
  )

  if (toonStartIndex !== -1) {
    // Return from the first TOON line to the end, but stop if we hit another code block
    const toonLines = lines.slice(toonStartIndex)
    const endOfBlock = toonLines.findIndex(line => line.trim().startsWith('```'))
    const finalLines = endOfBlock !== -1 ? toonLines.slice(0, endOfBlock) : toonLines
    return finalLines.join('\n').trim()
  }

  // 3. Last fallback: return cleaned response
  return response
    .replace(/^Here is the (?:TOON|data|result).*?:/i, '')
    .replace(/^```\w*/i, '')
    .replace(/```$/i, '')
    .trim()
}

/**
 * Robustly repairs backslashes and newlines in quoted strings
 * Turns invalid escapes like \i or \f (LaTeX) into \\i or \\f
 * Also turns literal newlines into \n to prevent parsing crashes
 */
export function repairBackslashes(str: string): string {
  let fixed = ''
  let inString = false
  let stringChar = ''

  for (let i = 0; i < str.length; i++) {
    const char = str[i]

    if (inString) {
      if (char === '\\') {
        const nextChar = str[i + 1]
        // Only allow very specific escapes that are unlikely to be LaTeX
        // We preserve \\ and \" and \'
        if (nextChar === '\\' || nextChar === stringChar) {
          fixed += char + nextChar
          i++
        }
        // Handle \uXXXX if it looks like one
        else if (nextChar === 'u' && /^[0-9a-fA-F]{4}/.test(str.substring(i + 2, i + 6))) {
          fixed += char + str.substring(i + 1, i + 6)
          i += 5
        }
        else {
          // Everything else (including \n, \t, \r, \i, \f) is escaped for LaTeX safety
          fixed += '\\\\'
        }
      } else if (char === '\n') {
        fixed += '\\n'
      } else if (char === '\t') {
        fixed += '\\t'
      } else if (char === stringChar) {
        inString = false
        fixed += char
      } else {
        fixed += char
      }
    } else {
      if (char === '"' || char === "'") {
        inString = true
        stringChar = char
      }
      fixed += char
    }
  }
  return fixed
}

/**
 * Parse TOON response from LLM with error handling
 */
export function parseToonResponse<T>(response: string): T {
  const toonBlock = extractToonBlock(response)

  if (!toonBlock) {
    throw new Error('Could not find TOON or JSON content in the AI response.')
  }

  // Define parsing attempts
  const attempts = [
    { name: 'Strict TOON', fn: () => fromToon<T>(toonBlock, true) },
    { name: 'Lenient TOON', fn: () => fromToon<T>(toonBlock, false) },
    { name: 'Repaired + Lenient TOON', fn: () => fromToon<T>(repairBackslashes(toonBlock), false) },
    { name: 'JSON Recovery', fn: () => repairAndParseJson<T>(toonBlock) },
  ]

  let lastError: any = null

  for (const attempt of attempts) {
    try {
      if (attempt.name === 'JSON Recovery') console.warn('⚠️ TOON parsing failed. Attempting JSON recovery...')
      return attempt.fn()
    } catch (error) {
      lastError = error
      // Continue to next attempt
    }
  }

  // All attempts failed
  console.group('TOON/JSON Parse Critical Failure')
  console.error('Original Response:', response)
  console.error('Extracted Block:', toonBlock)
  console.error('Last Error:', lastError)
  console.groupEnd()

  throw new Error(`Failed to parse AI response as TOON or JSON. ${lastError?.message || 'Unknown error'}`)
}

/**
 * Robust JSON parser that handles common LLM errors like
 * - LaTeX backslashes (\frac instead of \\frac)
 * - Newlines in strings
 * - TOON-style headers (key[N]:)
 */
export function repairAndParseJson<T>(jsonString: string): T {
  let cleaned = jsonString.trim()

  // 0. Strip comments (// ...)
  cleaned = cleaned.replace(/\/\/.*$/gm, '')

  // 1. Convert TOON headers to JSON keys
  // Handle key[N]: or key[N]{a,b,c}:
  cleaned = cleaned.replace(/^(\s*)([a-zA-Z0-9_]+)(?:\[[0-9]*\])?(?:\{[^}]*\})?(\s*):/gm, '$1"$2"$3:')

  // 2. Quote simple keys that might have been missed
  cleaned = cleaned.replace(/^(\s*)([a-zA-Z0-9_]+)(\s*):/gm, '$1"$2"$3:')

  // 3. Quote unquoted string values (risky but often needed for short values)
  cleaned = cleaned.replace(/"([a-zA-Z0-9_]+)"\s*:\s*([a-zA-Z0-9_]+)(?!\s*")/g, (match, key, val) => {
    if (['true', 'false', 'null'].includes(val)) return match
    if (!isNaN(Number(val))) return match
    return `"${key}": "${val}"`
  })

  // 4. Insert missing commas between key-value pairs
  cleaned = cleaned.replace(/([\}\]"0-9]|true|false|null)\s*"\s*([a-zA-Z0-9_]+)"/g, '$1, "$2"')
  cleaned = cleaned.replace(/([\}\]"0-9]|true|false|null)\s*\n\s*"/g, '$1,\n"')

  // 5. Remove trailing commas
  cleaned = cleaned.replace(/,\s*([\]\}])/g, '$1')

  // 6. Ensure it's wrapped in braces
  if (!cleaned.trim().startsWith('{')) {
    cleaned = `{${cleaned}}`
  }

  try {
    return JSON.parse(repairBackslashes(cleaned)) as T
  } catch (e) {
    // Last ditch: just try to parse the repaired string directly
    throw e
  }
}

/**
 * Format syllabus data as TOON for AI prompts
 * Much more compact than JSON representation
 */
export function formatSyllabusAsToon(
  syllabusData: Record<string, { subject: string; chapters: Array<{ chapter: string; topics: string[]; priority: number }> }>
): string {
  // Convert to flat array format that's ideal for TOON
  const allChapters: Array<{
    subject: string
    chapter: string
    topics: string
    priority: number
  }> = []

  for (const [subject, data] of Object.entries(syllabusData)) {
    for (const ch of data.chapters) {
      allChapters.push({
        subject,
        chapter: ch.chapter,
        topics: ch.topics.join('; '), // Semicolon-separated for CSV compatibility
        priority: ch.priority
      })
    }
  }

  return toToon({ syllabus: allChapters })
}
