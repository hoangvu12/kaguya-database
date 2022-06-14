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
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


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
-- Name: novel_character_filter(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.novel_character_filter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   IF NOT EXISTS(SELECT 1 FROM novel_characters WHERE novel_id = NEW.novel_id AND name = NEW.name)

   THEN

      RETURN NEW;

   ELSE

      RETURN NULL;

   END IF;

END;$$;


ALTER FUNCTION public.novel_character_filter() OWNER TO supabase_admin;

--
-- Name: novel_recommendations_upsert_filter(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.novel_recommendations_upsert_filter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   IF EXISTS(SELECT 1 FROM novel WHERE ani_id = NEW.recommend_id)

   THEN

      RETURN NEW;

   ELSE

      RETURN NULL;

   END IF;

END;$$;


ALTER FUNCTION public.novel_recommendations_upsert_filter() OWNER TO supabase_admin;

--
-- Name: novel_relations_upsert_filter(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.novel_relations_upsert_filter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   IF EXISTS(SELECT 1 FROM novel WHERE ani_id = NEW.relation_id)

   THEN

      RETURN NEW;

   ELSE

      RETURN NULL;

   END IF;

END;$$;


ALTER FUNCTION public.novel_relations_upsert_filter() OWNER TO supabase_admin;

--
-- Name: pgrst_watch(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.pgrst_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

  NOTIFY pgrst, 'reload schema';

END;

$$;



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
-- Name: update_novel_chapters(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_novel_chapters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

  BEGIN

      update novel set chapters_updated_at = current_timestamp where ani_id = NEW.novel_id;



      return NEW;

  END;

$$;

ALTER FUNCTION public.update_novel_chapters() OWNER TO supabase_admin;

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

SET default_tablespace = '';

SET default_table_access_method = heap;

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
-- Name: kaguya_subscriptions kaguya_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_subscriptions
    ADD CONSTRAINT kaguya_subscriptions_pkey PRIMARY KEY ("userAgent", "userId");


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
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: kaguya_episodes handle_anime_episodes_updated_at; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER handle_anime_episodes_updated_at BEFORE INSERT ON public.kaguya_episodes FOR EACH ROW EXECUTE FUNCTION public.update_anime_episodes();


--
-- Name: kaguya_chapters handle_manga_chapters_updated_at; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER handle_manga_chapters_updated_at BEFORE INSERT ON public.kaguya_chapters FOR EACH ROW EXECUTE FUNCTION public.update_manga_chapters();


--
-- Name: kaguya_anime_source update_updatedat_kaguya_anime_source; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_anime_source BEFORE UPDATE ON public.kaguya_anime_source FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_chapters update_updatedat_kaguya_chapters; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_chapters BEFORE UPDATE ON public.kaguya_chapters FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_episodes update_updatedat_kaguya_episodes; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_episodes BEFORE UPDATE ON public.kaguya_episodes FOR EACH ROW EXECUTE FUNCTION public.updated_at();


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
-- Name: kaguya_subscriptions update_updatedat_kaguya_subscriptions; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_subscriptions BEFORE UPDATE ON public.kaguya_subscriptions FOR EACH ROW EXECUTE FUNCTION public.updated_at();


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
-- Name: comments comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: kaguya_anime_source kaguya_anime_source_sourceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_anime_source
    ADD CONSTRAINT "kaguya_anime_source_sourceId_fkey" FOREIGN KEY ("sourceId") REFERENCES public.kaguya_sources(id) ON DELETE CASCADE;


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
-- Name: kaguya_manga_source kaguya_manga_source_sourceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_manga_source
    ADD CONSTRAINT "kaguya_manga_source_sourceId_fkey" FOREIGN KEY ("sourceId") REFERENCES public.kaguya_sources(id) ON DELETE CASCADE;


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
-- Name: kaguya_subscriptions kaguya_subscriptions_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_subscriptions
    ADD CONSTRAINT "kaguya_subscriptions_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id);


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
-- Name: kaguya_episodes Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_episodes FOR SELECT USING (true);


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
-- Name: kaguya_subscriptions Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.kaguya_subscriptions FOR SELECT USING (true);


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
-- Name: kaguya_episodes; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_episodes ENABLE ROW LEVEL SECURITY;

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
-- Name: kaguya_subscriptions; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_subscriptions ENABLE ROW LEVEL SECURITY;

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

