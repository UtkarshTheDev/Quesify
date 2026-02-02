import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { deleteCache } from '@/lib/cache/api-cache'
import { applyRateLimit } from '@/lib/ratelimit/client'

export async function POST(request: NextRequest) {
    const rateLimitResult = await applyRateLimit(request, 'feed')
    if (!rateLimitResult.success && rateLimitResult.response) {
        return rateLimitResult.response
    }

    try {
        const supabase = await createClient()
        const { data: { user } } = await supabase.auth.getUser()

        if (!user) {
            return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
        }

        // Invalidate all feed caches for this user
        const cachePatterns = [
            `feed:mixed:${user.id}:*`,
            `feed:questions:${user.id}:*`,
            `feed:users:${user.id}:*`
        ]

        // Delete first page caches (most commonly accessed)
        await Promise.all([
            deleteCache(`feed:mixed:${user.id}:0:20`),
            deleteCache(`feed:questions:${user.id}:0:20`),
            deleteCache(`feed:users:${user.id}:0:10`)
        ])

        console.log(`[Feed/Refresh] Invalidated caches for user ${user.id}`)

        return NextResponse.json({
            success: true,
            regeneratedAt: new Date().toISOString()
        })
    } catch (error) {
        console.error('[Feed/Refresh] Error:', error)
        return NextResponse.json(
            { error: error instanceof Error ? error.message : 'Refresh failed' },
            { status: 500 }
        )
    }
}
