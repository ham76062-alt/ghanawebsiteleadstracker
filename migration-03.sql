-- Ghana Website Leads Tracker — business type, follow-up dates, Pending outcome
-- Run this AFTER schema.sql, seed.sql and migration-02.sql, in Supabase:
-- left menu -> SQL Editor -> New query, paste this whole file, press Run.
-- It is safe to run again: it does not touch the 310 leads or their marks.
--
-- What it does, in plain words:
--  1. Adds a business type to every lead (local or foreign). Every lead
--     you already have is set to local.
--  2. Adds a follow-up date to every lead (empty until you pick one).
--  3. Allows a new outcome, Pending, on a lead.
--
-- 1. Business type on every lead (every existing lead becomes local).
alter table public.leads add column if not exists business_type text not null default 'local'
  check (business_type in ('local','foreign'));

-- 2. Follow-up date on every lead (empty until you pick one).
alter table public.leads add column if not exists follow_up_date date;

-- 3. Allow 'pending' as a lead status.
-- The status rule was made without a name in schema.sql, so Postgres
-- named it leads_status_check. Find whatever it is called now and drop
-- it, then put the rule back with 'pending' added.
DO $$
DECLARE cname text;
BEGIN
  SELECT conname INTO cname
  FROM pg_constraint
  WHERE conrelid = 'public.leads'::regclass
    AND contype = 'c'
    AND pg_get_constraintdef(oid) ILIKE '%status%';
  IF cname IS NOT NULL THEN
    EXECUTE format('ALTER TABLE public.leads DROP CONSTRAINT %I', cname);
  END IF;
END $$;
ALTER TABLE public.leads ADD CONSTRAINT leads_status_check
  CHECK (status IN ('new','built','contacted','booked','noreply','declined','notavailable','pending'));

-- Check: this should show all your leads as local, and your marks unchanged.
select business_type, count(*) as leads from public.leads group by business_type order by business_type;
select status, count(*) as leads from public.leads group by status order by status;
