-- Habit Tracker — Supabase schema
-- Run this once in your Supabase project's SQL Editor (Dashboard → SQL Editor → New query → Run).
-- Safe to re-run: every statement is guarded with IF NOT EXISTS / OR REPLACE.

-- ─── Habits ──────────────────────────────────────────────────────────────
create table if not exists habits (
  id           text primary key,              -- client-generated id (matches the app's existing id scheme)
  user_id      uuid not null references auth.users(id) on delete cascade,
  name         text not null,
  tag          text,
  freq         integer not null default 7,
  icon         text,                          -- optional emoji shown next to the habit name
  position     integer not null default 0,     -- manual drag-reorder position
  paused_from  date,
  paused_until date,
  created_at   timestamptz not null default now()
);
create index if not exists habits_user_id_idx on habits(user_id);
-- Safe to re-run on an existing table that predates the icon column:
alter table habits add column if not exists icon text;

-- ─── Completions (one row per habit per day it was done) ───────────────
create table if not exists completions (
  user_id  uuid not null references auth.users(id) on delete cascade,
  habit_id text not null references habits(id) on delete cascade,
  date     date not null,
  primary key (habit_id, date)
);
create index if not exists completions_user_id_idx on completions(user_id);

-- ─── Tags (name -> color, per user) ──────────────────────────────────────
create table if not exists tags (
  user_id uuid not null references auth.users(id) on delete cascade,
  name    text not null,
  color   text not null,
  primary key (user_id, name)
);

-- ─── Weekly review notes ─────────────────────────────────────────────────
create table if not exists notes (
  user_id    uuid not null references auth.users(id) on delete cascade,
  week_start date not null,                    -- the Sunday that starts the week
  text       text not null default '',
  primary key (user_id, week_start)
);

-- ─── Row Level Security ──────────────────────────────────────────────────
-- Everyone can only ever see or change their own rows, enforced at the
-- database layer (not just in the app) — this is what makes it safe for
-- multiple people to share one Supabase project.
alter table habits      enable row level security;
alter table completions enable row level security;
alter table tags        enable row level security;
alter table notes       enable row level security;

drop policy if exists "habits: owner only" on habits;
create policy "habits: owner only" on habits
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "completions: owner only" on completions;
create policy "completions: owner only" on completions
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "tags: owner only" on tags;
create policy "tags: owner only" on tags
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "notes: owner only" on notes;
create policy "notes: owner only" on notes
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
