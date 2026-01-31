import { redis } from '@/lib/db/redis'

export const CACHE_TTL = {
  STATIC_DATA: 60 * 60,
  PAGINATION: 60 * 10,
  USER_DATA: 60 * 60,
  QUESTION_DETAIL: 60 * 10,
  REALTIME_STATS: 60 * 5,
}

export const CACHE_KEYS = {
  STATIC: {
    ALL_SUBJECTS: 'subjects:list',
    ALL_SYLLABUS: 'syllabus:all',
    SYLLABUS_SUBJECT: (subject: string) => `syllabus:${subject.toLowerCase()}`,
  },
  USER: {
    PROFILE: (userId: string) => `user:profile:${userId}`,
  },
  PAGINATION: {
    QUESTIONS: (
      userId: string | null,
      filters: { subject?: string; chapter?: string; difficulty?: string; isMCQ?: string | null }
    ) => {
      const parts = ['questions', filters.subject || '', filters.chapter || '', filters.difficulty || '', filters.isMCQ || '']
      return `user:questions:${userId || 'guest'}:${parts.join(':')}`
    },
    ACTIVITIES: (userId: string) => `user:activities:${userId || 'guest'}`,
    SOLUTIONS: (userId: string) => `user:solutions:${userId || 'guest'}`,
  },
  ENTITY: {
    QUESTION: (questionId: string) => `question:${questionId}`,
    SOLUTION: (solutionId: string) => `solution:${solutionId}`,
    USER_STATS: (questionId: string, userId: string) => `stats:question:${questionId}:${userId || 'guest'}`,
  },
}

export type CacheHitRate = {
  hits: number
  misses: number
  rate: number
}

export interface CachedResult<T> {
  data: T
  fromCache: boolean
  cacheHitRate?: CacheHitRate
}

export async function setCache<T>(key: string, value: T, ttl?: number): Promise<boolean> {
  if (!redis) {
    console.warn(`[Cache] Redis unavailable, skipping cache for key: ${key}`)
    return false
  }

  try {
    const result = await redis.set(key, value, { ex: ttl || CACHE_TTL.STATIC_DATA })
    console.log(`[Cache] SET ${key} (TTL: ${ttl || CACHE_TTL.STATIC_DATA}s)`)
    return result === 'OK'
  } catch (error) {
    console.error(`[Cache] Error setting ${key}:`, error)
    return false
  }
}

export async function getCache<T>(key: string): Promise<CachedResult<T>> {
  if (!redis) {
    return {
      data: null as T,
      fromCache: false,
    }
  }

  try {
    const start = performance.now()
    const cached = await redis.get<T>(key)
    const duration = performance.now() - start

    if (cached) {
      console.log(`[Cache] HIT ${key} (${duration.toFixed(2)}ms)`)
      return {
        data: cached,
        fromCache: true,
      }
    }

    console.log(`[Cache] MISS ${key} (${duration.toFixed(2)}ms)`)
    return {
      data: null as T,
      fromCache: false,
    }
  } catch (error) {
    console.error(`[Cache] Error getting ${key}:`, error)
    return {
      data: null as T,
      fromCache: false,
    }
  }
}

export async function deleteCache(keyOrPattern: string): Promise<boolean> {
  if (!redis) {
    console.warn(`[Cache] Redis unavailable, skipping delete for: ${keyOrPattern}`)
    return false
  }

  try {
    const result = await redis.del(keyOrPattern)
    console.log(`[Cache] DELETE ${keyOrPattern}`)
    return result > 0
  } catch (error) {
    console.error(`[Cache] Error deleting ${keyOrPattern}:`, error)
    return false
  }
}

export async function invalidateCache(pattern: string): Promise<number> {
  if (!redis) {
    console.warn(`[Cache] Redis unavailable, skipping invalidation for pattern: ${pattern}`)
    return 0
  }

  try {
    const result = await redis.del(pattern)
    console.log(`[Cache] INVALIDATE ${pattern} (deleted ${result} keys)`)
    return result
  } catch (error) {
    console.error(`[Cache] Error invalidating ${pattern}:`, error)
    return 0
  }
}

class CacheHitTracker {
  private hits = 0
  private misses = 0

  hit() {
    this.hits++
  }

  miss() {
    this.misses++
  }

  getRate() {
    const total = this.hits + this.misses
    return {
      hits: this.hits,
      misses: this.misses,
      rate: total > 0 ? (this.hits / total) * 100 : 0,
    }
  }

  reset() {
    this.hits = 0
    this.misses = 0
  }
}

const tracker = new CacheHitTracker()

export function recordCacheHit(): void {
  tracker.hit()
}

export function recordCacheMiss(): void {
  tracker.miss()
}

export function getCacheHitRate(): CacheHitRate {
  return tracker.getRate()
}

export function resetCacheHitTracker(): void {
  tracker.reset()
}
