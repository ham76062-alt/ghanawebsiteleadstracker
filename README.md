# Ghana Website Leads Tracker — Supabase version

The same tracker you already use, with one big change: **your marks now
save in Supabase, so they are the same on your phone and laptop.**
The look is the same. The 310 leads are the same. Only the saving
changed — it used to save in one browser only, and that is fixed.

The 310 leads are no longer written inside `index.html`. They live in
Supabase now, so nobody can read them by downloading the file.

## Round 6 update — stages, Calendar, Filter (26 Nov 2026)

If your tracker is already live, you only need two steps. Do them in
this order:

### Step A — Run migration-06 in Supabase

1. Open your Supabase project (ghanawebsiteleadstracker).
2. In the left menu, click **SQL Editor**, then **New query**.
3. Open `migration-06.sql` from this folder, copy everything in it,
   paste it into the query box, and press **Run**.
4. It is safe to run again. It copies your current marks into the new
   switches, exactly as they are — nothing extra is switched on.
5. If you never ran migration-02, migration-03, migration-04 or
   migration-05, run those first, in that order, then run 06.

### Step B — Replace index.html on GitHub

Same as step 4 below: replace the old `index.html` with the new one
from this folder. Vercel updates your site by itself. Wait about a
minute, then open the site and log in.

### What is new

- **Stages are separate switches.** On each lead: Contacted, Site
  built, Booked — in that order. Tap one and it stays on; tap the
  others and they stay on too. Tap again to switch one off.
- **Outcome is on its own.** Picking No reply, Declined, Not
  available or Pending only changes the outcome. It never touches
  the three switches.
- **Calendar tab** (after Feedback & contracts, for everyone). It
  shows the days you called, from the contact dates on your leads.
  Tap a day to see the companies you called that day, by name, and
  how many booked. Follow-up dates show as due.
- **Filter button.** The row of filter buttons is gone. One small
  Filter button sits next to Import Leads — tap it and tick as many
  filters as you want. The leads move up to fill the space.
- The CSV download now has Contacted, Site built, Booked and Outcome
  as separate columns.

## What is in this folder

- `index.html` — the new tracker. One file, same as before. Upload
  this to GitHub (step 4 below).
- `schema.sql` — makes the tables in Supabase. Run it once.
- `seed.sql` — puts the 310 leads into those tables. Run it once,
  after `schema.sql`.
- `migration-02.sql` … `migration-06.sql` — changes made after the
  first setup. Run each one once, in order, in the Supabase SQL
  Editor. 06 is the new one for this round.
- `README.md` — this file.

## Do these steps in order

### Step 1 — Make the tables

1. Open your Supabase project (ghanawebsiteleadstracker).
2. In the left menu, click **SQL Editor**, then **New query**.
3. Open `schema.sql` on your computer, copy everything in it, paste
   it into the query box, and press **Run**.
4. You should see "Success. No rows returned." That is correct.

### Step 2 — Put the 310 leads in

1. In the SQL Editor, click **New query** again.
2. Open `seed.sql`, copy everything in it, paste it, and press **Run**.
3. At the end it shows a number. That number should be **310**.
   If it is not 310, tell the assistant before you go on.

### Step 3 — Make your login

1. In the left menu, click **Authentication**, then **Users**.
2. Click **Add user**, then **Create new user**.
3. Email: `ham76062@gmail.com`
4. Password: pick a password you will remember. This is the password
   you will use to log in to the tracker from now on.
5. Click **Create user**.

The old hosted password will not work any more. Only this new
Supabase login works.

### Step 4 — Put the new file on GitHub

1. Open your GitHub repo for the tracker (the same one Vercel uses).
2. Replace the old `index.html` with the new `index.html` from this
   folder. Same name, same place. (Upload files, pick the new file,
   commit.)
3. Vercel sees the change and updates your site by itself. You do
   not need to touch Vercel. Wait about a minute.

### Step 5 — Open it and log in

1. Open your site: `https://ghanawebsiteleadstracker.vercel.app/`
2. Log in with `ham76062@gmail.com` and the password from step 3.
3. You should see all 310 leads. Tap a lead's Contacted button to
   test it, then open the site on your other device and log in — the
   mark should already be there.

## Three honest notes

1. **Old marks do not move over.** Marks you made on the old hosted
   copy were saved in that device's browser only, so they stay there.
   The new copy starts with all 310 leads as Not contacted. If you
   had marked any as Contacted or Booked on the old copy, tap them
   again in the new copy — it takes a minute.
2. **Reset data now clears every device.** The Reset data button
   used to clear only the device you tapped it on. Now it clears
   your marks, feedback and contracts everywhere. Only tap it if
   you really want to start again.
3. **Free Supabase sleeps after 7 days with no use.** You open the
   tracker most days, so it should stay awake. If it ever sleeps,
   open Supabase and click to wake it up — nothing is lost.

## Safety

- Only the **publishable key** is in `index.html`. That key is safe
  to be in the file. The **secret key** is not in any file here, and
  it must never be put in the file or shared with anyone.
- Only people logged in can read or change the data. The rules that
  enforce this are in `schema.sql` (Row Level Security).
- If the page ever says "Could not load your leads", it means it
  could not reach Supabase. Check your internet, then tap Try again.
  If it keeps failing, check that steps 1 and 2 above were done.
