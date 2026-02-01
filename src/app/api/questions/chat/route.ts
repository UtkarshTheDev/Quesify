import { NextRequest, NextResponse } from 'next/server'
import { getAIClient } from '@/lib/ai/client'
import { PROMPTS, formatPrompt } from '@/lib/ai/prompts'
import { applyRateLimit } from '@/lib/ratelimit/client'

export async function POST(request: NextRequest) {
    const rateLimitResult = await applyRateLimit(request, 'chat')
    if (!rateLimitResult.success && rateLimitResult.response) {
        return rateLimitResult.response
    }

  try {
    const { message, questionContext } = await request.json()

    if (!message || !questionContext) {
      return NextResponse.json(
        { error: 'Missing message or context' },
        { status: 400 }
      )
    }

    const ai = getAIClient()
    
    const prompt = formatPrompt(PROMPTS.chatAssistant, {
      questionText: questionContext.text,
      subject: questionContext.subject,
      chapter: questionContext.chapter,
      solution: questionContext.solution,
      userMessage: message
    })

    const reply = await ai.generateText(prompt, 'fast')

    return NextResponse.json({ reply })
  } catch (error) {
    console.error('Chat API Error:', error)
    return NextResponse.json(
      { error: 'Failed to process chat request' },
      { status: 500 }
    )
  }
}
