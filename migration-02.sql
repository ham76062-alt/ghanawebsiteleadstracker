-- Ghana Website Leads Tracker — user accounts + per-lead notes
-- Run this AFTER schema.sql and seed.sql, in Supabase: left menu
-- -> SQL Editor -> New query, paste this whole file, press Run.
-- It is safe to run again: it does not touch the 310 leads.
--
-- What it does, in plain words:
--  1. Adds a notes box to every lead.
--  2. Adds a profiles table: one row per login account, with a status
--     (pending / approved / rejected / deactivated).
--  3. When someone creates an account, a profile row is made for them
--     automatically — approved straight away for ham76062@gmail.com,
--     pending for everyone else.
--  4. Only approved accounts can read or change leads, feedback and
--     contracts. Anyone else is stopped, even if they are logged in.

-- 1. Notes on every lead (empty until someone writes one).
alter table public.leads add column if not exists notes text;

-- 2. Profiles: one row per account.
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null,
  full_name text not null default '',
  status text not null default 'pending'
    check (status in ('pending','approved','rejected','deactivated')),
  created_at timestamptz not null default now()
);
create index if not exists profiles_status_idx on public.profiles (status);

grant usage on schema public to authenticated;
grant select, insert, update, delete on table public.profiles to authenticated;

alter table public.profiles enable row level security;

-- Who can see profiles:
-- the owner sees every profile; anyone else sees only their own row.
drop policy if exists "profiles_owner_select" on public.profiles;
create policy "profiles_owner_select" on public.profiles
  for select to authenticated
  using ((auth.jwt() ->> 'email') = 'ham76062@gmail.com');

drop policy if exists "profiles_own_select" on public.profiles;
create policy "profiles_own_select" on public.profiles
  for select to authenticated
  using (id = auth.uid());

-- Who can change a profile's status or delete a profile:
-- only the owner, and never the owner's own row. New profile rows are
-- made by the trigger below, not from the app, so there is no insert rule.
drop policy if exists "profiles_owner_update" on public.profiles;
create policy "profiles_owner_update" on public.profiles
  for update to authenticated
  using ((auth.jwt() ->> 'email') = 'ham76062@gmail.com' and email <> 'ham76062@gmail.com')
  with check ((auth.jwt() ->> 'email') = 'ham76062@gmail.com' and email <> 'ham76062@gmail.com');

drop policy if exists "profiles_owner_delete" on public.profiles;
create policy "profiles_owner_delete" on public.profiles
  for delete to authenticated
  using ((auth.jwt() ->> 'email') = 'ham76062@gmail.com' and email <> 'ham76062@gmail.com');

-- 3. Make a profile row automatically when an account is created.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, full_name, status)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    case when new.email = 'ham76062@gmail.com' then 'approved' else 'pending' end
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 4. Backfill: make profile rows for accounts that already exist
-- (for example the owner's account, made before this file was run).
insert into public.profiles (id, email, full_name, status)
select
  id,
  email,
  coalesce(raw_user_meta_data ->> 'full_name', ''),
  case when email = 'ham76062@gmail.com' then 'approved' else 'pending' end
from auth.users
on conflict (id) do nothing;

-- 5. Only approved accounts can touch leads, feedback and contracts.
-- (This replaces the old "any logged-in user" rules.)
drop policy if exists "leads_authenticated_all" on public.leads;
create policy "leads_approved_all" on public.leads
  for all to authenticated
  using (exists (select 1 from public.profiles where id = auth.uid() and status = 'approved'))
  with check (exists (select 1 from public.profiles where id = auth.uid() and status = 'approved'));

drop policy if exists "feedback_authenticated_all" on public.feedback;
create policy "feedback_approved_all" on public.feedback
  for all to authenticated
  using (exists (select 1 from public.profiles where id = auth.uid() and status = 'approved'))
  with check (exists (select 1 from public.profiles where id = auth.uid() and status = 'approved'));

drop policy if exists "contracts_authenticated_all" on public.contracts;
create policy "contracts_approved_all" on public.contracts
  for all to authenticated
  using (exists (select 1 from public.profiles where id = auth.uid() and status = 'approved'))
  with check (exists (select 1 from public.profiles where id = auth.uid() and status = 'approved'));

-- Check: this should list the owner as approved (and anyone else pending).
select email, status from public.profiles order by created_at;
