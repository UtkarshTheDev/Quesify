-- =============================================================================
-- ROLLBACK: Restore Original Embeddings (text-embedding-004)
-- FILENAME: 09_reset_embeddings_rollback.sql
-- PURPOSE: Restore embeddings if needed
-- =============================================================================

/*
NOTE: This rollback assumes you created a backup before clearing embeddings.
If you didn't create a backup, you cannot restore the old embeddings.

To use this rollback:
1. Stop the backfill script if running
2. Restore your backup
3. Redeploy old application code
*/

-- Option 1: Restore from full database backup
-- psql -h <host> -U <user> -d <db> < backup_pre_migration.sql

-- Option 2: If you exported just the questions table
-- psql -h <host> -U <user> -d <db> < questions_backup.sql

DO $$
BEGIN
    RAISE NOTICE '========================================';
    RAISE NOTICE 'ROLLBACK INSTRUCTIONS';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'To rollback:';
    RAISE NOTICE '1. Restore from backup (see comments above)';
    RAISE NOTICE '2. Redeploy old application code (text-embedding-004)';
    RAISE NOTICE '3. Verify embeddings are restored';
    RAISE NOTICE '';
    RAISE NOTICE 'NOTE: You must have created a backup BEFORE clearing embeddings!';
    RAISE NOTICE '========================================';
END $$;
