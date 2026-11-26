-- Ghana Website Leads Tracker — contact date on every lead
-- Run this AFTER schema.sql, seed.sql, migration-02.sql and migration-03.sql,
-- in Supabase: left menu -> SQL Editor -> New query, paste this whole file, press Run.
-- It is safe to run again: it does not touch the 310 leads or their marks.
--
-- What it does, in plain words:
--  1. Adds a contact date to every lead (empty until you pick one) —
--     the date you called the business or booked the site.
-- Nothing else changes: deleting a lead uses the tables and rules that
-- are already there (its feedback and contracts are removed with it).

-- 1. Contact date on every lead (empty until you pick one).
alter table public.leads add column if not exists contact_date date;

-- Check: this should show all your leads, and how many have a contact date set.
select count(*) as leads from public.leads;
select count(*) as leads_with_contact_date from public.leads where contact_date is not null;
