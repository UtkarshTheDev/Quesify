export const RATE_LIMITS = {
  upload: {
    limit: 5,
    window: '1 m',
    prefix: 'ratelimit:upload',
    message: 'Upload limit reached. Please wait a moment before uploading another image.'
  },
  chat: {
    limit: 20,
    window: '1 m',
    prefix: 'ratelimit:chat',
    message: 'Chat limit reached. Please wait a moment before sending another message.'
  },
  aiSolve: {
    limit: 15,
    window: '1 m',
    prefix: 'ratelimit:ai-solve',
    message: 'AI solution limit reached. Please wait a moment.'
  },
  aiTweak: {
    limit: 20,
    window: '1 m',
    prefix: 'ratelimit:ai-tweak',
    message: 'AI modification limit reached. Please wait a moment.'
  },
  dbWrite: {
    limit: 30,
    window: '1 m',
    prefix: 'ratelimit:db-write',
    message: 'Too many write operations. Please wait a moment.'
  },
  dbRead: {
    limit: 60,
    window: '1 m',
    prefix: 'ratelimit:db-read',
    message: 'Too many read requests. Please wait a moment.'
  },
  charts: {
    limit: 10,
    window: '1 m',
    prefix: 'ratelimit:charts',
    message: 'Chart generation limit reached. Please wait a moment.'
  },
  authCheck: {
    limit: 10,
    window: '1 m',
    prefix: 'ratelimit:auth-check',
    message: 'Too many authentication checks. Please wait a moment.'
  },
  onboarding: {
    limit: 5,
    window: '1 m',
    prefix: 'ratelimit:onboarding',
    message: 'Too many onboarding attempts. Please wait a moment.'
  },
  social: {
    limit: 50,
    window: '1 m',
    prefix: 'ratelimit:social',
    message: 'Too many social actions. Please wait a moment.'
  },
} as const;

export type RateLimitKey = keyof typeof RATE_LIMITS;
