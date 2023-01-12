--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 15.1

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

DROP POLICY IF EXISTS "Enable update for users based on user_id" ON public.sce_comment_reactions;
DROP POLICY IF EXISTS "Enable update for users based on user_id" ON public.kaguya_videos;
DROP POLICY IF EXISTS "Enable update for users based on user_id" ON public.kaguya_images;
DROP POLICY IF EXISTS "Enable update for users based on user_id" ON public.kaguya_episodes;
DROP POLICY IF EXISTS "Enable update for users based on user_id" ON public.kaguya_chapters;
DROP POLICY IF EXISTS "Enable update for users based on userId" ON public.kaguya_notification_users;
DROP POLICY IF EXISTS "Enable update for users based on senderId" ON public.kaguya_notifications;
DROP POLICY IF EXISTS "Enable update for users based on id" ON public.sce_comments;
DROP POLICY IF EXISTS "Enable update for users based on id" ON public.kaguya_watch_status;
DROP POLICY IF EXISTS "Enable update for users based on id" ON public.kaguya_read_status;
DROP POLICY IF EXISTS "Enable update for users based on email" ON public.users;
DROP POLICY IF EXISTS "Enable update for users based on email" ON public.kaguya_watched;
DROP POLICY IF EXISTS "Enable update for users based on email" ON public.kaguya_subscriptions;
DROP POLICY IF EXISTS "Enable update for users based on email" ON public.kaguya_read;
DROP POLICY IF EXISTS "Enable update for users based on email" ON public.kaguya_manga_subscribers;
DROP POLICY IF EXISTS "Enable update for users based on email" ON public.kaguya_anime_subscribers;
DROP POLICY IF EXISTS "Enable update for authenticated users only" ON public.kaguya_translations;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.kaguya_videos;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.kaguya_translations;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.kaguya_notifications;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.kaguya_notification_users;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.kaguya_images;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.kaguya_hostings;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.kaguya_dmca;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.sce_comments;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.sce_comment_reactions;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.kaguya_watched;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.kaguya_watch_status;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.kaguya_videos;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.kaguya_translations;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.kaguya_subscriptions;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.kaguya_rooms;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.kaguya_room_users;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.kaguya_read_status;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.kaguya_read;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.kaguya_notifications;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.kaguya_notification_users;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.kaguya_manga_subscribers;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.kaguya_images;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.kaguya_anime_subscribers;
DROP POLICY IF EXISTS "Enable delete for users based on user_id" ON public.sce_comments;
DROP POLICY IF EXISTS "Enable delete for users based on user_id" ON public.sce_comment_reactions;
DROP POLICY IF EXISTS "Enable delete for users based on user_id" ON public.kaguya_videos;
DROP POLICY IF EXISTS "Enable delete for users based on user_id" ON public.kaguya_notifications;
DROP POLICY IF EXISTS "Enable delete for users based on user_id" ON public.kaguya_notification_users;
DROP POLICY IF EXISTS "Enable delete for users based on user_id" ON public.kaguya_manga_subscribers;
DROP POLICY IF EXISTS "Enable delete for users based on user_id" ON public.kaguya_manga_source;
DROP POLICY IF EXISTS "Enable delete for users based on user_id" ON public.kaguya_images;
DROP POLICY IF EXISTS "Enable delete for users based on user_id" ON public.kaguya_episodes;
DROP POLICY IF EXISTS "Enable delete for users based on user_id" ON public.kaguya_chapters;
DROP POLICY IF EXISTS "Enable delete for users based on user_id" ON public.kaguya_anime_subscribers;
DROP POLICY IF EXISTS "Enable delete for users based on source_id" ON public.kaguya_anime_source;
DROP POLICY IF EXISTS "Enable access to all users" ON public.users;
DROP POLICY IF EXISTS "Enable access to all users" ON public.sce_reactions;
DROP POLICY IF EXISTS "Enable access to all users" ON public.sce_comments;
DROP POLICY IF EXISTS "Enable access to all users" ON public.sce_comment_reactions;
DROP POLICY IF EXISTS "Enable access to all users" ON public.kaguya_watched;
DROP POLICY IF EXISTS "Enable access to all users" ON public.kaguya_watch_status;
DROP POLICY IF EXISTS "Enable access to all users" ON public.kaguya_subscriptions;
DROP POLICY IF EXISTS "Enable access to all users" ON public.kaguya_sources;
DROP POLICY IF EXISTS "Enable access to all users" ON public.kaguya_rooms;
DROP POLICY IF EXISTS "Enable access to all users" ON public.kaguya_room_users;
DROP POLICY IF EXISTS "Enable access to all users" ON public.kaguya_read_status;
DROP POLICY IF EXISTS "Enable access to all users" ON public.kaguya_read;
DROP POLICY IF EXISTS "Enable access to all users" ON public.kaguya_manga_subscribers;
DROP POLICY IF EXISTS "Enable access to all users" ON public.kaguya_manga_source;
DROP POLICY IF EXISTS "Enable access to all users" ON public.kaguya_episodes;
DROP POLICY IF EXISTS "Enable access to all users" ON public.kaguya_chapters;
DROP POLICY IF EXISTS "Enable access to all users" ON public.kaguya_anime_subscribers;
DROP POLICY IF EXISTS "Enable access to all users" ON public.kaguya_anime_source;
ALTER TABLE IF EXISTS ONLY public.sce_comments DROP CONSTRAINT IF EXISTS sce_comments_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.sce_comments DROP CONSTRAINT IF EXISTS sce_comments_parent_id_fkey;
ALTER TABLE IF EXISTS ONLY public.sce_comment_reactions DROP CONSTRAINT IF EXISTS sce_comment_reactions_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.sce_comment_reactions DROP CONSTRAINT IF EXISTS sce_comment_reactions_reaction_type_fkey;
ALTER TABLE IF EXISTS ONLY public.sce_comment_reactions DROP CONSTRAINT IF EXISTS sce_comment_reactions_comment_id_fkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_watched DROP CONSTRAINT IF EXISTS "kaguya_watched_userId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_watched DROP CONSTRAINT IF EXISTS "kaguya_watched_episodeId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_watch_status DROP CONSTRAINT IF EXISTS "kaguya_watch_status_userId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_videos DROP CONSTRAINT IF EXISTS "kaguya_videos_userId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_videos DROP CONSTRAINT IF EXISTS "kaguya_videos_hostingId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_videos DROP CONSTRAINT IF EXISTS "kaguya_videos_episodeId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_subscriptions DROP CONSTRAINT IF EXISTS "kaguya_subscriptions_userId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_sources DROP CONSTRAINT IF EXISTS "kaguya_sources_addedUserId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_rooms DROP CONSTRAINT IF EXISTS "kaguya_rooms_hostUserId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_rooms DROP CONSTRAINT IF EXISTS "kaguya_rooms_episodeId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_room_users DROP CONSTRAINT IF EXISTS "kaguya_room_users_roomId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_read DROP CONSTRAINT IF EXISTS "kaguya_read_userId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_read_status DROP CONSTRAINT IF EXISTS "kaguya_read_status_userId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_read DROP CONSTRAINT IF EXISTS "kaguya_read_chapterId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_notifications DROP CONSTRAINT IF EXISTS "kaguya_notifications_senderId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_notifications DROP CONSTRAINT IF EXISTS "kaguya_notifications_receiverId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_notification_users DROP CONSTRAINT IF EXISTS "kaguya_notification_users_userId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_notification_users DROP CONSTRAINT IF EXISTS "kaguya_notification_users_notificationId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_manga_subscribers DROP CONSTRAINT IF EXISTS "kaguya_manga_subscribers_userId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_manga_source DROP CONSTRAINT IF EXISTS "kaguya_manga_source_sourceId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_images DROP CONSTRAINT IF EXISTS "kaguya_images_userId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_images DROP CONSTRAINT IF EXISTS "kaguya_images_chapterId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_episodes DROP CONSTRAINT IF EXISTS "kaguya_episodes_userId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_episodes DROP CONSTRAINT IF EXISTS "kaguya_episodes_sourceId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_episodes DROP CONSTRAINT IF EXISTS "kaguya_episodes_sourceConnectionId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_chapters DROP CONSTRAINT IF EXISTS "kaguya_chapters_userId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_chapters DROP CONSTRAINT IF EXISTS "kaguya_chapters_sourceId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_chapters DROP CONSTRAINT IF EXISTS "kaguya_chapters_sourceConnectionId_fkey";
ALTER TABLE IF EXISTS ONLY public.kaguya_anime_subscribers DROP CONSTRAINT IF EXISTS "kaguya_anime_subscribers_userId_fkey";
DROP TRIGGER IF EXISTS update_updatedat_kaguya_watched ON public.kaguya_watched;
DROP TRIGGER IF EXISTS update_updatedat_kaguya_watch_status ON public.kaguya_watch_status;
DROP TRIGGER IF EXISTS update_updatedat_kaguya_videos ON public.kaguya_videos;
DROP TRIGGER IF EXISTS update_updatedat_kaguya_translations ON public.kaguya_translations;
DROP TRIGGER IF EXISTS update_updatedat_kaguya_subscriptions ON public.kaguya_subscriptions;
DROP TRIGGER IF EXISTS update_updatedat_kaguya_sources ON public.kaguya_sources;
DROP TRIGGER IF EXISTS update_updatedat_kaguya_rooms ON public.kaguya_rooms;
DROP TRIGGER IF EXISTS update_updatedat_kaguya_room_users ON public.kaguya_room_users;
DROP TRIGGER IF EXISTS update_updatedat_kaguya_read_status ON public.kaguya_read_status;
DROP TRIGGER IF EXISTS update_updatedat_kaguya_read ON public.kaguya_read;
DROP TRIGGER IF EXISTS update_updatedat_kaguya_notifications ON public.kaguya_notifications;
DROP TRIGGER IF EXISTS update_updatedat_kaguya_notification_users ON public.kaguya_notification_users;
DROP TRIGGER IF EXISTS update_updatedat_kaguya_manga_source ON public.kaguya_manga_source;
DROP TRIGGER IF EXISTS update_updatedat_kaguya_images ON public.kaguya_images;
DROP TRIGGER IF EXISTS update_updatedat_kaguya_hostings ON public.kaguya_hostings;
DROP TRIGGER IF EXISTS update_updatedat_kaguya_episodes ON public.kaguya_episodes;
DROP TRIGGER IF EXISTS update_updatedat_kaguya_dmca ON public.kaguya_dmca;
DROP TRIGGER IF EXISTS update_updatedat_kaguya_chapters ON public.kaguya_chapters;
DROP TRIGGER IF EXISTS update_updatedat_kaguya_anime_source ON public.kaguya_anime_source;
DROP TRIGGER IF EXISTS notifcation_insert_trigger ON public.kaguya_notifications;
DROP TRIGGER IF EXISTS comment_reaction_insert_trigger ON public.sce_comment_reactions;
DROP TRIGGER IF EXISTS comment_insert_trigger ON public.sce_comments;
DROP TRIGGER IF EXISTS on_auth_user_updated ON auth.users;
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP INDEX IF EXISTS public.users_id_index;
DROP INDEX IF EXISTS public.idx_watched;
DROP INDEX IF EXISTS public.idx_watch_status;
DROP INDEX IF EXISTS public.idx_videos;
DROP INDEX IF EXISTS public.idx_subscriptions;
DROP INDEX IF EXISTS public.idx_sources;
DROP INDEX IF EXISTS public.idx_rooms;
DROP INDEX IF EXISTS public.idx_room_users;
DROP INDEX IF EXISTS public.idx_read_status;
DROP INDEX IF EXISTS public.idx_read;
DROP INDEX IF EXISTS public.idx_notifications;
DROP INDEX IF EXISTS public.idx_notification_users;
DROP INDEX IF EXISTS public.idx_manga_subscriber_user_id;
DROP INDEX IF EXISTS public.idx_manga_source_id;
DROP INDEX IF EXISTS public.idx_images;
DROP INDEX IF EXISTS public.idx_episode_slug;
DROP INDEX IF EXISTS public.idx_chapter_slug;
DROP INDEX IF EXISTS public.idx_anime_subscriber_user_id;
DROP INDEX IF EXISTS public.idx_anime_source_id;

ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_username_key;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.sce_reactions DROP CONSTRAINT IF EXISTS sce_reactions_pkey;
ALTER TABLE IF EXISTS ONLY public.sce_migrations DROP CONSTRAINT IF EXISTS sce_migrations_pkey;
ALTER TABLE IF EXISTS ONLY public.sce_comments DROP CONSTRAINT IF EXISTS sce_comments_pkey;
ALTER TABLE IF EXISTS ONLY public.sce_comment_reactions DROP CONSTRAINT IF EXISTS sce_comment_reactions_user_id_comment_id_reaction_type_key;
ALTER TABLE IF EXISTS ONLY public.sce_comment_reactions DROP CONSTRAINT IF EXISTS sce_comment_reactions_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_watched DROP CONSTRAINT IF EXISTS kaguya_watched_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_watch_status DROP CONSTRAINT IF EXISTS kaguya_watch_status_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_videos DROP CONSTRAINT IF EXISTS kaguya_videos_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_videos DROP CONSTRAINT IF EXISTS "kaguya_videos_episodeId_key";
ALTER TABLE IF EXISTS ONLY public.kaguya_translations DROP CONSTRAINT IF EXISTS kaguya_translations_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_subscriptions DROP CONSTRAINT IF EXISTS kaguya_subscriptions_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_sources DROP CONSTRAINT IF EXISTS kaguya_sources_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_rooms DROP CONSTRAINT IF EXISTS kaguya_rooms_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_room_users DROP CONSTRAINT IF EXISTS kaguya_room_users_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_read_status DROP CONSTRAINT IF EXISTS kaguya_read_status_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_read DROP CONSTRAINT IF EXISTS kaguya_read_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_notifications DROP CONSTRAINT IF EXISTS kaguya_notifications_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_notification_users DROP CONSTRAINT IF EXISTS kaguya_notification_users_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_manga_subscribers DROP CONSTRAINT IF EXISTS kaguya_manga_subscribers_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_manga_source DROP CONSTRAINT IF EXISTS kaguya_manga_source_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_manga_source DROP CONSTRAINT IF EXISTS kaguya_manga_source_id_key;
ALTER TABLE IF EXISTS ONLY public.kaguya_images DROP CONSTRAINT IF EXISTS kaguya_images_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_hostings DROP CONSTRAINT IF EXISTS kaguya_hostings_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_hostings DROP CONSTRAINT IF EXISTS kaguya_hostings_name_key;
ALTER TABLE IF EXISTS ONLY public.kaguya_hostings DROP CONSTRAINT IF EXISTS kaguya_hostings_id_key;
ALTER TABLE IF EXISTS ONLY public.kaguya_episodes DROP CONSTRAINT IF EXISTS kaguya_episodes_slug_key;
ALTER TABLE IF EXISTS ONLY public.kaguya_episodes DROP CONSTRAINT IF EXISTS kaguya_episodes_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_episodes DROP CONSTRAINT IF EXISTS kaguya_episodes_id_key;
ALTER TABLE IF EXISTS ONLY public.kaguya_dmca DROP CONSTRAINT IF EXISTS kaguya_dmca_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_chapters DROP CONSTRAINT IF EXISTS kaguya_chapters_slug_key;
ALTER TABLE IF EXISTS ONLY public.kaguya_chapters DROP CONSTRAINT IF EXISTS kaguya_chapters_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_anime_subscribers DROP CONSTRAINT IF EXISTS kaguya_anime_subscribers_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_anime_source DROP CONSTRAINT IF EXISTS kaguya_anime_source_pkey;
ALTER TABLE IF EXISTS ONLY public.kaguya_anime_source DROP CONSTRAINT IF EXISTS kaguya_anime_source_id_key;

DROP TABLE IF EXISTS public.sce_reactions;
DROP TABLE IF EXISTS public.sce_migrations;
DROP VIEW IF EXISTS public.sce_display_users;
DROP TABLE IF EXISTS public.users;
DROP VIEW IF EXISTS public.sce_comments_with_metadata;
DROP TABLE IF EXISTS public.sce_comments;
DROP VIEW IF EXISTS public.sce_comment_reactions_metadata;
DROP TABLE IF EXISTS public.sce_comment_reactions;
DROP TABLE IF EXISTS public.kaguya_watched;
DROP TABLE IF EXISTS public.kaguya_watch_status;
DROP TABLE IF EXISTS public.kaguya_videos;
DROP TABLE IF EXISTS public.kaguya_translations;
DROP TABLE IF EXISTS public.kaguya_subscriptions;
DROP TABLE IF EXISTS public.kaguya_sources;
DROP TABLE IF EXISTS public.kaguya_rooms;
DROP TABLE IF EXISTS public.kaguya_room_users;
DROP TABLE IF EXISTS public.kaguya_read_status;
DROP TABLE IF EXISTS public.kaguya_read;
DROP TABLE IF EXISTS public.kaguya_notifications;
DROP TABLE IF EXISTS public.kaguya_notification_users;
DROP TABLE IF EXISTS public.kaguya_manga_subscribers;
DROP TABLE IF EXISTS public.kaguya_manga_source;
DROP TABLE IF EXISTS public.kaguya_images;
DROP TABLE IF EXISTS public.kaguya_hostings;
DROP TABLE IF EXISTS public.kaguya_episodes;
DROP TABLE IF EXISTS public.kaguya_dmca;
DROP TABLE IF EXISTS public.kaguya_chapters;
DROP TABLE IF EXISTS public.kaguya_anime_subscribers;
DROP TABLE IF EXISTS public.kaguya_anime_source;
SET default_tablespace = '';

SET default_table_access_method = heap;


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
    "sourceConnectionId" character varying,
    "userId" uuid,
    published boolean DEFAULT true NOT NULL,
    section character varying
);


ALTER TABLE public.kaguya_chapters OWNER TO supabase_admin;

--
-- Name: kaguya_dmca; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_dmca (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    "mediaId" bigint NOT NULL,
    "mediaType" character varying NOT NULL
);


ALTER TABLE public.kaguya_dmca OWNER TO supabase_admin;

--
-- Name: kaguya_dmca_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_dmca ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.kaguya_dmca_id_seq
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
    "sourceConnectionId" character varying,
    "userId" uuid,
    published boolean DEFAULT true NOT NULL,
    section character varying
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
-- Name: kaguya_hostings; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_hostings (
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    id character varying NOT NULL,
    name character varying NOT NULL,
    "supportedUrlFormats" text[]
);


ALTER TABLE public.kaguya_hostings OWNER TO supabase_admin;

--
-- Name: kaguya_images; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_images (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    images json NOT NULL,
    "userId" uuid NOT NULL,
    "chapterId" character varying
);


ALTER TABLE public.kaguya_images OWNER TO supabase_admin;

--
-- Name: kaguya_images_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_images ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.kaguya_images_id_seq
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
-- Name: kaguya_notification_users; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_notification_users (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    "userId" uuid,
    "isRead" boolean DEFAULT false,
    "notificationId" bigint
);


ALTER TABLE public.kaguya_notification_users OWNER TO supabase_admin;

--
-- Name: kaguya_notification_users_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_notification_users ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.kaguya_notification_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kaguya_notifications; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_notifications (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    "entityId" text NOT NULL,
    "senderId" uuid,
    "receiverId" uuid NOT NULL,
    "entityType" character varying NOT NULL,
    "parentEntityId" text,
    "isRead" boolean DEFAULT false
);


ALTER TABLE public.kaguya_notifications OWNER TO supabase_admin;

--
-- Name: kaguya_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_notifications ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.kaguya_notifications_id_seq
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
    "userId" uuid NOT NULL,
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.kaguya_read_status OWNER TO supabase_admin;

--
-- Name: kaguya_room_users; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_room_users (
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    "roomId" bigint,
    "userId" text,
    id character varying NOT NULL,
    "peerId" text,
    name character varying,
    "avatarUrl" text,
    "isMicMuted" boolean DEFAULT true,
    "isHeadphoneMuted" boolean DEFAULT false,
    "useVoiceChat" boolean DEFAULT false
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
    locales character varying[],
    "addedUserId" uuid,
    "isCustomSource" boolean DEFAULT false
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
-- Name: kaguya_translations; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_translations (
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    title character varying,
    description text,
    "mediaId" bigint NOT NULL,
    locale character varying NOT NULL,
    "mediaType" character varying NOT NULL
);


ALTER TABLE public.kaguya_translations OWNER TO supabase_admin;

--
-- Name: TABLE kaguya_translations; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.kaguya_translations IS 'Translations of media';


--
-- Name: kaguya_videos; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.kaguya_videos (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    video jsonb NOT NULL,
    subtitles jsonb,
    fonts jsonb,
    "episodeId" character varying NOT NULL,
    "userId" uuid,
    "hostingId" character varying
);


ALTER TABLE public.kaguya_videos OWNER TO supabase_admin;

--
-- Name: kaguya_videos_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_videos ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.kaguya_videos_id_seq
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
    "userId" uuid NOT NULL,
    updated_at timestamp without time zone DEFAULT now()
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
    "episodeId" character varying NOT NULL,
    "episodeNumber" bigint NOT NULL
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
-- Name: sce_comment_reactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sce_comment_reactions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    comment_id uuid NOT NULL,
    user_id uuid NOT NULL,
    reaction_type character varying NOT NULL
);


ALTER TABLE public.sce_comment_reactions OWNER TO postgres;

--
-- Name: sce_comment_reactions_metadata; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.sce_comment_reactions_metadata AS
 SELECT sce_comment_reactions.comment_id,
    sce_comment_reactions.reaction_type,
    count(*) AS reaction_count,
    bool_or((sce_comment_reactions.user_id = auth.uid())) AS active_for_user
   FROM public.sce_comment_reactions
  GROUP BY sce_comment_reactions.comment_id, sce_comment_reactions.reaction_type
  ORDER BY sce_comment_reactions.reaction_type;


ALTER TABLE public.sce_comment_reactions_metadata OWNER TO postgres;

--
-- Name: sce_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sce_comments (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    topic character varying NOT NULL,
    comment character varying NOT NULL,
    user_id uuid NOT NULL,
    parent_id uuid,
    mentioned_user_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL
);


ALTER TABLE public.sce_comments OWNER TO postgres;

--
-- Name: sce_comments_with_metadata; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.sce_comments_with_metadata AS
 SELECT sce_comments.id,
    sce_comments.created_at,
    sce_comments.topic,
    sce_comments.comment,
    sce_comments.user_id,
    sce_comments.parent_id,
    sce_comments.mentioned_user_ids,
    ( SELECT count(*) AS count
           FROM public.sce_comments c
          WHERE (c.parent_id = sce_comments.id)) AS replies_count
   FROM public.sce_comments;


ALTER TABLE public.sce_comments_with_metadata OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    email character varying,
    aud character varying,
    role character varying,
    "authRole" character varying DEFAULT 'user'::character varying NOT NULL,
    "isVerified" boolean DEFAULT false NOT NULL,
    username text,
    bio text,
    "avatarUrl" text,
    name character varying,
    "bannerUrl" text
);


ALTER TABLE public.users OWNER TO supabase_admin;

--
-- Name: sce_display_users; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.sce_display_users AS
 SELECT users.id,
    (users.name)::text AS name,
    users."avatarUrl" AS avatar,
    users.username,
    (users."authRole")::text AS role
   FROM public.users;


ALTER TABLE public.sce_display_users OWNER TO postgres;

--
-- Name: sce_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sce_migrations (
    migration text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.sce_migrations OWNER TO postgres;

--
-- Name: sce_reactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sce_reactions (
    type character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    label character varying NOT NULL,
    url character varying NOT NULL,
    metadata jsonb
);


ALTER TABLE public.sce_reactions OWNER TO postgres;

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
-- Name: kaguya_dmca kaguya_dmca_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_dmca
    ADD CONSTRAINT kaguya_dmca_pkey PRIMARY KEY (id);


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
-- Name: kaguya_hostings kaguya_hostings_id_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_hostings
    ADD CONSTRAINT kaguya_hostings_id_key UNIQUE (id);


--
-- Name: kaguya_hostings kaguya_hostings_name_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_hostings
    ADD CONSTRAINT kaguya_hostings_name_key UNIQUE (name);


--
-- Name: kaguya_hostings kaguya_hostings_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_hostings
    ADD CONSTRAINT kaguya_hostings_pkey PRIMARY KEY (id);


--
-- Name: kaguya_images kaguya_images_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_images
    ADD CONSTRAINT kaguya_images_pkey PRIMARY KEY (id);


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
-- Name: kaguya_notification_users kaguya_notification_users_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_notification_users
    ADD CONSTRAINT kaguya_notification_users_pkey PRIMARY KEY (id);


--
-- Name: kaguya_notifications kaguya_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_notifications
    ADD CONSTRAINT kaguya_notifications_pkey PRIMARY KEY (id);


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
-- Name: kaguya_translations kaguya_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_translations
    ADD CONSTRAINT kaguya_translations_pkey PRIMARY KEY ("mediaId", locale, "mediaType");


--
-- Name: kaguya_videos kaguya_videos_episodeId_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_videos
    ADD CONSTRAINT "kaguya_videos_episodeId_key" UNIQUE ("episodeId");


--
-- Name: kaguya_videos kaguya_videos_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_videos
    ADD CONSTRAINT kaguya_videos_pkey PRIMARY KEY (id);


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
-- Name: sce_comment_reactions sce_comment_reactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sce_comment_reactions
    ADD CONSTRAINT sce_comment_reactions_pkey PRIMARY KEY (id);


--
-- Name: sce_comment_reactions sce_comment_reactions_user_id_comment_id_reaction_type_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sce_comment_reactions
    ADD CONSTRAINT sce_comment_reactions_user_id_comment_id_reaction_type_key UNIQUE (user_id, comment_id, reaction_type);


--
-- Name: sce_comments sce_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sce_comments
    ADD CONSTRAINT sce_comments_pkey PRIMARY KEY (id);


--
-- Name: sce_migrations sce_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sce_migrations
    ADD CONSTRAINT sce_migrations_pkey PRIMARY KEY (migration);


--
-- Name: sce_reactions sce_reactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sce_reactions
    ADD CONSTRAINT sce_reactions_pkey PRIMARY KEY (type);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: idx_anime_source_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_anime_source_id ON public.kaguya_anime_source USING btree (id);


--
-- Name: idx_anime_subscriber_user_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_anime_subscriber_user_id ON public.kaguya_anime_subscribers USING btree ("userId");


--
-- Name: idx_chapter_slug; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_chapter_slug ON public.kaguya_chapters USING btree ("sourceConnectionId", "sourceId");


--
-- Name: idx_episode_slug; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_episode_slug ON public.kaguya_episodes USING btree ("sourceConnectionId", "sourceId");


--
-- Name: idx_images; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_images ON public.kaguya_images USING btree ("userId", "chapterId");


--
-- Name: idx_manga_source_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_manga_source_id ON public.kaguya_manga_source USING btree (id);


--
-- Name: idx_manga_subscriber_user_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_manga_subscriber_user_id ON public.kaguya_manga_subscribers USING btree ("userId");


--
-- Name: idx_notification_users; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_notification_users ON public.kaguya_notification_users USING btree ("userId", "notificationId");


--
-- Name: idx_notifications; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_notifications ON public.kaguya_notifications USING btree ("senderId", "receiverId");


--
-- Name: idx_read; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_read ON public.kaguya_read USING btree ("userId", "mediaId", "chapterId");


--
-- Name: idx_read_status; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_read_status ON public.kaguya_read_status USING btree ("mediaId", "userId");


--
-- Name: idx_room_users; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_room_users ON public.kaguya_room_users USING btree ("roomId");


--
-- Name: idx_rooms; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_rooms ON public.kaguya_rooms USING btree ("hostUserId", "episodeId");


--
-- Name: idx_sources; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_sources ON public.kaguya_sources USING btree ("addedUserId");


--
-- Name: idx_subscriptions; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_subscriptions ON public.kaguya_subscriptions USING btree ("userId");


--
-- Name: idx_videos; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_videos ON public.kaguya_videos USING btree ("userId", "episodeId", "hostingId");


--
-- Name: idx_watch_status; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_watch_status ON public.kaguya_watch_status USING btree ("mediaId", "userId");


--
-- Name: idx_watched; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_watched ON public.kaguya_watched USING btree ("userId", "mediaId", "episodeId");


--
-- Name: users_id_index; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX users_id_index ON public.users USING btree (id);


--
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- Name: users on_auth_user_updated; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_updated AFTER UPDATE ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- Name: sce_comments comment_insert_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER comment_insert_trigger AFTER INSERT ON public.sce_comments FOR EACH ROW EXECUTE FUNCTION public.notify_mentioned_users();


--
-- Name: sce_comment_reactions comment_reaction_insert_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER comment_reaction_insert_trigger AFTER INSERT ON public.sce_comment_reactions FOR EACH ROW EXECUTE FUNCTION public.notify_reacted_users();


--
-- Name: kaguya_notifications notifcation_insert_trigger; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER notifcation_insert_trigger AFTER INSERT ON public.kaguya_notifications FOR EACH ROW EXECUTE FUNCTION public.update_notifcation_users();


--
-- Name: kaguya_anime_source update_updatedat_kaguya_anime_source; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_anime_source BEFORE UPDATE ON public.kaguya_anime_source FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_chapters update_updatedat_kaguya_chapters; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_chapters BEFORE UPDATE ON public.kaguya_chapters FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_dmca update_updatedat_kaguya_dmca; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_dmca BEFORE UPDATE ON public.kaguya_dmca FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_episodes update_updatedat_kaguya_episodes; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_episodes BEFORE UPDATE ON public.kaguya_episodes FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_hostings update_updatedat_kaguya_hostings; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_hostings BEFORE UPDATE ON public.kaguya_hostings FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_images update_updatedat_kaguya_images; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_images BEFORE UPDATE ON public.kaguya_images FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_manga_source update_updatedat_kaguya_manga_source; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_manga_source BEFORE UPDATE ON public.kaguya_manga_source FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_notification_users update_updatedat_kaguya_notification_users; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_notification_users BEFORE UPDATE ON public.kaguya_notification_users FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_notifications update_updatedat_kaguya_notifications; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_notifications BEFORE UPDATE ON public.kaguya_notifications FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_read update_updatedat_kaguya_read; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_read BEFORE UPDATE ON public.kaguya_read FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_read_status update_updatedat_kaguya_read_status; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_read_status BEFORE UPDATE ON public.kaguya_read_status FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_room_users update_updatedat_kaguya_room_users; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_room_users BEFORE UPDATE ON public.kaguya_room_users FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_rooms update_updatedat_kaguya_rooms; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_rooms BEFORE UPDATE ON public.kaguya_rooms FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_sources update_updatedat_kaguya_sources; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_sources BEFORE UPDATE ON public.kaguya_sources FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_subscriptions update_updatedat_kaguya_subscriptions; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_subscriptions BEFORE UPDATE ON public.kaguya_subscriptions FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_translations update_updatedat_kaguya_translations; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_translations BEFORE UPDATE ON public.kaguya_translations FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_videos update_updatedat_kaguya_videos; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_videos BEFORE UPDATE ON public.kaguya_videos FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_watch_status update_updatedat_kaguya_watch_status; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_watch_status BEFORE UPDATE ON public.kaguya_watch_status FOR EACH ROW EXECUTE FUNCTION public.updated_at();


--
-- Name: kaguya_watched update_updatedat_kaguya_watched; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_updatedat_kaguya_watched BEFORE UPDATE ON public.kaguya_watched FOR EACH ROW EXECUTE FUNCTION public.updated_at();


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
-- Name: kaguya_chapters kaguya_chapters_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_chapters
    ADD CONSTRAINT "kaguya_chapters_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id);


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
-- Name: kaguya_episodes kaguya_episodes_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_episodes
    ADD CONSTRAINT "kaguya_episodes_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id);


--
-- Name: kaguya_images kaguya_images_chapterId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_images
    ADD CONSTRAINT "kaguya_images_chapterId_fkey" FOREIGN KEY ("chapterId") REFERENCES public.kaguya_chapters(slug) ON DELETE CASCADE;


--
-- Name: kaguya_images kaguya_images_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_images
    ADD CONSTRAINT "kaguya_images_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id);


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
-- Name: kaguya_notification_users kaguya_notification_users_notificationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_notification_users
    ADD CONSTRAINT "kaguya_notification_users_notificationId_fkey" FOREIGN KEY ("notificationId") REFERENCES public.kaguya_notifications(id);


--
-- Name: kaguya_notification_users kaguya_notification_users_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_notification_users
    ADD CONSTRAINT "kaguya_notification_users_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id);


--
-- Name: kaguya_notifications kaguya_notifications_receiverId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_notifications
    ADD CONSTRAINT "kaguya_notifications_receiverId_fkey" FOREIGN KEY ("receiverId") REFERENCES public.users(id);


--
-- Name: kaguya_notifications kaguya_notifications_senderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_notifications
    ADD CONSTRAINT "kaguya_notifications_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES public.users(id);


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
-- Name: kaguya_sources kaguya_sources_addedUserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_sources
    ADD CONSTRAINT "kaguya_sources_addedUserId_fkey" FOREIGN KEY ("addedUserId") REFERENCES public.users(id);


--
-- Name: kaguya_subscriptions kaguya_subscriptions_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_subscriptions
    ADD CONSTRAINT "kaguya_subscriptions_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id);


--
-- Name: kaguya_videos kaguya_videos_episodeId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_videos
    ADD CONSTRAINT "kaguya_videos_episodeId_fkey" FOREIGN KEY ("episodeId") REFERENCES public.kaguya_episodes(slug) ON DELETE CASCADE;


--
-- Name: kaguya_videos kaguya_videos_hostingId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_videos
    ADD CONSTRAINT "kaguya_videos_hostingId_fkey" FOREIGN KEY ("hostingId") REFERENCES public.kaguya_hostings(id);


--
-- Name: kaguya_videos kaguya_videos_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.kaguya_videos
    ADD CONSTRAINT "kaguya_videos_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id);


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
-- Name: sce_comment_reactions sce_comment_reactions_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sce_comment_reactions
    ADD CONSTRAINT sce_comment_reactions_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES public.sce_comments(id) ON DELETE CASCADE;


--
-- Name: sce_comment_reactions sce_comment_reactions_reaction_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sce_comment_reactions
    ADD CONSTRAINT sce_comment_reactions_reaction_type_fkey FOREIGN KEY (reaction_type) REFERENCES public.sce_reactions(type);


--
-- Name: sce_comment_reactions sce_comment_reactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sce_comment_reactions
    ADD CONSTRAINT sce_comment_reactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: sce_comments sce_comments_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sce_comments
    ADD CONSTRAINT sce_comments_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.sce_comments(id) ON DELETE CASCADE;


--
-- Name: sce_comments sce_comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sce_comments
    ADD CONSTRAINT sce_comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


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
-- Name: sce_comment_reactions Enable access to all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable access to all users" ON public.sce_comment_reactions FOR SELECT USING (true);


--
-- Name: sce_comments Enable access to all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable access to all users" ON public.sce_comments FOR SELECT USING (true);


--
-- Name: sce_reactions Enable access to all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable access to all users" ON public.sce_reactions FOR SELECT USING (true);


--
-- Name: users Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable access to all users" ON public.users FOR SELECT USING (true);


--
-- Name: kaguya_anime_source Enable delete for users based on source_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable delete for users based on source_id" ON public.kaguya_anime_source FOR DELETE USING ((auth.uid() = ( SELECT kaguya_sources."addedUserId"
   FROM public.kaguya_sources
  WHERE ((kaguya_anime_source."sourceId")::text = (kaguya_sources.id)::text))));


--
-- Name: kaguya_anime_subscribers Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable delete for users based on user_id" ON public.kaguya_anime_subscribers FOR DELETE USING ((auth.uid() = "userId"));


--
-- Name: kaguya_chapters Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable delete for users based on user_id" ON public.kaguya_chapters FOR DELETE USING ((auth.uid() = "userId"));


--
-- Name: kaguya_episodes Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable delete for users based on user_id" ON public.kaguya_episodes FOR DELETE USING ((auth.uid() = "userId"));


--
-- Name: kaguya_images Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable delete for users based on user_id" ON public.kaguya_images FOR DELETE USING ((auth.uid() = "userId"));


--
-- Name: kaguya_manga_source Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable delete for users based on user_id" ON public.kaguya_manga_source FOR DELETE USING ((auth.uid() = ( SELECT kaguya_sources."addedUserId"
   FROM public.kaguya_sources
  WHERE ((kaguya_manga_source."sourceId")::text = (kaguya_sources.id)::text))));


--
-- Name: kaguya_manga_subscribers Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable delete for users based on user_id" ON public.kaguya_manga_subscribers FOR DELETE USING ((auth.uid() = "userId"));


--
-- Name: kaguya_notification_users Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable delete for users based on user_id" ON public.kaguya_notification_users FOR DELETE USING ((auth.uid() = "userId"));


--
-- Name: kaguya_notifications Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable delete for users based on user_id" ON public.kaguya_notifications FOR DELETE USING ((auth.uid() = "senderId"));


--
-- Name: kaguya_videos Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable delete for users based on user_id" ON public.kaguya_videos FOR DELETE USING ((auth.uid() = "userId"));


--
-- Name: sce_comment_reactions Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable delete for users based on user_id" ON public.sce_comment_reactions FOR DELETE USING ((auth.uid() = user_id));


--
-- Name: sce_comments Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable delete for users based on user_id" ON public.sce_comments FOR DELETE USING ((auth.uid() = user_id));


--
-- Name: kaguya_anime_subscribers Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.kaguya_anime_subscribers FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: kaguya_images Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.kaguya_images FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: kaguya_manga_subscribers Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.kaguya_manga_subscribers FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: kaguya_notification_users Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.kaguya_notification_users FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: kaguya_notifications Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.kaguya_notifications FOR INSERT TO authenticated WITH CHECK (true);


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
-- Name: kaguya_translations Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.kaguya_translations FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: kaguya_videos Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.kaguya_videos FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: kaguya_watch_status Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.kaguya_watch_status FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: kaguya_watched Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.kaguya_watched FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: sce_comment_reactions Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable insert for authenticated users only" ON public.sce_comment_reactions FOR INSERT WITH CHECK (((auth.role() = 'authenticated'::text) AND (user_id = auth.uid())));


--
-- Name: sce_comments Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable insert for authenticated users only" ON public.sce_comments FOR INSERT WITH CHECK (((auth.role() = 'authenticated'::text) AND (user_id = auth.uid())));


--
-- Name: kaguya_dmca Enable read access for all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable read access for all users" ON public.kaguya_dmca FOR SELECT USING (true);


--
-- Name: kaguya_hostings Enable read access for all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable read access for all users" ON public.kaguya_hostings FOR SELECT USING (true);


--
-- Name: kaguya_images Enable read access for all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable read access for all users" ON public.kaguya_images FOR SELECT USING (true);


--
-- Name: kaguya_notification_users Enable read access for all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable read access for all users" ON public.kaguya_notification_users FOR SELECT USING (true);


--
-- Name: kaguya_notifications Enable read access for all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable read access for all users" ON public.kaguya_notifications FOR SELECT USING (true);


--
-- Name: kaguya_translations Enable read access for all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable read access for all users" ON public.kaguya_translations FOR SELECT USING (true);


--
-- Name: kaguya_videos Enable read access for all users; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable read access for all users" ON public.kaguya_videos FOR SELECT USING (true);


--
-- Name: kaguya_translations Enable update for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for authenticated users only" ON public.kaguya_translations FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


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
-- Name: users Enable update for users based on email; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on email" ON public.users FOR UPDATE USING ((auth.uid() = id)) WITH CHECK ((auth.uid() = id));


--
-- Name: kaguya_read_status Enable update for users based on id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on id" ON public.kaguya_read_status FOR UPDATE USING ((auth.uid() = "userId")) WITH CHECK ((auth.uid() = "userId"));


--
-- Name: kaguya_watch_status Enable update for users based on id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on id" ON public.kaguya_watch_status FOR UPDATE USING ((auth.uid() = "userId")) WITH CHECK ((auth.uid() = "userId"));


--
-- Name: sce_comments Enable update for users based on id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable update for users based on id" ON public.sce_comments FOR UPDATE USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- Name: kaguya_notifications Enable update for users based on senderId; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on senderId" ON public.kaguya_notifications FOR UPDATE USING ((auth.uid() = "senderId")) WITH CHECK ((auth.uid() = "senderId"));


--
-- Name: kaguya_notification_users Enable update for users based on userId; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on userId" ON public.kaguya_notification_users FOR UPDATE USING ((auth.uid() = "userId")) WITH CHECK ((auth.uid() = "userId"));


--
-- Name: kaguya_chapters Enable update for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on user_id" ON public.kaguya_chapters FOR UPDATE USING ((auth.uid() = "userId")) WITH CHECK ((auth.uid() = "userId"));


--
-- Name: kaguya_episodes Enable update for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on user_id" ON public.kaguya_episodes FOR UPDATE USING ((auth.uid() = "userId")) WITH CHECK ((auth.uid() = "userId"));


--
-- Name: kaguya_images Enable update for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on user_id" ON public.kaguya_images FOR UPDATE USING ((auth.uid() = "userId")) WITH CHECK ((auth.uid() = "userId"));


--
-- Name: kaguya_videos Enable update for users based on user_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for users based on user_id" ON public.kaguya_videos FOR UPDATE USING ((auth.uid() = "userId"));


--
-- Name: sce_comment_reactions Enable update for users based on user_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable update for users based on user_id" ON public.sce_comment_reactions FOR UPDATE USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


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
-- Name: kaguya_dmca; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_dmca ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_episodes; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_episodes ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_hostings; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_hostings ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_images; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_images ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_manga_source; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_manga_source ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_manga_subscribers; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_manga_subscribers ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_notification_users; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_notification_users ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_notifications; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_notifications ENABLE ROW LEVEL SECURITY;

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
-- Name: kaguya_translations; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_translations ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_videos; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_videos ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_watch_status; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_watch_status ENABLE ROW LEVEL SECURITY;

--
-- Name: kaguya_watched; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.kaguya_watched ENABLE ROW LEVEL SECURITY;

--
-- Name: sce_comment_reactions; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.sce_comment_reactions ENABLE ROW LEVEL SECURITY;

--
-- Name: sce_comments; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.sce_comments ENABLE ROW LEVEL SECURITY;

--
-- Name: sce_migrations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.sce_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sce_reactions; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.sce_reactions ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

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
-- Name: TABLE kaguya_dmca; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_dmca TO postgres;
GRANT ALL ON TABLE public.kaguya_dmca TO anon;
GRANT ALL ON TABLE public.kaguya_dmca TO authenticated;
GRANT ALL ON TABLE public.kaguya_dmca TO service_role;


--
-- Name: SEQUENCE kaguya_dmca_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.kaguya_dmca_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.kaguya_dmca_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kaguya_dmca_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kaguya_dmca_id_seq TO service_role;


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
-- Name: TABLE kaguya_hostings; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_hostings TO postgres;
GRANT ALL ON TABLE public.kaguya_hostings TO anon;
GRANT ALL ON TABLE public.kaguya_hostings TO authenticated;
GRANT ALL ON TABLE public.kaguya_hostings TO service_role;


--
-- Name: TABLE kaguya_images; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_images TO postgres;
GRANT ALL ON TABLE public.kaguya_images TO anon;
GRANT ALL ON TABLE public.kaguya_images TO authenticated;
GRANT ALL ON TABLE public.kaguya_images TO service_role;


--
-- Name: SEQUENCE kaguya_images_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.kaguya_images_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.kaguya_images_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kaguya_images_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kaguya_images_id_seq TO service_role;


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
-- Name: TABLE kaguya_notification_users; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_notification_users TO postgres;
GRANT ALL ON TABLE public.kaguya_notification_users TO anon;
GRANT ALL ON TABLE public.kaguya_notification_users TO authenticated;
GRANT ALL ON TABLE public.kaguya_notification_users TO service_role;


--
-- Name: SEQUENCE kaguya_notification_users_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.kaguya_notification_users_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.kaguya_notification_users_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kaguya_notification_users_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kaguya_notification_users_id_seq TO service_role;


--
-- Name: TABLE kaguya_notifications; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_notifications TO postgres;
GRANT ALL ON TABLE public.kaguya_notifications TO anon;
GRANT ALL ON TABLE public.kaguya_notifications TO authenticated;
GRANT ALL ON TABLE public.kaguya_notifications TO service_role;


--
-- Name: SEQUENCE kaguya_notifications_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.kaguya_notifications_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.kaguya_notifications_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kaguya_notifications_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kaguya_notifications_id_seq TO service_role;


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
-- Name: TABLE kaguya_subscriptions; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_subscriptions TO postgres;
GRANT ALL ON TABLE public.kaguya_subscriptions TO anon;
GRANT ALL ON TABLE public.kaguya_subscriptions TO authenticated;
GRANT ALL ON TABLE public.kaguya_subscriptions TO service_role;


--
-- Name: TABLE kaguya_translations; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_translations TO postgres;
GRANT ALL ON TABLE public.kaguya_translations TO anon;
GRANT ALL ON TABLE public.kaguya_translations TO authenticated;
GRANT ALL ON TABLE public.kaguya_translations TO service_role;


--
-- Name: TABLE kaguya_videos; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.kaguya_videos TO postgres;
GRANT ALL ON TABLE public.kaguya_videos TO anon;
GRANT ALL ON TABLE public.kaguya_videos TO authenticated;
GRANT ALL ON TABLE public.kaguya_videos TO service_role;


--
-- Name: SEQUENCE kaguya_videos_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.kaguya_videos_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.kaguya_videos_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kaguya_videos_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kaguya_videos_id_seq TO service_role;


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
-- Name: TABLE sce_comment_reactions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.sce_comment_reactions TO anon;
GRANT ALL ON TABLE public.sce_comment_reactions TO authenticated;
GRANT ALL ON TABLE public.sce_comment_reactions TO service_role;


--
-- Name: TABLE sce_comment_reactions_metadata; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.sce_comment_reactions_metadata TO anon;
GRANT ALL ON TABLE public.sce_comment_reactions_metadata TO authenticated;
GRANT ALL ON TABLE public.sce_comment_reactions_metadata TO service_role;


--
-- Name: TABLE sce_comments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.sce_comments TO anon;
GRANT ALL ON TABLE public.sce_comments TO authenticated;
GRANT ALL ON TABLE public.sce_comments TO service_role;


--
-- Name: TABLE sce_comments_with_metadata; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.sce_comments_with_metadata TO anon;
GRANT ALL ON TABLE public.sce_comments_with_metadata TO authenticated;
GRANT ALL ON TABLE public.sce_comments_with_metadata TO service_role;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.users TO postgres;
GRANT ALL ON TABLE public.users TO anon;
GRANT ALL ON TABLE public.users TO authenticated;
GRANT ALL ON TABLE public.users TO service_role;


--
-- Name: TABLE sce_display_users; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.sce_display_users TO anon;
GRANT ALL ON TABLE public.sce_display_users TO authenticated;
GRANT ALL ON TABLE public.sce_display_users TO service_role;


--
-- Name: TABLE sce_migrations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.sce_migrations TO anon;
GRANT ALL ON TABLE public.sce_migrations TO authenticated;
GRANT ALL ON TABLE public.sce_migrations TO service_role;


--
-- Name: TABLE sce_reactions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.sce_reactions TO anon;
GRANT ALL ON TABLE public.sce_reactions TO authenticated;
GRANT ALL ON TABLE public.sce_reactions TO service_role;


--
-- PostgreSQL database dump complete
--

