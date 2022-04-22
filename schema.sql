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
    description text,
    "vietnameseTitle" character varying,
    "isAdult" boolean,
    synonyms text[],
    "countryOfOrigin" character varying,
    "averageScore" smallint,
    genres character varying[],
    duration smallint,
    trailer character varying
);


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


--
-- Name: anime_search(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.anime_search(string text) RETURNS SETOF public.kaguya_anime
    LANGUAGE plpgsql
    AS $$

  begin

  return query select * from kaguya_anime where to_tsvector(title || ' ' || coalesce("vietnameseTitle", '') || ' ' || coalesce(arr2text(synonyms), '') || ' ' || coalesce(description, '')) @@ plainto_tsquery(string);

  end

$$;


--
-- Name: arr2text(text[]); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.arr2text(ci text[]) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT array_to_string($1, ',')$_$;


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
    description text,
    "vietnameseTitle" character varying,
    synonyms character varying[],
    "chapterUpdatedAt" timestamp with time zone DEFAULT now(),
    "totalChapters" integer
);


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


--
-- Name: manga_search(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.manga_search(string text) RETURNS SETOF public.kaguya_manga
    LANGUAGE plpgsql
    AS $$

  begin

  return query select * from kaguya_manga where to_tsvector(title || ' ' || coalesce("vietnameseTitle", '') || ' ' || coalesce(arr2text(synonyms), '') || ' ' || coalesce(description, '')) @@ plainto_tsquery(string);

  end

$$;


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


--
-- Name: upsert_data(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.upsert_data() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

  BEGIN

    IF (OLD."vietnameseTitle" IS NOT NULL)

    THEN

      NEW."vietnameseTitle" = OLD."vietnameseTitle";

    END IF;



    IF (OLD.description IS NOT NULL)

    THEN

      NEW.description = OLD.description;

    END IF;

    

    RETURN NEW;

  END;

$$;


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


--
-- Name: kaguya_anime_subscribers; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_anime_subscribers (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    "userId" uuid,
    "mediaId" bigint
);


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


--
-- Name: kaguya_manga_subscribers; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_manga_subscribers (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    "userId" uuid,
    "mediaId" bigint
);


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
    name character varying NOT NULL
);


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


--
-- Name: kaguya_voice_actor_connections; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_voice_actor_connections (
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    "voiceActorId" bigint NOT NULL,
    "characterId" bigint NOT NULL
);


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
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.subscriptions (
    created_at timestamp with time zone DEFAULT now(),
    subscription jsonb NOT NULL,
    "userId" uuid NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    user_agent character varying NOT NULL
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

create or replace function public.handle_new_user() 
returns trigger as $$
begin
  insert into public.users (id, email, created_at, updated_at, user_metadata, raw_app_meta_data, aud, role)
  values (new.id, new.email, new.created_at, new.updated_at, new.raw_user_meta_data, new.raw_app_meta_data, new.aud, new.role) on conflict (id) do update set (id, email, created_at, updated_at, user_metadata, raw_app_meta_data, aud, role) = (new.id, new.email, new.created_at, new.updated_at, new.raw_user_meta_data, new.raw_app_meta_data, new.aud, new.role);
  return new;
end;
$$ language plpgsql security definer;

ALTER TABLE kaguya_episodes
DROP CONSTRAINT "kaguya_episodes_sourceConnectionId_fkey",
ADD CONSTRAINT "kaguya_episodes_sourceConnectionId_fkey"
   FOREIGN KEY ("sourceConnectionId")
   REFERENCES kaguya_anime_source(id)
   ON DELETE CASCADE;

ALTER TABLE kaguya_chapters
DROP CONSTRAINT "kaguya_chapters_sourceConnectionId_fkey",
ADD CONSTRAINT "kaguya_chapters_sourceConnectionId_fkey"
   FOREIGN KEY ("sourceConnectionId")
   REFERENCES kaguya_manga_source(id)
   ON DELETE CASCADE;

ALTER TABLE kaguya_episodes
DROP CONSTRAINT "kaguya_episodes_sourceId_fkey",
ADD CONSTRAINT "kaguya_episodes_sourceId_fkey"
   FOREIGN KEY ("sourceId")
   REFERENCES kaguya_sources(id)
   ON DELETE CASCADE;

ALTER TABLE kaguya_chapters
DROP CONSTRAINT "kaguya_chapters_sourceId_fkey",
ADD CONSTRAINT "kaguya_chapters_sourceId_fkey"
   FOREIGN KEY ("sourceId")
   REFERENCES kaguya_sources(id)
   ON DELETE CASCADE;

ALTER TABLE kaguya_anime_source
DROP CONSTRAINT "kaguya_anime_source_sourceId_fkey",
ADD CONSTRAINT "kaguya_anime_source_sourceId_fkey"
   FOREIGN KEY ("sourceId")
   REFERENCES kaguya_sources(id)
   ON DELETE CASCADE;

ALTER TABLE kaguya_manga_source
DROP CONSTRAINT "kaguya_manga_source_sourceId_fkey",
ADD CONSTRAINT "kaguya_manga_source_sourceId_fkey"
   FOREIGN KEY ("sourceId")
   REFERENCES kaguya_sources(id)
   ON DELETE CASCADE;

ALTER TABLE kaguya_watched
DROP CONSTRAINT "kaguya_watched_episodeId_fkey",
ADD CONSTRAINT "kaguya_watched_episodeId_fkey"
   FOREIGN KEY ("episodeId")
   REFERENCES kaguya_episodes(slug)
   ON DELETE CASCADE;

ALTER TABLE kaguya_read
DROP CONSTRAINT "kaguya_read_chapterId_fkey",
ADD CONSTRAINT "kaguya_read_chapterId_fkey"
   FOREIGN KEY ("chapterId")
   REFERENCES kaguya_chapters(slug)
   ON DELETE CASCADE;

--
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- Name: users on_auth_user_updated; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_updated AFTER UPDATE ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


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
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (user_agent, "userId");


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
    ADD CONSTRAINT "kaguya_anime_source_sourceId_fkey" FOREIGN KEY ("sourceId") REFERENCES public.kaguya_sources(id);


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
    ADD CONSTRAINT "kaguya_chapters_sourceConnectionId_fkey" FOREIGN KEY ("sourceConnectionId") REFERENCES public.kaguya_manga_source(id);


--
-- Name: kaguya_chapters kaguya_chapters_sourceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_chapters
    ADD CONSTRAINT "kaguya_chapters_sourceId_fkey" FOREIGN KEY ("sourceId") REFERENCES public.kaguya_sources(id);


--
-- Name: kaguya_episodes kaguya_episodes_sourceConnectionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_episodes
    ADD CONSTRAINT "kaguya_episodes_sourceConnectionId_fkey" FOREIGN KEY ("sourceConnectionId") REFERENCES public.kaguya_anime_source(id);


--
-- Name: kaguya_episodes kaguya_episodes_sourceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_episodes
    ADD CONSTRAINT "kaguya_episodes_sourceId_fkey" FOREIGN KEY ("sourceId") REFERENCES public.kaguya_sources(id);


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
    ADD CONSTRAINT "kaguya_manga_source_sourceId_fkey" FOREIGN KEY ("sourceId") REFERENCES public.kaguya_sources(id);


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
    ADD CONSTRAINT "kaguya_read_chapterId_fkey" FOREIGN KEY ("chapterId") REFERENCES public.kaguya_chapters(slug);


--
-- Name: kaguya_read kaguya_read_mediaId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_read
    ADD CONSTRAINT "kaguya_read_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES public.kaguya_manga(id);


--
-- Name: kaguya_read_status kaguya_read_status_mediaId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_read_status
    ADD CONSTRAINT "kaguya_read_status_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES public.kaguya_manga(id);


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
    ADD CONSTRAINT "kaguya_watch_status_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES public.kaguya_anime(id);


--
-- Name: kaguya_watch_status kaguya_watch_status_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_watch_status
    ADD CONSTRAINT "kaguya_watch_status_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id);


--
-- Name: kaguya_watched kaguya_watched_episodeId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_watched
    ADD CONSTRAINT "kaguya_watched_episodeId_fkey" FOREIGN KEY ("episodeId") REFERENCES public.kaguya_episodes(slug);


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
-- Name: subscriptions subscriptions_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT "subscriptions_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id);


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
-- Name: subscriptions Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.subscriptions FOR SELECT USING (true);


--
-- Name: users Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.users FOR SELECT USING (true);


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
-- Name: subscriptions Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable delete for users based on user_id" ON public.subscriptions FOR DELETE USING ((auth.uid() = "userId"));


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
-- Name: reply_comments Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.reply_comments FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: subscriptions Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.subscriptions FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: subscriptions Enable update access for users based on their user ID; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update access for users based on their user ID" ON public.subscriptions FOR UPDATE USING ((auth.uid() = "userId"));


--
-- Name: kaguya_anime_subscribers Enable update for users based on email; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on email" ON public.kaguya_anime_subscribers FOR UPDATE USING ((auth.uid() = "userId")) WITH CHECK ((auth.uid() = "userId"));


--
-- Name: kaguya_manga_subscribers Enable update for users based on email; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on email" ON public.kaguya_manga_subscribers FOR UPDATE USING ((auth.uid() = "userId")) WITH CHECK ((auth.uid() = "userId"));


--
-- Name: kaguya_subscriptions Enable update for users based on email; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on email" ON public.kaguya_subscriptions FOR UPDATE USING ((auth.uid() = "userId")) WITH CHECK ((auth.uid() = "userId"));


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
-- Name: subscriptions; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
