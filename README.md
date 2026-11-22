# Ghana Website Leads Tracker — hosting package

A self-contained tracker app with all 110 verified leads, built to look and
work like the live Ghana Website Leads Tracker. One file: `index.html`.
No build step, no server code, no other files, no internet needed.

## Login on the hosted copy

Opening the page shows a login screen first: your email
ham76062@gmail.com with the same password as your app tracker
(tell the assistant if you want a different password — the file
will be rebuilt with it). The email box is blank — no example
shown. There is a Log out button at the top, and closing the
browser tab logs you out. **Logging out does not erase anything:**
your marks, feedback and contracts stay saved in this browser and
are still there when you log back in. They do not move to another
phone or computer — the tracker here in the Muse app is the one
that saves on every device. Clearing the browser's data, using
private browsing, or the Reset data button erases them.

**Be clear about what this lock does:** it only hides the page from
someone who opens the link without the password. The 110 leads are
written inside the `index.html` file itself, so anyone who downloads
the file can read them. It is NOT the same protection as the live
tracker in the Muse app, whose login is enforced on the server. Do not
put anything in the hosted copy that you would not want a visitor to
see, and do not reuse your app-tracker password here.

## What's inside

- `index.html` — the whole tracker in one file:
  - **Leads tab** — all 110 leads as cards, scores out of 10, highest
    first. Pick a niche from the dropdown (every niche, with lead
    counts); the City dropdown lists only the 16 main cities — Accra,
    Tamale, Takoradi, Kumasi, Tema, Cape Coast, Sunyani, Tarkwa, Kasoa,
    Elmina, Akim Oda, Bunso, Sogakope, Nsawam, Biriwa, Beyin — and
    picking one shows every lead in that city (Accra shows all 54).
    Filter by status with the pills (including new "No reply" and
    "Declined" pills). Tap "Problem, solution & contact"
    on a card and it opens like the tracker here: Problem spotted,
    What you'll build, Social, Best contact, Phone (and Email), with
    WhatsApp / Call / Email / Map buttons using the lead's real phone
    and a Google Maps search for the business. Business names use the
    same serif font as the tracker here. **Site built / Contacted /
    Booked** buttons on every card flip its badge right away (Booked
    turns gold), the counters at the top update, and tapping the active
    button again undoes a wrong tap.
    Under the three buttons, plain underlined text links **No reply**
    (they never answered) and **Declined** (they said no to the site) —
    tapping one marks the lead with that badge (the text turns amber or
    red and bold), tapping it again undoes it.
  - **Feedback & contracts tab** — pick any customer, then tap
    "+ Add customer feedback" to log what they said and the changes
    made after; tap "+ Add a contract" to add contracts (what was
    agreed, amount in GH₵, one-off/monthly/yearly billing,
    active/pending/ended, start and renewal dates, notes, Website and
    Drive links). Adding a contract automatically marks that customer
    as Booked on the Leads page. Every feedback entry and every contract has an
    **Edit** button — tap it to change it later, and a Delete button
    to remove it. The summary strip tracks feedback logged, active
    contracts and the monthly recurring total (monthly contracts add to
    it automatically), plus a **Total earnings** card beside Monthly
    recurring that adds up every contract amount — monthly, one-off and
    yearly together — so it grows as more contracts are added.
  - **Import Leads** — upload a CSV, match its columns to the lead fields
    (auto-matched, changeable) with a live preview. Every row is checked:
    missing name, bad email, or a score outside 0–10 is flagged invalid,
    and rows already in the tracker are flagged as duplicates. Nothing is
    saved until you press Confirm. Imported leads arrive as Not contacted.
  - **Download CSV** — exports whatever the table is currently showing.
  - **Reset data** — clears your marks on this device and restores the
    original 110 leads.

## How to host it

Any static host works:

1. **Vercel** — drag the `index.html` file (or this folder) onto
   vercel.com/new, or push it to a GitHub repo connected to Vercel.
   The file must be at the root of the project (or set the Root
   Directory to the folder it sits in).
2. **Netlify Drop** — go to app.netlify.com/drop and drag the folder
   onto the page. You get a live link in under a minute.
3. **GitHub Pages** — upload `index.html` to a repository, turn on
   Pages in the repository settings (branch: main, folder: root).
4. **Any web host / cPanel** — upload `index.html` to the public
   folder (usually `public_html`).

## Two honest limits of the hosted copy

1. **Marks save in this browser only.** Your taps, feedback and
   contracts are stored in the browser's own storage, so they stay on
   the device/browser you made them in. They do not sync to your phone
   or another computer. The live tracker in the Muse app is the version
   that saves on every device.
2. **No login on the hosted copy.** A static page cannot enforce a
   login — anyone who has the file can read the leads inside it. So
   this package has no login screen on purpose. The real login (only
   ham76062@gmail.com, password stored as a secure hash, enforced on
   the server) lives only on the live tracker in the app. Do not put
   anything in the hosted copy that you would not want a visitor to see.

## About the data

Verified 21–22 November 2026. Research only — no business contacted, no
demo built. Every entry was checked live: the business is operating, its
website was opened or confirmed absent, and its social pages and public
contact details were checked. Process: research → build → contact.
Verify a business exists and needs a site before building any demo.
