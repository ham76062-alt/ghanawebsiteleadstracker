-- Ghana Website Leads Tracker — Supabase tables
-- Run this ONCE in Supabase: left menu -> SQL Editor -> New query,
-- paste this whole file, press Run.
-- It is safe to run again: nothing is lost if you run it twice.

create table if not exists public.leads (
  id bigint primary key,
  rank integer not null,
  name text not null,
  industry text not null default '',
  city text not null default '',
  website text not null default '',
  social text not null default '',
  phone text not null default '',
  email text not null default '',
  problem text not null default '',
  solution text not null default '',
  score numeric(3,1),
  contact text not null default '',
  status text not null default 'new'
    check (status in ('new','built','contacted','booked','noreply','declined','notavailable')),
  built_at date,
  contacted_at date,
  booked_at date,
  created_at timestamptz not null default now()
);

create table if not exists public.feedback (
  id uuid primary key default gen_random_uuid(),
  lead_id bigint references public.leads(id) on delete cascade,
  customer text not null,
  text text not null,
  changes text not null default '',
  date date,
  created_at timestamptz not null default now()
);

create table if not exists public.contracts (
  id uuid primary key default gen_random_uuid(),
  lead_id bigint references public.leads(id) on delete cascade,
  customer text not null,
  what text not null,
  amount numeric not null default 0,
  billing text not null default 'monthly'
    check (billing in ('monthly','one-off','yearly')),
  status text not null default 'active'
    check (status in ('active','pending','ended')),
  start_date date,
  renew_date date,
  web text not null default '',
  drive text not null default '',
  notes text not null default '',
  created_at timestamptz not null default now()
);

create index if not exists leads_status_idx on public.leads (status);
create index if not exists feedback_lead_idx on public.feedback (lead_id);
create index if not exists contracts_lead_idx on public.contracts (lead_id);

grant usage on schema public to authenticated;
grant select, insert, update, delete on table public.leads to authenticated;
grant select, insert, update, delete on table public.feedback to authenticated;
grant select, insert, update, delete on table public.contracts to authenticated;

alter table public.leads enable row level security;
alter table public.feedback enable row level security;
alter table public.contracts enable row level security;

drop policy if exists "leads_authenticated_all" on public.leads;
create policy "leads_authenticated_all" on public.leads
  for all to authenticated
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

drop policy if exists "feedback_authenticated_all" on public.feedback;
create policy "feedback_authenticated_all" on public.feedback
  for all to authenticated
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

drop policy if exists "contracts_authenticated_all" on public.contracts;
create policy "contracts_authenticated_all" on public.contracts
  for all to authenticated
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');
