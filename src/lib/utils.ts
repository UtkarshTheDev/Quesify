import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function stripBoxed(str: string): string {
  if (!str) return ""
  const match = str.match(/\\boxed\{/)
  if (!match) return str
  const start = (match.index || 0) + 7
  let count = 1
  let end = start
  while (count > 0 && end < str.length) {
    if (str[end] === "{") count++
    else if (str[end] === "}") count--
    end++
  }
  if (count === 0) {
    const content = str.slice(start, end - 1)
    const before = str.slice(0, match.index)
    const after = str.slice(end)
    return stripBoxed(before + content + after)
  }
  return str
}

/**
 * Format seconds into a human-readable duration string
 * Examples: 45s, 2m 30s, 1h 15m
 */
export function formatDuration(seconds: number): string {
  if (!seconds || seconds <= 0) return ''
  
  const hours = Math.floor(seconds / 3600)
  const minutes = Math.floor((seconds % 3600) / 60)
  const secs = seconds % 60
  
  if (hours > 0) {
    return `${hours}h ${minutes}m`
  } else if (minutes > 0) {
    return secs > 0 ? `${minutes}m ${secs}s` : `${minutes}m`
  } else {
    return `${secs}s`
  }
}
