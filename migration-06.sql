-- Ghana Website Leads Tracker — stages as separate switches + outcome on its own
-- Run this AFTER migration-05.sql, in Supabase: left menu -> SQL Editor
-- -> New query, paste this whole file, press Run.
-- It is safe to run again: it does not touch the businesses, and it never
-- wipes marks you made with the new tracker.
--
-- What it does, in plain words:
--  1. Adds three yes/no switches to your own marks (lead_state):
--     contacted, site_built and booked. Each one is on or off on its own,
--     so a lead can be Contacted and Site built and Booked all at once.
--  2. Adds an outcome of its own: No reply / Declined / Not available /
--     Pending (or empty). Picking an outcome no longer touches the switches.
--  3. Copies your current marks into the new switches, exactly as they are:
--     Contacted -> contacted on; Site built -> site built on;
--     Booked -> booked on; No reply / Declined / Not available / Pending
--     -> outcome, with no switches on. Nothing extra is switched on.
--  4. Your old status stays in place, untouched. Nothing is lost, and the
--     old tracker file keeps working until you upload the new one.
--
-- Run this BEFORE you upload the new index.html. The new file needs these
-- columns to save your marks.

-- 1. The three switches + the outcome, on your own marks.
alter table public.lead_state add column if not exists contacted boolean not null default false;
alter table public.lead_state add column if not exists site_built boolean not null default false;
alter table public.lead_state add column if not exists booked boolean not null default false;
alter table public.lead_state add column if not exists outcome text not null default ''
  check (outcome in ('', 'noreply', 'declined', 'notavailable', 'pending'));

-- 2. Copy your current marks, exactly as they are.
-- Only rows with no switches on yet are copied, so running this twice
-- never wipes marks you made with the new tracker.
update public.lead_state
set contacted = (status = 'contacted'),
    site_built = (status = 'built'),
    booked = (status = 'booked'),
    outcome = case when status in ('noreply', 'declined', 'notavailable', 'pending') then status else '' end
where contacted = false and site_built = false and booked = false and outcome = '';

-- Check: these should match the numbers on your screen.
-- (A lead can now count in more than one column.)
select count(*) filter (where contacted) as contacted,
       count(*) filter (where site_built) as site_built,
       count(*) filter (where booked) as booked
from public.lead_state;
select outcome, count(*) as leads from public.lead_state group by outcome order by outcome;
