# Setup

## 1. Create new project

Sign up [Supabase](https://app.supabase.io), create a new project. Wait for your database is up running.

## 2. Create tables and functions

Go to _SQL Editor_ in the left sidebar.

![SQL Editor](https://i.ibb.co/0yVdWZL/image-2022-04-11-111745302.png)

Create a new query, paste in this [schema](https://github.com/hoangvu12/kaguya-database/blob/main/schema.sql) and hit run.

![New Query](https://i.ibb.co/MNmqmgQ/image-2022-04-11-112013701.png)

This will create tables and functions that [Kaguya](github.com/hoangvu12/Kaguya) needed for running.

## 3. Copy URL and Keys

Go to the Project Settings (the cog icon), open the API tab, and find your API URL and anon key. You will need these later.

![URL and Keys](https://i.ibb.co/L8rPfNM/image-2022-04-11-112755195.png)

The `anon` key is your client-side key. Which anyone can use it to access your database, but will be restricted by [row level security](https://supabase.com/docs/guides/auth/row-level-security)

The `service_role` key has full access your data, it will bypass all row level securities. These keys have to be kept secret and are meant to be used in server environments and never on a client or browser.

# Notes

Don't blame me if the structure is bad, I had no experience while making these structure, and it will take a lot of effort to change.

If you are an experience sql developer, feel free to contribute.

Thank you :)
