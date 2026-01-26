import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { class12Syllabus } from '@/lib/syllabus-data'
import { nanoid } from 'nanoid'

/**
 * POST /api/admin/seed-syllabus
 * Seeds the database with Class 12 syllabus data for Physics, Chemistry, and Mathematics
 *
 * Options (via request body):
 * - clearExisting: boolean (default: false) - Clear existing Class 12 syllabus before seeding
 * - subjects: string[] (optional) - Only seed specific subjects (e.g., ["Physics", "Chemistry"])
 */
export async function POST(request: NextRequest) {
  try {
    const supabase = await createClient()

    // Authentication check (optional - you may want to add admin role check)
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json(
        { error: 'Unauthorized. Please login to seed syllabus.' },
        { status: 401 }
      )
    }

    // Parse request body for options
    let options = {
      clearExisting: false,
      subjects: undefined as string[] | undefined
    }

    try {
      const body = await request.json()
      options = {
        clearExisting: body.clearExisting ?? false,
        subjects: body.subjects
      }
    } catch {
      // No body provided, use defaults
    }

    // Filter syllabus by subjects if specified
    const syllabusToSeed = options.subjects
      ? class12Syllabus.filter(entry => options.subjects!.includes(entry.subject))
      : class12Syllabus

    if (syllabusToSeed.length === 0) {
      return NextResponse.json(
        { error: 'No syllabus entries found for the specified subjects' },
        { status: 400 }
      )
    }

    // Step 1: Clear existing Class 12 syllabus if requested
    if (options.clearExisting) {
      const deleteQuery = options.subjects
        ? supabase
            .from('syllabus')
            .delete()
            .eq('class', '12')
            .in('subject', options.subjects)
        : supabase
            .from('syllabus')
            .delete()
            .eq('class', '12')

      const { error: deleteError, count } = await deleteQuery

      if (deleteError) {
        console.error('Error clearing existing syllabus:', deleteError)
        return NextResponse.json(
          { error: 'Failed to clear existing syllabus', details: deleteError.message },
          { status: 500 }
        )
      }

      console.log(`Cleared ${count ?? 0} existing Class 12 syllabus entries`)
    }

    // Step 2: Prepare data for insertion
    const syllabusRecords = syllabusToSeed.map(entry => ({
      id: nanoid(),
      class: entry.class,
      subject: entry.subject,
      chapter: entry.chapter,
      topics: entry.topics,
      priority: entry.priority,
      is_verified: true,
      created_at: new Date().toISOString()
    }))

    // Step 3: Insert in batches (Supabase has a limit on bulk inserts)
    const BATCH_SIZE = 100
    const batches = []

    for (let i = 0; i < syllabusRecords.length; i += BATCH_SIZE) {
      batches.push(syllabusRecords.slice(i, i + BATCH_SIZE))
    }

    let totalInserted = 0
    const errors: { batch: number; error: string }[] = []

    for (const [index, batch] of batches.entries()) {
      const { data, error } = await supabase
        .from('syllabus')
        .insert(batch)
        .select()

      if (error) {
        console.error(`Error inserting batch ${index + 1}:`, error)
        errors.push({
          batch: index + 1,
          error: error.message
        })
      } else {
        totalInserted += data?.length ?? 0
        console.log(`Batch ${index + 1}/${batches.length}: Inserted ${data?.length ?? 0} records`)
      }
    }

    // Step 4: Return results
    if (errors.length > 0) {
      return NextResponse.json({
        success: false,
        message: 'Syllabus seeding completed with errors',
        totalInserted,
        totalRecords: syllabusRecords.length,
        errors
      }, { status: 207 }) // 207 Multi-Status
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

    return NextResponse.json({
      success: true,
      message: 'Syllabus seeded successfully',
      totalInserted,
      totalRecords: syllabusRecords.length,
      batches: batches.length,
      clearedExisting: options.clearExisting,
      subjectCounts,
      subjects: Object.keys(subjectCounts || {}),
      timestamp: new Date().toISOString()
    })

  } catch (error) {
    console.error('Syllabus seeding error:', error)
    return NextResponse.json(
      {
        error: 'Syllabus seeding failed',
        details: error instanceof Error ? error.message : 'Unknown error'
      },
      { status: 500 }
    )
  }
}

/**
 * GET /api/admin/seed-syllabus
 * Get information about the syllabus seeding without actually seeding
 */
export async function GET(request: NextRequest) {
  try {
    const supabase = await createClient()

    // Get current syllabus count in database
    const { count: currentCount, error: countError } = await supabase
      .from('syllabus')
      .select('*', { count: 'exact', head: true })
      .eq('class', '12')

    if (countError) {
      console.error('Error getting current count:', countError)
    }

    // Get subject breakdown from database
    const { data: dbStats } = await supabase
      .from('syllabus')
      .select('subject')
      .eq('class', '12')

    const dbSubjectCounts = dbStats?.reduce((acc, entry) => {
      acc[entry.subject] = (acc[entry.subject] || 0) + 1
      return acc
    }, {} as Record<string, number>)

    // Get subject breakdown from seed data
    const seedSubjectCounts = class12Syllabus.reduce((acc, entry) => {
      acc[entry.subject] = (acc[entry.subject] || 0) + 1
      return acc
    }, {} as Record<string, number>)

    return NextResponse.json({
      seedData: {
        totalEntries: class12Syllabus.length,
        subjects: Object.keys(seedSubjectCounts),
        breakdown: seedSubjectCounts
      },
      database: {
        totalEntries: currentCount ?? 0,
        subjects: Object.keys(dbSubjectCounts || {}),
        breakdown: dbSubjectCounts || {}
      },
      instructions: {
        seed: 'POST /api/admin/seed-syllabus',
        clearAndSeed: 'POST /api/admin/seed-syllabus with body: { "clearExisting": true }',
        seedSpecificSubjects: 'POST /api/admin/seed-syllabus with body: { "subjects": ["Physics", "Chemistry"] }'
      }
    })

  } catch (error) {
    console.error('Error getting syllabus info:', error)
    return NextResponse.json(
      {
        error: 'Failed to get syllabus information',
        details: error instanceof Error ? error.message : 'Unknown error'
      },
      { status: 500 }
    )
  }
}
