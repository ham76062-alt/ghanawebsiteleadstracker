-- Ghana Website Leads Tracker — each user has their own marks
-- Run this AFTER schema.sql, seed.sql, migration-02.sql, migration-03.sql
-- and migration-04.sql, in Supabase: left menu -> SQL Editor -> New query,
-- paste this whole file, press Run.
-- It is safe to run again: it does not touch the 310 businesses and it
-- does not lose anyone's marks.
--
-- What it does, in plain words:
--  1. Adds a new table, lead_state: one row per person per lead, holding
--     that person's own marks (status, notes, business type, dates).
--     The 310 businesses stay one shared list for everyone.
--  2. Copies the marks you already have into your own lead_state rows,
--     so nothing you marked is lost.
--  3. Feedback and contracts now belong to the person who wrote them.
--     The ones already saved stay with you (the owner).
--  4. New rules: you can only see and change your own marks, feedback
--     and contracts — and the same goes for every other user, including
--     for the owner. The owner still manages users, imports and deletes.
--  5. Only the owner can change or delete a business itself.

-- 1. Your own marks, one row per person per lead.
create table if not exists public.lead_state (
  user_id uuid not null references auth.users(id) on delete cascade,
  lead_id bigint not null references public.leads(id) on delete cascade,
  status text not null default 'new'
    check (status in ('new','built','contacted','booked','noreply','declined','notavailable','pending')),
  notes text,
  business_type text not null default 'local'
    check (business_type in ('local','foreign')),
  follow_up_date date,
  contact_date date,
  updated_at timestamptz not null default now(),
  primary key (user_id, lead_id)
);
create index if not exists lead_state_user_idx on public.lead_state (user_id);

grant usage on schema public to authenticated;
grant select, insert, update, delete on table public.lead_state to authenticated;

alter table public.lead_state enable row level security;

-- You can only ever see or change your own marks.
drop policy if exists "lead_state_own_all" on public.lead_state;
create policy "lead_state_own_all" on public.lead_state
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- If a mark is saved without a user, it belongs to whoever is logged in.
alter table public.lead_state alter column user_id set default auth.uid();

-- 2. Copy the marks already on the leads into your own rows.
-- (If another user made any of these marks, they come across as yours:
-- the old shared table never recorded who made a mark.)
insert into public.lead_state (user_id, lead_id, status, notes, business_type, follow_up_date, contact_date)
select u.id, l.id, l.status, l.notes, coalesce(l.business_type, 'local'), l.follow_up_date, l.contact_date
from public.leads l
cross join (select id from auth.users where email = 'ham76062@gmail.com') u
where l.status <> 'new'
   or (l.notes is not null and l.notes <> '')
   or coalesce(l.business_type, 'local') <> 'local'
   or l.follow_up_date is not null
   or l.contact_date is not null
on conflict (user_id, lead_id) do nothing;

-- 3. Feedback and contracts now belong to the person who wrote them.
alter table public.feedback add column if not exists owner_id uuid references auth.users(id) on delete cascade;
alter table public.contracts add column if not exists owner_id uuid references auth.users(id) on delete cascade;
-- If a row is saved without an owner, it belongs to whoever is logged in.
alter table public.feedback alter column owner_id set default auth.uid();
alter table public.contracts alter column owner_id set default auth.uid();
-- The feedback and contracts already saved stay with you (the owner).
update public.feedback set owner_id = (select id from auth.users where email = 'ham76062@gmail.com') where owner_id is null;
update public.contracts set owner_id = (select id from auth.users where email = 'ham76062@gmail.com') where owner_id is null;

-- 4. New rules for feedback and contracts: only the owner of a row
-- can see it or change it.
drop policy if exists "feedback_approved_all" on public.feedback;
create policy "feedback_owner_all" on public.feedback
  for all to authenticated
  using (owner_id = auth.uid())
  with check (owner_id = auth.uid());

drop policy if exists "contracts_approved_all" on public.contracts;
create policy "contracts_owner_all" on public.contracts
  for all to authenticated
  using (owner_id = auth.uid())
  with check (owner_id = auth.uid());

-- 5. New rules for the shared list of businesses: everyone approved
-- can see it and add to it, but only the owner can change or delete
-- a business itself.
drop policy if exists "leads_approved_all" on public.leads;
create policy "leads_approved_select" on public.leads
  for select to authenticated
  using (exists (select 1 from public.profiles where id = auth.uid() and status = 'approved'));
create policy "leads_approved_insert" on public.leads
  for insert to authenticated
  with check (exists (select 1 from public.profiles where id = auth.uid() and status = 'approved'));
create policy "leads_owner_update" on public.leads
  for update to authenticated
  using ((auth.jwt() ->> 'email') = 'ham76062@gmail.com')
  with check ((auth.jwt() ->> 'email') = 'ham76062@gmail.com');
create policy "leads_owner_delete" on public.leads
  for delete to authenticated
  using ((auth.jwt() ->> 'email') = 'ham76062@gmail.com');

-- Checks: your marks should be copied (one row per lead you marked),
-- the feedback and contracts should all have an owner, and the 310
-- businesses should still all be there.
select count(*) as my_marks from public.lead_state;
select status, count(*) as leads from public.lead_state group by status order by status;
select count(*) as feedback_with_owner from public.feedback where owner_id is not null;
select count(*) as contracts_with_owner from public.contracts where owner_id is not null;
select count(*) as businesses from public.leads;
