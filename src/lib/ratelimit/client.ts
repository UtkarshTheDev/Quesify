import { Ratelimit } from '@upstash/ratelimit';
import { Redis } from '@upstash/redis';
import { NextRequest, NextResponse } from 'next/server';
import { RATE_LIMITS, RateLimitKey } from './config';
import { createClient } from '@/lib/supabase/server';

type SupabaseClient = Awaited<ReturnType<typeof createClient>>;

const redis = new Redis({
  url: process.env.UPSTASH_REDIS_REST_URL!,
  token: process.env.UPSTASH_REDIS_REST_TOKEN!,
});

const rateLimiters: Record<RateLimitKey, Ratelimit> = {
  upload: new Ratelimit({
    redis,
    limiter: Ratelimit.slidingWindow(5, '1 m'),
    prefix: 'ratelimit:upload',
    analytics: true,
  }),
  chat: new Ratelimit({
    redis,
    limiter: Ratelimit.slidingWindow(20, '1 m'),
    prefix: 'ratelimit:chat',
    analytics: true,
  }),
  aiSolve: new Ratelimit({
    redis,
    limiter: Ratelimit.slidingWindow(15, '1 m'),
    prefix: 'ratelimit:ai-solve',
    analytics: true,
  }),
  aiTweak: new Ratelimit({
    redis,
    limiter: Ratelimit.slidingWindow(20, '1 m'),
    prefix: 'ratelimit:ai-tweak',
    analytics: true,
  }),
  dbWrite: new Ratelimit({
    redis,
    limiter: Ratelimit.slidingWindow(30, '1 m'),
    prefix: 'ratelimit:db-write',
    analytics: true,
  }),
  dbRead: new Ratelimit({
    redis,
    limiter: Ratelimit.slidingWindow(60, '1 m'),
    prefix: 'ratelimit:db-read',
    analytics: true,
  }),
  charts: new Ratelimit({
    redis,
    limiter: Ratelimit.slidingWindow(10, '1 m'),
    prefix: 'ratelimit:charts',
    analytics: true,
  }),
  authCheck: new Ratelimit({
    redis,
    limiter: Ratelimit.slidingWindow(10, '1 m'),
    prefix: 'ratelimit:auth-check',
    analytics: true,
  }),
  onboarding: new Ratelimit({
    redis,
    limiter: Ratelimit.slidingWindow(5, '1 m'),
    prefix: 'ratelimit:onboarding',
    analytics: true,
  }),
  social: new Ratelimit({
    redis,
    limiter: Ratelimit.slidingWindow(50, '1 m'),
    prefix: 'ratelimit:social',
    analytics: true,
  }),
};

async function getIdentifier(request: NextRequest, supabaseClient?: SupabaseClient): Promise<string> {
  if (supabaseClient) {
    try {
      const { data: { user } } = await supabaseClient.auth.getUser();
      if (user?.id) return `user_${user.id}`;
    } catch {
    }
  }

  const ip = request.headers.get('x-forwarded-for') || 
             request.headers.get('x-real-ip') || 
             'unknown';
  return `ip_${ip}`;
}

export async function applyRateLimit(
  request: NextRequest,
  limitKey: RateLimitKey,
  supabaseClient?: SupabaseClient
): Promise<{ success: boolean; response?: NextResponse; remaining?: number }> {
  const identifier = await getIdentifier(request, supabaseClient);
  const limiter = rateLimiters[limitKey];
  const config = RATE_LIMITS[limitKey];

  try {
    const { success, limit, reset, remaining } = await limiter.limit(identifier);

    if (success) return { success: true, remaining };

    const response = NextResponse.json(
      {
        error: 'Rate limit exceeded',
        message: config.message,
        retry_after: Math.ceil((reset - Date.now()) / 1000),
      },
      {
        status: 429,
        headers: {
          'X-RateLimit-Limit': limit.toString(),
          'X-RateLimit-Remaining': '0',
          'X-RateLimit-Reset': reset.toString(),
          'Retry-After': Math.ceil((reset - Date.now()) / 1000).toString(),
        },
      }
    );

    return { success: false, response };

  } catch (error) {
    console.error('Rate limit error:', error);
    return { success: true };
  }
}

export function withRateLimit(limitKey: RateLimitKey) {
  return async function rateLimitMiddleware(
    request: NextRequest,
    handler: (request: NextRequest) => Promise<NextResponse>
  ): Promise<NextResponse> {
    const result = await applyRateLimit(request, limitKey);

    if (!result.success && result.response) {
      return result.response;
    }

    return handler(request);
  };
}

export { redis, rateLimiters };
