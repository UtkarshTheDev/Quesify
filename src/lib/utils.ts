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
