import { config } from 'dotenv'
import { createClient } from '@supabase/supabase-js'
import { getAIClient } from '../lib/ai/client'
import { resolve } from 'path'

config({ path: resolve(process.cwd(), '.env.local') })

const BATCH_SIZE = 50
const RATE_LIMIT_DELAY_MS = 200

async function backfillEmbeddings() {
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
  const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.NEXT_PUBLIC_SUPABASE_SERVICE_ROLE_KEY
  const geminiKey = process.env.GEMINI_API_KEY

  if (!supabaseUrl || !supabaseServiceKey || !geminiKey) {
    console.error('❌ Missing environment variables:')
    console.error('  - NEXT_PUBLIC_SUPABASE_URL')
    console.error('  - SUPABASE_SERVICE_ROLE_KEY (or NEXT_PUBLIC_SUPABASE_SERVICE_ROLE_KEY)')
    console.error('  - GEMINI_API_KEY')
    process.exit(1)
  }

  const supabase = createClient(supabaseUrl, supabaseServiceKey)
  const ai = getAIClient()

  console.log('🚀 Starting embedding backfill...')
  console.log('Generating 768-dimension embeddings with gemini-embedding-001')

  let processed = 0
  let failed = 0
  let hasMore = true
  let lastId: string | null = null

  while (hasMore) {
    const query = supabase
      .from('questions')
      .select('id, question_text')
      .is('embedding', null)
      .order('id')
      .limit(BATCH_SIZE)

    if (lastId) {
      query.gt('id', lastId)
    }

    const { data: questions, error } = await query

    if (error) {
      console.error('❌ Database error:', error)
      break
    }

    if (!questions || questions.length === 0) {
      hasMore = false
      break
    }

    console.log(`\n📦 Processing batch of ${questions.length} questions...`)

    for (const question of questions) {
      try {
        const embedding = await ai.generateEmbedding(
          question.question_text,
          'retrieval_document'
        )

        if (embedding.length !== 768) {
          console.warn(`⚠️  Wrong dimension for ${question.id}: ${embedding.length}`)
          failed++
          continue
        }

        const { error: updateError } = await supabase
          .from('questions')
          .update({ embedding })
          .eq('id', question.id)

        if (updateError) {
          console.error(`❌ Failed to update ${question.id}:`, updateError)
          failed++
        } else {
          processed++
          process.stdout.write('.')
        }

        await new Promise((resolve) => setTimeout(resolve, RATE_LIMIT_DELAY_MS))
      } catch (err) {
        console.error(`\n❌ Failed to process ${question.id}:`, err)
        failed++
      }
    }

    lastId = questions[questions.length - 1].id
    console.log(`\n📊 Progress: ${processed} processed, ${failed} failed`)
  }

  console.log('\n\n🎉 BACKFILL COMPLETE!')
  console.log(`✅ Successfully processed: ${processed}`)
  console.log(`❌ Failed: ${failed}`)
  console.log(
    `📈 Success rate: ${((processed / (processed + failed)) * 100).toFixed(1)}%`
  )
}

backfillEmbeddings().catch(console.error)
