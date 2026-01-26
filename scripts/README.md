# Scripts

This directory contains utility scripts for managing the Quesify application.

## Available Scripts

### `seed-syllabus.ts`

Seeds the Supabase database with Class 12 CBSE syllabus data.

**Usage:**
```bash
# Seed syllabus data (add to existing)
bun scripts/seed-syllabus.ts

# Clear existing Class 12 syllabus and re-seed
bun scripts/seed-syllabus.ts --clear
```

**Requirements:**
- Environment variables must be set in `.env.local`:
  - `NEXT_PUBLIC_SUPABASE_URL`
  - `SUPABASE_SERVICE_ROLE_KEY`

**What it does:**
1. Connects to Supabase using service role key (bypasses RLS)
2. Optionally clears existing Class 12 syllabus data
3. Reads syllabus from `/src/lib/syllabus-data.ts`
4. Inserts data in batches of 100 records
5. Reports summary statistics

**Example Output:**
```
🌱 Starting syllabus seeding...

🧹 Clearing existing Class 12 syllabus...
✅ Cleared 48 existing entries

📊 Preparing 48 syllabus entries...
📦 Inserting in 1 batches of up to 100 records...

   Batch 1/1... ✅ (48 records)

============================================================
✅ Seeding completed successfully!
   Total inserted: 48/48

📈 Database Summary:
   Chemistry: 20 chapters
   Physics: 15 chapters
   Mathematics: 13 chapters
============================================================
```

## Adding New Scripts

When adding new scripts:

1. Use TypeScript with Bun runtime
2. Add shebang: `#!/usr/bin/env bun`
3. Include clear usage instructions in comments
4. Handle errors gracefully
5. Provide progress feedback
6. Update this README

## Bun vs Node.js

These scripts use Bun instead of Node.js for:
- Faster execution
- Built-in TypeScript support
- Native .env loading
- Better developer experience

To run with Bun:
```bash
bun <script-name>.ts
```
