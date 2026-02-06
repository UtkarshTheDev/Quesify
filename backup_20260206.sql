--
-- PostgreSQL database dump
--

\restrict ymkwfi2t7ZT1Eb4KAnBCwPabl6ZoJehpk0d5jDpoCsVhDw5WPVIquVa5ngNHPMp

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA supabase_migrations;


ALTER SCHEMA supabase_migrations OWNER TO postgres;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: moddatetime; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS moddatetime WITH SCHEMA public;


--
-- Name: EXTENSION moddatetime; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION moddatetime IS 'Automatic updated_at timestamp management';


--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: vector; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS vector WITH SCHEMA public;


--
-- Name: EXTENSION vector; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION vector IS 'Vector similarity search for question matching';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


ALTER TYPE auth.oauth_authorization_status OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: activity_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.activity_type_enum AS ENUM (
    'question_created',
    'solution_contributed',
    'question_solved',
    'question_forked',
    'hint_updated',
    'question_deleted',
    'solution_deleted'
);


ALTER TYPE public.activity_type_enum OWNER TO postgres;

--
-- Name: TYPE activity_type_enum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.activity_type_enum IS 'Types of user activities tracked';


--
-- Name: difficulty_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.difficulty_enum AS ENUM (
    'easy',
    'medium',
    'hard',
    'very_hard'
);


ALTER TYPE public.difficulty_enum OWNER TO postgres;

--
-- Name: TYPE difficulty_enum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.difficulty_enum IS 'Difficulty levels for questions';


--
-- Name: feed_item_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.feed_item_type AS ENUM (
    'question',
    'user_suggestion'
);


ALTER TYPE public.feed_item_type OWNER TO postgres;

--
-- Name: notification_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.notification_type AS ENUM (
    'follow',
    'like',
    'link',
    'contribution'
);


ALTER TYPE public.notification_type OWNER TO postgres;

--
-- Name: question_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.question_type_enum AS ENUM (
    'MCQ',
    'VSA',
    'SA',
    'LA',
    'CASE_STUDY'
);


ALTER TYPE public.question_type_enum OWNER TO postgres;

--
-- Name: TYPE question_type_enum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.question_type_enum IS 'Types of questions supported';


--
-- Name: target_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.target_type_enum AS ENUM (
    'question',
    'solution'
);


ALTER TYPE public.target_type_enum OWNER TO postgres;

--
-- Name: TYPE target_type_enum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.target_type_enum IS 'Target entity types for activities';


--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: cleanup_activities_on_question_delete(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cleanup_activities_on_question_delete() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    DELETE FROM user_activities
    WHERE target_id = OLD.id
    AND target_type = 'question'
    AND activity_type = 'question_created';

    DELETE FROM user_activities
    WHERE target_id IN (
        SELECT id FROM solutions WHERE question_id = OLD.id
    )
    AND target_type = 'solution'
    AND activity_type = 'solution_contributed';

    RETURN OLD;
END;
$$;


ALTER FUNCTION public.cleanup_activities_on_question_delete() OWNER TO postgres;

--
-- Name: FUNCTION cleanup_activities_on_question_delete(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.cleanup_activities_on_question_delete() IS 'Clean up related activities when a question is permanently deleted';


--
-- Name: decrement_question_popularity(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.decrement_question_popularity() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    UPDATE questions 
    SET popularity = GREATEST(0, popularity - 1)
    WHERE id = OLD.question_id;
    RETURN OLD;
END;
$$;


ALTER FUNCTION public.decrement_question_popularity() OWNER TO postgres;

--
-- Name: FUNCTION decrement_question_popularity(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.decrement_question_popularity() IS 'Decrement question popularity when a user unlinks';


--
-- Name: get_explore_questions(uuid, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_explore_questions(p_user_id uuid, p_limit integer DEFAULT 6) RETURNS TABLE(question_id uuid, question_text text, subject text, chapter text, topics jsonb, difficulty public.difficulty_enum, popularity integer, created_at timestamp with time zone, image_url text, type public.question_type_enum, has_diagram boolean, uploader_user_id uuid, uploader_display_name text, uploader_username text, uploader_avatar_url text, solutions_count bigint, is_in_bank boolean, due_for_review boolean, similarity_score double precision)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        q.id::UUID,
        q.question_text,
        q.subject,
        q.chapter,
        q.topics,
        q.difficulty,
        q.popularity,
        q.created_at,
        q.image_url,
        q.type,
        q.has_diagram,
        q.owner_id AS uploader_user_id,
        up.display_name AS uploader_display_name,
        up.username AS uploader_username,
        up.avatar_url AS uploader_avatar_url,
        (SELECT COUNT(*) FROM solutions s WHERE s.question_id = q.id)::BIGINT AS solutions_count,
        FALSE AS is_in_bank, -- By definition, these are not in bank
        FALSE AS due_for_review,
        0::DOUBLE PRECISION AS sim_score
    FROM questions q
    JOIN user_profiles up ON up.user_id = q.owner_id
    WHERE 
        q.deleted_at IS NULL
        AND q.owner_id != p_user_id -- Exclude own questions
        AND NOT EXISTS (SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id)
    ORDER BY 
        q.popularity DESC, 
        q.created_at DESC
    LIMIT p_limit;
END;
$$;


ALTER FUNCTION public.get_explore_questions(p_user_id uuid, p_limit integer) OWNER TO postgres;

--
-- Name: get_mixed_feed(uuid, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_mixed_feed(p_user_id uuid, p_limit integer DEFAULT 20, p_offset integer DEFAULT 0) RETURNS TABLE(item_id uuid, item_type text, item_data jsonb, score integer, created_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_question_count INT;
    v_user_count INT;
BEGIN
    -- 3:1 ratio
    v_question_count := GREATEST(1, floor(p_limit * 0.75));
    v_user_count := GREATEST(1, floor(p_limit * 0.25));

    RETURN QUERY
    WITH 
    q_source AS (
        SELECT 
            rq.question_id::UUID AS src_id,
            'question'::TEXT AS src_type,
            jsonb_build_object(
                'id', rq.question_id,
                'question_text', rq.question_text,
                'subject', rq.subject,
                'chapter', rq.chapter,
                'topics', rq.topics,
                'difficulty', rq.difficulty,
                'created_at', rq.created_at,
                'image_url', rq.image_url,
                'solutions_count', rq.solutions_count,
                'is_in_bank', rq.is_in_bank,
                'due_for_review', rq.due_for_review,
                'uploader', jsonb_build_object(
                    'user_id', rq.uploader_user_id,
                    'display_name', rq.uploader_display_name,
                    'username', rq.uploader_username,
                    'avatar_url', rq.uploader_avatar_url
                )
            ) AS src_data,
            rq.score::INT AS src_score,
            rq.created_at AS src_created_at,
            ROW_NUMBER() OVER (ORDER BY rq.score DESC, rq.created_at DESC) AS custom_rn
        FROM get_recommended_questions(p_user_id, v_question_count + p_offset, 0) rq
    ),
    u_source AS (
        SELECT 
            ru.user_id::UUID AS src_id,
            'user_suggestion'::TEXT AS src_type,
            jsonb_build_object(
                'user_id', ru.user_id,
                'display_name', ru.display_name,
                'username', ru.username,
                'avatar_url', ru.avatar_url,
                'total_questions', ru.total_questions,
                'total_solutions', ru.total_solutions,
                'is_following', ru.is_following,
                'mutual_follows_count', ru.mutual_follows_count,
                'common_subjects', ru.common_subjects
            ) AS src_data,
            ru.score::INT AS src_score,
            ru.last_active AS src_created_at,
            ROW_NUMBER() OVER (ORDER BY ru.score DESC) AS custom_rn
        FROM get_recommended_users(p_user_id, v_user_count + (p_offset / 3), 0) ru
    ),
    combined_source AS (
        SELECT src_id, src_type, src_data, src_score, src_created_at, custom_rn FROM q_source
        UNION ALL
        SELECT src_id, src_type, src_data, src_score, src_created_at, custom_rn FROM u_source
    ),
    ordered_feed AS (
        SELECT
            c.src_id,
            c.src_type,
            c.src_data,
            c.src_score,
            c.src_created_at,
            CASE 
                WHEN c.src_type = 'question' THEN c.custom_rn + (c.custom_rn - 1) / 3
                ELSE (c.custom_rn * 4)
            END AS sort_order
        FROM combined_source c
    )
    SELECT
        of_feed.src_id AS item_id,
        of_feed.src_type AS item_type,
        of_feed.src_data AS item_data,
        of_feed.src_score AS score,
        of_feed.src_created_at AS created_at
    FROM ordered_feed of_feed
    ORDER BY of_feed.sort_order ASC
    LIMIT p_limit
    OFFSET p_offset;
END;
$$;


ALTER FUNCTION public.get_mixed_feed(p_user_id uuid, p_limit integer, p_offset integer) OWNER TO postgres;

--
-- Name: get_other_users_count(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_other_users_count(q_id text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_current_user UUID;
    v_count INTEGER;
BEGIN
    v_current_user := auth.uid();
    
    SELECT COUNT(*)::INTEGER INTO v_count
    FROM user_questions
    WHERE question_id = q_id
    AND user_id != v_current_user;
    
    RETURN v_count;
END;
$$;


ALTER FUNCTION public.get_other_users_count(q_id text) OWNER TO postgres;

--
-- Name: FUNCTION get_other_users_count(q_id text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.get_other_users_count(q_id text) IS 'Count other users linked to a question (excludes current user)';


--
-- Name: get_recommended_questions(uuid, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_recommended_questions(p_user_id uuid, p_limit integer DEFAULT 20, p_offset integer DEFAULT 0) RETURNS TABLE(question_id uuid, question_text text, subject text, chapter text, topics jsonb, difficulty public.difficulty_enum, popularity integer, created_at timestamp with time zone, image_url text, type public.question_type_enum, has_diagram boolean, uploader_user_id uuid, uploader_display_name text, uploader_username text, uploader_avatar_url text, solutions_count bigint, is_in_bank boolean, due_for_review boolean, score integer)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_user_subjects TEXT[];
    v_user_chapters TEXT[];
    v_user_difficulty TEXT;
    v_followed_users UUID[];
BEGIN
    v_user_subjects := get_user_subjects(p_user_id);
    v_user_chapters := get_user_chapters(p_user_id);
    v_user_difficulty := get_user_avg_difficulty(p_user_id);
    
    SELECT ARRAY(SELECT following_id FROM follows WHERE follower_id = p_user_id) INTO v_followed_users;
    
    RETURN QUERY
    SELECT 
        q.id::UUID AS question_id,
        q.question_text,
        q.subject,
        q.chapter,
        q.topics,
        q.difficulty,
        q.popularity,
        q.created_at,
        q.image_url,
        q.type,
        q.has_diagram,
        q.owner_id AS uploader_user_id,
        up.display_name AS uploader_display_name,
        up.username AS uploader_username,
        up.avatar_url AS uploader_avatar_url,
        (SELECT COUNT(*) FROM solutions s WHERE s.question_id = q.id)::BIGINT AS solutions_count,
        EXISTS(SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id) AS is_in_bank,
        COALESCE(EXISTS(SELECT 1 FROM user_question_stats uqs WHERE uqs.user_id = p_user_id AND uqs.question_id = q.id AND uqs.next_review_at <= NOW()), false) AS due_for_review,
        (
            -- Scoring Logic (Refined for practice)
            CASE WHEN q.subject = ANY(v_user_subjects) THEN 30 ELSE 0 END +
            CASE WHEN q.chapter = ANY(v_user_chapters) THEN 20 ELSE 0 END +
            CASE WHEN q.owner_id = ANY(v_followed_users) THEN 25 ELSE 0 END +
            CASE WHEN q.difficulty::TEXT = v_user_difficulty THEN 15 ELSE 0 END +
            -- Practice bonus: prioritizing others' questions
            CASE WHEN q.owner_id != p_user_id THEN 20 ELSE 0 END +
            -- Freshness/Popularity
            LEAST(q.popularity, 10)::INT +
            CASE WHEN q.created_at > NOW() - INTERVAL '3 days' THEN 10 ELSE 0 END
        ) AS score
    FROM questions q
    JOIN user_profiles up ON up.user_id = q.owner_id
    WHERE q.deleted_at IS NULL
    ORDER BY score DESC, q.created_at DESC
    LIMIT p_limit OFFSET p_offset;
END;
$$;


ALTER FUNCTION public.get_recommended_questions(p_user_id uuid, p_limit integer, p_offset integer) OWNER TO postgres;

--
-- Name: get_recommended_users(uuid, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_recommended_users(p_user_id uuid, p_limit integer DEFAULT 10, p_offset integer DEFAULT 0) RETURNS TABLE(user_id uuid, display_name text, username text, avatar_url text, common_subjects text[], mutual_follows_count bigint, total_questions bigint, total_solutions bigint, is_following boolean, last_active timestamp with time zone, score integer)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        up.user_id,
        up.display_name,
        up.username,
        up.avatar_url,
        ARRAY[]::TEXT[] AS common_subjects,
        0::BIGINT AS mutual_follows_count,
        up.total_uploaded::BIGINT AS total_questions,
        up.solutions_helped_count::BIGINT AS total_solutions,
        EXISTS(SELECT 1 FROM follows f WHERE f.follower_id = p_user_id AND f.following_id = up.user_id) AS is_following,
        up.updated_at AS last_active,
        10 AS score
    FROM user_profiles up
    WHERE up.user_id != p_user_id
    AND NOT EXISTS (SELECT 1 FROM follows f WHERE f.follower_id = p_user_id AND f.following_id = up.user_id)
    ORDER BY up.updated_at DESC
    LIMIT p_limit OFFSET p_offset;
END;
$$;


ALTER FUNCTION public.get_recommended_users(p_user_id uuid, p_limit integer, p_offset integer) OWNER TO postgres;

--
-- Name: get_user_avg_difficulty(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user_avg_difficulty(p_user_id uuid) RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_avg NUMERIC;
BEGIN
    SELECT AVG(CASE 
        WHEN q.difficulty = 'easy' THEN 1
        WHEN q.difficulty = 'medium' THEN 2
        WHEN q.difficulty = 'hard' THEN 3
        WHEN q.difficulty = 'very_hard' THEN 4
        ELSE 2
    END) INTO v_avg
    FROM user_question_stats uqs
    JOIN questions q ON q.id = uqs.question_id
    WHERE uqs.user_id = p_user_id
    AND uqs.solved = true;
    
    IF v_avg IS NULL THEN RETURN 'medium';
    ELSIF v_avg < 1.5 THEN RETURN 'easy';
    ELSIF v_avg < 2.5 THEN RETURN 'medium';
    ELSIF v_avg < 3.5 THEN RETURN 'hard';
    ELSE RETURN 'very_hard';
    END IF;
END;
$$;


ALTER FUNCTION public.get_user_avg_difficulty(p_user_id uuid) OWNER TO postgres;

--
-- Name: get_user_chapters(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user_chapters(p_user_id uuid) RETURNS text[]
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_chapters TEXT[];
BEGIN
    SELECT ARRAY(
        SELECT DISTINCT q.chapter
        FROM user_questions uq
        JOIN questions q ON q.id = uq.question_id
        WHERE uq.user_id = p_user_id
        AND q.chapter IS NOT NULL
    ) INTO v_chapters;
    
    RETURN COALESCE(v_chapters, ARRAY[]::TEXT[]);
END;
$$;


ALTER FUNCTION public.get_user_chapters(p_user_id uuid) OWNER TO postgres;

--
-- Name: get_user_subjects(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user_subjects(p_user_id uuid) RETURNS text[]
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_subjects TEXT[];
BEGIN
    SELECT ARRAY(
        SELECT DISTINCT unnest FROM (
            SELECT unnest(COALESCE(up.subjects, ARRAY[]::TEXT[]))
            FROM user_profiles up
            WHERE up.user_id = p_user_id
            UNION
            SELECT q.subject
            FROM user_questions uq
            JOIN questions q ON q.id = uq.question_id
            WHERE uq.user_id = p_user_id
            AND q.subject IS NOT NULL
        ) AS combined_subjects
    ) INTO v_subjects;
    
    RETURN COALESCE(v_subjects, ARRAY[]::TEXT[]);
END;
$$;


ALTER FUNCTION public.get_user_subjects(p_user_id uuid) OWNER TO postgres;

--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
    INSERT INTO public.user_profiles (user_id, display_name, username, avatar_url)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'display_name', NEW.email),
        NULL,
        COALESCE(NEW.raw_user_meta_data->>'avatar_url', NEW.raw_user_meta_data->>'picture')
    )
    ON CONFLICT (user_id) DO UPDATE SET
        avatar_url = EXCLUDED.avatar_url,
        display_name = EXCLUDED.display_name;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.handle_new_user() OWNER TO postgres;

--
-- Name: FUNCTION handle_new_user(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.handle_new_user() IS 'Automatically creates user_profiles row when new user signs up';


--
-- Name: increment_question_popularity(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.increment_question_popularity() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    UPDATE questions 
    SET popularity = popularity + 1
    WHERE id = NEW.question_id;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.increment_question_popularity() OWNER TO postgres;

--
-- Name: FUNCTION increment_question_popularity(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.increment_question_popularity() IS 'Increment question popularity when a new user links to it';


--
-- Name: increment_solutions_count(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.increment_solutions_count(question_id text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- This is a placeholder - the actual solution count comes from COUNT in queries
    -- But we keep this for compatibility with existing code
    RETURN;
END;
$$;


ALTER FUNCTION public.increment_solutions_count(question_id text) OWNER TO postgres;

--
-- Name: FUNCTION increment_solutions_count(question_id text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.increment_solutions_count(question_id text) IS 'Placeholder for backward compatibility';


--
-- Name: log_question_created_activity(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_question_created_activity() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    question_subject TEXT;
    question_chapter TEXT;
    question_snippet TEXT;
BEGIN
    SELECT subject, chapter,
           LEFT(question_text, 100) || CASE WHEN LENGTH(question_text) > 100 THEN '...' ELSE '' END
    INTO question_subject, question_chapter, question_snippet
    FROM questions
    WHERE id = NEW.question_id;

    INSERT INTO user_activities (user_id, activity_type, target_id, target_type, metadata)
    VALUES (
        NEW.user_id,
        'question_created',
        NEW.question_id,
        'question',
        jsonb_build_object(
            'is_owner', NEW.is_owner,
            'subject', COALESCE(question_subject, 'General'),
            'chapter', COALESCE(question_chapter, 'Unknown'),
            'snippet', COALESCE(question_snippet, 'No preview available')
        )
    );
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.log_question_created_activity() OWNER TO postgres;

--
-- Name: FUNCTION log_question_created_activity(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.log_question_created_activity() IS 'Log activity when user creates a question with full metadata';


--
-- Name: log_solution_contributed_activity(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_solution_contributed_activity() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    question_subject TEXT;
    question_chapter TEXT;
    question_snippet TEXT;
BEGIN
    SELECT subject, chapter,
           LEFT(question_text, 100) || CASE WHEN LENGTH(question_text) > 100 THEN '...' ELSE '' END
    INTO question_subject, question_chapter, question_snippet
    FROM questions
    WHERE id = NEW.question_id;

    INSERT INTO user_activities (user_id, activity_type, target_id, target_type, metadata)
    VALUES (
        NEW.contributor_id,
        'solution_contributed',
        NEW.id,
        'solution',
        jsonb_build_object(
            'question_id', NEW.question_id,
            'approach_description', NEW.approach_description,
            'subject', COALESCE(question_subject, 'General'),
            'chapter', COALESCE(question_chapter, 'Unknown'),
            'snippet', COALESCE(question_snippet, 'No preview available')
        )
    );
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.log_solution_contributed_activity() OWNER TO postgres;

--
-- Name: FUNCTION log_solution_contributed_activity(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.log_solution_contributed_activity() IS 'Log activity when user contributes a solution with full metadata';


--
-- Name: log_user_activity(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_user_activity() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    target_metadata JSONB := '{}'::jsonb;
    target_user_id UUID;
    v_subject TEXT;
    v_chapter TEXT;
    v_text TEXT;
BEGIN
    -- Handle Questions
    IF TG_TABLE_NAME = 'questions' THEN
        IF TG_OP = 'INSERT' THEN
            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
            VALUES (NEW.owner_id, 'question_created', NEW.id, 'question', 
                jsonb_build_object('subject', NEW.subject, 'chapter', NEW.chapter, 'snippet', left(NEW.question_text, 150)));
        ELSIF TG_OP = 'UPDATE' THEN
            IF (OLD.hint IS DISTINCT FROM NEW.hint) THEN
                INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
                VALUES (NEW.owner_id, 'hint_updated', NEW.id, 'question', 
                    jsonb_build_object('subject', NEW.subject, 'chapter', NEW.chapter, 'snippet', left(NEW.question_text, 150)));
            END IF;
        ELSIF TG_OP = 'DELETE' THEN
            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
            VALUES (OLD.owner_id, 'question_deleted', OLD.id, 'question', 
                jsonb_build_object('subject', OLD.subject, 'chapter', OLD.chapter, 'snippet', left(OLD.question_text, 150)));
        END IF;

    -- Handle Solutions
    ELSIF TG_TABLE_NAME = 'solutions' THEN
        IF TG_OP = 'INSERT' THEN
            -- Get question details
            SELECT subject, chapter, owner_id INTO v_subject, v_chapter, target_user_id 
            FROM public.questions WHERE id = NEW.question_id;
            
            IF target_user_id != NEW.contributor_id THEN
                INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
                VALUES (NEW.contributor_id, 'solution_contributed', NEW.id, 'solution', 
                    jsonb_build_object('subject', v_subject, 'chapter', v_chapter, 'snippet', left(NEW.solution_text, 150), 'question_id', NEW.question_id));
            END IF;
        ELSIF TG_OP = 'DELETE' THEN
             SELECT subject, chapter, owner_id INTO v_subject, v_chapter, target_user_id 
             FROM public.questions WHERE id = OLD.question_id;

             INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
             VALUES (OLD.contributor_id, 'solution_deleted', OLD.id, 'solution', 
                 jsonb_build_object('subject', v_subject, 'chapter', v_chapter));
        END IF;

    -- Handle Question Stats (Solving)
    ELSIF TG_TABLE_NAME = 'user_question_stats' THEN
        -- Check for INSERT with solved=true OR UPDATE with solved becoming true
        IF (TG_OP = 'INSERT' AND NEW.solved = true) OR 
           (TG_OP = 'UPDATE' AND NEW.solved = true AND (OLD.solved = false OR OLD.solved IS NULL)) THEN
            
            SELECT subject, chapter, question_text INTO v_subject, v_chapter, v_text 
            FROM public.questions WHERE id = NEW.question_id;
            
            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
            VALUES (NEW.user_id, 'question_solved', NEW.question_id, 'question', 
                jsonb_build_object('subject', v_subject, 'chapter', v_chapter, 'snippet', left(v_text, 150)));
        END IF;

    -- Handle User Questions (Forking/Bank)
    ELSIF TG_TABLE_NAME = 'user_questions' THEN
        -- Only log if the user is NOT the owner (i.e., they are linking someone else's question)
        IF TG_OP = 'INSERT' AND NEW.is_owner = false THEN
            SELECT subject, chapter, question_text INTO v_subject, v_chapter, v_text 
            FROM public.questions WHERE id = NEW.question_id;
            
            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)
            VALUES (NEW.user_id, 'question_forked', NEW.question_id, 'question', 
                jsonb_build_object('subject', v_subject, 'chapter', v_chapter, 'snippet', left(v_text, 150)));
        END IF;
    END IF;

    RETURN NULL;
END;
$$;


ALTER FUNCTION public.log_user_activity() OWNER TO postgres;

--
-- Name: match_questions_with_solutions(public.vector, double precision, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.match_questions_with_solutions(query_embedding public.vector, match_threshold double precision, match_count integer) RETURNS TABLE(id text, owner_id uuid, question_text text, matched_solution_text text, similarity double precision)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        q.id,
        q.owner_id,
        q.question_text,
        s.solution_text AS matched_solution_text,
        1 - (q.embedding <=> query_embedding) AS similarity
    FROM questions q
    LEFT JOIN solutions s ON s.question_id = q.id AND s.is_ai_best = TRUE
    WHERE 
        q.deleted_at IS NULL
        AND q.embedding IS NOT NULL
        AND 1 - (q.embedding <=> query_embedding) > match_threshold
    ORDER BY q.embedding <=> query_embedding
    LIMIT match_count;
END;
$$;


ALTER FUNCTION public.match_questions_with_solutions(query_embedding public.vector, match_threshold double precision, match_count integer) OWNER TO postgres;

--
-- Name: FUNCTION match_questions_with_solutions(query_embedding public.vector, match_threshold double precision, match_count integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.match_questions_with_solutions(query_embedding public.vector, match_threshold double precision, match_count integer) IS 'Find similar questions using vector cosine similarity';


--
-- Name: notify_on_contribution(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_on_contribution() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    question_owner_id UUID;
BEGIN
    -- Get question owner
    SELECT owner_id INTO question_owner_id
    FROM questions
    WHERE id = NEW.question_id;

    -- Don't notify if contributing to own question
    IF question_owner_id != NEW.contributor_id THEN
        INSERT INTO notifications (recipient_id, sender_id, type, entity_id, entity_type)
        VALUES (
            question_owner_id,
            NEW.contributor_id,
            'contribution',
            NEW.id::UUID, -- Linking to the solution
            'solution'
        );
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_on_contribution() OWNER TO postgres;

--
-- Name: notify_on_follow(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_on_follow() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    INSERT INTO notifications (recipient_id, sender_id, type, entity_id, entity_type)
    VALUES (
        NEW.following_id,
        NEW.follower_id,
        'follow',
        NEW.follower_id::UUID,
        'user'
    );
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_on_follow() OWNER TO postgres;

--
-- Name: notify_on_link(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_on_link() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    question_owner_id UUID;
BEGIN
    -- Only notify for linked questions (not original uploads)
    IF NEW.is_owner = FALSE THEN
        -- Get the original owner of the question
        SELECT owner_id INTO question_owner_id
        FROM public.questions
        WHERE id = NEW.question_id;

        -- Don't notify if the user is linking their own question (edge case)
        -- OR if the question has no owner (shouldn't happen)
        IF question_owner_id IS NOT NULL AND question_owner_id != NEW.user_id THEN
            INSERT INTO public.notifications (recipient_id, sender_id, type, entity_id, entity_type)
            VALUES (
                question_owner_id,
                NEW.user_id,
                'link',
                NEW.question_id::UUID,
                'question'
            );
        END IF;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_on_link() OWNER TO postgres;

--
-- Name: FUNCTION notify_on_link(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.notify_on_link() IS 'Notify question owner when someone links their question';


--
-- Name: notify_on_solution_like(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_on_solution_like() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    solution_author_id UUID;
BEGIN
    -- Get solution author
    SELECT contributor_id INTO solution_author_id
    FROM solutions
    WHERE id = NEW.solution_id;

    -- Don't notify if liking own solution
    IF solution_author_id != NEW.user_id THEN
        INSERT INTO notifications (recipient_id, sender_id, type, entity_id, entity_type)
        VALUES (
            solution_author_id,
            NEW.user_id,
            'like',
            NEW.solution_id::UUID,
            'solution'
        );
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_on_solution_like() OWNER TO postgres;

--
-- Name: recalculate_user_stats(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.recalculate_user_stats(user_uuid uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_total_uploaded INTEGER;
    v_total_solved INTEGER;
BEGIN
    -- Count uploaded questions (non-deleted)
    SELECT COUNT(*)::INTEGER INTO v_total_uploaded
    FROM questions
    WHERE owner_id = user_uuid AND deleted_at IS NULL;

    -- Count contributed solutions
    SELECT COUNT(*)::INTEGER INTO v_total_solved
    FROM solutions
    WHERE contributor_id = user_uuid;

    -- Update user profile
    UPDATE user_profiles
    SET 
        total_uploaded = v_total_uploaded,
        total_solved = v_total_solved,
        updated_at = NOW()
    WHERE user_id = user_uuid;
END;
$$;


ALTER FUNCTION public.recalculate_user_stats(user_uuid uuid) OWNER TO postgres;

--
-- Name: search_questions(text, uuid, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_questions(p_query text, p_user_id uuid, p_limit integer DEFAULT 20, p_offset integer DEFAULT 0) RETURNS TABLE(question_id uuid, question_text text, subject text, chapter text, topics jsonb, difficulty public.difficulty_enum, popularity integer, created_at timestamp with time zone, image_url text, type public.question_type_enum, has_diagram boolean, uploader_user_id uuid, uploader_display_name text, uploader_username text, uploader_avatar_url text, solutions_count bigint, is_in_bank boolean, due_for_review boolean, similarity_score double precision)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        q.id::UUID, -- Explicit cast to UUID
        q.question_text,
        q.subject,
        q.chapter,
        q.topics,
        q.difficulty,
        q.popularity,
        q.created_at,
        q.image_url,
        q.type,
        q.has_diagram,
        q.owner_id AS uploader_user_id,
        up.display_name AS uploader_display_name,
        up.username AS uploader_username,
        up.avatar_url AS uploader_avatar_url,
        (SELECT COUNT(*) FROM solutions s WHERE s.question_id = q.id)::BIGINT AS solutions_count,
        EXISTS(SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id) AS is_in_bank,
        COALESCE(EXISTS(SELECT 1 FROM user_question_stats uqs WHERE uqs.user_id = p_user_id AND uqs.question_id = q.id AND uqs.next_review_at <= NOW()), false) AS due_for_review,
        similarity(q.question_text, p_query)::DOUBLE PRECISION AS sim_score -- Explicit cast to DOUBLE PRECISION
    FROM questions q
    JOIN user_profiles up ON up.user_id = q.owner_id
    WHERE 
        q.deleted_at IS NULL
        AND (
            q.question_text % p_query 
            OR q.question_text ILIKE '%' || p_query || '%'
            OR q.chapter % p_query
            OR q.chapter ILIKE '%' || p_query || '%'
            OR q.topics::text ILIKE '%' || p_query || '%'
        )
    ORDER BY 
        (EXISTS(SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id)) DESC,
        sim_score DESC,
        q.created_at DESC
    LIMIT p_limit OFFSET p_offset;
END;
$$;


ALTER FUNCTION public.search_questions(p_query text, p_user_id uuid, p_limit integer, p_offset integer) OWNER TO postgres;

--
-- Name: search_users(text, uuid, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_users(p_query text, p_viewer_id uuid, p_limit integer DEFAULT 10) RETURNS TABLE(user_id uuid, username text, display_name text, avatar_url text, common_subjects text[], mutual_follows_count bigint, total_questions bigint, total_solutions bigint, is_following boolean, similarity_score double precision)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        up.user_id::UUID, -- Explicit cast to UUID
        up.username,
        up.display_name,
        up.avatar_url,
        ARRAY[]::TEXT[] as common_subjects, 
        0::BIGINT as mutual_follows_count,
        up.total_uploaded::BIGINT AS total_questions,
        up.solutions_helped_count::BIGINT AS total_solutions,
        EXISTS(SELECT 1 FROM follows f WHERE f.follower_id = p_viewer_id AND f.following_id = up.user_id) AS is_following,
        GREATEST(similarity(up.username, p_query), similarity(up.display_name, p_query))::DOUBLE PRECISION AS sim_score -- Explicit cast to DOUBLE PRECISION
    FROM user_profiles up
    WHERE 
        (
            up.username % p_query 
            OR up.display_name % p_query
            OR up.username ILIKE '%' || p_query || '%'
            OR up.display_name ILIKE '%' || p_query || '%'
        )
        AND up.user_id != p_viewer_id 
    ORDER BY sim_score DESC
    LIMIT p_limit;
END;
$$;


ALTER FUNCTION public.search_users(p_query text, p_viewer_id uuid, p_limit integer) OWNER TO postgres;

--
-- Name: sync_revise_later_delete_to_stats(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sync_revise_later_delete_to_stats() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    UPDATE user_question_stats
    SET in_revise_later = FALSE, updated_at = NOW()
    WHERE user_id = OLD.user_id AND question_id = OLD.question_id;
    RETURN OLD;
END;
$$;


ALTER FUNCTION public.sync_revise_later_delete_to_stats() OWNER TO postgres;

--
-- Name: FUNCTION sync_revise_later_delete_to_stats(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.sync_revise_later_delete_to_stats() IS 'Sync revise_later delete to user_question_stats';


--
-- Name: sync_revise_later_to_stats(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sync_revise_later_to_stats() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    INSERT INTO user_question_stats (user_id, question_id, in_revise_later)
    VALUES (NEW.user_id, NEW.question_id, TRUE)
    ON CONFLICT (user_id, question_id)
    DO UPDATE SET in_revise_later = TRUE, updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.sync_revise_later_to_stats() OWNER TO postgres;

--
-- Name: FUNCTION sync_revise_later_to_stats(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.sync_revise_later_to_stats() IS 'Sync revise_later insert to user_question_stats';


--
-- Name: toggle_solution_like(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.toggle_solution_like(sol_id text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_user_id UUID;
    v_like_exists BOOLEAN;
    v_likes_count INTEGER;
BEGIN
    -- Get current user ID
    v_user_id := auth.uid();
    
    IF v_user_id IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'Not authenticated');
    END IF;
    
    -- Check if like already exists
    SELECT EXISTS(
        SELECT 1 FROM solution_likes 
        WHERE user_id = v_user_id AND solution_id = sol_id
    ) INTO v_like_exists;
    
    IF v_like_exists THEN
        -- Unlike: Remove the like
        DELETE FROM solution_likes 
        WHERE user_id = v_user_id AND solution_id = sol_id;
        
        -- Decrement likes count
        UPDATE solutions 
        SET likes = GREATEST(0, likes - 1)
        WHERE id = sol_id;
        
        SELECT likes INTO v_likes_count FROM solutions WHERE id = sol_id;
        RETURN jsonb_build_object('success', true, 'liked', false, 'likes', v_likes_count);
    ELSE
        -- Like: Add new like
        INSERT INTO solution_likes (user_id, solution_id)
        VALUES (v_user_id, sol_id);
        
        -- Increment likes count
        UPDATE solutions 
        SET likes = likes + 1
        WHERE id = sol_id;
        
        SELECT likes INTO v_likes_count FROM solutions WHERE id = sol_id;
        RETURN jsonb_build_object('success', true, 'liked', true, 'likes', v_likes_count);
    END IF;
END;
$$;


ALTER FUNCTION public.toggle_solution_like(sol_id text) OWNER TO postgres;

--
-- Name: FUNCTION toggle_solution_like(sol_id text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.toggle_solution_like(sol_id text) IS 'Toggle like/unlike on a solution atomically';


--
-- Name: trigger_recalc_stats(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trigger_recalc_stats() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    IF TG_TABLE_NAME = 'questions' THEN
        IF TG_OP = 'INSERT' THEN
            PERFORM recalculate_user_stats(NEW.owner_id);
            RETURN NEW;
        ELSIF TG_OP = 'DELETE' THEN
            PERFORM recalculate_user_stats(OLD.owner_id);
            RETURN OLD;
        END IF;
    ELSIF TG_TABLE_NAME = 'solutions' THEN
        IF TG_OP = 'INSERT' THEN
            PERFORM recalculate_user_stats(NEW.contributor_id);
            RETURN NEW;
        ELSIF TG_OP = 'DELETE' THEN
            PERFORM recalculate_user_stats(OLD.contributor_id);
            RETURN OLD;
        END IF;
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION public.trigger_recalc_stats() OWNER TO postgres;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

--
-- Name: FUNCTION update_updated_at_column(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.update_updated_at_column() IS 'Trigger function to auto-update updated_at timestamp';


--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_
        -- Filter by action early - only get subscriptions interested in this action
        -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
        and (subs.action_filter = '*' or subs.action_filter = action::text);

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: add_prefixes(text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.add_prefixes(_bucket_id text, _name text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    prefixes text[];
BEGIN
    prefixes := "storage"."get_prefixes"("_name");

    IF array_length(prefixes, 1) > 0 THEN
        INSERT INTO storage.prefixes (name, bucket_id)
        SELECT UNNEST(prefixes) as name, "_bucket_id" ON CONFLICT DO NOTHING;
    END IF;
END;
$$;


ALTER FUNCTION storage.add_prefixes(_bucket_id text, _name text) OWNER TO supabase_storage_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: delete_leaf_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_leaf_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_rows_deleted integer;
BEGIN
    LOOP
        WITH candidates AS (
            SELECT DISTINCT
                t.bucket_id,
                unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        ),
        uniq AS (
             SELECT
                 bucket_id,
                 name,
                 storage.get_level(name) AS level
             FROM candidates
             WHERE name <> ''
             GROUP BY bucket_id, name
        ),
        leaf AS (
             SELECT
                 p.bucket_id,
                 p.name,
                 p.level
             FROM storage.prefixes AS p
                  JOIN uniq AS u
                       ON u.bucket_id = p.bucket_id
                           AND u.name = p.name
                           AND u.level = p.level
             WHERE NOT EXISTS (
                 SELECT 1
                 FROM storage.objects AS o
                 WHERE o.bucket_id = p.bucket_id
                   AND o.level = p.level + 1
                   AND o.name COLLATE "C" LIKE p.name || '/%'
             )
             AND NOT EXISTS (
                 SELECT 1
                 FROM storage.prefixes AS c
                 WHERE c.bucket_id = p.bucket_id
                   AND c.level = p.level + 1
                   AND c.name COLLATE "C" LIKE p.name || '/%'
             )
        )
        DELETE
        FROM storage.prefixes AS p
            USING leaf AS l
        WHERE p.bucket_id = l.bucket_id
          AND p.name = l.name
          AND p.level = l.level;

        GET DIAGNOSTICS v_rows_deleted = ROW_COUNT;
        EXIT WHEN v_rows_deleted = 0;
    END LOOP;
END;
$$;


ALTER FUNCTION storage.delete_leaf_prefixes(bucket_ids text[], names text[]) OWNER TO supabase_storage_admin;

--
-- Name: delete_prefix(text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_prefix(_bucket_id text, _name text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Check if we can delete the prefix
    IF EXISTS(
        SELECT FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name") + 1
          AND "prefixes"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    )
    OR EXISTS(
        SELECT FROM "storage"."objects"
        WHERE "objects"."bucket_id" = "_bucket_id"
          AND "storage"."get_level"("objects"."name") = "storage"."get_level"("_name") + 1
          AND "objects"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    ) THEN
    -- There are sub-objects, skip deletion
    RETURN false;
    ELSE
        DELETE FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name")
          AND "prefixes"."name" = "_name";
        RETURN true;
    END IF;
END;
$$;


ALTER FUNCTION storage.delete_prefix(_bucket_id text, _name text) OWNER TO supabase_storage_admin;

--
-- Name: delete_prefix_hierarchy_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_prefix_hierarchy_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    prefix text;
BEGIN
    prefix := "storage"."get_prefix"(OLD."name");

    IF coalesce(prefix, '') != '' THEN
        PERFORM "storage"."delete_prefix"(OLD."bucket_id", prefix);
    END IF;

    RETURN OLD;
END;
$$;


ALTER FUNCTION storage.delete_prefix_hierarchy_trigger() OWNER TO supabase_storage_admin;

--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    SELECT string_to_array(name, '/') INTO _parts;
    SELECT _parts[array_length(_parts,1)] INTO _filename;
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_level(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_level(name text) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT array_length(string_to_array("name", '/'), 1);
$$;


ALTER FUNCTION storage.get_level(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_prefix(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_prefix(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT
    CASE WHEN strpos("name", '/') > 0 THEN
             regexp_replace("name", '[\/]{1}[^\/]+\/?$', '')
         ELSE
             ''
        END;
$_$;


ALTER FUNCTION storage.get_prefix(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_prefixes(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_prefixes(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
DECLARE
    parts text[];
    prefixes text[];
    prefix text;
BEGIN
    -- Split the name into parts by '/'
    parts := string_to_array("name", '/');
    prefixes := '{}';

    -- Construct the prefixes, stopping one level below the last part
    FOR i IN 1..array_length(parts, 1) - 1 LOOP
            prefix := array_to_string(parts[1:i], '/');
            prefixes := array_append(prefixes, prefix);
    END LOOP;

    RETURN prefixes;
END;
$$;


ALTER FUNCTION storage.get_prefixes(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) OWNER TO supabase_storage_admin;

--
-- Name: lock_top_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.lock_top_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket text;
    v_top text;
BEGIN
    FOR v_bucket, v_top IN
        SELECT DISTINCT t.bucket_id,
            split_part(t.name, '/', 1) AS top
        FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        WHERE t.name <> ''
        ORDER BY 1, 2
        LOOP
            PERFORM pg_advisory_xact_lock(hashtextextended(v_bucket || '/' || v_top, 0));
        END LOOP;
END;
$$;


ALTER FUNCTION storage.lock_top_prefixes(bucket_ids text[], names text[]) OWNER TO supabase_storage_admin;

--
-- Name: objects_delete_cleanup(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_delete_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket_ids text[];
    v_names      text[];
BEGIN
    IF current_setting('storage.gc.prefixes', true) = '1' THEN
        RETURN NULL;
    END IF;

    PERFORM set_config('storage.gc.prefixes', '1', true);

    SELECT COALESCE(array_agg(d.bucket_id), '{}'),
           COALESCE(array_agg(d.name), '{}')
    INTO v_bucket_ids, v_names
    FROM deleted AS d
    WHERE d.name <> '';

    PERFORM storage.lock_top_prefixes(v_bucket_ids, v_names);
    PERFORM storage.delete_leaf_prefixes(v_bucket_ids, v_names);

    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.objects_delete_cleanup() OWNER TO supabase_storage_admin;

--
-- Name: objects_insert_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_insert_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    NEW.level := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_insert_prefix_trigger() OWNER TO supabase_storage_admin;

--
-- Name: objects_update_cleanup(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_update_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    -- NEW - OLD (destinations to create prefixes for)
    v_add_bucket_ids text[];
    v_add_names      text[];

    -- OLD - NEW (sources to prune)
    v_src_bucket_ids text[];
    v_src_names      text[];
BEGIN
    IF TG_OP <> 'UPDATE' THEN
        RETURN NULL;
    END IF;

    -- 1) Compute NEW−OLD (added paths) and OLD−NEW (moved-away paths)
    WITH added AS (
        SELECT n.bucket_id, n.name
        FROM new_rows n
        WHERE n.name <> '' AND position('/' in n.name) > 0
        EXCEPT
        SELECT o.bucket_id, o.name FROM old_rows o WHERE o.name <> ''
    ),
    moved AS (
         SELECT o.bucket_id, o.name
         FROM old_rows o
         WHERE o.name <> ''
         EXCEPT
         SELECT n.bucket_id, n.name FROM new_rows n WHERE n.name <> ''
    )
    SELECT
        -- arrays for ADDED (dest) in stable order
        COALESCE( (SELECT array_agg(a.bucket_id ORDER BY a.bucket_id, a.name) FROM added a), '{}' ),
        COALESCE( (SELECT array_agg(a.name      ORDER BY a.bucket_id, a.name) FROM added a), '{}' ),
        -- arrays for MOVED (src) in stable order
        COALESCE( (SELECT array_agg(m.bucket_id ORDER BY m.bucket_id, m.name) FROM moved m), '{}' ),
        COALESCE( (SELECT array_agg(m.name      ORDER BY m.bucket_id, m.name) FROM moved m), '{}' )
    INTO v_add_bucket_ids, v_add_names, v_src_bucket_ids, v_src_names;

    -- Nothing to do?
    IF (array_length(v_add_bucket_ids, 1) IS NULL) AND (array_length(v_src_bucket_ids, 1) IS NULL) THEN
        RETURN NULL;
    END IF;

    -- 2) Take per-(bucket, top) locks: ALL prefixes in consistent global order to prevent deadlocks
    DECLARE
        v_all_bucket_ids text[];
        v_all_names text[];
    BEGIN
        -- Combine source and destination arrays for consistent lock ordering
        v_all_bucket_ids := COALESCE(v_src_bucket_ids, '{}') || COALESCE(v_add_bucket_ids, '{}');
        v_all_names := COALESCE(v_src_names, '{}') || COALESCE(v_add_names, '{}');

        -- Single lock call ensures consistent global ordering across all transactions
        IF array_length(v_all_bucket_ids, 1) IS NOT NULL THEN
            PERFORM storage.lock_top_prefixes(v_all_bucket_ids, v_all_names);
        END IF;
    END;

    -- 3) Create destination prefixes (NEW−OLD) BEFORE pruning sources
    IF array_length(v_add_bucket_ids, 1) IS NOT NULL THEN
        WITH candidates AS (
            SELECT DISTINCT t.bucket_id, unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(v_add_bucket_ids, v_add_names) AS t(bucket_id, name)
            WHERE name <> ''
        )
        INSERT INTO storage.prefixes (bucket_id, name)
        SELECT c.bucket_id, c.name
        FROM candidates c
        ON CONFLICT DO NOTHING;
    END IF;

    -- 4) Prune source prefixes bottom-up for OLD−NEW
    IF array_length(v_src_bucket_ids, 1) IS NOT NULL THEN
        -- re-entrancy guard so DELETE on prefixes won't recurse
        IF current_setting('storage.gc.prefixes', true) <> '1' THEN
            PERFORM set_config('storage.gc.prefixes', '1', true);
        END IF;

        PERFORM storage.delete_leaf_prefixes(v_src_bucket_ids, v_src_names);
    END IF;

    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.objects_update_cleanup() OWNER TO supabase_storage_admin;

--
-- Name: objects_update_level_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_update_level_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Ensure this is an update operation and the name has changed
    IF TG_OP = 'UPDATE' AND (NEW."name" <> OLD."name" OR NEW."bucket_id" <> OLD."bucket_id") THEN
        -- Set the new level
        NEW."level" := "storage"."get_level"(NEW."name");
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_update_level_trigger() OWNER TO supabase_storage_admin;

--
-- Name: objects_update_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_update_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    old_prefixes TEXT[];
BEGIN
    -- Ensure this is an update operation and the name has changed
    IF TG_OP = 'UPDATE' AND (NEW."name" <> OLD."name" OR NEW."bucket_id" <> OLD."bucket_id") THEN
        -- Retrieve old prefixes
        old_prefixes := "storage"."get_prefixes"(OLD."name");

        -- Remove old prefixes that are only used by this object
        WITH all_prefixes as (
            SELECT unnest(old_prefixes) as prefix
        ),
        can_delete_prefixes as (
             SELECT prefix
             FROM all_prefixes
             WHERE NOT EXISTS (
                 SELECT 1 FROM "storage"."objects"
                 WHERE "bucket_id" = OLD."bucket_id"
                   AND "name" <> OLD."name"
                   AND "name" LIKE (prefix || '%')
             )
         )
        DELETE FROM "storage"."prefixes" WHERE name IN (SELECT prefix FROM can_delete_prefixes);

        -- Add new prefixes
        PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    END IF;
    -- Set the new level
    NEW."level" := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_update_prefix_trigger() OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: prefixes_delete_cleanup(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.prefixes_delete_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket_ids text[];
    v_names      text[];
BEGIN
    IF current_setting('storage.gc.prefixes', true) = '1' THEN
        RETURN NULL;
    END IF;

    PERFORM set_config('storage.gc.prefixes', '1', true);

    SELECT COALESCE(array_agg(d.bucket_id), '{}'),
           COALESCE(array_agg(d.name), '{}')
    INTO v_bucket_ids, v_names
    FROM deleted AS d
    WHERE d.name <> '';

    PERFORM storage.lock_top_prefixes(v_bucket_ids, v_names);
    PERFORM storage.delete_leaf_prefixes(v_bucket_ids, v_names);

    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.prefixes_delete_cleanup() OWNER TO supabase_storage_admin;

--
-- Name: prefixes_insert_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.prefixes_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.prefixes_insert_trigger() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql
    AS $$
declare
    can_bypass_rls BOOLEAN;
begin
    SELECT rolbypassrls
    INTO can_bypass_rls
    FROM pg_roles
    WHERE rolname = coalesce(nullif(current_setting('role', true), 'none'), current_user);

    IF can_bypass_rls THEN
        RETURN QUERY SELECT * FROM storage.search_v1_optimised(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    ELSE
        RETURN QUERY SELECT * FROM storage.search_legacy_v1(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    END IF;
end;
$$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_legacy_v1(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select path_tokens[$1] as folder
           from storage.objects
             where objects.name ilike $2 || $3 || ''%''
               and bucket_id = $4
               and array_length(objects.path_tokens, 1) <> $1
           group by folder
           order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_v1_optimised(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v1_optimised(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select (string_to_array(name, ''/''))[level] as name
           from storage.prefixes
             where lower(prefixes.name) like lower($2 || $3) || ''%''
               and bucket_id = $4
               and level = $1
           order by name ' || v_sort_order || '
     )
     (select name,
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[level] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where lower(objects.name) like lower($2 || $3) || ''%''
       and bucket_id = $4
       and level = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search_v1_optimised(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    sort_col text;
    sort_ord text;
    cursor_op text;
    cursor_expr text;
    sort_expr text;
BEGIN
    -- Validate sort_order
    sort_ord := lower(sort_order);
    IF sort_ord NOT IN ('asc', 'desc') THEN
        sort_ord := 'asc';
    END IF;

    -- Determine cursor comparison operator
    IF sort_ord = 'asc' THEN
        cursor_op := '>';
    ELSE
        cursor_op := '<';
    END IF;
    
    sort_col := lower(sort_column);
    -- Validate sort column  
    IF sort_col IN ('updated_at', 'created_at') THEN
        cursor_expr := format(
            '($5 = '''' OR ROW(date_trunc(''milliseconds'', %I), name COLLATE "C") %s ROW(COALESCE(NULLIF($6, '''')::timestamptz, ''epoch''::timestamptz), $5))',
            sort_col, cursor_op
        );
        sort_expr := format(
            'COALESCE(date_trunc(''milliseconds'', %I), ''epoch''::timestamptz) %s, name COLLATE "C" %s',
            sort_col, sort_ord, sort_ord
        );
    ELSE
        cursor_expr := format('($5 = '''' OR name COLLATE "C" %s $5)', cursor_op);
        sort_expr := format('name COLLATE "C" %s', sort_ord);
    END IF;

    RETURN QUERY EXECUTE format(
        $sql$
        SELECT * FROM (
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name,
                    NULL::uuid AS id,
                    updated_at,
                    created_at,
                    NULL::timestamptz AS last_accessed_at,
                    NULL::jsonb AS metadata
                FROM storage.prefixes
                WHERE name COLLATE "C" LIKE $1 || '%%'
                    AND bucket_id = $2
                    AND level = $4
                    AND %s
                ORDER BY %s
                LIMIT $3
            )
            UNION ALL
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name,
                    id,
                    updated_at,
                    created_at,
                    last_accessed_at,
                    metadata
                FROM storage.objects
                WHERE name COLLATE "C" LIKE $1 || '%%'
                    AND bucket_id = $2
                    AND level = $4
                    AND %s
                ORDER BY %s
                LIMIT $3
            )
        ) obj
        ORDER BY %s
        LIMIT $3
        $sql$,
        cursor_expr,    -- prefixes WHERE
        sort_expr,      -- prefixes ORDER BY
        cursor_expr,    -- objects WHERE
        sort_expr,      -- objects ORDER BY
        sort_expr       -- final ORDER BY
    )
    USING prefix, bucket_name, limits, levels, start_after, sort_column_after;
END;
$_$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


ALTER TABLE auth.oauth_authorizations OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE auth.oauth_client_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


ALTER TABLE auth.oauth_consents OWNER TO supabase_auth_admin;

--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: follows; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.follows (
    follower_id uuid NOT NULL,
    following_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.follows OWNER TO postgres;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    recipient_id uuid,
    sender_id uuid,
    type public.notification_type NOT NULL,
    entity_id uuid,
    entity_type text,
    is_read boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questions (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    owner_id uuid NOT NULL,
    question_text text NOT NULL,
    options jsonb DEFAULT '[]'::jsonb,
    type public.question_type_enum DEFAULT 'MCQ'::public.question_type_enum,
    has_diagram boolean DEFAULT false,
    image_url text,
    subject text,
    chapter text,
    topics jsonb DEFAULT '[]'::jsonb,
    difficulty public.difficulty_enum DEFAULT 'medium'::public.difficulty_enum,
    importance integer DEFAULT 3,
    hint text,
    embedding public.vector(768),
    popularity integer DEFAULT 1,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT questions_importance_check CHECK (((importance >= 1) AND (importance <= 5)))
);


ALTER TABLE public.questions OWNER TO postgres;

--
-- Name: TABLE questions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.questions IS 'Core question bank with soft delete';


--
-- Name: COLUMN questions.question_text; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.questions.question_text IS 'Formatted question with LaTeX';


--
-- Name: COLUMN questions.embedding; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.questions.embedding IS 'Gemini embedding (768 dims) for similarity';


--
-- Name: COLUMN questions.popularity; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.questions.popularity IS 'Number of users linked to this question';


--
-- Name: COLUMN questions.deleted_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.questions.deleted_at IS 'Soft delete - NULL means active';


--
-- Name: revise_later; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.revise_later (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    user_id uuid NOT NULL,
    question_id text NOT NULL,
    added_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.revise_later OWNER TO postgres;

--
-- Name: TABLE revise_later; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.revise_later IS 'Questions user wants to revise later';


--
-- Name: solution_likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.solution_likes (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    user_id uuid NOT NULL,
    solution_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.solution_likes OWNER TO postgres;

--
-- Name: TABLE solution_likes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.solution_likes IS 'Tracks which users liked which solutions';


--
-- Name: solutions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.solutions (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    question_id text NOT NULL,
    contributor_id uuid NOT NULL,
    solution_text text NOT NULL,
    numerical_answer text,
    approach_description text,
    correct_option integer,
    avg_solve_time integer DEFAULT 0,
    likes integer DEFAULT 0,
    is_ai_best boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.solutions OWNER TO postgres;

--
-- Name: TABLE solutions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.solutions IS 'Multiple solutions per question';


--
-- Name: COLUMN solutions.correct_option; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.solutions.correct_option IS '0-indexed correct option for MCQ (0=A, 1=B, etc.)';


--
-- Name: COLUMN solutions.avg_solve_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.solutions.avg_solve_time IS 'Estimated solve time in seconds';


--
-- Name: COLUMN solutions.is_ai_best; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.solutions.is_ai_best IS 'Flag for AI-selected best solution';


--
-- Name: syllabus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.syllabus (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    class text,
    subject text NOT NULL,
    chapter text NOT NULL,
    topics jsonb DEFAULT '[]'::jsonb,
    priority integer DEFAULT 3,
    is_verified boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT syllabus_priority_check CHECK (((priority >= 1) AND (priority <= 5)))
);


ALTER TABLE public.syllabus OWNER TO postgres;

--
-- Name: TABLE syllabus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.syllabus IS 'Preset syllabus with AI extension support';


--
-- Name: COLUMN syllabus.priority; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.syllabus.priority IS 'Importance level for exam weightage (1-5)';


--
-- Name: COLUMN syllabus.is_verified; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.syllabus.is_verified IS 'FALSE if AI added and pending human review';


--
-- Name: user_activities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_activities (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    user_id uuid NOT NULL,
    activity_type public.activity_type_enum NOT NULL,
    target_id text,
    target_type public.target_type_enum,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_activities OWNER TO postgres;

--
-- Name: TABLE user_activities; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.user_activities IS 'Activity feed for user profiles';


--
-- Name: COLUMN user_activities.metadata; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.user_activities.metadata IS 'JSON with subject, chapter, snippet, etc.';


--
-- Name: user_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_profiles (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    user_id uuid NOT NULL,
    display_name text,
    username text,
    avatar_url text,
    subjects text[],
    streak_count integer DEFAULT 0,
    last_streak_date date,
    total_solved integer DEFAULT 0,
    total_uploaded integer DEFAULT 0,
    solutions_helped_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT username_format CHECK ((username ~* '^[a-z0-9_]+$'::text)),
    CONSTRAINT username_length CHECK ((length(username) >= 3))
);


ALTER TABLE public.user_profiles OWNER TO postgres;

--
-- Name: TABLE user_profiles; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.user_profiles IS 'Extended user profile information';


--
-- Name: COLUMN user_profiles.user_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.user_profiles.user_id IS 'Reference to auth.users';


--
-- Name: COLUMN user_profiles.username; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.user_profiles.username IS 'Unique public handle (lowercase, numbers, underscores)';


--
-- Name: COLUMN user_profiles.subjects; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.user_profiles.subjects IS 'Array of subjects the user is studying';


--
-- Name: user_question_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_question_stats (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    user_id uuid NOT NULL,
    question_id text NOT NULL,
    solved boolean DEFAULT false,
    failed boolean DEFAULT false,
    struggled boolean DEFAULT false,
    attempts integer DEFAULT 0,
    time_spent integer DEFAULT 0,
    user_difficulty integer,
    last_practiced_at timestamp with time zone,
    next_review_at timestamp with time zone,
    in_revise_later boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT user_question_stats_user_difficulty_check CHECK (((user_difficulty >= 1) AND (user_difficulty <= 5)))
);


ALTER TABLE public.user_question_stats OWNER TO postgres;

--
-- Name: TABLE user_question_stats; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.user_question_stats IS 'Per-user statistics for each question';


--
-- Name: COLUMN user_question_stats.struggled; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.user_question_stats.struggled IS 'True if time exceeded threshold or marked failed';


--
-- Name: COLUMN user_question_stats.next_review_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.user_question_stats.next_review_at IS 'Next spaced repetition review date';


--
-- Name: user_questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_questions (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    user_id uuid NOT NULL,
    question_id text NOT NULL,
    is_owner boolean DEFAULT false,
    is_contributor boolean DEFAULT false,
    added_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_questions OWNER TO postgres;

--
-- Name: TABLE user_questions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.user_questions IS 'Links users to questions they own or have forked';


--
-- Name: COLUMN user_questions.is_owner; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.user_questions.is_owner IS 'True if user created this question';


--
-- Name: COLUMN user_questions.is_contributor; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.user_questions.is_contributor IS 'True if user added a solution';


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_01_31; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_01_31 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_01_31 OWNER TO supabase_admin;

--
-- Name: messages_2026_02_01; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_02_01 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_02_01 OWNER TO supabase_admin;

--
-- Name: messages_2026_02_02; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_02_02 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_02_02 OWNER TO supabase_admin;

--
-- Name: messages_2026_02_03; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_02_03 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_02_03 OWNER TO supabase_admin;

--
-- Name: messages_2026_02_04; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_02_04 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_02_04 OWNER TO supabase_admin;

--
-- Name: messages_2026_02_05; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_02_05 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_02_05 OWNER TO supabase_admin;

--
-- Name: messages_2026_02_06; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_02_06 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_02_06 OWNER TO supabase_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_vectors OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb,
    level integer
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: prefixes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.prefixes (
    bucket_id text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    level integer GENERATED ALWAYS AS (storage.get_level(name)) STORED NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE storage.prefixes OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.vector_indexes OWNER TO supabase_storage_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: postgres
--

CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text,
    created_by text,
    idempotency_key text,
    rollback text[]
);


ALTER TABLE supabase_migrations.schema_migrations OWNER TO postgres;

--
-- Name: messages_2026_01_31; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_01_31 FOR VALUES FROM ('2026-01-31 00:00:00') TO ('2026-02-01 00:00:00');


--
-- Name: messages_2026_02_01; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_02_01 FOR VALUES FROM ('2026-02-01 00:00:00') TO ('2026-02-02 00:00:00');


--
-- Name: messages_2026_02_02; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_02_02 FOR VALUES FROM ('2026-02-02 00:00:00') TO ('2026-02-03 00:00:00');


--
-- Name: messages_2026_02_03; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_02_03 FOR VALUES FROM ('2026-02-03 00:00:00') TO ('2026-02-04 00:00:00');


--
-- Name: messages_2026_02_04; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_02_04 FOR VALUES FROM ('2026-02-04 00:00:00') TO ('2026-02-05 00:00:00');


--
-- Name: messages_2026_02_05; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_02_05 FOR VALUES FROM ('2026-02-05 00:00:00') TO ('2026-02-06 00:00:00');


--
-- Name: messages_2026_02_06; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_02_06 FOR VALUES FROM ('2026-02-06 00:00:00') TO ('2026-02-07 00:00:00');


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
58292060-46c9-4d29-8e5c-c8492cb3d5f4	\N	0068ae74-2659-4538-9036-1db0ab96f80f	s256	SCiPPjhfSxB6nQii5tmhSQrhvcWrIBq2mycIxqJfo2c	github			2026-02-01 08:23:48.976612+00	2026-02-01 08:23:48.976612+00	oauth	\N	\N	\N	\N	\N	f
fb6a1006-dd45-4198-9931-e4c77198b9f3	\N	3ce3830e-292a-4c09-948b-5a1d4bfa0417	s256	S3DRskQWLBNtu89IARdAI6jP2UMJ9vI2oHYlBmAegFc	google			2026-02-01 09:06:23.334837+00	2026-02-01 09:06:23.334837+00	oauth	\N	\N	\N	\N	\N	f
452524ab-2e8f-47d6-8e48-44c773672f9f	\N	8b174c14-5a88-4233-9f52-b35d980891a5	s256	ZkCKsLKZoDaecKhacbzUIvxZRwJJhxmul3hCr3QBtVs	google			2026-02-01 09:50:25.714063+00	2026-02-01 09:50:25.714063+00	oauth	\N	\N	\N	\N	\N	f
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
106732412508017409536	cf2e1d9f-2677-47a8-b3da-5a7cccfa5ec1	{"iss": "https://accounts.google.com", "sub": "106732412508017409536", "name": "Utkarsh Tiwari", "email": "work.utkarshtiwari@gmail.com", "picture": "https://lh3.googleusercontent.com/a/ACg8ocL034euCt8oRZo3rzIUgOeWRV9E1yGZgHox_IQC0C9uEOCWljY=s96-c", "full_name": "Utkarsh Tiwari", "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocL034euCt8oRZo3rzIUgOeWRV9E1yGZgHox_IQC0C9uEOCWljY=s96-c", "provider_id": "106732412508017409536", "email_verified": true, "phone_verified": false}	google	2026-02-01 13:00:52.578955+00	2026-02-01 13:00:52.579022+00	2026-02-01 13:00:52.579022+00	9e2d331e-dfa6-40c1-80de-c3969e2b737d
100050439495078221402	f3f4fc66-4e15-451a-9eec-ace39efd5804	{"iss": "https://accounts.google.com", "sub": "100050439495078221402", "name": "Utkarsh Tiwari", "email": "utkarshweb2023@gmail.com", "picture": "https://lh3.googleusercontent.com/a/ACg8ocLx8AlX8nnIDs1lyeqleLjiJlU7OEuqzZgvd61MvZTzQDUma_tn=s96-c", "full_name": "Utkarsh Tiwari", "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocLx8AlX8nnIDs1lyeqleLjiJlU7OEuqzZgvd61MvZTzQDUma_tn=s96-c", "provider_id": "100050439495078221402", "email_verified": true, "phone_verified": false}	google	2026-01-31 04:41:17.057743+00	2026-01-31 04:41:17.05781+00	2026-02-01 13:44:23.630163+00	1c068404-80f1-4e2c-94c7-4f3ac8db532b
103254405495310473399	6b787def-4b61-42ff-814b-ebb92a3036d1	{"iss": "https://accounts.google.com", "sub": "103254405495310473399", "name": "Utkarsh Tiwari", "email": "utkarshthedev.2025@gmail.com", "picture": "https://lh3.googleusercontent.com/a/ACg8ocJv3aCKgpu55OmrF_uaNyqTjZcxXTBptrd5UMVzI1muJQXHhQ=s96-c", "full_name": "Utkarsh Tiwari", "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocJv3aCKgpu55OmrF_uaNyqTjZcxXTBptrd5UMVzI1muJQXHhQ=s96-c", "provider_id": "103254405495310473399", "email_verified": true, "phone_verified": false}	google	2026-02-01 13:09:00.597873+00	2026-02-01 13:09:00.597922+00	2026-02-02 18:35:49.812298+00	2bf7c8c5-ecba-491a-96de-4d31fa12aff2
104405069302546255502	6eda01a1-1970-4562-b4cf-996ce9e22ff4	{"iss": "https://accounts.google.com", "sub": "104405069302546255502", "name": "Spark Web", "email": "sparkweb2022@gmail.com", "picture": "https://lh3.googleusercontent.com/a/ACg8ocLK8GPsXtgNi4jVR7Ai3AEyYptipFqkvIRHgskLbR2hQLrESGg=s96-c", "full_name": "Spark Web", "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocLK8GPsXtgNi4jVR7Ai3AEyYptipFqkvIRHgskLbR2hQLrESGg=s96-c", "provider_id": "104405069302546255502", "email_verified": true, "phone_verified": false}	google	2026-01-31 09:41:37.422328+00	2026-01-31 09:41:37.422399+00	2026-02-03 04:37:33.035549+00	5e95aad0-abc4-48c4-870c-15c14f479980
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
be547af7-f81d-481f-abd0-20ebf55ffcd3	2026-02-03 04:37:35.582251+00	2026-02-03 04:37:35.582251+00	oauth	d34b4211-5938-4d37-a777-acc69ee7964b
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	64	uvptm3y2fe5c	6eda01a1-1970-4562-b4cf-996ce9e22ff4	f	2026-02-03 04:37:35.578608+00	2026-02-03 04:37:35.578608+00	\N	be547af7-f81d-481f-abd0-20ebf55ffcd3
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
be547af7-f81d-481f-abd0-20ebf55ffcd3	6eda01a1-1970-4562-b4cf-996ce9e22ff4	2026-02-03 04:37:35.570925+00	2026-02-03 04:37:35.570925+00	\N	aal1	\N	\N	Mozilla/5.0 (X11; Linux x86_64; rv:146.0) Gecko/20100101 Firefox/146.0	152.58.152.251	\N	\N	\N	\N	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	6b787def-4b61-42ff-814b-ebb92a3036d1	authenticated	authenticated	utkarshthedev.2025@gmail.com	\N	2026-02-01 13:09:00.608663+00	\N		\N		\N			\N	2026-02-02 18:35:53.415548+00	{"provider": "google", "providers": ["google"]}	{"iss": "https://accounts.google.com", "sub": "103254405495310473399", "name": "Utkarsh Tiwari", "email": "utkarshthedev.2025@gmail.com", "picture": "https://lh3.googleusercontent.com/a/ACg8ocJv3aCKgpu55OmrF_uaNyqTjZcxXTBptrd5UMVzI1muJQXHhQ=s96-c", "full_name": "Utkarsh Tiwari", "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocJv3aCKgpu55OmrF_uaNyqTjZcxXTBptrd5UMVzI1muJQXHhQ=s96-c", "provider_id": "103254405495310473399", "email_verified": true, "phone_verified": false}	\N	2026-02-01 13:09:00.590637+00	2026-02-03 04:33:38.473552+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	f3f4fc66-4e15-451a-9eec-ace39efd5804	authenticated	authenticated	utkarshweb2023@gmail.com	\N	2026-01-31 04:41:17.068203+00	\N		\N		\N			\N	2026-02-01 13:44:26.440959+00	{"provider": "google", "providers": ["google"]}	{"iss": "https://accounts.google.com", "sub": "100050439495078221402", "name": "Utkarsh Tiwari", "email": "utkarshweb2023@gmail.com", "picture": "https://lh3.googleusercontent.com/a/ACg8ocLx8AlX8nnIDs1lyeqleLjiJlU7OEuqzZgvd61MvZTzQDUma_tn=s96-c", "full_name": "Utkarsh Tiwari", "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocLx8AlX8nnIDs1lyeqleLjiJlU7OEuqzZgvd61MvZTzQDUma_tn=s96-c", "provider_id": "100050439495078221402", "email_verified": true, "phone_verified": false}	\N	2026-01-31 04:41:17.024188+00	2026-02-01 13:44:26.478281+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	cf2e1d9f-2677-47a8-b3da-5a7cccfa5ec1	authenticated	authenticated	work.utkarshtiwari@gmail.com	\N	2026-02-01 13:00:52.588979+00	\N		\N		\N			\N	2026-02-01 13:01:01.157281+00	{"provider": "google", "providers": ["google"]}	{"iss": "https://accounts.google.com", "sub": "106732412508017409536", "name": "Utkarsh Tiwari", "email": "work.utkarshtiwari@gmail.com", "picture": "https://lh3.googleusercontent.com/a/ACg8ocL034euCt8oRZo3rzIUgOeWRV9E1yGZgHox_IQC0C9uEOCWljY=s96-c", "full_name": "Utkarsh Tiwari", "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocL034euCt8oRZo3rzIUgOeWRV9E1yGZgHox_IQC0C9uEOCWljY=s96-c", "provider_id": "106732412508017409536", "email_verified": true, "phone_verified": false}	\N	2026-02-01 13:00:52.505216+00	2026-02-01 13:01:01.186209+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	6eda01a1-1970-4562-b4cf-996ce9e22ff4	authenticated	authenticated	sparkweb2022@gmail.com	\N	2026-01-31 09:41:37.426648+00	\N		\N		\N			\N	2026-02-03 04:37:35.570792+00	{"provider": "google", "providers": ["google"]}	{"iss": "https://accounts.google.com", "sub": "104405069302546255502", "name": "Spark Web", "email": "sparkweb2022@gmail.com", "picture": "https://lh3.googleusercontent.com/a/ACg8ocLK8GPsXtgNi4jVR7Ai3AEyYptipFqkvIRHgskLbR2hQLrESGg=s96-c", "full_name": "Spark Web", "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocLK8GPsXtgNi4jVR7Ai3AEyYptipFqkvIRHgskLbR2hQLrESGg=s96-c", "provider_id": "104405069302546255502", "email_verified": true, "phone_verified": false}	\N	2026-01-31 09:41:37.406102+00	2026-02-03 04:37:35.58176+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: follows; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.follows (follower_id, following_id, created_at) FROM stdin;
6eda01a1-1970-4562-b4cf-996ce9e22ff4	f3f4fc66-4e15-451a-9eec-ace39efd5804	2026-01-31 13:26:06.765061+00
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, recipient_id, sender_id, type, entity_id, entity_type, is_read, created_at) FROM stdin;
0a7e2f52-e044-4826-87ce-5f9ceb72617f	f3f4fc66-4e15-451a-9eec-ace39efd5804	6eda01a1-1970-4562-b4cf-996ce9e22ff4	follow	6eda01a1-1970-4562-b4cf-996ce9e22ff4	user	t	2026-01-31 13:26:06.765061+00
91050115-96a7-4871-8df7-2c342cd3c2c9	6eda01a1-1970-4562-b4cf-996ce9e22ff4	f3f4fc66-4e15-451a-9eec-ace39efd5804	link	d67c4208-4acd-482d-af2d-5e760de3b700	question	t	2026-01-31 16:32:00.921814+00
8eec4942-c6c9-4934-9335-28861fba3340	6eda01a1-1970-4562-b4cf-996ce9e22ff4	f3f4fc66-4e15-451a-9eec-ace39efd5804	like	c12fafcd-29a3-40ce-b4ee-fb32581ecd43	solution	t	2026-01-31 16:32:30.66698+00
3eaf1777-33ed-4eff-acc4-0a07c9d5fda1	6eda01a1-1970-4562-b4cf-996ce9e22ff4	f3f4fc66-4e15-451a-9eec-ace39efd5804	link	fdffdaef-bc79-40a0-ab59-8321baf71d62	question	t	2026-01-31 19:33:23.422938+00
0331503c-e2fa-45cb-bcd3-321c211eaccf	6eda01a1-1970-4562-b4cf-996ce9e22ff4	f3f4fc66-4e15-451a-9eec-ace39efd5804	contribution	be624ebf-b806-476e-abc2-c15af1c9c35c	solution	t	2026-01-31 19:33:23.643693+00
3523cf4e-943c-4ace-b36f-0d83f74c7f50	f3f4fc66-4e15-451a-9eec-ace39efd5804	6eda01a1-1970-4562-b4cf-996ce9e22ff4	like	be624ebf-b806-476e-abc2-c15af1c9c35c	solution	t	2026-01-31 19:34:48.741127+00
53a0b921-740b-42c4-a005-547652813ad8	f3f4fc66-4e15-451a-9eec-ace39efd5804	6eda01a1-1970-4562-b4cf-996ce9e22ff4	like	be624ebf-b806-476e-abc2-c15af1c9c35c	solution	t	2026-01-31 20:58:10.329209+00
be6eb58b-abdb-4320-9646-9cc7981d5706	6eda01a1-1970-4562-b4cf-996ce9e22ff4	6b787def-4b61-42ff-814b-ebb92a3036d1	link	1954e9c7-4c54-46ce-b507-1a5947e0bfab	question	t	2026-02-01 13:12:43.981951+00
afbc1f6d-31f3-436e-bddb-15b056a9ae2c	6eda01a1-1970-4562-b4cf-996ce9e22ff4	6b787def-4b61-42ff-814b-ebb92a3036d1	contribution	deb62af3-4b1d-4094-89f2-50f07726a965	solution	t	2026-02-01 13:12:44.191012+00
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questions (id, owner_id, question_text, options, type, has_diagram, image_url, subject, chapter, topics, difficulty, importance, hint, embedding, popularity, deleted_at, created_at, updated_at) FROM stdin;
d67c4208-4acd-482d-af2d-5e760de3b700	6eda01a1-1970-4562-b4cf-996ce9e22ff4	The general solution of $e^y \\left(\\frac{dy}{dx} - 1\\right) = e^x$ is	["$e^y \\\\cdot x = x + c$", "$e^{(x-y)} = x + c$", "$e^{(y-x)} = x + c$", "None of these"]	MCQ	f	https://iljpsrbycqfunmpimjaa.supabase.co/storage/v1/object/public/question-images/6eda01a1-1970-4562-b4cf-996ce9e22ff4/1769860299857.png	Mathematics	Continuity and Differentiability	["Differentiation"]	medium	5	Differential equation analysis and direct evaluation of given options	[0.0065322667,-0.017691247,-0.0030265255,-0.055106297,0.009895879,0.027896862,0.037317958,-0.0148507375,0.012420686,0.0030819608,0.042370606,-0.013972547,-0.015992535,0.023376416,0.13878532,-0.010646207,0.009222418,-0.00055107404,-0.019305235,-0.023605311,-0.001194366,0.025276732,0.028959377,0.008363766,-0.015943253,0.012073709,-0.008715904,-0.0036204895,0.017610166,-0.008774354,0.008327443,0.018952157,-0.01627729,0.032380812,-0.014383329,0.002145224,0.018918263,0.013297497,0.008682568,-0.0041390215,-0.0028233978,0.0004766948,-0.008742602,-0.024270212,0.021212043,0.005639996,-0.03221756,-0.012668862,-0.02807557,0.0021661452,-0.005776222,0.005293137,-0.0107117845,-0.17816058,-0.012861011,0.0058867172,-0.0001690998,0.024290958,-0.012022223,-0.02276829,-0.0075571416,0.0025632887,-0.023515463,0.0036764906,-0.0062279664,0.00606801,0.046755377,0.014466722,-0.0002462946,-0.019790921,0.013130473,0.018103553,-0.0037498057,-0.012924845,-0.0076011466,-0.009196956,-0.006073547,-0.046424653,-0.0038171948,0.00100829,-0.033366803,-0.006381794,-0.011209432,-0.021822006,0.0014764667,0.006894362,-0.009930039,0.009587604,-0.017496279,-0.02394259,-0.008981763,0.02035186,0.014809674,0.009033188,-0.024343008,0.0017266012,-0.0012163323,0.046068236,-0.0006576103,0.0056902114,-0.017711595,0.013256081,-0.0039930567,-0.009919745,0.0017896252,-0.013845404,-0.019904807,0.011750136,-0.007098655,0.03164363,-0.015521066,-0.0012630761,-0.0005709975,0.0018436903,0.015622651,-0.13415997,0.017023887,-0.014994035,-0.020203771,-0.011386552,0.009511367,-0.030230451,0.00042631247,-0.006455362,-0.011170071,-0.025380144,0.031808116,0.004504591,0.0068041985,0.008027094,0.002261181,-0.017861143,-0.007815566,-0.030502016,0.043344095,0.023784138,-0.015067662,-0.0054560457,-0.01062073,0.000628564,-0.03390527,-0.012488423,0.020575006,-0.0012426758,-0.009921979,0.016339663,-0.020422844,-0.00457471,-0.010927621,-0.027513145,0.006678245,0.010433536,0.014746887,-0.007657209,0.007555068,-0.060622625,0.012987713,-0.0068004117,0.02569089,0.00046387844,-0.02542934,-0.0051422776,9.7516975e-05,0.0041014967,0.008725434,-0.0011901326,-0.014127331,-0.026717499,-0.0077941553,-0.005142707,-0.01889908,0.011574741,-0.0046383706,-0.0017004125,0.017990127,0.032065444,-0.02337212,0.020986827,0.015606513,0.012586724,0.0045033293,-0.008469887,-0.015104744,-0.00034804989,-0.0012686874,0.02060562,0.0056546517,0.0048185955,0.0045545246,0.0028041268,-0.020935971,-0.019430695,0.023410901,-0.037244316,0.02192174,-0.016645802,-0.012694876,0.007964414,-0.010386792,-0.0037018515,0.0018437477,0.03465695,-0.017711759,-0.011798717,-0.011972448,0.040813297,0.011659692,-0.0067600072,0.0011062135,0.01940374,-4.687643e-05,-0.040450983,0.059831772,-0.020485627,0.025763316,-0.033536527,0.017745296,0.0049736546,0.012591989,-0.0028853095,0.0076486105,-0.011456182,0.011239245,0.019435732,-0.053961735,-0.01954023,0.018282766,0.00983695,-0.00294176,0.014220337,0.02137585,-0.013880265,0.011183946,0.009986649,-0.019400043,0.027111428,0.0012005377,-0.014647058,0.01844366,0.033400755,-0.0023722197,-0.019615963,-0.0061346763,-0.0061166002,-0.027200118,-0.0005277326,-0.026845973,0.0031370232,0.0221059,0.023169806,-0.015199983,0.009486329,-0.008544543,0.010128635,-0.017481433,-0.015750317,0.01450506,0.0020048122,-0.000513735,0.013380733,0.006294207,-0.02300967,-0.009299436,-0.00012740101,-0.0045033754,-0.007793396,-0.006048759,0.02836479,-0.019521842,0.003291616,-0.00085625396,0.005774965,0.005955797,0.0061212783,0.011626036,0.028925562,-0.037456278,0.029751122,-0.004926027,-0.019647304,0.008657171,0.031242063,0.020612592,0.002962929,0.018901492,0.0076211756,0.0034125599,0.0084675625,-0.0035213334,-0.0022675046,-0.012647309,0.005135408,-0.014819054,-0.01594867,-0.003806035,-0.01214962,0.0032811158,-0.0056824237,-0.0020950679,-0.011327802,0.033033945,0.009190295,7.6135175e-06,0.017944032,-0.0033163598,-0.004157709,0.0013533479,0.0129222,0.017328609,-0.015495167,0.004226522,0.019475514,-0.03131411,0.01369952,-0.020808958,-0.013762367,-0.007943714,0.0030160167,0.00769567,-0.00886062,0.005827339,0.01355463,-0.0023049344,0.031220483,0.007799906,0.026194802,-0.02693413,0.00045940597,0.017078817,-0.00015283983,0.04524539,0.00077095587,0.025274877,0.016751407,-0.0139838,0.0042490996,0.025263527,-0.017576883,-0.009102609,-0.024879877,-0.0061233225,-0.01863845,-0.02652232,-0.0072603747,0.012681557,-0.0317263,-0.013348926,0.009513544,0.00021253857,-0.021477373,0.002281574,0.0008568334,0.013751762,0.027800694,-0.0021550695,0.023167819,0.027271839,0.009519907,-0.00087227736,0.016372452,-0.01452248,-0.032057185,-0.0019778137,0.006781676,-0.0007594824,0.022088153,-0.015812593,-0.015701959,-0.024053007,-0.01053104,-0.022894688,0.020826094,0.009337427,0.021800617,0.0064734234,0.015285798,0.0039523058,-0.012656557,-0.017761935,0.008800555,-0.035490856,0.020648185,0.0122052245,-0.013035649,-0.019073755,-0.0032228443,0.0123711815,-0.01174332,-0.007552618,-0.00232844,0.003460781,7.2858784e-05,-0.02283141,-0.013450564,-0.035848565,0.025092041,0.037624605,-0.008887633,-0.029396199,-0.011348407,0.008257536,-0.0055189766,0.018540785,0.002585512,0.016435968,0.007564318,-0.011769293,-0.010464476,-0.022430087,0.008218483,0.0066767335,0.0019230962,0.02975861,0.0053430614,0.017197281,-0.008511112,-0.0113474885,-0.017957116,0.0020386267,0.023153013,-0.018974688,0.036543123,-0.0141501045,-0.0015648301,0.02230763,0.00870226,-0.005289261,-0.031877868,-0.011805307,0.010965595,-0.019407846,-0.017103406,-0.0076434007,-0.030673407,-0.027145537,0.014857325,-0.0069681937,-0.020252205,-0.02181346,0.0033004775,0.040489215,0.0027889954,0.0060239136,0.0075551705,-0.007825135,0.0063604047,0.005856737,0.004917356,-0.026957953,-0.021568807,0.024779694,0.008398331,-0.0112260785,0.0122079365,0.0261464,0.0063477657,0.022413537,-0.014732707,0.0036069378,-0.029935714,-0.014285158,-0.0112454975,-0.006444806,0.021104582,-0.04667832,0.011935774,-0.011752825,0.001617203,-0.0343648,-0.00066337036,-0.008820016,0.011087205,0.02170532,-0.0055820583,-0.019666525,-0.020331321,-0.01550063,0.029179608,-0.011325114,-0.019849872,-0.0057422384,-0.008477398,0.004159702,0.012682783,0.0023031577,0.025335522,0.003304338,0.023818411,0.01561012,-0.005918896,0.015869271,0.010318692,-0.012678774,-0.01846555,-0.018015996,0.0003423847,-0.01122929,0.0056898976,0.00013304691,-0.0034400122,0.024318742,-0.0039933203,-0.022975989,0.04447284,0.0015206618,-0.008727092,-0.018263161,-0.011116636,-0.012187588,0.014580301,-0.022914235,-0.018839654,0.001556546,-0.020906985,0.010796544,0.019730661,-0.036382787,0.026688727,-0.023823023,-0.0112497285,-0.012835385,0.0070804334,0.026100468,0.015818648,-0.012852844,0.0021679858,-0.0025563845,0.0059141694,0.011730574,-0.0037427659,-0.03359457,0.0015790684,0.0322419,-0.0051884283,0.0061518205,-0.014590188,-0.006665363,0.033213217,0.045182906,-0.001267111,-0.01399497,-0.016339755,0.0255032,0.0073334114,-0.0019006014,-0.06212432,0.009440555,-0.025203215,0.0017984997,-0.016552936,-0.011762476,0.027171653,-0.003782492,-0.03293259,-0.017700633,0.0077324216,0.042201515,0.015928281,-0.0036320789,0.025536345,0.0076501477,-0.025222534,0.021446453,0.0032565366,0.024703644,0.036331788,0.03372994,0.01024209,0.015747346,-0.013675928,0.0053377175,-0.0069978335,0.015678568,-0.02074651,0.009998573,0.0029933124,-0.012357067,-0.016287902,0.002687667,0.010995901,-0.009670943,0.0003051925,0.00053667976,0.011790564,0.00039096124,0.016568618,0.008613928,-0.004271748,-0.020131571,0.022587862,0.014247207,0.020394105,0.011607073,0.022167172,0.018968105,-0.021054888,-0.0010998339,0.00080190937,-0.010211738,0.0023147115,-0.03054944,-0.004898935,0.0016122699,-0.0030142004,-0.011926131,0.0075902725,0.00048285013,-0.041164972,-0.0038978413,0.005988115,0.014161227,0.00429096,0.001429992,0.009935365,-0.0020440472,-0.027183319,0.01937586,0.01924612,0.0036473742,-0.0011134029,-0.00079315685,-0.03388756,-0.025654892,0.02770606,0.0013091698,-0.016915945,0.007876137,-0.04071063,0.003514,0.017779289,-0.036013976,-0.015822235,0.03577866,0.0059539825,-0.012527186,0.023063438,0.014665112,0.009939906,0.03362612,-0.010545242,-0.0028611857,0.0066457726,-0.00386163,0.0011382588,0.011473483,0.0061902925,0.021206228,0.0027116935,0.022020495,0.012366464,-0.018515829,0.019659055,0.02711856,-0.02536281,0.025928415,0.0068875877,0.0072343075,0.0014260334,-0.14373285,0.03450605,-0.00020152779,-0.009112585,0.008204753,0.0163146,0.017585626,-0.0059338696,-0.01593289,0.004389816,-0.0053612785,-0.014952871,-0.0076887147,-0.03930708,0.014143964,0.112268195,-0.008067795,-0.022061499,-0.025681786,-0.03522618,0.0026223068,-0.020587128,-0.0011281557,-0.010090408,-0.011622464,-0.008692151,0.007953436,0.0119279185,-0.0064108707,-0.0011819479,-0.030775461,0.021228025,0.006718564,-0.021111935,0.0145261185,-0.003771376,0.0033359574,-0.0058801374,-0.0017407998,-0.0036537594,0.0032726023,-0.004870128,0.029957483,-0.008158594,-0.0218859,-0.00469679,-0.0070613334,0.0062760934,0.0021357026,-0.012126832,-0.008403801,-0.065589055,-0.022598071,-0.012576119,0.0043175793,0.006144663,-0.018943388,-0.0039995923,0.016711205,-0.009098874,-0.02008261,-0.0148966005,-0.00043812,-0.014669257,-0.0039997166,0.005719666,-0.00519272,0.009631741,0.008138374,0.002134345,-0.004758416,0.033100367,0.026267558,0.026794907,0.008199063,-0.0036374356,0.0055390745,-0.008131009,-0.018208072,-0.020870853,0.0054242276,-0.018163485,-0.00901217,0.01113343,0.017493693,-0.016970996,-0.013778948,-0.0015971613,-0.021277092,0.01890564,-0.019139703,-0.0028268644,-0.0066375937,0.0074678324,0.007756492,-0.002304096,-0.021386433,0.011465101,0.0076427893,0.018193757,0.022455396,-0.02408059,-0.003494346,-0.0017925813,-0.0026638836,0.011418554,0.012387879,-0.004893301,0.023448946,-0.0022610424]	3	\N	2026-01-31 11:52:15.189497+00	2026-01-31 16:32:00.921814+00
a2562c0a-5fa1-4ee6-87c0-7404135a1d1c	6eda01a1-1970-4562-b4cf-996ce9e22ff4	A and B throw a die alternately till one of them gets a '6' and wins the game. Find their respective probabilities of winning, if A starts the game first.	[]	MCQ	f	https://iljpsrbycqfunmpimjaa.supabase.co/storage/v1/object/public/question-images/6eda01a1-1970-4562-b4cf-996ce9e22ff4/1769897847515.png	Mathematics	Probability	["Total probability", "Independent events"]	medium	5	Infinite geometric series to calculate probabilities of winning	[-0.00082112884,0.024946382,0.021210078,-0.0050504687,0.06733083,0.0249044,-0.0016337137,0.001251637,-0.010245961,0.0049661137,-0.03585434,-0.015753917,0.03386459,-0.022252774,0.0070241257,0.0053516105,0.008666759,0.042062033,-0.072057135,-0.019202042,0.0367664,-0.035253707,-0.0057451143,0.015768029,0.06345698,-0.06601984,0.0017147285,-0.07914229,-0.020454187,0.012866283,0.0031657126,0.047110777,0.0066736196,-0.02390408,0.017696118,-0.006797395,-0.054905307,-0.01838716,-0.0016164968,-0.013137951,-0.068312265,0.030319056,-0.0017987716,-0.065087914,-0.0030518507,-0.03648419,0.004508432,-0.03574479,-0.025021993,0.013601487,0.013027417,-0.01011736,-0.0724071,0.031442046,-0.024372822,-0.04750142,-0.0055259634,-0.0012184567,-0.009337066,0.00012694756,-0.0011827663,0.0024597938,-0.06632134,-0.027123105,-0.017158937,-0.00018120461,-0.06692889,0.0136243785,-0.0260216,-0.005867061,-0.014995902,-0.04971285,-0.053290717,0.015086082,-0.029565949,-0.035897925,-0.011710229,0.026521321,-0.055229705,-0.00742185,-0.0052775433,-0.002648683,0.062297788,0.020062122,0.0143994065,0.023690907,0.035230108,-0.008248451,0.00076635025,-0.027125817,0.029609006,0.022299862,-0.05345391,0.0050200247,0.03279979,-0.027278004,-0.064540066,-0.07638365,0.08369221,0.005643112,-0.022173366,0.019858686,-0.04286208,-0.00047538246,0.051839042,0.04100708,-0.021296741,0.028044399,0.018560803,0.013777545,-0.015828487,-0.028807776,-0.023318727,0.03845134,-0.027069876,-0.02164316,0.045074187,0.027673308,-0.007202716,0.009614603,-0.034293666,0.062032286,-0.03108592,0.0887519,-0.031722218,-0.0459902,-0.0045016683,-0.018835725,-0.046759374,-0.04196833,0.031953517,-0.031109145,0.009107563,0.06511164,0.027301384,-0.005115106,-0.016243776,0.042848837,0.021113047,0.015476596,-0.015376767,-0.03949239,-0.043549195,0.043976054,0.011882161,0.016587308,0.00087644183,-0.0028516839,-0.010443932,-0.024342233,-0.074716516,0.068151414,0.00940142,-0.017698422,0.0068187215,0.016113328,0.053512406,0.00055477855,0.08681486,-0.025586804,-0.0035895996,-0.013323657,0.017087178,-0.033297606,0.029835451,-0.09109939,0.0063955863,-0.026796846,-0.04904683,-0.0046057855,0.03165934,0.03830914,-0.038276784,-0.051804073,0.061302118,0.060928732,0.038463503,0.007519089,0.030139415,-0.04493387,0.07282234,0.02356021,-0.051259406,-0.04946428,-0.029454112,-0.015070792,-0.04995625,-0.00076998165,0.046437718,0.03742142,-0.025588766,-0.006797816,0.006898467,0.0053724013,-0.014448509,0.051244773,0.026058638,0.061832022,0.069279395,0.016483022,0.008279084,-0.027997574,0.047248576,0.040314842,-0.0056506046,-0.010449735,-0.0016770505,0.014947942,-0.058185272,0.052634034,0.031794753,0.03135105,0.048437994,0.046774562,0.0043274136,0.010827015,-0.0449888,-0.015421875,0.012850254,0.025434688,0.085495345,0.011286919,0.05741581,0.0056723864,6.377676e-05,0.009828048,0.021092843,-0.024086133,0.023492059,-0.03655449,-0.0019559145,0.05093458,0.009239537,0.044934344,-0.030294275,-0.06491391,0.008778116,0.017585203,-0.0098908255,-0.033160355,0.004698007,0.05037843,-0.038453992,0.014931329,0.07656953,0.015066576,-0.04483251,-0.0011541967,-0.02995668,-0.031963114,-0.04257786,-0.049111564,-0.030135533,0.011080009,-0.09694116,-0.06269,0.017308662,0.01256984,0.008320879,-0.09039431,0.014491188,-0.012125341,0.036400076,-0.009887699,0.012836009,-0.07659261,-0.03339215,0.019764585,0.013148982,0.016342403,-0.0041154437,-0.043490022,-0.05673513,0.033406503,0.009864844,0.00074636645,-0.030918088,0.021194661,0.00234975,-0.10414678,-0.04650792,0.0016806548,-0.02162679,-0.0042741927,0.009254269,-0.027670585,0.062109176,-0.017251983,0.024532052,0.0011294036,0.05177954,0.022263737,-0.043231506,-0.057831634,-0.0029343155,0.051104866,0.042388123,-0.013714384,-0.00070132426,-0.016554603,0.009926066,0.08220189,0.03190298,-0.006815803,-0.01668659,-0.0125144385,-0.064179786,-0.05228957,-0.05829355,0.03829517,0.018031517,0.01619132,-0.036053773,-0.06225376,-0.018637424,-0.04480446,-0.04964619,0.003818825,0.04017463,0.035856754,-0.026040783,-0.041635074,0.032359928,-0.012607562,0.0050630253,-0.033589315,-0.026090508,-0.030973934,-0.088983625,0.04919401,0.015924355,0.0034173997,-0.06581382,-0.00044824748,-0.031107506,0.01068068,0.016133422,0.0071588657,0.033333655,-0.0001230641,-0.030448547,0.06286287,0.03756277,0.026329443,0.011594038,-0.09680826,-0.07850122,-0.021093434,0.0038159592,-0.0140967965,0.025282383,-0.019629937,0.0041402467,-0.023206847,-0.006175561,0.01296661,0.07020795,-0.0099817,-0.026453521,0.044471152,0.03527308,0.016896836,-0.08079939,0.032427505,0.0045846743,-0.004449875,0.013328996,0.05116762,0.046182632,0.020569706,0.061397664,0.05512168,-0.0055313203,0.01130107,0.009595606,-0.032244164,-0.027825918,0.004773023,0.009733272,-0.05717511,-0.0034697966,-0.052884083,0.00027532844,0.016164156,0.010809283,-0.0041510984,-0.05011079,0.00012813238,-0.0043723695,0.022617972,-0.034446012,0.04518524,-0.0007999698,-0.04347379,-0.03511949,0.05155668,-0.021488281,0.0059329,0.015599984,0.06103649,0.013221814,-0.031240692,0.031080542,-0.00577899,0.02100327,-0.073701404,0.089336805,0.001035764,0.023316212,-0.012923121,0.0077646803,-0.044953894,-0.037634064,0.009793982,0.012374006,-0.07240866,0.026967144,0.008743117,0.008808782,0.0794987,-0.036103778,-0.005902633,0.038032558,-0.034281693,-0.047549278,-0.027129926,-0.008964366,-0.0096541485,-0.036744043,0.022525117,-0.0023774111,0.045375437,-0.011221035,-0.0038201269,0.07288846,-0.025321275,0.035258017,-0.017752606,-0.014069209,0.03833398,0.033860978,-0.009268346,0.0082435645,0.0006553512,-0.014238924,-0.00062911207,0.026131252,-0.0030029255,-0.033831548,-0.04865077,0.0163866,0.005548191,0.10230125,-0.039881606,-0.09255972,-0.028907828,0.07240533,-0.03513804,0.013706993,0.11267211,-0.016667286,-0.009354984,0.01413412,-0.050020464,0.054474887,-0.032076273,0.0026636538,-0.0029363693,0.026159428,0.054230925,0.026394177,-0.036052696,0.04633674,0.04163368,-0.042899564,0.009994376,0.045028605,-0.057756897,-0.009454607,-0.012887584,0.002569875,-0.013080243,-0.009081714,-0.0001031868,0.046071753,-0.032997437,-0.009408013,-0.002282157,0.012862306,-0.00084633124,0.008856076,0.055982284,-0.04650745,-0.04467135,0.013300392,-0.010625512,0.07305573,0.0068699988,0.003616562,0.043990754,0.059934564,-0.0011899525,-0.0015895386,-0.035645057,-0.008047954,-0.0486855,0.009512763,0.009314419,0.00055494555,-0.03507053,0.020732097,0.035020124,0.032589246,0.016939156,-0.03923974,0.030145934,-0.012972252,0.022156248,0.033895034,0.05199451,0.023961088,-0.051795527,0.039862897,-0.041396983,0.02477839,0.045812696,-0.07060402,0.012321623,-0.034236435,-0.023774344,-0.0031292858,-0.011403267,0.015030894,0.030790372,0.028501907,0.04234951,0.027345913,0.026517179,-0.057054535,-0.0011426957,-0.010536506,0.00063699496,-0.030888934,0.004216721,-0.0059015243,-0.050251916,-0.0044989097,0.045025624,-0.043017894,0.0012224746,0.04408331,-0.054878194,0.047291044,0.0274424,-0.056123048,-0.045105413,-0.011950622,-0.0087101,-0.026497621,-0.0009520701,-0.024534522,-0.011461784,0.033906426,0.03831693,-0.02650471,0.02472058,0.01494333,-0.0021661632,0.023521524,-0.0076504922,0.022049284,0.020250041,-0.029390948,-0.0074131973,-0.011777751,0.029329514,0.04248133,0.036971673,0.027313594,-0.05242926,-0.07698099,-0.0004201057,0.00036007547,-0.042542934,-0.06259668,0.032806784,0.005426548,-0.041171927,-0.017996883,-0.034604684,0.005491302,0.01974463,-0.0027772817,-0.07620904,-0.004608628,-0.012120374,0.023444844,0.03281741,0.00092000805,-0.024834868,-0.0056149173,0.03683614,-0.00080304197,0.02535632,0.012424834,-0.006149806,-0.030794894,0.013688599,-0.003007382,-0.012838906,0.014562361,0.009853952,0.006452023,0.058012467,-0.08269235,-0.027221408,-0.016735045,0.018622346,-0.00073364156,-0.027666688,0.014815943,0.023499154,-0.006841184,-0.06391266,-0.045830928,0.019545881,0.034341794,-0.008611772,0.07715621,0.052997667,0.0012728019,0.042202562,-0.032299872,0.01577576,-0.021071767,0.023036305,0.016522095,0.02155199,0.006773311,-0.0041551637,0.019667411,-0.014784928,0.08400953,0.027958455,-0.07115252,-0.007920326,-0.013259361,0.045910478,-0.06419668,0.03405978,-0.0157612,0.016709425,0.042981014,-0.041219328,-0.047637127,0.03941664,-0.00031610215,-0.061392255,0.021353655,-0.0277002,-0.009221918,-0.04667202,0.00565916,0.01189299,-0.01231236,-0.055241145,-0.049282786,0.0055418313,0.05717231,0.033969983,-0.0132115735,-0.01244364,-0.010009542,0.072751515,0.02155477,0.040354043,0.024193482,0.033238683,0.0016186683,-0.021602374,0.04416207,-0.01567625,-0.032333843,0.052306786,0.005249232,0.016250547,0.004858917,-0.0060203113,-0.027265633,-0.010016223,0.01703577,0.010588037,-0.032857902,-0.07217526,-0.06883114,0.039886642,-0.029485496,0.06706293,0.028979853,-0.011441726,-0.03923659,0.00054954423,-0.033069186,0.008860675,0.03442847,-0.025068931,0.057610936,0.027545204,-0.07769682,0.065266706,-0.07162609,-0.02039822,0.05145591,-0.058693424,0.027142843,0.025470257,0.007164512,0.01933996,0.028799154,0.0071363035,0.020521997,-0.02957567,-0.03569352,0.037255038,-0.01650987,0.021285657,-0.0005408216,-0.034721784,-0.04197338,0.050915927,-0.0045683826,-0.026590448,-0.0037796944,0.014512278,0.0056284345,-0.020078486,-0.051811714,-0.043697473,-0.07527648,-0.06476398,0.03242394,0.02440383,-0.025287284,0.04141418,-0.0023674006,0.0037014692,0.05268188,-0.060769156,0.0010240015,0.03973013,-0.0021470643,-0.023982078,-0.025530849,-0.012491175,0.095813215,-0.019570878,-0.0063152728,-0.006947405,0.0047233324,0.0101638995,-0.07531233,0.050017726,-0.015019678,0.028096942,-0.060670495,-0.022880448,0.0039066384,-0.056388624]	2	\N	2026-01-31 22:36:53.466156+00	2026-01-31 22:36:54.17336+00
b9727bd5-aff8-499d-86a4-dd2c6a6fea9d	6eda01a1-1970-4562-b4cf-996ce9e22ff4	Two cards are drawn from a well shuffled pack of 52 cards one after the other without replacement. Find the probability that one of them is a queen and the other is a king of opposite colour	[]	MCQ	f	https://iljpsrbycqfunmpimjaa.supabase.co/storage/v1/object/public/question-images/6eda01a1-1970-4562-b4cf-996ce9e22ff4/1769899129290.png	Mathematics	Probability	["Conditional probability", "Multiplication theorem"]	medium	5	Calculate the probability of drawing a queen and then a king of opposite color, and the probability of drawing a king and then a queen of opposite color, then sum these probabilities.	[-0.042783868,0.023459796,-0.003518657,-0.01571906,0.046390314,0.024640264,-0.00047686047,0.01126915,0.047201253,0.02617881,-0.022604913,-0.0035442477,0.03187349,0.0012383834,0.020136554,0.016268332,0.11819899,0.04268828,-0.08689335,-0.0036192844,0.05684063,-0.014437897,0.06408242,0.0066007767,0.011785439,-0.009563086,-0.009280652,-0.032732975,0.0038196289,-0.035476476,0.0017516585,0.05271256,0.055969447,-0.009992284,0.03259344,-0.031620946,-0.051195063,0.020126728,0.035185695,-0.040397484,-0.043162394,-0.041652568,0.036373757,-0.007824989,0.017845472,-0.038036004,0.026240686,0.0172375,-0.011709435,0.017004974,0.029403625,0.023897752,-0.039797533,0.05782085,-0.014891755,-0.07885308,-0.071296215,0.032905996,-0.026358705,-0.060175255,-0.00857238,0.015005016,-0.015985927,-0.050019156,0.023401273,0.0045369817,-0.03644523,-0.01823238,-0.04986459,0.02285012,0.064198226,0.0086167725,-0.022163915,0.021216467,-0.015893055,-0.04559797,0.03239347,0.0010913588,-0.059853327,0.037069287,0.010001516,0.007905026,0.12062226,0.016558615,-0.0059332256,0.0051399847,0.050813213,-0.03752356,-0.013889442,-0.020805225,0.095666625,0.00056682393,-0.07422329,-0.038170584,0.014720965,-0.022788776,-0.019183416,-0.043356426,0.062027495,0.058970813,-0.07385218,-0.026606131,-0.07639437,0.010042758,-0.01445359,0.055994652,-0.010719822,-0.033172306,-0.051590193,-0.02301249,-0.014017391,-0.025614701,0.005226014,0.013909255,-0.025066687,-0.05257236,-0.026151417,0.027597921,-0.016091801,0.031297833,0.03557746,0.028339906,-0.08611877,0.058533896,-0.021116802,0.00026420932,0.009334887,-0.0592504,-0.06407849,0.002007618,0.047547184,0.010106047,0.0015936943,0.10277921,-0.006734203,-0.027432075,0.014172525,0.037429497,0.0020158119,-0.008656083,0.01695694,-0.0153297335,-0.05461536,0.015676515,0.007500671,-0.05382839,0.059969872,0.01678127,-0.0062777065,0.008487652,-0.04023872,0.03461033,-0.004818246,0.056571607,-0.010709023,-0.03877716,0.068696864,0.01906839,-0.0024185707,-0.022797532,0.008572915,-0.03570592,-0.016809797,-0.032940816,-0.010056727,-0.011634904,-0.018818906,-0.020798877,-0.04063832,-0.034347914,0.034685384,-0.022031993,0.0017000951,-0.0138780875,0.007756803,-0.009411929,0.046072733,0.011356067,0.06338634,-0.012891123,0.03127351,0.02826195,-0.023305014,-0.048838377,-0.04364644,0.023669962,-0.02721033,-0.033146262,0.038386267,0.0031949396,-0.08341308,-0.018217208,0.008439498,-0.008502833,-0.038691916,0.03332926,0.014173935,0.01839964,0.02249335,0.0055857883,0.04458119,-0.023199169,0.053085826,0.002805365,-0.03179046,-0.02172349,-0.06073246,0.01229376,-0.07117712,0.040159795,0.03580831,-0.018681854,0.03959582,0.013152265,0.0020584601,-0.06052265,0.048385948,0.008654584,-0.015549266,0.08818986,0.02990384,0.0010437275,0.06484097,-0.008064198,0.013865801,-0.048482202,-0.004744501,-0.008343921,-0.003621202,-0.056579337,-0.009155562,0.019124338,0.010189565,0.006542191,-0.046730228,0.0022007104,-0.012658329,-0.07624846,-0.02479066,-0.0042422083,-0.054228324,-0.019497605,-0.013416571,0.030855207,0.061489042,-0.012031781,0.017038168,-0.010400938,0.033342864,-0.021471206,-0.056650933,-0.0023976003,0.026447587,0.009924026,-0.044173714,-0.027072333,0.03817128,0.009680009,0.0145450635,0.035246,0.0216314,-0.053750746,-0.006297498,0.020363044,-0.020886067,-0.07128014,-0.010126862,0.046349157,0.016655289,0.028767003,0.037717357,-0.0506006,-0.10760156,-0.028485514,0.0152217625,0.039557714,-0.03382945,-0.026995007,-0.0140975565,-0.06979743,-0.0021703045,-0.03612316,0.02100717,0.012707581,0.051300578,-0.034975234,0.028874543,-0.043666184,-0.050796755,0.03561798,-0.029033309,0.043964416,-0.04542849,-0.12390418,0.022464264,0.090259865,0.029004212,0.04188577,-0.054388084,-0.022495914,0.0020358667,0.055451617,-0.004058854,0.022115719,-0.03801245,0.04388482,-0.04200227,-0.04182115,-0.032010473,0.055507988,0.077653416,0.03407299,0.0063143354,-0.028236298,-0.049944222,-0.029424964,-0.032090083,0.05225455,0.052750282,0.038193136,0.009894517,0.015215654,0.04372362,0.004762966,0.012110488,0.01486986,0.0058406023,-0.010106395,-0.05326267,0.052453075,-0.011126141,0.014650966,-0.020515013,-0.002656987,0.015956052,0.028105166,-0.027777351,-0.0038411045,0.029059859,-0.00534914,-0.018961865,0.010277345,0.023981323,0.026309395,-0.015978862,-0.073753536,-0.0027867218,0.020692578,0.0066494737,-0.0118241785,0.038643323,-0.0071896166,0.008916194,-0.015324522,0.013228579,0.04663046,0.060794424,0.06970664,-0.006746683,0.0057037645,0.02428547,0.022446346,-0.031016124,0.028163416,0.0078766085,-0.042752393,0.060003214,0.029240057,-0.009263328,-0.041566424,0.019146925,-0.0033533308,-0.008472131,0.0017038007,0.005788448,-0.02238746,-0.036602464,-0.009137436,-0.007746883,-0.014300626,-0.020534689,-0.028830817,0.049323052,0.03527361,-0.004951383,0.016389001,-0.019288944,0.012353396,-0.024080819,0.009723163,-0.04639498,0.032849118,-0.005492688,-0.022241004,-0.0037461126,0.061388116,0.032978065,0.038929693,0.013830975,0.044909395,-0.027952781,-0.0008041573,0.014942144,-0.032810256,-0.00121698,-0.017992184,0.06492872,0.030960944,0.020296875,0.02833972,0.03443349,-0.057325505,-0.038594186,0.0062741125,0.031986304,-0.07505596,0.00556367,-0.029498281,0.007421795,0.029687624,-0.029879173,-0.033594567,0.01577724,-0.033681672,-0.018012248,-0.038016193,-0.00081426074,-0.026306706,-0.0866335,0.04574828,-0.021501495,0.044427894,-0.013036708,0.031626515,0.10139217,0.027486624,0.052899566,-0.061184883,0.03285541,0.0018223824,0.01947728,0.01680155,-0.0031237437,0.008885959,-0.01262337,0.046741273,0.02299062,8.645374e-05,0.01375926,-0.035715077,0.053192735,0.0089839045,0.02403285,-0.05605979,-0.065473475,-0.036790196,-0.05239729,-0.009824138,0.009433608,0.032529697,-0.017904654,-0.0017167405,0.04010724,0.008556908,0.0046907105,-0.018326884,-0.0076066963,0.0008032993,0.017783599,0.07554244,0.019159002,-0.013432292,-0.006548451,-0.061732434,-0.017036842,0.046692442,0.03695423,-0.012092898,0.019241037,0.04725717,9.0588685e-05,-0.017592875,0.0052629225,-0.04152312,-0.013655233,0.006286118,0.039346613,0.033900023,0.03643811,0.034358554,-0.010052402,0.009534039,-0.03735448,-0.07208768,0.0074323644,0.022235172,0.015507214,-0.0023093438,-0.00091876806,0.07960997,0.0119969975,-0.013969247,-0.002538909,-0.048913106,-0.011882029,-0.05925278,-0.004793384,0.0037526072,-0.012188823,-0.0422273,0.09141664,0.0025288214,0.021289473,0.003815495,-0.0086983945,0.0287379,-0.044227086,0.048180148,-0.0067246724,0.06404018,0.010207573,0.02139416,0.02995251,-0.019222373,0.06586643,-0.021051543,-0.028800195,0.014290615,0.038050268,-0.0050448556,0.013566826,0.022855539,0.0009868426,0.01655786,0.03768587,-0.025855366,0.03548554,-0.0072231707,-0.030174894,-0.007568663,-0.054021474,-0.056603365,-0.009781054,0.062129777,0.0060383505,-0.030591603,-0.025553629,0.03194952,-0.031286456,0.031748265,0.011771124,-0.076500766,-0.021888327,-0.07307973,-0.03556376,-0.041937698,-0.010172668,0.024855798,-0.028139362,-0.08319465,0.04111662,-0.022203868,0.04190051,-0.026755609,-0.029782917,-0.025594238,0.005431137,0.015540827,-0.034110695,-0.024715915,-0.0028236643,-0.0062463945,-0.056081194,-0.043171305,0.0075101084,0.04562977,-0.035882987,0.035513338,0.037235335,-0.010016628,-0.01682154,0.01179655,-0.008643369,0.0023407487,-0.02790429,-0.042221326,0.03746067,-0.024663098,0.05931152,-0.07926045,-0.022518354,0.05408556,-0.03400978,-0.057158038,-0.0056748306,0.027212258,0.05167683,-0.0076093916,0.005890074,-0.012176597,-0.028563747,0.032074098,0.039155938,0.049071413,-0.004331217,-0.029367896,-0.06518019,-0.044770665,-0.037093285,-0.04203468,-0.023729762,-0.0074702054,-0.051803462,-0.00021324413,-0.00090965995,-0.0025401416,-0.053421162,-0.022493586,0.034475893,0.034628965,-0.030897705,0.0076109194,-0.003099199,-0.04385273,-0.06310136,0.042148095,0.058436085,-0.037086163,0.097916566,0.06831887,-0.044563975,0.067632355,-0.00773189,-0.02590351,-0.0036564916,0.037566468,0.006989583,0.02232796,0.013464865,-0.04361506,-0.019980272,0.05039856,0.05877175,0.042381328,-0.046934996,-0.049882013,0.008653544,0.09870976,0.0037702203,-0.01988086,-0.039106764,0.0321495,0.009495611,-0.00949114,-0.016773567,0.029972311,0.0068959817,-0.05404744,0.05496239,0.0015159401,-0.045712247,-0.003595742,-0.017404232,0.025751581,0.0025192203,0.010906678,0.009954905,0.011996564,0.048123877,0.036453627,-0.014656128,-0.013205127,-0.010633066,-0.013288613,-0.009624523,0.027123261,0.07916961,0.02578366,0.023107883,0.03771022,0.045871943,-0.048045173,-0.0049746567,0.0636416,0.019630905,0.013825018,0.036352742,-0.06768296,0.010988721,0.00086624094,0.05038267,0.020610841,0.01306104,-0.024726138,-0.034925494,0.052686,-0.025959456,0.03206131,0.010557389,0.003827856,-0.009482413,-0.01493653,0.021007216,0.03466009,0.05928606,-0.016030457,0.0046503767,-0.0012793199,-0.08212555,0.03780863,-0.018829316,0.03045574,0.022088088,0.0051236153,0.0100204535,0.047135722,0.025115006,0.008954731,0.01774415,-0.010470854,0.03208566,-0.02420604,-0.044670574,-0.005000504,-0.025860129,0.045867562,-0.021328775,-0.033626672,0.020163903,0.059428327,-0.021457484,-0.018479627,-0.02568303,0.024583612,0.021708434,-0.036703393,0.025565442,-0.016634367,-0.007577401,-0.06676335,0.034647897,0.021025589,-0.029366804,-0.0101618245,-0.00814629,0.0064022797,0.0400603,-0.073443085,-0.012356811,-0.028256658,-0.05375036,-0.022437869,0.016309315,0.047463708,0.060955334,-0.027473692,-0.0054423795,0.014133256,-0.0013422115,0.00077241124,-0.049703732,0.050723325,-0.033456497,-0.0103437565,-0.0044971765,-0.010819627,0.01427005,-0.055954598]	2	\N	2026-01-31 22:39:27.656656+00	2026-01-31 22:39:28.038824+00
1954e9c7-4c54-46ce-b507-1a5947e0bfab	6eda01a1-1970-4562-b4cf-996ce9e22ff4	The probabilities of two students A and B coming to the school in time are $\\frac{3}{7}$ and $\\frac{5}{7}$ respectively. Assuming that the events, 'A coming in time' and 'B coming in time' are independent, find the probability of only one of them coming to the school in time.	[]	MCQ	f	https://iljpsrbycqfunmpimjaa.supabase.co/storage/v1/object/public/question-images/6eda01a1-1970-4562-b4cf-996ce9e22ff4/1769899307114.png	Mathematics	Probability	["Independent events", "Multiplication theorem"]	easy	5	Used the concept of independent events and calculated the probabilities of the required scenarios.	[0.055078145,-0.008683167,0.013278493,0.038103916,0.06505037,0.061793067,-0.03488166,0.05485726,-0.0037271269,-0.028510217,-0.0103854155,-0.023250649,0.031234846,-0.013695166,0.0006568261,-0.027162341,0.033245925,0.0019775229,-0.034389522,-0.022828389,0.005782233,-0.00026940537,0.016676612,0.05669349,0.0086317435,-0.009365785,0.0064832494,-0.034927085,-0.031939138,-0.01612421,0.0070378357,0.0019319463,-0.026635565,-0.047038812,0.048213664,0.017933197,-0.048897617,-0.018192811,0.0450188,-0.030557433,-0.0924979,-0.0128422445,-0.03379205,0.04078309,-0.04478412,0.017677821,-0.0010642523,0.033918735,0.02628998,-0.033834543,-0.06678082,0.03049919,-0.044616774,0.0070778923,-0.045300562,-0.052045416,-0.011761556,0.008716324,0.004933735,-0.011820189,-0.041511387,0.025970945,-0.052610833,-0.0076029114,-0.0020216482,0.047234453,-0.059164427,0.014896862,-0.048595633,0.039079275,0.022737833,-0.0038686902,-0.074481055,0.04603713,-0.018772226,-0.072203204,0.063426174,0.06255433,-0.025451886,0.06598356,-0.010952815,0.01759248,0.0378265,-0.0029692834,-0.011816487,-0.012483405,0.027358774,-0.010477777,-0.03852013,-0.06484183,0.014185658,-0.032261007,-0.02450064,-0.034607444,0.07875104,-0.019301245,-0.040762845,-0.018312775,0.12369192,-0.07393209,-0.010391376,-0.002669037,-0.02724687,-0.028549261,0.008125837,0.017479192,-0.016916694,-0.05504996,-0.049840614,-0.028753962,-0.03991266,0.0025398436,0.0040289075,0.014626857,-0.069116205,0.03843341,-0.028516343,0.01093777,-0.042842876,0.03175555,-0.030142277,0.020478943,-0.018531613,0.10789699,0.022344925,-0.004398118,0.03563168,-0.033679683,-0.041730784,0.0019444423,0.011697954,-0.013758097,0.06512926,0.051494032,0.06446608,-0.012415717,0.014519607,0.0059784874,0.019327695,0.038744356,0.01952865,-0.020075524,-0.05118289,0.0365932,0.017285764,0.009603271,0.04733309,0.037698966,0.035263147,0.013857845,-0.03567046,0.031145053,0.022621699,0.04165396,-0.01745667,0.010753951,0.041613493,-0.016412113,0.04696369,0.003496268,0.0017135132,-0.036761384,-0.036405683,-0.031240765,0.042222288,-0.028110482,-0.041366916,-0.0016949708,-0.048023015,-0.03109918,-0.008007682,-0.04004532,-0.040166013,-0.04491324,0.01962984,0.008340501,0.045937996,-0.032248292,-0.0045421747,-0.04108628,0.023221903,0.028092507,0.01607283,-0.07627419,0.0034369251,0.002570222,0.027767899,0.007630022,0.08018547,0.013832983,0.0035901747,0.009836536,0.03139008,-0.018133381,-0.07381818,0.0007279384,-0.021825217,0.055073347,-0.030953873,0.029073667,-0.0013339983,-0.017577697,-0.006547285,-0.001758758,-0.050351735,0.0035051678,-0.029783502,0.0015645638,-0.03599855,0.039799806,0.063459426,0.047382973,0.049049884,0.031941045,0.033934765,0.0050354055,0.040500194,-0.0013844486,-0.009031143,0.024191238,-0.009250568,0.014873974,-0.004308386,0.03735677,-0.0048952647,0.01652516,-0.026366208,0.0203906,-0.018067034,-0.104929455,0.033384435,0.014077959,0.018288603,0.09507173,-0.05092767,-0.054601673,-0.0074032117,-0.008036601,-0.018413898,-0.0347325,-0.025325248,-0.025659135,-0.086056985,-0.029770017,0.018898802,0.07082135,-0.033434417,-0.013723501,-0.034113962,-0.012562988,-0.048983146,-0.03318826,-0.06522139,-0.05151515,-0.11643241,-0.032348268,-0.017982107,0.030204466,0.03150002,-0.04837081,-0.010258532,-0.034231547,0.03773628,0.005976808,0.033998884,-0.07058958,-0.10007108,0.028743083,0.009634983,-0.021840319,0.01178238,-0.062754445,-0.084740154,0.00041006814,-0.03824811,0.014214296,-0.0010218528,-0.002341946,-0.013669773,-0.033452194,-0.014295399,-0.01820868,0.022366552,-0.012243092,0.0038028914,-0.03906822,0.024325995,-0.0349409,-0.0004348404,-0.033325776,0.029898541,0.015013037,-0.02224501,-0.04876425,0.019040117,0.019732974,0.016424663,-0.008291732,-0.05228974,-0.007581711,0.037369907,0.049049895,0.011944615,0.014274846,-0.03629775,0.02938613,-0.054757886,-0.011876873,0.00091370445,0.018315587,0.090898804,-0.0062015397,-0.017965008,0.006531909,-0.051704224,-0.029722502,-0.0806974,0.020948397,-0.01999547,-0.015730998,-0.023077928,-0.0054618893,-0.0233989,-0.03407202,-0.0061663836,-0.024121674,-0.07281128,-0.016998943,-0.05060124,0.0032274025,0.056203,-0.011205061,0.009503946,0.010594281,-0.02218754,-0.03642211,-0.059096947,-0.002782989,0.041764677,-0.006795014,-0.030195735,0.06425812,0.032518208,-0.032730613,0.014544693,-0.07767565,-0.0059278575,-0.048504107,-0.0038060255,0.01253257,0.067293845,0.0647171,-0.09561408,-0.00717164,0.020644812,0.022332992,0.021874284,-0.0081860265,0.035053365,0.029466167,-0.0024329778,0.004790302,-0.05006921,0.031259745,-0.028344262,-0.027570719,0.0076178294,0.046423588,0.042957872,0.019394321,-0.0011580247,0.052615218,0.0648474,-0.036191564,-0.005925531,0.0055478555,-0.036058955,-0.009278991,0.021827448,-0.04524157,-0.012587129,-0.030391647,0.016953917,0.095928065,-0.015498697,0.041223202,-0.06881561,-0.031183098,-0.007695746,-0.01526596,-0.006214361,0.06285427,-0.009516206,-0.0039291945,0.016030941,0.0893409,0.031388003,0.008051164,0.009992215,0.0338024,0.028686183,0.0018157249,0.06292227,-0.05127993,-0.01780675,-0.028387688,0.09232773,0.015499767,0.0336833,-0.022397181,-0.008008035,-0.05013538,0.016875125,0.027832346,0.018419221,0.011288611,0.04032901,-0.005964732,0.0071416534,0.069915056,-0.06285385,0.022817763,0.044480145,-0.019894598,-0.0056921523,-0.021080725,-0.028430007,-0.011403382,-0.04761415,0.019228797,0.005448932,0.05439129,-0.007989663,0.004231177,0.026456686,0.033806816,0.040455125,-0.020126741,0.04658589,0.0083935,0.023581183,0.010170807,-0.010853255,0.013415099,-0.0014591382,0.008122599,0.016356267,-0.0017900299,-0.049068723,-0.09357031,0.016169725,-0.10579627,0.060533058,-0.020389993,-0.0311408,0.025422556,0.03916186,-0.043705948,0.02579729,0.094710484,-0.06122739,0.0022860954,0.010272721,-0.029362215,0.08392655,-0.05623792,0.012003408,0.026885485,-0.009628687,0.025964959,0.00068981684,0.023205131,-0.0022481582,0.030022956,-0.030792411,0.041594516,0.04495483,0.036361437,-0.01462899,0.0022380322,-0.026265055,0.006662432,-0.002930531,-0.014621809,0.0553513,0.007869073,0.0026032925,0.030094327,-0.059382122,0.04699043,-0.0051240823,0.045208517,-0.030320488,-0.02446159,0.03835222,0.011080155,0.022453973,0.0154529335,-0.04211969,0.06186971,0.02653003,-0.0018680338,-0.0020804803,-0.039354596,0.0035713227,-0.021203488,-0.00764543,-0.016719388,0.02375775,-0.054144308,0.03679209,0.0031615633,0.018509068,-0.014622841,-0.012377984,-0.0066955127,-0.026778432,-0.008158678,0.0039773956,0.0642623,-0.010543195,-0.05605206,0.020993209,-0.024685157,0.07070922,0.000529885,0.022021769,-0.008087599,-0.028111143,-0.024449462,-0.006700741,0.05616263,0.04756693,0.046785273,0.046979755,0.0060110693,-0.015116926,0.010829293,0.0055350536,0.003688511,-0.008575143,0.024865784,-0.045533326,0.011253868,0.027833331,-0.037964847,-0.017787827,-0.011074222,-0.028448243,0.022596134,0.033405058,-0.03596921,-0.0010909751,-0.011657457,-0.052265674,-0.023316892,0.012303773,0.013522885,-0.002363564,-0.009618201,0.0133526465,-0.054390635,0.012952384,-0.0180237,-0.016226638,-0.020325704,0.011342308,0.0012524964,-0.005098571,-0.010569558,-0.00082720345,-0.0022177957,-0.008993243,-0.05220054,0.026512744,-0.04827343,0.015241391,0.005140343,0.03336808,-0.06948457,-0.028242376,-0.00060096406,0.017439963,-0.009015768,0.00045923094,-0.029691825,-0.014857532,0.006200545,0.05257746,0.0055799778,0.007957491,0.011787343,-0.005100424,-0.09189465,-0.028385468,-0.059775885,0.03284688,0.068947494,-0.012064885,0.004143128,0.016649514,0.01926792,0.0391433,0.028857214,0.024411356,-0.037135392,-0.06473147,-0.0033769847,-0.02467967,0.02369831,-0.0020343473,-0.0125175975,-0.0578019,0.05323676,-0.07729967,0.022175362,-0.038195472,0.000855176,0.030054905,-0.007875537,0.010123823,-0.05640109,-0.0617931,-0.055800147,-0.036449347,0.014484357,0.039575443,-0.022393722,0.026217952,-0.03245721,-0.0006113835,-0.0069240476,-0.017835211,0.01427968,-0.015369837,-0.018822212,-0.036570292,0.004522099,0.030562814,0.01812922,-0.005914493,0.029161932,0.019540366,0.0012502214,-0.0475924,-0.0026467321,0.0037332058,0.037768595,-0.05972348,0.02475885,0.01356589,0.04617557,-0.003624326,0.0027987282,-0.05918755,0.012979041,-0.011665762,-0.03273513,0.037839286,0.028711386,-0.0070832577,-0.111676246,0.0007421457,0.004592132,-0.0151697695,0.021356575,-0.024037924,0.0384343,0.022342315,-0.0033845631,0.014938449,0.0074366215,0.009756779,0.042069685,0.020055015,0.07215942,0.03913792,-0.0026037586,-0.03907862,-0.014365757,0.053301282,-0.0039564185,-0.05102989,0.004189105,0.016904991,-0.039760847,-0.027294444,-0.048980854,-0.05147433,-0.019737706,0.024208866,-0.00863968,0.001672779,-0.024946034,-0.009521761,0.0056568766,-0.009581667,0.053226296,0.058423117,-0.017567089,-0.06531818,-0.040469203,-0.018829977,-0.0078077717,0.023938773,-0.04606197,0.025846444,0.010815976,0.0038687075,0.02486989,-0.03271899,0.009226704,0.08251172,-0.061298527,0.038158946,0.025428237,0.0052699037,0.005282849,0.00493926,-0.021461602,0.04336603,-0.040232632,-0.05117633,0.0025681201,-0.017699214,-0.047066886,0.01587712,-0.028979087,-0.04352876,0.054810267,0.0041025644,0.00018687804,0.0024497146,0.0059631504,0.00041134685,-0.05391214,0.019733677,-0.0029873024,-0.024707,-0.03787509,0.040272307,-0.015282565,-0.04026257,-0.004052584,-0.028749226,0.03676993,0.07309243,-0.052893028,-0.034564868,-0.049543478,-0.06979763,-0.010660831,-0.036722638,0.012005731,0.07372392,-0.010842309,0.012550904,-0.017175304,-0.0067744465,-0.0038838626,-0.053911418,0.08102858,-0.06457765,0.054012854,0.017025804,-0.021439843,-0.03358884,-0.04738347]	3	\N	2026-01-31 22:45:47.308023+00	2026-02-01 13:12:43.981951+00
be97ce08-4a76-4a7f-a6e6-c93f2ad753eb	6eda01a1-1970-4562-b4cf-996ce9e22ff4	If $y = \\sin^{-1}\\left(\\frac{\\sqrt{1 + x} + \\sqrt{1 - x}}{2}\\right)$, then show that $\\frac{dy}{dx} = \\frac{-1}{2\\sqrt{1 - x^2}}$	[]	SA	f	https://iljpsrbycqfunmpimjaa.supabase.co/storage/v1/object/public/question-images/6eda01a1-1970-4562-b4cf-996ce9e22ff4/1770025270607.png	Mathematics	Continuity and Differentiability	["Derivative of inverse trigonometric functions"]	hard	5	To find dy/dx, we use the chain rule and the derivative of the inverse sine function. The key steps involve correctly calculating du/dx and simplifying 1 - u^2 to apply the formula for the derivative of the inverse sine function.	[0.053554878,-0.050526973,-0.03453541,-0.023766106,0.018745627,0.011491072,-0.017941723,0.03826482,0.020205481,-0.028394647,-0.020408481,0.035886217,0.07011646,-0.050251,0.089313656,0.010451621,0.042738248,0.030728078,-0.08727165,0.06667156,0.024397228,0.018041836,0.011221615,0.014050139,0.0065391404,-0.01961445,-0.020330887,-0.026779348,-0.034613017,0.0039350404,0.034972593,0.010849888,-0.018561745,-0.0070218886,-0.0052619586,0.045347072,-0.019901773,0.03354314,0.010996223,2.2581708e-05,-0.044430356,-0.055858072,-0.018868212,0.022199456,-0.014520475,0.004546012,-0.04044614,0.036242332,-0.0159577,0.03262411,0.010918327,-0.037563194,-0.0069706864,0.0027384877,-0.0059922794,-0.012115126,-0.03697307,-0.02238313,0.03937888,-0.018625174,-0.048035957,-0.031265933,-0.051297188,-0.0809592,-0.007213628,-0.0124309,-0.02585733,-0.0035169872,0.0077574793,0.055020943,0.0210971,0.021762287,1.3835534e-05,0.051949427,0.057853322,-0.022708226,0.005925476,-0.034420244,-0.011291942,0.003355027,0.017025193,0.06111828,0.06666808,-0.010983352,-0.030101191,0.04009962,-0.03297843,-0.051784135,-0.03166332,-0.07493227,0.045094028,0.018501041,0.022017632,-0.031966336,0.083843194,0.0019948075,-0.025521714,-0.11086845,0.037467495,0.017279815,-0.008996845,0.041032173,0.03190906,0.015368694,0.004162879,-0.004469422,-0.015863677,-0.02341607,-0.028794695,0.061528314,-0.011060949,0.005756672,0.03189648,-0.06782226,-0.02858216,-0.008626038,0.0032499256,0.016855493,-0.0063392944,0.031225722,0.027785007,-0.015187469,0.0036164653,0.043634318,0.026483038,-0.0076867044,0.024447326,-0.03405642,-0.06434363,0.048655216,0.055009652,-0.0050962376,-0.009423452,0.004761557,0.0663016,-0.046138424,-0.0035838669,0.045412093,-0.00079960446,0.0036358137,-0.010111939,-0.046403624,-0.07273896,-0.05295896,0.008593022,-0.047144353,0.01127299,0.004101968,-0.029407727,-0.053734485,-0.020267371,-0.026958074,0.059407126,0.037730027,0.017338183,0.015103762,0.0660019,0.015991425,0.018246906,-0.008152463,-0.01997894,-0.049223356,0.037515994,-0.02617479,-0.03257921,-0.034432035,0.009494814,-0.0074406653,-0.01883584,0.008668333,-0.045354262,-0.04296951,-0.04170825,0.025568243,-0.037004292,-0.015755197,0.06495657,0.009804297,-0.024717968,-0.06565644,0.014571681,-0.03517774,0.008194074,-0.009777064,0.10018665,-0.04024123,-0.020207992,-0.003335586,0.030984685,0.028211374,-0.04503499,0.055803135,0.039665665,-0.0061576404,-0.005000544,0.05111908,-0.003540761,0.0016817778,0.002583437,-0.030455653,-0.020217817,-0.012814924,-0.019942984,-0.06615103,-0.05412925,-0.024461439,-0.02862455,-0.048205383,-0.0072347918,0.019112805,0.007893367,0.030862918,0.027798168,-0.039072342,0.026823813,0.023997907,0.028386056,0.06500734,0.02817566,0.061316352,0.0045336313,0.012275024,-0.017722346,0.057474077,-0.01774705,-0.06344835,0.012107247,0.039929975,-0.0041975556,-0.06067324,0.016981585,0.023101475,0.0061874413,0.07520595,-0.0308784,0.033510063,0.04580869,-0.042544026,-0.025967129,-0.015486754,-0.03748672,0.06240232,0.021839242,-0.007671048,0.05187587,-0.02646057,-0.047578137,0.015211811,-0.023490643,-0.020295879,-0.051836405,0.014582823,0.0033189226,0.021849269,-0.082689986,0.0039815945,0.02381826,0.032290068,0.0067341393,-0.060723137,0.058528814,0.012557725,0.019760303,0.019084807,-0.006566396,-0.07824737,-0.006204387,-0.008834979,-0.02877974,0.0178846,0.012180532,-0.010975606,-0.040300436,-0.0036699162,-0.025620103,0.028283613,-0.025995914,-0.006649617,-0.0013503863,-0.027758528,0.041478235,-0.035331827,-0.004906502,0.0096976245,0.014561705,-0.07230497,0.037380107,-0.027722878,0.024527848,-0.05570024,0.03150676,0.03873795,0.014626627,-0.056045547,0.01930709,0.024812713,0.03915728,-0.011806734,-0.021992229,0.024602294,0.015820267,0.015573829,0.03298554,0.09164108,-0.042245615,0.014914114,-0.04813421,-0.049571343,0.0030011768,-0.015073441,0.05311713,-0.011998785,-0.039139107,0.042313557,-0.0056912717,-0.06424478,-0.047159184,-0.041374817,-0.030873276,0.05455656,0.034135625,0.018476233,-0.013327716,0.059570327,-0.011659282,-0.011425005,-0.040796805,-0.004764739,-0.034925662,0.009739776,0.056760542,-0.039239164,-0.026406111,0.023994917,-0.02496955,-0.005587947,-0.054507233,0.008635509,0.038518798,-0.0043201284,-0.022032274,-0.013458972,0.051727187,0.04506709,0.026826056,-0.06215476,-0.051754214,-0.031764023,0.005611322,0.0035671017,-0.04123518,0.030445125,-0.025004344,-0.05373091,-0.06334493,0.017767407,0.03948531,0.031961944,0.04928219,-0.020648286,-0.020585172,-0.005681987,-0.01769232,0.03706113,0.011660342,-0.019457094,-0.016269004,0.053730253,0.03950021,0.0010005939,-0.016661003,-0.033284444,-0.037661165,0.003959511,0.019086385,-0.042053327,0.009188636,-0.0021593904,-0.0035828748,-0.06216028,-0.05158646,-0.027276035,-0.022319304,-0.020390514,-0.069750614,0.046623714,-0.029826967,-0.002800357,-0.03275794,-0.057989772,-0.023514735,0.031423297,-0.0021560423,-0.049286064,-0.026882801,0.02027546,0.020769812,0.066489235,-0.028005762,-0.0053852755,-0.019796727,-0.0057771425,0.053327996,-0.017405465,-0.012384989,-0.040980946,0.0349813,0.0034606326,0.04212327,-0.0036009613,-0.015072626,0.027226644,0.0005857529,0.04549367,-0.04606821,-0.063480824,-0.045202192,-0.011498558,0.001222982,0.019887501,-0.057950664,-0.01958515,-0.046787985,-0.024521813,0.008788419,-0.04738323,-0.011089879,-0.0014305512,0.008347066,-0.023479607,0.014546693,0.003746809,0.03739203,0.027708806,0.042144407,0.041968636,0.0055951006,-0.013425362,0.0060828,0.01982638,8.4380044e-05,0.0255477,-0.020435756,0.028810533,-0.042147286,0.1035578,0.014399649,-0.00680315,0.01145978,-0.037191134,0.024235442,-0.072572336,0.03661114,-0.0007549487,-0.09304561,0.030338418,-0.021364518,0.0012874852,-0.01219954,0.016475335,-0.013231996,0.021746494,0.05481273,0.01148093,0.09507388,-0.059458673,-0.0029594763,0.03785296,-0.01818322,0.076817684,0.023358118,-0.0353736,-0.008270877,0.016188815,0.01726907,5.7695684e-06,0.0030131855,-0.04263993,-0.01152607,-0.022008006,0.036161102,0.0154596,-0.013972296,0.03752383,0.00484353,-0.029854663,-0.018029952,0.058801185,-0.01670478,-0.043608453,0.023886798,-0.0477708,-0.033830047,-0.06324817,0.017320793,-0.06446744,-0.010366784,-0.012179422,-0.026246682,0.02450153,0.043834656,0.06025432,0.01719709,-0.03450848,-0.013755013,-0.03229683,-0.050318506,-0.044972226,0.03652783,0.043334402,0.01491711,-0.0070923925,0.03256972,-0.039322406,0.0028146962,0.028975181,-0.0010580039,0.03042297,-0.026060868,0.07373773,-0.049851406,-0.008742203,0.011160679,-0.032005623,0.033883598,0.03909174,-0.06205286,-0.015820116,0.027931012,-0.015947348,-0.021969564,-0.0072490727,0.027690697,0.041315924,-0.053515237,0.054131076,0.0072151795,-0.020312222,0.018930273,0.026312053,0.01278264,-0.045936875,-0.081364244,0.031876326,0.04426077,-0.012541538,-0.021989776,0.052936368,-0.044016194,0.05143222,0.011417208,-0.033123966,-0.048900124,-0.0066513903,-0.0041226395,-0.021405924,-0.0028269805,-0.0038004597,0.030905982,-0.088468954,0.09877642,0.02606575,-0.0125459125,0.0016345673,-0.01573352,-0.09906864,0.003751256,0.03246704,-0.018000776,0.017851518,-0.028109537,-0.017646769,-0.026488293,0.0032355108,0.07102339,-0.0070038503,-0.0061536045,-0.015416741,0.022372851,0.014924636,0.020364625,0.0012729198,0.007846575,0.02147167,-0.012774062,-0.08090224,0.050235312,0.00221007,-0.018880062,-0.028220057,-0.035154678,0.012661581,-0.036045104,-0.016559081,0.052294258,-0.017311795,-0.067080714,0.024786528,-0.0059219236,-0.025907563,-0.026889013,-0.00081720337,0.024549287,-0.028251618,-0.03177677,-0.042991024,-0.05726911,0.02508465,-0.03521775,-0.034470245,-0.00781229,0.06925923,-0.04219851,0.06338108,-0.07127457,0.014234049,-0.026013257,0.0012550494,-0.0023824456,-0.05520638,-0.026556026,-0.032041945,0.046247877,-0.05389851,-0.042076077,-0.01958216,-0.034871466,0.020681977,0.08416205,0.02355481,-0.055388767,-0.015974863,0.039730716,-0.0026250076,0.026605574,-0.04873253,-0.031339332,0.04914811,-0.020290583,-0.0077078743,0.022423629,0.027377207,0.036866326,-0.03853397,-0.0042571826,-0.013754552,0.00348679,0.05442023,0.0287397,-0.015440417,0.031013554,-0.01026798,0.0053348225,0.0361856,-0.009490867,-0.0073427265,-0.04979509,0.023271669,0.032614883,0.012178066,-0.006444179,-0.0072495905,-0.053936407,-0.026912402,-0.025038967,0.018779041,-0.019115545,-0.00060170714,0.009935925,0.038738318,0.0038994087,0.007846245,0.0036087793,0.07776012,0.044493757,-0.020898398,0.04102453,0.023003308,-0.018068235,0.032712843,0.048165146,-0.03379319,0.011179392,-0.03667855,-0.00055246847,0.07705437,0.0591038,0.025622398,-0.012625393,0.0041133664,0.03950403,-0.01421856,-0.09676993,0.043276742,-0.017473362,0.05254347,-0.059552,0.018918503,0.07706926,0.025833447,-0.011077279,-0.038237732,0.03364631,-0.006523616,0.046476297,-0.0013682862,0.07915572,0.058087036,-0.001945621,0.04044199,0.0129179405,-0.0056755813,0.11715059,-0.063025735,0.04784244,0.007844677,-0.008488017,0.013799615,-0.025515234,0.0051130676,-0.012281549,-0.018325603,0.046300825,0.039492894,0.031224739,0.022849342,0.0056485655,-0.03183463,-0.041439153,0.0053953296,0.03709578,0.0033195047,-0.046059277,-0.012563017,-0.03165075,-0.009464459,-0.022596713,-0.009925231,-0.0018247006,-0.052399773,0.024921501,-0.026809143,-0.081679024,-0.09375998,0.0093597565,-0.026591126,-0.001084261,-0.0021320179,-0.007174891,-0.0012886894,-0.01928693,-0.008157471,0.022954533,0.05087983,0.050349742,-0.022100355,-0.018723082,0.003329545,-0.006500127,-0.0171072,0.006356549,0.053303618,0.0012141041,0.05886032,-0.06620047,0.003754756,0.051277433,-0.049543485]	2	\N	2026-02-02 09:43:12.809663+00	2026-02-02 09:43:13.936367+00
\.


--
-- Data for Name: revise_later; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.revise_later (id, user_id, question_id, added_at) FROM stdin;
\.


--
-- Data for Name: solution_likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.solution_likes (id, user_id, solution_id, created_at) FROM stdin;
5f32eb6d-1c12-4760-8027-bd7f8a60727a	f3f4fc66-4e15-451a-9eec-ace39efd5804	c12fafcd-29a3-40ce-b4ee-fb32581ecd43	2026-01-31 16:32:30.66698+00
\.


--
-- Data for Name: solutions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.solutions (id, question_id, contributor_id, solution_text, numerical_answer, approach_description, correct_option, avg_solve_time, likes, is_ai_best, created_at, updated_at) FROM stdin;
c12fafcd-29a3-40ce-b4ee-fb32581ecd43	d67c4208-4acd-482d-af2d-5e760de3b700	6eda01a1-1970-4562-b4cf-996ce9e22ff4	\n**Step 1: Analyze the given differential equation**\nWe are given the differential equation:\n$$\ne^y \\left(\\frac{dy}{dx} - 1\\right) = e^x\n$$\n\n\n\n**Step 2: Rearrange the equation**\nRearranging the terms to isolate the derivative:\n$$\n\\frac{dy}{dx} - 1 = \\frac{e^x}{e^y}\n$$\n$$\n\\frac{dy}{dx} = \\frac{e^x}{e^y} + 1\n$$\n\n\n\n**Step 3: Simplify the equation further**\nUsing the properties of exponents to simplify the right side:\n$$\n\\frac{dy}{dx} = e^{x-y} + 1\n$$\n\n\n\n**Step 4: Solve the differential equation**\nThis is a first-order linear differential equation. However, noticing the form of the equation suggests trying a separation of variables or recognizing a pattern that fits a known solution form. Let's rearrange it to see if we can separate variables or apply a suitable method:\n$$\n\\frac{dy}{dx} = e^{x-y} + 1\n$$\nLet's try to attempt a solution by inspection or using an integrating factor, considering the structure of the equation doesn't immediately lend itself to simple separation of variables due to the presence of both $x$ and $y$ in the exponent.\n\n\n\n\n**Step 5: Solve by recognizing the equation form**\nRecognizing that the equation might be solved by considering the relationship between $x$ and $y$ directly through the exponential terms, let's attempt a solution of the form that directly relates $e^y$ and $e^x$:\nConsider the original equation:\n$$\ne^y \\left(\\frac{dy}{dx} - 1\\right) = e^x\n$$\nThis equation can be manipulated into a form that suggests a direct relationship between $x$, $y$, and constants, by considering the integration of both sides or finding a suitable substitution that simplifies the equation.\n\n\n\n\n**Step 6: Directly solve or match given options**\nConsidering the original equation and the options provided, let's examine if any of the options directly satisfy the equation or provide a clue to the solution. Given the nature of the differential equation and the options, let's analyze each option to see if it aligns with the solution to the differential equation:\n- Option 0: $e^y \\cdot x = x + c$\n- Option 1: $e^{(x-y)} = x + c$\n- Option 2: $e^{(y-x)} = x + c$\nLet's differentiate each option with respect to $x$ and see which one aligns with the original differential equation.\n\n\n\n\n**Step 7: Differentiate the options**\nDifferentiating Option 1 with respect to $x$:\n$$\ne^{(x-y)} = x + c\n$$\n$$\n\\frac{d}{dx}(e^{(x-y)}) = \\frac{d}{dx}(x + c)\n$$\n$$\ne^{(x-y)}\\cdot \\frac{d}{dx}(x-y) = 1\n$$\n$$\ne^{(x-y)}\\cdot (1 - \\frac{dy}{dx}) = 1\n$$\nThis can be rearranged to:\n$$\ne^{(x-y)} - e^{(x-y)}\\cdot \\frac{dy}{dx} = 1\n$$\n$$\ne^{(x-y)}\\cdot \\frac{dy}{dx} - e^{(x-y)} = -1\n$$\n$$\ne^y \\cdot (\\frac{dy}{dx} - 1) = -e^x\n$$\nThis doesn't match our original equation. Let's correct the approach by directly evaluating the suitability of each option against the differential equation.\n\n\n\n\n**Step 8: Evaluate Option 2**\nConsidering Option 2:\n$$\ne^{(y-x)} = x + c\n$$\nDifferentiating both sides with respect to $x$:\n$$\n\\frac{d}{dx}(e^{(y-x)}) = \\frac{d}{dx}(x + c)\n$$\n$$\ne^{(y-x)}\\cdot \\frac{d}{dx}(y-x) = 1\n$$\n$$\ne^{(y-x)}\\cdot (\\frac{dy}{dx} - 1) = 1\n$$\nMultiplying both sides by $e^x$ to match the original equation's form:\n$$\ne^x \\cdot e^{(y-x)}\\cdot (\\frac{dy}{dx} - 1) = e^x\n$$\n$$\ne^y \\cdot (\\frac{dy}{dx} - 1) = e^x\n$$\nThis matches the original differential equation, indicating that Option 2 is indeed the correct form of the solution.\n\n	\N	\N	2	300	1	t	2026-01-31 11:52:15.370975+00	2026-01-31 16:32:30.66698+00
c2d3a87b-66d0-48bf-b2dc-26eea822e017	a2562c0a-5fa1-4ee6-87c0-7404135a1d1c	6eda01a1-1970-4562-b4cf-996ce9e22ff4	\n**Step 1: Define the problem and identify key elements**\nWe are given a game where A and B throw a die alternately until one of them gets a '6' and wins the game. A starts the game first.\n\n\n\nThe probability of getting a '6' on a single throw is $\\frac{1}{6}$, and the probability of not getting a '6' is $\\frac{5}{6}$.\n\n\n\n**Step 2: Calculate the probability of A winning on the first throw**\nA can win on the first throw with a probability of:\n$$\nP(A\\_win\\_first) = \\frac{1}{6}\n$$\n\n\n\n**Step 3: Calculate the probability of A winning on subsequent throws**\nFor A to win on the second throw, both A and B must not get a '6' on their first throws, and then A gets a '6' on the second throw. The probability of this sequence is:\n$$\nP(A\\_win\\_second) = \\left(\\frac{5}{6}\\right) \\times \\left(\\frac{5}{6}\\right) \\times \\frac{1}{6}\n$$\n\n\n\nThis pattern continues for A winning on the third throw, fourth throw, and so on.\n\n\n\n**Step 4: Sum the infinite series for A's probability of winning**\nThe total probability of A winning is the sum of the probabilities of A winning on the first throw, second throw, third throw, and so on. This forms an infinite geometric series:\n$$\nP(A\\_win) = \\frac{1}{6} + \\left(\\frac{5}{6}\\right)^2 \\times \\frac{1}{6} + \\left(\\frac{5}{6}\\right)^4 \\times \\frac{1}{6} + \\cdots\n$$\n$$\n= \\frac{\\frac{1}{6}}{1 - \\left(\\frac{5}{6}\\right)^2}\n$$\n\n\n\n**Step 5: Calculate the probability of B winning**\nSince the game is symmetric, and B starts after A, the probability of B winning can be derived similarly, but considering B's first chance to throw is after A's first throw. Thus, the probability that B wins is:\n$$\nP(B\\_win) = \\left(\\frac{5}{6}\\right) \\times \\frac{1}{6} + \\left(\\frac{5}{6}\\right)^3 \\times \\frac{1}{6} + \\cdots\n$$\n$$\n= \\frac{\\frac{5}{6} \\times \\frac{1}{6}}{1 - \\left(\\frac{5}{6}\\right)^2}\n$$\n\n\n\n**Step 6: Simplify the expressions for A and B's probabilities of winning**\nLet's simplify $P(A\\_win)$:\n$$\nP(A\\_win) = \\frac{\\frac{1}{6}}{1 - \\left(\\frac{5}{6}\\right)^2} = \\frac{\\frac{1}{6}}{1 - \\frac{25}{36}} = \\frac{\\frac{1}{6}}{\\frac{11}{36}} = \\frac{1}{6} \\times \\frac{36}{11} = \\frac{6}{11}\n$$\n\n\n\nAnd for $P(B\\_win)$:\n$$\nP(B\\_win) = \\frac{\\frac{5}{6} \\times \\frac{1}{6}}{1 - \\left(\\frac{5}{6}\\right)^2} = \\frac{\\frac{5}{36}}{\\frac{11}{36}} = \\frac{5}{36} \\times \\frac{36}{11} = \\frac{5}{11}\n$$\n\n\n\n**Step 7: Conclusion**\nThe probabilities of A and B winning are $\\frac{6}{11}$ and $\\frac{5}{11}$, respectively.	A: \\frac{6}{11}, B: \\frac{5}{11}	Infinite geometric series to calculate probabilities of winning	\N	300	0	t	2026-01-31 22:36:53.797595+00	2026-01-31 22:36:53.691+00
4dfdec6e-18ba-4cc4-98d0-99716ddacf79	b9727bd5-aff8-499d-86a4-dd2c6a6fea9d	6eda01a1-1970-4562-b4cf-996ce9e22ff4	\n**Step 1: Define the total number of cards and the number of queens and kings**\nThere are 52 cards in total, with 4 queens and 4 kings, each of two different colors (red and black).\n\n\n$$\n\\text{Total cards} = 52\n$$\n$$\n\\text{Queens} = 4\n$$\n$$\n\\text{Kings} = 4\n$$\n\n**Step 2: Calculate the probability of drawing a queen first and then a king of opposite color**\nThe probability of drawing a queen first is $\\frac{4}{52}$, and then the probability of drawing a king of opposite color is $\\frac{2}{51}$ because there are 2 kings of the opposite color left out of 51 cards.\n\n\n$$\nP(\\text{queen then king of opposite color}) = \\frac{4}{52} \\times \\frac{2}{51}\n$$\n\n**Step 3: Calculate the probability of drawing a king first and then a queen of opposite color**\nSimilarly, the probability of drawing a king first is $\\frac{4}{52}$, and then the probability of drawing a queen of opposite color is $\\frac{2}{51}$.\n\n\n$$\nP(\\text{king then queen of opposite color}) = \\frac{4}{52} \\times \\frac{2}{51}\n$$\n\n**Step 4: Calculate the total probability of one card being a queen and the other a king of opposite color**\nThe total probability is the sum of the probabilities from step 2 and step 3.\n\n\n$$\nP(\\text{total}) = P(\\text{queen then king of opposite color}) + P(\\text{king then queen of opposite color})\n$$\n$$\n= \\frac{4}{52} \\times \\frac{2}{51} + \\frac{4}{52} \\times \\frac{2}{51}\n$$\n$$\n= 2 \\times \\frac{4}{52} \\times \\frac{2}{51}\n$$\n$$\n= \\frac{16}{2652}\n$$\n$$\n= \\frac{4}{663}\n$$\n\n	\\frac{4}{663}	Calculate the probability of drawing a queen and then a king of opposite color, and the probability of drawing a king and then a queen of opposite color, then sum these probabilities.	\N	120	0	t	2026-01-31 22:39:27.798701+00	2026-01-31 22:39:27.745+00
cc03051c-0428-45a8-96ec-b896a83cd2e1	1954e9c7-4c54-46ce-b507-1a5947e0bfab	6eda01a1-1970-4562-b4cf-996ce9e22ff4	\n**Step 1: Define the probabilities of A and B coming to school in time**\nThe probability of student A coming to school in time is $\\frac{3}{7}$, and the probability of student B coming to school in time is $\\frac{5}{7}$.\n\n\n\n\n**Step 2: Calculate the probability of A coming in time and B not coming in time**\nThe probability of A coming in time and B not coming in time is given by:\n$$\nP(A \\cap \\bar{B}) = P(A) \\cdot P(\\bar{B})\n$$\n$$\n= \\frac{3}{7} \\cdot \\left(1 - \\frac{5}{7}\\right)\n$$\n$$\n= \\frac{3}{7} \\cdot \\frac{2}{7}\n$$\n$$\n= \\frac{6}{49}\n$$\n\n\n\n\n**Step 3: Calculate the probability of B coming in time and A not coming in time**\nThe probability of B coming in time and A not coming in time is given by:\n$$\nP(\\bar{A} \\cap B) = P(\\bar{A}) \\cdot P(B)\n$$\n$$\n= \\left(1 - \\frac{3}{7}\\right) \\cdot \\frac{5}{7}\n$$\n$$\n= \\frac{4}{7} \\cdot \\frac{5}{7}\n$$\n$$\n= \\frac{20}{49}\n$$\n\n\n\n\n**Step 4: Calculate the total probability of only one of them coming in time**\nThe total probability of only one of them coming in time is the sum of the probabilities calculated in steps 2 and 3:\n$$\nP(\\text{only one coming in time}) = P(A \\cap \\bar{B}) + P(\\bar{A} \\cap B)\n$$\n$$\n= \\frac{6}{49} + \\frac{20}{49}\n$$\n$$\n= \\frac{26}{49}\n$$\n\n	$\\frac{26}{49}$	Used the concept of independent events and calculated the probabilities of the required scenarios.	\N	120	0	t	2026-01-31 22:45:47.599269+00	2026-01-31 22:45:47.493+00
deb62af3-4b1d-4094-89f2-50f07726a965	1954e9c7-4c54-46ce-b507-1a5947e0bfab	6b787def-4b61-42ff-814b-ebb92a3036d1	\n**Step 1: Define the probabilities of A and B coming to school in time**\nThe probability of A coming to school in time is $\\frac{3}{7}$, and the probability of B coming to school in time is $\\frac{5}{7}$.\n\n\n\n\n**Step 2: Calculate the probability of A coming to school in time and B not coming to school in time**\nThe probability of A coming to school in time and B not coming to school in time is:\n$$\n\\frac{3}{7} \\times \\left(1 - \\frac{5}{7}\\right)\n$$\n$$\n= \\frac{3}{7} \\times \\frac{2}{7}\n$$\n$$\n= \\frac{6}{49}\n$$\n\n\n\n\n**Step 3: Calculate the probability of B coming to school in time and A not coming to school in time**\nThe probability of B coming to school in time and A not coming to school in time is:\n$$\n\\frac{5}{7} \\times \\left(1 - \\frac{3}{7}\\right)\n$$\n$$\n= \\frac{5}{7} \\times \\frac{4}{7}\n$$\n$$\n= \\frac{20}{49}\n$$\n\n\n\n\n**Step 4: Calculate the total probability of only one of them coming to school in time**\nThe total probability of only one of them coming to school in time is the sum of the probabilities calculated in steps 2 and 3:\n$$\n\\frac{6}{49} + \\frac{20}{49}\n$$\n$$\n= \\frac{26}{49}\n$$\n\n	$\\frac{26}{49}$	Calculate the probabilities of each scenario and sum them to find the total probability of only one student coming to school in time.	\N	120	0	f	2026-02-01 13:12:44.191012+00	2026-02-01 13:12:44.125+00
d615df15-4d40-4b6b-ba86-40ad3000e591	be97ce08-4a76-4a7f-a6e6-c93f2ad753eb	6eda01a1-1970-4562-b4cf-996ce9e22ff4	\n**Step 1: Differentiate y with respect to x**\nWe start with the given equation:\n$$\ny = \\sin^{-1}\\left(\\frac{\\sqrt{1 + x} + \\sqrt{1 - x}}{2}\\right)\n$$\nTo find $\\frac{dy}{dx}$, we'll use the chain rule and the fact that $\\frac{d}{dx}\\sin^{-1}(u) = \\frac{1}{\\sqrt{1-u^2}}\\frac{du}{dx}$.\n\n**Step 2: Apply the chain rule**\nLet $u = \\frac{\\sqrt{1 + x} + \\sqrt{1 - x}}{2}$.\nThen:\n$$\n\\frac{du}{dx} = \\frac{1}{2}\\left(\\frac{1}{2\\sqrt{1+x}} - \\frac{1}{2\\sqrt{1-x}}\\right)\n$$\n\n**Step 3: Substitute u and du/dx into the chain rule formula**\n$$\n\\frac{dy}{dx} = \\frac{1}{\\sqrt{1-u^2}}\\frac{du}{dx}\n$$\nSubstitute $u$ and $\\frac{du}{dx}$:\n$$\n= \\frac{1}{\\sqrt{1-\\left(\\frac{\\sqrt{1 + x} + \\sqrt{1 - x}}{2}\\right)^2}} \\cdot \\frac{1}{2}\\left(\\frac{1}{2\\sqrt{1+x}} - \\frac{1}{2\\sqrt{1-x}}\\right)\n$$\n\n**Step 4: Simplify the expression for dy/dx**\nFirst, simplify the denominator of the first term:\n$$\n1 - \\left(\\frac{\\sqrt{1 + x} + \\sqrt{1 - x}}{2}\\right)^2 = 1 - \\frac{(\\sqrt{1+x} + \\sqrt{1-x})^2}{4}\n$$\n$$\n= 1 - \\frac{1+x + 2\\sqrt{(1+x)(1-x)} + 1 - x}{4}\n$$\n$$\n= 1 - \\frac{2 + 2\\sqrt{1-x^2}}{4}\n$$\n$$\n= \\frac{4 - 2 - 2\\sqrt{1-x^2}}{4}\n$$\n$$\n= \\frac{2 - 2\\sqrt{1-x^2}}{4}\n$$\n$$\n= \\frac{1 - \\sqrt{1-x^2}}{2}\n$$\nThus:\n$$\n\\frac{1}{\\sqrt{1-u^2}} = \\frac{1}{\\sqrt{\\frac{1 - \\sqrt{1-x^2}}{2}}}\n$$\n$$\n= \\frac{\\sqrt{2}}{\\sqrt{1 - \\sqrt{1-x^2}}}\n$$\n$$\n= \\frac{\\sqrt{2}}{\\sqrt{1 - (1 - \\sqrt{1-x^2})}}\n$$\n$$\n= \\frac{\\sqrt{2}}{\\sqrt{\\sqrt{1-x^2}}}\n$$\n$$\n= \\frac{\\sqrt{2}}{(1-x^2)^{\\frac{1}{4}}}\n$$\n\n**Step 5: Further simplification and calculation of du/dx**\nHowever, simplification in Step 4 was incorrect; let's correctly simplify $1 - u^2$ and calculate $\\frac{du}{dx}$:\n$$\n1 - u^2 = 1 - \\left(\\frac{\\sqrt{1 + x} + \\sqrt{1 - x}}{2}\\right)^2\n$$\n$$\n= 1 - \\frac{1+x+2\\sqrt{1-x^2}+1-x}{4}\n$$\n$$\n= 1 - \\frac{2 + 2\\sqrt{1-x^2}}{4}\n$$\n$$\n= 1 - \\frac{1 + \\sqrt{1-x^2}}{2}\n$$\n$$\n= \\frac{2 - 1 - \\sqrt{1-x^2}}{2}\n$$\n$$\n= \\frac{1 - \\sqrt{1-x^2}}{2}\n$$\nSo:\n$$\n\\frac{1}{\\sqrt{1-u^2}} = \\frac{1}{\\sqrt{\\frac{1 - \\sqrt{1-x^2}}{2}}}\n$$\n$$\n= \\sqrt{\\frac{2}{1 - \\sqrt{1-x^2}}}\n$$\nAnd $\\frac{du}{dx}$ simplifies to:\n$$\n\\frac{du}{dx} = \\frac{1}{2}\\left(\\frac{1}{2\\sqrt{1+x}} - \\frac{1}{2\\sqrt{1-x}}\\right)\n$$\n$$\n= \\frac{1}{4}\\left(\\frac{\\sqrt{1-x} - \\sqrt{1+x}}{(1+x)(1-x)}\\right)\n$$\n$$\n= \\frac{1}{4}\\left(\\frac{\\sqrt{1-x} - \\sqrt{1+x}}{1-x^2}\\right)\n$$\n$$\n= \\frac{\\sqrt{1-x} - \\sqrt{1+x}}{4(1-x^2)}\n$$\n\n**Step 6: Combine the results**\nSubstitute back into the formula for $\\frac{dy}{dx}$:\n$$\n\\frac{dy}{dx} = \\sqrt{\\frac{2}{1 - \\sqrt{1-x^2}}} \\cdot \\frac{\\sqrt{1-x} - \\sqrt{1+x}}{4(1-x^2)}\n$$\nHowever, the correct path to simplify $\\frac{dy}{dx}$ should directly utilize the properties of inverse functions and the chain rule without incorrect expansions.\n\n**Step 7: Correct approach to find dy/dx**\nGiven $y = \\sin^{-1}\\left(\\frac{\\sqrt{1 + x} + \\sqrt{1 - x}}{2}\\right)$, let's find $\\frac{dy}{dx}$ using the correct formula for the derivative of $\\sin^{-1}(u)$:\n$$\n\\frac{d}{dx}\\sin^{-1}(u) = \\frac{1}{\\sqrt{1-u^2}}\\frac{du}{dx}\n$$\nHere, $u = \\frac{\\sqrt{1 + x} + \\sqrt{1 - x}}{2}$, so we first need to correctly find $\\frac{du}{dx}$ and then apply it.\n\n**Step 8: Correct calculation of du/dx**\n$$\n\\frac{du}{dx} = \\frac{1}{2}\\left(\\frac{1}{2\\sqrt{1+x}} - \\frac{1}{2\\sqrt{1-x}}\\right)\n$$\n$$\n= \\frac{1}{4}\\left(\\frac{1}{\\sqrt{1+x}} - \\frac{1}{\\sqrt{1-x}}\\right)\n$$\n$$\n= \\frac{1}{4}\\left(\\frac{\\sqrt{1-x} - \\sqrt{1+x}}{(1+x)(1-x)}\\right)\n$$\n$$\n= \\frac{\\sqrt{1-x} - \\sqrt{1+x}}{4(1-x^2)}\n$$\n\n**Step 9: Correct calculation of dy/dx using the chain rule**\nTo find $\\frac{dy}{dx}$, we apply the chain rule with the correct $u$ and $\\frac{du}{dx}$:\n$$\n\\frac{dy}{dx} = \\frac{1}{\\sqrt{1-u^2}}\\frac{du}{dx}\n$$\nGiven $u = \\frac{\\sqrt{1 + x} + \\sqrt{1 - x}}{2}$, let's correctly calculate $1 - u^2$:\n$$\n1 - u^2 = 1 - \\left(\\frac{\\sqrt{1 + x} + \\sqrt{1 - x}}{2}\\right)^2\n$$\n$$\n= 1 - \\frac{1+x+2\\sqrt{1-x^2}+1-x}{4}\n$$\n$$\n= 1 - \\frac{2 + 2\\sqrt{1-x^2}}{4}\n$$\n$$\n= 1 - \\frac{1 + \\sqrt{1-x^2}}{2}\n$$\n$$\n= \\frac{2 - 1 - \\sqrt{1-x^2}}{2}\n$$\n$$\n= \\frac{1 - \\sqrt{1-x^2}}{2}\n$$\nSo, $\\frac{1}{\\sqrt{1-u^2}} = \\frac{1}{\\sqrt{\\frac{1 - \\sqrt{1-x^2}}{2}}}$.\n\n**Step 10: Final simplification of dy/dx**\nSubstituting $\\frac{du}{dx}$ and $\\frac{1}{\\sqrt{1-u^2}}$ into $\\frac{dy}{dx}$:\n$$\n\\frac{dy}{dx} = \\frac{1}{\\sqrt{\\frac{1 - \\sqrt{1-x^2}}{2}}} \\cdot \\frac{\\sqrt{1-x} - \\sqrt{1+x}}{4(1-x^2)}\n$$\nHowever, the error in simplification misdirects the calculation. The correct approach should directly apply the derivative of $\\sin^{-1}(u)$ and correctly calculate $\\frac{du}{dx}$ without the incorrect simplifications.\n\n**Step 11: Correct Final Calculation**\nThe mistake in the previous steps was in the simplification and calculation process. To correctly find $\\frac{dy}{dx}$, we should directly apply the formula:\n$$\n\\frac{dy}{dx} = \\frac{1}{\\sqrt{1-u^2}} \\cdot \\frac{du}{dx}\n$$\nWhere $u = \\frac{\\sqrt{1 + x} + \\sqrt{1 - x}}{2}$, and correctly calculate $\\frac{du}{dx}$ and $1 - u^2$ without the incorrect expansions.\n\n**Step 12: Simplify 1 - u^2 correctly**\n$$\n1 - u^2 = 1 - \\left(\\frac{\\sqrt{1+x}+\\sqrt{1-x}}{2}\\right)^2\n$$\n$$\n= 1 - \\frac{1+x+2\\sqrt{1-x^2}+1-x}{4}\n$$\n$$\n= 1 - \\frac{2+2\\sqrt{1-x^2}}{4}\n$$\n$$\n= \\frac{4 - 2 - 2\\sqrt{1-x^2}}{4}\n$$\n$$\n= \\frac{2 - 2\\sqrt{1-x^2}}{4}\n$$\n$$\n= \\frac{1 - \\sqrt{1-x^2}}{2}\n$$\nThus, $\\frac{1}{\\sqrt{1-u^2}} = \\frac{1}{\\sqrt{\\frac{1-\\sqrt{1-x^2}}{2}}}$.\n\n**Step 13: Correct Calculation of du/dx and Final dy/dx**\nGiven $u = \\frac{\\sqrt{1+x} + \\sqrt{1-x}}{2}$,\n$$\n\\frac{du}{dx} = \\frac{1}{2}\\left(\\frac{1}{2\\sqrt{1+x}} - \\frac{1}{2\\sqrt{1-x}}\\right)\n$$\n$$\n= \\frac{1}{4}\\left(\\frac{1}{\\sqrt{1+x}} - \\frac{1}{\\sqrt{1-x}}\\right)\n$$\n$$\n= \\frac{\\sqrt{1-x} - \\sqrt{1+x}}{4(1-x^2)}\n$$\nThen, $\\frac{dy}{dx}$ is:\n$$\n\\frac{dy}{dx} = \\frac{1}{\\sqrt{1-u^2}}\\frac{du}{dx}\n$$\nSubstitute $\\frac{1}{\\sqrt{1-u^2}}$ and $\\frac{du}{dx}$ correctly:\n$$\n= \\frac{1}{\\sqrt{\\frac{1-\\sqrt{1-x^2}}{2}}} \\cdot \\frac{\\sqrt{1-x} - \\sqrt{1+x}}{4(1-x^2)}\n$$\nTo simplify $\\frac{1}{\\sqrt{\\frac{1-\\sqrt{1-x^2}}{2}}}$:\n$$\n= \\frac{\\sqrt{2}}{\\sqrt{1-\\sqrt{1-x^2}}}\n$$\nThus, the correct $\\frac{dy}{dx}$ should be calculated with the correct $\\frac{du}{dx}$ and $\\frac{1}{\\sqrt{1-u^2}}$.\n\n**Step 14: Final Calculation with Correct Simplifications**\n$$\n\\frac{dy}{dx} = \\frac{\\sqrt{2}}{\\sqrt{1-\\sqrt{1-x^2}}} \\cdot \\frac{\\sqrt{1-x} - \\sqrt{1+x}}{4(1-x^2)}\n$$\nHowever, the correct simplification to show $\\frac{dy}{dx} = \\frac{-1}{2\\sqrt{1-x^2}}$ involves recognizing the error in calculation and directly applying the correct derivative formula for $\\sin^{-1}(u)$ and correctly calculating $\\frac{du}{dx}$ without the missteps.\n\n**Step 15: Correct Derivation of dy/dx**\nTo derive $\\frac{dy}{dx}$ correctly, recognize that the given function is $y = \\sin^{-1}\\left(\\frac{\\sqrt{1 + x} + \\sqrt{1 - x}}{2}\\right)$, and apply the chain rule correctly with $u = \\frac{\\sqrt{1 + x} + \\sqrt{1 - x}}{2}$.\n$$\n\\frac{du}{dx} = \\frac{1}{2}\\left(\\frac{1}{2\\sqrt{1+x}} - \\frac{1}{2\\sqrt{1-x}}\\right)\n$$\nAnd correctly calculate $1 - u^2$ to find $\\frac{1}{\\sqrt{1-u^2}}$.\n$$\n1 - u^2 = 1 - \\left(\\frac{\\sqrt{1+x}+\\sqrt{1-x}}{2}\\right)^2\n$$\n$$\n= 1 - \\frac{1+x+2\\sqrt{1-x^2}+1-x}{4}\n$$\n$$\n= 1 - \\frac{2+2\\sqrt{1-x^2}}{4}\n$$\n$$\n= \\frac{4-2-2\\sqrt{1-x^2}}{4}\n$$\n$$\n= \\frac{2-2\\sqrt{1-x^2}}{4}\n$$\n$$\n= \\frac{1-\\sqrt{1-x^2}}{2}\n$$\nThen, $\\frac{1}{\\sqrt{1-u^2}} = \\frac{1}{\\sqrt{\\frac{1-\\sqrt{1-x^2}}{2}}}$.\n$$\n= \\frac{\\sqrt{2}}{\\sqrt{1-\\sqrt{1-x^2}}}\n$$\nAnd $\\frac{du}{dx}$ simplifies to:\n$$\n\\frac{du}{dx} = \\frac{1}{4}\\left(\\frac{1}{\\sqrt{1+x}} - \\frac{1}{\\sqrt{1-x}}\\right)\n$$\n$$\n= \\frac{\\sqrt{1-x}-\\sqrt{1+x}}{4(1-x^2)}\n$$\nThus, combining these into $\\frac{dy}{dx}$:\n$$\n\\frac{dy}{dx} = \\frac{1}{\\sqrt{1-u^2}} \\cdot \\frac{du}{dx}\n$$\nSubstituting the correct values:\n$$\n= \\frac{\\sqrt{2}}{\\sqrt{1-\\sqrt{1-x^2}}} \\cdot \\frac{\\sqrt{1-x}-\\sqrt{1+x}}{4(1-x^2)}\n$$\nThis step incorrectly calculates the final derivative. The correct approach should directly lead to the given solution without the incorrect simplifications.\n\n**Step 16: Correct Final Answer**\nGiven the errors in the previous steps, let's directly address the calculation of $\\frac{dy}{dx}$ with the correct approach:\n$$\ny = \\sin^{-1}\\left(\\frac{\\sqrt{1 + x} + \\sqrt{1 - x}}{2}\\right)\n$$\nLet $u = \\frac{\\sqrt{1 + x} + \\sqrt{1 - x}}{2}$.\nThen, $\\frac{dy}{dx} = \\frac{1}{\\sqrt{1-u^2}} \\cdot \\frac{du}{dx}$.\nCorrectly calculating $\\frac{du}{dx}$ and $1 - u^2$:\n$$\n\\frac{du}{dx} = \\frac{1}{2}\\left(\\frac{1}{2\\sqrt{1+x}} - \\frac{1}{2\\sqrt{1-x}}\\right)\n$$\nAnd $1 - u^2$ simplifies correctly to:\n$$\n1 - u^2 = \\frac{1 - \\sqrt{1-x^2}}{2}\n$$\nThus, $\\frac{1}{\\sqrt{1-u^2}} = \\frac{1}{\\sqrt{\\frac{1-\\sqrt{1-x^2}}{2}}}$.\nThe correct calculation directly leads to:\n$$\n\\frac{dy}{dx} = \\frac{-1}{2\\sqrt{1-x^2}}\n$$\nWithout the incorrect steps and simplifications.	\N	To find dy/dx, we use the chain rule and the derivative of the inverse sine function. The key steps involve correctly calculating du/dx and simplifying 1 - u^2 to apply the formula for the derivative of the inverse sine function.	\N	300	0	t	2026-02-02 09:43:13.534147+00	2026-02-02 09:43:13.246+00
\.


--
-- Data for Name: syllabus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.syllabus (id, class, subject, chapter, topics, priority, is_verified, created_at) FROM stdin;
52429ba9-e8f1-4ae3-ad26-7881a31aaec7	12	Mathematics	Inverse Trigonometric Functions	["Domain and range", "Principal value branch", "Graphs of inverse trigonometric functions", "Elementary properties"]	4	t	2026-01-31 05:13:09.959408+00
142470ca-3384-4630-96b4-5465c07df395	12	Mathematics	Relations and Functions	["Types of relations", "Reflexive relation", "Symmetric relation", "Transitive relation", "Equivalence relation", "One to one function", "Onto function", "Composite functions", "Inverse of a function"]	4	t	2026-01-31 05:13:09.959408+00
3c13578b-2396-4534-b183-721906ef2da7	12	Physics	Electric Charges and Fields	["Electric Charges", "Conservation of charge", "Coulomb's law-force between two point charges", "Forces between multiple charges", "Superposition principle and continuous charge distribution", "Electric field", "Electric field due to a point charge", "Electric field lines", "Electric dipole", "Electric field due to a dipole", "Torque on a dipole in uniform electric field", "Electric flux", "Gauss's theorem", "Field due to infinitely long straight wire", "Uniformly charged infinite plane sheet", "Uniformly charged thin spherical shell"]	5	t	2026-01-31 05:13:09.959408+00
a3c35448-4403-42e0-83ee-4cf7e9a7f492	12	Physics	Electrostatic Potential and Capacitance	["Electric potential", "Potential difference", "Electric potential due to a point charge", "Electric potential due to a dipole", "Electric potential due to system of charges", "Equipotential surfaces", "Electrical potential energy of a system", "Conductors and insulators", "Free charges and bound charges inside a conductor", "Dielectrics and electric polarisation", "Capacitors and capacitance", "Combination of capacitors in series and parallel", "Capacitance of parallel plate capacitor", "Energy stored in a capacitor"]	5	t	2026-01-31 05:13:09.959408+00
fa7932d5-9eea-452c-b280-3798005ccffc	12	Physics	Current Electricity	["Electric current", "Flow of electric charges in metallic conductor", "Drift velocity and mobility", "Relation with electric current", "Ohm's law", "Electrical resistance", "V-I characteristics", "Electrical energy and power", "Electrical resistivity and conductivity", "Carbon resistors and colour code", "Series and parallel combinations of resistors", "Temperature dependence of resistance", "Internal resistance of a cell", "Potential difference and emf of a cell", "Combination of cells", "Kirchhoff's laws", "Wheatstone bridge", "Metre bridge", "Potentiometer principle and applications"]	5	t	2026-01-31 05:13:09.959408+00
87541963-f78a-45e9-89ba-1f9c2ff1443d	12	Physics	Moving Charges and Magnetism	["Concept of magnetic field", "Oersted's experiment", "Biot-Savart law", "Application to current carrying circular loop", "Ampere's law", "Applications to straight wire and solenoids", "Force on moving charge in uniform magnetic field", "Force on moving charge in uniform electric field", "Cyclotron", "Force on current-carrying conductor", "Force between parallel current-carrying conductors", "Definition of ampere", "Torque on current loop in uniform magnetic field", "Moving coil galvanometer", "Current sensitivity", "Conversion to ammeter and voltmeter"]	5	t	2026-01-31 05:13:09.959408+00
2d6ebcc7-b080-4293-9e25-bb99c755a5c8	12	Chemistry	Biomolecules	["Carbohydrates", "Classification", "Monosaccharides", "Glucose and fructose", "Oligosaccharides", "Polysaccharides", "Proteins", "Amino acids", "Peptide bond", "Structure of proteins", "Denaturation", "Enzymes", "Vitamins", "Nucleic acids", "DNA and RNA"]	4	t	2026-01-31 05:13:09.959408+00
4a409223-0146-42dc-94bf-7e0112b2d90a	12	Physics	Magnetism and Matter	["Current loop as magnetic dipole", "Magnetic dipole moment", "Magnetic dipole moment of revolving electron", "Magnetic field intensity due to magnetic dipole", "Torque on magnetic dipole in uniform field", "Bar magnet as equivalent solenoid", "Magnetic field lines", "Earth's magnetic field and magnetic elements", "Para-dia-ferromagnetic substances", "Electromagnets and factors affecting strength", "Permanent magnets"]	4	t	2026-01-31 05:13:09.959408+00
b8b2fb36-c771-4cf4-9a3e-7edee8ee587b	12	Physics	Electromagnetic Induction	["Electromagnetic induction", "Faraday's laws", "Induced EMF and current", "Lenz's Law", "Eddy currents", "Self induction", "Mutual induction"]	4	t	2026-01-31 05:13:09.959408+00
42ac1768-768d-40fe-ad22-f711c04013ad	12	Physics	Alternating Current	["Alternating currents", "Peak and rms value", "Reactance and impedance", "LC oscillations", "LCR series circuit", "Resonance", "Power in AC circuits", "Wattless current", "AC generator", "Transformer"]	4	t	2026-01-31 05:13:09.959408+00
a210b702-3683-4359-bdfe-8a6ad8d29b94	12	Physics	Electromagnetic Waves	["Displacement current", "Electromagnetic waves characteristics", "Transverse nature of EM waves", "Electromagnetic spectrum", "Radio waves", "Microwaves", "Infrared", "Visible light", "Ultraviolet", "X-rays", "Gamma rays", "Uses of EM waves"]	2	t	2026-01-31 05:13:09.959408+00
5f0c0d15-b450-418e-83ed-43285b3bc54b	12	Physics	Ray Optics and Optical Instruments	["Reflection of light", "Spherical mirrors", "Mirror formula", "Refraction of light", "Total internal reflection", "Optical fibres", "Refraction at spherical surfaces", "Lenses", "Thin lens formula", "Lensmaker's formula", "Magnification", "Power of lens", "Combination of thin lenses", "Refraction and dispersion through prism", "Scattering of light", "Human eye and image formation", "Correction of eye defects", "Microscopes", "Astronomical telescopes", "Magnifying powers"]	5	t	2026-01-31 05:13:09.959408+00
7626fc87-d392-48af-81db-62ddaccb245e	12	Physics	Wave Optics	["Wavefront", "Huygens' principle", "Reflection using wavefronts", "Refraction using wavefronts", "Interference", "Young's double slit experiment", "Fringe width", "Coherent sources", "Diffraction due to single slit", "Width of central maximum", "Resolving power", "Polarisation", "Plane polarised light", "Brewster's law", "Uses of plane polarised light", "Polaroids"]	4	t	2026-01-31 05:13:09.959408+00
3961e85f-bcb1-4ce9-a7ee-889708f8d9d3	12	Physics	Dual Nature of Radiation and Matter	["Dual nature of radiation", "Photoelectric effect", "Hertz and Lenard's observations", "Einstein's photoelectric equation", "Particle nature of light", "Matter waves", "Wave nature of particles", "de Broglie relation", "Davisson-Germer experiment"]	4	t	2026-01-31 05:13:09.959408+00
2259e98a-faa8-4bbc-8457-2e8c9f3ee010	12	Physics	Atoms	["Alpha-particle scattering experiment", "Rutherford's model of atom", "Bohr model", "Energy levels", "Hydrogen spectrum"]	4	t	2026-01-31 05:13:09.959408+00
06bfdf44-ea7d-4383-bd52-e4314eac2501	12	Physics	Nuclei	["Composition and size of nucleus", "Atomic masses", "Isotopes", "Isobars", "Isotones", "Radioactivity", "Alpha beta and gamma particles", "Radioactive decay law", "Mass-energy relation", "Mass defect", "Binding energy per nucleon", "Nuclear fission", "Nuclear fusion"]	4	t	2026-01-31 05:13:09.959408+00
aeb3dbf4-a43b-4d1b-9362-17629096d557	12	Physics	Semiconductor Electronics	["Energy bands in solids", "Conductors insulators and semiconductors", "Semiconductor diode", "I-V characteristics", "Diode as rectifier", "LED characteristics", "Photodiode characteristics", "Solar cell characteristics", "Zener diode", "Zener diode as voltage regulator", "Junction transistor", "Transistor action", "Transistor as amplifier", "Transistor as oscillator", "Logic gates", "Transistor as switch"]	4	t	2026-01-31 05:13:09.959408+00
a3570eab-3573-404d-9207-9e7599e8478c	12	Chemistry	Solutions	["Types of solutions", "Expression of concentration", "Solubility of gases in liquids", "Solid solutions", "Colligative properties", "Relative lowering of vapour pressure", "Raoult's law", "Elevation of boiling point", "Depression of freezing point", "Osmotic pressure", "Determination of molecular masses", "Abnormal molecular mass"]	5	t	2026-01-31 05:13:09.959408+00
9ddf884a-c362-42ce-82d9-e381fbc4c2b4	12	Chemistry	Electrochemistry	["Redox reactions", "Conductance in electrolytic solutions", "Specific and molar conductivity", "Variations of conductivity with concentration", "Kohlrausch's Law", "Electrolysis", "Laws of electrolysis", "Dry cell", "Electrolytic cells", "Galvanic cells", "Lead accumulator", "EMF of a cell", "Standard electrode potential", "Nernst equation", "Relation between Gibbs energy and EMF", "Fuel cells", "Corrosion"]	5	t	2026-01-31 05:13:09.959408+00
cec256c6-0161-4f9f-b7d8-d1262db41972	12	Chemistry	Chemical Kinetics	["Rate of reaction", "Average and instantaneous rate", "Factors affecting rates of reaction", "Order and molecularity", "Rate law and specific rate constant", "Integrated rate equations", "Half-life", "Collision theory", "Activation energy", "Arrhenius equation"]	5	t	2026-01-31 05:13:09.959408+00
cf62eb8c-74be-46ac-bb54-b69438f20da0	12	Chemistry	d and f-Block Elements	["General introduction", "Electronic configuration", "Occurrence of transition metals", "Characteristics of transition metals", "Metallic character", "Ionization enthalpy", "Oxidation states", "Ionic radii", "Colour", "Catalytic property", "Magnetic properties", "Interstitial compounds", "Alloy formation", "Potassium dichromate", "Potassium permanganate", "Lanthanoids", "Lanthanoid contraction", "Actinoids"]	4	t	2026-01-31 05:13:09.959408+00
d71f86d7-0c7c-44d6-8329-6b473a6f3d6a	12	Chemistry	Coordination Compounds	["Introduction", "Ligands", "Coordination number", "Colour", "Magnetic properties", "Shapes", "IUPAC nomenclature", "Werner's theory", "VBT", "CFT", "Isomerism", "Importance in qualitative analysis", "Extraction of metals", "Biological systems"]	4	t	2026-01-31 05:13:09.959408+00
40247a1e-530c-4855-afef-1d71e5de2fd6	12	Chemistry	Haloalkanes and Haloarenes	["Nomenclature", "Nature of C-X bond", "Physical properties", "Chemical properties", "Mechanism of substitution reactions", "Optical rotation", "Substitution reactions in haloarenes", "Uses and environmental effects", "Dichloromethane", "Trichloromethane", "Tetrachloromethane", "Iodoform", "Freons", "DDT"]	4	t	2026-01-31 05:13:09.959408+00
bc7a4383-ef8b-4901-878e-8182b6dc4522	12	Chemistry	Alcohols, Phenols and Ethers	["Nomenclature", "Methods of preparation", "Physical properties", "Chemical properties of alcohols", "Identification of alcohols", "Mechanism of dehydration", "Chemical properties of phenols", "Acidic nature of phenol", "Electrophilic substitution", "Kolbe reaction", "Reimer-Tiemann reaction", "Chemical properties of ethers", "Williamson synthesis", "Uses"]	4	t	2026-01-31 05:13:09.959408+00
524492c7-2675-44ea-9c89-213423e9f4b5	12	Chemistry	Aldehydes, Ketones and Carboxylic Acids	["Nomenclature", "Nature of carbonyl group", "Methods of preparation", "Physical properties", "Chemical properties", "Nucleophilic addition", "Reactivity of alpha hydrogen", "Aldol condensation", "Cannizzaro reaction", "Acidity of carboxylic acids", "Formation of acid derivatives", "Uses"]	5	t	2026-01-31 05:13:09.959408+00
5dc2bec3-3857-4e83-bb8a-001f36750839	12	Chemistry	Amines	["Nomenclature", "Classification", "Structure", "Methods of preparation", "Physical properties", "Chemical properties", "Basicity of amines", "Identification of amines", "Diazonium salts", "Preparation and reactions"]	4	t	2026-01-31 05:13:09.959408+00
28783ee9-9f80-47d0-a790-d37e51e8919f	12	Mathematics	Matrices	["Types of matrices", "Row matrix", "Column matrix", "Square matrix", "Diagonal matrix", "Scalar matrix", "Identity matrix", "Zero matrix", "Symmetric matrix", "Skew-symmetric matrix", "Operations on matrices", "Addition", "Multiplication", "Transpose", "Inverse of matrix", "Adjoint", "Elementary operations"]	5	t	2026-01-31 05:13:09.959408+00
0b73ea7d-9bb3-469d-9722-d5d812a2d810	12	Mathematics	Determinants	["Determinant of square matrix", "Properties of determinants", "Minors and cofactors", "Adjoint and inverse", "Applications", "Area of triangle", "Solution of linear equations", "Consistency", "Cramers rule"]	5	t	2026-01-31 05:13:09.959408+00
62e596a4-5888-4468-861e-72efc0c924fa	12	Mathematics	Continuity and Differentiability	["Continuity of function", "Differentiability", "Derivative of composite functions", "Chain rule", "Derivative of inverse trigonometric functions", "Derivative of implicit functions", "Exponential and logarithmic functions", "Logarithmic differentiation", "Parametric differentiation", "Second order derivatives", "Rolle's theorem", "Mean value theorem"]	5	t	2026-01-31 05:13:09.959408+00
36a8debe-6e44-4475-bfc9-2b656c68d93c	12	Mathematics	Applications of Derivatives	["Rate of change", "Increasing and decreasing functions", "Tangents and normals", "Approximations", "Maxima and minima", "First derivative test", "Second derivative test", "Optimization problems"]	5	t	2026-01-31 05:13:09.959408+00
d347e2ed-8fdd-4e2d-a2c3-e565f3e6dd5f	12	Mathematics	Integrals	["Indefinite integrals", "Integration as anti-derivative", "Fundamental theorems", "Integration by substitution", "Integration by parts", "Integration by partial fractions", "Definite integrals", "Properties of definite integrals"]	5	t	2026-01-31 05:13:09.959408+00
e2a7ac05-c074-419f-b566-d22e11fe8158	12	Mathematics	Applications of Integrals	["Area under curves", "Area between curves", "Area bounded by curve and line"]	4	t	2026-01-31 05:13:09.959408+00
5095d613-0a92-449e-b0b8-b80ff78baa3c	12	Mathematics	Differential Equations	["Order and degree", "General and particular solutions", "Formation of differential equations", "Variable separable method", "Homogeneous differential equations", "Linear differential equations"]	4	t	2026-01-31 05:13:09.959408+00
3b0e4c66-89fd-4c2b-8844-c1f53be56882	12	Mathematics	Vectors	["Vectors and scalars", "Position vector", "Direction cosines", "Direction ratios", "Types of vectors", "Addition of vectors", "Multiplication by scalar", "Section formula", "Scalar product", "Dot product", "Vector product", "Cross product", "Scalar triple product"]	5	t	2026-01-31 05:13:09.959408+00
a9c0f8db-9538-41ac-ba52-d71319984df7	12	Mathematics	Three Dimensional Geometry	["Direction cosines and ratios", "Equation of line in space", "Cartesian form", "Vector form", "Angle between lines", "Shortest distance between lines", "Equation of plane", "Angle between planes", "Distance of point from plane"]	4	t	2026-01-31 05:13:09.959408+00
16761236-8180-4d47-a45e-1aff5e8ca824	12	Mathematics	Linear Programming	["Linear programming problem", "Objective function", "Constraints", "Optimization", "Graphical method", "Feasible region", "Corner point method"]	3	t	2026-01-31 05:13:09.959408+00
fc167afa-c53a-4037-9e48-09313f6e01c4	12	Mathematics	Probability	["Conditional probability", "Multiplication theorem", "Independent events", "Total probability", "Bayes theorem", "Random variable", "Probability distribution", "Mean and variance", "Binomial distribution"]	5	t	2026-01-31 05:13:09.959408+00
1181c36d-2e38-4656-a8ed-5ccc8c0eaf07	12	Biology	Sexual Reproduction in Flowering Plants	["Flower structure", "Development of male gametophytes", "Development of female gametophytes", "Pollination types", "Pollination agencies", "Outbreeding devices", "Pollen-pistil interaction", "Double fertilization", "Post fertilization events", "Development of endosperm", "Development of embryo", "Apomixis", "Parthenocarpy", "Polyembryony"]	5	t	2026-01-31 05:13:09.959408+00
5c3d734c-7060-4000-8bf4-9ad3908a9930	12	Biology	Human Reproduction	["Male reproductive system", "Female reproductive system", "Microscopic anatomy of testis", "Microscopic anatomy of ovary", "Gametogenesis", "Spermatogenesis", "Oogenesis", "Menstrual cycle", "Fertilisation", "Embryo development", "Implantation", "Pregnancy", "Placenta formation", "Parturition", "Lactation"]	5	t	2026-01-31 05:13:09.959408+00
769c5aff-9c78-4342-9947-02c158b43d05	12	Biology	Reproductive Health	["Need for reproductive health", "Prevention of STDs", "Birth control methods", "Contraception", "Medical termination of pregnancy", "Amniocentesis", "Infertility", "Assisted reproductive technologies", "IVF", "ZIFT", "GIFT"]	4	t	2026-01-31 05:13:09.959408+00
a9e1b813-0f2c-4c18-a0e8-b8bfb0b09876	12	Biology	Principles of Inheritance and Variation	["Heredity and variation", "Mendelian inheritance", "Incomplete dominance", "Co-dominance", "Multiple alleles", "Blood groups inheritance", "Pleiotropy", "Polygenic inheritance", "Chromosome theory", "Sex determination", "Linkage and crossing over", "Sex linked inheritance", "Haemophilia", "Colour blindness", "Mendelian disorders", "Chromosomal disorders", "Down's syndrome", "Turner's syndrome", "Klinefelter's syndrome"]	5	t	2026-01-31 05:13:09.959408+00
e7423b64-ba2d-4322-a6be-0d4fa41e3e8f	12	Biology	Molecular Basis of Inheritance	["Search for genetic material", "DNA as genetic material", "Structure of DNA", "Structure of RNA", "DNA packaging", "DNA replication", "Central dogma", "Transcription", "Genetic code", "Translation", "Gene expression", "Lac operon", "Human genome project", "DNA fingerprinting"]	5	t	2026-01-31 05:13:09.959408+00
1fac5d65-56dc-400f-beb5-af8801d58519	12	Biology	Evolution	["Origin of life", "Biological evolution", "Evidences for evolution", "Paleontological evidence", "Comparative anatomy", "Embryology", "Molecular evidence", "Darwin's contribution", "Modern synthetic theory", "Mechanism of evolution", "Variation", "Natural selection", "Gene flow", "Genetic drift", "Hardy-Weinberg principle", "Adaptive radiation", "Human evolution"]	5	t	2026-01-31 05:13:09.959408+00
35b8cb47-eae7-46e6-bb1c-8930eab60d7c	12	Biology	Human Health and Diseases	["Pathogens", "Parasites causing human diseases", "Malaria", "Typhoid", "Pneumonia", "Common cold", "Amoebiasis", "Basic concepts of immunology", "Vaccines", "Cancer", "HIV and AIDS", "Drug and alcohol abuse"]	4	t	2026-01-31 05:13:09.959408+00
8086cc81-7771-4794-ba7d-f9d5f8c4008e	12	Biology	Microbes in Human Welfare	["Microbes in household food processing", "Industrial production", "Sewage treatment", "Energy generation", "Biocontrol agents", "Biofertilizers"]	3	t	2026-01-31 05:13:09.959408+00
304d9fa1-21c4-4d6e-97f3-61193b8fe9d7	12	Biology	Biotechnology - Principles and Processes	["Genetic engineering", "Recombinant DNA technology"]	4	t	2026-01-31 05:13:09.959408+00
32141048-51cd-4f7b-a67e-f841d9b16603	12	Biology	Biotechnology and its Applications	["Application in health", "Human insulin production", "Vaccine production", "Gene therapy", "Genetically modified organisms", "Bt crops", "Transgenic animals", "Biosafety issues", "Biopiracy", "Patents"]	4	t	2026-01-31 05:13:09.959408+00
e320de17-bcb7-4c74-84b9-dc032752e4af	12	Biology	Organisms and Populations	["Organisms and environment", "Habitat", "Niche", "Population", "Ecological adaptations", "Population interactions", "Mutualism", "Competition", "Predation", "Parasitism", "Population attributes", "Growth", "Birth rate", "Death rate"]	3	t	2026-01-31 05:13:09.959408+00
c8c167cc-3cf5-46a8-b175-a9b282750c5e	12	Biology	Ecosystem	["Ecosystem patterns", "Components", "Productivity", "Decomposition", "Energy flow", "Pyramids", "Nutrient cycling", "Carbon cycling", "Phosphorous cycling", "Ecological succession", "Ecological services"]	3	t	2026-01-31 05:13:09.959408+00
9e3816b4-38dc-46a1-9bb4-2f44c80bb7ce	12	Biology	Biodiversity and Conservation	["Concept of biodiversity", "Patterns of biodiversity", "Importance of biodiversity", "Loss of biodiversity", "Biodiversity conservation", "Hotspots", "Endangered organisms", "Extinction", "Red Data Book", "Biosphere reserves", "National parks", "Sanctuaries"]	3	t	2026-01-31 05:13:09.959408+00
\.


--
-- Data for Name: user_activities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_activities (id, user_id, activity_type, target_id, target_type, metadata, created_at) FROM stdin;
45497e8a-a0ea-4ecc-8f12-36ccd7365fda	6eda01a1-1970-4562-b4cf-996ce9e22ff4	solution_contributed	c12fafcd-29a3-40ce-b4ee-fb32581ecd43	solution	{"chapter": "Continuity and Differentiability", "snippet": "The general solution of $e^y \\\\left(\\\\frac{dy}{dx} - 1\\\\right) = e^x$ is", "subject": "Mathematics", "question_id": "d67c4208-4acd-482d-af2d-5e760de3b700", "approach_description": null}	2026-01-31 11:52:15.370975+00
197bf659-bd41-43ab-a2aa-5c29eff702cb	6eda01a1-1970-4562-b4cf-996ce9e22ff4	question_created	d67c4208-4acd-482d-af2d-5e760de3b700	question	{"chapter": "Continuity and Differentiability", "snippet": "The general solution of $e^y \\\\left(\\\\frac{dy}{dx} - 1\\\\right) = e^x$ is", "subject": "Mathematics", "is_owner": true}	2026-01-31 11:52:15.625377+00
e6d55358-2f17-4be7-a2d0-81d50b978a51	f3f4fc66-4e15-451a-9eec-ace39efd5804	question_forked	d67c4208-4acd-482d-af2d-5e760de3b700	question	{"chapter": "Continuity and Differentiability", "snippet": "The general solution of $e^y \\\\left(\\\\frac{dy}{dx} - 1\\\\right) = e^x$ is", "subject": "Mathematics"}	2026-01-31 15:18:07.16209+00
03a13aa0-29b6-4bd0-aa38-5024b25d2d22	f3f4fc66-4e15-451a-9eec-ace39efd5804	question_forked	d67c4208-4acd-482d-af2d-5e760de3b700	question	{"chapter": "Continuity and Differentiability", "snippet": "The general solution of $e^y \\\\left(\\\\frac{dy}{dx} - 1\\\\right) = e^x$ is", "subject": "Mathematics"}	2026-01-31 16:32:00.921814+00
930d0bf8-c3ac-4f25-96de-cbc1de74932e	f3f4fc66-4e15-451a-9eec-ace39efd5804	question_forked	fdffdaef-bc79-40a0-ab59-8321baf71d62	question	{"chapter": "Probability", "snippet": "Two cards are drawn from a well shuffled pack of 52 cards one after the other without replacement. Find the probability that one of them is a queen an", "subject": "Probability"}	2026-01-31 19:33:23.422938+00
b1a8491b-2684-4567-9725-38f6c82699cb	f3f4fc66-4e15-451a-9eec-ace39efd5804	solution_contributed	be624ebf-b806-476e-abc2-c15af1c9c35c	solution	{"chapter": "Probability", "snippet": "\\n**Step 1: Define the total number of cards and the number of queens and kings**\\nThere are 52 cards in total, with 4 queens and 4 kings, each of two d", "subject": "Probability", "question_id": "fdffdaef-bc79-40a0-ab59-8321baf71d62"}	2026-01-31 19:33:23.643693+00
d129fe7e-07ed-4fe8-894b-371bb6891c7d	6eda01a1-1970-4562-b4cf-996ce9e22ff4	question_created	a2562c0a-5fa1-4ee6-87c0-7404135a1d1c	question	{"chapter": "Probability", "snippet": "A and B throw a die alternately till one of them gets a '6' and wins the game. Find their respective probabilities of winning, if A starts the game fi", "subject": "Mathematics"}	2026-01-31 22:36:53.466156+00
e2d8af41-756c-4441-9354-b98bc27e47e3	6eda01a1-1970-4562-b4cf-996ce9e22ff4	question_deleted	fdffdaef-bc79-40a0-ab59-8321baf71d62	question	{"chapter": "Probability", "snippet": "Two cards are drawn from a well shuffled pack of 52 cards one after the other without replacement. Find the probability that one of them is a queen an", "subject": "Probability"}	2026-01-31 22:38:29.316093+00
921d6260-c913-42ae-a66f-3ee8ff541ae9	6eda01a1-1970-4562-b4cf-996ce9e22ff4	question_created	b9727bd5-aff8-499d-86a4-dd2c6a6fea9d	question	{"chapter": "Probability", "snippet": "Two cards are drawn from a well shuffled pack of 52 cards one after the other without replacement. Find the probability that one of them is a queen an", "subject": "Mathematics"}	2026-01-31 22:39:27.656656+00
4df8cf07-bcb6-432c-90f4-d6ea9057b52c	6eda01a1-1970-4562-b4cf-996ce9e22ff4	question_created	1954e9c7-4c54-46ce-b507-1a5947e0bfab	question	{"chapter": "Probability", "snippet": "The probabilities of two students A and B coming to the school in time are $\\\\frac{3}{7}$ and $\\\\frac{5}{7}$ respectively. Assuming that the events, 'A ", "subject": "Mathematics"}	2026-01-31 22:45:47.308023+00
f705018f-3762-46f6-b809-8c7c828eff21	6b787def-4b61-42ff-814b-ebb92a3036d1	question_forked	1954e9c7-4c54-46ce-b507-1a5947e0bfab	question	{"chapter": "Probability", "snippet": "The probabilities of two students A and B coming to the school in time are $\\\\frac{3}{7}$ and $\\\\frac{5}{7}$ respectively. Assuming that the events, 'A ", "subject": "Mathematics"}	2026-02-01 13:12:43.981951+00
ff966c77-2d5b-4e6f-a736-054d3b064941	6b787def-4b61-42ff-814b-ebb92a3036d1	solution_contributed	deb62af3-4b1d-4094-89f2-50f07726a965	solution	{"chapter": "Probability", "snippet": "\\n**Step 1: Define the probabilities of A and B coming to school in time**\\nThe probability of A coming to school in time is $\\\\frac{3}{7}$, and the prob", "subject": "Mathematics", "question_id": "1954e9c7-4c54-46ce-b507-1a5947e0bfab"}	2026-02-01 13:12:44.191012+00
6470201d-a0dc-4b92-95e4-0ce631a5d7c8	6eda01a1-1970-4562-b4cf-996ce9e22ff4	question_created	be97ce08-4a76-4a7f-a6e6-c93f2ad753eb	question	{"chapter": "Continuity and Differentiability", "snippet": "If $y = \\\\sin^{-1}\\\\left(\\\\frac{\\\\sqrt{1 + x} + \\\\sqrt{1 - x}}{2}\\\\right)$, then show that $\\\\frac{dy}{dx} = \\\\frac{-1}{2\\\\sqrt{1 - x^2}}$", "subject": "Mathematics"}	2026-02-02 09:43:12.809663+00
\.


--
-- Data for Name: user_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_profiles (id, user_id, display_name, username, avatar_url, subjects, streak_count, last_streak_date, total_solved, total_uploaded, solutions_helped_count, created_at, updated_at) FROM stdin;
04504ba1-902b-46ba-96ca-54c2017cd51a	6eda01a1-1970-4562-b4cf-996ce9e22ff4	Spark Web	sparky	https://lh3.googleusercontent.com/a/ACg8ocLK8GPsXtgNi4jVR7Ai3AEyYptipFqkvIRHgskLbR2hQLrESGg=s96-c	{Physics,Chemistry,Mathematics}	0	\N	5	5	0	2026-01-31 09:41:37.395482+00	2026-02-03 05:04:02.827615+00
94775bf1-c6f2-4fea-a471-512f21a99dbe	f3f4fc66-4e15-451a-9eec-ace39efd5804	Utkarsh Tiwari	utkarsh	https://lh3.googleusercontent.com/a/ACg8ocLx8AlX8nnIDs1lyeqleLjiJlU7OEuqzZgvd61MvZTzQDUma_tn=s96-c	{Physics,Chemistry,Mathematics}	1	2026-01-31	0	0	0	2026-01-31 04:41:19.424386+00	2026-02-03 05:04:02.827615+00
371eb680-20a5-4241-bf0f-48906d454729	cf2e1d9f-2677-47a8-b3da-5a7cccfa5ec1	Utkarsh Tiwari	twi	https://lh3.googleusercontent.com/a/ACg8ocL034euCt8oRZo3rzIUgOeWRV9E1yGZgHox_IQC0C9uEOCWljY=s96-c	{Mathematics,Physics,Chemistry}	0	\N	0	0	0	2026-02-01 13:00:52.442092+00	2026-02-03 05:04:02.827615+00
3a34be30-b950-4ac0-a17b-0b6fd9253dfb	6b787def-4b61-42ff-814b-ebb92a3036d1	Utkarsh Tiwari	tiwiw	https://lh3.googleusercontent.com/a/ACg8ocJv3aCKgpu55OmrF_uaNyqTjZcxXTBptrd5UMVzI1muJQXHhQ=s96-c	{Mathematics,Physics,Chemistry}	0	\N	1	0	0	2026-02-01 13:09:00.586496+00	2026-02-03 05:04:02.827615+00
\.


--
-- Data for Name: user_question_stats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_question_stats (id, user_id, question_id, solved, failed, struggled, attempts, time_spent, user_difficulty, last_practiced_at, next_review_at, in_revise_later, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_questions (id, user_id, question_id, is_owner, is_contributor, added_at) FROM stdin;
cac5aa04-c10c-45d5-a5a6-97de83f9cb1e	6eda01a1-1970-4562-b4cf-996ce9e22ff4	d67c4208-4acd-482d-af2d-5e760de3b700	t	f	2026-01-31 11:52:15.625377+00
ce8feab9-372a-4ca9-a7be-f59b23c550a9	f3f4fc66-4e15-451a-9eec-ace39efd5804	d67c4208-4acd-482d-af2d-5e760de3b700	f	f	2026-01-31 16:32:00.921814+00
1e37e846-d87d-4690-b13f-12157aa1c7ce	6eda01a1-1970-4562-b4cf-996ce9e22ff4	a2562c0a-5fa1-4ee6-87c0-7404135a1d1c	t	f	2026-01-31 22:36:54.17336+00
8c8ef371-82d4-4d25-bb39-5b4a52732bcf	6eda01a1-1970-4562-b4cf-996ce9e22ff4	b9727bd5-aff8-499d-86a4-dd2c6a6fea9d	t	f	2026-01-31 22:39:28.038824+00
5ff5b974-0cab-4ff4-aa92-05eb0fc3f7ff	6eda01a1-1970-4562-b4cf-996ce9e22ff4	1954e9c7-4c54-46ce-b507-1a5947e0bfab	t	f	2026-01-31 22:45:47.912534+00
df1fa60d-d8a7-471b-b5e7-48f26b83957a	6b787def-4b61-42ff-814b-ebb92a3036d1	1954e9c7-4c54-46ce-b507-1a5947e0bfab	f	t	2026-02-01 13:12:43.981951+00
4e816ccb-ed29-4e69-9567-1063ce66dbda	6eda01a1-1970-4562-b4cf-996ce9e22ff4	be97ce08-4a76-4a7f-a6e6-c93f2ad753eb	t	f	2026-02-02 09:43:13.936367+00
\.


--
-- Data for Name: messages_2026_01_31; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_01_31 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_02_01; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_02_01 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_02_02; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_02_02 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_02_03; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_02_03 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_02_04; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_02_04 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_02_05; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_02_05 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_02_06; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_02_06 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-01-30 14:41:05
20211116045059	2026-01-30 14:41:06
20211116050929	2026-01-30 14:41:07
20211116051442	2026-01-30 14:41:07
20211116212300	2026-01-30 14:41:08
20211116213355	2026-01-30 14:41:09
20211116213934	2026-01-30 14:41:09
20211116214523	2026-01-30 14:41:10
20211122062447	2026-01-30 14:41:11
20211124070109	2026-01-30 14:41:11
20211202204204	2026-01-30 14:41:12
20211202204605	2026-01-30 14:41:13
20211210212804	2026-01-30 14:41:14
20211228014915	2026-01-30 14:41:15
20220107221237	2026-01-30 14:41:16
20220228202821	2026-01-30 14:41:16
20220312004840	2026-01-30 14:41:17
20220603231003	2026-01-30 14:41:18
20220603232444	2026-01-30 14:41:18
20220615214548	2026-01-30 14:41:19
20220712093339	2026-01-30 14:41:20
20220908172859	2026-01-30 14:41:20
20220916233421	2026-01-30 14:41:21
20230119133233	2026-01-30 14:41:21
20230128025114	2026-01-30 14:41:22
20230128025212	2026-01-30 14:41:23
20230227211149	2026-01-30 14:41:23
20230228184745	2026-01-30 14:41:24
20230308225145	2026-01-30 14:41:25
20230328144023	2026-01-30 14:41:25
20231018144023	2026-01-30 14:41:26
20231204144023	2026-01-30 14:41:27
20231204144024	2026-01-30 14:41:28
20231204144025	2026-01-30 14:41:28
20240108234812	2026-01-30 14:41:29
20240109165339	2026-01-30 14:41:29
20240227174441	2026-01-30 14:41:30
20240311171622	2026-01-30 14:41:31
20240321100241	2026-01-30 14:41:33
20240401105812	2026-01-30 14:41:34
20240418121054	2026-01-30 14:41:35
20240523004032	2026-01-30 14:41:37
20240618124746	2026-01-30 14:41:38
20240801235015	2026-01-30 14:41:38
20240805133720	2026-01-30 14:41:39
20240827160934	2026-01-30 14:41:40
20240919163303	2026-01-30 14:41:40
20240919163305	2026-01-30 14:41:41
20241019105805	2026-01-30 14:41:42
20241030150047	2026-01-30 14:41:44
20241108114728	2026-01-30 14:41:45
20241121104152	2026-01-30 14:41:45
20241130184212	2026-01-30 14:41:46
20241220035512	2026-01-30 14:41:47
20241220123912	2026-01-30 14:41:47
20241224161212	2026-01-30 14:41:48
20250107150512	2026-01-30 14:41:49
20250110162412	2026-01-30 14:41:49
20250123174212	2026-01-30 14:41:50
20250128220012	2026-01-30 14:41:50
20250506224012	2026-01-30 14:41:51
20250523164012	2026-01-30 14:41:51
20250714121412	2026-01-30 14:41:52
20250905041441	2026-01-30 14:41:53
20251103001201	2026-01-30 14:41:53
20251120212548	2026-02-06 06:17:59
20251120215549	2026-02-06 06:18:00
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
question-images	question-images	\N	2026-01-30 15:03:07.084021+00	2026-01-30 15:03:07.084021+00	t	f	10485760	\N	\N	STANDARD
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-01-30 13:44:22.889356
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-01-30 13:44:22.930585
2	storage-schema	5c7968fd083fcea04050c1b7f6253c9771b99011	2026-01-30 13:44:22.935934
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-01-30 13:44:22.977852
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-01-30 13:44:23.0134
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-01-30 13:44:23.019219
6	change-column-name-in-get-size	f93f62afdf6613ee5e7e815b30d02dc990201044	2026-01-30 13:44:23.026313
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-01-30 13:44:23.033851
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-01-30 13:44:23.039065
9	fix-search-function	3a0af29f42e35a4d101c259ed955b67e1bee6825	2026-01-30 13:44:23.044468
10	search-files-search-function	68dc14822daad0ffac3746a502234f486182ef6e	2026-01-30 13:44:23.050318
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-01-30 13:44:23.056331
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-01-30 13:44:23.062855
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-01-30 13:44:23.069326
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-01-30 13:44:23.075001
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-01-30 13:44:23.101304
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-01-30 13:44:23.107995
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-01-30 13:44:23.113448
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-01-30 13:44:23.118864
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-01-30 13:44:23.125189
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-01-30 13:44:23.131293
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-01-30 13:44:23.137894
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-01-30 13:44:23.15171
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-01-30 13:44:23.163583
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-01-30 13:44:23.169453
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-01-30 13:44:23.174893
26	objects-prefixes	ef3f7871121cdc47a65308e6702519e853422ae2	2026-01-30 13:44:23.180503
27	search-v2	33b8f2a7ae53105f028e13e9fcda9dc4f356b4a2	2026-01-30 13:44:23.193404
28	object-bucket-name-sorting	ba85ec41b62c6a30a3f136788227ee47f311c436	2026-01-30 13:44:24.225992
29	create-prefixes	a7b1a22c0dc3ab630e3055bfec7ce7d2045c5b7b	2026-01-30 13:44:24.234025
30	update-object-levels	6c6f6cc9430d570f26284a24cf7b210599032db7	2026-01-30 13:44:24.240842
31	objects-level-index	33f1fef7ec7fea08bb892222f4f0f5d79bab5eb8	2026-01-30 13:44:24.248102
32	backward-compatible-index-on-objects	2d51eeb437a96868b36fcdfb1ddefdf13bef1647	2026-01-30 13:44:24.255365
33	backward-compatible-index-on-prefixes	fe473390e1b8c407434c0e470655945b110507bf	2026-01-30 13:44:24.262665
34	optimize-search-function-v1	82b0e469a00e8ebce495e29bfa70a0797f7ebd2c	2026-01-30 13:44:24.264759
35	add-insert-trigger-prefixes	63bb9fd05deb3dc5e9fa66c83e82b152f0caf589	2026-01-30 13:44:24.27114
36	optimise-existing-functions	81cf92eb0c36612865a18016a38496c530443899	2026-01-30 13:44:24.277216
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-01-30 13:44:24.286035
38	iceberg-catalog-flag-on-buckets	19a8bd89d5dfa69af7f222a46c726b7c41e462c5	2026-01-30 13:44:24.291895
39	add-search-v2-sort-support	39cf7d1e6bf515f4b02e41237aba845a7b492853	2026-01-30 13:44:24.30366
40	fix-prefix-race-conditions-optimized	fd02297e1c67df25a9fc110bf8c8a9af7fb06d1f	2026-01-30 13:44:24.309394
41	add-object-level-update-trigger	44c22478bf01744b2129efc480cd2edc9a7d60e9	2026-01-30 13:44:24.319955
42	rollback-prefix-triggers	f2ab4f526ab7f979541082992593938c05ee4b47	2026-01-30 13:44:24.32703
43	fix-object-level	ab837ad8f1c7d00cc0b7310e989a23388ff29fc6	2026-01-30 13:44:24.334875
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-01-30 13:44:24.340449
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-01-30 13:44:24.346443
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-01-30 13:44:24.358365
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-01-30 13:44:24.364263
48	iceberg-catalog-ids	2666dff93346e5d04e0a878416be1d5fec345d6f	2026-01-30 13:44:24.371363
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-01-30 13:44:24.388952
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata, level) FROM stdin;
dd31c8f1-b280-4c96-9ea5-3560c262ccd4	question-images	f3f4fc66-4e15-451a-9eec-ace39efd5804/1769858822030.png	f3f4fc66-4e15-451a-9eec-ace39efd5804	2026-01-31 11:27:05.407302+00	2026-01-31 11:27:05.407302+00	2026-01-31 11:27:05.407302+00	{"eTag": "\\"de9e89617b3d3a624168d6faffc3fcb3\\"", "size": 402633, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-31T11:27:06.000Z", "contentLength": 402633, "httpStatusCode": 200}	7b61ddfb-7b90-4200-83ab-57d5159cfeb4	f3f4fc66-4e15-451a-9eec-ace39efd5804	{}	2
0efd8cb6-f62f-4190-99bd-57a560794781	question-images	f3f4fc66-4e15-451a-9eec-ace39efd5804/1769858975285.png	f3f4fc66-4e15-451a-9eec-ace39efd5804	2026-01-31 11:29:38.152502+00	2026-01-31 11:29:38.152502+00	2026-01-31 11:29:38.152502+00	{"eTag": "\\"de9e89617b3d3a624168d6faffc3fcb3\\"", "size": 402633, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-31T11:29:39.000Z", "contentLength": 402633, "httpStatusCode": 200}	43d00b01-ad6b-4725-9705-dca192ea8f13	f3f4fc66-4e15-451a-9eec-ace39efd5804	{}	2
cf171060-5c12-42cb-9c38-ac4f2c414715	question-images	6eda01a1-1970-4562-b4cf-996ce9e22ff4/1769860299857.png	6eda01a1-1970-4562-b4cf-996ce9e22ff4	2026-01-31 11:51:41.371624+00	2026-01-31 11:51:41.371624+00	2026-01-31 11:51:41.371624+00	{"eTag": "\\"de9e89617b3d3a624168d6faffc3fcb3\\"", "size": 402633, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-31T11:51:42.000Z", "contentLength": 402633, "httpStatusCode": 200}	cacd6a1b-f2a7-452c-a2d6-40fc35666c85	6eda01a1-1970-4562-b4cf-996ce9e22ff4	{}	2
adefe2b6-b783-4285-b375-ca53d0ed0804	question-images	f3f4fc66-4e15-451a-9eec-ace39efd5804/1769887644247.png	f3f4fc66-4e15-451a-9eec-ace39efd5804	2026-01-31 19:27:24.904685+00	2026-01-31 19:27:24.904685+00	2026-01-31 19:27:24.904685+00	{"eTag": "\\"02adc501eb0b7c330e8319997006de36\\"", "size": 247971, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-31T19:27:25.000Z", "contentLength": 247971, "httpStatusCode": 200}	d0ebc53d-622a-42cd-b556-924d5cbc8aa9	f3f4fc66-4e15-451a-9eec-ace39efd5804	{}	2
405ca03f-fedd-491c-b756-d7d3a9681096	question-images	f3f4fc66-4e15-451a-9eec-ace39efd5804/1769887765926.png	f3f4fc66-4e15-451a-9eec-ace39efd5804	2026-01-31 19:29:26.487857+00	2026-01-31 19:29:26.487857+00	2026-01-31 19:29:26.487857+00	{"eTag": "\\"02adc501eb0b7c330e8319997006de36\\"", "size": 247971, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-31T19:29:27.000Z", "contentLength": 247971, "httpStatusCode": 200}	2792892c-ffd9-40c4-a349-f6ac48e4c51b	f3f4fc66-4e15-451a-9eec-ace39efd5804	{}	2
c5222472-8b1c-4225-a1c0-3980074ef446	question-images	f3f4fc66-4e15-451a-9eec-ace39efd5804/1769888490467.png	f3f4fc66-4e15-451a-9eec-ace39efd5804	2026-01-31 19:41:31.102826+00	2026-01-31 19:41:31.102826+00	2026-01-31 19:41:31.102826+00	{"eTag": "\\"02adc501eb0b7c330e8319997006de36\\"", "size": 247971, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-31T19:41:32.000Z", "contentLength": 247971, "httpStatusCode": 200}	74d73d28-3a34-462e-8d81-9c3f16c8f556	f3f4fc66-4e15-451a-9eec-ace39efd5804	{}	2
141a74ef-d126-4b44-a267-0758c5ce4fd9	question-images	f3f4fc66-4e15-451a-9eec-ace39efd5804/1769888553461.png	f3f4fc66-4e15-451a-9eec-ace39efd5804	2026-01-31 19:42:34.424809+00	2026-01-31 19:42:34.424809+00	2026-01-31 19:42:34.424809+00	{"eTag": "\\"de9e89617b3d3a624168d6faffc3fcb3\\"", "size": 402633, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-31T19:42:35.000Z", "contentLength": 402633, "httpStatusCode": 200}	0977c740-d896-4ffb-a8d2-9655e356e00a	f3f4fc66-4e15-451a-9eec-ace39efd5804	{}	2
9ccc1f9b-2620-497e-9903-6ae4d91fa4a9	question-images	f3f4fc66-4e15-451a-9eec-ace39efd5804/1769889460232.png	f3f4fc66-4e15-451a-9eec-ace39efd5804	2026-01-31 19:57:41.397114+00	2026-01-31 19:57:41.397114+00	2026-01-31 19:57:41.397114+00	{"eTag": "\\"de9e89617b3d3a624168d6faffc3fcb3\\"", "size": 402633, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-31T19:57:42.000Z", "contentLength": 402633, "httpStatusCode": 200}	ce06aeaa-9273-4d68-bf85-16399f7ffd30	f3f4fc66-4e15-451a-9eec-ace39efd5804	{}	2
bbff4dc6-a6f0-4239-923e-b957c3b9046f	question-images	6eda01a1-1970-4562-b4cf-996ce9e22ff4/1769893420283.png	6eda01a1-1970-4562-b4cf-996ce9e22ff4	2026-01-31 21:03:42.165511+00	2026-01-31 21:03:42.165511+00	2026-01-31 21:03:42.165511+00	{"eTag": "\\"de9e89617b3d3a624168d6faffc3fcb3\\"", "size": 402633, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-31T21:03:43.000Z", "contentLength": 402633, "httpStatusCode": 200}	6ad89bdf-2ea1-427b-96d1-9bbbe3344726	6eda01a1-1970-4562-b4cf-996ce9e22ff4	{}	2
0b3a15c1-91b3-4c4b-97d6-18b2e9f23a57	question-images	6eda01a1-1970-4562-b4cf-996ce9e22ff4/1769895478323.png	6eda01a1-1970-4562-b4cf-996ce9e22ff4	2026-01-31 21:37:59.926035+00	2026-01-31 21:37:59.926035+00	2026-01-31 21:37:59.926035+00	{"eTag": "\\"13047a2ded99d0199fb69c77c5cb5762\\"", "size": 170646, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-31T21:38:00.000Z", "contentLength": 170646, "httpStatusCode": 200}	04ece910-17f0-4cb1-a10c-0eade0a328f3	6eda01a1-1970-4562-b4cf-996ce9e22ff4	{}	2
74545052-2338-4b84-b5c1-5fea7ce620aa	question-images	6eda01a1-1970-4562-b4cf-996ce9e22ff4/1769895676132.png	6eda01a1-1970-4562-b4cf-996ce9e22ff4	2026-01-31 21:41:17.568208+00	2026-01-31 21:41:17.568208+00	2026-01-31 21:41:17.568208+00	{"eTag": "\\"13047a2ded99d0199fb69c77c5cb5762\\"", "size": 170646, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-31T21:41:18.000Z", "contentLength": 170646, "httpStatusCode": 200}	5a8acd71-2cf6-49f7-8586-14e63571e26c	6eda01a1-1970-4562-b4cf-996ce9e22ff4	{}	2
71e4630d-4759-4fe9-bd2b-83d40f9bd66d	question-images	6eda01a1-1970-4562-b4cf-996ce9e22ff4/1769895869132.png	6eda01a1-1970-4562-b4cf-996ce9e22ff4	2026-01-31 21:44:30.454543+00	2026-01-31 21:44:30.454543+00	2026-01-31 21:44:30.454543+00	{"eTag": "\\"13047a2ded99d0199fb69c77c5cb5762\\"", "size": 170646, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-31T21:44:31.000Z", "contentLength": 170646, "httpStatusCode": 200}	13a2ca01-4116-4490-a0cf-59ed33640729	6eda01a1-1970-4562-b4cf-996ce9e22ff4	{}	2
f9f036cf-fdb2-49da-a4ab-45d2d15e705f	question-images	6eda01a1-1970-4562-b4cf-996ce9e22ff4/1769896320048.png	6eda01a1-1970-4562-b4cf-996ce9e22ff4	2026-01-31 21:52:01.321606+00	2026-01-31 21:52:01.321606+00	2026-01-31 21:52:01.321606+00	{"eTag": "\\"13047a2ded99d0199fb69c77c5cb5762\\"", "size": 170646, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-31T21:52:02.000Z", "contentLength": 170646, "httpStatusCode": 200}	68b179e2-0245-4bee-a1fe-bb9eadeebeda	6eda01a1-1970-4562-b4cf-996ce9e22ff4	{}	2
7046ec39-b5f4-47d4-9cf0-6988d83ceac5	question-images	6eda01a1-1970-4562-b4cf-996ce9e22ff4/1769896516755.png	6eda01a1-1970-4562-b4cf-996ce9e22ff4	2026-01-31 21:55:17.921712+00	2026-01-31 21:55:17.921712+00	2026-01-31 21:55:17.921712+00	{"eTag": "\\"13047a2ded99d0199fb69c77c5cb5762\\"", "size": 170646, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-31T21:55:18.000Z", "contentLength": 170646, "httpStatusCode": 200}	0c78c4e5-d0f4-4bf0-9c77-7e2e026c6710	6eda01a1-1970-4562-b4cf-996ce9e22ff4	{}	2
8952587c-3090-4072-bdf2-4ca1275274ba	question-images	6eda01a1-1970-4562-b4cf-996ce9e22ff4/1769897529519.png	6eda01a1-1970-4562-b4cf-996ce9e22ff4	2026-01-31 22:12:10.972002+00	2026-01-31 22:12:10.972002+00	2026-01-31 22:12:10.972002+00	{"eTag": "\\"13047a2ded99d0199fb69c77c5cb5762\\"", "size": 170646, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-31T22:12:11.000Z", "contentLength": 170646, "httpStatusCode": 200}	7a05008a-b234-4515-9a01-b50dcfab5623	6eda01a1-1970-4562-b4cf-996ce9e22ff4	{}	2
ca0bb5fa-8307-4b80-be0a-a697f53783da	question-images	6eda01a1-1970-4562-b4cf-996ce9e22ff4/1769897847515.png	6eda01a1-1970-4562-b4cf-996ce9e22ff4	2026-01-31 22:17:29.003768+00	2026-01-31 22:17:29.003768+00	2026-01-31 22:17:29.003768+00	{"eTag": "\\"13047a2ded99d0199fb69c77c5cb5762\\"", "size": 170646, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-31T22:17:29.000Z", "contentLength": 170646, "httpStatusCode": 200}	35d40d7e-d7d6-45f7-935a-f344794c745a	6eda01a1-1970-4562-b4cf-996ce9e22ff4	{}	2
e63c1690-5b26-4fa2-8c2d-cee6eff714fe	question-images	6eda01a1-1970-4562-b4cf-996ce9e22ff4/1769899129290.png	6eda01a1-1970-4562-b4cf-996ce9e22ff4	2026-01-31 22:38:50.855186+00	2026-01-31 22:38:50.855186+00	2026-01-31 22:38:50.855186+00	{"eTag": "\\"422bbc9efb730b20350226a776d73094\\"", "size": 321184, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-31T22:38:51.000Z", "contentLength": 321184, "httpStatusCode": 200}	d136df0f-ef1e-483f-bd1b-cd9aa8da8473	6eda01a1-1970-4562-b4cf-996ce9e22ff4	{}	2
45195890-b999-4821-a29a-e43b1633f055	question-images	6eda01a1-1970-4562-b4cf-996ce9e22ff4/1769899268845.png	6eda01a1-1970-4562-b4cf-996ce9e22ff4	2026-01-31 22:41:10.527125+00	2026-01-31 22:41:10.527125+00	2026-01-31 22:41:10.527125+00	{"eTag": "\\"2f308f7ba481ce50deb19be94e18fd81\\"", "size": 268130, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-31T22:41:11.000Z", "contentLength": 268130, "httpStatusCode": 200}	f16ef639-72be-4210-aa2b-3bac198e2591	6eda01a1-1970-4562-b4cf-996ce9e22ff4	{}	2
a2f9270a-a8c5-4f60-bcab-f3b262ad8013	question-images	6eda01a1-1970-4562-b4cf-996ce9e22ff4/1769899307114.png	6eda01a1-1970-4562-b4cf-996ce9e22ff4	2026-01-31 22:41:47.782258+00	2026-01-31 22:41:47.782258+00	2026-01-31 22:41:47.782258+00	{"eTag": "\\"2f308f7ba481ce50deb19be94e18fd81\\"", "size": 268130, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-31T22:41:48.000Z", "contentLength": 268130, "httpStatusCode": 200}	20287d3a-1551-4b12-a275-c7dc66e28784	6eda01a1-1970-4562-b4cf-996ce9e22ff4	{}	2
b3450406-19d5-4274-9985-7d7f14285a97	question-images	f3f4fc66-4e15-451a-9eec-ace39efd5804/1769928602546.png	f3f4fc66-4e15-451a-9eec-ace39efd5804	2026-02-01 06:50:03.295978+00	2026-02-01 06:50:03.295978+00	2026-02-01 06:50:03.295978+00	{"eTag": "\\"13047a2ded99d0199fb69c77c5cb5762\\"", "size": 170646, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-02-01T06:50:04.000Z", "contentLength": 170646, "httpStatusCode": 200}	cbb7c03e-06fc-408d-a9a2-fe280f5f5f83	f3f4fc66-4e15-451a-9eec-ace39efd5804	{}	2
dea20ef6-d740-41d8-be93-34bc989bc896	question-images	6b787def-4b61-42ff-814b-ebb92a3036d1/1769951541260.png	6b787def-4b61-42ff-814b-ebb92a3036d1	2026-02-01 13:12:21.948354+00	2026-02-01 13:12:21.948354+00	2026-02-01 13:12:21.948354+00	{"eTag": "\\"2f308f7ba481ce50deb19be94e18fd81\\"", "size": 268130, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-02-01T13:12:22.000Z", "contentLength": 268130, "httpStatusCode": 200}	855d611b-5db4-4192-bb74-a8ceee1fe8a0	6b787def-4b61-42ff-814b-ebb92a3036d1	{}	2
b1172a41-3b66-46c8-8fb8-f3ff4b3d24b2	question-images	6b787def-4b61-42ff-814b-ebb92a3036d1/1769952695419.png	6b787def-4b61-42ff-814b-ebb92a3036d1	2026-02-01 13:31:36.023+00	2026-02-01 13:31:36.023+00	2026-02-01 13:31:36.023+00	{"eTag": "\\"2f308f7ba481ce50deb19be94e18fd81\\"", "size": 268130, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-02-01T13:31:36.000Z", "contentLength": 268130, "httpStatusCode": 200}	cbdb2e3e-2527-4349-8438-da501b5448b8	6b787def-4b61-42ff-814b-ebb92a3036d1	{}	2
4e65b092-fbff-4c86-9b0e-5b83d5641ed2	question-images	6eda01a1-1970-4562-b4cf-996ce9e22ff4/1770025270607.png	6eda01a1-1970-4562-b4cf-996ce9e22ff4	2026-02-02 09:41:11.310451+00	2026-02-02 09:41:11.310451+00	2026-02-02 09:41:11.310451+00	{"eTag": "\\"956b086848c16d7e5a36bc37bfb70d9f\\"", "size": 119855, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-02-02T09:41:12.000Z", "contentLength": 119855, "httpStatusCode": 200}	c4772f09-1e72-46d6-8ddb-5b20d10d12d4	6eda01a1-1970-4562-b4cf-996ce9e22ff4	{}	2
\.


--
-- Data for Name: prefixes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.prefixes (bucket_id, name, created_at, updated_at) FROM stdin;
question-images	f3f4fc66-4e15-451a-9eec-ace39efd5804	2026-01-31 09:40:04.789816+00	2026-01-31 09:40:04.789816+00
question-images	6eda01a1-1970-4562-b4cf-996ce9e22ff4	2026-01-31 11:51:41.371624+00	2026-01-31 11:51:41.371624+00
question-images	6b787def-4b61-42ff-814b-ebb92a3036d1	2026-02-01 13:12:21.948354+00	2026-02-01 13:12:21.948354+00
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: supabase_migrations; Owner: postgres
--

COPY supabase_migrations.schema_migrations (version, statements, name, created_by, idempotency_key, rollback) FROM stdin;
20260130180208	{"-- Migration: Initialize Required Extensions\n-- Description: Install pgvector and other required extensions\n-- Created: 2026-01-30\n\n-- Enable pgvector extension for embedding similarity search\nCREATE EXTENSION IF NOT EXISTS vector;\n\n-- Enable moddatetime for automatic updated_at tracking\nCREATE EXTENSION IF NOT EXISTS moddatetime;\n\n-- Enable uuid-ossp for UUID generation (if not already enabled by Supabase)\nCREATE EXTENSION IF NOT EXISTS \\"uuid-ossp\\";\n\nCOMMENT ON EXTENSION vector IS 'Vector similarity search for question matching';\nCOMMENT ON EXTENSION moddatetime IS 'Automatic updated_at timestamp management';"}	init_extensions	utkarshweb2023@gmail.com	\N	\N
20260130180228	{"-- Migration: Create ENUM Types\n-- Description: Define all enumerated types for the application\n-- Created: 2026-01-30\n\n-- Question types: MCQ, Very Short Answer, Short Answer, Long Answer, Case Study\nCREATE TYPE question_type_enum AS ENUM (\n    'MCQ',\n    'VSA',\n    'SA',\n    'LA',\n    'CASE_STUDY'\n);\n\n-- Difficulty levels\nCREATE TYPE difficulty_enum AS ENUM (\n    'easy',\n    'medium',\n    'hard',\n    'very_hard'\n);\n\n-- Activity types for user activity feed\nCREATE TYPE activity_type_enum AS ENUM (\n    'question_created',\n    'solution_contributed',\n    'question_solved',\n    'question_forked',\n    'hint_updated',\n    'question_deleted',\n    'solution_deleted'\n);\n\n-- Target types for activities\nCREATE TYPE target_type_enum AS ENUM (\n    'question',\n    'solution'\n);\n\nCOMMENT ON TYPE question_type_enum IS 'Types of questions supported';\nCOMMENT ON TYPE difficulty_enum IS 'Difficulty levels for questions';\nCOMMENT ON TYPE activity_type_enum IS 'Types of user activities tracked';\nCOMMENT ON TYPE target_type_enum IS 'Target entity types for activities';"}	create_enums	utkarshweb2023@gmail.com	\N	\N
20260130180354	{"-- Migration: Create Core Tables\n-- Description: Create all application tables with constraints\n-- Created: 2026-01-30\n\n-- ============================================\n-- 1. USER PROFILES\n-- Extended user data linked to auth.users\n-- ============================================\nCREATE TABLE user_profiles (\n    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,\n    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,\n    display_name TEXT,\n    username TEXT UNIQUE,\n    avatar_url TEXT,\n    subjects TEXT[], -- Array of subjects user studies\n    streak_count INTEGER DEFAULT 0,\n    last_streak_date DATE,\n    total_solved INTEGER DEFAULT 0,\n    total_uploaded INTEGER DEFAULT 0,\n    solutions_helped_count INTEGER DEFAULT 0,\n    created_at TIMESTAMPTZ DEFAULT NOW(),\n    updated_at TIMESTAMPTZ DEFAULT NOW(),\n    \n    CONSTRAINT unique_user_id UNIQUE (user_id),\n    CONSTRAINT username_format CHECK (username ~* '^[a-z0-9_]+$'),\n    CONSTRAINT username_length CHECK (LENGTH(username) >= 3)\n);\n\nCOMMENT ON TABLE user_profiles IS 'Extended user profile information';\nCOMMENT ON COLUMN user_profiles.user_id IS 'Reference to auth.users';\nCOMMENT ON COLUMN user_profiles.username IS 'Unique public handle (lowercase, numbers, underscores)';\nCOMMENT ON COLUMN user_profiles.subjects IS 'Array of subjects the user is studying';\n\n-- ============================================\n-- 2. QUESTIONS\n-- Core question data with soft delete support\n-- ============================================\nCREATE TABLE questions (\n    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,\n    owner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,\n    extracted_text TEXT, -- Raw OCR/extracted text before formatting\n    question_text TEXT NOT NULL, -- LaTeX formatted question\n    options JSONB DEFAULT '[]'::JSONB, -- MCQ options with LaTeX\n    type question_type_enum DEFAULT 'MCQ',\n    has_diagram BOOLEAN DEFAULT FALSE,\n    image_url TEXT, -- Supabase Storage URL\n    subject TEXT,\n    chapter TEXT,\n    topics JSONB DEFAULT '[]'::JSONB, -- Array of topic strings\n    difficulty difficulty_enum DEFAULT 'medium',\n    importance INTEGER DEFAULT 3 CHECK (importance >= 1 AND importance <= 5),\n    hint TEXT, -- AI-generated hint\n    embedding VECTOR(768), -- Gemini embedding for similarity search\n    popularity INTEGER DEFAULT 1, -- Count of users who have this question\n    deleted_at TIMESTAMPTZ, -- Soft delete timestamp\n    created_at TIMESTAMPTZ DEFAULT NOW(),\n    updated_at TIMESTAMPTZ DEFAULT NOW()\n);\n\nCOMMENT ON TABLE questions IS 'Core question bank with soft delete';\nCOMMENT ON COLUMN questions.extracted_text IS 'Raw text extracted from image';\nCOMMENT ON COLUMN questions.question_text IS 'Formatted question with LaTeX';\nCOMMENT ON COLUMN questions.embedding IS 'Gemini embedding (768 dims) for similarity';\nCOMMENT ON COLUMN questions.popularity IS 'Number of users linked to this question';\nCOMMENT ON COLUMN questions.deleted_at IS 'Soft delete - NULL means active';\n\n-- ============================================\n-- 3. SOLUTIONS\n-- Multiple solutions per question\n-- ============================================\nCREATE TABLE solutions (\n    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,\n    question_id TEXT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,\n    contributor_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,\n    solution_text TEXT NOT NULL, -- LaTeX formatted solution\n    numerical_answer TEXT, -- For numerical questions\n    approach_description TEXT, -- Brief description of approach\n    correct_option INTEGER, -- 0-indexed correct option for MCQ\n    avg_solve_time INTEGER DEFAULT 0, -- Estimated time in seconds\n    likes INTEGER DEFAULT 0,\n    is_ai_best BOOLEAN DEFAULT FALSE, -- AI's initial pick as best solution\n    created_at TIMESTAMPTZ DEFAULT NOW(),\n    updated_at TIMESTAMPTZ DEFAULT NOW()\n);\n\nCOMMENT ON TABLE solutions IS 'Multiple solutions per question';\nCOMMENT ON COLUMN solutions.correct_option IS '0-indexed correct option for MCQ (0=A, 1=B, etc.)';\nCOMMENT ON COLUMN solutions.avg_solve_time IS 'Estimated solve time in seconds';\nCOMMENT ON COLUMN solutions.is_ai_best IS 'Flag for AI-selected best solution';\n\n-- ============================================\n-- 4. USER_QUESTIONS\n-- Links users to questions (ownership/forking)\n-- ============================================\nCREATE TABLE user_questions (\n    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,\n    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,\n    question_id TEXT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,\n    is_owner BOOLEAN DEFAULT FALSE,\n    is_contributor BOOLEAN DEFAULT FALSE, -- User added a solution\n    added_at TIMESTAMPTZ DEFAULT NOW(),\n    \n    CONSTRAINT unique_user_question UNIQUE (user_id, question_id)\n);\n\nCOMMENT ON TABLE user_questions IS 'Links users to questions they own or have forked';\nCOMMENT ON COLUMN user_questions.is_owner IS 'True if user created this question';\nCOMMENT ON COLUMN user_questions.is_contributor IS 'True if user added a solution';\n\n-- ============================================\n-- 5. USER_QUESTION_STATS\n-- Per-user solving statistics\n-- ============================================\nCREATE TABLE user_question_stats (\n    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,\n    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,\n    question_id TEXT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,\n    solved BOOLEAN DEFAULT FALSE,\n    failed BOOLEAN DEFAULT FALSE,\n    struggled BOOLEAN DEFAULT FALSE,\n    attempts INTEGER DEFAULT 0,\n    time_spent INTEGER DEFAULT 0, -- Total time in seconds\n    user_difficulty INTEGER CHECK (user_difficulty >= 1 AND user_difficulty <= 5),\n    last_practiced_at TIMESTAMPTZ,\n    next_review_at TIMESTAMPTZ, -- For spaced repetition\n    in_revise_later BOOLEAN DEFAULT FALSE,\n    created_at TIMESTAMPTZ DEFAULT NOW(),\n    updated_at TIMESTAMPTZ DEFAULT NOW(),\n    \n    CONSTRAINT unique_user_question_stats UNIQUE (user_id, question_id)\n);\n\nCOMMENT ON TABLE user_question_stats IS 'Per-user statistics for each question';\nCOMMENT ON COLUMN user_question_stats.struggled IS 'True if time exceeded threshold or marked failed';\nCOMMENT ON COLUMN user_question_stats.next_review_at IS 'Next spaced repetition review date';\n\n-- ============================================\n-- 6. SOLUTION_LIKES\n-- User likes on solutions\n-- ============================================\nCREATE TABLE solution_likes (\n    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,\n    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,\n    solution_id TEXT NOT NULL REFERENCES solutions(id) ON DELETE CASCADE,\n    created_at TIMESTAMPTZ DEFAULT NOW(),\n    \n    CONSTRAINT unique_user_solution_like UNIQUE (user_id, solution_id)\n);\n\nCOMMENT ON TABLE solution_likes IS 'Tracks which users liked which solutions';\n\n-- ============================================\n-- 7. REVISE_LATER\n-- User's revise later list\n-- ============================================\nCREATE TABLE revise_later (\n    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,\n    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,\n    question_id TEXT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,\n    added_at TIMESTAMPTZ DEFAULT NOW(),\n    \n    CONSTRAINT unique_user_revise_later UNIQUE (user_id, question_id)\n);\n\nCOMMENT ON TABLE revise_later IS 'Questions user wants to revise later';\n\n-- ============================================\n-- 8. USER_ACTIVITIES\n-- Activity feed log\n-- ============================================\nCREATE TABLE user_activities (\n    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,\n    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,\n    activity_type activity_type_enum NOT NULL,\n    target_id TEXT, -- question_id or solution_id\n    target_type target_type_enum,\n    metadata JSONB DEFAULT '{}'::JSONB, -- Additional context (subject, chapter, snippet)\n    created_at TIMESTAMPTZ DEFAULT NOW()\n);\n\nCOMMENT ON TABLE user_activities IS 'Activity feed for user profiles';\nCOMMENT ON COLUMN user_activities.metadata IS 'JSON with subject, chapter, snippet, etc.';\n\n-- ============================================\n-- 9. SYLLABUS\n-- Preset Class 11/12 syllabus\n-- ============================================\nCREATE TABLE syllabus (\n    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,\n    class TEXT, -- '11', '12', or NULL for universal\n    subject TEXT NOT NULL,\n    chapter TEXT NOT NULL,\n    topics JSONB DEFAULT '[]'::JSONB,\n    priority INTEGER DEFAULT 3 CHECK (priority >= 1 AND priority <= 5),\n    is_verified BOOLEAN DEFAULT TRUE, -- FALSE for AI-added pending review\n    created_at TIMESTAMPTZ DEFAULT NOW()\n);\n\nCOMMENT ON TABLE syllabus IS 'Preset syllabus with AI extension support';\nCOMMENT ON COLUMN syllabus.priority IS 'Importance level for exam weightage (1-5)';\nCOMMENT ON COLUMN syllabus.is_verified IS 'FALSE if AI added and pending human review';"}	create_tables	utkarshweb2023@gmail.com	\N	\N
20260130180436	{"-- Migration: Create Indexes\n-- Description: Performance indexes for frequently queried columns\n-- Created: 2026-01-30\n\n-- ============================================\n-- USER_PROFILES indexes\n-- ============================================\nCREATE INDEX idx_user_profiles_username ON user_profiles(username);\nCREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);\n\n-- ============================================\n-- QUESTIONS indexes\n-- ============================================\nCREATE INDEX idx_questions_owner_id ON questions(owner_id);\nCREATE INDEX idx_questions_subject ON questions(subject);\nCREATE INDEX idx_questions_chapter ON questions(chapter);\nCREATE INDEX idx_questions_subject_chapter ON questions(subject, chapter);\nCREATE INDEX idx_questions_type ON questions(type);\nCREATE INDEX idx_questions_difficulty ON questions(difficulty);\nCREATE INDEX idx_questions_deleted_at ON questions(deleted_at) WHERE deleted_at IS NULL;\nCREATE INDEX idx_questions_popularity ON questions(popularity DESC);\n\n-- HNSW index for vector similarity search (faster than IVFFlat for high-dimensional)\nCREATE INDEX idx_questions_embedding ON questions \n    USING hnsw (embedding vector_cosine_ops)\n    WITH (m = 16, ef_construction = 64);\n\nCOMMENT ON INDEX idx_questions_embedding IS 'HNSW index for cosine similarity search on embeddings';\n\n-- ============================================\n-- SOLUTIONS indexes\n-- ============================================\nCREATE INDEX idx_solutions_question_id ON solutions(question_id);\nCREATE INDEX idx_solutions_contributor_id ON solutions(contributor_id);\nCREATE INDEX idx_solutions_likes ON solutions(likes DESC);\nCREATE INDEX idx_solutions_is_ai_best ON solutions(is_ai_best) WHERE is_ai_best = TRUE;\n\n-- ============================================\n-- USER_QUESTIONS indexes\n-- ============================================\nCREATE INDEX idx_user_questions_user_id ON user_questions(user_id);\nCREATE INDEX idx_user_questions_question_id ON user_questions(question_id);\nCREATE INDEX idx_user_questions_is_owner ON user_questions(user_id, is_owner) WHERE is_owner = TRUE;\n\n-- ============================================\n-- USER_QUESTION_STATS indexes\n-- ============================================\nCREATE INDEX idx_user_question_stats_user_id ON user_question_stats(user_id);\nCREATE INDEX idx_user_question_stats_question_id ON user_question_stats(question_id);\nCREATE INDEX idx_user_question_stats_solved ON user_question_stats(user_id, solved) WHERE solved = TRUE;\nCREATE INDEX idx_user_question_stats_failed ON user_question_stats(user_id, failed) WHERE failed = TRUE;\nCREATE INDEX idx_user_question_stats_revise_later ON user_question_stats(user_id, in_revise_later) WHERE in_revise_later = TRUE;\nCREATE INDEX idx_user_question_stats_next_review ON user_question_stats(user_id, next_review_at) WHERE next_review_at IS NOT NULL;\n\n-- ============================================\n-- SOLUTION_LIKES indexes\n-- ============================================\nCREATE INDEX idx_solution_likes_solution_id ON solution_likes(solution_id);\nCREATE INDEX idx_solution_likes_user_id ON solution_likes(user_id);\n\n-- ============================================\n-- REVISE_LATER indexes\n-- ============================================\nCREATE INDEX idx_revise_later_user_id ON revise_later(user_id);\nCREATE INDEX idx_revise_later_question_id ON revise_later(question_id);\n\n-- ============================================\n-- USER_ACTIVITIES indexes\n-- ============================================\nCREATE INDEX idx_user_activities_user_id ON user_activities(user_id);\nCREATE INDEX idx_user_activities_created_at ON user_activities(created_at DESC);\nCREATE INDEX idx_user_activities_user_created ON user_activities(user_id, created_at DESC);\n\n-- ============================================\n-- SYLLABUS indexes\n-- ============================================\nCREATE INDEX idx_syllabus_subject ON syllabus(subject);\nCREATE INDEX idx_syllabus_class ON syllabus(class);\nCREATE INDEX idx_syllabus_subject_chapter ON syllabus(subject, chapter);\nCREATE INDEX idx_syllabus_verified ON syllabus(is_verified) WHERE is_verified = TRUE;"}	create_indexes	utkarshweb2023@gmail.com	\N	\N
20260130180523	{"-- Migration: Create RPC Functions\n-- Description: Database functions for complex operations\n-- Created: 2026-01-30\n\n-- ============================================\n-- 1. MATCH_QUESTIONS_WITH_SOLUTIONS\n-- Vector similarity search for duplicate detection\n-- Returns questions with similarity score and their solutions\n-- ============================================\nCREATE OR REPLACE FUNCTION match_questions_with_solutions(\n    query_embedding VECTOR(768),\n    match_threshold FLOAT,\n    match_count INT\n)\nRETURNS TABLE (\n    id TEXT,\n    owner_id UUID,\n    question_text TEXT,\n    matched_solution_text TEXT,\n    similarity FLOAT\n)\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nBEGIN\n    RETURN QUERY\n    SELECT \n        q.id,\n        q.owner_id,\n        q.question_text,\n        s.solution_text AS matched_solution_text,\n        1 - (q.embedding <=> query_embedding) AS similarity\n    FROM questions q\n    LEFT JOIN solutions s ON s.question_id = q.id AND s.is_ai_best = TRUE\n    WHERE \n        q.deleted_at IS NULL\n        AND q.embedding IS NOT NULL\n        AND 1 - (q.embedding <=> query_embedding) > match_threshold\n    ORDER BY q.embedding <=> query_embedding\n    LIMIT match_count;\nEND;\n$$;\n\nCOMMENT ON FUNCTION match_questions_with_solutions IS 'Find similar questions using vector cosine similarity';\n\n-- ============================================\n-- 2. TOGGLE_SOLUTION_LIKE\n-- Atomically toggle like/unlike and update count\n-- ============================================\nCREATE OR REPLACE FUNCTION toggle_solution_like(\n    sol_id TEXT\n)\nRETURNS JSONB\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nDECLARE\n    v_user_id UUID;\n    v_like_exists BOOLEAN;\n    v_likes_count INTEGER;\nBEGIN\n    -- Get current user ID\n    v_user_id := auth.uid();\n    \n    IF v_user_id IS NULL THEN\n        RETURN jsonb_build_object('success', false, 'error', 'Not authenticated');\n    END IF;\n    \n    -- Check if like already exists\n    SELECT EXISTS(\n        SELECT 1 FROM solution_likes \n        WHERE user_id = v_user_id AND solution_id = sol_id\n    ) INTO v_like_exists;\n    \n    IF v_like_exists THEN\n        -- Unlike: Remove the like\n        DELETE FROM solution_likes \n        WHERE user_id = v_user_id AND solution_id = sol_id;\n        \n        -- Decrement likes count\n        UPDATE solutions \n        SET likes = GREATEST(0, likes - 1)\n        WHERE id = sol_id;\n        \n        SELECT likes INTO v_likes_count FROM solutions WHERE id = sol_id;\n        RETURN jsonb_build_object('success', true, 'liked', false, 'likes', v_likes_count);\n    ELSE\n        -- Like: Add new like\n        INSERT INTO solution_likes (user_id, solution_id)\n        VALUES (v_user_id, sol_id);\n        \n        -- Increment likes count\n        UPDATE solutions \n        SET likes = likes + 1\n        WHERE id = sol_id;\n        \n        SELECT likes INTO v_likes_count FROM solutions WHERE id = sol_id;\n        RETURN jsonb_build_object('success', true, 'liked', true, 'likes', v_likes_count);\n    END IF;\nEND;\n$$;\n\nCOMMENT ON FUNCTION toggle_solution_like IS 'Toggle like/unlike on a solution atomically';\n\n-- ============================================\n-- 3. GET_OTHER_USERS_COUNT\n-- Count how many other users are linked to a question\n-- SECURITY DEFINER to bypass RLS for counting\n-- ============================================\nCREATE OR REPLACE FUNCTION get_other_users_count(\n    q_id TEXT\n)\nRETURNS INTEGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nDECLARE\n    v_current_user UUID;\n    v_count INTEGER;\nBEGIN\n    v_current_user := auth.uid();\n    \n    SELECT COUNT(*)::INTEGER INTO v_count\n    FROM user_questions\n    WHERE question_id = q_id\n    AND user_id != v_current_user;\n    \n    RETURN v_count;\nEND;\n$$;\n\nCOMMENT ON FUNCTION get_other_users_count IS 'Count other users linked to a question (excludes current user)';\n\n-- ============================================\n-- 4. INCREMENT_SOLUTIONS_COUNT\n-- Increment solution count for a question\n-- ============================================\nCREATE OR REPLACE FUNCTION increment_solutions_count(\n    question_id TEXT\n)\nRETURNS VOID\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nBEGIN\n    -- This is a placeholder - the actual solution count comes from COUNT in queries\n    -- But we keep this for compatibility with existing code\n    RETURN;\nEND;\n$$;\n\nCOMMENT ON FUNCTION increment_solutions_count IS 'Placeholder for backward compatibility';\n\n-- ============================================\n-- 5. AUTO-UPDATE UPDATED_AT TRIGGER FUNCTION\n-- ============================================\nCREATE OR REPLACE FUNCTION update_updated_at_column()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nAS $$\nBEGIN\n    NEW.updated_at = NOW();\n    RETURN NEW;\nEND;\n$$;\n\nCOMMENT ON FUNCTION update_updated_at_column IS 'Trigger function to auto-update updated_at timestamp';"}	create_functions	utkarshweb2023@gmail.com	\N	\N
20260130180616	{"-- Migration: Create Triggers\n-- Description: Automatic triggers for updated_at and computed fields\n-- Created: 2026-01-30\n\n-- ============================================\n-- 1. AUTO-UPDATE UPDATED_AT TRIGGERS\n-- ============================================\n\n-- user_profiles\nCREATE TRIGGER update_user_profiles_updated_at\n    BEFORE UPDATE ON user_profiles\n    FOR EACH ROW\n    EXECUTE FUNCTION update_updated_at_column();\n\n-- questions\nCREATE TRIGGER update_questions_updated_at\n    BEFORE UPDATE ON questions\n    FOR EACH ROW\n    EXECUTE FUNCTION update_updated_at_column();\n\n-- solutions\nCREATE TRIGGER update_solutions_updated_at\n    BEFORE UPDATE ON solutions\n    FOR EACH ROW\n    EXECUTE FUNCTION update_updated_at_column();\n\n-- user_question_stats\nCREATE TRIGGER update_user_question_stats_updated_at\n    BEFORE UPDATE ON user_question_stats\n    FOR EACH ROW\n    EXECUTE FUNCTION update_updated_at_column();\n\n-- ============================================\n-- 2. AUTO-INCREMENT QUESTION POPULARITY\n-- When a user links to a question, increment popularity\n-- ============================================\nCREATE OR REPLACE FUNCTION increment_question_popularity()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nBEGIN\n    UPDATE questions \n    SET popularity = popularity + 1\n    WHERE id = NEW.question_id;\n    RETURN NEW;\nEND;\n$$;\n\nCREATE TRIGGER trg_increment_popularity_on_link\n    AFTER INSERT ON user_questions\n    FOR EACH ROW\n    EXECUTE FUNCTION increment_question_popularity();\n\nCOMMENT ON FUNCTION increment_question_popularity IS 'Increment question popularity when a new user links to it';\n\n-- ============================================\n-- 3. AUTO-DECREMENT QUESTION POPULARITY\n-- When a user unlinks from a question, decrement popularity\n-- ============================================\nCREATE OR REPLACE FUNCTION decrement_question_popularity()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nBEGIN\n    UPDATE questions \n    SET popularity = GREATEST(0, popularity - 1)\n    WHERE id = OLD.question_id;\n    RETURN OLD;\nEND;\n$$;\n\nCREATE TRIGGER trg_decrement_popularity_on_unlink\n    AFTER DELETE ON user_questions\n    FOR EACH ROW\n    EXECUTE FUNCTION decrement_question_popularity();\n\nCOMMENT ON FUNCTION decrement_question_popularity IS 'Decrement question popularity when a user unlinks';\n\n-- ============================================\n-- 4. AUTO-LOG ACTIVITY ON QUESTION CREATE\n-- ============================================\nCREATE OR REPLACE FUNCTION log_question_created_activity()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nBEGIN\n    INSERT INTO user_activities (user_id, activity_type, target_id, target_type, metadata)\n    VALUES (\n        NEW.user_id,\n        'question_created',\n        NEW.question_id,\n        'question',\n        jsonb_build_object(\n            'is_owner', NEW.is_owner\n        )\n    );\n    RETURN NEW;\nEND;\n$$;\n\nCREATE TRIGGER trg_log_activity_on_question_link\n    AFTER INSERT ON user_questions\n    FOR EACH ROW\n    WHEN (NEW.is_owner = TRUE)\n    EXECUTE FUNCTION log_question_created_activity();\n\nCOMMENT ON FUNCTION log_question_created_activity IS 'Log activity when user creates a question';\n\n-- ============================================\n-- 5. AUTO-LOG ACTIVITY ON SOLUTION CREATE\n-- ============================================\nCREATE OR REPLACE FUNCTION log_solution_contributed_activity()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nBEGIN\n    INSERT INTO user_activities (user_id, activity_type, target_id, target_type, metadata)\n    VALUES (\n        NEW.contributor_id,\n        'solution_contributed',\n        NEW.id,\n        'solution',\n        jsonb_build_object(\n            'question_id', NEW.question_id,\n            'approach_description', NEW.approach_description\n        )\n    );\n    RETURN NEW;\nEND;\n$$;\n\nCREATE TRIGGER trg_log_activity_on_solution_create\n    AFTER INSERT ON solutions\n    FOR EACH ROW\n    EXECUTE FUNCTION log_solution_contributed_activity();\n\nCOMMENT ON FUNCTION log_solution_contributed_activity IS 'Log activity when user contributes a solution';\n\n-- ============================================\n-- 6. SYNC REVISE_LATER WITH USER_QUESTION_STATS\n-- When added to revise_later, update the stats table\n-- ============================================\nCREATE OR REPLACE FUNCTION sync_revise_later_to_stats()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nBEGIN\n    INSERT INTO user_question_stats (user_id, question_id, in_revise_later)\n    VALUES (NEW.user_id, NEW.question_id, TRUE)\n    ON CONFLICT (user_id, question_id)\n    DO UPDATE SET in_revise_later = TRUE, updated_at = NOW();\n    RETURN NEW;\nEND;\n$$;\n\nCREATE TRIGGER trg_sync_revise_later_insert\n    AFTER INSERT ON revise_later\n    FOR EACH ROW\n    EXECUTE FUNCTION sync_revise_later_to_stats();\n\nCOMMENT ON FUNCTION sync_revise_later_to_stats IS 'Sync revise_later insert to user_question_stats';\n\n-- ============================================\n-- 7. SYNC REVISE_LATER DELETE WITH USER_QUESTION_STATS\n-- ============================================\nCREATE OR REPLACE FUNCTION sync_revise_later_delete_to_stats()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nBEGIN\n    UPDATE user_question_stats\n    SET in_revise_later = FALSE, updated_at = NOW()\n    WHERE user_id = OLD.user_id AND question_id = OLD.question_id;\n    RETURN OLD;\nEND;\n$$;\n\nCREATE TRIGGER trg_sync_revise_later_delete\n    AFTER DELETE ON revise_later\n    FOR EACH ROW\n    EXECUTE FUNCTION sync_revise_later_delete_to_stats();\n\nCOMMENT ON FUNCTION sync_revise_later_delete_to_stats IS 'Sync revise_later delete to user_question_stats';"}	create_triggers	utkarshweb2023@gmail.com	\N	\N
20260130180701	{"-- Migration: Enable Row Level Security\n-- Description: Enable RLS on all tables and create policies\n-- Created: 2026-01-30\n\n-- ============================================\n-- 1. USER_PROFILES\n-- Public readable, users manage own\n-- ============================================\nALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;\n\n-- Everyone can view profiles (needed for public profile pages)\nCREATE POLICY \\"Profiles are viewable by everyone\\" \n    ON user_profiles FOR SELECT \n    USING (true);\n\n-- Users can insert their own profile\nCREATE POLICY \\"Users can insert their own profile\\" \n    ON user_profiles FOR INSERT \n    WITH CHECK (auth.uid() = user_id);\n\n-- Users can update their own profile\nCREATE POLICY \\"Users can update their own profile\\" \n    ON user_profiles FOR UPDATE \n    USING (auth.uid() = user_id);\n\n-- ============================================\n-- 2. QUESTIONS\n-- Public readable, owners manage\n-- ============================================\nALTER TABLE questions ENABLE ROW LEVEL SECURITY;\n\n-- Everyone can view non-deleted questions\nCREATE POLICY \\"Questions are viewable by everyone\\" \n    ON questions FOR SELECT \n    USING (deleted_at IS NULL);\n\n-- Authenticated users can insert (ownership set via trigger/app)\nCREATE POLICY \\"Authenticated users can insert questions\\" \n    ON questions FOR INSERT \n    WITH CHECK (auth.uid() = owner_id);\n\n-- Owners can update their questions\nCREATE POLICY \\"Owners can update their questions\\" \n    ON questions FOR UPDATE \n    USING (auth.uid() = owner_id AND deleted_at IS NULL);\n\n-- Owners can soft delete their questions\nCREATE POLICY \\"Owners can delete their questions\\" \n    ON questions FOR DELETE \n    USING (auth.uid() = owner_id);\n\n-- ============================================\n-- 3. SOLUTIONS\n-- Public readable, contributors manage\n-- ============================================\nALTER TABLE solutions ENABLE ROW LEVEL SECURITY;\n\n-- Everyone can view solutions\nCREATE POLICY \\"Solutions are viewable by everyone\\" \n    ON solutions FOR SELECT \n    USING (true);\n\n-- Users can insert their own solutions\nCREATE POLICY \\"Users can insert their own solutions\\" \n    ON solutions FOR INSERT \n    WITH CHECK (auth.uid() = contributor_id);\n\n-- Contributors can update their solutions\nCREATE POLICY \\"Contributors can update their solutions\\" \n    ON solutions FOR UPDATE \n    USING (auth.uid() = contributor_id);\n\n-- Contributors can delete their solutions\nCREATE POLICY \\"Contributors can delete their solutions\\" \n    ON solutions FOR DELETE \n    USING (auth.uid() = contributor_id);\n\n-- ============================================\n-- 4. USER_QUESTIONS\n-- Users manage their own links only\n-- ============================================\nALTER TABLE user_questions ENABLE ROW LEVEL SECURITY;\n\n-- Users can view their own links\nCREATE POLICY \\"Users can view their own question links\\" \n    ON user_questions FOR SELECT \n    USING (auth.uid() = user_id);\n\n-- Users can insert their own links\nCREATE POLICY \\"Users can insert their own question links\\" \n    ON user_questions FOR INSERT \n    WITH CHECK (auth.uid() = user_id);\n\n-- Users can delete their own links\nCREATE POLICY \\"Users can delete their own question links\\" \n    ON user_questions FOR DELETE \n    USING (auth.uid() = user_id);\n\n-- ============================================\n-- 5. USER_QUESTION_STATS\n-- Users manage their own stats only\n-- ============================================\nALTER TABLE user_question_stats ENABLE ROW LEVEL SECURITY;\n\n-- Users can view their own stats\nCREATE POLICY \\"Users can view their own stats\\" \n    ON user_question_stats FOR SELECT \n    USING (auth.uid() = user_id);\n\n-- Users can insert their own stats\nCREATE POLICY \\"Users can insert their own stats\\" \n    ON user_question_stats FOR INSERT \n    WITH CHECK (auth.uid() = user_id);\n\n-- Users can update their own stats\nCREATE POLICY \\"Users can update their own stats\\" \n    ON user_question_stats FOR UPDATE \n    USING (auth.uid() = user_id);\n\n-- ============================================\n-- 6. SOLUTION_LIKES\n-- Public view, users manage own\n-- ============================================\nALTER TABLE solution_likes ENABLE ROW LEVEL SECURITY;\n\n-- Everyone can view likes\nCREATE POLICY \\"Likes are viewable by everyone\\" \n    ON solution_likes FOR SELECT \n    USING (true);\n\n-- Users can insert their own likes\nCREATE POLICY \\"Users can insert their own likes\\" \n    ON solution_likes FOR INSERT \n    WITH CHECK (auth.uid() = user_id);\n\n-- Users can delete their own likes\nCREATE POLICY \\"Users can delete their own likes\\" \n    ON solution_likes FOR DELETE \n    USING (auth.uid() = user_id);\n\n-- ============================================\n-- 7. REVISE_LATER\n-- Users manage their own list only\n-- ============================================\nALTER TABLE revise_later ENABLE ROW LEVEL SECURITY;\n\n-- Users can view their own revise list\nCREATE POLICY \\"Users can view their own revise list\\" \n    ON revise_later FOR SELECT \n    USING (auth.uid() = user_id);\n\n-- Users can insert into their own revise list\nCREATE POLICY \\"Users can insert into their own revise list\\" \n    ON revise_later FOR INSERT \n    WITH CHECK (auth.uid() = user_id);\n\n-- Users can delete from their own revise list\nCREATE POLICY \\"Users can delete from their own revise list\\" \n    ON revise_later FOR DELETE \n    USING (auth.uid() = user_id);\n\n-- ============================================\n-- 8. USER_ACTIVITIES\n-- Users view own, insert own\n-- ============================================\nALTER TABLE user_activities ENABLE ROW LEVEL SECURITY;\n\n-- Users can view their own activities\nCREATE POLICY \\"Users can view their own activities\\" \n    ON user_activities FOR SELECT \n    USING (auth.uid() = user_id);\n\n-- System can insert activities (via trigger)\nCREATE POLICY \\"System can insert activities\\" \n    ON user_activities FOR INSERT \n    WITH CHECK (auth.uid() = user_id);\n\n-- ============================================\n-- 9. SYLLABUS\n-- Authenticated users can view\n-- ============================================\nALTER TABLE syllabus ENABLE ROW LEVEL SECURITY;\n\n-- Authenticated users can view syllabus\nCREATE POLICY \\"Authenticated users can view syllabus\\" \n    ON syllabus FOR SELECT \n    USING (auth.role() = 'authenticated');\n\n-- Note: Syllabus modifications should be done via admin API or service role"}	enable_rls	utkarshweb2023@gmail.com	\N	\N
20260131050158	{"-- Migration: Seed Syllabus Data\n-- Description: Insert Class 12 CBSE Syllabus for Physics, Chemistry, Mathematics, and Biology\n-- Created: 2026-01-31\n-- Source: syllabus.md (CBSE Class 12 Syllabus 2024-2025)\n\n-- Clear existing Class 12 syllabus\nDELETE FROM syllabus WHERE class = '12';\n\n-- ============================================\n-- PHYSICS\n-- ============================================\n\n-- Unit I: Electrostatics\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Physics', 'Electric Charges and Fields', to_jsonb(ARRAY[\n    'Electric Charges',\n    'Conservation of charge',\n    'Coulomb''s law-force between two point charges',\n    'Forces between multiple charges',\n    'Superposition principle and continuous charge distribution',\n    'Electric field',\n    'Electric field due to a point charge',\n    'Electric field lines',\n    'Electric dipole',\n    'Electric field due to a dipole',\n    'Torque on a dipole in uniform electric field',\n    'Electric flux',\n    'Gauss''s theorem',\n    'Field due to infinitely long straight wire',\n    'Uniformly charged infinite plane sheet',\n    'Uniformly charged thin spherical shell'\n]), 5, true);\n\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Physics', 'Electrostatic Potential and Capacitance', to_jsonb(ARRAY[\n    'Electric potential',\n    'Potential difference',\n    'Electric potential due to a point charge',\n    'Electric potential due to a dipole',\n    'Electric potential due to system of charges',\n    'Equipotential surfaces',\n    'Electrical potential energy of a system',\n    'Conductors and insulators',\n    'Free charges and bound charges inside a conductor',\n    'Dielectrics and electric polarisation',\n    'Capacitors and capacitance',\n    'Combination of capacitors in series and parallel',\n    'Capacitance of parallel plate capacitor',\n    'Energy stored in a capacitor'\n]), 5, true);\n\n-- Unit II: Current Electricity\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Physics', 'Current Electricity', to_jsonb(ARRAY[\n    'Electric current',\n    'Flow of electric charges in metallic conductor',\n    'Drift velocity and mobility',\n    'Relation with electric current',\n    'Ohm''s law',\n    'Electrical resistance',\n    'V-I characteristics',\n    'Electrical energy and power',\n    'Electrical resistivity and conductivity',\n    'Carbon resistors and colour code',\n    'Series and parallel combinations of resistors',\n    'Temperature dependence of resistance',\n    'Internal resistance of a cell',\n    'Potential difference and emf of a cell',\n    'Combination of cells',\n    'Kirchhoff''s laws',\n    'Wheatstone bridge',\n    'Metre bridge',\n    'Potentiometer principle and applications'\n]), 5, true);\n\n-- Unit III: Magnetic Effects of Current and Magnetism\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Physics', 'Moving Charges and Magnetism', to_jsonb(ARRAY[\n    'Concept of magnetic field',\n    'Oersted''s experiment',\n    'Biot-Savart law',\n    'Application to current carrying circular loop',\n    'Ampere''s law',\n    'Applications to straight wire and solenoids',\n    'Force on moving charge in uniform magnetic field',\n    'Force on moving charge in uniform electric field',\n    'Cyclotron',\n    'Force on current-carrying conductor',\n    'Force between parallel current-carrying conductors',\n    'Definition of ampere',\n    'Torque on current loop in uniform magnetic field',\n    'Moving coil galvanometer',\n    'Current sensitivity',\n    'Conversion to ammeter and voltmeter'\n]), 5, true);\n\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Physics', 'Magnetism and Matter', to_jsonb(ARRAY[\n    'Current loop as magnetic dipole',\n    'Magnetic dipole moment',\n    'Magnetic dipole moment of revolving electron',\n    'Magnetic field intensity due to magnetic dipole',\n    'Torque on magnetic dipole in uniform field',\n    'Bar magnet as equivalent solenoid',\n    'Magnetic field lines',\n    'Earth''s magnetic field and magnetic elements',\n    'Para-dia-ferromagnetic substances',\n    'Electromagnets and factors affecting strength',\n    'Permanent magnets'\n]), 4, true);\n\n-- Unit IV: Electromagnetic Induction and Alternating Currents\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Physics', 'Electromagnetic Induction', to_jsonb(ARRAY[\n    'Electromagnetic induction',\n    'Faraday''s laws',\n    'Induced EMF and current',\n    'Lenz''s Law',\n    'Eddy currents',\n    'Self induction',\n    'Mutual induction'\n]), 4, true);\n\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Physics', 'Alternating Current', to_jsonb(ARRAY[\n    'Alternating currents',\n    'Peak and rms value',\n    'Reactance and impedance',\n    'LC oscillations',\n    'LCR series circuit',\n    'Resonance',\n    'Power in AC circuits',\n    'Wattless current',\n    'AC generator',\n    'Transformer'\n]), 4, true);\n\n-- Unit V: Electromagnetic Waves\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Physics', 'Electromagnetic Waves', to_jsonb(ARRAY[\n    'Displacement current',\n    'Electromagnetic waves characteristics',\n    'Transverse nature of EM waves',\n    'Electromagnetic spectrum',\n    'Radio waves',\n    'Microwaves',\n    'Infrared',\n    'Visible light',\n    'Ultraviolet',\n    'X-rays',\n    'Gamma rays',\n    'Uses of EM waves'\n]), 2, true);\n\n-- Unit VI: Optics\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Physics', 'Ray Optics and Optical Instruments', to_jsonb(ARRAY[\n    'Reflection of light',\n    'Spherical mirrors',\n    'Mirror formula',\n    'Refraction of light',\n    'Total internal reflection',\n    'Optical fibres',\n    'Refraction at spherical surfaces',\n    'Lenses',\n    'Thin lens formula',\n    'Lensmaker''s formula',\n    'Magnification',\n    'Power of lens',\n    'Combination of thin lenses',\n    'Refraction and dispersion through prism',\n    'Scattering of light',\n    'Human eye and image formation',\n    'Correction of eye defects',\n    'Microscopes',\n    'Astronomical telescopes',\n    'Magnifying powers'\n]), 5, true);\n\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Physics', 'Wave Optics', to_jsonb(ARRAY[\n    'Wavefront',\n    'Huygens'' principle',\n    'Reflection using wavefronts',\n    'Refraction using wavefronts',\n    'Interference',\n    'Young''s double slit experiment',\n    'Fringe width',\n    'Coherent sources',\n    'Diffraction due to single slit',\n    'Width of central maximum',\n    'Resolving power',\n    'Polarisation',\n    'Plane polarised light',\n    'Brewster''s law',\n    'Uses of plane polarised light',\n    'Polaroids'\n]), 4, true);\n\n-- Unit VII: Dual Nature of Radiation and Matter\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Physics', 'Dual Nature of Radiation and Matter', to_jsonb(ARRAY[\n    'Dual nature of radiation',\n    'Photoelectric effect',\n    'Hertz and Lenard''s observations',\n    'Einstein''s photoelectric equation',\n    'Particle nature of light',\n    'Matter waves',\n    'Wave nature of particles',\n    'de Broglie relation',\n    'Davisson-Germer experiment'\n]), 4, true);\n\n-- Unit VIII: Atoms and Nuclei\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Physics', 'Atoms', to_jsonb(ARRAY[\n    'Alpha-particle scattering experiment',\n    'Rutherford''s model of atom',\n    'Bohr model',\n    'Energy levels',\n    'Hydrogen spectrum'\n]), 4, true);\n\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Physics', 'Nuclei', to_jsonb(ARRAY[\n    'Composition and size of nucleus',\n    'Atomic masses',\n    'Isotopes',\n    'Isobars',\n    'Isotones',\n    'Radioactivity',\n    'Alpha beta and gamma particles',\n    'Radioactive decay law',\n    'Mass-energy relation',\n    'Mass defect',\n    'Binding energy per nucleon',\n    'Nuclear fission',\n    'Nuclear fusion'\n]), 4, true);\n\n-- Unit IX: Electronic Devices\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Physics', 'Semiconductor Electronics', to_jsonb(ARRAY[\n    'Energy bands in solids',\n    'Conductors insulators and semiconductors',\n    'Semiconductor diode',\n    'I-V characteristics',\n    'Diode as rectifier',\n    'LED characteristics',\n    'Photodiode characteristics',\n    'Solar cell characteristics',\n    'Zener diode',\n    'Zener diode as voltage regulator',\n    'Junction transistor',\n    'Transistor action',\n    'Transistor as amplifier',\n    'Transistor as oscillator',\n    'Logic gates',\n    'Transistor as switch'\n]), 4, true);\n\n-- ============================================\n-- CHEMISTRY\n-- ============================================\n\n-- Unit I: Solutions\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Chemistry', 'Solutions', to_jsonb(ARRAY[\n    'Types of solutions',\n    'Expression of concentration',\n    'Solubility of gases in liquids',\n    'Solid solutions',\n    'Colligative properties',\n    'Relative lowering of vapour pressure',\n    'Raoult''s law',\n    'Elevation of boiling point',\n    'Depression of freezing point',\n    'Osmotic pressure',\n    'Determination of molecular masses',\n    'Abnormal molecular mass'\n]), 5, true);\n\n-- Unit II: Electrochemistry\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Chemistry', 'Electrochemistry', to_jsonb(ARRAY[\n    'Redox reactions',\n    'Conductance in electrolytic solutions',\n    'Specific and molar conductivity',\n    'Variations of conductivity with concentration',\n    'Kohlrausch''s Law',\n    'Electrolysis',\n    'Laws of electrolysis',\n    'Dry cell',\n    'Electrolytic cells',\n    'Galvanic cells',\n    'Lead accumulator',\n    'EMF of a cell',\n    'Standard electrode potential',\n    'Nernst equation',\n    'Relation between Gibbs energy and EMF',\n    'Fuel cells',\n    'Corrosion'\n]), 5, true);\n\n-- Unit III: Chemical Kinetics\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Chemistry', 'Chemical Kinetics', to_jsonb(ARRAY[\n    'Rate of reaction',\n    'Average and instantaneous rate',\n    'Factors affecting rates of reaction',\n    'Order and molecularity',\n    'Rate law and specific rate constant',\n    'Integrated rate equations',\n    'Half-life',\n    'Collision theory',\n    'Activation energy',\n    'Arrhenius equation'\n]), 5, true);\n\n-- Unit V: d and f-Block Elements\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Chemistry', 'd and f-Block Elements', to_jsonb(ARRAY[\n    'General introduction',\n    'Electronic configuration',\n    'Occurrence of transition metals',\n    'Characteristics of transition metals',\n    'Metallic character',\n    'Ionization enthalpy',\n    'Oxidation states',\n    'Ionic radii',\n    'Colour',\n    'Catalytic property',\n    'Magnetic properties',\n    'Interstitial compounds',\n    'Alloy formation',\n    'Potassium dichromate',\n    'Potassium permanganate',\n    'Lanthanoids',\n    'Lanthanoid contraction',\n    'Actinoids'\n]), 4, true);\n\n-- Unit VI: Coordination Compounds\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Chemistry', 'Coordination Compounds', to_jsonb(ARRAY[\n    'Introduction',\n    'Ligands',\n    'Coordination number',\n    'Colour',\n    'Magnetic properties',\n    'Shapes',\n    'IUPAC nomenclature',\n    'Werner''s theory',\n    'VBT',\n    'CFT',\n    'Isomerism',\n    'Importance in qualitative analysis',\n    'Extraction of metals',\n    'Biological systems'\n]), 4, true);\n\n-- Unit VII: Haloalkanes and Haloarenes\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Chemistry', 'Haloalkanes and Haloarenes', to_jsonb(ARRAY[\n    'Nomenclature',\n    'Nature of C-X bond',\n    'Physical properties',\n    'Chemical properties',\n    'Mechanism of substitution reactions',\n    'Optical rotation',\n    'Substitution reactions in haloarenes',\n    'Uses and environmental effects',\n    'Dichloromethane',\n    'Trichloromethane',\n    'Tetrachloromethane',\n    'Iodoform',\n    'Freons',\n    'DDT'\n]), 4, true);\n\n-- Unit VIII: Alcohols, Phenols and Ethers\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Chemistry', 'Alcohols, Phenols and Ethers', to_jsonb(ARRAY[\n    'Nomenclature',\n    'Methods of preparation',\n    'Physical properties',\n    'Chemical properties of alcohols',\n    'Identification of alcohols',\n    'Mechanism of dehydration',\n    'Chemical properties of phenols',\n    'Acidic nature of phenol',\n    'Electrophilic substitution',\n    'Kolbe reaction',\n    'Reimer-Tiemann reaction',\n    'Chemical properties of ethers',\n    'Williamson synthesis',\n    'Uses'\n]), 4, true);\n\n-- Unit IX: Aldehydes, Ketones and Carboxylic Acids\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Chemistry', 'Aldehydes, Ketones and Carboxylic Acids', to_jsonb(ARRAY[\n    'Nomenclature',\n    'Nature of carbonyl group',\n    'Methods of preparation',\n    'Physical properties',\n    'Chemical properties',\n    'Nucleophilic addition',\n    'Reactivity of alpha hydrogen',\n    'Aldol condensation',\n    'Cannizzaro reaction',\n    'Acidity of carboxylic acids',\n    'Formation of acid derivatives',\n    'Uses'\n]), 5, true);\n\n-- Unit X: Amines\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Chemistry', 'Amines', to_jsonb(ARRAY[\n    'Nomenclature',\n    'Classification',\n    'Structure',\n    'Methods of preparation',\n    'Physical properties',\n    'Chemical properties',\n    'Basicity of amines',\n    'Identification of amines',\n    'Diazonium salts',\n    'Preparation and reactions'\n]), 4, true);\n\n-- Unit XI: Biomolecules\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Chemistry', 'Biomolecules', to_jsonb(ARRAY[\n    'Carbohydrates',\n    'Classification',\n    'Monosaccharides',\n    'Glucose and fructose',\n    'Oligosaccharides',\n    'Polysaccharides',\n    'Proteins',\n    'Amino acids',\n    'Peptide bond',\n    'Structure of proteins',\n    'Denaturation',\n    'Enzymes',\n    'Vitamins',\n    'Nucleic acids',\n    'DNA and RNA'\n]), 4, true);\n\n-- ============================================\n-- MATHEMATICS\n-- ============================================\n\n-- Unit I: Relations and Functions\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Mathematics', 'Relations and Functions', to_jsonb(ARRAY[\n    'Types of relations',\n    'Reflexive relation',\n    'Symmetric relation',\n    'Transitive relation',\n    'Equivalence relation',\n    'One to one function',\n    'Onto function',\n    'Composite functions',\n    'Inverse of a function'\n]), 4, true);\n\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Mathematics', 'Inverse Trigonometric Functions', to_jsonb(ARRAY[\n    'Domain and range',\n    'Principal value branch',\n    'Graphs of inverse trigonometric functions',\n    'Elementary properties'\n]), 4, true);\n\n-- Unit II: Algebra\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Mathematics', 'Matrices', to_jsonb(ARRAY[\n    'Types of matrices',\n    'Row matrix',\n    'Column matrix',\n    'Square matrix',\n    'Diagonal matrix',\n    'Scalar matrix',\n    'Identity matrix',\n    'Zero matrix',\n    'Symmetric matrix',\n    'Skew-symmetric matrix',\n    'Operations on matrices',\n    'Addition',\n    'Multiplication',\n    'Transpose',\n    'Inverse of matrix',\n    'Adjoint',\n    'Elementary operations'\n]), 5, true);\n\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Mathematics', 'Determinants', to_jsonb(ARRAY[\n    'Determinant of square matrix',\n    'Properties of determinants',\n    'Minors and cofactors',\n    'Adjoint and inverse',\n    'Applications',\n    'Area of triangle',\n    'Solution of linear equations',\n    'Consistency',\n    'Cramers rule'\n]), 5, true);\n\n-- Unit III: Calculus\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Mathematics', 'Continuity and Differentiability', to_jsonb(ARRAY[\n    'Continuity of function',\n    'Differentiability',\n    'Derivative of composite functions',\n    'Chain rule',\n    'Derivative of inverse trigonometric functions',\n    'Derivative of implicit functions',\n    'Exponential and logarithmic functions',\n    'Logarithmic differentiation',\n    'Parametric differentiation',\n    'Second order derivatives',\n    'Rolle''s theorem',\n    'Mean value theorem'\n]), 5, true);\n\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Mathematics', 'Applications of Derivatives', to_jsonb(ARRAY[\n    'Rate of change',\n    'Increasing and decreasing functions',\n    'Tangents and normals',\n    'Approximations',\n    'Maxima and minima',\n    'First derivative test',\n    'Second derivative test',\n    'Optimization problems'\n]), 5, true);\n\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Mathematics', 'Integrals', to_jsonb(ARRAY[\n    'Indefinite integrals',\n    'Integration as anti-derivative',\n    'Fundamental theorems',\n    'Integration by substitution',\n    'Integration by parts',\n    'Integration by partial fractions',\n    'Definite integrals',\n    'Properties of definite integrals'\n]), 5, true);\n\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Mathematics', 'Applications of Integrals', to_jsonb(ARRAY[\n    'Area under curves',\n    'Area between curves',\n    'Area bounded by curve and line'\n]), 4, true);\n\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Mathematics', 'Differential Equations', to_jsonb(ARRAY[\n    'Order and degree',\n    'General and particular solutions',\n    'Formation of differential equations',\n    'Variable separable method',\n    'Homogeneous differential equations',\n    'Linear differential equations'\n]), 4, true);\n\n-- Unit IV: Vectors and 3D Geometry\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Mathematics', 'Vectors', to_jsonb(ARRAY[\n    'Vectors and scalars',\n    'Position vector',\n    'Direction cosines',\n    'Direction ratios',\n    'Types of vectors',\n    'Addition of vectors',\n    'Multiplication by scalar',\n    'Section formula',\n    'Scalar product',\n    'Dot product',\n    'Vector product',\n    'Cross product',\n    'Scalar triple product'\n]), 5, true);\n\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Mathematics', 'Three Dimensional Geometry', to_jsonb(ARRAY[\n    'Direction cosines and ratios',\n    'Equation of line in space',\n    'Cartesian form',\n    'Vector form',\n    'Angle between lines',\n    'Shortest distance between lines',\n    'Equation of plane',\n    'Angle between planes',\n    'Distance of point from plane'\n]), 4, true);\n\n-- Unit V: Linear Programming\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Mathematics', 'Linear Programming', to_jsonb(ARRAY[\n    'Linear programming problem',\n    'Objective function',\n    'Constraints',\n    'Optimization',\n    'Graphical method',\n    'Feasible region',\n    'Corner point method'\n]), 3, true);\n\n-- Unit VI: Probability\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Mathematics', 'Probability', to_jsonb(ARRAY[\n    'Conditional probability',\n    'Multiplication theorem',\n    'Independent events',\n    'Total probability',\n    'Bayes theorem',\n    'Random variable',\n    'Probability distribution',\n    'Mean and variance',\n    'Binomial distribution'\n]), 5, true);\n\n-- ============================================\n-- BIOLOGY\n-- ============================================\n\n-- Unit VI: Reproduction\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Biology', 'Sexual Reproduction in Flowering Plants', to_jsonb(ARRAY[\n    'Flower structure',\n    'Development of male gametophytes',\n    'Development of female gametophytes',\n    'Pollination types',\n    'Pollination agencies',\n    'Outbreeding devices',\n    'Pollen-pistil interaction',\n    'Double fertilization',\n    'Post fertilization events',\n    'Development of endosperm',\n    'Development of embryo',\n    'Apomixis',\n    'Parthenocarpy',\n    'Polyembryony'\n]), 5, true);\n\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Biology', 'Human Reproduction', to_jsonb(ARRAY[\n    'Male reproductive system',\n    'Female reproductive system',\n    'Microscopic anatomy of testis',\n    'Microscopic anatomy of ovary',\n    'Gametogenesis',\n    'Spermatogenesis',\n    'Oogenesis',\n    'Menstrual cycle',\n    'Fertilisation',\n    'Embryo development',\n    'Implantation',\n    'Pregnancy',\n    'Placenta formation',\n    'Parturition',\n    'Lactation'\n]), 5, true);\n\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Biology', 'Reproductive Health', to_jsonb(ARRAY[\n    'Need for reproductive health',\n    'Prevention of STDs',\n    'Birth control methods',\n    'Contraception',\n    'Medical termination of pregnancy',\n    'Amniocentesis',\n    'Infertility',\n    'Assisted reproductive technologies',\n    'IVF',\n    'ZIFT',\n    'GIFT'\n]), 4, true);\n\n-- Unit VII: Genetics and Evolution\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Biology', 'Principles of Inheritance and Variation', to_jsonb(ARRAY[\n    'Heredity and variation',\n    'Mendelian inheritance',\n    'Incomplete dominance',\n    'Co-dominance',\n    'Multiple alleles',\n    'Blood groups inheritance',\n    'Pleiotropy',\n    'Polygenic inheritance',\n    'Chromosome theory',\n    'Sex determination',\n    'Linkage and crossing over',\n    'Sex linked inheritance',\n    'Haemophilia',\n    'Colour blindness',\n    'Mendelian disorders',\n    'Chromosomal disorders',\n    'Down''s syndrome',\n    'Turner''s syndrome',\n    'Klinefelter''s syndrome'\n]), 5, true);\n\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Biology', 'Molecular Basis of Inheritance', to_jsonb(ARRAY[\n    'Search for genetic material',\n    'DNA as genetic material',\n    'Structure of DNA',\n    'Structure of RNA',\n    'DNA packaging',\n    'DNA replication',\n    'Central dogma',\n    'Transcription',\n    'Genetic code',\n    'Translation',\n    'Gene expression',\n    'Lac operon',\n    'Human genome project',\n    'DNA fingerprinting'\n]), 5, true);\n\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Biology', 'Evolution', to_jsonb(ARRAY[\n    'Origin of life',\n    'Biological evolution',\n    'Evidences for evolution',\n    'Paleontological evidence',\n    'Comparative anatomy',\n    'Embryology',\n    'Molecular evidence',\n    'Darwin''s contribution',\n    'Modern synthetic theory',\n    'Mechanism of evolution',\n    'Variation',\n    'Natural selection',\n    'Gene flow',\n    'Genetic drift',\n    'Hardy-Weinberg principle',\n    'Adaptive radiation',\n    'Human evolution'\n]), 5, true);\n\n-- Unit VIII: Biology and Human Welfare\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Biology', 'Human Health and Diseases', to_jsonb(ARRAY[\n    'Pathogens',\n    'Parasites causing human diseases',\n    'Malaria',\n    'Typhoid',\n    'Pneumonia',\n    'Common cold',\n    'Amoebiasis',\n    'Basic concepts of immunology',\n    'Vaccines',\n    'Cancer',\n    'HIV and AIDS',\n    'Drug and alcohol abuse'\n]), 4, true);\n\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Biology', 'Microbes in Human Welfare', to_jsonb(ARRAY[\n    'Microbes in household food processing',\n    'Industrial production',\n    'Sewage treatment',\n    'Energy generation',\n    'Biocontrol agents',\n    'Biofertilizers'\n]), 3, true);\n\n-- Unit IX: Biotechnology and its Applications\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Biology', 'Biotechnology - Principles and Processes', to_jsonb(ARRAY[\n    'Genetic engineering',\n    'Recombinant DNA technology'\n]), 4, true);\n\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Biology', 'Biotechnology and its Applications', to_jsonb(ARRAY[\n    'Application in health',\n    'Human insulin production',\n    'Vaccine production',\n    'Gene therapy',\n    'Genetically modified organisms',\n    'Bt crops',\n    'Transgenic animals',\n    'Biosafety issues',\n    'Biopiracy',\n    'Patents'\n]), 4, true);\n\n-- Unit X: Ecology and Environment\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Biology', 'Organisms and Populations', to_jsonb(ARRAY[\n    'Organisms and environment',\n    'Habitat',\n    'Niche',\n    'Population',\n    'Ecological adaptations',\n    'Population interactions',\n    'Mutualism',\n    'Competition',\n    'Predation',\n    'Parasitism',\n    'Population attributes',\n    'Growth',\n    'Birth rate',\n    'Death rate'\n]), 3, true);\n\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Biology', 'Ecosystem', to_jsonb(ARRAY[\n    'Ecosystem patterns',\n    'Components',\n    'Productivity',\n    'Decomposition',\n    'Energy flow',\n    'Pyramids',\n    'Nutrient cycling',\n    'Carbon cycling',\n    'Phosphorous cycling',\n    'Ecological succession',\n    'Ecological services'\n]), 3, true);\n\nINSERT INTO syllabus (id, class, subject, chapter, topics, priority, is_verified) VALUES\n(gen_random_uuid()::TEXT, '12', 'Biology', 'Biodiversity and Conservation', to_jsonb(ARRAY[\n    'Concept of biodiversity',\n    'Patterns of biodiversity',\n    'Importance of biodiversity',\n    'Loss of biodiversity',\n    'Biodiversity conservation',\n    'Hotspots',\n    'Endangered organisms',\n    'Extinction',\n    'Red Data Book',\n    'Biosphere reserves',\n    'National parks',\n    'Sanctuaries'\n]), 3, true);"}	seed_syllabus	utkarshweb2023@gmail.com	\N	\N
20260131062651	{"-- Fix: Allow users to insert their own profile during onboarding\n-- The onboarding flow needs to create a profile after auth\n\nDROP POLICY IF EXISTS \\"Users can insert own profile\\" ON user_profiles;\n\nCREATE POLICY \\"Users can insert own profile\\"\nON user_profiles\nFOR INSERT\nTO authenticated\nWITH CHECK (\n    user_id = auth.uid()\n);"}	fix_user_profiles_rls	utkarshweb2023@gmail.com	\N	\N
20260131080818	{"\n-- Add foreign key relationship between solutions.contributor_id and user_profiles.user_id\n-- This enables the Supabase client to join these tables using the !contributor_id syntax\n\nALTER TABLE solutions\nADD CONSTRAINT solutions_contributor_id_user_profiles_fkey\nFOREIGN KEY (contributor_id) \nREFERENCES user_profiles(user_id)\nON DELETE CASCADE;\n"}	add_solutions_user_profiles_fk	utkarshweb2023@gmail.com	\N	\N
20260131082100	{"\n-- Add foreign key relationship between questions.owner_id and user_profiles.user_id\n-- This enables the Supabase client to join these tables using the !owner_id syntax\n\nALTER TABLE questions\nADD CONSTRAINT questions_owner_id_user_profiles_fkey\nFOREIGN KEY (owner_id) \nREFERENCES user_profiles(user_id)\nON DELETE CASCADE;\n"}	add_questions_user_profiles_fk	utkarshweb2023@gmail.com	\N	\N
20260131085344	{"-- Migration: Fix Storage RLS and User Profile Relationships\n-- Created: 2026-01-31\n-- \n-- This migration addresses critical issues following Supabase/Postgres best practices:\n-- 1. Storage RLS policies for question-images bucket uploads\n-- 2. Foreign key relationships for user profile joins (solutions & questions)\n-- 3. Indexes on foreign key columns (per best practices - 10-100x faster JOINs)\n-- 4. Auto-create user_profiles trigger on auth.users insert\n-- 5. Optimized RLS policies with proper patterns\n\n-- ============================================================================\n-- FIX 1: Storage RLS Policies for question-images bucket\n-- ============================================================================\n-- Issue: RLS was enabled on storage.objects but no policies existed, causing\n-- \\"new row violates row-level security policy\\" error on image uploads\n-- Best Practice: Apply principle of least privilege - only grant needed permissions\n\n-- Drop existing policies first (to avoid conflicts), then recreate\nDROP POLICY IF EXISTS \\"Allow authenticated uploads to question-images\\" ON storage.objects;\nDROP POLICY IF EXISTS \\"Allow authenticated reads from question-images\\" ON storage.objects;\nDROP POLICY IF EXISTS \\"Allow authenticated deletes from question-images\\" ON storage.objects;\nDROP POLICY IF EXISTS \\"Allow public reads from question-images\\" ON storage.objects;\n\n-- Policy: Allow authenticated users to upload (INSERT) to question-images bucket\nCREATE POLICY \\"Allow authenticated uploads to question-images\\"\nON storage.objects\nFOR INSERT\nTO authenticated\nWITH CHECK (\n    bucket_id = 'question-images'\n);\n\n-- Policy: Allow authenticated users to read (SELECT) from question-images bucket\nCREATE POLICY \\"Allow authenticated reads from question-images\\"\nON storage.objects\nFOR SELECT\nTO authenticated\nUSING (\n    bucket_id = 'question-images'\n);\n\n-- Policy: Allow authenticated users to delete from question-images bucket\nCREATE POLICY \\"Allow authenticated deletes from question-images\\"\nON storage.objects\nFOR DELETE\nTO authenticated\nUSING (\n    bucket_id = 'question-images'\n);\n\n-- Policy: Allow public read access (since bucket is public)\nCREATE POLICY \\"Allow public reads from question-images\\"\nON storage.objects\nFOR SELECT\nTO anon\nUSING (\n    bucket_id = 'question-images'\n);\n\n-- ============================================================================\n-- FIX 2: Foreign Key Relationship for Solutions → User Profiles\n-- ============================================================================\n-- Issue: Code queries use syntax `author:user_profiles!contributor_id` but no\n-- FK relationship existed, causing PGRST200 error:\n-- \\"Could not find a relationship between 'solutions' and 'user_profiles'\\"\n-- Best Practice: Index foreign key columns for 10-100x faster JOINs\n\n-- Add foreign key: solutions.contributor_id → user_profiles.user_id\n-- This enables Supabase PostgREST to understand the join relationship\nDO $$\nBEGIN\n    IF NOT EXISTS (\n        SELECT 1 FROM information_schema.table_constraints \n        WHERE constraint_name = 'solutions_contributor_id_user_profiles_fkey'\n    ) THEN\n        ALTER TABLE solutions\n        ADD CONSTRAINT solutions_contributor_id_user_profiles_fkey\n        FOREIGN KEY (contributor_id) \n        REFERENCES user_profiles(user_id)\n        ON DELETE CASCADE;\n    END IF;\nEND $$;\n\n-- Best Practice: Index the FK column for fast JOINs and CASCADE operations\nCREATE INDEX IF NOT EXISTS idx_solutions_contributor_id_user_profiles \nON solutions(contributor_id);\n\nCOMMENT ON CONSTRAINT solutions_contributor_id_user_profiles_fkey ON solutions \nIS 'Enables author:user_profiles!contributor_id joins';\n\n-- ============================================================================\n-- FIX 3: Foreign Key Relationship for Questions → User Profiles  \n-- ============================================================================\n-- Issue: Code queries use syntax `author:user_profiles!owner_id` but no\n-- FK relationship existed to user_profiles, only to auth.users\n-- This prevents efficient joins for question owner profile data\n\n-- Add foreign key: questions.owner_id → user_profiles.user_id\n-- This enables Supabase PostgREST to understand the join relationship\nDO $$\nBEGIN\n    IF NOT EXISTS (\n        SELECT 1 FROM information_schema.table_constraints \n        WHERE constraint_name = 'questions_owner_id_user_profiles_fkey'\n    ) THEN\n        ALTER TABLE questions\n        ADD CONSTRAINT questions_owner_id_user_profiles_fkey\n        FOREIGN KEY (owner_id) \n        REFERENCES user_profiles(user_id)\n        ON DELETE CASCADE;\n    END IF;\nEND $$;\n\n-- Best Practice: Index the FK column for fast JOINs and CASCADE operations\nCREATE INDEX IF NOT EXISTS idx_questions_owner_id_user_profiles \nON questions(owner_id);\n\nCOMMENT ON CONSTRAINT questions_owner_id_user_profiles_fkey ON questions \nIS 'Enables author:user_profiles!owner_id joins';\n\n-- ============================================================================\n-- FIX 4: Additional Foreign Key Indexes (Best Practice Compliance)\n-- ============================================================================\n-- Per Postgres best practices: Always index foreign key columns\n-- This ensures fast JOINs and efficient ON DELETE CASCADE operations\n\n-- Index for questions.owner_id (auth.users FK) - already exists as idx_questions_owner_id\n-- But we need to ensure it's optimized\n\n-- Index for solutions.question_id - already exists as idx_solutions_question_id ✓\n-- Index for solutions.contributor_id (auth.users FK) - already exists as idx_solutions_contributor_id ✓\n\n-- Additional optimized indexes for common query patterns:\n\n-- Composite index for questions by subject + chapter (common filter pattern)\n-- Already exists: idx_questions_subject_chapter ✓\n\n-- Partial index for active (non-deleted) questions - already exists ✓\n-- idx_questions_deleted_at WHERE deleted_at IS NULL\n\n-- ============================================================================\n-- FIX 5: Auto-Create User Profile Trigger\n-- ============================================================================\n-- Issue: New users don't have user_profiles rows, causing \\"profile not found\\" errors\n-- Best Practice: Use trigger to maintain data consistency automatically\n\n-- Function to create user profile on auth.users insert\nCREATE OR REPLACE FUNCTION public.handle_new_user()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n    -- Insert new user profile with defaults\n    INSERT INTO public.user_profiles (user_id, display_name, username)\n    VALUES (\n        NEW.id,\n        COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email),\n        NULL  -- Username must be set manually during onboarding\n    )\n    ON CONFLICT (user_id) DO NOTHING;  -- Prevent duplicates if already exists\n    \n    RETURN NEW;\nEND;\n$$;\n\nCOMMENT ON FUNCTION public.handle_new_user() \nIS 'Automatically creates user_profiles row when new user signs up';\n\n-- Trigger to call function on auth.users insert\nDROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;\nCREATE TRIGGER on_auth_user_created\n    AFTER INSERT ON auth.users\n    FOR EACH ROW\n    EXECUTE FUNCTION public.handle_new_user();\n\n-- ============================================================================\n-- FIX 6: Optimized RLS Policies (Performance Best Practice)\n-- ============================================================================\n-- Best Practice: Wrap auth.uid() in SELECT for 100x+ faster RLS on large tables\n-- This ensures auth.uid() is called once per query, not once per row\n\n-- Drop and recreate policies with optimized patterns\n\n-- User Profiles: Update policy with optimized pattern\nDROP POLICY IF EXISTS \\"Users can update their own profile\\" ON user_profiles;\nCREATE POLICY \\"Users can update their own profile\\" \n    ON user_profiles FOR UPDATE \n    USING ((SELECT auth.uid()) = user_id);\n\n-- User Profiles: Insert policy with optimized pattern  \nDROP POLICY IF EXISTS \\"Users can insert their own profile\\" ON user_profiles;\nCREATE POLICY \\"Users can insert their own profile\\" \n    ON user_profiles FOR INSERT \n    WITH CHECK ((SELECT auth.uid()) = user_id);\n\n-- Questions: Update policy with optimized pattern\nDROP POLICY IF EXISTS \\"Owners can update their questions\\" ON questions;\nCREATE POLICY \\"Owners can update their questions\\" \n    ON questions FOR UPDATE \n    USING ((SELECT auth.uid()) = owner_id AND deleted_at IS NULL);\n\n-- Questions: Delete policy with optimized pattern\nDROP POLICY IF EXISTS \\"Owners can delete their questions\\" ON questions;\nCREATE POLICY \\"Owners can delete their questions\\" \n    ON questions FOR DELETE \n    USING ((SELECT auth.uid()) = owner_id);\n\n-- Questions: Insert policy with optimized pattern\nDROP POLICY IF EXISTS \\"Authenticated users can insert questions\\" ON questions;\nCREATE POLICY \\"Authenticated users can insert questions\\" \n    ON questions FOR INSERT \n    WITH CHECK ((SELECT auth.uid()) = owner_id);\n\n-- Solutions: Update policy with optimized pattern\nDROP POLICY IF EXISTS \\"Contributors can update their solutions\\" ON solutions;\nCREATE POLICY \\"Contributors can update their solutions\\" \n    ON solutions FOR UPDATE \n    USING ((SELECT auth.uid()) = contributor_id);\n\n-- Solutions: Delete policy with optimized pattern\nDROP POLICY IF EXISTS \\"Contributors can delete their solutions\\" ON solutions;\nCREATE POLICY \\"Contributors can delete their solutions\\" \n    ON solutions FOR DELETE \n    USING ((SELECT auth.uid()) = contributor_id);\n\n-- Solutions: Insert policy with optimized pattern\nDROP POLICY IF EXISTS \\"Users can insert their own solutions\\" ON solutions;\nCREATE POLICY \\"Users can insert their own solutions\\" \n    ON solutions FOR INSERT \n    WITH CHECK ((SELECT auth.uid()) = contributor_id);\n\n-- User Questions: All policies with optimized pattern\nDROP POLICY IF EXISTS \\"Users can view their own question links\\" ON user_questions;\nCREATE POLICY \\"Users can view their own question links\\" \n    ON user_questions FOR SELECT \n    USING ((SELECT auth.uid()) = user_id);\n\nDROP POLICY IF EXISTS \\"Users can insert their own question links\\" ON user_questions;\nCREATE POLICY \\"Users can insert their own question links\\" \n    ON user_questions FOR INSERT \n    WITH CHECK ((SELECT auth.uid()) = user_id);\n\nDROP POLICY IF EXISTS \\"Users can delete their own question links\\" ON user_questions;\nCREATE POLICY \\"Users can delete their own question links\\" \n    ON user_questions FOR DELETE \n    USING ((SELECT auth.uid()) = user_id);\n\n-- User Question Stats: All policies with optimized pattern\nDROP POLICY IF EXISTS \\"Users can view their own stats\\" ON user_question_stats;\nCREATE POLICY \\"Users can view their own stats\\" \n    ON user_question_stats FOR SELECT \n    USING ((SELECT auth.uid()) = user_id);\n\nDROP POLICY IF EXISTS \\"Users can insert their own stats\\" ON user_question_stats;\nCREATE POLICY \\"Users can insert their own stats\\" \n    ON user_question_stats FOR INSERT \n    WITH CHECK ((SELECT auth.uid()) = user_id);\n\nDROP POLICY IF EXISTS \\"Users can update their own stats\\" ON user_question_stats;\nCREATE POLICY \\"Users can update their own stats\\" \n    ON user_question_stats FOR UPDATE \n    USING ((SELECT auth.uid()) = user_id);\n\n-- Solution Likes: Insert/Delete policies with optimized pattern\nDROP POLICY IF EXISTS \\"Users can insert their own likes\\" ON solution_likes;\nCREATE POLICY \\"Users can insert their own likes\\" \n    ON solution_likes FOR INSERT \n    WITH CHECK ((SELECT auth.uid()) = user_id);\n\nDROP POLICY IF EXISTS \\"Users can delete their own likes\\" ON solution_likes;\nCREATE POLICY \\"Users can delete their own likes\\" \n    ON solution_likes FOR DELETE \n    USING ((SELECT auth.uid()) = user_id);\n\n-- Revise Later: All policies with optimized pattern\nDROP POLICY IF EXISTS \\"Users can view their own revise list\\" ON revise_later;\nCREATE POLICY \\"Users can view their own revise list\\" \n    ON revise_later FOR SELECT \n    USING ((SELECT auth.uid()) = user_id);\n\nDROP POLICY IF EXISTS \\"Users can insert into their own revise list\\" ON revise_later;\nCREATE POLICY \\"Users can insert into their own revise list\\" \n    ON revise_later FOR INSERT \n    WITH CHECK ((SELECT auth.uid()) = user_id);\n\nDROP POLICY IF EXISTS \\"Users can delete from their own revise list\\" ON revise_later;\nCREATE POLICY \\"Users can delete from their own revise list\\" \n    ON revise_later FOR DELETE \n    USING ((SELECT auth.uid()) = user_id);\n\n-- User Activities: Policies with optimized pattern\nDROP POLICY IF EXISTS \\"Users can view their own activities\\" ON user_activities;\nCREATE POLICY \\"Users can view their own activities\\" \n    ON user_activities FOR SELECT \n    USING ((SELECT auth.uid()) = user_id);\n\nDROP POLICY IF EXISTS \\"System can insert activities\\" ON user_activities;\nCREATE POLICY \\"System can insert activities\\" \n    ON user_activities FOR INSERT \n    WITH CHECK ((SELECT auth.uid()) = user_id);"}	fix_storage_and_relationships	utkarshweb2023@gmail.com	\N	\N
20260131091305	{"-- FIX 6: Migrate ALL User FKs from auth.users to user_profiles\n-- CRITICAL: All user-related foreign keys should point to user_profiles, not auth.users\n\n-- Function to safely migrate FK with data preservation\nCREATE OR REPLACE FUNCTION migrate_fk_to_user_profiles(\n    p_table TEXT,\n    p_column TEXT,\n    p_existing_fk_name TEXT\n)\nRETURNS VOID\nLANGUAGE plpgsql\nAS $$\nBEGIN\n    -- Drop existing FK to auth.users if exists\n    EXECUTE format(\n        'ALTER TABLE %I DROP CONSTRAINT IF EXISTS %I',\n        p_table,\n        p_existing_fk_name\n    );\n    \n    -- Add new FK to user_profiles\n    EXECUTE format(\n        'ALTER TABLE %I ADD CONSTRAINT %I FOREIGN KEY (%I) REFERENCES user_profiles(user_id) ON DELETE CASCADE',\n        p_table,\n        p_table || '_' || p_column || '_user_profiles_fkey',\n        p_column\n    );\nEXCEPTION\n    WHEN duplicate_table THEN\n        NULL;\nEND;\n$$;\n\n-- Migrate all tables\nSELECT migrate_fk_to_user_profiles('user_questions', 'user_id', 'user_questions_user_id_fkey');\nSELECT migrate_fk_to_user_profiles('user_question_stats', 'user_id', 'user_question_stats_user_id_fkey');\nSELECT migrate_fk_to_user_profiles('solution_likes', 'user_id', 'solution_likes_user_id_fkey');\nSELECT migrate_fk_to_user_profiles('revise_later', 'user_id', 'revise_later_user_id_fkey');\nSELECT migrate_fk_to_user_profiles('user_activities', 'user_id', 'user_activities_user_id_fkey');\n\n-- Drop the helper function\nDROP FUNCTION migrate_fk_to_user_profiles(TEXT, TEXT, TEXT);\n\n-- Ensure indexes exist on all user_id FK columns\nCREATE INDEX IF NOT EXISTS idx_user_questions_user_id ON user_questions(user_id);\nCREATE INDEX IF NOT EXISTS idx_user_question_stats_user_id ON user_question_stats(user_id);\nCREATE INDEX IF NOT EXISTS idx_solution_likes_user_id ON solution_likes(user_id);\nCREATE INDEX IF NOT EXISTS idx_revise_later_user_id ON revise_later(user_id);\nCREATE INDEX IF NOT EXISTS idx_user_activities_user_id ON user_activities(user_id);"}	migrate_all_user_fks_to_user_profiles	utkarshweb2023@gmail.com	\N	\N
20260131102011	{"-- Migration: Fix Activity Triggers and Data Consistency\n-- Description: Update triggers to capture proper metadata and add cleanup for deleted questions\n-- Created: 2026-01-31\n\n-- ============================================\n-- 1. UPDATE QUESTION CREATED ACTIVITY TRIGGER\n-- Add subject, chapter, and snippet metadata\n-- ============================================\nCREATE OR REPLACE FUNCTION log_question_created_activity()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nDECLARE\n    question_subject TEXT;\n    question_chapter TEXT;\n    question_snippet TEXT;\nBEGIN\n    SELECT subject, chapter,\n           LEFT(question_text, 100) || CASE WHEN LENGTH(question_text) > 100 THEN '...' ELSE '' END\n    INTO question_subject, question_chapter, question_snippet\n    FROM questions\n    WHERE id = NEW.question_id;\n\n    INSERT INTO user_activities (user_id, activity_type, target_id, target_type, metadata)\n    VALUES (\n        NEW.user_id,\n        'question_created',\n        NEW.question_id,\n        'question',\n        jsonb_build_object(\n            'is_owner', NEW.is_owner,\n            'subject', COALESCE(question_subject, 'General'),\n            'chapter', COALESCE(question_chapter, 'Unknown'),\n            'snippet', COALESCE(question_snippet, 'No preview available')\n        )\n    );\n    RETURN NEW;\nEND;\n$$;\n\nCOMMENT ON FUNCTION log_question_created_activity IS 'Log activity when user creates a question with full metadata';\n\n-- ============================================\n-- 2. UPDATE SOLUTION CONTRIBUTED ACTIVITY TRIGGER\n-- Add subject and snippet from the related question\n-- ============================================\nCREATE OR REPLACE FUNCTION log_solution_contributed_activity()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nDECLARE\n    question_subject TEXT;\n    question_chapter TEXT;\n    question_snippet TEXT;\nBEGIN\n    SELECT subject, chapter,\n           LEFT(question_text, 100) || CASE WHEN LENGTH(question_text) > 100 THEN '...' ELSE '' END\n    INTO question_subject, question_chapter, question_snippet\n    FROM questions\n    WHERE id = NEW.question_id;\n\n    INSERT INTO user_activities (user_id, activity_type, target_id, target_type, metadata)\n    VALUES (\n        NEW.contributor_id,\n        'solution_contributed',\n        NEW.id,\n        'solution',\n        jsonb_build_object(\n            'question_id', NEW.question_id,\n            'approach_description', NEW.approach_description,\n            'subject', COALESCE(question_subject, 'General'),\n            'chapter', COALESCE(question_chapter, 'Unknown'),\n            'snippet', COALESCE(question_snippet, 'No preview available')\n        )\n    );\n    RETURN NEW;\nEND;\n$$;\n\nCOMMENT ON FUNCTION log_solution_contributed_activity IS 'Log activity when user contributes a solution with full metadata';\n\n-- ============================================\n-- 3. CREATE TRIGGER TO CLEAN UP ACTIVITIES WHEN QUESTION IS DELETED\n-- Remove related activities when a question is permanently deleted\n-- ============================================\nCREATE OR REPLACE FUNCTION cleanup_activities_on_question_delete()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nBEGIN\n    DELETE FROM user_activities\n    WHERE target_id = OLD.id\n    AND target_type = 'question'\n    AND activity_type = 'question_created';\n\n    DELETE FROM user_activities\n    WHERE target_id IN (\n        SELECT id FROM solutions WHERE question_id = OLD.id\n    )\n    AND target_type = 'solution'\n    AND activity_type = 'solution_contributed';\n\n    RETURN OLD;\nEND;\n$$;\n\nDROP TRIGGER IF EXISTS trg_cleanup_activities_on_question_delete ON questions;\n\nCREATE TRIGGER trg_cleanup_activities_on_question_delete\n    AFTER DELETE ON questions\n    FOR EACH ROW\n    EXECUTE FUNCTION cleanup_activities_on_question_delete();\n\nCOMMENT ON FUNCTION cleanup_activities_on_question_delete IS 'Clean up related activities when a question is permanently deleted';\n\n-- ============================================\n-- 4. CLEAN UP EXISTING ORPHANED ACTIVITIES\n-- Remove activities that reference non-existent questions or solutions\n-- ============================================\n\nDELETE FROM user_activities ua\nWHERE ua.target_type = 'question'\nAND ua.activity_type = 'question_created'\nAND NOT EXISTS (\n    SELECT 1 FROM questions q WHERE q.id = ua.target_id\n);\n\nDELETE FROM user_activities ua\nWHERE ua.target_type = 'solution'\nAND ua.activity_type = 'solution_contributed'\nAND NOT EXISTS (\n    SELECT 1 FROM solutions s WHERE s.id = ua.target_id\n);\n\n-- ============================================\n-- 5. BACKFILL MISSING METADATA FOR EXISTING ACTIVITIES\n-- Update existing activities with proper subject/chapter/snippet\n-- ============================================\n\nUPDATE user_activities ua\nSET metadata = jsonb_build_object(\n    'is_owner', COALESCE((ua.metadata->>'is_owner')::boolean, true),\n    'subject', COALESCE(q.subject, 'General'),\n    'chapter', COALESCE(q.chapter, 'Unknown'),\n    'snippet', COALESCE(LEFT(q.question_text, 100) || CASE WHEN LENGTH(q.question_text) > 100 THEN '...' ELSE '' END, 'No preview available')\n)\nFROM questions q\nWHERE ua.target_id = q.id\nAND ua.target_type = 'question'\nAND ua.activity_type = 'question_created';\n\nUPDATE user_activities ua\nSET metadata = jsonb_build_object(\n    'question_id', s.question_id,\n    'approach_description', s.approach_description,\n    'subject', COALESCE(q.subject, 'General'),\n    'chapter', COALESCE(q.chapter, 'Unknown'),\n    'snippet', COALESCE(LEFT(q.question_text, 100) || CASE WHEN LENGTH(q.question_text) > 100 THEN '...' ELSE '' END, 'No preview available')\n)\nFROM solutions s\nJOIN questions q ON q.id = s.question_id\nWHERE ua.target_id = s.id\nAND ua.target_type = 'solution'\nAND ua.activity_type = 'solution_contributed';\n"}	fix_activity_triggers	utkarshweb2023@gmail.com	\N	\N
20260131121524	{"-- Migration: Create Social Features\n-- Description: Create follows and notifications tables with automated triggers\n-- Created: 2026-01-31\n\n-- ============================================\n-- 1. FOLLOWS TABLE\n-- ============================================\nCREATE TABLE IF NOT EXISTS follows (\n    follower_id UUID REFERENCES user_profiles(user_id) ON DELETE CASCADE,\n    following_id UUID REFERENCES user_profiles(user_id) ON DELETE CASCADE,\n    created_at TIMESTAMPTZ DEFAULT NOW(),\n    PRIMARY KEY (follower_id, following_id)\n);\n\n-- RLS Policies\nALTER TABLE follows ENABLE ROW LEVEL SECURITY;\n\nCREATE POLICY \\"Anyone can view follows\\" \n    ON follows FOR SELECT \n    USING (true);\n\nCREATE POLICY \\"Users can follow others\\" \n    ON follows FOR INSERT \n    WITH CHECK (auth.uid() = follower_id);\n\nCREATE POLICY \\"Users can unfollow\\" \n    ON follows FOR DELETE \n    USING (auth.uid() = follower_id);\n\n-- ============================================\n-- 2. NOTIFICATIONS TABLE\n-- ============================================\nDO $$ BEGIN\n    CREATE TYPE notification_type AS ENUM (\n        'follow', \n        'like', \n        'link', \n        'contribution'\n    );\nEXCEPTION\n    WHEN duplicate_object THEN null;\nEND $$;\n\nCREATE TABLE IF NOT EXISTS notifications (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    recipient_id UUID REFERENCES user_profiles(user_id) ON DELETE CASCADE,\n    sender_id UUID REFERENCES user_profiles(user_id) ON DELETE CASCADE,\n    type notification_type NOT NULL,\n    entity_id UUID, -- Can link to user_profile (for follow) or solution/question\n    entity_type TEXT, -- 'user', 'solution', 'question'\n    is_read BOOLEAN DEFAULT FALSE,\n    created_at TIMESTAMPTZ DEFAULT NOW()\n);\n\n-- Index for fast queries\nCREATE INDEX IF NOT EXISTS idx_notifications_recipient ON notifications(recipient_id);\nCREATE INDEX IF NOT EXISTS idx_notifications_unread ON notifications(recipient_id) WHERE is_read = FALSE;\n\n-- RLS Policies\nALTER TABLE notifications ENABLE ROW LEVEL SECURITY;\n\nCREATE POLICY \\"Users view their own notifications\\" \n    ON notifications FOR SELECT \n    USING (auth.uid() = recipient_id);\n\nCREATE POLICY \\"Users update their own notifications\\" \n    ON notifications FOR UPDATE \n    USING (auth.uid() = recipient_id);\n\n-- ============================================\n-- 3. AUTOMATION TRIGGERS\n-- ============================================\n\n-- A. New Follower Notification\nCREATE OR REPLACE FUNCTION notify_on_follow()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nBEGIN\n    INSERT INTO notifications (recipient_id, sender_id, type, entity_id, entity_type)\n    VALUES (\n        NEW.following_id,\n        NEW.follower_id,\n        'follow',\n        NEW.follower_id,\n        'user'\n    );\n    RETURN NEW;\nEND;\n$$;\n\nDROP TRIGGER IF EXISTS trg_notify_on_follow ON follows;\nCREATE TRIGGER trg_notify_on_follow\n    AFTER INSERT ON follows\n    FOR EACH ROW\n    EXECUTE FUNCTION notify_on_follow();\n\n-- B. Solution Liked Notification\nCREATE OR REPLACE FUNCTION notify_on_solution_like()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nDECLARE\n    solution_author_id UUID;\nBEGIN\n    -- Get solution author\n    SELECT contributor_id INTO solution_author_id\n    FROM solutions\n    WHERE id = NEW.solution_id;\n\n    -- Don't notify if liking own solution\n    IF solution_author_id != NEW.user_id THEN\n        INSERT INTO notifications (recipient_id, sender_id, type, entity_id, entity_type)\n        VALUES (\n            solution_author_id,\n            NEW.user_id,\n            'like',\n            NEW.solution_id,\n            'solution'\n        );\n    END IF;\n    RETURN NEW;\nEND;\n$$;\n\nDROP TRIGGER IF EXISTS trg_notify_on_solution_like ON solution_likes;\nCREATE TRIGGER trg_notify_on_solution_like\n    AFTER INSERT ON solution_likes\n    FOR EACH ROW\n    EXECUTE FUNCTION notify_on_solution_like();\n\n-- C. New Contribution Notification (to question owner)\nCREATE OR REPLACE FUNCTION notify_on_contribution()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nDECLARE\n    question_owner_id UUID;\nBEGIN\n    -- Get question owner\n    SELECT owner_id INTO question_owner_id\n    FROM questions\n    WHERE id = NEW.question_id;\n\n    -- Don't notify if contributing to own question\n    IF question_owner_id != NEW.contributor_id THEN\n        INSERT INTO notifications (recipient_id, sender_id, type, entity_id, entity_type)\n        VALUES (\n            question_owner_id,\n            NEW.contributor_id,\n            'contribution',\n            NEW.id, -- Linking to the solution\n            'solution'\n        );\n    END IF;\n    RETURN NEW;\nEND;\n$$;\n\nDROP TRIGGER IF EXISTS trg_notify_on_contribution ON solutions;\nCREATE TRIGGER trg_notify_on_contribution\n    AFTER INSERT ON solutions\n    FOR EACH ROW\n    EXECUTE FUNCTION notify_on_contribution();"}	create_social_features	utkarshweb2023@gmail.com	\N	\N
20260131194546	{"-- Fix solve activity trigger to handle INSERT (first-time solves)\n\nCREATE OR REPLACE FUNCTION public.log_user_activity()\nRETURNS TRIGGER AS $$\nDECLARE\n    target_metadata JSONB := '{}'::jsonb;\n    target_user_id UUID;\n    v_subject TEXT;\n    v_chapter TEXT;\n    v_text TEXT;\nBEGIN\n    -- Handle Questions\n    IF TG_TABLE_NAME = 'questions' THEN\n        IF TG_OP = 'INSERT' THEN\n            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)\n            VALUES (NEW.owner_id, 'question_created', NEW.id, 'question', \n                jsonb_build_object('subject', NEW.subject, 'chapter', NEW.chapter, 'snippet', left(NEW.question_text, 150)));\n        ELSIF TG_OP = 'UPDATE' THEN\n            IF (OLD.hint IS DISTINCT FROM NEW.hint) THEN\n                INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)\n                VALUES (NEW.owner_id, 'hint_updated', NEW.id, 'question', \n                    jsonb_build_object('subject', NEW.subject, 'chapter', NEW.chapter, 'snippet', left(NEW.question_text, 150)));\n            END IF;\n        ELSIF TG_OP = 'DELETE' THEN\n            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)\n            VALUES (OLD.owner_id, 'question_deleted', OLD.id, 'question', \n                jsonb_build_object('subject', OLD.subject, 'chapter', OLD.chapter, 'snippet', left(OLD.question_text, 150)));\n        END IF;\n\n    -- Handle Solutions\n    ELSIF TG_TABLE_NAME = 'solutions' THEN\n        IF TG_OP = 'INSERT' THEN\n            -- Get question details\n            SELECT subject, chapter, owner_id INTO v_subject, v_chapter, target_user_id \n            FROM public.questions WHERE id = NEW.question_id;\n            \n            IF target_user_id != NEW.contributor_id THEN\n                INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)\n                VALUES (NEW.contributor_id, 'solution_contributed', NEW.id, 'solution', \n                    jsonb_build_object('subject', v_subject, 'chapter', v_chapter, 'snippet', left(NEW.solution_text, 150), 'question_id', NEW.question_id));\n            END IF;\n        ELSIF TG_OP = 'DELETE' THEN\n             SELECT subject, chapter, owner_id INTO v_subject, v_chapter, target_user_id \n             FROM public.questions WHERE id = OLD.question_id;\n\n             INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)\n             VALUES (OLD.contributor_id, 'solution_deleted', OLD.id, 'solution', \n                 jsonb_build_object('subject', v_subject, 'chapter', v_chapter));\n        END IF;\n\n    -- Handle Question Stats (Solving)\n    ELSIF TG_TABLE_NAME = 'user_question_stats' THEN\n        -- Check for INSERT with solved=true OR UPDATE with solved becoming true\n        IF (TG_OP = 'INSERT' AND NEW.solved = true) OR \n           (TG_OP = 'UPDATE' AND NEW.solved = true AND (OLD.solved = false OR OLD.solved IS NULL)) THEN\n            \n            SELECT subject, chapter, question_text INTO v_subject, v_chapter, v_text \n            FROM public.questions WHERE id = NEW.question_id;\n            \n            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)\n            VALUES (NEW.user_id, 'question_solved', NEW.question_id, 'question', \n                jsonb_build_object('subject', v_subject, 'chapter', v_chapter, 'snippet', left(v_text, 150)));\n        END IF;\n\n    -- Handle User Questions (Forking/Bank)\n    ELSIF TG_TABLE_NAME = 'user_questions' THEN\n        -- Only log if the user is NOT the owner (i.e., they are linking someone else's question)\n        IF TG_OP = 'INSERT' AND NEW.is_owner = false THEN\n            SELECT subject, chapter, question_text INTO v_subject, v_chapter, v_text \n            FROM public.questions WHERE id = NEW.question_id;\n            \n            INSERT INTO public.user_activities (user_id, activity_type, target_id, target_type, metadata)\n            VALUES (NEW.user_id, 'question_forked', NEW.question_id, 'question', \n                jsonb_build_object('subject', v_subject, 'chapter', v_chapter, 'snippet', left(v_text, 150)));\n        END IF;\n    END IF;\n\n    RETURN NULL;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER;\n\n-- Recreate trigger for user_question_stats to include INSERT\nDROP TRIGGER IF EXISTS tr_log_solve_activity ON public.user_question_stats;\nCREATE TRIGGER tr_log_solve_activity\nAFTER INSERT OR UPDATE ON public.user_question_stats\nFOR EACH ROW EXECUTE FUNCTION public.log_user_activity();\n"}	20260201_fix_solve_activity_trigger	utkarshweb2023@gmail.com	\N	\N
20260202162319	{"-- MIGRATION 05: RECOMMENDATION SYSTEM (REWRITTEN FROM SCRATCH)\n-- Purpose: Fix RPC error 42804 (text vs uuid type mismatch) by enforcing strict types.\n\n-- 1. CLEANUP: Drop all existing versions to avoid signature conflicts.\nDROP FUNCTION IF EXISTS get_mixed_feed(uuid, int, int);\nDROP FUNCTION IF EXISTS get_recommended_users(uuid, int, int);\nDROP FUNCTION IF EXISTS get_recommended_questions(uuid, int, int);\nDROP FUNCTION IF EXISTS get_user_avg_difficulty(uuid);\nDROP FUNCTION IF EXISTS get_user_chapters(uuid);\nDROP FUNCTION IF EXISTS get_user_subjects(uuid);\n\n-- 2. HELPER FUNCTIONS\nCREATE OR REPLACE FUNCTION get_user_subjects(p_user_id UUID)\nRETURNS TEXT[] LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_subjects TEXT[];\nBEGIN\n    SELECT ARRAY(\n        SELECT DISTINCT unnest FROM (\n            SELECT unnest(COALESCE(up.subjects, ARRAY[]::TEXT[]))\n            FROM user_profiles up\n            WHERE up.user_id = p_user_id\n            UNION\n            SELECT q.subject\n            FROM user_questions uq\n            JOIN questions q ON q.id = uq.question_id\n            WHERE uq.user_id = p_user_id\n            AND q.subject IS NOT NULL\n        ) AS combined_subjects\n    ) INTO v_subjects;\n    \n    RETURN COALESCE(v_subjects, ARRAY[]::TEXT[]);\nEND;\n$$;\n\nCREATE OR REPLACE FUNCTION get_user_chapters(p_user_id UUID)\nRETURNS TEXT[] LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_chapters TEXT[];\nBEGIN\n    SELECT ARRAY(\n        SELECT DISTINCT q.chapter\n        FROM user_questions uq\n        JOIN questions q ON q.id = uq.question_id\n        WHERE uq.user_id = p_user_id\n        AND q.chapter IS NOT NULL\n    ) INTO v_chapters;\n    \n    RETURN COALESCE(v_chapters, ARRAY[]::TEXT[]);\nEND;\n$$;\n\nCREATE OR REPLACE FUNCTION get_user_avg_difficulty(p_user_id UUID)\nRETURNS TEXT LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_avg NUMERIC;\nBEGIN\n    SELECT AVG(CASE \n        WHEN q.difficulty = 'easy' THEN 1\n        WHEN q.difficulty = 'medium' THEN 2\n        WHEN q.difficulty = 'hard' THEN 3\n        WHEN q.difficulty = 'very_hard' THEN 4\n        ELSE 2\n    END) INTO v_avg\n    FROM user_question_stats uqs\n    JOIN questions q ON q.id = uqs.question_id\n    WHERE uqs.user_id = p_user_id\n    AND uqs.solved = true;\n    \n    IF v_avg IS NULL THEN RETURN 'medium';\n    ELSIF v_avg < 1.5 THEN RETURN 'easy';\n    ELSIF v_avg < 2.5 THEN RETURN 'medium';\n    ELSIF v_avg < 3.5 THEN RETURN 'hard';\n    ELSE RETURN 'very_hard';\n    END IF;\nEND;\n$$;\n\n-- 3. CORE RECOMMENDATION FUNCTIONS\n\nCREATE OR REPLACE FUNCTION get_recommended_questions(\n    p_user_id UUID,\n    p_limit INT DEFAULT 20,\n    p_offset INT DEFAULT 0\n)\nRETURNS TABLE (\n    question_id UUID,\n    question_text TEXT,\n    subject TEXT,\n    chapter TEXT,\n    topics JSONB,\n    difficulty difficulty_enum,\n    popularity INT,\n    created_at TIMESTAMPTZ,\n    image_url TEXT,\n    type question_type_enum,\n    has_diagram BOOLEAN,\n    uploader_user_id UUID,\n    uploader_display_name TEXT,\n    uploader_username TEXT,\n    uploader_avatar_url TEXT,\n    solutions_count BIGINT,\n    is_in_bank BOOLEAN,\n    due_for_review BOOLEAN,\n    score INT\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_user_subjects TEXT[];\n    v_user_chapters TEXT[];\n    v_user_difficulty TEXT;\n    v_followed_users UUID[];\nBEGIN\n    v_user_subjects := get_user_subjects(p_user_id);\n    v_user_chapters := get_user_chapters(p_user_id);\n    v_user_difficulty := get_user_avg_difficulty(p_user_id);\n    \n    SELECT ARRAY(SELECT following_id FROM follows WHERE follower_id = p_user_id) INTO v_followed_users;\n    \n    RETURN QUERY\n    SELECT \n        q.id AS question_id,\n        q.question_text,\n        q.subject,\n        q.chapter,\n        q.topics,\n        q.difficulty,\n        q.popularity,\n        q.created_at,\n        q.image_url,\n        q.type,\n        q.has_diagram,\n        q.owner_id AS uploader_user_id,\n        up.display_name AS uploader_display_name,\n        up.username AS uploader_username,\n        up.avatar_url AS uploader_avatar_url,\n        (SELECT COUNT(*) FROM solutions s WHERE s.question_id = q.id)::BIGINT AS solutions_count,\n        EXISTS(SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id) AS is_in_bank,\n        COALESCE(EXISTS(SELECT 1 FROM user_question_stats uqs WHERE uqs.user_id = p_user_id AND uqs.question_id = q.id AND uqs.next_review_at <= NOW()), false) AS due_for_review,\n        (\n            CASE WHEN q.subject = ANY(v_user_subjects) THEN 30 ELSE 0 END +\n            CASE WHEN q.chapter = ANY(v_user_chapters) THEN 20 ELSE 0 END +\n            CASE WHEN q.owner_id = ANY(v_followed_users) THEN 25 ELSE 0 END +\n            CASE WHEN q.difficulty::TEXT = v_user_difficulty THEN 15 ELSE 0 END +\n            LEAST(q.popularity, 10)::INT\n        ) AS score\n    FROM questions q\n    JOIN user_profiles up ON up.user_id = q.owner_id\n    WHERE q.deleted_at IS NULL\n    ORDER BY score DESC, q.created_at DESC\n    LIMIT p_limit OFFSET p_offset;\nEND;\n$$;\n\nCREATE OR REPLACE FUNCTION get_recommended_users(\n    p_user_id UUID,\n    p_limit INT DEFAULT 10,\n    p_offset INT DEFAULT 0\n)\nRETURNS TABLE (\n    user_id UUID,\n    display_name TEXT,\n    username TEXT,\n    avatar_url TEXT,\n    common_subjects TEXT[],\n    mutual_follows_count BIGINT,\n    total_questions BIGINT,\n    total_solutions BIGINT,\n    is_following BOOLEAN,\n    last_active TIMESTAMPTZ,\n    score INT\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nBEGIN\n    RETURN QUERY\n    SELECT \n        up.user_id,\n        up.display_name,\n        up.username,\n        up.avatar_url,\n        ARRAY[]::TEXT[] AS common_subjects,\n        0::BIGINT AS mutual_follows_count,\n        up.total_uploaded::BIGINT AS total_questions,\n        up.solutions_helped_count::BIGINT AS total_solutions,\n        EXISTS(SELECT 1 FROM follows f WHERE f.follower_id = p_user_id AND f.following_id = up.user_id) AS is_following,\n        up.updated_at AS last_active,\n        10 AS score\n    FROM user_profiles up\n    WHERE up.user_id != p_user_id\n    AND NOT EXISTS (SELECT 1 FROM follows f WHERE f.follower_id = p_user_id AND f.following_id = up.user_id)\n    ORDER BY up.updated_at DESC\n    LIMIT p_limit OFFSET p_offset;\nEND;\n$$;\n\n-- 4. THE MIXED FEED (The Fix)\nCREATE OR REPLACE FUNCTION get_mixed_feed(\n    p_user_id UUID,\n    p_limit INT DEFAULT 20,\n    p_offset INT DEFAULT 0\n)\nRETURNS TABLE (\n    item_id UUID,\n    item_type TEXT,\n    item_data JSONB,\n    score INT,\n    created_at TIMESTAMPTZ\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_question_count INT;\n    v_user_count INT;\nBEGIN\n    v_question_count := GREATEST(1, floor(p_limit * 0.8));\n    v_user_count := GREATEST(1, floor(p_limit * 0.2));\n\n    RETURN QUERY\n    WITH \n    q_source AS (\n        SELECT \n            rq.question_id::UUID AS src_id,\n            'question'::TEXT AS src_type,\n            jsonb_build_object(\n                'id', rq.question_id,\n                'question_text', rq.question_text,\n                'subject', rq.subject,\n                'chapter', rq.chapter,\n                'difficulty', rq.difficulty,\n                'topics', rq.topics,\n                'popularity', rq.popularity,\n                'image_url', rq.image_url,\n                'type', rq.type,\n                'has_diagram', rq.has_diagram,\n                'solutions_count', rq.solutions_count,\n                'is_in_bank', rq.is_in_bank,\n                'due_for_review', rq.due_for_review,\n                'uploader', jsonb_build_object(\n                    'user_id', rq.uploader_user_id,\n                    'display_name', rq.uploader_display_name,\n                    'username', rq.uploader_username,\n                    'avatar_url', rq.uploader_avatar_url\n                )\n            ) AS src_data,\n            rq.score::INT AS src_score,\n            rq.created_at AS src_created_at,\n            ROW_NUMBER() OVER (ORDER BY rq.score DESC, rq.created_at DESC) AS custom_rn\n        FROM get_recommended_questions(p_user_id, v_question_count + p_offset, 0) rq\n    ),\n    u_source AS (\n        SELECT \n            ru.user_id::UUID AS src_id,\n            'user_suggestion'::TEXT AS src_type,\n            jsonb_build_object(\n                'user_id', ru.user_id,\n                'display_name', ru.display_name,\n                'username', ru.username,\n                'avatar_url', ru.avatar_url,\n                'common_subjects', ru.common_subjects,\n                'mutual_follows_count', ru.mutual_follows_count,\n                'total_questions', ru.total_questions,\n                'total_solutions', ru.total_solutions,\n                'is_following', ru.is_following\n            ) AS src_data,\n            ru.score::INT AS src_score,\n            ru.last_active AS src_created_at,\n            ROW_NUMBER() OVER (ORDER BY ru.score DESC) AS custom_rn\n        FROM get_recommended_users(p_user_id, v_user_count + (p_offset / 4), 0) ru\n    ),\n    combined_source AS (\n        SELECT src_id, src_type, src_data, src_score, src_created_at, custom_rn FROM q_source\n        UNION ALL\n        SELECT src_id, src_type, src_data, src_score, src_created_at, custom_rn FROM u_source\n    ),\n    ordered_feed AS (\n        SELECT\n            c.src_id,\n            c.src_type,\n            c.src_data,\n            c.src_score,\n            c.src_created_at,\n            CASE \n                WHEN c.src_type = 'question' THEN c.custom_rn + (c.custom_rn - 1) / 4\n                ELSE (c.custom_rn * 5)\n            END AS sort_order\n        FROM combined_source c\n    )\n    SELECT\n        of_feed.src_id AS item_id,\n        of_feed.src_type AS item_type,\n        of_feed.src_data AS item_data,\n        of_feed.src_score AS score,\n        of_feed.src_created_at AS created_at\n    FROM ordered_feed of_feed\n    ORDER BY of_feed.sort_order ASC\n    LIMIT p_limit\n    OFFSET p_offset;\nEND;\n$$;\n\n-- 5. PERMISSIONS\nGRANT EXECUTE ON FUNCTION get_user_subjects(UUID) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_user_chapters(UUID) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_user_avg_difficulty(UUID) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_recommended_questions(UUID, INT, INT) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_recommended_users(UUID, INT, INT) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_mixed_feed(UUID, INT, INT) TO authenticated;\n"}	recommendation_system_v2	utkarshweb2023@gmail.com	\N	\N
20260202162744	{"-- MIGRATION 05: RECOMMENDATION SYSTEM (FINAL FIX V3)\n-- Purpose: Fix RPC error 42804 by casting TEXT IDs to UUID explicitly.\n\n-- 1. CLEANUP\nDROP FUNCTION IF EXISTS get_mixed_feed(uuid, int, int);\nDROP FUNCTION IF EXISTS get_recommended_users(uuid, int, int);\nDROP FUNCTION IF EXISTS get_recommended_questions(uuid, int, int);\nDROP FUNCTION IF EXISTS get_user_avg_difficulty(uuid);\nDROP FUNCTION IF EXISTS get_user_chapters(uuid);\nDROP FUNCTION IF EXISTS get_user_subjects(uuid);\n\n-- 2. HELPER FUNCTIONS\nCREATE OR REPLACE FUNCTION get_user_subjects(p_user_id UUID)\nRETURNS TEXT[] LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_subjects TEXT[];\nBEGIN\n    SELECT ARRAY(\n        SELECT DISTINCT unnest FROM (\n            SELECT unnest(COALESCE(up.subjects, ARRAY[]::TEXT[]))\n            FROM user_profiles up\n            WHERE up.user_id = p_user_id\n            UNION\n            SELECT q.subject\n            FROM user_questions uq\n            JOIN questions q ON q.id = uq.question_id\n            WHERE uq.user_id = p_user_id\n            AND q.subject IS NOT NULL\n        ) AS combined_subjects\n    ) INTO v_subjects;\n    \n    RETURN COALESCE(v_subjects, ARRAY[]::TEXT[]);\nEND;\n$$;\n\nCREATE OR REPLACE FUNCTION get_user_chapters(p_user_id UUID)\nRETURNS TEXT[] LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_chapters TEXT[];\nBEGIN\n    SELECT ARRAY(\n        SELECT DISTINCT q.chapter\n        FROM user_questions uq\n        JOIN questions q ON q.id = uq.question_id\n        WHERE uq.user_id = p_user_id\n        AND q.chapter IS NOT NULL\n    ) INTO v_chapters;\n    \n    RETURN COALESCE(v_chapters, ARRAY[]::TEXT[]);\nEND;\n$$;\n\nCREATE OR REPLACE FUNCTION get_user_avg_difficulty(p_user_id UUID)\nRETURNS TEXT LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_avg NUMERIC;\nBEGIN\n    SELECT AVG(CASE \n        WHEN q.difficulty = 'easy' THEN 1\n        WHEN q.difficulty = 'medium' THEN 2\n        WHEN q.difficulty = 'hard' THEN 3\n        WHEN q.difficulty = 'very_hard' THEN 4\n        ELSE 2\n    END) INTO v_avg\n    FROM user_question_stats uqs\n    JOIN questions q ON q.id = uqs.question_id\n    WHERE uqs.user_id = p_user_id\n    AND uqs.solved = true;\n    \n    IF v_avg IS NULL THEN RETURN 'medium';\n    ELSIF v_avg < 1.5 THEN RETURN 'easy';\n    ELSIF v_avg < 2.5 THEN RETURN 'medium';\n    ELSIF v_avg < 3.5 THEN RETURN 'hard';\n    ELSE RETURN 'very_hard';\n    END IF;\nEND;\n$$;\n\n-- 3. CORE RECOMMENDATION FUNCTIONS\n\nCREATE OR REPLACE FUNCTION get_recommended_questions(\n    p_user_id UUID,\n    p_limit INT DEFAULT 20,\n    p_offset INT DEFAULT 0\n)\nRETURNS TABLE (\n    question_id UUID,\n    question_text TEXT,\n    subject TEXT,\n    chapter TEXT,\n    topics JSONB,\n    difficulty difficulty_enum,\n    popularity INT,\n    created_at TIMESTAMPTZ,\n    image_url TEXT,\n    type question_type_enum,\n    has_diagram BOOLEAN,\n    uploader_user_id UUID,\n    uploader_display_name TEXT,\n    uploader_username TEXT,\n    uploader_avatar_url TEXT,\n    solutions_count BIGINT,\n    is_in_bank BOOLEAN,\n    due_for_review BOOLEAN,\n    score INT\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_user_subjects TEXT[];\n    v_user_chapters TEXT[];\n    v_user_difficulty TEXT;\n    v_followed_users UUID[];\nBEGIN\n    v_user_subjects := get_user_subjects(p_user_id);\n    v_user_chapters := get_user_chapters(p_user_id);\n    v_user_difficulty := get_user_avg_difficulty(p_user_id);\n    \n    SELECT ARRAY(SELECT following_id FROM follows WHERE follower_id = p_user_id) INTO v_followed_users;\n    \n    RETURN QUERY\n    SELECT \n        q.id::UUID AS question_id, -- CRITICAL FIX: Cast TEXT to UUID\n        q.question_text,\n        q.subject,\n        q.chapter,\n        q.topics,\n        q.difficulty,\n        q.popularity,\n        q.created_at,\n        q.image_url,\n        q.type,\n        q.has_diagram,\n        q.owner_id AS uploader_user_id,\n        up.display_name AS uploader_display_name,\n        up.username AS uploader_username,\n        up.avatar_url AS uploader_avatar_url,\n        (SELECT COUNT(*) FROM solutions s WHERE s.question_id = q.id)::BIGINT AS solutions_count,\n        EXISTS(SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id) AS is_in_bank,\n        COALESCE(EXISTS(SELECT 1 FROM user_question_stats uqs WHERE uqs.user_id = p_user_id AND uqs.question_id = q.id AND uqs.next_review_at <= NOW()), false) AS due_for_review,\n        (\n            CASE WHEN q.subject = ANY(v_user_subjects) THEN 30 ELSE 0 END +\n            CASE WHEN q.chapter = ANY(v_user_chapters) THEN 20 ELSE 0 END +\n            CASE WHEN q.owner_id = ANY(v_followed_users) THEN 25 ELSE 0 END +\n            CASE WHEN q.difficulty::TEXT = v_user_difficulty THEN 15 ELSE 0 END +\n            LEAST(q.popularity, 10)::INT\n        ) AS score\n    FROM questions q\n    JOIN user_profiles up ON up.user_id = q.owner_id\n    WHERE q.deleted_at IS NULL\n    ORDER BY score DESC, q.created_at DESC\n    LIMIT p_limit OFFSET p_offset;\nEND;\n$$;\n\nCREATE OR REPLACE FUNCTION get_recommended_users(\n    p_user_id UUID,\n    p_limit INT DEFAULT 10,\n    p_offset INT DEFAULT 0\n)\nRETURNS TABLE (\n    user_id UUID,\n    display_name TEXT,\n    username TEXT,\n    avatar_url TEXT,\n    common_subjects TEXT[],\n    mutual_follows_count BIGINT,\n    total_questions BIGINT,\n    total_solutions BIGINT,\n    is_following BOOLEAN,\n    last_active TIMESTAMPTZ,\n    score INT\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nBEGIN\n    RETURN QUERY\n    SELECT \n        up.user_id, -- Valid UUID\n        up.display_name,\n        up.username,\n        up.avatar_url,\n        ARRAY[]::TEXT[] AS common_subjects,\n        0::BIGINT AS mutual_follows_count,\n        up.total_uploaded::BIGINT AS total_questions,\n        up.solutions_helped_count::BIGINT AS total_solutions,\n        EXISTS(SELECT 1 FROM follows f WHERE f.follower_id = p_user_id AND f.following_id = up.user_id) AS is_following,\n        up.updated_at AS last_active,\n        10 AS score\n    FROM user_profiles up\n    WHERE up.user_id != p_user_id\n    AND NOT EXISTS (SELECT 1 FROM follows f WHERE f.follower_id = p_user_id AND f.following_id = up.user_id)\n    ORDER BY up.updated_at DESC\n    LIMIT p_limit OFFSET p_offset;\nEND;\n$$;\n\n-- 4. MIXED FEED\nCREATE OR REPLACE FUNCTION get_mixed_feed(\n    p_user_id UUID,\n    p_limit INT DEFAULT 20,\n    p_offset INT DEFAULT 0\n)\nRETURNS TABLE (\n    item_id UUID,\n    item_type TEXT,\n    item_data JSONB,\n    score INT,\n    created_at TIMESTAMPTZ\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_question_count INT;\n    v_user_count INT;\nBEGIN\n    v_question_count := GREATEST(1, floor(p_limit * 0.8));\n    v_user_count := GREATEST(1, floor(p_limit * 0.2));\n\n    RETURN QUERY\n    WITH \n    q_source AS (\n        SELECT \n            rq.question_id AS src_id, -- Already UUID from get_recommended_questions\n            'question'::TEXT AS src_type,\n            jsonb_build_object(\n                'id', rq.question_id,\n                'question_text', rq.question_text,\n                'subject', rq.subject,\n                'chapter', rq.chapter,\n                'difficulty', rq.difficulty,\n                'topics', rq.topics,\n                'popularity', rq.popularity,\n                'image_url', rq.image_url,\n                'type', rq.type,\n                'has_diagram', rq.has_diagram,\n                'solutions_count', rq.solutions_count,\n                'is_in_bank', rq.is_in_bank,\n                'due_for_review', rq.due_for_review,\n                'uploader', jsonb_build_object(\n                    'user_id', rq.uploader_user_id,\n                    'display_name', rq.uploader_display_name,\n                    'username', rq.uploader_username,\n                    'avatar_url', rq.uploader_avatar_url\n                )\n            ) AS src_data,\n            rq.score::INT AS src_score,\n            rq.created_at AS src_created_at,\n            ROW_NUMBER() OVER (ORDER BY rq.score DESC, rq.created_at DESC) AS custom_rn\n        FROM get_recommended_questions(p_user_id, v_question_count + p_offset, 0) rq\n    ),\n    u_source AS (\n        SELECT \n            ru.user_id AS src_id, -- Already UUID\n            'user_suggestion'::TEXT AS src_type,\n            jsonb_build_object(\n                'user_id', ru.user_id,\n                'display_name', ru.display_name,\n                'username', ru.username,\n                'avatar_url', ru.avatar_url,\n                'common_subjects', ru.common_subjects,\n                'mutual_follows_count', ru.mutual_follows_count,\n                'total_questions', ru.total_questions,\n                'total_solutions', ru.total_solutions,\n                'is_following', ru.is_following\n            ) AS src_data,\n            ru.score::INT AS src_score,\n            ru.last_active AS src_created_at,\n            ROW_NUMBER() OVER (ORDER BY ru.score DESC) AS custom_rn\n        FROM get_recommended_users(p_user_id, v_user_count + (p_offset / 4), 0) ru\n    ),\n    combined_source AS (\n        SELECT src_id, src_type, src_data, src_score, src_created_at, custom_rn FROM q_source\n        UNION ALL\n        SELECT src_id, src_type, src_data, src_score, src_created_at, custom_rn FROM u_source\n    ),\n    ordered_feed AS (\n        SELECT\n            c.src_id,\n            c.src_type,\n            c.src_data,\n            c.src_score,\n            c.src_created_at,\n            CASE \n                WHEN c.src_type = 'question' THEN c.custom_rn + (c.custom_rn - 1) / 4\n                ELSE (c.custom_rn * 5)\n            END AS sort_order\n        FROM combined_source c\n    )\n    SELECT\n        of_feed.src_id AS item_id,\n        of_feed.src_type AS item_type,\n        of_feed.src_data AS item_data,\n        of_feed.src_score AS score,\n        of_feed.src_created_at AS created_at\n    FROM ordered_feed of_feed\n    ORDER BY of_feed.sort_order ASC\n    LIMIT p_limit\n    OFFSET p_offset;\nEND;\n$$;\n\n-- 5. PERMISSIONS\nGRANT EXECUTE ON FUNCTION get_user_subjects(UUID) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_user_chapters(UUID) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_user_avg_difficulty(UUID) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_recommended_questions(UUID, INT, INT) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_recommended_users(UUID, INT, INT) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_mixed_feed(UUID, INT, INT) TO authenticated;\n"}	recommendation_system_v3_cast_fix	utkarshweb2023@gmail.com	\N	\N
20260202164731	{"-- MIGRATION 05: RECOMMENDATION SYSTEM (REFINED RATIO & PRACTICE FOCUS)\n-- Purpose: Update feed to a 3:1 ratio and prioritize other users' content for practice.\n\n-- 1. CLEANUP (Drop functions to update signature if needed, though they stay the same)\nDROP FUNCTION IF EXISTS get_mixed_feed(uuid, int, int);\nDROP FUNCTION IF EXISTS get_recommended_users(uuid, int, int);\nDROP FUNCTION IF EXISTS get_recommended_questions(uuid, int, int);\n\n-- 2. CORE RECOMMENDATION FUNCTIONS (Updated for practice focus)\n\nCREATE OR REPLACE FUNCTION get_recommended_questions(\n    p_user_id UUID,\n    p_limit INT DEFAULT 20,\n    p_offset INT DEFAULT 0\n)\nRETURNS TABLE (\n    question_id UUID,\n    question_text TEXT,\n    subject TEXT,\n    chapter TEXT,\n    topics JSONB,\n    difficulty difficulty_enum,\n    popularity INT,\n    created_at TIMESTAMPTZ,\n    image_url TEXT,\n    type question_type_enum,\n    has_diagram BOOLEAN,\n    uploader_user_id UUID,\n    uploader_display_name TEXT,\n    uploader_username TEXT,\n    uploader_avatar_url TEXT,\n    solutions_count BIGINT,\n    is_in_bank BOOLEAN,\n    due_for_review BOOLEAN,\n    score INT\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_user_subjects TEXT[];\n    v_user_chapters TEXT[];\n    v_user_difficulty TEXT;\n    v_followed_users UUID[];\nBEGIN\n    v_user_subjects := get_user_subjects(p_user_id);\n    v_user_chapters := get_user_chapters(p_user_id);\n    v_user_difficulty := get_user_avg_difficulty(p_user_id);\n    \n    SELECT ARRAY(SELECT following_id FROM follows WHERE follower_id = p_user_id) INTO v_followed_users;\n    \n    RETURN QUERY\n    SELECT \n        q.id::UUID AS question_id,\n        q.question_text,\n        q.subject,\n        q.chapter,\n        q.topics,\n        q.difficulty,\n        q.popularity,\n        q.created_at,\n        q.image_url,\n        q.type,\n        q.has_diagram,\n        q.owner_id AS uploader_user_id,\n        up.display_name AS uploader_display_name,\n        up.username AS uploader_username,\n        up.avatar_url AS uploader_avatar_url,\n        (SELECT COUNT(*) FROM solutions s WHERE s.question_id = q.id)::BIGINT AS solutions_count,\n        EXISTS(SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id) AS is_in_bank,\n        COALESCE(EXISTS(SELECT 1 FROM user_question_stats uqs WHERE uqs.user_id = p_user_id AND uqs.question_id = q.id AND uqs.next_review_at <= NOW()), false) AS due_for_review,\n        (\n            -- Scoring Logic (Refined for practice)\n            CASE WHEN q.subject = ANY(v_user_subjects) THEN 30 ELSE 0 END +\n            CASE WHEN q.chapter = ANY(v_user_chapters) THEN 20 ELSE 0 END +\n            CASE WHEN q.owner_id = ANY(v_followed_users) THEN 25 ELSE 0 END +\n            CASE WHEN q.difficulty::TEXT = v_user_difficulty THEN 15 ELSE 0 END +\n            -- Practice bonus: prioritizing others' questions\n            CASE WHEN q.owner_id != p_user_id THEN 20 ELSE 0 END +\n            -- Freshness/Popularity\n            LEAST(q.popularity, 10)::INT +\n            CASE WHEN q.created_at > NOW() - INTERVAL '3 days' THEN 10 ELSE 0 END\n        ) AS score\n    FROM questions q\n    JOIN user_profiles up ON up.user_id = q.owner_id\n    WHERE q.deleted_at IS NULL\n    -- Ensure we emphasize \\"practice\\" - so we don't necessarily want *only* others, but we rank them higher.\n    ORDER BY score DESC, q.created_at DESC\n    LIMIT p_limit OFFSET p_offset;\nEND;\n$$;\n\n-- 3. THE MIXED FEED (Updated for 3:1 ratio)\nCREATE OR REPLACE FUNCTION get_mixed_feed(\n    p_user_id UUID,\n    p_limit INT DEFAULT 20,\n    p_offset INT DEFAULT 0\n)\nRETURNS TABLE (\n    item_id UUID,\n    item_type TEXT,\n    item_data JSONB,\n    score INT,\n    created_at TIMESTAMPTZ\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_question_count INT;\n    v_user_count INT;\nBEGIN\n    -- 3:1 ratio (75% questions, 25% user suggestions)\n    v_question_count := GREATEST(1, floor(p_limit * 0.75));\n    v_user_count := GREATEST(1, floor(p_limit * 0.25));\n\n    RETURN QUERY\n    WITH \n    q_source AS (\n        SELECT \n            rq.question_id::UUID AS src_id,\n            'question'::TEXT AS src_type,\n            jsonb_build_object(\n                'id', rq.question_id,\n                'question_text', rq.question_text,\n                'subject', rq.subject,\n                'chapter', rq.chapter,\n                'difficulty', rq.difficulty,\n                'topics', rq.topics,\n                'popularity', rq.popularity,\n                'image_url', rq.image_url,\n                'type', rq.type,\n                'has_diagram', rq.has_diagram,\n                'solutions_count', rq.solutions_count,\n                'is_in_bank', rq.is_in_bank,\n                'due_for_review', rq.due_for_review,\n                'uploader', jsonb_build_object(\n                    'user_id', rq.uploader_user_id,\n                    'display_name', rq.uploader_display_name,\n                    'username', rq.uploader_username,\n                    'avatar_url', rq.uploader_avatar_url\n                )\n            ) AS src_data,\n            rq.score::INT AS src_score,\n            rq.created_at AS src_created_at,\n            ROW_NUMBER() OVER (ORDER BY rq.score DESC, rq.created_at DESC) AS custom_rn\n        FROM get_recommended_questions(p_user_id, v_question_count + p_offset, 0) rq\n    ),\n    u_source AS (\n        SELECT \n            ru.user_id::UUID AS src_id,\n            'user_suggestion'::TEXT AS src_type,\n            jsonb_build_object(\n                'user_id', ru.user_id,\n                'display_name', ru.display_name,\n                'username', ru.username,\n                'avatar_url', ru.avatar_url,\n                'common_subjects', ru.common_subjects,\n                'mutual_follows_count', ru.mutual_follows_count,\n                'total_questions', ru.total_questions,\n                'total_solutions', ru.total_solutions,\n                'is_following', ru.is_following\n            ) AS src_data,\n            ru.score::INT AS src_score,\n            ru.last_active AS src_created_at,\n            ROW_NUMBER() OVER (ORDER BY ru.score DESC) AS custom_rn\n        FROM get_recommended_users(p_user_id, v_user_count + (p_offset / 3), 0) ru\n    ),\n    combined_source AS (\n        SELECT src_id, src_type, src_data, src_score, src_created_at, custom_rn FROM q_source\n        UNION ALL\n        SELECT src_id, src_type, src_data, src_score, src_created_at, custom_rn FROM u_source\n    ),\n    ordered_feed AS (\n        SELECT\n            c.src_id,\n            c.src_type,\n            c.src_data,\n            c.src_score,\n            c.src_created_at,\n            CASE \n                -- Interleave logic: insert user card after every 3 questions\n                WHEN c.src_type = 'question' THEN c.custom_rn + (c.custom_rn - 1) / 3\n                ELSE (c.custom_rn * 4) -- User suggestions at positions 4, 8, 12...\n            END AS sort_order\n        FROM combined_source c\n    )\n    SELECT\n        of_feed.src_id AS item_id,\n        of_feed.src_type AS item_type,\n        of_feed.src_data AS item_data,\n        of_feed.src_score AS score,\n        of_feed.src_created_at AS created_at\n    FROM ordered_feed of_feed\n    ORDER BY of_feed.sort_order ASC\n    LIMIT p_limit\n    OFFSET p_offset;\nEND;\n$$;\n\n-- Note: get_recommended_users stays as it was (already updated in scratch-rewrite)\n\n-- 4. PERMISSIONS\nGRANT EXECUTE ON FUNCTION get_recommended_questions(UUID, INT, INT) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_mixed_feed(UUID, INT, INT) TO authenticated;\n"}	recommendation_system_3_to_1_ratio	utkarshweb2023@gmail.com	\N	\N
20260202165134	{"-- MIGRATION 05: RECOMMENDATION SYSTEM (COMPLETE RESTORATION)\n-- Fixes RPC error 42883 (function does not exist) by providing full definitions.\n\n-- 1. CLEANUP\nDROP FUNCTION IF EXISTS get_mixed_feed(uuid, int, int);\nDROP FUNCTION IF EXISTS get_recommended_users(uuid, int, int);\nDROP FUNCTION IF EXISTS get_recommended_questions(uuid, int, int);\nDROP FUNCTION IF EXISTS get_user_avg_difficulty(uuid);\nDROP FUNCTION IF EXISTS get_user_chapters(uuid);\nDROP FUNCTION IF EXISTS get_user_subjects(uuid);\n\n-- 2. HELPER FUNCTIONS\nCREATE OR REPLACE FUNCTION get_user_subjects(p_user_id UUID)\nRETURNS TEXT[] LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_subjects TEXT[];\nBEGIN\n    SELECT ARRAY(\n        SELECT DISTINCT unnest FROM (\n            SELECT unnest(COALESCE(up.subjects, ARRAY[]::TEXT[]))\n            FROM user_profiles up\n            WHERE up.user_id = p_user_id\n            UNION\n            SELECT q.subject\n            FROM user_questions uq\n            JOIN questions q ON q.id = uq.question_id\n            WHERE uq.user_id = p_user_id\n            AND q.subject IS NOT NULL\n        ) AS combined_subjects\n    ) INTO v_subjects;\n    \n    RETURN COALESCE(v_subjects, ARRAY[]::TEXT[]);\nEND;\n$$;\n\nCREATE OR REPLACE FUNCTION get_user_chapters(p_user_id UUID)\nRETURNS TEXT[] LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_chapters TEXT[];\nBEGIN\n    SELECT ARRAY(\n        SELECT DISTINCT q.chapter\n        FROM user_questions uq\n        JOIN questions q ON q.id = uq.question_id\n        WHERE uq.user_id = p_user_id\n        AND q.chapter IS NOT NULL\n    ) INTO v_chapters;\n    \n    RETURN COALESCE(v_chapters, ARRAY[]::TEXT[]);\nEND;\n$$;\n\nCREATE OR REPLACE FUNCTION get_user_avg_difficulty(p_user_id UUID)\nRETURNS TEXT LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_avg NUMERIC;\nBEGIN\n    SELECT AVG(CASE \n        WHEN q.difficulty = 'easy' THEN 1\n        WHEN q.difficulty = 'medium' THEN 2\n        WHEN q.difficulty = 'hard' THEN 3\n        WHEN q.difficulty = 'very_hard' THEN 4\n        ELSE 2\n    END) INTO v_avg\n    FROM user_question_stats uqs\n    JOIN questions q ON q.id = uqs.question_id\n    WHERE uqs.user_id = p_user_id\n    AND uqs.solved = true;\n    \n    IF v_avg IS NULL THEN RETURN 'medium';\n    ELSIF v_avg < 1.5 THEN RETURN 'easy';\n    ELSIF v_avg < 2.5 THEN RETURN 'medium';\n    ELSIF v_avg < 3.5 THEN RETURN 'hard';\n    ELSE RETURN 'very_hard';\n    END IF;\nEND;\n$$;\n\n-- 3. CORE RECOMMENDATION FUNCTIONS\n\nCREATE OR REPLACE FUNCTION get_recommended_questions(\n    p_user_id UUID,\n    p_limit INT DEFAULT 20,\n    p_offset INT DEFAULT 0\n)\nRETURNS TABLE (\n    question_id UUID,\n    question_text TEXT,\n    subject TEXT,\n    chapter TEXT,\n    topics JSONB,\n    difficulty difficulty_enum,\n    popularity INT,\n    created_at TIMESTAMPTZ,\n    image_url TEXT,\n    type question_type_enum,\n    has_diagram BOOLEAN,\n    uploader_user_id UUID,\n    uploader_display_name TEXT,\n    uploader_username TEXT,\n    uploader_avatar_url TEXT,\n    solutions_count BIGINT,\n    is_in_bank BOOLEAN,\n    due_for_review BOOLEAN,\n    score INT\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_user_subjects TEXT[];\n    v_user_chapters TEXT[];\n    v_user_difficulty TEXT;\n    v_followed_users UUID[];\nBEGIN\n    v_user_subjects := get_user_subjects(p_user_id);\n    v_user_chapters := get_user_chapters(p_user_id);\n    v_user_difficulty := get_user_avg_difficulty(p_user_id);\n    \n    SELECT ARRAY(SELECT following_id FROM follows WHERE follower_id = p_user_id) INTO v_followed_users;\n    \n    RETURN QUERY\n    SELECT \n        q.id::UUID AS question_id,\n        q.question_text,\n        q.subject,\n        q.chapter,\n        q.topics,\n        q.difficulty,\n        q.popularity,\n        q.created_at,\n        q.image_url,\n        q.type,\n        q.has_diagram,\n        q.owner_id AS uploader_user_id,\n        up.display_name AS uploader_display_name,\n        up.username AS uploader_username,\n        up.avatar_url AS uploader_avatar_url,\n        (SELECT COUNT(*) FROM solutions s WHERE s.question_id = q.id)::BIGINT AS solutions_count,\n        EXISTS(SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id) AS is_in_bank,\n        COALESCE(EXISTS(SELECT 1 FROM user_question_stats uqs WHERE uqs.user_id = p_user_id AND uqs.question_id = q.id AND uqs.next_review_at <= NOW()), false) AS due_for_review,\n        (\n            CASE WHEN q.subject = ANY(v_user_subjects) THEN 30 ELSE 0 END +\n            CASE WHEN q.chapter = ANY(v_user_chapters) THEN 20 ELSE 0 END +\n            CASE WHEN q.owner_id = ANY(v_followed_users) THEN 25 ELSE 0 END +\n            CASE WHEN q.difficulty::TEXT = v_user_difficulty THEN 15 ELSE 0 END +\n            CASE WHEN q.owner_id != p_user_id THEN 20 ELSE 0 END +\n            LEAST(q.popularity, 10)::INT +\n            CASE WHEN q.created_at > NOW() - INTERVAL '3 days' THEN 10 ELSE 0 END\n        ) AS score\n    FROM questions q\n    JOIN user_profiles up ON up.user_id = q.owner_id\n    WHERE q.deleted_at IS NULL\n    ORDER BY score DESC, q.created_at DESC\n    LIMIT p_limit OFFSET p_offset;\nEND;\n$$;\n\nCREATE OR REPLACE FUNCTION get_recommended_users(\n    p_user_id UUID,\n    p_limit INT DEFAULT 10,\n    p_offset INT DEFAULT 0\n)\nRETURNS TABLE (\n    user_id UUID,\n    display_name TEXT,\n    username TEXT,\n    avatar_url TEXT,\n    common_subjects TEXT[],\n    mutual_follows_count BIGINT,\n    total_questions BIGINT,\n    total_solutions BIGINT,\n    is_following BOOLEAN,\n    last_active TIMESTAMPTZ,\n    score INT\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nBEGIN\n    RETURN QUERY\n    SELECT \n        up.user_id,\n        up.display_name,\n        up.username,\n        up.avatar_url,\n        ARRAY[]::TEXT[] AS common_subjects,\n        0::BIGINT AS mutual_follows_count,\n        up.total_uploaded::BIGINT AS total_questions,\n        up.solutions_helped_count::BIGINT AS total_solutions,\n        EXISTS(SELECT 1 FROM follows f WHERE f.follower_id = p_user_id AND f.following_id = up.user_id) AS is_following,\n        up.updated_at AS last_active,\n        10 AS score\n    FROM user_profiles up\n    WHERE up.user_id != p_user_id\n    AND NOT EXISTS (SELECT 1 FROM follows f WHERE f.follower_id = p_user_id AND f.following_id = up.user_id)\n    ORDER BY up.updated_at DESC\n    LIMIT p_limit OFFSET p_offset;\nEND;\n$$;\n\n-- 4. MIXED FEED (3:1 Ratio)\nCREATE OR REPLACE FUNCTION get_mixed_feed(\n    p_user_id UUID,\n    p_limit INT DEFAULT 20,\n    p_offset INT DEFAULT 0\n)\nRETURNS TABLE (\n    item_id UUID,\n    item_type TEXT,\n    item_data JSONB,\n    score INT,\n    created_at TIMESTAMPTZ\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_question_count INT;\n    v_user_count INT;\nBEGIN\n    v_question_count := GREATEST(1, floor(p_limit * 0.75));\n    v_user_count := GREATEST(1, floor(p_limit * 0.25));\n\n    RETURN QUERY\n    WITH \n    q_source AS (\n        SELECT \n            rq.question_id::UUID AS src_id,\n            'question'::TEXT AS src_type,\n            jsonb_build_object(\n                'id', rq.question_id,\n                'question_text', rq.question_text,\n                'subject', rq.subject,\n                'chapter', rq.chapter,\n                'difficulty', rq.difficulty,\n                'uploader', jsonb_build_object(\n                    'user_id', rq.uploader_user_id,\n                    'display_name', rq.uploader_display_name,\n                    'username', rq.uploader_username\n                )\n            ) AS src_data,\n            rq.score::INT AS src_score,\n            rq.created_at AS src_created_at,\n            ROW_NUMBER() OVER (ORDER BY rq.score DESC, rq.created_at DESC) AS custom_rn\n        FROM get_recommended_questions(p_user_id, v_question_count + p_offset, 0) rq\n    ),\n    u_source AS (\n        SELECT \n            ru.user_id::UUID AS src_id,\n            'user_suggestion'::TEXT AS src_type,\n            jsonb_build_object(\n                'user_id', ru.user_id,\n                'display_name', ru.display_name,\n                'username', ru.username,\n                'avatar_url', ru.avatar_url,\n                'is_following', ru.is_following\n            ) AS src_data,\n            ru.score::INT AS src_score,\n            ru.last_active AS src_created_at,\n            ROW_NUMBER() OVER (ORDER BY ru.score DESC) AS custom_rn\n        FROM get_recommended_users(p_user_id, v_user_count + (p_offset / 3), 0) ru\n    ),\n    combined_source AS (\n        SELECT src_id, src_type, src_data, src_score, src_created_at, custom_rn FROM q_source\n        UNION ALL\n        SELECT src_id, src_type, src_data, src_score, src_created_at, custom_rn FROM u_source\n    ),\n    ordered_feed AS (\n        SELECT\n            c.src_id,\n            c.src_type,\n            c.src_data,\n            c.src_score,\n            c.src_created_at,\n            CASE \n                WHEN c.src_type = 'question' THEN c.custom_rn + (c.custom_rn - 1) / 3\n                ELSE (c.custom_rn * 4)\n            END AS sort_order\n        FROM combined_source c\n    )\n    SELECT\n        of_feed.src_id AS item_id,\n        of_feed.src_type AS item_type,\n        of_feed.src_data AS item_data,\n        of_feed.src_score AS score,\n        of_feed.src_created_at AS created_at\n    FROM ordered_feed of_feed\n    ORDER BY of_feed.sort_order ASC\n    LIMIT p_limit\n    OFFSET p_offset;\nEND;\n$$;\n\n-- 5. PERMISSIONS\nGRANT EXECUTE ON FUNCTION get_user_subjects(UUID) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_user_chapters(UUID) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_user_avg_difficulty(UUID) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_recommended_questions(UUID, INT, INT) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_recommended_users(UUID, INT, INT) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_mixed_feed(UUID, INT, INT) TO authenticated;\n"}	restore_all_recommendation_functions	utkarshweb2023@gmail.com	\N	\N
20260202174230	{"-- MIGRATION 06: GLOBAL SEARCH FEATURE\n-- Purpose: Implement fuzzy text search for questions and users, cleaning up unused columns.\n\n-- 1. SCHEMA CLEANUP\nALTER TABLE questions DROP COLUMN IF EXISTS extracted_text;\n\n-- 2. EXTENSION SETUP\nCREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;\n\n-- 3. INDEXING\nCREATE INDEX IF NOT EXISTS idx_questions_text_gin ON questions USING gin (question_text gin_trgm_ops);\nCREATE INDEX IF NOT EXISTS idx_users_username_gin ON user_profiles USING gin (username gin_trgm_ops);\nCREATE INDEX IF NOT EXISTS idx_users_display_name_gin ON user_profiles USING gin (display_name gin_trgm_ops);\n\n-- 4. SEARCH FUNCTIONS\n\n-- Search Questions\nCREATE OR REPLACE FUNCTION search_questions(\n    p_query TEXT,\n    p_user_id UUID,\n    p_limit INT DEFAULT 20,\n    p_offset INT DEFAULT 0\n)\nRETURNS TABLE (\n    question_id UUID,\n    question_text TEXT,\n    subject TEXT,\n    chapter TEXT,\n    topics JSONB,\n    difficulty difficulty_enum,\n    created_at TIMESTAMPTZ,\n    uploader_username TEXT,\n    is_in_bank BOOLEAN,\n    similarity_score DOUBLE PRECISION\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nBEGIN\n    RETURN QUERY\n    SELECT\n        q.id,\n        q.question_text,\n        q.subject,\n        q.chapter,\n        q.topics,\n        q.difficulty,\n        q.created_at,\n        up.username,\n        EXISTS(SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id) AS is_in_bank,\n        similarity(q.question_text, p_query) AS sim_score\n    FROM questions q\n    JOIN user_profiles up ON up.user_id = q.owner_id\n    WHERE \n        q.deleted_at IS NULL\n        AND q.question_text % p_query \n    ORDER BY \n        (EXISTS(SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id)) DESC,\n        sim_score DESC,\n        q.created_at DESC\n    LIMIT p_limit OFFSET p_offset;\nEND;\n$$;\n\n-- Search Users\nCREATE OR REPLACE FUNCTION search_users(\n    p_query TEXT,\n    p_limit INT DEFAULT 10\n)\nRETURNS TABLE (\n    user_id UUID,\n    username TEXT,\n    display_name TEXT,\n    avatar_url TEXT,\n    similarity_score DOUBLE PRECISION\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nBEGIN\n    RETURN QUERY\n    SELECT\n        up.user_id,\n        up.username,\n        up.display_name,\n        up.avatar_url,\n        GREATEST(similarity(up.username, p_query), similarity(up.display_name, p_query)) AS sim_score\n    FROM user_profiles up\n    WHERE \n        (up.username % p_query OR up.display_name % p_query)\n    ORDER BY sim_score DESC\n    LIMIT p_limit;\nEND;\n$$;\n\n-- 5. PERMISSIONS\nGRANT EXECUTE ON FUNCTION search_questions(TEXT, UUID, INT, INT) TO authenticated;\nGRANT EXECUTE ON FUNCTION search_users(TEXT, INT) TO authenticated;\n"}	search_feature_implementation	utkarshweb2023@gmail.com	\N	\N
20260202174515	{"-- MIGRATION 06: GLOBAL SEARCH FEATURE (v2 - Rich Data)\n-- Purpose: Implement fuzzy text search for questions and users, cleaning up unused columns.\n\n-- 1. SCHEMA CLEANUP\nALTER TABLE questions DROP COLUMN IF EXISTS extracted_text;\n\n-- 2. EXTENSION SETUP\nCREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;\n\n-- 3. INDEXING\nCREATE INDEX IF NOT EXISTS idx_questions_text_gin ON questions USING gin (question_text gin_trgm_ops);\nCREATE INDEX IF NOT EXISTS idx_users_username_gin ON user_profiles USING gin (username gin_trgm_ops);\nCREATE INDEX IF NOT EXISTS idx_users_display_name_gin ON user_profiles USING gin (display_name gin_trgm_ops);\n\n-- 4. SEARCH FUNCTIONS\n\n-- Search Questions (Rich Data for QuestionFeedCard)\nDROP FUNCTION IF EXISTS search_questions(TEXT, UUID, INT, INT);\n\nCREATE OR REPLACE FUNCTION search_questions(\n    p_query TEXT,\n    p_user_id UUID,\n    p_limit INT DEFAULT 20,\n    p_offset INT DEFAULT 0\n)\nRETURNS TABLE (\n    question_id UUID,\n    question_text TEXT,\n    subject TEXT,\n    chapter TEXT,\n    topics JSONB,\n    difficulty difficulty_enum,\n    popularity INT,\n    created_at TIMESTAMPTZ,\n    image_url TEXT,\n    type question_type_enum,\n    has_diagram BOOLEAN,\n    uploader_user_id UUID,\n    uploader_display_name TEXT,\n    uploader_username TEXT,\n    uploader_avatar_url TEXT,\n    solutions_count BIGINT,\n    is_in_bank BOOLEAN,\n    due_for_review BOOLEAN,\n    similarity_score DOUBLE PRECISION\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nBEGIN\n    RETURN QUERY\n    SELECT\n        q.id,\n        q.question_text,\n        q.subject,\n        q.chapter,\n        q.topics,\n        q.difficulty,\n        q.popularity,\n        q.created_at,\n        q.image_url,\n        q.type,\n        q.has_diagram,\n        q.owner_id AS uploader_user_id,\n        up.display_name AS uploader_display_name,\n        up.username AS uploader_username,\n        up.avatar_url AS uploader_avatar_url,\n        (SELECT COUNT(*) FROM solutions s WHERE s.question_id = q.id)::BIGINT AS solutions_count,\n        EXISTS(SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id) AS is_in_bank,\n        COALESCE(EXISTS(SELECT 1 FROM user_question_stats uqs WHERE uqs.user_id = p_user_id AND uqs.question_id = q.id AND uqs.next_review_at <= NOW()), false) AS due_for_review,\n        similarity(q.question_text, p_query) AS sim_score\n    FROM questions q\n    JOIN user_profiles up ON up.user_id = q.owner_id\n    WHERE \n        q.deleted_at IS NULL\n        AND q.question_text % p_query \n    ORDER BY \n        (EXISTS(SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id)) DESC,\n        sim_score DESC,\n        q.created_at DESC\n    LIMIT p_limit OFFSET p_offset;\nEND;\n$$;\n\n-- Search Users (Rich Data)\nDROP FUNCTION IF EXISTS search_users(TEXT, INT);\nDROP FUNCTION IF EXISTS search_users(TEXT, UUID, INT);\n\nCREATE OR REPLACE FUNCTION search_users(\n    p_query TEXT,\n    p_viewer_id UUID,\n    p_limit INT DEFAULT 10\n)\nRETURNS TABLE (\n    user_id UUID,\n    username TEXT,\n    display_name TEXT,\n    avatar_url TEXT,\n    common_subjects TEXT[],\n    mutual_follows_count BIGINT,\n    total_questions BIGINT,\n    total_solutions BIGINT,\n    is_following BOOLEAN,\n    similarity_score DOUBLE PRECISION\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nBEGIN\n    RETURN QUERY\n    SELECT\n        up.user_id,\n        up.username,\n        up.display_name,\n        up.avatar_url,\n        ARRAY[]::TEXT[] as common_subjects, \n        0::BIGINT as mutual_follows_count,\n        up.total_uploaded::BIGINT AS total_questions,\n        up.solutions_helped_count::BIGINT AS total_solutions,\n        EXISTS(SELECT 1 FROM follows f WHERE f.follower_id = p_viewer_id AND f.following_id = up.user_id) AS is_following,\n        GREATEST(similarity(up.username, p_query), similarity(up.display_name, p_query)) AS sim_score\n    FROM user_profiles up\n    WHERE \n        (up.username % p_query OR up.display_name % p_query)\n        AND up.user_id != p_viewer_id \n    ORDER BY sim_score DESC\n    LIMIT p_limit;\nEND;\n$$;\n\n-- 5. PERMISSIONS\nGRANT EXECUTE ON FUNCTION search_questions(TEXT, UUID, INT, INT) TO authenticated;\nGRANT EXECUTE ON FUNCTION search_users(TEXT, UUID, INT) TO authenticated;\n"}	search_feature_fix_drop	utkarshweb2023@gmail.com	\N	\N
20260202175403	{"-- MIGRATION 05: RECOMMENDATION SYSTEM (REFINED RATIO & PRACTICE FOCUS & SYNCED PAYLOAD)\n-- Purpose: Sync get_mixed_feed JSON payload with UI requirements and verify solutions counting.\n\n-- Note: We are re-applying the entire migration 05 with the fixed payloads.\n\n-- 1. CLEANUP\nDROP FUNCTION IF EXISTS get_mixed_feed(uuid, int, int);\nDROP FUNCTION IF EXISTS get_recommended_users(uuid, int, int);\nDROP FUNCTION IF EXISTS get_recommended_questions(uuid, int, int);\nDROP FUNCTION IF EXISTS get_user_avg_difficulty(uuid);\nDROP FUNCTION IF EXISTS get_user_chapters(uuid);\nDROP FUNCTION IF EXISTS get_user_subjects(uuid);\n\n-- 2. HELPER FUNCTIONS\nCREATE OR REPLACE FUNCTION get_user_subjects(p_user_id UUID)\nRETURNS TEXT[] LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_subjects TEXT[];\nBEGIN\n    SELECT ARRAY(\n        SELECT DISTINCT unnest FROM (\n            SELECT unnest(COALESCE(up.subjects, ARRAY[]::TEXT[]))\n            FROM user_profiles up\n            WHERE up.user_id = p_user_id\n            UNION\n            SELECT q.subject\n            FROM user_questions uq\n            JOIN questions q ON q.id = uq.question_id\n            WHERE uq.user_id = p_user_id\n            AND q.subject IS NOT NULL\n        ) AS combined_subjects\n    ) INTO v_subjects;\n    \n    RETURN COALESCE(v_subjects, ARRAY[]::TEXT[]);\nEND;\n$$;\n\nCREATE OR REPLACE FUNCTION get_user_chapters(p_user_id UUID)\nRETURNS TEXT[] LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_chapters TEXT[];\nBEGIN\n    SELECT ARRAY(\n        SELECT DISTINCT q.chapter\n        FROM user_questions uq\n        JOIN questions q ON q.id = uq.question_id\n        WHERE uq.user_id = p_user_id\n        AND q.chapter IS NOT NULL\n    ) INTO v_chapters;\n    \n    RETURN COALESCE(v_chapters, ARRAY[]::TEXT[]);\nEND;\n$$;\n\nCREATE OR REPLACE FUNCTION get_user_avg_difficulty(p_user_id UUID)\nRETURNS TEXT LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_avg NUMERIC;\nBEGIN\n    SELECT AVG(CASE \n        WHEN q.difficulty = 'easy' THEN 1\n        WHEN q.difficulty = 'medium' THEN 2\n        WHEN q.difficulty = 'hard' THEN 3\n        WHEN q.difficulty = 'very_hard' THEN 4\n        ELSE 2\n    END) INTO v_avg\n    FROM user_question_stats uqs\n    JOIN questions q ON q.id = uqs.question_id\n    WHERE uqs.user_id = p_user_id\n    AND uqs.solved = true;\n    \n    IF v_avg IS NULL THEN RETURN 'medium';\n    ELSIF v_avg < 1.5 THEN RETURN 'easy';\n    ELSIF v_avg < 2.5 THEN RETURN 'medium';\n    ELSIF v_avg < 3.5 THEN RETURN 'hard';\n    ELSE RETURN 'very_hard';\n    END IF;\nEND;\n$$;\n\n-- 3. CORE RECOMMENDATION FUNCTIONS\n\nCREATE OR REPLACE FUNCTION get_recommended_questions(\n    p_user_id UUID,\n    p_limit INT DEFAULT 20,\n    p_offset INT DEFAULT 0\n)\nRETURNS TABLE (\n    question_id UUID,\n    question_text TEXT,\n    subject TEXT,\n    chapter TEXT,\n    topics JSONB,\n    difficulty difficulty_enum,\n    popularity INT,\n    created_at TIMESTAMPTZ,\n    image_url TEXT,\n    type question_type_enum,\n    has_diagram BOOLEAN,\n    uploader_user_id UUID,\n    uploader_display_name TEXT,\n    uploader_username TEXT,\n    uploader_avatar_url TEXT,\n    solutions_count BIGINT,\n    is_in_bank BOOLEAN,\n    due_for_review BOOLEAN,\n    score INT\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_user_subjects TEXT[];\n    v_user_chapters TEXT[];\n    v_user_difficulty TEXT;\n    v_followed_users UUID[];\nBEGIN\n    v_user_subjects := get_user_subjects(p_user_id);\n    v_user_chapters := get_user_chapters(p_user_id);\n    v_user_difficulty := get_user_avg_difficulty(p_user_id);\n    \n    SELECT ARRAY(SELECT following_id FROM follows WHERE follower_id = p_user_id) INTO v_followed_users;\n    \n    RETURN QUERY\n    SELECT \n        q.id::UUID AS question_id,\n        q.question_text,\n        q.subject,\n        q.chapter,\n        q.topics,\n        q.difficulty,\n        q.popularity,\n        q.created_at,\n        q.image_url,\n        q.type,\n        q.has_diagram,\n        q.owner_id AS uploader_user_id,\n        up.display_name AS uploader_display_name,\n        up.username AS uploader_username,\n        up.avatar_url AS uploader_avatar_url,\n        (SELECT COUNT(*) FROM solutions s WHERE s.question_id = q.id)::BIGINT AS solutions_count,\n        EXISTS(SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id) AS is_in_bank,\n        COALESCE(EXISTS(SELECT 1 FROM user_question_stats uqs WHERE uqs.user_id = p_user_id AND uqs.question_id = q.id AND uqs.next_review_at <= NOW()), false) AS due_for_review,\n        (\n            -- Scoring Logic (Refined for practice)\n            CASE WHEN q.subject = ANY(v_user_subjects) THEN 30 ELSE 0 END +\n            CASE WHEN q.chapter = ANY(v_user_chapters) THEN 20 ELSE 0 END +\n            CASE WHEN q.owner_id = ANY(v_followed_users) THEN 25 ELSE 0 END +\n            CASE WHEN q.difficulty::TEXT = v_user_difficulty THEN 15 ELSE 0 END +\n            -- Practice bonus: prioritizing others' questions\n            CASE WHEN q.owner_id != p_user_id THEN 20 ELSE 0 END +\n            -- Freshness/Popularity\n            LEAST(q.popularity, 10)::INT +\n            CASE WHEN q.created_at > NOW() - INTERVAL '3 days' THEN 10 ELSE 0 END\n        ) AS score\n    FROM questions q\n    JOIN user_profiles up ON up.user_id = q.owner_id\n    WHERE q.deleted_at IS NULL\n    ORDER BY score DESC, q.created_at DESC\n    LIMIT p_limit OFFSET p_offset;\nEND;\n$$;\n\nCREATE OR REPLACE FUNCTION get_recommended_users(\n    p_user_id UUID,\n    p_limit INT DEFAULT 10,\n    p_offset INT DEFAULT 0\n)\nRETURNS TABLE (\n    user_id UUID,\n    display_name TEXT,\n    username TEXT,\n    avatar_url TEXT,\n    common_subjects TEXT[],\n    mutual_follows_count BIGINT,\n    total_questions BIGINT,\n    total_solutions BIGINT,\n    is_following BOOLEAN,\n    last_active TIMESTAMPTZ,\n    score INT\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nBEGIN\n    RETURN QUERY\n    SELECT \n        up.user_id,\n        up.display_name,\n        up.username,\n        up.avatar_url,\n        ARRAY[]::TEXT[] AS common_subjects,\n        0::BIGINT AS mutual_follows_count,\n        up.total_uploaded::BIGINT AS total_questions,\n        up.solutions_helped_count::BIGINT AS total_solutions,\n        EXISTS(SELECT 1 FROM follows f WHERE f.follower_id = p_user_id AND f.following_id = up.user_id) AS is_following,\n        up.updated_at AS last_active,\n        10 AS score\n    FROM user_profiles up\n    WHERE up.user_id != p_user_id\n    AND NOT EXISTS (SELECT 1 FROM follows f WHERE f.follower_id = p_user_id AND f.following_id = up.user_id)\n    ORDER BY up.updated_at DESC\n    LIMIT p_limit OFFSET p_offset;\nEND;\n$$;\n\n-- 4. MIXED FEED (3:1 Ratio)\nCREATE OR REPLACE FUNCTION get_mixed_feed(\n    p_user_id UUID,\n    p_limit INT DEFAULT 20,\n    p_offset INT DEFAULT 0\n)\nRETURNS TABLE (\n    item_id UUID,\n    item_type TEXT,\n    item_data JSONB,\n    score INT,\n    created_at TIMESTAMPTZ\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n    v_question_count INT;\n    v_user_count INT;\nBEGIN\n    -- 3:1 ratio\n    v_question_count := GREATEST(1, floor(p_limit * 0.75));\n    v_user_count := GREATEST(1, floor(p_limit * 0.25));\n\n    RETURN QUERY\n    WITH \n    q_source AS (\n        SELECT \n            rq.question_id::UUID AS src_id,\n            'question'::TEXT AS src_type,\n            jsonb_build_object(\n                'id', rq.question_id,\n                'question_text', rq.question_text,\n                'subject', rq.subject,\n                'chapter', rq.chapter,\n                'topics', rq.topics,\n                'difficulty', rq.difficulty,\n                'created_at', rq.created_at,\n                'image_url', rq.image_url,\n                'solutions_count', rq.solutions_count,\n                'is_in_bank', rq.is_in_bank,\n                'due_for_review', rq.due_for_review,\n                'uploader', jsonb_build_object(\n                    'user_id', rq.uploader_user_id,\n                    'display_name', rq.uploader_display_name,\n                    'username', rq.uploader_username,\n                    'avatar_url', rq.uploader_avatar_url\n                )\n            ) AS src_data,\n            rq.score::INT AS src_score,\n            rq.created_at AS src_created_at,\n            ROW_NUMBER() OVER (ORDER BY rq.score DESC, rq.created_at DESC) AS custom_rn\n        FROM get_recommended_questions(p_user_id, v_question_count + p_offset, 0) rq\n    ),\n    u_source AS (\n        SELECT \n            ru.user_id::UUID AS src_id,\n            'user_suggestion'::TEXT AS src_type,\n            jsonb_build_object(\n                'user_id', ru.user_id,\n                'display_name', ru.display_name,\n                'username', ru.username,\n                'avatar_url', ru.avatar_url,\n                'total_questions', ru.total_questions,\n                'total_solutions', ru.total_solutions,\n                'is_following', ru.is_following,\n                'mutual_follows_count', ru.mutual_follows_count,\n                'common_subjects', ru.common_subjects\n            ) AS src_data,\n            ru.score::INT AS src_score,\n            ru.last_active AS src_created_at,\n            ROW_NUMBER() OVER (ORDER BY ru.score DESC) AS custom_rn\n        FROM get_recommended_users(p_user_id, v_user_count + (p_offset / 3), 0) ru\n    ),\n    combined_source AS (\n        SELECT src_id, src_type, src_data, src_score, src_created_at, custom_rn FROM q_source\n        UNION ALL\n        SELECT src_id, src_type, src_data, src_score, src_created_at, custom_rn FROM u_source\n    ),\n    ordered_feed AS (\n        SELECT\n            c.src_id,\n            c.src_type,\n            c.src_data,\n            c.src_score,\n            c.src_created_at,\n            CASE \n                WHEN c.src_type = 'question' THEN c.custom_rn + (c.custom_rn - 1) / 3\n                ELSE (c.custom_rn * 4)\n            END AS sort_order\n        FROM combined_source c\n    )\n    SELECT\n        of_feed.src_id AS item_id,\n        of_feed.src_type AS item_type,\n        of_feed.src_data AS item_data,\n        of_feed.src_score AS score,\n        of_feed.src_created_at AS created_at\n    FROM ordered_feed of_feed\n    ORDER BY of_feed.sort_order ASC\n    LIMIT p_limit\n    OFFSET p_offset;\nEND;\n$$;\n\n-- 5. PERMISSIONS\nGRANT EXECUTE ON FUNCTION get_user_subjects(UUID) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_user_chapters(UUID) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_user_avg_difficulty(UUID) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_recommended_questions(UUID, INT, INT) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_recommended_users(UUID, INT, INT) TO authenticated;\nGRANT EXECUTE ON FUNCTION get_mixed_feed(UUID, INT, INT) TO authenticated;\n"}	fix_mixed_feed_payload_and_verified_solutions_count	utkarshweb2023@gmail.com	\N	\N
20260202180601	{"-- MIGRATION 06: GLOBAL SEARCH FEATURE (v3 - Type Fixes)\n-- Purpose: Implement fuzzy text search for questions and users with strict type casting to avoid RPC errors.\n\n-- 1. SCHEMA CLEANUP\nALTER TABLE questions DROP COLUMN IF EXISTS extracted_text;\n\n-- 2. EXTENSION SETUP\nCREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;\n\n-- 3. INDEXING\nCREATE INDEX IF NOT EXISTS idx_questions_text_gin ON questions USING gin (question_text gin_trgm_ops);\nCREATE INDEX IF NOT EXISTS idx_users_username_gin ON user_profiles USING gin (username gin_trgm_ops);\nCREATE INDEX IF NOT EXISTS idx_users_display_name_gin ON user_profiles USING gin (display_name gin_trgm_ops);\n\n-- 4. SEARCH FUNCTIONS\n\n-- Search Questions (Rich Data for QuestionFeedCard)\nDROP FUNCTION IF EXISTS search_questions(TEXT, UUID, INT, INT);\n\nCREATE OR REPLACE FUNCTION search_questions(\n    p_query TEXT,\n    p_user_id UUID,\n    p_limit INT DEFAULT 20,\n    p_offset INT DEFAULT 0\n)\nRETURNS TABLE (\n    question_id UUID,\n    question_text TEXT,\n    subject TEXT,\n    chapter TEXT,\n    topics JSONB,\n    difficulty difficulty_enum,\n    popularity INT,\n    created_at TIMESTAMPTZ,\n    image_url TEXT,\n    type question_type_enum,\n    has_diagram BOOLEAN,\n    uploader_user_id UUID,\n    uploader_display_name TEXT,\n    uploader_username TEXT,\n    uploader_avatar_url TEXT,\n    solutions_count BIGINT,\n    is_in_bank BOOLEAN,\n    due_for_review BOOLEAN,\n    similarity_score DOUBLE PRECISION\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nBEGIN\n    RETURN QUERY\n    SELECT\n        q.id::UUID, -- Explicit cast to UUID\n        q.question_text,\n        q.subject,\n        q.chapter,\n        q.topics,\n        q.difficulty,\n        q.popularity,\n        q.created_at,\n        q.image_url,\n        q.type,\n        q.has_diagram,\n        q.owner_id AS uploader_user_id,\n        up.display_name AS uploader_display_name,\n        up.username AS uploader_username,\n        up.avatar_url AS uploader_avatar_url,\n        (SELECT COUNT(*) FROM solutions s WHERE s.question_id = q.id)::BIGINT AS solutions_count,\n        EXISTS(SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id) AS is_in_bank,\n        COALESCE(EXISTS(SELECT 1 FROM user_question_stats uqs WHERE uqs.user_id = p_user_id AND uqs.question_id = q.id AND uqs.next_review_at <= NOW()), false) AS due_for_review,\n        similarity(q.question_text, p_query)::DOUBLE PRECISION AS sim_score -- Explicit cast to DOUBLE PRECISION\n    FROM questions q\n    JOIN user_profiles up ON up.user_id = q.owner_id\n    WHERE \n        q.deleted_at IS NULL\n        AND q.question_text % p_query \n    ORDER BY \n        (EXISTS(SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id)) DESC,\n        sim_score DESC,\n        q.created_at DESC\n    LIMIT p_limit OFFSET p_offset;\nEND;\n$$;\n\n-- Search Users (Rich Data)\nDROP FUNCTION IF EXISTS search_users(TEXT, INT);\nDROP FUNCTION IF EXISTS search_users(TEXT, UUID, INT);\n\nCREATE OR REPLACE FUNCTION search_users(\n    p_query TEXT,\n    p_viewer_id UUID,\n    p_limit INT DEFAULT 10\n)\nRETURNS TABLE (\n    user_id UUID,\n    username TEXT,\n    display_name TEXT,\n    avatar_url TEXT,\n    common_subjects TEXT[],\n    mutual_follows_count BIGINT,\n    total_questions BIGINT,\n    total_solutions BIGINT,\n    is_following BOOLEAN,\n    similarity_score DOUBLE PRECISION\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nBEGIN\n    RETURN QUERY\n    SELECT\n        up.user_id::UUID, -- Explicit cast to UUID\n        up.username,\n        up.display_name,\n        up.avatar_url,\n        ARRAY[]::TEXT[] as common_subjects, \n        0::BIGINT as mutual_follows_count,\n        up.total_uploaded::BIGINT AS total_questions,\n        up.solutions_helped_count::BIGINT AS total_solutions,\n        EXISTS(SELECT 1 FROM follows f WHERE f.follower_id = p_viewer_id AND f.following_id = up.user_id) AS is_following,\n        GREATEST(similarity(up.username, p_query), similarity(up.display_name, p_query))::DOUBLE PRECISION AS sim_score -- Explicit cast to DOUBLE PRECISION\n    FROM user_profiles up\n    WHERE \n        (up.username % p_query OR up.display_name % p_query)\n        AND up.user_id != p_viewer_id \n    ORDER BY sim_score DESC\n    LIMIT p_limit;\nEND;\n$$;\n\n-- 5. PERMISSIONS\nGRANT EXECUTE ON FUNCTION search_questions(TEXT, UUID, INT, INT) TO authenticated;\nGRANT EXECUTE ON FUNCTION search_users(TEXT, UUID, INT) TO authenticated;\n"}	search_type_fixes_dev	utkarshweb2023@gmail.com	\N	\N
20260202181330	{"-- MIGRATION 06: GLOBAL SEARCH FEATURE (v4 - UI & Logic Fixes)\n-- Purpose: \n-- 1. Combine fuzzy search (%) with partial match (ILIKE) for better recall.\n-- 2. Ensure explicit type casting (UUID/DOUBLE PRECISION).\n\n-- RE-APPLY SEARCH FUNCTIONS\n\n-- Search Questions\nDROP FUNCTION IF EXISTS search_questions(TEXT, UUID, INT, INT);\n\nCREATE OR REPLACE FUNCTION search_questions(\n    p_query TEXT,\n    p_user_id UUID,\n    p_limit INT DEFAULT 20,\n    p_offset INT DEFAULT 0\n)\nRETURNS TABLE (\n    question_id UUID,\n    question_text TEXT,\n    subject TEXT,\n    chapter TEXT,\n    topics JSONB,\n    difficulty difficulty_enum,\n    popularity INT,\n    created_at TIMESTAMPTZ,\n    image_url TEXT,\n    type question_type_enum,\n    has_diagram BOOLEAN,\n    uploader_user_id UUID,\n    uploader_display_name TEXT,\n    uploader_username TEXT,\n    uploader_avatar_url TEXT,\n    solutions_count BIGINT,\n    is_in_bank BOOLEAN,\n    due_for_review BOOLEAN,\n    similarity_score DOUBLE PRECISION\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nBEGIN\n    RETURN QUERY\n    SELECT\n        q.id::UUID,\n        q.question_text,\n        q.subject,\n        q.chapter,\n        q.topics,\n        q.difficulty,\n        q.popularity,\n        q.created_at,\n        q.image_url,\n        q.type,\n        q.has_diagram,\n        q.owner_id AS uploader_user_id,\n        up.display_name AS uploader_display_name,\n        up.username AS uploader_username,\n        up.avatar_url AS uploader_avatar_url,\n        (SELECT COUNT(*) FROM solutions s WHERE s.question_id = q.id)::BIGINT AS solutions_count,\n        EXISTS(SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id) AS is_in_bank,\n        COALESCE(EXISTS(SELECT 1 FROM user_question_stats uqs WHERE uqs.user_id = p_user_id AND uqs.question_id = q.id AND uqs.next_review_at <= NOW()), false) AS due_for_review,\n        similarity(q.question_text, p_query)::DOUBLE PRECISION AS sim_score\n    FROM questions q\n    JOIN user_profiles up ON up.user_id = q.owner_id\n    WHERE \n        q.deleted_at IS NULL\n        AND (\n            q.question_text % p_query \n            OR \n            q.question_text ILIKE '%' || p_query || '%'\n        )\n    ORDER BY \n        (EXISTS(SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id)) DESC,\n        sim_score DESC,\n        q.created_at DESC\n    LIMIT p_limit OFFSET p_offset;\nEND;\n$$;\n\n-- Search Users\nDROP FUNCTION IF EXISTS search_users(TEXT, INT);\nDROP FUNCTION IF EXISTS search_users(TEXT, UUID, INT);\n\nCREATE OR REPLACE FUNCTION search_users(\n    p_query TEXT,\n    p_viewer_id UUID,\n    p_limit INT DEFAULT 10\n)\nRETURNS TABLE (\n    user_id UUID,\n    username TEXT,\n    display_name TEXT,\n    avatar_url TEXT,\n    common_subjects TEXT[],\n    mutual_follows_count BIGINT,\n    total_questions BIGINT,\n    total_solutions BIGINT,\n    is_following BOOLEAN,\n    similarity_score DOUBLE PRECISION\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nBEGIN\n    RETURN QUERY\n    SELECT\n        up.user_id::UUID,\n        up.username,\n        up.display_name,\n        up.avatar_url,\n        ARRAY[]::TEXT[] as common_subjects, \n        0::BIGINT as mutual_follows_count,\n        up.total_uploaded::BIGINT AS total_questions,\n        up.solutions_helped_count::BIGINT AS total_solutions,\n        EXISTS(SELECT 1 FROM follows f WHERE f.follower_id = p_viewer_id AND f.following_id = up.user_id) AS is_following,\n        GREATEST(similarity(up.username, p_query), similarity(up.display_name, p_query))::DOUBLE PRECISION AS sim_score\n    FROM user_profiles up\n    WHERE \n        (\n            up.username % p_query \n            OR up.display_name % p_query\n            OR up.username ILIKE '%' || p_query || '%'\n            OR up.display_name ILIKE '%' || p_query || '%'\n        )\n        AND up.user_id != p_viewer_id \n    ORDER BY sim_score DESC\n    LIMIT p_limit;\nEND;\n$$;\n\nGRANT EXECUTE ON FUNCTION search_questions(TEXT, UUID, INT, INT) TO authenticated;\nGRANT EXECUTE ON FUNCTION search_users(TEXT, UUID, INT) TO authenticated;\n"}	search_ui_and_logic_fixes_dev	utkarshweb2023@gmail.com	\N	\N
20260202182444	{"-- MIGRATION 06: GLOBAL SEARCH FEATURE (v5 - Chapter & Topic Support)\n\n-- RE-APPLY SEARCH FUNCTIONS\n\n-- Search Questions\nDROP FUNCTION IF EXISTS search_questions(TEXT, UUID, INT, INT);\n\nCREATE OR REPLACE FUNCTION search_questions(\n    p_query TEXT,\n    p_user_id UUID,\n    p_limit INT DEFAULT 20,\n    p_offset INT DEFAULT 0\n)\nRETURNS TABLE (\n    question_id UUID,\n    question_text TEXT,\n    subject TEXT,\n    chapter TEXT,\n    topics JSONB,\n    difficulty difficulty_enum,\n    popularity INT,\n    created_at TIMESTAMPTZ,\n    image_url TEXT,\n    type question_type_enum,\n    has_diagram BOOLEAN,\n    uploader_user_id UUID,\n    uploader_display_name TEXT,\n    uploader_username TEXT,\n    uploader_avatar_url TEXT,\n    solutions_count BIGINT,\n    is_in_bank BOOLEAN,\n    due_for_review BOOLEAN,\n    similarity_score DOUBLE PRECISION\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nBEGIN\n    RETURN QUERY\n    SELECT\n        q.id::UUID,\n        q.question_text,\n        q.subject,\n        q.chapter,\n        q.topics,\n        q.difficulty,\n        q.popularity,\n        q.created_at,\n        q.image_url,\n        q.type,\n        q.has_diagram,\n        q.owner_id AS uploader_user_id,\n        up.display_name AS uploader_display_name,\n        up.username AS uploader_username,\n        up.avatar_url AS uploader_avatar_url,\n        (SELECT COUNT(*) FROM solutions s WHERE s.question_id = q.id)::BIGINT AS solutions_count,\n        EXISTS(SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id) AS is_in_bank,\n        COALESCE(EXISTS(SELECT 1 FROM user_question_stats uqs WHERE uqs.user_id = p_user_id AND uqs.question_id = q.id AND uqs.next_review_at <= NOW()), false) AS due_for_review,\n        similarity(q.question_text, p_query)::DOUBLE PRECISION AS sim_score\n    FROM questions q\n    JOIN user_profiles up ON up.user_id = q.owner_id\n    WHERE \n        q.deleted_at IS NULL\n        AND (\n            q.question_text % p_query \n            OR q.question_text ILIKE '%' || p_query || '%'\n            OR q.chapter % p_query\n            OR q.chapter ILIKE '%' || p_query || '%'\n            OR q.topics::text ILIKE '%' || p_query || '%'\n        )\n    ORDER BY \n        (EXISTS(SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id)) DESC,\n        sim_score DESC,\n        q.created_at DESC\n    LIMIT p_limit OFFSET p_offset;\nEND;\n$$;\n\nGRANT EXECUTE ON FUNCTION search_questions(TEXT, UUID, INT, INT) TO authenticated;\n"}	search_chapter_topic_dev	utkarshweb2023@gmail.com	\N	\N
20260202183237	{"-- MIGRATION 06: GLOBAL SEARCH FEATURE (v6 - Explore Suggestions)\n\n-- Explore Questions (For empty search state)\nDROP FUNCTION IF EXISTS get_explore_questions(UUID, INT);\n\nCREATE OR REPLACE FUNCTION get_explore_questions(\n    p_user_id UUID,\n    p_limit INT DEFAULT 6\n)\nRETURNS TABLE (\n    question_id UUID,\n    question_text TEXT,\n    subject TEXT,\n    chapter TEXT,\n    topics JSONB,\n    difficulty difficulty_enum,\n    popularity INT,\n    created_at TIMESTAMPTZ,\n    image_url TEXT,\n    type question_type_enum,\n    has_diagram BOOLEAN,\n    uploader_user_id UUID,\n    uploader_display_name TEXT,\n    uploader_username TEXT,\n    uploader_avatar_url TEXT,\n    solutions_count BIGINT,\n    is_in_bank BOOLEAN,\n    due_for_review BOOLEAN,\n    similarity_score DOUBLE PRECISION\n) LANGUAGE plpgsql SECURITY DEFINER AS $$\nBEGIN\n    RETURN QUERY\n    SELECT\n        q.id::UUID,\n        q.question_text,\n        q.subject,\n        q.chapter,\n        q.topics,\n        q.difficulty,\n        q.popularity,\n        q.created_at,\n        q.image_url,\n        q.type,\n        q.has_diagram,\n        q.owner_id AS uploader_user_id,\n        up.display_name AS uploader_display_name,\n        up.username AS uploader_username,\n        up.avatar_url AS uploader_avatar_url,\n        (SELECT COUNT(*) FROM solutions s WHERE s.question_id = q.id)::BIGINT AS solutions_count,\n        FALSE AS is_in_bank, -- By definition, these are not in bank\n        FALSE AS due_for_review,\n        0::DOUBLE PRECISION AS sim_score\n    FROM questions q\n    JOIN user_profiles up ON up.user_id = q.owner_id\n    WHERE \n        q.deleted_at IS NULL\n        AND q.owner_id != p_user_id -- Exclude own questions\n        AND NOT EXISTS (SELECT 1 FROM user_questions uq WHERE uq.user_id = p_user_id AND uq.question_id = q.id)\n    ORDER BY \n        q.popularity DESC, \n        q.created_at DESC\n    LIMIT p_limit;\nEND;\n$$;\n\nGRANT EXECUTE ON FUNCTION get_explore_questions(UUID, INT) TO authenticated;\n"}	explore_questions_dev	utkarshweb2023@gmail.com	\N	\N
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 64, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: follows follows_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (follower_id, following_id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: revise_later revise_later_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revise_later
    ADD CONSTRAINT revise_later_pkey PRIMARY KEY (id);


--
-- Name: solution_likes solution_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solution_likes
    ADD CONSTRAINT solution_likes_pkey PRIMARY KEY (id);


--
-- Name: solutions solutions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT solutions_pkey PRIMARY KEY (id);


--
-- Name: syllabus syllabus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.syllabus
    ADD CONSTRAINT syllabus_pkey PRIMARY KEY (id);


--
-- Name: user_profiles unique_user_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT unique_user_id UNIQUE (user_id);


--
-- Name: user_questions unique_user_question; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_questions
    ADD CONSTRAINT unique_user_question UNIQUE (user_id, question_id);


--
-- Name: user_question_stats unique_user_question_stats; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_question_stats
    ADD CONSTRAINT unique_user_question_stats UNIQUE (user_id, question_id);


--
-- Name: revise_later unique_user_revise_later; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revise_later
    ADD CONSTRAINT unique_user_revise_later UNIQUE (user_id, question_id);


--
-- Name: solution_likes unique_user_solution_like; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solution_likes
    ADD CONSTRAINT unique_user_solution_like UNIQUE (user_id, solution_id);


--
-- Name: user_activities user_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_activities
    ADD CONSTRAINT user_activities_pkey PRIMARY KEY (id);


--
-- Name: user_profiles user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (id);


--
-- Name: user_profiles user_profiles_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_username_key UNIQUE (username);


--
-- Name: user_question_stats user_question_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_question_stats
    ADD CONSTRAINT user_question_stats_pkey PRIMARY KEY (id);


--
-- Name: user_questions user_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_questions
    ADD CONSTRAINT user_questions_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_01_31 messages_2026_01_31_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_01_31
    ADD CONSTRAINT messages_2026_01_31_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_02_01 messages_2026_02_01_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_02_01
    ADD CONSTRAINT messages_2026_02_01_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_02_02 messages_2026_02_02_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_02_02
    ADD CONSTRAINT messages_2026_02_02_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_02_03 messages_2026_02_03_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_02_03
    ADD CONSTRAINT messages_2026_02_03_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_02_04 messages_2026_02_04_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_02_04
    ADD CONSTRAINT messages_2026_02_04_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_02_05 messages_2026_02_05_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_02_05
    ADD CONSTRAINT messages_2026_02_05_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_02_06 messages_2026_02_06_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_02_06
    ADD CONSTRAINT messages_2026_02_06_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: prefixes prefixes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (bucket_id, level, name);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_idempotency_key_key; Type: CONSTRAINT; Schema: supabase_migrations; Owner: postgres
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_idempotency_key_key UNIQUE (idempotency_key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: postgres
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: idx_follows_mutual; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_follows_mutual ON public.follows USING btree (following_id, follower_id);


--
-- Name: idx_notifications_recipient; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_recipient ON public.notifications USING btree (recipient_id);


--
-- Name: idx_notifications_unread; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_unread ON public.notifications USING btree (recipient_id) WHERE (is_read = false);


--
-- Name: idx_questions_chapter; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_questions_chapter ON public.questions USING btree (chapter);


--
-- Name: idx_questions_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_questions_deleted_at ON public.questions USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: idx_questions_difficulty; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_questions_difficulty ON public.questions USING btree (difficulty);


--
-- Name: idx_questions_embedding; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_questions_embedding ON public.questions USING hnsw (embedding public.vector_cosine_ops) WITH (m='16', ef_construction='64');


--
-- Name: INDEX idx_questions_embedding; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.idx_questions_embedding IS 'HNSW index for cosine similarity search on embeddings';


--
-- Name: idx_questions_owner_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_questions_owner_id ON public.questions USING btree (owner_id);


--
-- Name: idx_questions_owner_id_user_profiles; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_questions_owner_id_user_profiles ON public.questions USING btree (owner_id);


--
-- Name: idx_questions_popularity; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_questions_popularity ON public.questions USING btree (popularity DESC);


--
-- Name: idx_questions_subject; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_questions_subject ON public.questions USING btree (subject);


--
-- Name: idx_questions_subject_chapter; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_questions_subject_chapter ON public.questions USING btree (subject, chapter);


--
-- Name: idx_questions_subject_chapter_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_questions_subject_chapter_created ON public.questions USING btree (subject, chapter, created_at DESC) WHERE (deleted_at IS NULL);


--
-- Name: idx_questions_text_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_questions_text_gin ON public.questions USING gin (question_text public.gin_trgm_ops);


--
-- Name: idx_questions_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_questions_type ON public.questions USING btree (type);


--
-- Name: idx_revise_later_question_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_revise_later_question_id ON public.revise_later USING btree (question_id);


--
-- Name: idx_revise_later_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_revise_later_user_id ON public.revise_later USING btree (user_id);


--
-- Name: idx_solution_likes_solution_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_solution_likes_solution_id ON public.solution_likes USING btree (solution_id);


--
-- Name: idx_solution_likes_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_solution_likes_user_id ON public.solution_likes USING btree (user_id);


--
-- Name: idx_solutions_contributor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_solutions_contributor_id ON public.solutions USING btree (contributor_id);


--
-- Name: idx_solutions_contributor_id_user_profiles; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_solutions_contributor_id_user_profiles ON public.solutions USING btree (contributor_id);


--
-- Name: idx_solutions_is_ai_best; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_solutions_is_ai_best ON public.solutions USING btree (is_ai_best) WHERE (is_ai_best = true);


--
-- Name: idx_solutions_likes; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_solutions_likes ON public.solutions USING btree (likes DESC);


--
-- Name: idx_solutions_question_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_solutions_question_id ON public.solutions USING btree (question_id);


--
-- Name: idx_syllabus_class; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_syllabus_class ON public.syllabus USING btree (class);


--
-- Name: idx_syllabus_subject; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_syllabus_subject ON public.syllabus USING btree (subject);


--
-- Name: idx_syllabus_subject_chapter; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_syllabus_subject_chapter ON public.syllabus USING btree (subject, chapter);


--
-- Name: idx_syllabus_verified; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_syllabus_verified ON public.syllabus USING btree (is_verified) WHERE (is_verified = true);


--
-- Name: idx_user_activities_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_activities_created_at ON public.user_activities USING btree (created_at DESC);


--
-- Name: idx_user_activities_user_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_activities_user_created ON public.user_activities USING btree (user_id, created_at DESC);


--
-- Name: idx_user_activities_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_activities_user_id ON public.user_activities USING btree (user_id);


--
-- Name: idx_user_profiles_subjects; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_profiles_subjects ON public.user_profiles USING gin (subjects);


--
-- Name: idx_user_profiles_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_profiles_user_id ON public.user_profiles USING btree (user_id);


--
-- Name: idx_user_profiles_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_profiles_username ON public.user_profiles USING btree (username);


--
-- Name: idx_user_question_stats_failed; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_question_stats_failed ON public.user_question_stats USING btree (user_id, failed) WHERE (failed = true);


--
-- Name: idx_user_question_stats_next_review; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_question_stats_next_review ON public.user_question_stats USING btree (user_id, next_review_at) WHERE (next_review_at IS NOT NULL);


--
-- Name: idx_user_question_stats_question_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_question_stats_question_id ON public.user_question_stats USING btree (question_id);


--
-- Name: idx_user_question_stats_review_due; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_question_stats_review_due ON public.user_question_stats USING btree (user_id, next_review_at) WHERE (next_review_at IS NOT NULL);


--
-- Name: idx_user_question_stats_revise_later; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_question_stats_revise_later ON public.user_question_stats USING btree (user_id, in_revise_later) WHERE (in_revise_later = true);


--
-- Name: idx_user_question_stats_solved; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_question_stats_solved ON public.user_question_stats USING btree (user_id, solved) WHERE (solved = true);


--
-- Name: idx_user_question_stats_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_question_stats_user_id ON public.user_question_stats USING btree (user_id);


--
-- Name: idx_user_questions_is_owner; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_questions_is_owner ON public.user_questions USING btree (user_id, is_owner) WHERE (is_owner = true);


--
-- Name: idx_user_questions_question_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_questions_question_id ON public.user_questions USING btree (question_id);


--
-- Name: idx_user_questions_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_questions_user_id ON public.user_questions USING btree (user_id);


--
-- Name: idx_users_display_name_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_display_name_gin ON public.user_profiles USING gin (display_name public.gin_trgm_ops);


--
-- Name: idx_users_username_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_username_gin ON public.user_profiles USING gin (username public.gin_trgm_ops);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_01_31_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_01_31_inserted_at_topic_idx ON realtime.messages_2026_01_31 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_02_01_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_02_01_inserted_at_topic_idx ON realtime.messages_2026_02_01 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_02_02_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_02_02_inserted_at_topic_idx ON realtime.messages_2026_02_02 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_02_03_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_02_03_inserted_at_topic_idx ON realtime.messages_2026_02_03 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_02_04_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_02_04_inserted_at_topic_idx ON realtime.messages_2026_02_04 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_02_05_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_02_05_inserted_at_topic_idx ON realtime.messages_2026_02_05 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_02_06_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_02_06_inserted_at_topic_idx ON realtime.messages_2026_02_06 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_name_bucket_level_unique; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_name_bucket_level_unique ON storage.objects USING btree (name COLLATE "C", bucket_id, level);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_lower_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_lower_name ON storage.objects USING btree ((path_tokens[level]), lower(name) text_pattern_ops, bucket_id, level);


--
-- Name: idx_prefixes_lower_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_prefixes_lower_name ON storage.prefixes USING btree (bucket_id, level, ((string_to_array(name, '/'::text))[level]), lower(name) text_pattern_ops);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: objects_bucket_id_level_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX objects_bucket_id_level_idx ON storage.objects USING btree (bucket_id, level, name COLLATE "C");


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: messages_2026_01_31_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_01_31_inserted_at_topic_idx;


--
-- Name: messages_2026_01_31_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_01_31_pkey;


--
-- Name: messages_2026_02_01_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_02_01_inserted_at_topic_idx;


--
-- Name: messages_2026_02_01_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_02_01_pkey;


--
-- Name: messages_2026_02_02_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_02_02_inserted_at_topic_idx;


--
-- Name: messages_2026_02_02_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_02_02_pkey;


--
-- Name: messages_2026_02_03_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_02_03_inserted_at_topic_idx;


--
-- Name: messages_2026_02_03_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_02_03_pkey;


--
-- Name: messages_2026_02_04_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_02_04_inserted_at_topic_idx;


--
-- Name: messages_2026_02_04_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_02_04_pkey;


--
-- Name: messages_2026_02_05_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_02_05_inserted_at_topic_idx;


--
-- Name: messages_2026_02_05_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_02_05_pkey;


--
-- Name: messages_2026_02_06_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_02_06_inserted_at_topic_idx;


--
-- Name: messages_2026_02_06_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_02_06_pkey;


--
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- Name: user_question_stats tr_log_solve_activity; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tr_log_solve_activity AFTER INSERT OR UPDATE ON public.user_question_stats FOR EACH ROW EXECUTE FUNCTION public.log_user_activity();


--
-- Name: questions tr_stats_questions; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tr_stats_questions AFTER INSERT OR DELETE ON public.questions FOR EACH ROW EXECUTE FUNCTION public.trigger_recalc_stats();


--
-- Name: solutions tr_stats_solutions; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tr_stats_solutions AFTER INSERT OR DELETE ON public.solutions FOR EACH ROW EXECUTE FUNCTION public.trigger_recalc_stats();


--
-- Name: questions trg_cleanup_activities_on_question_delete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_cleanup_activities_on_question_delete AFTER DELETE ON public.questions FOR EACH ROW EXECUTE FUNCTION public.cleanup_activities_on_question_delete();


--
-- Name: user_questions trg_decrement_popularity_on_unlink; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_decrement_popularity_on_unlink AFTER DELETE ON public.user_questions FOR EACH ROW EXECUTE FUNCTION public.decrement_question_popularity();


--
-- Name: user_questions trg_increment_popularity_on_link; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_increment_popularity_on_link AFTER INSERT ON public.user_questions FOR EACH ROW EXECUTE FUNCTION public.increment_question_popularity();


--
-- Name: questions trg_log_activity_questions; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_log_activity_questions AFTER INSERT OR DELETE OR UPDATE ON public.questions FOR EACH ROW EXECUTE FUNCTION public.log_user_activity();


--
-- Name: solutions trg_log_activity_solutions; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_log_activity_solutions AFTER INSERT OR UPDATE ON public.solutions FOR EACH ROW EXECUTE FUNCTION public.log_user_activity();


--
-- Name: user_questions trg_log_activity_user_questions; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_log_activity_user_questions AFTER INSERT ON public.user_questions FOR EACH ROW EXECUTE FUNCTION public.log_user_activity();


--
-- Name: solutions trg_notify_on_contribution; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_notify_on_contribution AFTER INSERT ON public.solutions FOR EACH ROW EXECUTE FUNCTION public.notify_on_contribution();


--
-- Name: follows trg_notify_on_follow; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_notify_on_follow AFTER INSERT ON public.follows FOR EACH ROW EXECUTE FUNCTION public.notify_on_follow();


--
-- Name: user_questions trg_notify_on_link; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_notify_on_link AFTER INSERT ON public.user_questions FOR EACH ROW EXECUTE FUNCTION public.notify_on_link();


--
-- Name: solution_likes trg_notify_on_solution_like; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_notify_on_solution_like AFTER INSERT ON public.solution_likes FOR EACH ROW EXECUTE FUNCTION public.notify_on_solution_like();


--
-- Name: revise_later trg_sync_revise_later_delete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_sync_revise_later_delete AFTER DELETE ON public.revise_later FOR EACH ROW EXECUTE FUNCTION public.sync_revise_later_delete_to_stats();


--
-- Name: revise_later trg_sync_revise_later_insert; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_sync_revise_later_insert AFTER INSERT ON public.revise_later FOR EACH ROW EXECUTE FUNCTION public.sync_revise_later_to_stats();


--
-- Name: questions update_questions_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_questions_updated_at BEFORE UPDATE ON public.questions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: solutions update_solutions_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_solutions_updated_at BEFORE UPDATE ON public.solutions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: user_profiles update_user_profiles_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_user_profiles_updated_at BEFORE UPDATE ON public.user_profiles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: user_question_stats update_user_question_stats_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_user_question_stats_updated_at BEFORE UPDATE ON public.user_question_stats FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: objects objects_delete_delete_prefix; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_delete_delete_prefix AFTER DELETE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- Name: objects objects_insert_create_prefix; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_insert_create_prefix BEFORE INSERT ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.objects_insert_prefix_trigger();


--
-- Name: objects objects_update_create_prefix; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_update_create_prefix BEFORE UPDATE ON storage.objects FOR EACH ROW WHEN (((new.name <> old.name) OR (new.bucket_id <> old.bucket_id))) EXECUTE FUNCTION storage.objects_update_prefix_trigger();


--
-- Name: prefixes prefixes_create_hierarchy; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER prefixes_create_hierarchy BEFORE INSERT ON storage.prefixes FOR EACH ROW WHEN ((pg_trigger_depth() < 1)) EXECUTE FUNCTION storage.prefixes_insert_trigger();


--
-- Name: prefixes prefixes_delete_hierarchy; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER prefixes_delete_hierarchy AFTER DELETE ON storage.prefixes FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: follows follows_follower_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES public.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: follows follows_following_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_following_id_fkey FOREIGN KEY (following_id) REFERENCES public.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: notifications notifications_recipient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_recipient_id_fkey FOREIGN KEY (recipient_id) REFERENCES public.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: notifications notifications_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: questions questions_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: questions questions_owner_id_user_profiles_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_owner_id_user_profiles_fkey FOREIGN KEY (owner_id) REFERENCES public.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: CONSTRAINT questions_owner_id_user_profiles_fkey ON questions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON CONSTRAINT questions_owner_id_user_profiles_fkey ON public.questions IS 'Enables author:user_profiles!owner_id joins';


--
-- Name: revise_later revise_later_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revise_later
    ADD CONSTRAINT revise_later_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- Name: revise_later revise_later_user_id_user_profiles_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revise_later
    ADD CONSTRAINT revise_later_user_id_user_profiles_fkey FOREIGN KEY (user_id) REFERENCES public.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: solution_likes solution_likes_solution_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solution_likes
    ADD CONSTRAINT solution_likes_solution_id_fkey FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_likes solution_likes_user_id_user_profiles_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solution_likes
    ADD CONSTRAINT solution_likes_user_id_user_profiles_fkey FOREIGN KEY (user_id) REFERENCES public.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: solutions solutions_contributor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT solutions_contributor_id_fkey FOREIGN KEY (contributor_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: solutions solutions_contributor_id_user_profiles_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT solutions_contributor_id_user_profiles_fkey FOREIGN KEY (contributor_id) REFERENCES public.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: CONSTRAINT solutions_contributor_id_user_profiles_fkey ON solutions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON CONSTRAINT solutions_contributor_id_user_profiles_fkey ON public.solutions IS 'Enables author:user_profiles!contributor_id joins';


--
-- Name: solutions solutions_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT solutions_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- Name: user_activities user_activities_user_id_user_profiles_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_activities
    ADD CONSTRAINT user_activities_user_id_user_profiles_fkey FOREIGN KEY (user_id) REFERENCES public.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: user_profiles user_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: user_question_stats user_question_stats_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_question_stats
    ADD CONSTRAINT user_question_stats_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- Name: user_question_stats user_question_stats_user_id_user_profiles_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_question_stats
    ADD CONSTRAINT user_question_stats_user_id_user_profiles_fkey FOREIGN KEY (user_id) REFERENCES public.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: user_questions user_questions_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_questions
    ADD CONSTRAINT user_questions_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- Name: user_questions user_questions_user_id_user_profiles_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_questions
    ADD CONSTRAINT user_questions_user_id_user_profiles_fkey FOREIGN KEY (user_id) REFERENCES public.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: prefixes prefixes_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT "prefixes_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: follows Anyone can view follows; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view follows" ON public.follows FOR SELECT USING (true);


--
-- Name: questions Authenticated users can insert questions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can insert questions" ON public.questions FOR INSERT WITH CHECK ((( SELECT auth.uid() AS uid) = owner_id));


--
-- Name: syllabus Authenticated users can view syllabus; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view syllabus" ON public.syllabus FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: solutions Contributors can delete their solutions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Contributors can delete their solutions" ON public.solutions FOR DELETE USING ((( SELECT auth.uid() AS uid) = contributor_id));


--
-- Name: solutions Contributors can update their solutions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Contributors can update their solutions" ON public.solutions FOR UPDATE USING ((( SELECT auth.uid() AS uid) = contributor_id));


--
-- Name: solution_likes Likes are viewable by everyone; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Likes are viewable by everyone" ON public.solution_likes FOR SELECT USING (true);


--
-- Name: questions Owners can delete their questions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Owners can delete their questions" ON public.questions FOR DELETE USING ((( SELECT auth.uid() AS uid) = owner_id));


--
-- Name: questions Owners can update their questions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Owners can update their questions" ON public.questions FOR UPDATE USING (((( SELECT auth.uid() AS uid) = owner_id) AND (deleted_at IS NULL)));


--
-- Name: user_profiles Profiles are viewable by everyone; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Profiles are viewable by everyone" ON public.user_profiles FOR SELECT USING (true);


--
-- Name: questions Questions are viewable by everyone; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Questions are viewable by everyone" ON public.questions FOR SELECT USING ((deleted_at IS NULL));


--
-- Name: solutions Solutions are viewable by everyone; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Solutions are viewable by everyone" ON public.solutions FOR SELECT USING (true);


--
-- Name: user_activities System can insert activities; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "System can insert activities" ON public.user_activities FOR INSERT WITH CHECK ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: revise_later Users can delete from their own revise list; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete from their own revise list" ON public.revise_later FOR DELETE USING ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: solution_likes Users can delete their own likes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete their own likes" ON public.solution_likes FOR DELETE USING ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: user_questions Users can delete their own question links; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete their own question links" ON public.user_questions FOR DELETE USING ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: follows Users can follow others; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can follow others" ON public.follows FOR INSERT WITH CHECK ((auth.uid() = follower_id));


--
-- Name: revise_later Users can insert into their own revise list; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert into their own revise list" ON public.revise_later FOR INSERT WITH CHECK ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: user_profiles Users can insert own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert own profile" ON public.user_profiles FOR INSERT TO authenticated WITH CHECK ((user_id = auth.uid()));


--
-- Name: solution_likes Users can insert their own likes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own likes" ON public.solution_likes FOR INSERT WITH CHECK ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: user_profiles Users can insert their own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own profile" ON public.user_profiles FOR INSERT WITH CHECK ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: user_questions Users can insert their own question links; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own question links" ON public.user_questions FOR INSERT WITH CHECK ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: solutions Users can insert their own solutions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own solutions" ON public.solutions FOR INSERT WITH CHECK ((( SELECT auth.uid() AS uid) = contributor_id));


--
-- Name: user_question_stats Users can insert their own stats; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own stats" ON public.user_question_stats FOR INSERT WITH CHECK ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: follows Users can unfollow; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can unfollow" ON public.follows FOR DELETE USING ((auth.uid() = follower_id));


--
-- Name: user_profiles Users can update their own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update their own profile" ON public.user_profiles FOR UPDATE USING ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: user_question_stats Users can update their own stats; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update their own stats" ON public.user_question_stats FOR UPDATE USING ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: user_questions Users can view their own question links; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view their own question links" ON public.user_questions FOR SELECT USING ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: revise_later Users can view their own revise list; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view their own revise list" ON public.revise_later FOR SELECT USING ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: user_question_stats Users can view their own stats; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view their own stats" ON public.user_question_stats FOR SELECT USING ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: notifications Users update their own notifications; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users update their own notifications" ON public.notifications FOR UPDATE USING ((auth.uid() = recipient_id));


--
-- Name: notifications Users view their own notifications; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users view their own notifications" ON public.notifications FOR SELECT USING ((auth.uid() = recipient_id));


--
-- Name: follows; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.follows ENABLE ROW LEVEL SECURITY;

--
-- Name: notifications; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

--
-- Name: questions; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;

--
-- Name: revise_later; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.revise_later ENABLE ROW LEVEL SECURITY;

--
-- Name: solution_likes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.solution_likes ENABLE ROW LEVEL SECURITY;

--
-- Name: solutions; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.solutions ENABLE ROW LEVEL SECURITY;

--
-- Name: syllabus; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.syllabus ENABLE ROW LEVEL SECURITY;

--
-- Name: user_activities; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.user_activities ENABLE ROW LEVEL SECURITY;

--
-- Name: user_activities user_activities_read_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY user_activities_read_policy ON public.user_activities FOR SELECT USING (true);


--
-- Name: user_profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: user_question_stats; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.user_question_stats ENABLE ROW LEVEL SECURITY;

--
-- Name: user_questions; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.user_questions ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: objects Allow authenticated deletes from question-images; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Allow authenticated deletes from question-images" ON storage.objects FOR DELETE TO authenticated USING ((bucket_id = 'question-images'::text));


--
-- Name: objects Allow authenticated reads from question-images; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Allow authenticated reads from question-images" ON storage.objects FOR SELECT TO authenticated USING ((bucket_id = 'question-images'::text));


--
-- Name: objects Allow authenticated uploads to question-images; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Allow authenticated uploads to question-images" ON storage.objects FOR INSERT TO authenticated WITH CHECK ((bucket_id = 'question-images'::text));


--
-- Name: objects Allow public reads from question-images; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Allow public reads from question-images" ON storage.objects FOR SELECT TO anon USING ((bucket_id = 'question-images'::text));


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: prefixes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.prefixes ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: supabase_realtime_messages_publication; Type: PUBLICATION; Schema: -; Owner: supabase_admin
--

CREATE PUBLICATION supabase_realtime_messages_publication WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime_messages_publication OWNER TO supabase_admin;

--
-- Name: supabase_realtime_messages_publication messages; Type: PUBLICATION TABLE; Schema: realtime; Owner: supabase_admin
--

ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE ONLY realtime.messages;


--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION gtrgm_in(cstring); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_in(cstring) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_in(cstring) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_in(cstring) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_in(cstring) TO service_role;


--
-- Name: FUNCTION gtrgm_out(public.gtrgm); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_out(public.gtrgm) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_out(public.gtrgm) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_out(public.gtrgm) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_out(public.gtrgm) TO service_role;


--
-- Name: FUNCTION halfvec_in(cstring, oid, integer); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_in(cstring, oid, integer) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_in(cstring, oid, integer) TO anon;
GRANT ALL ON FUNCTION public.halfvec_in(cstring, oid, integer) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_in(cstring, oid, integer) TO service_role;


--
-- Name: FUNCTION halfvec_out(public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_out(public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_out(public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.halfvec_out(public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_out(public.halfvec) TO service_role;


--
-- Name: FUNCTION halfvec_recv(internal, oid, integer); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_recv(internal, oid, integer) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_recv(internal, oid, integer) TO anon;
GRANT ALL ON FUNCTION public.halfvec_recv(internal, oid, integer) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_recv(internal, oid, integer) TO service_role;


--
-- Name: FUNCTION halfvec_send(public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_send(public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_send(public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.halfvec_send(public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_send(public.halfvec) TO service_role;


--
-- Name: FUNCTION halfvec_typmod_in(cstring[]); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_typmod_in(cstring[]) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_typmod_in(cstring[]) TO anon;
GRANT ALL ON FUNCTION public.halfvec_typmod_in(cstring[]) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_typmod_in(cstring[]) TO service_role;


--
-- Name: FUNCTION sparsevec_in(cstring, oid, integer); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.sparsevec_in(cstring, oid, integer) TO postgres;
GRANT ALL ON FUNCTION public.sparsevec_in(cstring, oid, integer) TO anon;
GRANT ALL ON FUNCTION public.sparsevec_in(cstring, oid, integer) TO authenticated;
GRANT ALL ON FUNCTION public.sparsevec_in(cstring, oid, integer) TO service_role;


--
-- Name: FUNCTION sparsevec_out(public.sparsevec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.sparsevec_out(public.sparsevec) TO postgres;
GRANT ALL ON FUNCTION public.sparsevec_out(public.sparsevec) TO anon;
GRANT ALL ON FUNCTION public.sparsevec_out(public.sparsevec) TO authenticated;
GRANT ALL ON FUNCTION public.sparsevec_out(public.sparsevec) TO service_role;


--
-- Name: FUNCTION sparsevec_recv(internal, oid, integer); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.sparsevec_recv(internal, oid, integer) TO postgres;
GRANT ALL ON FUNCTION public.sparsevec_recv(internal, oid, integer) TO anon;
GRANT ALL ON FUNCTION public.sparsevec_recv(internal, oid, integer) TO authenticated;
GRANT ALL ON FUNCTION public.sparsevec_recv(internal, oid, integer) TO service_role;


--
-- Name: FUNCTION sparsevec_send(public.sparsevec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.sparsevec_send(public.sparsevec) TO postgres;
GRANT ALL ON FUNCTION public.sparsevec_send(public.sparsevec) TO anon;
GRANT ALL ON FUNCTION public.sparsevec_send(public.sparsevec) TO authenticated;
GRANT ALL ON FUNCTION public.sparsevec_send(public.sparsevec) TO service_role;


--
-- Name: FUNCTION sparsevec_typmod_in(cstring[]); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.sparsevec_typmod_in(cstring[]) TO postgres;
GRANT ALL ON FUNCTION public.sparsevec_typmod_in(cstring[]) TO anon;
GRANT ALL ON FUNCTION public.sparsevec_typmod_in(cstring[]) TO authenticated;
GRANT ALL ON FUNCTION public.sparsevec_typmod_in(cstring[]) TO service_role;


--
-- Name: FUNCTION vector_in(cstring, oid, integer); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_in(cstring, oid, integer) TO postgres;
GRANT ALL ON FUNCTION public.vector_in(cstring, oid, integer) TO anon;
GRANT ALL ON FUNCTION public.vector_in(cstring, oid, integer) TO authenticated;
GRANT ALL ON FUNCTION public.vector_in(cstring, oid, integer) TO service_role;


--
-- Name: FUNCTION vector_out(public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_out(public.vector) TO postgres;
GRANT ALL ON FUNCTION public.vector_out(public.vector) TO anon;
GRANT ALL ON FUNCTION public.vector_out(public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.vector_out(public.vector) TO service_role;


--
-- Name: FUNCTION vector_recv(internal, oid, integer); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_recv(internal, oid, integer) TO postgres;
GRANT ALL ON FUNCTION public.vector_recv(internal, oid, integer) TO anon;
GRANT ALL ON FUNCTION public.vector_recv(internal, oid, integer) TO authenticated;
GRANT ALL ON FUNCTION public.vector_recv(internal, oid, integer) TO service_role;


--
-- Name: FUNCTION vector_send(public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_send(public.vector) TO postgres;
GRANT ALL ON FUNCTION public.vector_send(public.vector) TO anon;
GRANT ALL ON FUNCTION public.vector_send(public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.vector_send(public.vector) TO service_role;


--
-- Name: FUNCTION vector_typmod_in(cstring[]); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_typmod_in(cstring[]) TO postgres;
GRANT ALL ON FUNCTION public.vector_typmod_in(cstring[]) TO anon;
GRANT ALL ON FUNCTION public.vector_typmod_in(cstring[]) TO authenticated;
GRANT ALL ON FUNCTION public.vector_typmod_in(cstring[]) TO service_role;


--
-- Name: FUNCTION array_to_halfvec(real[], integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.array_to_halfvec(real[], integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.array_to_halfvec(real[], integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.array_to_halfvec(real[], integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.array_to_halfvec(real[], integer, boolean) TO service_role;


--
-- Name: FUNCTION array_to_sparsevec(real[], integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.array_to_sparsevec(real[], integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.array_to_sparsevec(real[], integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.array_to_sparsevec(real[], integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.array_to_sparsevec(real[], integer, boolean) TO service_role;


--
-- Name: FUNCTION array_to_vector(real[], integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.array_to_vector(real[], integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.array_to_vector(real[], integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.array_to_vector(real[], integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.array_to_vector(real[], integer, boolean) TO service_role;


--
-- Name: FUNCTION array_to_halfvec(double precision[], integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.array_to_halfvec(double precision[], integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.array_to_halfvec(double precision[], integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.array_to_halfvec(double precision[], integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.array_to_halfvec(double precision[], integer, boolean) TO service_role;


--
-- Name: FUNCTION array_to_sparsevec(double precision[], integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.array_to_sparsevec(double precision[], integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.array_to_sparsevec(double precision[], integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.array_to_sparsevec(double precision[], integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.array_to_sparsevec(double precision[], integer, boolean) TO service_role;


--
-- Name: FUNCTION array_to_vector(double precision[], integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.array_to_vector(double precision[], integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.array_to_vector(double precision[], integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.array_to_vector(double precision[], integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.array_to_vector(double precision[], integer, boolean) TO service_role;


--
-- Name: FUNCTION array_to_halfvec(integer[], integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.array_to_halfvec(integer[], integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.array_to_halfvec(integer[], integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.array_to_halfvec(integer[], integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.array_to_halfvec(integer[], integer, boolean) TO service_role;


--
-- Name: FUNCTION array_to_sparsevec(integer[], integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.array_to_sparsevec(integer[], integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.array_to_sparsevec(integer[], integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.array_to_sparsevec(integer[], integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.array_to_sparsevec(integer[], integer, boolean) TO service_role;


--
-- Name: FUNCTION array_to_vector(integer[], integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.array_to_vector(integer[], integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.array_to_vector(integer[], integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.array_to_vector(integer[], integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.array_to_vector(integer[], integer, boolean) TO service_role;


--
-- Name: FUNCTION array_to_halfvec(numeric[], integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.array_to_halfvec(numeric[], integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.array_to_halfvec(numeric[], integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.array_to_halfvec(numeric[], integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.array_to_halfvec(numeric[], integer, boolean) TO service_role;


--
-- Name: FUNCTION array_to_sparsevec(numeric[], integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.array_to_sparsevec(numeric[], integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.array_to_sparsevec(numeric[], integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.array_to_sparsevec(numeric[], integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.array_to_sparsevec(numeric[], integer, boolean) TO service_role;


--
-- Name: FUNCTION array_to_vector(numeric[], integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.array_to_vector(numeric[], integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.array_to_vector(numeric[], integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.array_to_vector(numeric[], integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.array_to_vector(numeric[], integer, boolean) TO service_role;


--
-- Name: FUNCTION halfvec_to_float4(public.halfvec, integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_to_float4(public.halfvec, integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_to_float4(public.halfvec, integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.halfvec_to_float4(public.halfvec, integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_to_float4(public.halfvec, integer, boolean) TO service_role;


--
-- Name: FUNCTION halfvec(public.halfvec, integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec(public.halfvec, integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.halfvec(public.halfvec, integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.halfvec(public.halfvec, integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec(public.halfvec, integer, boolean) TO service_role;


--
-- Name: FUNCTION halfvec_to_sparsevec(public.halfvec, integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_to_sparsevec(public.halfvec, integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_to_sparsevec(public.halfvec, integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.halfvec_to_sparsevec(public.halfvec, integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_to_sparsevec(public.halfvec, integer, boolean) TO service_role;


--
-- Name: FUNCTION halfvec_to_vector(public.halfvec, integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_to_vector(public.halfvec, integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_to_vector(public.halfvec, integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.halfvec_to_vector(public.halfvec, integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_to_vector(public.halfvec, integer, boolean) TO service_role;


--
-- Name: FUNCTION sparsevec_to_halfvec(public.sparsevec, integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.sparsevec_to_halfvec(public.sparsevec, integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.sparsevec_to_halfvec(public.sparsevec, integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.sparsevec_to_halfvec(public.sparsevec, integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.sparsevec_to_halfvec(public.sparsevec, integer, boolean) TO service_role;


--
-- Name: FUNCTION sparsevec(public.sparsevec, integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.sparsevec(public.sparsevec, integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.sparsevec(public.sparsevec, integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.sparsevec(public.sparsevec, integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.sparsevec(public.sparsevec, integer, boolean) TO service_role;


--
-- Name: FUNCTION sparsevec_to_vector(public.sparsevec, integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.sparsevec_to_vector(public.sparsevec, integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.sparsevec_to_vector(public.sparsevec, integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.sparsevec_to_vector(public.sparsevec, integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.sparsevec_to_vector(public.sparsevec, integer, boolean) TO service_role;


--
-- Name: FUNCTION vector_to_float4(public.vector, integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_to_float4(public.vector, integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.vector_to_float4(public.vector, integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.vector_to_float4(public.vector, integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.vector_to_float4(public.vector, integer, boolean) TO service_role;


--
-- Name: FUNCTION vector_to_halfvec(public.vector, integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_to_halfvec(public.vector, integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.vector_to_halfvec(public.vector, integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.vector_to_halfvec(public.vector, integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.vector_to_halfvec(public.vector, integer, boolean) TO service_role;


--
-- Name: FUNCTION vector_to_sparsevec(public.vector, integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_to_sparsevec(public.vector, integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.vector_to_sparsevec(public.vector, integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.vector_to_sparsevec(public.vector, integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.vector_to_sparsevec(public.vector, integer, boolean) TO service_role;


--
-- Name: FUNCTION vector(public.vector, integer, boolean); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector(public.vector, integer, boolean) TO postgres;
GRANT ALL ON FUNCTION public.vector(public.vector, integer, boolean) TO anon;
GRANT ALL ON FUNCTION public.vector(public.vector, integer, boolean) TO authenticated;
GRANT ALL ON FUNCTION public.vector(public.vector, integer, boolean) TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION pg_reload_conf(); Type: ACL; Schema: pg_catalog; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pg_catalog.pg_reload_conf() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION binary_quantize(public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.binary_quantize(public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.binary_quantize(public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.binary_quantize(public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.binary_quantize(public.halfvec) TO service_role;


--
-- Name: FUNCTION binary_quantize(public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.binary_quantize(public.vector) TO postgres;
GRANT ALL ON FUNCTION public.binary_quantize(public.vector) TO anon;
GRANT ALL ON FUNCTION public.binary_quantize(public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.binary_quantize(public.vector) TO service_role;


--
-- Name: FUNCTION cleanup_activities_on_question_delete(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cleanup_activities_on_question_delete() TO anon;
GRANT ALL ON FUNCTION public.cleanup_activities_on_question_delete() TO authenticated;
GRANT ALL ON FUNCTION public.cleanup_activities_on_question_delete() TO service_role;


--
-- Name: FUNCTION cosine_distance(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.cosine_distance(public.halfvec, public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.cosine_distance(public.halfvec, public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.cosine_distance(public.halfvec, public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.cosine_distance(public.halfvec, public.halfvec) TO service_role;


--
-- Name: FUNCTION cosine_distance(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.cosine_distance(public.sparsevec, public.sparsevec) TO postgres;
GRANT ALL ON FUNCTION public.cosine_distance(public.sparsevec, public.sparsevec) TO anon;
GRANT ALL ON FUNCTION public.cosine_distance(public.sparsevec, public.sparsevec) TO authenticated;
GRANT ALL ON FUNCTION public.cosine_distance(public.sparsevec, public.sparsevec) TO service_role;


--
-- Name: FUNCTION cosine_distance(public.vector, public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.cosine_distance(public.vector, public.vector) TO postgres;
GRANT ALL ON FUNCTION public.cosine_distance(public.vector, public.vector) TO anon;
GRANT ALL ON FUNCTION public.cosine_distance(public.vector, public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.cosine_distance(public.vector, public.vector) TO service_role;


--
-- Name: FUNCTION decrement_question_popularity(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.decrement_question_popularity() TO anon;
GRANT ALL ON FUNCTION public.decrement_question_popularity() TO authenticated;
GRANT ALL ON FUNCTION public.decrement_question_popularity() TO service_role;


--
-- Name: FUNCTION get_explore_questions(p_user_id uuid, p_limit integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_explore_questions(p_user_id uuid, p_limit integer) TO anon;
GRANT ALL ON FUNCTION public.get_explore_questions(p_user_id uuid, p_limit integer) TO authenticated;
GRANT ALL ON FUNCTION public.get_explore_questions(p_user_id uuid, p_limit integer) TO service_role;


--
-- Name: FUNCTION get_mixed_feed(p_user_id uuid, p_limit integer, p_offset integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_mixed_feed(p_user_id uuid, p_limit integer, p_offset integer) TO anon;
GRANT ALL ON FUNCTION public.get_mixed_feed(p_user_id uuid, p_limit integer, p_offset integer) TO authenticated;
GRANT ALL ON FUNCTION public.get_mixed_feed(p_user_id uuid, p_limit integer, p_offset integer) TO service_role;


--
-- Name: FUNCTION get_other_users_count(q_id text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_other_users_count(q_id text) TO anon;
GRANT ALL ON FUNCTION public.get_other_users_count(q_id text) TO authenticated;
GRANT ALL ON FUNCTION public.get_other_users_count(q_id text) TO service_role;


--
-- Name: FUNCTION get_recommended_questions(p_user_id uuid, p_limit integer, p_offset integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_recommended_questions(p_user_id uuid, p_limit integer, p_offset integer) TO anon;
GRANT ALL ON FUNCTION public.get_recommended_questions(p_user_id uuid, p_limit integer, p_offset integer) TO authenticated;
GRANT ALL ON FUNCTION public.get_recommended_questions(p_user_id uuid, p_limit integer, p_offset integer) TO service_role;


--
-- Name: FUNCTION get_recommended_users(p_user_id uuid, p_limit integer, p_offset integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_recommended_users(p_user_id uuid, p_limit integer, p_offset integer) TO anon;
GRANT ALL ON FUNCTION public.get_recommended_users(p_user_id uuid, p_limit integer, p_offset integer) TO authenticated;
GRANT ALL ON FUNCTION public.get_recommended_users(p_user_id uuid, p_limit integer, p_offset integer) TO service_role;


--
-- Name: FUNCTION get_user_avg_difficulty(p_user_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_user_avg_difficulty(p_user_id uuid) TO anon;
GRANT ALL ON FUNCTION public.get_user_avg_difficulty(p_user_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_user_avg_difficulty(p_user_id uuid) TO service_role;


--
-- Name: FUNCTION get_user_chapters(p_user_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_user_chapters(p_user_id uuid) TO anon;
GRANT ALL ON FUNCTION public.get_user_chapters(p_user_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_user_chapters(p_user_id uuid) TO service_role;


--
-- Name: FUNCTION get_user_subjects(p_user_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_user_subjects(p_user_id uuid) TO anon;
GRANT ALL ON FUNCTION public.get_user_subjects(p_user_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_user_subjects(p_user_id uuid) TO service_role;


--
-- Name: FUNCTION gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal) TO postgres;
GRANT ALL ON FUNCTION public.gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal) TO anon;
GRANT ALL ON FUNCTION public.gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal) TO authenticated;
GRANT ALL ON FUNCTION public.gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal) TO service_role;


--
-- Name: FUNCTION gin_extract_value_trgm(text, internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gin_extract_value_trgm(text, internal) TO postgres;
GRANT ALL ON FUNCTION public.gin_extract_value_trgm(text, internal) TO anon;
GRANT ALL ON FUNCTION public.gin_extract_value_trgm(text, internal) TO authenticated;
GRANT ALL ON FUNCTION public.gin_extract_value_trgm(text, internal) TO service_role;


--
-- Name: FUNCTION gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal) TO postgres;
GRANT ALL ON FUNCTION public.gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal) TO anon;
GRANT ALL ON FUNCTION public.gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal) TO authenticated;
GRANT ALL ON FUNCTION public.gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal) TO service_role;


--
-- Name: FUNCTION gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal) TO postgres;
GRANT ALL ON FUNCTION public.gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal) TO anon;
GRANT ALL ON FUNCTION public.gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal) TO authenticated;
GRANT ALL ON FUNCTION public.gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal) TO service_role;


--
-- Name: FUNCTION gtrgm_compress(internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_compress(internal) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_compress(internal) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_compress(internal) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_compress(internal) TO service_role;


--
-- Name: FUNCTION gtrgm_consistent(internal, text, smallint, oid, internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_consistent(internal, text, smallint, oid, internal) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_consistent(internal, text, smallint, oid, internal) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_consistent(internal, text, smallint, oid, internal) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_consistent(internal, text, smallint, oid, internal) TO service_role;


--
-- Name: FUNCTION gtrgm_decompress(internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_decompress(internal) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_decompress(internal) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_decompress(internal) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_decompress(internal) TO service_role;


--
-- Name: FUNCTION gtrgm_distance(internal, text, smallint, oid, internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_distance(internal, text, smallint, oid, internal) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_distance(internal, text, smallint, oid, internal) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_distance(internal, text, smallint, oid, internal) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_distance(internal, text, smallint, oid, internal) TO service_role;


--
-- Name: FUNCTION gtrgm_options(internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_options(internal) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_options(internal) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_options(internal) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_options(internal) TO service_role;


--
-- Name: FUNCTION gtrgm_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_penalty(internal, internal, internal) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_penalty(internal, internal, internal) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_penalty(internal, internal, internal) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_penalty(internal, internal, internal) TO service_role;


--
-- Name: FUNCTION gtrgm_picksplit(internal, internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_picksplit(internal, internal) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_picksplit(internal, internal) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_picksplit(internal, internal) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_picksplit(internal, internal) TO service_role;


--
-- Name: FUNCTION gtrgm_same(public.gtrgm, public.gtrgm, internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_same(public.gtrgm, public.gtrgm, internal) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_same(public.gtrgm, public.gtrgm, internal) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_same(public.gtrgm, public.gtrgm, internal) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_same(public.gtrgm, public.gtrgm, internal) TO service_role;


--
-- Name: FUNCTION gtrgm_union(internal, internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_union(internal, internal) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_union(internal, internal) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_union(internal, internal) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_union(internal, internal) TO service_role;


--
-- Name: FUNCTION halfvec_accum(double precision[], public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_accum(double precision[], public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_accum(double precision[], public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.halfvec_accum(double precision[], public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_accum(double precision[], public.halfvec) TO service_role;


--
-- Name: FUNCTION halfvec_add(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_add(public.halfvec, public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_add(public.halfvec, public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.halfvec_add(public.halfvec, public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_add(public.halfvec, public.halfvec) TO service_role;


--
-- Name: FUNCTION halfvec_avg(double precision[]); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_avg(double precision[]) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_avg(double precision[]) TO anon;
GRANT ALL ON FUNCTION public.halfvec_avg(double precision[]) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_avg(double precision[]) TO service_role;


--
-- Name: FUNCTION halfvec_cmp(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_cmp(public.halfvec, public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_cmp(public.halfvec, public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.halfvec_cmp(public.halfvec, public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_cmp(public.halfvec, public.halfvec) TO service_role;


--
-- Name: FUNCTION halfvec_combine(double precision[], double precision[]); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_combine(double precision[], double precision[]) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_combine(double precision[], double precision[]) TO anon;
GRANT ALL ON FUNCTION public.halfvec_combine(double precision[], double precision[]) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_combine(double precision[], double precision[]) TO service_role;


--
-- Name: FUNCTION halfvec_concat(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_concat(public.halfvec, public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_concat(public.halfvec, public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.halfvec_concat(public.halfvec, public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_concat(public.halfvec, public.halfvec) TO service_role;


--
-- Name: FUNCTION halfvec_eq(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_eq(public.halfvec, public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_eq(public.halfvec, public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.halfvec_eq(public.halfvec, public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_eq(public.halfvec, public.halfvec) TO service_role;


--
-- Name: FUNCTION halfvec_ge(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_ge(public.halfvec, public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_ge(public.halfvec, public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.halfvec_ge(public.halfvec, public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_ge(public.halfvec, public.halfvec) TO service_role;


--
-- Name: FUNCTION halfvec_gt(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_gt(public.halfvec, public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_gt(public.halfvec, public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.halfvec_gt(public.halfvec, public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_gt(public.halfvec, public.halfvec) TO service_role;


--
-- Name: FUNCTION halfvec_l2_squared_distance(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_l2_squared_distance(public.halfvec, public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_l2_squared_distance(public.halfvec, public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.halfvec_l2_squared_distance(public.halfvec, public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_l2_squared_distance(public.halfvec, public.halfvec) TO service_role;


--
-- Name: FUNCTION halfvec_le(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_le(public.halfvec, public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_le(public.halfvec, public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.halfvec_le(public.halfvec, public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_le(public.halfvec, public.halfvec) TO service_role;


--
-- Name: FUNCTION halfvec_lt(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_lt(public.halfvec, public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_lt(public.halfvec, public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.halfvec_lt(public.halfvec, public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_lt(public.halfvec, public.halfvec) TO service_role;


--
-- Name: FUNCTION halfvec_mul(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_mul(public.halfvec, public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_mul(public.halfvec, public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.halfvec_mul(public.halfvec, public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_mul(public.halfvec, public.halfvec) TO service_role;


--
-- Name: FUNCTION halfvec_ne(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_ne(public.halfvec, public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_ne(public.halfvec, public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.halfvec_ne(public.halfvec, public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_ne(public.halfvec, public.halfvec) TO service_role;


--
-- Name: FUNCTION halfvec_negative_inner_product(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_negative_inner_product(public.halfvec, public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_negative_inner_product(public.halfvec, public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.halfvec_negative_inner_product(public.halfvec, public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_negative_inner_product(public.halfvec, public.halfvec) TO service_role;


--
-- Name: FUNCTION halfvec_spherical_distance(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_spherical_distance(public.halfvec, public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_spherical_distance(public.halfvec, public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.halfvec_spherical_distance(public.halfvec, public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_spherical_distance(public.halfvec, public.halfvec) TO service_role;


--
-- Name: FUNCTION halfvec_sub(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.halfvec_sub(public.halfvec, public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.halfvec_sub(public.halfvec, public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.halfvec_sub(public.halfvec, public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.halfvec_sub(public.halfvec, public.halfvec) TO service_role;


--
-- Name: FUNCTION hamming_distance(bit, bit); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.hamming_distance(bit, bit) TO postgres;
GRANT ALL ON FUNCTION public.hamming_distance(bit, bit) TO anon;
GRANT ALL ON FUNCTION public.hamming_distance(bit, bit) TO authenticated;
GRANT ALL ON FUNCTION public.hamming_distance(bit, bit) TO service_role;


--
-- Name: FUNCTION handle_new_user(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.handle_new_user() TO anon;
GRANT ALL ON FUNCTION public.handle_new_user() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_user() TO service_role;


--
-- Name: FUNCTION hnsw_bit_support(internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.hnsw_bit_support(internal) TO postgres;
GRANT ALL ON FUNCTION public.hnsw_bit_support(internal) TO anon;
GRANT ALL ON FUNCTION public.hnsw_bit_support(internal) TO authenticated;
GRANT ALL ON FUNCTION public.hnsw_bit_support(internal) TO service_role;


--
-- Name: FUNCTION hnsw_halfvec_support(internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.hnsw_halfvec_support(internal) TO postgres;
GRANT ALL ON FUNCTION public.hnsw_halfvec_support(internal) TO anon;
GRANT ALL ON FUNCTION public.hnsw_halfvec_support(internal) TO authenticated;
GRANT ALL ON FUNCTION public.hnsw_halfvec_support(internal) TO service_role;


--
-- Name: FUNCTION hnsw_sparsevec_support(internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.hnsw_sparsevec_support(internal) TO postgres;
GRANT ALL ON FUNCTION public.hnsw_sparsevec_support(internal) TO anon;
GRANT ALL ON FUNCTION public.hnsw_sparsevec_support(internal) TO authenticated;
GRANT ALL ON FUNCTION public.hnsw_sparsevec_support(internal) TO service_role;


--
-- Name: FUNCTION hnswhandler(internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.hnswhandler(internal) TO postgres;
GRANT ALL ON FUNCTION public.hnswhandler(internal) TO anon;
GRANT ALL ON FUNCTION public.hnswhandler(internal) TO authenticated;
GRANT ALL ON FUNCTION public.hnswhandler(internal) TO service_role;


--
-- Name: FUNCTION increment_question_popularity(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.increment_question_popularity() TO anon;
GRANT ALL ON FUNCTION public.increment_question_popularity() TO authenticated;
GRANT ALL ON FUNCTION public.increment_question_popularity() TO service_role;


--
-- Name: FUNCTION increment_solutions_count(question_id text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.increment_solutions_count(question_id text) TO anon;
GRANT ALL ON FUNCTION public.increment_solutions_count(question_id text) TO authenticated;
GRANT ALL ON FUNCTION public.increment_solutions_count(question_id text) TO service_role;


--
-- Name: FUNCTION inner_product(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.inner_product(public.halfvec, public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.inner_product(public.halfvec, public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.inner_product(public.halfvec, public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.inner_product(public.halfvec, public.halfvec) TO service_role;


--
-- Name: FUNCTION inner_product(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.inner_product(public.sparsevec, public.sparsevec) TO postgres;
GRANT ALL ON FUNCTION public.inner_product(public.sparsevec, public.sparsevec) TO anon;
GRANT ALL ON FUNCTION public.inner_product(public.sparsevec, public.sparsevec) TO authenticated;
GRANT ALL ON FUNCTION public.inner_product(public.sparsevec, public.sparsevec) TO service_role;


--
-- Name: FUNCTION inner_product(public.vector, public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.inner_product(public.vector, public.vector) TO postgres;
GRANT ALL ON FUNCTION public.inner_product(public.vector, public.vector) TO anon;
GRANT ALL ON FUNCTION public.inner_product(public.vector, public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.inner_product(public.vector, public.vector) TO service_role;


--
-- Name: FUNCTION ivfflat_bit_support(internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.ivfflat_bit_support(internal) TO postgres;
GRANT ALL ON FUNCTION public.ivfflat_bit_support(internal) TO anon;
GRANT ALL ON FUNCTION public.ivfflat_bit_support(internal) TO authenticated;
GRANT ALL ON FUNCTION public.ivfflat_bit_support(internal) TO service_role;


--
-- Name: FUNCTION ivfflat_halfvec_support(internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.ivfflat_halfvec_support(internal) TO postgres;
GRANT ALL ON FUNCTION public.ivfflat_halfvec_support(internal) TO anon;
GRANT ALL ON FUNCTION public.ivfflat_halfvec_support(internal) TO authenticated;
GRANT ALL ON FUNCTION public.ivfflat_halfvec_support(internal) TO service_role;


--
-- Name: FUNCTION ivfflathandler(internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.ivfflathandler(internal) TO postgres;
GRANT ALL ON FUNCTION public.ivfflathandler(internal) TO anon;
GRANT ALL ON FUNCTION public.ivfflathandler(internal) TO authenticated;
GRANT ALL ON FUNCTION public.ivfflathandler(internal) TO service_role;


--
-- Name: FUNCTION jaccard_distance(bit, bit); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.jaccard_distance(bit, bit) TO postgres;
GRANT ALL ON FUNCTION public.jaccard_distance(bit, bit) TO anon;
GRANT ALL ON FUNCTION public.jaccard_distance(bit, bit) TO authenticated;
GRANT ALL ON FUNCTION public.jaccard_distance(bit, bit) TO service_role;


--
-- Name: FUNCTION l1_distance(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.l1_distance(public.halfvec, public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.l1_distance(public.halfvec, public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.l1_distance(public.halfvec, public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.l1_distance(public.halfvec, public.halfvec) TO service_role;


--
-- Name: FUNCTION l1_distance(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.l1_distance(public.sparsevec, public.sparsevec) TO postgres;
GRANT ALL ON FUNCTION public.l1_distance(public.sparsevec, public.sparsevec) TO anon;
GRANT ALL ON FUNCTION public.l1_distance(public.sparsevec, public.sparsevec) TO authenticated;
GRANT ALL ON FUNCTION public.l1_distance(public.sparsevec, public.sparsevec) TO service_role;


--
-- Name: FUNCTION l1_distance(public.vector, public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.l1_distance(public.vector, public.vector) TO postgres;
GRANT ALL ON FUNCTION public.l1_distance(public.vector, public.vector) TO anon;
GRANT ALL ON FUNCTION public.l1_distance(public.vector, public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.l1_distance(public.vector, public.vector) TO service_role;


--
-- Name: FUNCTION l2_distance(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.l2_distance(public.halfvec, public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.l2_distance(public.halfvec, public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.l2_distance(public.halfvec, public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.l2_distance(public.halfvec, public.halfvec) TO service_role;


--
-- Name: FUNCTION l2_distance(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.l2_distance(public.sparsevec, public.sparsevec) TO postgres;
GRANT ALL ON FUNCTION public.l2_distance(public.sparsevec, public.sparsevec) TO anon;
GRANT ALL ON FUNCTION public.l2_distance(public.sparsevec, public.sparsevec) TO authenticated;
GRANT ALL ON FUNCTION public.l2_distance(public.sparsevec, public.sparsevec) TO service_role;


--
-- Name: FUNCTION l2_distance(public.vector, public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.l2_distance(public.vector, public.vector) TO postgres;
GRANT ALL ON FUNCTION public.l2_distance(public.vector, public.vector) TO anon;
GRANT ALL ON FUNCTION public.l2_distance(public.vector, public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.l2_distance(public.vector, public.vector) TO service_role;


--
-- Name: FUNCTION l2_norm(public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.l2_norm(public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.l2_norm(public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.l2_norm(public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.l2_norm(public.halfvec) TO service_role;


--
-- Name: FUNCTION l2_norm(public.sparsevec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.l2_norm(public.sparsevec) TO postgres;
GRANT ALL ON FUNCTION public.l2_norm(public.sparsevec) TO anon;
GRANT ALL ON FUNCTION public.l2_norm(public.sparsevec) TO authenticated;
GRANT ALL ON FUNCTION public.l2_norm(public.sparsevec) TO service_role;


--
-- Name: FUNCTION l2_normalize(public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.l2_normalize(public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.l2_normalize(public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.l2_normalize(public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.l2_normalize(public.halfvec) TO service_role;


--
-- Name: FUNCTION l2_normalize(public.sparsevec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.l2_normalize(public.sparsevec) TO postgres;
GRANT ALL ON FUNCTION public.l2_normalize(public.sparsevec) TO anon;
GRANT ALL ON FUNCTION public.l2_normalize(public.sparsevec) TO authenticated;
GRANT ALL ON FUNCTION public.l2_normalize(public.sparsevec) TO service_role;


--
-- Name: FUNCTION l2_normalize(public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.l2_normalize(public.vector) TO postgres;
GRANT ALL ON FUNCTION public.l2_normalize(public.vector) TO anon;
GRANT ALL ON FUNCTION public.l2_normalize(public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.l2_normalize(public.vector) TO service_role;


--
-- Name: FUNCTION log_question_created_activity(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.log_question_created_activity() TO anon;
GRANT ALL ON FUNCTION public.log_question_created_activity() TO authenticated;
GRANT ALL ON FUNCTION public.log_question_created_activity() TO service_role;


--
-- Name: FUNCTION log_solution_contributed_activity(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.log_solution_contributed_activity() TO anon;
GRANT ALL ON FUNCTION public.log_solution_contributed_activity() TO authenticated;
GRANT ALL ON FUNCTION public.log_solution_contributed_activity() TO service_role;


--
-- Name: FUNCTION log_user_activity(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.log_user_activity() TO anon;
GRANT ALL ON FUNCTION public.log_user_activity() TO authenticated;
GRANT ALL ON FUNCTION public.log_user_activity() TO service_role;


--
-- Name: FUNCTION match_questions_with_solutions(query_embedding public.vector, match_threshold double precision, match_count integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.match_questions_with_solutions(query_embedding public.vector, match_threshold double precision, match_count integer) TO anon;
GRANT ALL ON FUNCTION public.match_questions_with_solutions(query_embedding public.vector, match_threshold double precision, match_count integer) TO authenticated;
GRANT ALL ON FUNCTION public.match_questions_with_solutions(query_embedding public.vector, match_threshold double precision, match_count integer) TO service_role;


--
-- Name: FUNCTION moddatetime(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.moddatetime() TO postgres;
GRANT ALL ON FUNCTION public.moddatetime() TO anon;
GRANT ALL ON FUNCTION public.moddatetime() TO authenticated;
GRANT ALL ON FUNCTION public.moddatetime() TO service_role;


--
-- Name: FUNCTION notify_on_contribution(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.notify_on_contribution() TO anon;
GRANT ALL ON FUNCTION public.notify_on_contribution() TO authenticated;
GRANT ALL ON FUNCTION public.notify_on_contribution() TO service_role;


--
-- Name: FUNCTION notify_on_follow(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.notify_on_follow() TO anon;
GRANT ALL ON FUNCTION public.notify_on_follow() TO authenticated;
GRANT ALL ON FUNCTION public.notify_on_follow() TO service_role;


--
-- Name: FUNCTION notify_on_link(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.notify_on_link() TO anon;
GRANT ALL ON FUNCTION public.notify_on_link() TO authenticated;
GRANT ALL ON FUNCTION public.notify_on_link() TO service_role;


--
-- Name: FUNCTION notify_on_solution_like(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.notify_on_solution_like() TO anon;
GRANT ALL ON FUNCTION public.notify_on_solution_like() TO authenticated;
GRANT ALL ON FUNCTION public.notify_on_solution_like() TO service_role;


--
-- Name: FUNCTION recalculate_user_stats(user_uuid uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.recalculate_user_stats(user_uuid uuid) TO anon;
GRANT ALL ON FUNCTION public.recalculate_user_stats(user_uuid uuid) TO authenticated;
GRANT ALL ON FUNCTION public.recalculate_user_stats(user_uuid uuid) TO service_role;


--
-- Name: FUNCTION search_questions(p_query text, p_user_id uuid, p_limit integer, p_offset integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.search_questions(p_query text, p_user_id uuid, p_limit integer, p_offset integer) TO anon;
GRANT ALL ON FUNCTION public.search_questions(p_query text, p_user_id uuid, p_limit integer, p_offset integer) TO authenticated;
GRANT ALL ON FUNCTION public.search_questions(p_query text, p_user_id uuid, p_limit integer, p_offset integer) TO service_role;


--
-- Name: FUNCTION search_users(p_query text, p_viewer_id uuid, p_limit integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.search_users(p_query text, p_viewer_id uuid, p_limit integer) TO anon;
GRANT ALL ON FUNCTION public.search_users(p_query text, p_viewer_id uuid, p_limit integer) TO authenticated;
GRANT ALL ON FUNCTION public.search_users(p_query text, p_viewer_id uuid, p_limit integer) TO service_role;


--
-- Name: FUNCTION set_limit(real); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.set_limit(real) TO postgres;
GRANT ALL ON FUNCTION public.set_limit(real) TO anon;
GRANT ALL ON FUNCTION public.set_limit(real) TO authenticated;
GRANT ALL ON FUNCTION public.set_limit(real) TO service_role;


--
-- Name: FUNCTION show_limit(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.show_limit() TO postgres;
GRANT ALL ON FUNCTION public.show_limit() TO anon;
GRANT ALL ON FUNCTION public.show_limit() TO authenticated;
GRANT ALL ON FUNCTION public.show_limit() TO service_role;


--
-- Name: FUNCTION show_trgm(text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.show_trgm(text) TO postgres;
GRANT ALL ON FUNCTION public.show_trgm(text) TO anon;
GRANT ALL ON FUNCTION public.show_trgm(text) TO authenticated;
GRANT ALL ON FUNCTION public.show_trgm(text) TO service_role;


--
-- Name: FUNCTION similarity(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.similarity(text, text) TO postgres;
GRANT ALL ON FUNCTION public.similarity(text, text) TO anon;
GRANT ALL ON FUNCTION public.similarity(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.similarity(text, text) TO service_role;


--
-- Name: FUNCTION similarity_dist(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.similarity_dist(text, text) TO postgres;
GRANT ALL ON FUNCTION public.similarity_dist(text, text) TO anon;
GRANT ALL ON FUNCTION public.similarity_dist(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.similarity_dist(text, text) TO service_role;


--
-- Name: FUNCTION similarity_op(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.similarity_op(text, text) TO postgres;
GRANT ALL ON FUNCTION public.similarity_op(text, text) TO anon;
GRANT ALL ON FUNCTION public.similarity_op(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.similarity_op(text, text) TO service_role;


--
-- Name: FUNCTION sparsevec_cmp(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.sparsevec_cmp(public.sparsevec, public.sparsevec) TO postgres;
GRANT ALL ON FUNCTION public.sparsevec_cmp(public.sparsevec, public.sparsevec) TO anon;
GRANT ALL ON FUNCTION public.sparsevec_cmp(public.sparsevec, public.sparsevec) TO authenticated;
GRANT ALL ON FUNCTION public.sparsevec_cmp(public.sparsevec, public.sparsevec) TO service_role;


--
-- Name: FUNCTION sparsevec_eq(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.sparsevec_eq(public.sparsevec, public.sparsevec) TO postgres;
GRANT ALL ON FUNCTION public.sparsevec_eq(public.sparsevec, public.sparsevec) TO anon;
GRANT ALL ON FUNCTION public.sparsevec_eq(public.sparsevec, public.sparsevec) TO authenticated;
GRANT ALL ON FUNCTION public.sparsevec_eq(public.sparsevec, public.sparsevec) TO service_role;


--
-- Name: FUNCTION sparsevec_ge(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.sparsevec_ge(public.sparsevec, public.sparsevec) TO postgres;
GRANT ALL ON FUNCTION public.sparsevec_ge(public.sparsevec, public.sparsevec) TO anon;
GRANT ALL ON FUNCTION public.sparsevec_ge(public.sparsevec, public.sparsevec) TO authenticated;
GRANT ALL ON FUNCTION public.sparsevec_ge(public.sparsevec, public.sparsevec) TO service_role;


--
-- Name: FUNCTION sparsevec_gt(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.sparsevec_gt(public.sparsevec, public.sparsevec) TO postgres;
GRANT ALL ON FUNCTION public.sparsevec_gt(public.sparsevec, public.sparsevec) TO anon;
GRANT ALL ON FUNCTION public.sparsevec_gt(public.sparsevec, public.sparsevec) TO authenticated;
GRANT ALL ON FUNCTION public.sparsevec_gt(public.sparsevec, public.sparsevec) TO service_role;


--
-- Name: FUNCTION sparsevec_l2_squared_distance(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.sparsevec_l2_squared_distance(public.sparsevec, public.sparsevec) TO postgres;
GRANT ALL ON FUNCTION public.sparsevec_l2_squared_distance(public.sparsevec, public.sparsevec) TO anon;
GRANT ALL ON FUNCTION public.sparsevec_l2_squared_distance(public.sparsevec, public.sparsevec) TO authenticated;
GRANT ALL ON FUNCTION public.sparsevec_l2_squared_distance(public.sparsevec, public.sparsevec) TO service_role;


--
-- Name: FUNCTION sparsevec_le(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.sparsevec_le(public.sparsevec, public.sparsevec) TO postgres;
GRANT ALL ON FUNCTION public.sparsevec_le(public.sparsevec, public.sparsevec) TO anon;
GRANT ALL ON FUNCTION public.sparsevec_le(public.sparsevec, public.sparsevec) TO authenticated;
GRANT ALL ON FUNCTION public.sparsevec_le(public.sparsevec, public.sparsevec) TO service_role;


--
-- Name: FUNCTION sparsevec_lt(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.sparsevec_lt(public.sparsevec, public.sparsevec) TO postgres;
GRANT ALL ON FUNCTION public.sparsevec_lt(public.sparsevec, public.sparsevec) TO anon;
GRANT ALL ON FUNCTION public.sparsevec_lt(public.sparsevec, public.sparsevec) TO authenticated;
GRANT ALL ON FUNCTION public.sparsevec_lt(public.sparsevec, public.sparsevec) TO service_role;


--
-- Name: FUNCTION sparsevec_ne(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.sparsevec_ne(public.sparsevec, public.sparsevec) TO postgres;
GRANT ALL ON FUNCTION public.sparsevec_ne(public.sparsevec, public.sparsevec) TO anon;
GRANT ALL ON FUNCTION public.sparsevec_ne(public.sparsevec, public.sparsevec) TO authenticated;
GRANT ALL ON FUNCTION public.sparsevec_ne(public.sparsevec, public.sparsevec) TO service_role;


--
-- Name: FUNCTION sparsevec_negative_inner_product(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.sparsevec_negative_inner_product(public.sparsevec, public.sparsevec) TO postgres;
GRANT ALL ON FUNCTION public.sparsevec_negative_inner_product(public.sparsevec, public.sparsevec) TO anon;
GRANT ALL ON FUNCTION public.sparsevec_negative_inner_product(public.sparsevec, public.sparsevec) TO authenticated;
GRANT ALL ON FUNCTION public.sparsevec_negative_inner_product(public.sparsevec, public.sparsevec) TO service_role;


--
-- Name: FUNCTION strict_word_similarity(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.strict_word_similarity(text, text) TO postgres;
GRANT ALL ON FUNCTION public.strict_word_similarity(text, text) TO anon;
GRANT ALL ON FUNCTION public.strict_word_similarity(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.strict_word_similarity(text, text) TO service_role;


--
-- Name: FUNCTION strict_word_similarity_commutator_op(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.strict_word_similarity_commutator_op(text, text) TO postgres;
GRANT ALL ON FUNCTION public.strict_word_similarity_commutator_op(text, text) TO anon;
GRANT ALL ON FUNCTION public.strict_word_similarity_commutator_op(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.strict_word_similarity_commutator_op(text, text) TO service_role;


--
-- Name: FUNCTION strict_word_similarity_dist_commutator_op(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.strict_word_similarity_dist_commutator_op(text, text) TO postgres;
GRANT ALL ON FUNCTION public.strict_word_similarity_dist_commutator_op(text, text) TO anon;
GRANT ALL ON FUNCTION public.strict_word_similarity_dist_commutator_op(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.strict_word_similarity_dist_commutator_op(text, text) TO service_role;


--
-- Name: FUNCTION strict_word_similarity_dist_op(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.strict_word_similarity_dist_op(text, text) TO postgres;
GRANT ALL ON FUNCTION public.strict_word_similarity_dist_op(text, text) TO anon;
GRANT ALL ON FUNCTION public.strict_word_similarity_dist_op(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.strict_word_similarity_dist_op(text, text) TO service_role;


--
-- Name: FUNCTION strict_word_similarity_op(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.strict_word_similarity_op(text, text) TO postgres;
GRANT ALL ON FUNCTION public.strict_word_similarity_op(text, text) TO anon;
GRANT ALL ON FUNCTION public.strict_word_similarity_op(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.strict_word_similarity_op(text, text) TO service_role;


--
-- Name: FUNCTION subvector(public.halfvec, integer, integer); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.subvector(public.halfvec, integer, integer) TO postgres;
GRANT ALL ON FUNCTION public.subvector(public.halfvec, integer, integer) TO anon;
GRANT ALL ON FUNCTION public.subvector(public.halfvec, integer, integer) TO authenticated;
GRANT ALL ON FUNCTION public.subvector(public.halfvec, integer, integer) TO service_role;


--
-- Name: FUNCTION subvector(public.vector, integer, integer); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.subvector(public.vector, integer, integer) TO postgres;
GRANT ALL ON FUNCTION public.subvector(public.vector, integer, integer) TO anon;
GRANT ALL ON FUNCTION public.subvector(public.vector, integer, integer) TO authenticated;
GRANT ALL ON FUNCTION public.subvector(public.vector, integer, integer) TO service_role;


--
-- Name: FUNCTION sync_revise_later_delete_to_stats(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sync_revise_later_delete_to_stats() TO anon;
GRANT ALL ON FUNCTION public.sync_revise_later_delete_to_stats() TO authenticated;
GRANT ALL ON FUNCTION public.sync_revise_later_delete_to_stats() TO service_role;


--
-- Name: FUNCTION sync_revise_later_to_stats(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sync_revise_later_to_stats() TO anon;
GRANT ALL ON FUNCTION public.sync_revise_later_to_stats() TO authenticated;
GRANT ALL ON FUNCTION public.sync_revise_later_to_stats() TO service_role;


--
-- Name: FUNCTION toggle_solution_like(sol_id text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.toggle_solution_like(sol_id text) TO anon;
GRANT ALL ON FUNCTION public.toggle_solution_like(sol_id text) TO authenticated;
GRANT ALL ON FUNCTION public.toggle_solution_like(sol_id text) TO service_role;


--
-- Name: FUNCTION trigger_recalc_stats(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.trigger_recalc_stats() TO anon;
GRANT ALL ON FUNCTION public.trigger_recalc_stats() TO authenticated;
GRANT ALL ON FUNCTION public.trigger_recalc_stats() TO service_role;


--
-- Name: FUNCTION update_updated_at_column(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_updated_at_column() TO anon;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO authenticated;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO service_role;


--
-- Name: FUNCTION vector_accum(double precision[], public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_accum(double precision[], public.vector) TO postgres;
GRANT ALL ON FUNCTION public.vector_accum(double precision[], public.vector) TO anon;
GRANT ALL ON FUNCTION public.vector_accum(double precision[], public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.vector_accum(double precision[], public.vector) TO service_role;


--
-- Name: FUNCTION vector_add(public.vector, public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_add(public.vector, public.vector) TO postgres;
GRANT ALL ON FUNCTION public.vector_add(public.vector, public.vector) TO anon;
GRANT ALL ON FUNCTION public.vector_add(public.vector, public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.vector_add(public.vector, public.vector) TO service_role;


--
-- Name: FUNCTION vector_avg(double precision[]); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_avg(double precision[]) TO postgres;
GRANT ALL ON FUNCTION public.vector_avg(double precision[]) TO anon;
GRANT ALL ON FUNCTION public.vector_avg(double precision[]) TO authenticated;
GRANT ALL ON FUNCTION public.vector_avg(double precision[]) TO service_role;


--
-- Name: FUNCTION vector_cmp(public.vector, public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_cmp(public.vector, public.vector) TO postgres;
GRANT ALL ON FUNCTION public.vector_cmp(public.vector, public.vector) TO anon;
GRANT ALL ON FUNCTION public.vector_cmp(public.vector, public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.vector_cmp(public.vector, public.vector) TO service_role;


--
-- Name: FUNCTION vector_combine(double precision[], double precision[]); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_combine(double precision[], double precision[]) TO postgres;
GRANT ALL ON FUNCTION public.vector_combine(double precision[], double precision[]) TO anon;
GRANT ALL ON FUNCTION public.vector_combine(double precision[], double precision[]) TO authenticated;
GRANT ALL ON FUNCTION public.vector_combine(double precision[], double precision[]) TO service_role;


--
-- Name: FUNCTION vector_concat(public.vector, public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_concat(public.vector, public.vector) TO postgres;
GRANT ALL ON FUNCTION public.vector_concat(public.vector, public.vector) TO anon;
GRANT ALL ON FUNCTION public.vector_concat(public.vector, public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.vector_concat(public.vector, public.vector) TO service_role;


--
-- Name: FUNCTION vector_dims(public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_dims(public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.vector_dims(public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.vector_dims(public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.vector_dims(public.halfvec) TO service_role;


--
-- Name: FUNCTION vector_dims(public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_dims(public.vector) TO postgres;
GRANT ALL ON FUNCTION public.vector_dims(public.vector) TO anon;
GRANT ALL ON FUNCTION public.vector_dims(public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.vector_dims(public.vector) TO service_role;


--
-- Name: FUNCTION vector_eq(public.vector, public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_eq(public.vector, public.vector) TO postgres;
GRANT ALL ON FUNCTION public.vector_eq(public.vector, public.vector) TO anon;
GRANT ALL ON FUNCTION public.vector_eq(public.vector, public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.vector_eq(public.vector, public.vector) TO service_role;


--
-- Name: FUNCTION vector_ge(public.vector, public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_ge(public.vector, public.vector) TO postgres;
GRANT ALL ON FUNCTION public.vector_ge(public.vector, public.vector) TO anon;
GRANT ALL ON FUNCTION public.vector_ge(public.vector, public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.vector_ge(public.vector, public.vector) TO service_role;


--
-- Name: FUNCTION vector_gt(public.vector, public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_gt(public.vector, public.vector) TO postgres;
GRANT ALL ON FUNCTION public.vector_gt(public.vector, public.vector) TO anon;
GRANT ALL ON FUNCTION public.vector_gt(public.vector, public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.vector_gt(public.vector, public.vector) TO service_role;


--
-- Name: FUNCTION vector_l2_squared_distance(public.vector, public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_l2_squared_distance(public.vector, public.vector) TO postgres;
GRANT ALL ON FUNCTION public.vector_l2_squared_distance(public.vector, public.vector) TO anon;
GRANT ALL ON FUNCTION public.vector_l2_squared_distance(public.vector, public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.vector_l2_squared_distance(public.vector, public.vector) TO service_role;


--
-- Name: FUNCTION vector_le(public.vector, public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_le(public.vector, public.vector) TO postgres;
GRANT ALL ON FUNCTION public.vector_le(public.vector, public.vector) TO anon;
GRANT ALL ON FUNCTION public.vector_le(public.vector, public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.vector_le(public.vector, public.vector) TO service_role;


--
-- Name: FUNCTION vector_lt(public.vector, public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_lt(public.vector, public.vector) TO postgres;
GRANT ALL ON FUNCTION public.vector_lt(public.vector, public.vector) TO anon;
GRANT ALL ON FUNCTION public.vector_lt(public.vector, public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.vector_lt(public.vector, public.vector) TO service_role;


--
-- Name: FUNCTION vector_mul(public.vector, public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_mul(public.vector, public.vector) TO postgres;
GRANT ALL ON FUNCTION public.vector_mul(public.vector, public.vector) TO anon;
GRANT ALL ON FUNCTION public.vector_mul(public.vector, public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.vector_mul(public.vector, public.vector) TO service_role;


--
-- Name: FUNCTION vector_ne(public.vector, public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_ne(public.vector, public.vector) TO postgres;
GRANT ALL ON FUNCTION public.vector_ne(public.vector, public.vector) TO anon;
GRANT ALL ON FUNCTION public.vector_ne(public.vector, public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.vector_ne(public.vector, public.vector) TO service_role;


--
-- Name: FUNCTION vector_negative_inner_product(public.vector, public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_negative_inner_product(public.vector, public.vector) TO postgres;
GRANT ALL ON FUNCTION public.vector_negative_inner_product(public.vector, public.vector) TO anon;
GRANT ALL ON FUNCTION public.vector_negative_inner_product(public.vector, public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.vector_negative_inner_product(public.vector, public.vector) TO service_role;


--
-- Name: FUNCTION vector_norm(public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_norm(public.vector) TO postgres;
GRANT ALL ON FUNCTION public.vector_norm(public.vector) TO anon;
GRANT ALL ON FUNCTION public.vector_norm(public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.vector_norm(public.vector) TO service_role;


--
-- Name: FUNCTION vector_spherical_distance(public.vector, public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_spherical_distance(public.vector, public.vector) TO postgres;
GRANT ALL ON FUNCTION public.vector_spherical_distance(public.vector, public.vector) TO anon;
GRANT ALL ON FUNCTION public.vector_spherical_distance(public.vector, public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.vector_spherical_distance(public.vector, public.vector) TO service_role;


--
-- Name: FUNCTION vector_sub(public.vector, public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.vector_sub(public.vector, public.vector) TO postgres;
GRANT ALL ON FUNCTION public.vector_sub(public.vector, public.vector) TO anon;
GRANT ALL ON FUNCTION public.vector_sub(public.vector, public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.vector_sub(public.vector, public.vector) TO service_role;


--
-- Name: FUNCTION word_similarity(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.word_similarity(text, text) TO postgres;
GRANT ALL ON FUNCTION public.word_similarity(text, text) TO anon;
GRANT ALL ON FUNCTION public.word_similarity(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.word_similarity(text, text) TO service_role;


--
-- Name: FUNCTION word_similarity_commutator_op(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.word_similarity_commutator_op(text, text) TO postgres;
GRANT ALL ON FUNCTION public.word_similarity_commutator_op(text, text) TO anon;
GRANT ALL ON FUNCTION public.word_similarity_commutator_op(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.word_similarity_commutator_op(text, text) TO service_role;


--
-- Name: FUNCTION word_similarity_dist_commutator_op(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.word_similarity_dist_commutator_op(text, text) TO postgres;
GRANT ALL ON FUNCTION public.word_similarity_dist_commutator_op(text, text) TO anon;
GRANT ALL ON FUNCTION public.word_similarity_dist_commutator_op(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.word_similarity_dist_commutator_op(text, text) TO service_role;


--
-- Name: FUNCTION word_similarity_dist_op(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.word_similarity_dist_op(text, text) TO postgres;
GRANT ALL ON FUNCTION public.word_similarity_dist_op(text, text) TO anon;
GRANT ALL ON FUNCTION public.word_similarity_dist_op(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.word_similarity_dist_op(text, text) TO service_role;


--
-- Name: FUNCTION word_similarity_op(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.word_similarity_op(text, text) TO postgres;
GRANT ALL ON FUNCTION public.word_similarity_op(text, text) TO anon;
GRANT ALL ON FUNCTION public.word_similarity_op(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.word_similarity_op(text, text) TO service_role;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION avg(public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.avg(public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.avg(public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.avg(public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.avg(public.halfvec) TO service_role;


--
-- Name: FUNCTION avg(public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.avg(public.vector) TO postgres;
GRANT ALL ON FUNCTION public.avg(public.vector) TO anon;
GRANT ALL ON FUNCTION public.avg(public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.avg(public.vector) TO service_role;


--
-- Name: FUNCTION sum(public.halfvec); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.sum(public.halfvec) TO postgres;
GRANT ALL ON FUNCTION public.sum(public.halfvec) TO anon;
GRANT ALL ON FUNCTION public.sum(public.halfvec) TO authenticated;
GRANT ALL ON FUNCTION public.sum(public.halfvec) TO service_role;


--
-- Name: FUNCTION sum(public.vector); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.sum(public.vector) TO postgres;
GRANT ALL ON FUNCTION public.sum(public.vector) TO anon;
GRANT ALL ON FUNCTION public.sum(public.vector) TO authenticated;
GRANT ALL ON FUNCTION public.sum(public.vector) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE follows; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.follows TO anon;
GRANT ALL ON TABLE public.follows TO authenticated;
GRANT ALL ON TABLE public.follows TO service_role;


--
-- Name: TABLE notifications; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.notifications TO anon;
GRANT ALL ON TABLE public.notifications TO authenticated;
GRANT ALL ON TABLE public.notifications TO service_role;


--
-- Name: TABLE questions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.questions TO anon;
GRANT ALL ON TABLE public.questions TO authenticated;
GRANT ALL ON TABLE public.questions TO service_role;


--
-- Name: TABLE revise_later; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.revise_later TO anon;
GRANT ALL ON TABLE public.revise_later TO authenticated;
GRANT ALL ON TABLE public.revise_later TO service_role;


--
-- Name: TABLE solution_likes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.solution_likes TO anon;
GRANT ALL ON TABLE public.solution_likes TO authenticated;
GRANT ALL ON TABLE public.solution_likes TO service_role;


--
-- Name: TABLE solutions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.solutions TO anon;
GRANT ALL ON TABLE public.solutions TO authenticated;
GRANT ALL ON TABLE public.solutions TO service_role;


--
-- Name: TABLE syllabus; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.syllabus TO anon;
GRANT ALL ON TABLE public.syllabus TO authenticated;
GRANT ALL ON TABLE public.syllabus TO service_role;


--
-- Name: TABLE user_activities; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_activities TO anon;
GRANT ALL ON TABLE public.user_activities TO authenticated;
GRANT ALL ON TABLE public.user_activities TO service_role;


--
-- Name: TABLE user_profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_profiles TO anon;
GRANT ALL ON TABLE public.user_profiles TO authenticated;
GRANT ALL ON TABLE public.user_profiles TO service_role;


--
-- Name: TABLE user_question_stats; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_question_stats TO anon;
GRANT ALL ON TABLE public.user_question_stats TO authenticated;
GRANT ALL ON TABLE public.user_question_stats TO service_role;


--
-- Name: TABLE user_questions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_questions TO anon;
GRANT ALL ON TABLE public.user_questions TO authenticated;
GRANT ALL ON TABLE public.user_questions TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE messages_2026_01_31; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_01_31 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_01_31 TO dashboard_user;


--
-- Name: TABLE messages_2026_02_01; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_02_01 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_02_01 TO dashboard_user;


--
-- Name: TABLE messages_2026_02_02; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_02_02 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_02_02 TO dashboard_user;


--
-- Name: TABLE messages_2026_02_03; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_02_03 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_02_03 TO dashboard_user;


--
-- Name: TABLE messages_2026_02_04; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_02_04 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_02_04 TO dashboard_user;


--
-- Name: TABLE messages_2026_02_05; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_02_05 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_02_05 TO dashboard_user;


--
-- Name: TABLE messages_2026_02_06; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_02_06 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_02_06 TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.buckets FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.objects FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- Name: TABLE prefixes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.prefixes TO service_role;
GRANT ALL ON TABLE storage.prefixes TO authenticated;
GRANT ALL ON TABLE storage.prefixes TO anon;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

\unrestrict ymkwfi2t7ZT1Eb4KAnBCwPabl6ZoJehpk0d5jDpoCsVhDw5WPVIquVa5ngNHPMp

