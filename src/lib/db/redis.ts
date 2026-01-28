import { Redis } from '@upstash/redis'

/**
 * Redis client for server-side caching.
 * Uses Upstash Redis via HTTP (better for serverless/Next.js).
 */

const getRedisClient = () => {
  if (!process.env.UPSTASH_REDIS_REST_URL || !process.env.UPSTASH_REDIS_REST_TOKEN) {
    console.warn('Redis credentials not found. Caching will be disabled.')
    return null
  }

  return new Redis({
    url: process.env.UPSTASH_REDIS_REST_URL,
    token: process.env.UPSTASH_REDIS_REST_TOKEN,
  })
}

export const redis = getRedisClient()
