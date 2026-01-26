#!/usr/bin/env bun

/**
 * Seed Syllabus Data into Supabase
 *
 * This script imports the Class 12 syllabus data from src/lib/syllabus-data.ts
 * and inserts it into the Supabase 'syllabus' table.
 *
 * Usage:
 *   bun scripts/seed-syllabus.ts [--clear]
 *
 * Options:
 *   --clear  Clear existing Class 12 syllabus before seeding
 */

import { createClient } from '@supabase/supabase-js'
import { class12Syllabus } from '../src/lib/syllabus-data'
import { nanoid } from 'nanoid'

// Configuration
const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY
const BATCH_SIZE = 100

// Parse command line arguments
const args = process.argv.slice(2)
const shouldClear = args.includes('--clear')

async function main() {
  console.log('🌱 Starting syllabus seeding...\n')

  // Validate environment variables
  if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
    console.error('❌ Error: Missing Supabase environment variables')
    console.error('   Required: NEXT_PUBLIC_SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY')
    console.error('\n   Please ensure your .env file contains these variables.')
    process.exit(1)
  }

  // Create Supabase client with service role key (bypasses RLS)
  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
    auth: {
      autoRefreshToken: false,
      persistSession: false
    }
  })

  try {
    // Step 1: Clear existing data if requested
    if (shouldClear) {
      console.log('🧹 Clearing existing Class 12 syllabus...')
      const { error: deleteError, count } = await supabase
        .from('syllabus')
        .delete()
        .eq('class', '12')

      if (deleteError) {
        console.error('❌ Error clearing existing data:', deleteError.message)
        throw deleteError
      }

      console.log(`✅ Cleared ${count ?? 0} existing entries\n`)
    }

    // Step 2: Prepare data for insertion
    console.log(`📊 Preparing ${class12Syllabus.length} syllabus entries...`)

    const syllabusRecords = class12Syllabus.map(entry => ({
      id: nanoid(),
      class: entry.class,
      subject: entry.subject,
      chapter: entry.chapter,
      topics: entry.topics,
      priority: entry.priority,
      is_verified: true,
      created_at: new Date().toISOString()
    }))

    // Step 3: Insert in batches
    const batches: typeof syllabusRecords[] = []
    for (let i = 0; i < syllabusRecords.length; i += BATCH_SIZE) {
      batches.push(syllabusRecords.slice(i, i + BATCH_SIZE))
    }

    console.log(`📦 Inserting in ${batches.length} batches of up to ${BATCH_SIZE} records...\n`)

    let totalInserted = 0
    const errors: { batch: number; error: string }[] = []

    for (const [index, batch] of batches.entries()) {
      process.stdout.write(`   Batch ${index + 1}/${batches.length}... `)

      const { data, error } = await supabase
        .from('syllabus')
        .insert(batch)
        .select()

      if (error) {
        console.log('❌')
        console.error(`   Error: ${error.message}`)
        errors.push({
          batch: index + 1,
          error: error.message
        })
      } else {
        totalInserted += data?.length ?? 0
        console.log(`✅ (${data?.length ?? 0} records)`)
      }
    }

    // Step 4: Display results
    console.log('\n' + '='.repeat(60))

    if (errors.length > 0) {
      console.log(`⚠️  Seeding completed with errors`)
      console.log(`   Total inserted: ${totalInserted}/${syllabusRecords.length}`)
      console.log(`   Failed batches: ${errors.length}`)
      console.log('\nErrors:')
      errors.forEach(err => {
        console.log(`   Batch ${err.batch}: ${err.error}`)
      })
    } else {
      console.log(`✅ Seeding completed successfully!`)
      console.log(`   Total inserted: ${totalInserted}/${syllabusRecords.length}`)
    }

    // Step 5: Get summary statistics
    const { data: stats } = await supabase
      .from('syllabus')
      .select('subject, chapter')
      .eq('class', '12')

    const subjectCounts = stats?.reduce((acc, entry) => {
      acc[entry.subject] = (acc[entry.subject] || 0) + 1
      return acc
    }, {} as Record<string, number>)

    console.log('\n📈 Database Summary:')
    if (subjectCounts) {
      Object.entries(subjectCounts)
        .sort((a, b) => b[1] - a[1])
        .forEach(([subject, count]) => {
          console.log(`   ${subject}: ${count} chapters`)
        })
    }

    console.log('='.repeat(60) + '\n')

    if (errors.length > 0) {
      process.exit(1)
    }

  } catch (error) {
    console.error('\n❌ Fatal error:', error instanceof Error ? error.message : 'Unknown error')
    process.exit(1)
  }
}

// Run the script
main()
