--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 14.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: airing_schedule_filter(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.airing_schedule_filter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   IF NOT EXISTS(SELECT 1 FROM airing_schedule WHERE anime_id = NEW.anime_id AND episode = NEW.episode)

   THEN

      RETURN NEW;

   ELSE

      RETURN NULL;

   END IF;

END;$$;


ALTER FUNCTION public.airing_schedule_filter() OWNER TO supabase_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: kaguya_anime; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_anime (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    "idMal" bigint,
    title json NOT NULL,
    "coverImage" jsonb NOT NULL,
    "startDate" jsonb,
    trending integer,
    popularity integer,
    favourites integer,
    "bannerImage" character varying,
    season character varying,
    "seasonYear" smallint,
    format character varying,
    status character varying,
    "totalEpisodes" smallint,
    tags character varying[],
    "episodeUpdatedAt" timestamp without time zone DEFAULT now(),
    description json,
    "vietnameseTitle" character varying,
    "isAdult" boolean,
    synonyms text[],
    "countryOfOrigin" character varying,
    "averageScore" smallint,
    genres character varying[],
    duration smallint,
    trailer character varying
);


ALTER TABLE public.kaguya_anime OWNER TO supabase_admin;

--
-- Name: anime_random(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.anime_random() RETURNS SETOF public.kaguya_anime
    LANGUAGE plpgsql
    AS $$

  begin

  return query select * from kaguya_anime order by random();

  end

$$;


ALTER FUNCTION public.anime_random() OWNER TO supabase_admin;

--
-- Name: anime_recommendations_upsert_filter(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.anime_recommendations_upsert_filter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   IF EXISTS(SELECT 1 FROM anime WHERE ani_id = NEW.recommend_id)

   THEN

      RETURN NEW;

   ELSE

      RETURN NULL;

   END IF;

END;$$;


ALTER FUNCTION public.anime_recommendations_upsert_filter() OWNER TO supabase_admin;

--
-- Name: anime_relations_upsert_filter(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.anime_relations_upsert_filter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   IF EXISTS(SELECT 1 FROM anime WHERE ani_id = NEW.relation_id)

   THEN

      RETURN NEW;

   ELSE

      RETURN NULL;

   END IF;

END;$$;


ALTER FUNCTION public.anime_relations_upsert_filter() OWNER TO supabase_admin;

--
-- Name: anime_search(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.anime_search(string text) RETURNS SETOF public.kaguya_anime
    LANGUAGE plpgsql
    AS $$

  begin

  return query select * from kaguya_anime where to_tsvector(title || ' ' || coalesce("vietnameseTitle", '') || ' ' || coalesce(arr2text(synonyms), '') || ' ' || description) @@ plainto_tsquery(string);

  end

$$;


ALTER FUNCTION public.anime_search(string text) OWNER TO supabase_admin;

--
-- Name: arr2text(text[]); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.arr2text(ci text[]) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT array_to_string($1, ',')$_$;


ALTER FUNCTION public.arr2text(ci text[]) OWNER TO supabase_admin;

--
-- Name: both_search(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.both_search(string text) RETURNS TABLE(title text, description text)
    LANGUAGE plpgsql
    AS $$

  begin

  return query select title, description from manga union all select title, description from anime where to_tsvector(title || ' ' || description) @@ plainto_tsquery(string);

  end

$$;


ALTER FUNCTION public.both_search(string text) OWNER TO supabase_admin;

--
-- Name: character_filter(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.character_filter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   IF NOT EXISTS(SELECT 1 FROM characters WHERE anime_id = NEW.anime_id AND name = NEW.name)

   THEN

      RETURN NEW;

   ELSE

      RETURN NULL;

   END IF;

END;$$;


ALTER FUNCTION public.character_filter() OWNER TO supabase_admin;

--
-- Name: kaguya_characters; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_characters (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    name json NOT NULL,
    image jsonb NOT NULL,
    gender character varying,
    "dateOfBirth" jsonb,
    age character varying,
    favourites integer,
    "bloodType" character varying
);


ALTER TABLE public.kaguya_characters OWNER TO supabase_admin;

--
-- Name: characters_search(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.characters_search(keyword text) RETURNS SETOF public.kaguya_characters
    LANGUAGE plpgsql
    AS $$

  begin

  return query select * from kaguya_characters where to_tsvector(name) @@ plainto_tsquery(keyword);

  end

$$;


ALTER FUNCTION public.characters_search(keyword text) OWNER TO supabase_admin;

--
-- Name: delete_expired_schedules(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.delete_expired_schedules() RETURNS boolean
    LANGUAGE plpgsql
    AS $$

BEGIN

    delete from kaguya_airing_schedules T1 

    using       kaguya_airing_schedules T2 

    where T1.ctid < T2.ctid

    and T1."mediaId" = T2."mediaId"

    and T1.episode = T2.episode

    or T1."airingAt" <= extract(epoch from now());

    return true;

END;

$$;


ALTER FUNCTION public.delete_expired_schedules() OWNER TO supabase_admin;

--
-- Name: generate_create_table_statement(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_create_table_statement(p_table_name character varying) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $_$

DECLARE

    v_table_ddl   text;

    column_record record;

    table_rec record;

    constraint_rec record;

    firstrec boolean;

BEGIN

    FOR table_rec IN

        SELECT c.relname FROM pg_catalog.pg_class c

            LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace

                WHERE relkind = 'r'

                AND relname~ ('^('||p_table_name||')$')

                AND n.nspname <> 'pg_catalog'

                AND n.nspname <> 'information_schema'

                AND n.nspname !~ '^pg_toast'

                AND pg_catalog.pg_table_is_visible(c.oid)

          ORDER BY c.relname

    LOOP



        FOR column_record IN 

            SELECT 

                b.nspname as schema_name,

                b.relname as table_name,

                a.attname as column_name,

                pg_catalog.format_type(a.atttypid, a.atttypmod) as column_type,

                CASE WHEN 

                    (SELECT substring(pg_catalog.pg_get_expr(d.adbin, d.adrelid) for 128)

                     FROM pg_catalog.pg_attrdef d

                     WHERE d.adrelid = a.attrelid AND d.adnum = a.attnum AND a.atthasdef) IS NOT NULL THEN

                    'DEFAULT '|| (SELECT substring(pg_catalog.pg_get_expr(d.adbin, d.adrelid) for 128)

                                  FROM pg_catalog.pg_attrdef d

                                  WHERE d.adrelid = a.attrelid AND d.adnum = a.attnum AND a.atthasdef)

                ELSE

                    ''

                END as column_default_value,

                CASE WHEN a.attnotnull = true THEN 

                    'NOT NULL'

                ELSE

                    'NULL'

                END as column_not_null,

                a.attnum as attnum,

                e.max_attnum as max_attnum

            FROM 

                pg_catalog.pg_attribute a

                INNER JOIN 

                 (SELECT c.oid,

                    n.nspname,

                    c.relname

                  FROM pg_catalog.pg_class c

                       LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace

                  WHERE c.relname = table_rec.relname

                    AND pg_catalog.pg_table_is_visible(c.oid)

                  ORDER BY 2, 3) b

                ON a.attrelid = b.oid

                INNER JOIN 

                 (SELECT 

                      a.attrelid,

                      max(a.attnum) as max_attnum

                  FROM pg_catalog.pg_attribute a

                  WHERE a.attnum > 0 

                    AND NOT a.attisdropped

                  GROUP BY a.attrelid) e

                ON a.attrelid=e.attrelid

            WHERE a.attnum > 0 

              AND NOT a.attisdropped

            ORDER BY a.attnum

        LOOP

            IF column_record.attnum = 1 THEN

                v_table_ddl:='CREATE TABLE '||column_record.schema_name||'.'||column_record.table_name||' (';

            ELSE

                v_table_ddl:=v_table_ddl||',';

            END IF;



            IF column_record.attnum <= column_record.max_attnum THEN

                v_table_ddl:=v_table_ddl||chr(10)||

                         '    '||column_record.column_name||' '||column_record.column_type||' '||column_record.column_default_value||' '||column_record.column_not_null;

            END IF;

        END LOOP;



        firstrec := TRUE;

        FOR constraint_rec IN

            SELECT conname, pg_get_constraintdef(c.oid) as constrainddef 

                FROM pg_constraint c 

                    WHERE conrelid=(

                        SELECT attrelid FROM pg_attribute

                        WHERE attrelid = (

                            SELECT oid FROM pg_class WHERE relname = table_rec.relname

                        ) AND attname='tableoid'

                    )

        LOOP

            v_table_ddl:=v_table_ddl||','||chr(10);

            v_table_ddl:=v_table_ddl||'CONSTRAINT '||constraint_rec.conname;

            v_table_ddl:=v_table_ddl||chr(10)||'    '||constraint_rec.constrainddef;

            firstrec := FALSE;

        END LOOP;

        v_table_ddl:=v_table_ddl||');';

        RETURN NEXT v_table_ddl;

    END LOOP;

END;

$_$;


ALTER FUNCTION public.generate_create_table_statement(p_table_name character varying) OWNER TO postgres;

--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$

begin

  insert into public.users (id, email, created_at, updated_at, user_metadata, raw_app_meta_data, aud, role)

  values (new.id, new.email, new.created_at, new.updated_at, new.raw_user_meta_data, new.raw_app_meta_data, new.aud, new.role) on conflict (id) do update set (id, email, created_at, updated_at, user_metadata, raw_app_meta_data, aud, role) = (new.id, new.email, new.created_at, new.updated_at, new.raw_user_meta_data, new.raw_app_meta_data, new.aud, new.role);

  return new;

end;

$$;


ALTER FUNCTION public.handle_new_user() OWNER TO supabase_admin;

--
-- Name: manga_character_filter(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.manga_character_filter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   IF NOT EXISTS(SELECT 1 FROM manga_characters WHERE manga_id = NEW.manga_id AND name = NEW.name)

   THEN

      RETURN NEW;

   ELSE

      RETURN NULL;

   END IF;

END;$$;


ALTER FUNCTION public.manga_character_filter() OWNER TO supabase_admin;

--
-- Name: kaguya_manga; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_manga (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    "idMal" bigint,
    title json NOT NULL,
    "coverImage" jsonb NOT NULL,
    "startDate" jsonb,
    trending integer,
    popularity integer,
    favourites integer,
    "bannerImage" character varying,
    format character varying,
    status character varying,
    tags character varying[],
    "isAdult" boolean,
    "averageScore" smallint,
    "countryOfOrigin" character varying,
    genres character varying[],
    description json,
    "vietnameseTitle" character varying,
    synonyms character varying[],
    "chapterUpdatedAt" timestamp with time zone DEFAULT now(),
    "totalChapters" integer
);


ALTER TABLE public.kaguya_manga OWNER TO supabase_admin;

--
-- Name: manga_random(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.manga_random() RETURNS SETOF public.kaguya_manga
    LANGUAGE plpgsql
    AS $$

  begin

  return query select * from kaguya_manga order by random();

  end

$$;


ALTER FUNCTION public.manga_random() OWNER TO supabase_admin;

--
-- Name: manga_recommendations_upsert_filter(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.manga_recommendations_upsert_filter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   IF EXISTS(SELECT 1 FROM manga WHERE ani_id = NEW.recommend_id)

   THEN

      RETURN NEW;

   ELSE

      RETURN NULL;

   END IF;

END;$$;


ALTER FUNCTION public.manga_recommendations_upsert_filter() OWNER TO supabase_admin;

--
-- Name: manga_relations_upsert_filter(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.manga_relations_upsert_filter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   IF EXISTS(SELECT 1 FROM manga WHERE ani_id = NEW.relation_id)

   THEN

      RETURN NEW;

   ELSE

      RETURN NULL;

   END IF;

END;$$;


ALTER FUNCTION public.manga_relations_upsert_filter() OWNER TO supabase_admin;

--
-- Name: manga_search(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.manga_search(string text) RETURNS SETOF public.kaguya_manga
    LANGUAGE plpgsql
    AS $$

  begin

  return query select * from kaguya_manga where to_tsvector(title ' ' || coalesce(arr2text(synonyms), '') || ' ' || description) @@ plainto_tsquery(string);

  end

$$;


ALTER FUNCTION public.manga_search(string text) OWNER TO supabase_admin;

--
-- Name: new_anime_recommendations_upsert_filter(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.new_anime_recommendations_upsert_filter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   IF EXISTS(SELECT 1 FROM kaguya_anime WHERE id = NEW."recommendationId")

   THEN

      RETURN NEW;

   ELSE

      RETURN NULL;

   END IF;

END;$$;


ALTER FUNCTION public.new_anime_recommendations_upsert_filter() OWNER TO supabase_admin;

--
-- Name: new_anime_relations_upsert_filter(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.new_anime_relations_upsert_filter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   IF EXISTS(SELECT 1 FROM kaguya_anime WHERE id = NEW."relationId")

   THEN

      RETURN NEW;

   ELSE

      RETURN NULL;

   END IF;

END;$$;


ALTER FUNCTION public.new_anime_relations_upsert_filter() OWNER TO supabase_admin;

--
-- Name: new_manga_recommendations_upsert_filter(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.new_manga_recommendations_upsert_filter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   IF EXISTS(SELECT 1 FROM kaguya_manga WHERE id = NEW."recommendationId")

   THEN

      RETURN NEW;

   ELSE

      RETURN NULL;

   END IF;

END;$$;


ALTER FUNCTION public.new_manga_recommendations_upsert_filter() OWNER TO supabase_admin;

--
-- Name: new_manga_relations_upsert_filter(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.new_manga_relations_upsert_filter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   IF EXISTS(SELECT 1 FROM kaguya_manga WHERE id = NEW."relationId")

   THEN

      RETURN NEW;

   ELSE

      RETURN NULL;

   END IF;

END;$$;


ALTER FUNCTION public.new_manga_relations_upsert_filter() OWNER TO supabase_admin;

--
-- Name: update_anime_episodes(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_anime_episodes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

  BEGIN

    update kaguya_anime set "episodeUpdatedAt" = current_timestamp where id = (select "mediaId" from kaguya_anime_source where id = NEW."sourceConnectionId");



    RETURN NEW;

  END;

$$;


ALTER FUNCTION public.update_anime_episodes() OWNER TO supabase_admin;

--
-- Name: update_manga_chapters(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_manga_chapters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

  BEGIN

    update kaguya_manga set "chapterUpdatedAt" = current_timestamp where id = (select "mediaId" from kaguya_manga_source where id = NEW."sourceConnectionId");



    RETURN NEW;

  END;

$$;


ALTER FUNCTION public.update_manga_chapters() OWNER TO supabase_admin;

--
-- Name: update_new_anime_episodes(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_new_anime_episodes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

  BEGIN

    IF EXISTS(SELECT 1 FROM kaguya_episodes where "sourceEpisodeId" = new."sourceEpisodeId" AND "sourceId" = new."sourceId")

    THEN

        RETURN NULL;

    END IF;



    update kaguya_anime set "episodeUpdatedAt" = current_timestamp where id = NEW."mediaId";



    RETURN NEW;

  END;

$$;


ALTER FUNCTION public.update_new_anime_episodes() OWNER TO supabase_admin;

--
-- Name: updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

    NEW.updated_at = now();

    RETURN NEW;

END;

$$;


ALTER FUNCTION public.updated_at() OWNER TO supabase_admin;

--
-- Name: upsert_anime(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.upsert_anime() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

  BEGIN

    NEW."vietnameseTitle" = OLD."vietnameseTitle";

    NEW.description = OLD.description;

    

    RETURN NEW;

  END;

$$;


ALTER FUNCTION public.upsert_anime() OWNER TO supabase_admin;

--
-- Name: upsert_data(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.upsert_data() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

  BEGIN

    IF ((OLD.title::JSONB->>'vietnamese') IS NOT NULL AND (OLD.title::JSONB->>'vietnamese') != '')

    THEN

      NEW.title = OLD.title::JSONB || NEW.title::JSONB;

    END IF;



    IF ((OLD.description::JSONB->>'vietnamese') IS NOT NULL AND (OLD.description::JSONB->>'vietnamese') != '')

    THEN

      NEW.description = OLD.description::JSONB || NEW.description::JSONB;

    END IF;

    

    RETURN NEW;

  END;

$$;


ALTER FUNCTION public.upsert_data() OWNER TO supabase_admin;

--
-- Name: kaguya_voice_actors; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_voice_actors (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    name jsonb,
    language character varying,
    image jsonb,
    "primaryOccupations" character varying[],
    gender character varying,
    "dateOfBirth" jsonb,
    "dateOfDeath" jsonb,
    age smallint,
    "yearsActive" smallint[],
    "homeTown" character varying,
    "bloodType" character varying,
    favourites smallint
);


ALTER TABLE public.kaguya_voice_actors OWNER TO supabase_admin;

--
-- Name: voice_actors_search(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.voice_actors_search(keyword text) RETURNS SETOF public.kaguya_voice_actors
    LANGUAGE plpgsql
    AS $$

  begin

  return query select * from kaguya_voice_actors where to_tsvector(name) @@ plainto_tsquery(keyword);

  end

$$;


ALTER FUNCTION public.voice_actors_search(keyword text) OWNER TO supabase_admin;

--
-- Name: comment_reactions; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.comment_reactions (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    emoji character varying NOT NULL,
    user_id uuid NOT NULL,
    comment_id bigint NOT NULL
);


ALTER TABLE public.comment_reactions OWNER TO supabase_admin;

--
-- Name: comment_reactions_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.comment_reactions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.comment_reactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: comments; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.comments (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    body text NOT NULL,
    anime_id bigint,
    manga_id bigint,
    user_id uuid NOT NULL,
    is_reply boolean DEFAULT false,
    is_edited boolean DEFAULT false
);


ALTER TABLE public.comments OWNER TO supabase_admin;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.comments ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kaguya_airing_schedules; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_airing_schedules (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    "airingAt" bigint,
    episode smallint NOT NULL,
    "mediaId" bigint NOT NULL
);


ALTER TABLE public.kaguya_airing_schedules OWNER TO supabase_admin;

--
-- Name: kaguya_airing_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_airing_schedules ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.kaguya_airing_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kaguya_anime_characters; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_anime_characters (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    "characterId" bigint NOT NULL,
    role character varying,
    "mediaId" bigint NOT NULL,
    name character varying
);


ALTER TABLE public.kaguya_anime_characters OWNER TO supabase_admin;

--
-- Name: kaguya_anime_characters_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_anime_characters ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.kaguya_anime_characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kaguya_anime_recommendations; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_anime_recommendations (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    "recommendationId" bigint NOT NULL,
    "originalId" bigint NOT NULL,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.kaguya_anime_recommendations OWNER TO supabase_admin;

--
-- Name: kaguya_anime_recommendations_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_anime_recommendations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.kaguya_anime_recommendations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kaguya_anime_relations; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_anime_relations (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    "relationId" bigint NOT NULL,
    "originalId" bigint NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    "relationType" text
);


ALTER TABLE public.kaguya_anime_relations OWNER TO supabase_admin;

--
-- Name: kaguya_anime_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_anime_relations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.kaguya_anime_relations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kaguya_anime_source; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_anime_source (
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    "mediaId" bigint NOT NULL,
    "sourceMediaId" character varying NOT NULL,
    "sourceId" character varying NOT NULL,
    id character varying NOT NULL
);


ALTER TABLE public.kaguya_anime_source OWNER TO supabase_admin;

--
-- Name: kaguya_anime_subscribers; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_anime_subscribers (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    "userId" uuid,
    "mediaId" bigint
);


ALTER TABLE public.kaguya_anime_subscribers OWNER TO supabase_admin;

--
-- Name: kaguya_anime_subscribers_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_anime_subscribers ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.kaguya_anime_subscribers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kaguya_chapters; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_chapters (
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    name character varying NOT NULL,
    "sourceMediaId" character varying,
    "sourceChapterId" character varying NOT NULL,
    "sourceId" character varying NOT NULL,
    slug character varying NOT NULL,
    "sourceConnectionId" character varying
);


ALTER TABLE public.kaguya_chapters OWNER TO supabase_admin;

--
-- Name: kaguya_characters_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_characters ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.kaguya_characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kaguya_episodes; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_episodes (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    name character varying NOT NULL,
    "sourceId" character varying NOT NULL,
    "sourceEpisodeId" character varying NOT NULL,
    "sourceMediaId" character varying(255),
    slug character varying NOT NULL,
    "sourceConnectionId" character varying
);


ALTER TABLE public.kaguya_episodes OWNER TO supabase_admin;

--
-- Name: kaguya_episodes_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_episodes ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.kaguya_episodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kaguya_manga_characters; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_manga_characters (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    "characterId" bigint NOT NULL,
    role character varying,
    "mediaId" bigint NOT NULL,
    name character varying
);


ALTER TABLE public.kaguya_manga_characters OWNER TO supabase_admin;

--
-- Name: kaguya_manga_characters_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_manga_characters ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.kaguya_manga_characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kaguya_manga_recommendations; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_manga_recommendations (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    "recommendationId" bigint NOT NULL,
    "originalId" bigint NOT NULL,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.kaguya_manga_recommendations OWNER TO supabase_admin;

--
-- Name: kaguya_manga_recommendations_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_manga_recommendations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.kaguya_manga_recommendations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kaguya_manga_relations; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_manga_relations (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    "relationId" bigint NOT NULL,
    "originalId" bigint NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    "relationType" text
);


ALTER TABLE public.kaguya_manga_relations OWNER TO supabase_admin;

--
-- Name: kaguya_manga_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_manga_relations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.kaguya_manga_relations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kaguya_manga_source; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_manga_source (
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    "mediaId" bigint NOT NULL,
    "sourceMediaId" character varying NOT NULL,
    "sourceId" character varying NOT NULL,
    id character varying NOT NULL
);


ALTER TABLE public.kaguya_manga_source OWNER TO supabase_admin;

--
-- Name: kaguya_manga_subscribers; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_manga_subscribers (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    "userId" uuid,
    "mediaId" bigint
);


ALTER TABLE public.kaguya_manga_subscribers OWNER TO supabase_admin;

--
-- Name: kaguya_manga_subscribers_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_manga_subscribers ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.kaguya_manga_subscribers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kaguya_read; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_read (
    created_at timestamp with time zone DEFAULT now(),
    "userId" uuid NOT NULL,
    "mediaId" bigint NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    "chapterId" character varying NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.kaguya_read OWNER TO supabase_admin;

--
-- Name: kaguya_read_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_read ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.kaguya_read_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kaguya_read_status; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_read_status (
    created_at timestamp with time zone DEFAULT now(),
    status character varying,
    "mediaId" bigint NOT NULL,
    "userId" uuid NOT NULL
);


ALTER TABLE public.kaguya_read_status OWNER TO supabase_admin;

--
-- Name: kaguya_room_users; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_room_users (
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    "roomId" bigint,
    "userId" uuid,
    id character varying NOT NULL
);


ALTER TABLE public.kaguya_room_users OWNER TO supabase_admin;

--
-- Name: kaguya_rooms; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_rooms (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    "hostUserId" uuid,
    "mediaId" bigint,
    "episodeId" character varying,
    title character varying,
    visibility character varying DEFAULT 'public'::character varying
);


ALTER TABLE public.kaguya_rooms OWNER TO supabase_admin;

--
-- Name: kaguya_rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_rooms ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.kaguya_rooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kaguya_sources; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_sources (
    id character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    name character varying NOT NULL,
    locales character varying[]
);


ALTER TABLE public.kaguya_sources OWNER TO supabase_admin;

--
-- Name: kaguya_studio_connections; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_studio_connections (
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    "studioId" bigint NOT NULL,
    "isMain" boolean,
    "mediaId" bigint NOT NULL
);


ALTER TABLE public.kaguya_studio_connections OWNER TO supabase_admin;

--
-- Name: kaguya_studios; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_studios (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    "isAnimationStudio" boolean,
    favourites integer,
    name character varying
);


ALTER TABLE public.kaguya_studios OWNER TO supabase_admin;

--
-- Name: kaguya_subscriptions; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_subscriptions (
    created_at timestamp with time zone DEFAULT now(),
    subscription jsonb NOT NULL,
    "userId" uuid NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    "userAgent" character varying NOT NULL
);


ALTER TABLE public.kaguya_subscriptions OWNER TO supabase_admin;

--
-- Name: kaguya_voice_actor_connections; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_voice_actor_connections (
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    "voiceActorId" bigint NOT NULL,
    "characterId" bigint NOT NULL
);


ALTER TABLE public.kaguya_voice_actor_connections OWNER TO supabase_admin;

--
-- Name: kaguya_voice_actors_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_voice_actors ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.kaguya_voice_actors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kaguya_watch_status; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_watch_status (
    created_at timestamp with time zone DEFAULT now(),
    status character varying,
    "mediaId" bigint NOT NULL,
    "userId" uuid NOT NULL
);


ALTER TABLE public.kaguya_watch_status OWNER TO supabase_admin;

--
-- Name: kaguya_watched; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_watched (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    "userId" uuid NOT NULL,
    "mediaId" bigint NOT NULL,
    "watchedTime" real,
    "episodeId" character varying NOT NULL
);


ALTER TABLE public.kaguya_watched OWNER TO supabase_admin;

--
-- Name: kaguya_watched_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_watched ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.kaguya_watched_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: reply_comments; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.reply_comments (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    original_id bigint,
    reply_id bigint
);


ALTER TABLE public.reply_comments OWNER TO supabase_admin;

--
-- Name: reply_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.reply_comments ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.reply_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: studios_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_studios ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.studios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    user_metadata jsonb,
    raw_app_meta_data jsonb,
    email character varying,
    aud character varying,
    role character varying,
    auth_role character varying DEFAULT 'user'::character varying NOT NULL
);


ALTER TABLE public.users OWNER TO supabase_admin;

--
-- Name: comment_reactions comment_reactions_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.comment_reactions
    ADD CONSTRAINT comment_reactions_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: kaguya_airing_schedules kaguya_airing_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_airing_schedules
    ADD CONSTRAINT kaguya_airing_schedules_pkey PRIMARY KEY (episode, "mediaId");


--
-- Name: kaguya_anime_characters kaguya_anime_characters_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_anime_characters
    ADD CONSTRAINT kaguya_anime_characters_pkey PRIMARY KEY ("characterId", "mediaId");


--
-- Name: kaguya_anime kaguya_anime_id_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_anime
    ADD CONSTRAINT kaguya_anime_id_key UNIQUE (id);


--
-- Name: kaguya_anime kaguya_anime_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_anime
    ADD CONSTRAINT kaguya_anime_pkey PRIMARY KEY (id);


--
-- Name: kaguya_anime_recommendations kaguya_anime_recommendations_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_anime_recommendations
    ADD CONSTRAINT kaguya_anime_recommendations_pkey PRIMARY KEY ("originalId", "recommendationId");


--
-- Name: kaguya_anime_relations kaguya_anime_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_anime_relations
    ADD CONSTRAINT kaguya_anime_relations_pkey PRIMARY KEY ("originalId", "relationId");


--
-- Name: kaguya_anime_source kaguya_anime_source_id_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_anime_source
    ADD CONSTRAINT kaguya_anime_source_id_key UNIQUE (id);


--
-- Name: kaguya_anime_source kaguya_anime_source_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_anime_source
    ADD CONSTRAINT kaguya_anime_source_pkey PRIMARY KEY (id);


--
-- Name: kaguya_anime_subscribers kaguya_anime_subscribers_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_anime_subscribers
    ADD CONSTRAINT kaguya_anime_subscribers_pkey PRIMARY KEY (id);


--
-- Name: kaguya_chapters kaguya_chapters_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_chapters
    ADD CONSTRAINT kaguya_chapters_pkey PRIMARY KEY (slug);


--
-- Name: kaguya_chapters kaguya_chapters_slug_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_chapters
    ADD CONSTRAINT kaguya_chapters_slug_key UNIQUE (slug);


--
-- Name: kaguya_characters kaguya_characters_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_characters
    ADD CONSTRAINT kaguya_characters_pkey PRIMARY KEY (id);


--
-- Name: kaguya_episodes kaguya_episodes_id_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_episodes
    ADD CONSTRAINT kaguya_episodes_id_key UNIQUE (id);


--
-- Name: kaguya_episodes kaguya_episodes_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_episodes
    ADD CONSTRAINT kaguya_episodes_pkey PRIMARY KEY (slug);


--
-- Name: kaguya_episodes kaguya_episodes_slug_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_episodes
    ADD CONSTRAINT kaguya_episodes_slug_key UNIQUE (slug);


--
-- Name: kaguya_manga_characters kaguya_manga_characters_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_manga_characters
    ADD CONSTRAINT kaguya_manga_characters_pkey PRIMARY KEY ("characterId", "mediaId");


--
-- Name: kaguya_manga kaguya_manga_id_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_manga
    ADD CONSTRAINT kaguya_manga_id_key UNIQUE (id);


--
-- Name: kaguya_manga kaguya_manga_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_manga
    ADD CONSTRAINT kaguya_manga_pkey PRIMARY KEY (id);


--
-- Name: kaguya_manga_recommendations kaguya_manga_recommendations_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_manga_recommendations
    ADD CONSTRAINT kaguya_manga_recommendations_pkey PRIMARY KEY ("originalId", "recommendationId");


--
-- Name: kaguya_manga_relations kaguya_manga_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_manga_relations
    ADD CONSTRAINT kaguya_manga_relations_pkey PRIMARY KEY ("originalId", "relationId");


--
-- Name: kaguya_manga_source kaguya_manga_source_id_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_manga_source
    ADD CONSTRAINT kaguya_manga_source_id_key UNIQUE (id);


--
-- Name: kaguya_manga_source kaguya_manga_source_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_manga_source
    ADD CONSTRAINT kaguya_manga_source_pkey PRIMARY KEY (id);


--
-- Name: kaguya_manga_subscribers kaguya_manga_subscribers_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_manga_subscribers
    ADD CONSTRAINT kaguya_manga_subscribers_pkey PRIMARY KEY (id);


--
-- Name: kaguya_read kaguya_read_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_read
    ADD CONSTRAINT kaguya_read_pkey PRIMARY KEY ("mediaId", "userId");


--
-- Name: kaguya_read_status kaguya_read_status_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_read_status
    ADD CONSTRAINT kaguya_read_status_pkey PRIMARY KEY ("mediaId", "userId");


--
-- Name: kaguya_room_users kaguya_room_users_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_room_users
    ADD CONSTRAINT kaguya_room_users_pkey PRIMARY KEY (id);


--
-- Name: kaguya_rooms kaguya_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_rooms
    ADD CONSTRAINT kaguya_rooms_pkey PRIMARY KEY (id);


--
-- Name: kaguya_sources kaguya_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_sources
    ADD CONSTRAINT kaguya_sources_pkey PRIMARY KEY (id);


--
-- Name: kaguya_studio_connections kaguya_studio_connections_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_studio_connections
    ADD CONSTRAINT kaguya_studio_connections_pkey PRIMARY KEY ("studioId", "mediaId");


--
-- Name: kaguya_subscriptions kaguya_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_subscriptions
    ADD CONSTRAINT kaguya_subscriptions_pkey PRIMARY KEY ("userAgent", "userId");


--
-- Name: kaguya_voice_actor_connections kaguya_voice_actor_connections_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_voice_actor_connections
    ADD CONSTRAINT kaguya_voice_actor_connections_pkey PRIMARY KEY ("voiceActorId", "characterId");


--
-- Name: kaguya_voice_actors kaguya_voice_actors_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_voice_actors
    ADD CONSTRAINT kaguya_voice_actors_pkey PRIMARY KEY (id);


--
-- Name: kaguya_watch_status kaguya_watch_status_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_watch_status
    ADD CONSTRAINT kaguya_watch_status_pkey PRIMARY KEY ("mediaId", "userId");


--
-- Name: kaguya_watched kaguya_watched_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_watched
    ADD CONSTRAINT kaguya_watched_pkey PRIMARY KEY ("mediaId", "userId");


--
-- Name: reply_comments reply_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.reply_comments
    ADD CONSTRAINT reply_comments_pkey PRIMARY KEY (id);


--
-- Name: kaguya_studios studios_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_studios
    ADD CONSTRAINT studios_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: kaguya_episodes handle_anime_episodes_updated_at; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER handle_anime_episodes_updated_at BEFORE INSERT ON public.kaguya_episodes FOR EACH ROW EXECUTE FUNCTION public.update_anime_episodes();


--
-- Name: kaguya_anime handle_data_upsert; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER handle_data_upsert BEFORE UPDATE ON public.kaguya_anime FOR EACH ROW EXECUTE FUNCTION public.upsert_data();


--
-- Name: kaguya_manga handle_data_upsert; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER handle_data_upsert BEFORE UPDATE ON public.kaguya_manga FOR EACH ROW EXECUTE FUNCTION public.upsert_data();


--
-- Name: kaguya_chapters handle_manga_chapters_updated_at; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER handle_manga_chapters_updated_at BEFORE INSERT ON public.kaguya_chapters FOR EACH ROW EXECUTE FUNCTION public.update_manga_chapters();


--
-- Name: kaguya_anime_recommendations new_anime_recommendations_upsert_filter; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER new_anime_recommendations_upsert_filter BEFORE INSERT ON public.kaguya_anime_recommendations FOR EACH ROW EXECUTE FUNCTION public.new_anime_recommendations_upsert_filter();


--
-- Name: kaguya_anime_relations new_anime_relations_upsert_filter; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER new_anime_relations_upsert_filter BEFORE INSERT ON public.kaguya_anime_relations FOR EACH ROW EXECUTE FUNCTION public.new_anime_relations_upsert_filter();


--
-- Name: kaguya_manga_recommendations new_manga_recommendations_upsert_filter; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER new_manga_recommendations_upsert_filter BEFORE INSERT ON public.kaguya_manga_recommendations FOR EACH ROW EXECUTE FUNCTION public.new_manga_recommendations_upsert_filter();


--
-- Name: kaguya_manga_relations new_manga_relations_upsert_filter; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER new_manga_relations_upsert_filter BEFORE INSERT ON public.kaguya_manga_relations FOR EACH ROW EXECUTE FUNCTION public.new_manga_relations_upsert_filter();


--
-- Name: kaguya_airing_schedules update_updatedat_kaguya_airing_schedules; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_airing_schedules BEFORE UPDATE ON public.kaguya_airing_schedules FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_anime update_updatedat_kaguya_anime; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_anime BEFORE UPDATE ON public.kaguya_anime FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_anime_characters update_updatedat_kaguya_anime_characters; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_anime_characters BEFORE UPDATE ON public.kaguya_anime_characters FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_anime_recommendations update_updatedat_kaguya_anime_recommendations; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_anime_recommendations BEFORE UPDATE ON public.kaguya_anime_recommendations FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_anime_relations update_updatedat_kaguya_anime_relations; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_anime_relations BEFORE UPDATE ON public.kaguya_anime_relations FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_anime_source update_updatedat_kaguya_anime_source; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_anime_source BEFORE UPDATE ON public.kaguya_anime_source FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_chapters update_updatedat_kaguya_chapters; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_chapters BEFORE UPDATE ON public.kaguya_chapters FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_characters update_updatedat_kaguya_characters; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_characters BEFORE UPDATE ON public.kaguya_characters FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_episodes update_updatedat_kaguya_episodes; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_episodes BEFORE UPDATE ON public.kaguya_episodes FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_manga update_updatedat_kaguya_manga; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_manga BEFORE UPDATE ON public.kaguya_manga FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_manga_characters update_updatedat_kaguya_manga_characters; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_manga_characters BEFORE UPDATE ON public.kaguya_manga_characters FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_manga_recommendations update_updatedat_kaguya_manga_recommendations; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_manga_recommendations BEFORE UPDATE ON public.kaguya_manga_recommendations FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_manga_relations update_updatedat_kaguya_manga_relations; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_manga_relations BEFORE UPDATE ON public.kaguya_manga_relations FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_manga_source update_updatedat_kaguya_manga_source; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_manga_source BEFORE UPDATE ON public.kaguya_manga_source FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_read update_updatedat_kaguya_read; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_read BEFORE UPDATE ON public.kaguya_read FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_sources update_updatedat_kaguya_sources; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_sources BEFORE UPDATE ON public.kaguya_sources FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_studio_connections update_updatedat_kaguya_studio_connections; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_studio_connections BEFORE UPDATE ON public.kaguya_studio_connections FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_studios update_updatedat_kaguya_studios; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_studios BEFORE UPDATE ON public.kaguya_studios FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_subscriptions update_updatedat_kaguya_subscriptions; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_subscriptions BEFORE UPDATE ON public.kaguya_subscriptions FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_voice_actor_connections update_updatedat_kaguya_voice_actor_connections; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_voice_actor_connections BEFORE UPDATE ON public.kaguya_voice_actor_connections FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_voice_actors update_updatedat_kaguya_voice_actors; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_voice_actors BEFORE UPDATE ON public.kaguya_voice_actors FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_watched update_updatedat_kaguya_watched; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_watched BEFORE UPDATE ON public.kaguya_watched FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: comment_reactions comment_reactions_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.comment_reactions
    ADD CONSTRAINT comment_reactions_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES public.comments(id) ON DELETE CASCADE;


--
-- Name: comment_reactions comment_reactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.comment_reactions
    ADD CONSTRAINT comment_reactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: comments comments_anime_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_anime_id_fkey FOREIGN KEY (anime_id) REFERENCES public.kaguya_anime(id);


--
-- Name: comments comments_manga_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_manga_id_fkey FOREIGN KEY (manga_id) REFERENCES public.kaguya_manga(id);


--
-- Name: comments comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: kaguya_airing_schedules kaguya_airing_schedules_mediaId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_airing_schedules
    ADD CONSTRAINT "kaguya_airing_schedules_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES public.kaguya_anime(id) ON DELETE CASCADE;


--
-- Name: kaguya_anime_characters kaguya_anime_characters_characterId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_anime_characters
    ADD CONSTRAINT "kaguya_anime_characters_characterId_fkey" FOREIGN KEY ("characterId") REFERENCES public.kaguya_characters(id);


--
-- Name: kaguya_anime_characters kaguya_anime_characters_mediaId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_anime_characters
    ADD CONSTRAINT "kaguya_anime_characters_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES public.kaguya_anime(id) ON DELETE CASCADE;


--
-- Name: kaguya_anime_recommendations kaguya_anime_recommendations_originalId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_anime_recommendations
    ADD CONSTRAINT "kaguya_anime_recommendations_originalId_fkey" FOREIGN KEY ("originalId") REFERENCES public.kaguya_anime(id) ON DELETE CASCADE;


--
-- Name: kaguya_anime_recommendations kaguya_anime_recommendations_recommendationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_anime_recommendations
    ADD CONSTRAINT "kaguya_anime_recommendations_recommendationId_fkey" FOREIGN KEY ("recommendationId") REFERENCES public.kaguya_anime(id) ON DELETE CASCADE;


--
-- Name: kaguya_anime_relations kaguya_anime_relations_originalId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_anime_relations
    ADD CONSTRAINT "kaguya_anime_relations_originalId_fkey" FOREIGN KEY ("originalId") REFERENCES public.kaguya_anime(id) ON DELETE CASCADE;


--
-- Name: kaguya_anime_relations kaguya_anime_relations_relationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_anime_relations
    ADD CONSTRAINT "kaguya_anime_relations_relationId_fkey" FOREIGN KEY ("relationId") REFERENCES public.kaguya_anime(id) ON DELETE CASCADE;


--
-- Name: kaguya_anime_source kaguya_anime_source_mediaId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_anime_source
    ADD CONSTRAINT "kaguya_anime_source_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES public.kaguya_anime(id) ON DELETE CASCADE;


--
-- Name: kaguya_anime_source kaguya_anime_source_sourceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_anime_source
    ADD CONSTRAINT "kaguya_anime_source_sourceId_fkey" FOREIGN KEY ("sourceId") REFERENCES public.kaguya_sources(id) ON DELETE CASCADE;


--
-- Name: kaguya_anime_subscribers kaguya_anime_subscribers_mediaId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_anime_subscribers
    ADD CONSTRAINT "kaguya_anime_subscribers_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES public.kaguya_anime(id);


--
-- Name: kaguya_anime_subscribers kaguya_anime_subscribers_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_anime_subscribers
    ADD CONSTRAINT "kaguya_anime_subscribers_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id);


--
-- Name: kaguya_chapters kaguya_chapters_sourceConnectionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_chapters
    ADD CONSTRAINT "kaguya_chapters_sourceConnectionId_fkey" FOREIGN KEY ("sourceConnectionId") REFERENCES public.kaguya_manga_source(id) ON DELETE CASCADE;


--
-- Name: kaguya_chapters kaguya_chapters_sourceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_chapters
    ADD CONSTRAINT "kaguya_chapters_sourceId_fkey" FOREIGN KEY ("sourceId") REFERENCES public.kaguya_sources(id) ON DELETE CASCADE;


--
-- Name: kaguya_episodes kaguya_episodes_sourceConnectionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_episodes
    ADD CONSTRAINT "kaguya_episodes_sourceConnectionId_fkey" FOREIGN KEY ("sourceConnectionId") REFERENCES public.kaguya_anime_source(id) ON DELETE CASCADE;


--
-- Name: kaguya_episodes kaguya_episodes_sourceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_episodes
    ADD CONSTRAINT "kaguya_episodes_sourceId_fkey" FOREIGN KEY ("sourceId") REFERENCES public.kaguya_sources(id) ON DELETE CASCADE;


--
-- Name: kaguya_manga_characters kaguya_manga_characters_characterId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_manga_characters
    ADD CONSTRAINT "kaguya_manga_characters_characterId_fkey" FOREIGN KEY ("characterId") REFERENCES public.kaguya_characters(id);


--
-- Name: kaguya_manga_characters kaguya_manga_characters_mediaId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_manga_characters
    ADD CONSTRAINT "kaguya_manga_characters_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES public.kaguya_manga(id) ON DELETE CASCADE;


--
-- Name: kaguya_manga_recommendations kaguya_manga_recommendations_originalId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_manga_recommendations
    ADD CONSTRAINT "kaguya_manga_recommendations_originalId_fkey" FOREIGN KEY ("originalId") REFERENCES public.kaguya_manga(id) ON DELETE CASCADE;


--
-- Name: kaguya_manga_recommendations kaguya_manga_recommendations_recommendationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_manga_recommendations
    ADD CONSTRAINT "kaguya_manga_recommendations_recommendationId_fkey" FOREIGN KEY ("recommendationId") REFERENCES public.kaguya_manga(id) ON DELETE CASCADE;


--
-- Name: kaguya_manga_relations kaguya_manga_relations_originalId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_manga_relations
    ADD CONSTRAINT "kaguya_manga_relations_originalId_fkey" FOREIGN KEY ("originalId") REFERENCES public.kaguya_manga(id) ON DELETE CASCADE;


--
-- Name: kaguya_manga_relations kaguya_manga_relations_relationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_manga_relations
    ADD CONSTRAINT "kaguya_manga_relations_relationId_fkey" FOREIGN KEY ("relationId") REFERENCES public.kaguya_manga(id) ON DELETE CASCADE;


--
-- Name: kaguya_manga_source kaguya_manga_source_mediaId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_manga_source
    ADD CONSTRAINT "kaguya_manga_source_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES public.kaguya_manga(id) ON DELETE CASCADE;


--
-- Name: kaguya_manga_source kaguya_manga_source_sourceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_manga_source
    ADD CONSTRAINT "kaguya_manga_source_sourceId_fkey" FOREIGN KEY ("sourceId") REFERENCES public.kaguya_sources(id) ON DELETE CASCADE;


--
-- Name: kaguya_manga_subscribers kaguya_manga_subscribers_mediaId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_manga_subscribers
    ADD CONSTRAINT "kaguya_manga_subscribers_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES public.kaguya_manga(id);


--
-- Name: kaguya_manga_subscribers kaguya_manga_subscribers_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_manga_subscribers
    ADD CONSTRAINT "kaguya_manga_subscribers_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id);


--
-- Name: kaguya_read kaguya_read_chapterId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_read
    ADD CONSTRAINT "kaguya_read_chapterId_fkey" FOREIGN KEY ("chapterId") REFERENCES public.kaguya_chapters(slug) ON DELETE CASCADE;


--
-- Name: kaguya_read kaguya_read_mediaId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_read
    ADD CONSTRAINT "kaguya_read_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES public.kaguya_manga(id);


--
-- Name: kaguya_read_status kaguya_read_status_mediaId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_read_status
    ADD CONSTRAINT "kaguya_read_status_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES public.kaguya_manga(id) ON DELETE CASCADE;


--
-- Name: kaguya_read_status kaguya_read_status_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_read_status
    ADD CONSTRAINT "kaguya_read_status_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id);


--
-- Name: kaguya_read kaguya_read_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_read
    ADD CONSTRAINT "kaguya_read_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id);


--
-- Name: kaguya_room_users kaguya_room_users_roomId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_room_users
    ADD CONSTRAINT "kaguya_room_users_roomId_fkey" FOREIGN KEY ("roomId") REFERENCES public.kaguya_rooms(id) ON DELETE CASCADE;


--
-- Name: kaguya_room_users kaguya_room_users_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_room_users
    ADD CONSTRAINT "kaguya_room_users_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id);


--
-- Name: kaguya_rooms kaguya_rooms_episodeId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_rooms
    ADD CONSTRAINT "kaguya_rooms_episodeId_fkey" FOREIGN KEY ("episodeId") REFERENCES public.kaguya_episodes(slug);


--
-- Name: kaguya_rooms kaguya_rooms_hostUserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_rooms
    ADD CONSTRAINT "kaguya_rooms_hostUserId_fkey" FOREIGN KEY ("hostUserId") REFERENCES public.users(id);


--
-- Name: kaguya_rooms kaguya_rooms_mediaId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_rooms
    ADD CONSTRAINT "kaguya_rooms_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES public.kaguya_anime(id);


--
-- Name: kaguya_studio_connections kaguya_studio_connections_mediaId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_studio_connections
    ADD CONSTRAINT "kaguya_studio_connections_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES public.kaguya_anime(id) ON DELETE CASCADE;


--
-- Name: kaguya_studio_connections kaguya_studio_connections_studioId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_studio_connections
    ADD CONSTRAINT "kaguya_studio_connections_studioId_fkey" FOREIGN KEY ("studioId") REFERENCES public.kaguya_studios(id);


--
-- Name: kaguya_subscriptions kaguya_subscriptions_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_subscriptions
    ADD CONSTRAINT "kaguya_subscriptions_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id);


--
-- Name: kaguya_voice_actor_connections kaguya_voice_actor_connections_characterId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_voice_actor_connections
    ADD CONSTRAINT "kaguya_voice_actor_connections_characterId_fkey" FOREIGN KEY ("characterId") REFERENCES public.kaguya_characters(id);


--
-- Name: kaguya_voice_actor_connections kaguya_voice_actor_connections_voiceActorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_voice_actor_connections
    ADD CONSTRAINT "kaguya_voice_actor_connections_voiceActorId_fkey" FOREIGN KEY ("voiceActorId") REFERENCES public.kaguya_voice_actors(id);


--
-- Name: kaguya_watch_status kaguya_watch_status_mediaId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_watch_status
    ADD CONSTRAINT "kaguya_watch_status_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES public.kaguya_anime(id) ON DELETE CASCADE;


--
-- Name: kaguya_watch_status kaguya_watch_status_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_watch_status
    ADD CONSTRAINT "kaguya_watch_status_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id);


--
-- Name: kaguya_watched kaguya_watched_episodeId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_watched
    ADD CONSTRAINT "kaguya_watched_episodeId_fkey" FOREIGN KEY ("episodeId") REFERENCES public.kaguya_episodes(slug) ON DELETE CASCADE;


--
-- Name: kaguya_watched kaguya_watched_mediaId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_watched
    ADD CONSTRAINT "kaguya_watched_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES public.kaguya_anime(id);


--
-- Name: kaguya_watched kaguya_watched_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_watched
    ADD CONSTRAINT "kaguya_watched_userId_fkey" FOREIGN KEY ("userId") REFERENCES auth.users(id);


--
-- Name: reply_comments reply_comments_original_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.reply_comments
    ADD CONSTRAINT reply_comments_original_id_fkey FOREIGN KEY (original_id) REFERENCES public.comments(id) ON DELETE CASCADE;


--
-- Name: reply_comments reply_comments_reply_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.reply_comments
    ADD CONSTRAINT reply_comments_reply_id_fkey FOREIGN KEY (reply_id) REFERENCES public.comments(id) ON DELETE CASCADE;


--
-- Name: comment_reactions Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.comment_reactions FOR SELECT USING (true);


--
-- Name: comments Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.comments FOR SELECT USING (true);


--
-- Name: kaguya_airing_schedules Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_airing_schedules FOR SELECT USING (true);


--
-- Name: kaguya_anime Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_anime FOR SELECT USING (true);


--
-- Name: kaguya_anime_characters Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_anime_characters FOR SELECT USING (true);


--
-- Name: kaguya_anime_recommendations Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_anime_recommendations FOR SELECT USING (true);


--
-- Name: kaguya_anime_relations Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_anime_relations FOR SELECT USING (true);


--
-- Name: kaguya_anime_source Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_anime_source FOR SELECT USING (true);


--
-- Name: kaguya_anime_subscribers Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_anime_subscribers FOR SELECT USING (true);


--
-- Name: kaguya_chapters Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_chapters FOR SELECT USING (true);


--
-- Name: kaguya_characters Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_characters FOR SELECT USING (true);


--
-- Name: kaguya_episodes Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_episodes FOR SELECT USING (true);


--
-- Name: kaguya_manga Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_manga FOR SELECT USING (true);


--
-- Name: kaguya_manga_characters Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_manga_characters FOR SELECT USING (true);


--
-- Name: kaguya_manga_recommendations Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_manga_recommendations FOR SELECT USING (true);


--
-- Name: kaguya_manga_relations Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_manga_relations FOR SELECT USING (true);


--
-- Name: kaguya_manga_source Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_manga_source FOR SELECT USING (true);


--
-- Name: kaguya_manga_subscribers Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_manga_subscribers FOR SELECT USING (true);


--
-- Name: kaguya_read Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_read FOR SELECT USING (true);


--
-- Name: kaguya_read_status Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_read_status FOR SELECT USING (true);


--
-- Name: kaguya_room_users Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_room_users FOR SELECT USING (true);


--
-- Name: kaguya_rooms Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_rooms FOR SELECT USING (true);


--
-- Name: kaguya_sources Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_sources FOR SELECT USING (true);


--
-- Name: kaguya_studio_connections Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_studio_connections FOR SELECT USING (true);


--
-- Name: kaguya_studios Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_studios FOR SELECT USING (true);


--
-- Name: kaguya_subscriptions Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_subscriptions FOR SELECT USING (true);


--
-- Name: kaguya_voice_actor_connections Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_voice_actor_connections FOR SELECT USING (true);


--
-- Name: kaguya_voice_actors Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_voice_actors FOR SELECT USING (true);


--
-- Name: kaguya_watch_status Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_watch_status FOR SELECT USING (true);


--
-- Name: kaguya_watched Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_watched FOR SELECT USING (true);


--
-- Name: reply_comments Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.reply_comments FOR SELECT USING (true);


--
-- Name: users Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.users FOR SELECT USING (true);


--
-- Name: comment_reactions Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable delete for users based on user_id" ON public.comment_reactions FOR DELETE USING ((auth.uid() = user_id));


--
-- Name: comments Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable delete for users based on user_id" ON public.comments FOR DELETE USING ((auth.uid() = user_id));


--
-- Name: kaguya_anime_subscribers Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable delete for users based on user_id" ON public.kaguya_anime_subscribers FOR DELETE USING ((auth.uid() = "userId"));


--
-- Name: kaguya_manga_subscribers Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable delete for users based on user_id" ON public.kaguya_manga_subscribers FOR DELETE USING ((auth.uid() = "userId"));


--
-- Name: kaguya_room_users Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable delete for users based on user_id" ON public.kaguya_room_users FOR DELETE USING ((auth.uid() = "userId"));


--
-- Name: comment_reactions Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.comment_reactions FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: comments Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.comments FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: kaguya_anime_subscribers Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.kaguya_anime_subscribers FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: kaguya_manga_subscribers Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.kaguya_manga_subscribers FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: kaguya_read Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.kaguya_read FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: kaguya_read_status Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.kaguya_read_status FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: kaguya_room_users Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.kaguya_room_users FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: kaguya_rooms Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.kaguya_rooms FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: kaguya_subscriptions Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.kaguya_subscriptions FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: kaguya_watch_status Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.kaguya_watch_status FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: kaguya_watched Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.kaguya_watched FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: reply_comments Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.reply_comments FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: comment_reactions Enable update for users based on email; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on email" ON public.comment_reactions FOR UPDATE USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- Name: kaguya_anime_subscribers Enable update for users based on email; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on email" ON public.kaguya_anime_subscribers FOR UPDATE USING ((auth.uid() = "userId")) WITH CHECK ((auth.uid() = "userId"));


--
-- Name: kaguya_manga_subscribers Enable update for users based on email; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on email" ON public.kaguya_manga_subscribers FOR UPDATE USING ((auth.uid() = "userId")) WITH CHECK ((auth.uid() = "userId"));


--
-- Name: kaguya_read Enable update for users based on email; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on email" ON public.kaguya_read FOR UPDATE USING ((auth.uid() = "userId")) WITH CHECK ((auth.uid() = "userId"));


--
-- Name: kaguya_subscriptions Enable update for users based on email; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on email" ON public.kaguya_subscriptions FOR UPDATE USING ((auth.uid() = "userId")) WITH CHECK ((auth.uid() = "userId"));


--
-- Name: kaguya_watched Enable update for users based on email; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on email" ON public.kaguya_watched FOR UPDATE USING ((auth.uid() = "userId")) WITH CHECK ((auth.uid() = "userId"));


--
-- Name: kaguya_read_status Enable update for users based on id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on id" ON public.kaguya_read_status FOR UPDATE USING ((auth.uid() = "userId")) WITH CHECK ((auth.uid() = "userId"));


--
-- Name: kaguya_watch_status Enable update for users based on id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on id" ON public.kaguya_watch_status FOR UPDATE USING ((auth.uid() = "userId")) WITH CHECK ((auth.uid() = "userId"));


--
-- Name: comments Enable update for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on user_id" ON public.comments FOR UPDATE USING ((auth.uid() = user_id));


--
-- Name: kaguya_room_users Enable update for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on user_id" ON public.kaguya_room_users FOR UPDATE USING ((auth.uid() = "userId")) WITH CHECK ((auth.uid() = "userId"));


--
-- Name: comment_reactions; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.comment_reactions ENABLE ROW LEVEL SECURITY;

--
-- Name: comments; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_airing_schedules; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_airing_schedules ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_anime; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_anime ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_anime_characters; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_anime_characters ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_anime_recommendations; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_anime_recommendations ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_anime_relations; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_anime_relations ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_anime_source; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_anime_source ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_anime_subscribers; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_anime_subscribers ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_chapters; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_chapters ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_characters; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_characters ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_episodes; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_episodes ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_manga; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_manga ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_manga_characters; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_manga_characters ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_manga_recommendations; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_manga_recommendations ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_manga_relations; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_manga_relations ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_manga_source; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_manga_source ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_manga_subscribers; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_manga_subscribers ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_read; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_read ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_read_status; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_read_status ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_room_users; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_room_users ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_rooms; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_rooms ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_sources; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_sources ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_studio_connections; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_studio_connections ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_studios; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_studios ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_subscriptions; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_subscriptions ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_voice_actor_connections; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_voice_actor_connections ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_voice_actors; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_voice_actors ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_watch_status; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_watch_status ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_watched; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_watched ENABLE ROW LEVEL SECURITY;

--
-- Name: reply_comments; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.reply_comments ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: FUNCTION airing_schedule_filter(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.airing_schedule_filter() TO postgres;
GRANT ALL ON FUNCTION public.airing_schedule_filter() TO anon;
GRANT ALL ON FUNCTION public.airing_schedule_filter() TO authenticated;
GRANT ALL ON FUNCTION public.airing_schedule_filter() TO service_role;


--
-- Name: TABLE kaguya_anime; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_anime TO postgres;
GRANT ALL ON TABLE public.kaguya_anime TO anon;
GRANT ALL ON TABLE public.kaguya_anime TO authenticated;
GRANT ALL ON TABLE public.kaguya_anime TO service_role;


--
-- Name: FUNCTION anime_random(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.anime_random() TO postgres;
GRANT ALL ON FUNCTION public.anime_random() TO anon;
GRANT ALL ON FUNCTION public.anime_random() TO authenticated;
GRANT ALL ON FUNCTION public.anime_random() TO service_role;


--
-- Name: FUNCTION anime_recommendations_upsert_filter(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.anime_recommendations_upsert_filter() TO postgres;
GRANT ALL ON FUNCTION public.anime_recommendations_upsert_filter() TO anon;
GRANT ALL ON FUNCTION public.anime_recommendations_upsert_filter() TO authenticated;
GRANT ALL ON FUNCTION public.anime_recommendations_upsert_filter() TO service_role;


--
-- Name: FUNCTION anime_relations_upsert_filter(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.anime_relations_upsert_filter() TO postgres;
GRANT ALL ON FUNCTION public.anime_relations_upsert_filter() TO anon;
GRANT ALL ON FUNCTION public.anime_relations_upsert_filter() TO authenticated;
GRANT ALL ON FUNCTION public.anime_relations_upsert_filter() TO service_role;


--
-- Name: FUNCTION anime_search(string text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.anime_search(string text) TO postgres;
GRANT ALL ON FUNCTION public.anime_search(string text) TO anon;
GRANT ALL ON FUNCTION public.anime_search(string text) TO authenticated;
GRANT ALL ON FUNCTION public.anime_search(string text) TO service_role;


--
-- Name: FUNCTION arr2text(ci text[]); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.arr2text(ci text[]) TO postgres;
GRANT ALL ON FUNCTION public.arr2text(ci text[]) TO anon;
GRANT ALL ON FUNCTION public.arr2text(ci text[]) TO authenticated;
GRANT ALL ON FUNCTION public.arr2text(ci text[]) TO service_role;


--
-- Name: FUNCTION both_search(string text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.both_search(string text) TO postgres;
GRANT ALL ON FUNCTION public.both_search(string text) TO anon;
GRANT ALL ON FUNCTION public.both_search(string text) TO authenticated;
GRANT ALL ON FUNCTION public.both_search(string text) TO service_role;


--
-- Name: FUNCTION character_filter(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.character_filter() TO postgres;
GRANT ALL ON FUNCTION public.character_filter() TO anon;
GRANT ALL ON FUNCTION public.character_filter() TO authenticated;
GRANT ALL ON FUNCTION public.character_filter() TO service_role;


--
-- Name: TABLE kaguya_characters; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_characters TO postgres;
GRANT ALL ON TABLE public.kaguya_characters TO anon;
GRANT ALL ON TABLE public.kaguya_characters TO authenticated;
GRANT ALL ON TABLE public.kaguya_characters TO service_role;


--
-- Name: FUNCTION characters_search(keyword text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.characters_search(keyword text) TO postgres;
GRANT ALL ON FUNCTION public.characters_search(keyword text) TO anon;
GRANT ALL ON FUNCTION public.characters_search(keyword text) TO authenticated;
GRANT ALL ON FUNCTION public.characters_search(keyword text) TO service_role;


--
-- Name: FUNCTION delete_expired_schedules(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.delete_expired_schedules() TO postgres;
GRANT ALL ON FUNCTION public.delete_expired_schedules() TO anon;
GRANT ALL ON FUNCTION public.delete_expired_schedules() TO authenticated;
GRANT ALL ON FUNCTION public.delete_expired_schedules() TO service_role;


--
-- Name: FUNCTION generate_create_table_statement(p_table_name character varying); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.generate_create_table_statement(p_table_name character varying) TO anon;
GRANT ALL ON FUNCTION public.generate_create_table_statement(p_table_name character varying) TO authenticated;
GRANT ALL ON FUNCTION public.generate_create_table_statement(p_table_name character varying) TO service_role;


--
-- Name: FUNCTION handle_new_user(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.handle_new_user() TO postgres;
GRANT ALL ON FUNCTION public.handle_new_user() TO anon;
GRANT ALL ON FUNCTION public.handle_new_user() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_user() TO service_role;


--
-- Name: FUNCTION manga_character_filter(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.manga_character_filter() TO postgres;
GRANT ALL ON FUNCTION public.manga_character_filter() TO anon;
GRANT ALL ON FUNCTION public.manga_character_filter() TO authenticated;
GRANT ALL ON FUNCTION public.manga_character_filter() TO service_role;


--
-- Name: TABLE kaguya_manga; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_manga TO postgres;
GRANT ALL ON TABLE public.kaguya_manga TO anon;
GRANT ALL ON TABLE public.kaguya_manga TO authenticated;
GRANT ALL ON TABLE public.kaguya_manga TO service_role;


--
-- Name: FUNCTION manga_random(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.manga_random() TO postgres;
GRANT ALL ON FUNCTION public.manga_random() TO anon;
GRANT ALL ON FUNCTION public.manga_random() TO authenticated;
GRANT ALL ON FUNCTION public.manga_random() TO service_role;


--
-- Name: FUNCTION manga_recommendations_upsert_filter(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.manga_recommendations_upsert_filter() TO postgres;
GRANT ALL ON FUNCTION public.manga_recommendations_upsert_filter() TO anon;
GRANT ALL ON FUNCTION public.manga_recommendations_upsert_filter() TO authenticated;
GRANT ALL ON FUNCTION public.manga_recommendations_upsert_filter() TO service_role;


--
-- Name: FUNCTION manga_relations_upsert_filter(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.manga_relations_upsert_filter() TO postgres;
GRANT ALL ON FUNCTION public.manga_relations_upsert_filter() TO anon;
GRANT ALL ON FUNCTION public.manga_relations_upsert_filter() TO authenticated;
GRANT ALL ON FUNCTION public.manga_relations_upsert_filter() TO service_role;


--
-- Name: FUNCTION manga_search(string text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.manga_search(string text) TO postgres;
GRANT ALL ON FUNCTION public.manga_search(string text) TO anon;
GRANT ALL ON FUNCTION public.manga_search(string text) TO authenticated;
GRANT ALL ON FUNCTION public.manga_search(string text) TO service_role;


--
-- Name: FUNCTION new_anime_recommendations_upsert_filter(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.new_anime_recommendations_upsert_filter() TO postgres;
GRANT ALL ON FUNCTION public.new_anime_recommendations_upsert_filter() TO anon;
GRANT ALL ON FUNCTION public.new_anime_recommendations_upsert_filter() TO authenticated;
GRANT ALL ON FUNCTION public.new_anime_recommendations_upsert_filter() TO service_role;


--
-- Name: FUNCTION new_anime_relations_upsert_filter(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.new_anime_relations_upsert_filter() TO postgres;
GRANT ALL ON FUNCTION public.new_anime_relations_upsert_filter() TO anon;
GRANT ALL ON FUNCTION public.new_anime_relations_upsert_filter() TO authenticated;
GRANT ALL ON FUNCTION public.new_anime_relations_upsert_filter() TO service_role;


--
-- Name: FUNCTION new_manga_recommendations_upsert_filter(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.new_manga_recommendations_upsert_filter() TO postgres;
GRANT ALL ON FUNCTION public.new_manga_recommendations_upsert_filter() TO anon;
GRANT ALL ON FUNCTION public.new_manga_recommendations_upsert_filter() TO authenticated;
GRANT ALL ON FUNCTION public.new_manga_recommendations_upsert_filter() TO service_role;


--
-- Name: FUNCTION new_manga_relations_upsert_filter(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.new_manga_relations_upsert_filter() TO postgres;
GRANT ALL ON FUNCTION public.new_manga_relations_upsert_filter() TO anon;
GRANT ALL ON FUNCTION public.new_manga_relations_upsert_filter() TO authenticated;
GRANT ALL ON FUNCTION public.new_manga_relations_upsert_filter() TO service_role;


--
-- Name: FUNCTION update_anime_episodes(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.update_anime_episodes() TO postgres;
GRANT ALL ON FUNCTION public.update_anime_episodes() TO anon;
GRANT ALL ON FUNCTION public.update_anime_episodes() TO authenticated;
GRANT ALL ON FUNCTION public.update_anime_episodes() TO service_role;


--
-- Name: FUNCTION update_manga_chapters(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.update_manga_chapters() TO postgres;
GRANT ALL ON FUNCTION public.update_manga_chapters() TO anon;
GRANT ALL ON FUNCTION public.update_manga_chapters() TO authenticated;
GRANT ALL ON FUNCTION public.update_manga_chapters() TO service_role;


--
-- Name: FUNCTION update_new_anime_episodes(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.update_new_anime_episodes() TO postgres;
GRANT ALL ON FUNCTION public.update_new_anime_episodes() TO anon;
GRANT ALL ON FUNCTION public.update_new_anime_episodes() TO authenticated;
GRANT ALL ON FUNCTION public.update_new_anime_episodes() TO service_role;


--
-- Name: FUNCTION updated_at(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.updated_at() TO postgres;
GRANT ALL ON FUNCTION public.updated_at() TO anon;
GRANT ALL ON FUNCTION public.updated_at() TO authenticated;
GRANT ALL ON FUNCTION public.updated_at() TO service_role;


--
-- Name: FUNCTION upsert_anime(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.upsert_anime() TO postgres;
GRANT ALL ON FUNCTION public.upsert_anime() TO anon;
GRANT ALL ON FUNCTION public.upsert_anime() TO authenticated;
GRANT ALL ON FUNCTION public.upsert_anime() TO service_role;


--
-- Name: FUNCTION upsert_data(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.upsert_data() TO postgres;
GRANT ALL ON FUNCTION public.upsert_data() TO anon;
GRANT ALL ON FUNCTION public.upsert_data() TO authenticated;
GRANT ALL ON FUNCTION public.upsert_data() TO service_role;


--
-- Name: TABLE kaguya_voice_actors; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_voice_actors TO postgres;
GRANT ALL ON TABLE public.kaguya_voice_actors TO anon;
GRANT ALL ON TABLE public.kaguya_voice_actors TO authenticated;
GRANT ALL ON TABLE public.kaguya_voice_actors TO service_role;


--
-- Name: FUNCTION voice_actors_search(keyword text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.voice_actors_search(keyword text) TO postgres;
GRANT ALL ON FUNCTION public.voice_actors_search(keyword text) TO anon;
GRANT ALL ON FUNCTION public.voice_actors_search(keyword text) TO authenticated;
GRANT ALL ON FUNCTION public.voice_actors_search(keyword text) TO service_role;


--
-- Name: TABLE comment_reactions; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.comment_reactions TO postgres;
GRANT ALL ON TABLE public.comment_reactions TO anon;
GRANT ALL ON TABLE public.comment_reactions TO authenticated;
GRANT ALL ON TABLE public.comment_reactions TO service_role;


--
-- Name: SEQUENCE comment_reactions_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.comment_reactions_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.comment_reactions_id_seq TO anon;
GRANT ALL ON SEQUENCE public.comment_reactions_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.comment_reactions_id_seq TO service_role;


--
-- Name: TABLE comments; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.comments TO postgres;
GRANT ALL ON TABLE public.comments TO anon;
GRANT ALL ON TABLE public.comments TO authenticated;
GRANT ALL ON TABLE public.comments TO service_role;


--
-- Name: SEQUENCE comments_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.comments_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.comments_id_seq TO anon;
GRANT ALL ON SEQUENCE public.comments_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.comments_id_seq TO service_role;


--
-- Name: TABLE kaguya_airing_schedules; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_airing_schedules TO postgres;
GRANT ALL ON TABLE public.kaguya_airing_schedules TO anon;
GRANT ALL ON TABLE public.kaguya_airing_schedules TO authenticated;
GRANT ALL ON TABLE public.kaguya_airing_schedules TO service_role;


--
-- Name: SEQUENCE kaguya_airing_schedules_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.kaguya_airing_schedules_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.kaguya_airing_schedules_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kaguya_airing_schedules_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kaguya_airing_schedules_id_seq TO service_role;


--
-- Name: TABLE kaguya_anime_characters; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_anime_characters TO postgres;
GRANT ALL ON TABLE public.kaguya_anime_characters TO anon;
GRANT ALL ON TABLE public.kaguya_anime_characters TO authenticated;
GRANT ALL ON TABLE public.kaguya_anime_characters TO service_role;


--
-- Name: SEQUENCE kaguya_anime_characters_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.kaguya_anime_characters_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.kaguya_anime_characters_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kaguya_anime_characters_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kaguya_anime_characters_id_seq TO service_role;


--
-- Name: TABLE kaguya_anime_recommendations; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_anime_recommendations TO postgres;
GRANT ALL ON TABLE public.kaguya_anime_recommendations TO anon;
GRANT ALL ON TABLE public.kaguya_anime_recommendations TO authenticated;
GRANT ALL ON TABLE public.kaguya_anime_recommendations TO service_role;


--
-- Name: SEQUENCE kaguya_anime_recommendations_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.kaguya_anime_recommendations_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.kaguya_anime_recommendations_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kaguya_anime_recommendations_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kaguya_anime_recommendations_id_seq TO service_role;


--
-- Name: TABLE kaguya_anime_relations; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_anime_relations TO postgres;
GRANT ALL ON TABLE public.kaguya_anime_relations TO anon;
GRANT ALL ON TABLE public.kaguya_anime_relations TO authenticated;
GRANT ALL ON TABLE public.kaguya_anime_relations TO service_role;


--
-- Name: SEQUENCE kaguya_anime_relations_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.kaguya_anime_relations_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.kaguya_anime_relations_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kaguya_anime_relations_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kaguya_anime_relations_id_seq TO service_role;


--
-- Name: TABLE kaguya_anime_source; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_anime_source TO postgres;
GRANT ALL ON TABLE public.kaguya_anime_source TO anon;
GRANT ALL ON TABLE public.kaguya_anime_source TO authenticated;
GRANT ALL ON TABLE public.kaguya_anime_source TO service_role;


--
-- Name: TABLE kaguya_anime_subscribers; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_anime_subscribers TO postgres;
GRANT ALL ON TABLE public.kaguya_anime_subscribers TO anon;
GRANT ALL ON TABLE public.kaguya_anime_subscribers TO authenticated;
GRANT ALL ON TABLE public.kaguya_anime_subscribers TO service_role;


--
-- Name: SEQUENCE kaguya_anime_subscribers_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.kaguya_anime_subscribers_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.kaguya_anime_subscribers_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kaguya_anime_subscribers_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kaguya_anime_subscribers_id_seq TO service_role;


--
-- Name: TABLE kaguya_chapters; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_chapters TO postgres;
GRANT ALL ON TABLE public.kaguya_chapters TO anon;
GRANT ALL ON TABLE public.kaguya_chapters TO authenticated;
GRANT ALL ON TABLE public.kaguya_chapters TO service_role;


--
-- Name: SEQUENCE kaguya_characters_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.kaguya_characters_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.kaguya_characters_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kaguya_characters_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kaguya_characters_id_seq TO service_role;


--
-- Name: TABLE kaguya_episodes; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_episodes TO postgres;
GRANT ALL ON TABLE public.kaguya_episodes TO anon;
GRANT ALL ON TABLE public.kaguya_episodes TO authenticated;
GRANT ALL ON TABLE public.kaguya_episodes TO service_role;


--
-- Name: SEQUENCE kaguya_episodes_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.kaguya_episodes_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.kaguya_episodes_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kaguya_episodes_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kaguya_episodes_id_seq TO service_role;


--
-- Name: TABLE kaguya_manga_characters; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_manga_characters TO postgres;
GRANT ALL ON TABLE public.kaguya_manga_characters TO anon;
GRANT ALL ON TABLE public.kaguya_manga_characters TO authenticated;
GRANT ALL ON TABLE public.kaguya_manga_characters TO service_role;


--
-- Name: SEQUENCE kaguya_manga_characters_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.kaguya_manga_characters_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.kaguya_manga_characters_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kaguya_manga_characters_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kaguya_manga_characters_id_seq TO service_role;


--
-- Name: TABLE kaguya_manga_recommendations; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_manga_recommendations TO postgres;
GRANT ALL ON TABLE public.kaguya_manga_recommendations TO anon;
GRANT ALL ON TABLE public.kaguya_manga_recommendations TO authenticated;
GRANT ALL ON TABLE public.kaguya_manga_recommendations TO service_role;


--
-- Name: SEQUENCE kaguya_manga_recommendations_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.kaguya_manga_recommendations_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.kaguya_manga_recommendations_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kaguya_manga_recommendations_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kaguya_manga_recommendations_id_seq TO service_role;


--
-- Name: TABLE kaguya_manga_relations; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_manga_relations TO postgres;
GRANT ALL ON TABLE public.kaguya_manga_relations TO anon;
GRANT ALL ON TABLE public.kaguya_manga_relations TO authenticated;
GRANT ALL ON TABLE public.kaguya_manga_relations TO service_role;


--
-- Name: SEQUENCE kaguya_manga_relations_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.kaguya_manga_relations_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.kaguya_manga_relations_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kaguya_manga_relations_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kaguya_manga_relations_id_seq TO service_role;


--
-- Name: TABLE kaguya_manga_source; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_manga_source TO postgres;
GRANT ALL ON TABLE public.kaguya_manga_source TO anon;
GRANT ALL ON TABLE public.kaguya_manga_source TO authenticated;
GRANT ALL ON TABLE public.kaguya_manga_source TO service_role;


--
-- Name: TABLE kaguya_manga_subscribers; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_manga_subscribers TO postgres;
GRANT ALL ON TABLE public.kaguya_manga_subscribers TO anon;
GRANT ALL ON TABLE public.kaguya_manga_subscribers TO authenticated;
GRANT ALL ON TABLE public.kaguya_manga_subscribers TO service_role;


--
-- Name: SEQUENCE kaguya_manga_subscribers_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.kaguya_manga_subscribers_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.kaguya_manga_subscribers_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kaguya_manga_subscribers_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kaguya_manga_subscribers_id_seq TO service_role;


--
-- Name: TABLE kaguya_read; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_read TO postgres;
GRANT ALL ON TABLE public.kaguya_read TO anon;
GRANT ALL ON TABLE public.kaguya_read TO authenticated;
GRANT ALL ON TABLE public.kaguya_read TO service_role;


--
-- Name: SEQUENCE kaguya_read_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.kaguya_read_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.kaguya_read_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kaguya_read_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kaguya_read_id_seq TO service_role;


--
-- Name: TABLE kaguya_read_status; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_read_status TO postgres;
GRANT ALL ON TABLE public.kaguya_read_status TO anon;
GRANT ALL ON TABLE public.kaguya_read_status TO authenticated;
GRANT ALL ON TABLE public.kaguya_read_status TO service_role;


--
-- Name: TABLE kaguya_room_users; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_room_users TO postgres;
GRANT ALL ON TABLE public.kaguya_room_users TO anon;
GRANT ALL ON TABLE public.kaguya_room_users TO authenticated;
GRANT ALL ON TABLE public.kaguya_room_users TO service_role;


--
-- Name: TABLE kaguya_rooms; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_rooms TO postgres;
GRANT ALL ON TABLE public.kaguya_rooms TO anon;
GRANT ALL ON TABLE public.kaguya_rooms TO authenticated;
GRANT ALL ON TABLE public.kaguya_rooms TO service_role;


--
-- Name: SEQUENCE kaguya_rooms_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.kaguya_rooms_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.kaguya_rooms_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kaguya_rooms_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kaguya_rooms_id_seq TO service_role;


--
-- Name: TABLE kaguya_sources; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_sources TO postgres;
GRANT ALL ON TABLE public.kaguya_sources TO anon;
GRANT ALL ON TABLE public.kaguya_sources TO authenticated;
GRANT ALL ON TABLE public.kaguya_sources TO service_role;


--
-- Name: TABLE kaguya_studio_connections; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_studio_connections TO postgres;
GRANT ALL ON TABLE public.kaguya_studio_connections TO anon;
GRANT ALL ON TABLE public.kaguya_studio_connections TO authenticated;
GRANT ALL ON TABLE public.kaguya_studio_connections TO service_role;


--
-- Name: TABLE kaguya_studios; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_studios TO postgres;
GRANT ALL ON TABLE public.kaguya_studios TO anon;
GRANT ALL ON TABLE public.kaguya_studios TO authenticated;
GRANT ALL ON TABLE public.kaguya_studios TO service_role;


--
-- Name: TABLE kaguya_subscriptions; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_subscriptions TO postgres;
GRANT ALL ON TABLE public.kaguya_subscriptions TO anon;
GRANT ALL ON TABLE public.kaguya_subscriptions TO authenticated;
GRANT ALL ON TABLE public.kaguya_subscriptions TO service_role;


--
-- Name: TABLE kaguya_voice_actor_connections; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_voice_actor_connections TO postgres;
GRANT ALL ON TABLE public.kaguya_voice_actor_connections TO anon;
GRANT ALL ON TABLE public.kaguya_voice_actor_connections TO authenticated;
GRANT ALL ON TABLE public.kaguya_voice_actor_connections TO service_role;


--
-- Name: SEQUENCE kaguya_voice_actors_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.kaguya_voice_actors_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.kaguya_voice_actors_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kaguya_voice_actors_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kaguya_voice_actors_id_seq TO service_role;


--
-- Name: TABLE kaguya_watch_status; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_watch_status TO postgres;
GRANT ALL ON TABLE public.kaguya_watch_status TO anon;
GRANT ALL ON TABLE public.kaguya_watch_status TO authenticated;
GRANT ALL ON TABLE public.kaguya_watch_status TO service_role;


--
-- Name: TABLE kaguya_watched; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_watched TO postgres;
GRANT ALL ON TABLE public.kaguya_watched TO anon;
GRANT ALL ON TABLE public.kaguya_watched TO authenticated;
GRANT ALL ON TABLE public.kaguya_watched TO service_role;


--
-- Name: SEQUENCE kaguya_watched_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.kaguya_watched_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.kaguya_watched_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kaguya_watched_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kaguya_watched_id_seq TO service_role;


--
-- Name: TABLE reply_comments; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.reply_comments TO postgres;
GRANT ALL ON TABLE public.reply_comments TO anon;
GRANT ALL ON TABLE public.reply_comments TO authenticated;
GRANT ALL ON TABLE public.reply_comments TO service_role;


--
-- Name: SEQUENCE reply_comments_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.reply_comments_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.reply_comments_id_seq TO anon;
GRANT ALL ON SEQUENCE public.reply_comments_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.reply_comments_id_seq TO service_role;


--
-- Name: SEQUENCE studios_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.studios_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.studios_id_seq TO anon;
GRANT ALL ON SEQUENCE public.studios_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.studios_id_seq TO service_role;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.users TO postgres;
GRANT ALL ON TABLE public.users TO anon;
GRANT ALL ON TABLE public.users TO authenticated;
GRANT ALL ON TABLE public.users TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- PostgreSQL database dump complete
--

