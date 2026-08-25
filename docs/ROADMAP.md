# Roadmap: peptides research South Africa

| Field | Value |
| --- | --- |
| Working name | `peptides_research_south_africa` |
| Public name | TBD (see PRD) |
| Owner | David Teren |
| Date | 2026-08-25 |
| Status | First roadmap. Phases are order and effort, not a calendar. This file does not promise that any phase is already built. |

This is a research catalog. It is not a clinic. It is not a pharmacy.

Source documents: [PRD](PRD.md), [epics](EPICS.md), [scout inventory](research/scout-inventory.md), [ideation](research/ideation.md). Phases follow PRD priority (P0, then P1, then P2) and the epics in EPICS.md. Every feature has exactly one primary epic there.

---

## How to read this file

- **Phases are sequence, not dates.** Effort is in weekends of focused work.
- **Phase 1 is the smallest useful product.** JSON files plus a readable catalog. Zero paid APIs. No accounts. No scrape farm in the app.
- **Exit criteria use “you can now …”.** A phase is done when a person can do those things, not when a ticket list is empty.
- **Every PRD feature (F-1 to F-23) appears in at least one phase.** Schema-only work for later features lives in Phase 1 so later phases do not rewrite the files.
- **Primary epic lives in EPICS.md.** This file is the phase map. An epic may span two phases (EP-02 for F-8 stamp chrome, EP-08 for F-20). Closing a phase does not require that epic to be finished.
- **Research during a phase may open public pages** (SAHPRA, WADA, PubMed, vendor homepages). The running app must not scrape live shops.

Ideas in the PRD non-goals table stay off this roadmap. Do not add checkout, order buttons, live stock, clinic booking, dosing advice, injection technique, AI protocol generators, a general drug-interaction engine, user reviews, affiliate ranking, hosted COA PDFs, a traffic-light “legal to buy”, or a forum.

---

## Phase map (one screen)

| Phase | What it is | Effort | Features | PRD priority |
| --- | --- | --- | --- | --- |
| **1. Honest catalog** | JSON source of truth, import, compound / provider / product pages, disclaimer, first scout drop | ~2 weekends | F-1, F-2, F-3, F-4, F-14 | P0 core |
| **2. Find and judge** | Alias search, filters, SAHPRA / WADA / evidence / COA / verified stamps, comparison | ~2 weekends | F-5, F-6, F-7, F-8, F-9, F-10, F-11, F-12, F-13 | P0 extras |
| **3. Offline and the research loop** | PWA cache, device-local saves, documented Grok loop | ~1–2 weekends | F-15, F-16, F-17 | P1 |
| **4. Stacks** | Stack checker, named stacks, pair notes | ~2 weekends | F-18, F-19, F-21 | P2 |
| **5. Later** | Accounts, reconstitution helper, native wrapper | later | F-20, F-22, F-23 | P2 |

Stack work waits until the catalog is trusted (Phase 4 after Phases 1 to 3). Native wrapping waits until the PWA is installable (F-23 after F-15). Named stacks wait until the checker exists (F-19 after F-18). F-20 stays in EP-08 and waits for Phase 5; Phase 4 can close without it. No P0 feature sits only in Phase 5.

---

## Feature index

Every PRD feature appears here. “Schema in Phase 1” means the JSON keys exist on day one. The user-facing work still lands in the phase named in the **Lands** column. **Epic** is the single primary epic from EPICS.md.

| ID | Title | Lands | Epic | Notes |
| --- | --- | --- | --- | --- |
| F-1 | JSON catalog as source of truth | Phase 1 | EP-01 | Includes stack schema and later-flag keys so files are not rewritten |
| F-2 | Compound index and detail | Phase 1 | EP-02 | Index shows name, class, routes, evidence grade as stored facts. That listed grade is F-2, not the F-8 stamp |
| F-3 | Provider index and detail (SA-first) | Phase 1 | EP-03 | Type is stored and shown. Comparison table is F-9 |
| F-4 | Product listings | Phase 1 | EP-03 | No Buy button. Login-gated prices stay empty |
| F-5 | Browse and filter | Phase 2 | EP-05 | Needs enough records to make empty results meaningful. Class chips live here |
| F-6 | Alias and misspelling search | Phase 2 | EP-05 | Aliases are stored in Phase 1 JSON |
| F-7 | Legal and regulatory flags (SAHPRA) | Phase 2 | EP-04 | SAHPRA object is required in Phase 1 schema |
| F-8 | Evidence grades | Phase 2 | EP-02 | Grade is stored in Phase 1 and listed on the index (F-2). Phase 2 is card-level stamp chrome only |
| F-9 | Provider type taxonomy and comparison | Phase 2 | EP-03 | Type is on every provider in Phase 1. Comparison rows land here |
| F-10 | WADA / SAIDS flag | Phase 2 | EP-04 | WADA object in Phase 1 schema. Flag sits high on the page here |
| F-11 | COA-stated flag | Phase 2 | EP-03 | COA URL on product JSON in Phase 1. Copy is “provider states a COA” |
| F-12 | Last-verified stamps | Phase 2 | EP-05 | Review date is required from Phase 1 (CI). UI stamps land here |
| F-13 | Compound class taxonomy | Phase 2 | EP-02 | Primary class is stored in Phase 1. Filter chips by class are F-5 in this phase |
| F-14 | Site-wide informational disclaimer | Phase 1 | EP-01 | Visible above the fold on compound views from day one |
| F-15 | PWA offline catalog | Phase 3 | EP-06 | Enable the existing Rails PWA stubs. No web push |
| F-16 | Device-local saved compounds | Phase 3 | EP-06 | Device-local storage only. No server table |
| F-17 | Agent research workflow documented | Phase 3 | EP-07 | Written from a working import, not as vapour |
| F-18 | Stack checker | Phase 4 | EP-08 | Schema in F-1. UI only after the catalog is trusted |
| F-19 | Named suggested stacks | Phase 4 | EP-08 | After F-18. Do not publish a named stack that fails the checker |
| F-20 | Reconstitution arithmetic helper | Phase 5 | EP-08 | Unit maths only. Must not pre-fill from reported protocols. Not started until this phase |
| F-21 | Curated pair notes UI | Phase 4 | EP-08 | Inside the stack checker. Not a second screen |
| F-22 | Accounts and synced saves | Phase 5 | EP-09 | Magic link. Browse still works logged out |
| F-23 | Native mobile wrapper | Phase 5 | EP-09 | After F-15 is real. Same catalog as the web app |

---

## Phase 1. Honest catalog

**Effort:** ~2 weekends.
**Goal:** A person in South Africa can read a small, cited catalog with no account and no paid network services.

This is the smallest slice that is actually useful. A search box over empty files is not a product. Stamps over empty files are theatre. A readable compound page next to a named local provider is the product.

### Why this is first

JSON in the catalog folder is the research source of truth (PRD goal 2). Rails imports it into PostgreSQL. Agents never write the database. If the schema, import, and pages do not exist, later search, flags, and stacks have nowhere to land.

### In scope

- **F-1.** One record per file under the catalog folder. Schemas for source, compound, provider, product, and stack. Templates. Stacks folder empty except a placeholder. Rails import of valid files. Invalid JSON or a failed schema check cannot merge. Price never lives on a compound file.
- **F-2.** Compound index and detail: what it is, class, aliases, routes, forms, research uses, and **commonly reported research protocols** as cited text. Not a calculator. Index lists the stored evidence grade as a fact. That listed grade is not the F-8 card stamp.
- **F-3.** Provider index and detail for the first eight live SA providers. Show type, city if known, website, listing posture, prescription flag, linked products. Status down or excluded stays out of the public index.
- **F-4.** Product rows for SKUs with a live URL and a visible form. Compound, provider, form, route, strength, pack, rand price, price date. No Buy button. No WhatsApp order. No live stock badge.
- **F-14.** Disclaimer on every compound, provider, and product view: not medical advice, not legal advice, not an instruction to buy or use, not an endorsement of any provider.

Schema keys for later flags (SAHPRA, WADA, evidence grade, COA URL, review date, primary class, empty pair notes) are required or present now. Phase 2 reads them. It does not invent a second file shape.

### First catalog drop (from scout §4.6)

**Compounds (6):** `bpc-157`, `tb-500`, `semax`, `selank`, `ghk-cu`, `noopept`.

**Providers (8):** `reschem`, `biopeptics`, `tetratide-labs`, `the-clinic`, `comp-pharm`, `alphahuman`, `neuroactive`, `primeself`.

**Products:** only where form is visible on a live URL. The Clinic login-gated prices store no price and a visible-without-login flag of false. RPSA stays out until city and SKUs are confirmed.

Compound summary and research uses cite regulator or primary literature. Vendor pages are enough for product facts only. Wikipedia, if used, is encyclopedia kind plus a primary source.

### Out of scope here

Paid APIs. Accounts. Live scrape in the app. Search and filter UI (F-5, F-6). F-8 card-level stamp (extra chrome; the index already lists the stored grade as F-2). First-class legal / WADA / COA / 90-day stamps (F-7, F-9 to F-12). Filter chips by class (F-5 / F-13). PWA routes. Stacks UI. Native apps. Arithmetic helper (F-20, Phase 5).

Research in this phase may open public SAHPRA, WADA, PubMed, and vendor pages by hand or in an agent session. That is how the first JSON is written. The app still does not scrape.

### Exit criteria

You can now:

1. Open a compound page for each of the six starter compounds and read a cited summary, routes, and commonly reported research protocols.
2. See the stored evidence grade listed on the compound index as a fact, not as a card-level stamp.
3. Open a provider page for each of the eight starter providers and see type, listing posture, and linked products.
4. Compare at least one compound across more than one provider by form and ZAR as-of date, with no Buy button.
5. See the informational disclaimer without scrolling past the fold on compound views.
6. Fail a check by committing invalid JSON, a missing review date, or empty sources.
7. Run the site locally with PostgreSQL only. No paid API keys. No user accounts.

---

## Phase 2. Find and judge

**Effort:** ~2 weekends.
**Goal:** A visitor can find a compound by alias and can judge legal, evidence, athlete, and provider-type facts on the same page.

This lands after Phase 1 because filters and stamps need a trusted catalog. Six compounds and eight providers are enough to prove search, chips, and comparison. They are not enough to fake a national index. Grow the JSON in the same shape. Do not wait for forty compounds before search works.

### Why this is second

PRD goals 3 and 4: SAHPRA, WADA/SAIDS, evidence grade, provider type, and last-checked dates sit on the same page as the compound. Search must work for aliases, brands, and misspellings. Phase 1 stores those fields and already lists the stored grade on the index (F-2). Phase 2 makes the flags usable and adds the F-8 card stamp.

### In scope

- **F-5.** Index chips for route, form, class, and provider type. Empty results say so. Default sort is not cheapest first. Injectable covers both stored injection routes.
- **F-6.** Search normalises hyphens, spaces, and case. Known aliases and brands resolve. Unknown strings return no match plus a way to report a missing alias. Search must not invent a compound.
- **F-7.** SAHPRA block: registered yes/no/unknown, registration numbers if any, schedule if known, on the unregistered warning list, dated notes, link to the SAHPRA public page. No traffic-light “legal to buy”. “This is not legal advice” sits with the flags.
- **F-8.** Card-level stamp on top of the grade already listed on the Phase 1 index (F-2). Grade on the card, not only as a list fact or footnote. Citations with the stamp. No fifth “promising” grade. Human review can block grade inflation before publish. This is extra chrome. It is not the first time the grade appears.
- **F-9.** Filter by provider type. Comparison table: form, route, ZAR as-of, ships-from (ZA vs abroad), cold-chain. Type is a classification, not a “verified seller” or “recommended” badge. Default sort may prefer documented pharmacies over unknown. It must not say “safe”.
- **F-10.** WADA flag, class, list year, one-line note, and official link high on the compound page. SAIDS named as the local code signatory. No “can I compete this weekend?” wizard.
- **F-11.** “Provider states a COA” with URL and date. No hosted PDFs. No purity score.
- **F-12.** “Checked YYYY-MM-DD” on compounds, providers, listings, and legal blocks. UI marks “needs review” when the review date is older than 90 days. The date is not a live scrape clock.
- **F-13.** One primary class plus optional tags, already stored in Phase 1. Filter chips land with F-5. No 40-node ontology.

### Why not Phase 1

A SAHPRA stamp on one compound is cheap. A consistent stamp language across the catalog is the work. Doing it after import exists means the UI reads JSON instead of inventing a parallel content model. The index already lists the stored grade in Phase 1; this phase is the card stamp plus the other flags.

### Exit criteria

You can now:

1. Type `BPC157`, `bpc 157`, or `body protection compound` and reach BPC-157.
2. Filter to nasal nootropics, or to injectable peptides from compounding pharmacies, and get an honest empty state when nothing matches.
3. See SAHPRA, WADA/SAIDS, the evidence-grade card stamp, and last-checked date on the same compound page.
4. Compare form, route, and ZAR as-of across providers without a shop sort or a recommended-seller badge.
5. Read “provider states a COA” and not a hosted purity claim.
6. Spot a fact that is older than 90 days as “needs review”.

---

## Phase 3. Offline catalog and the research loop

**Effort:** ~1–2 weekends.
**Goal:** The catalog is usable on a phone with poor data, and the curator has a written loop that keeps JSON honest.

This lands after Phase 2 because caching a catalog that cannot be searched or judged is not more useful offline. Device-local saves wait until there is something worth saving.

### Why this is third

PWA stubs already exist in the Rails scaffold (`app/views/pwa/manifest.json.erb`, `app/views/pwa/service-worker.js`) with routes commented. Turning them on is P1, not the first useful slice. The Grok loop (F-17) is documented from a working schema check and a real first drop, not written as a wish.

### In scope

- **F-15.** Installable PWA. Offline browse of compound and provider pages. Stale banner. No web push. No offline accounts.
- **F-16.** Save and unsave compounds on this device. Survives refresh until site data is cleared. No server table. Password tooling stays unused.
- **F-17.** Catalog readme states the loop: copy a template, keep keys, add at least one source row, set the review date to the day the URL was opened, run schema validation, do not merge on failure. Compound summary cannot cite vendor-only sources. No live scrape farm. No bulk PMC download. No Examine.com scrape.

### Why not earlier

Phase 1 already fails CI on invalid JSON (F-1). F-17 is the human-readable loop around that gate. Writing it after the first drop exists keeps the README true.

### Exit criteria

You can now:

1. Install the catalog on a phone home screen and read cached compound and provider pages with the network off, and see that the copy may be stale.
2. Save a compound on one device without creating an account, and see it after refresh.
3. Follow the catalog readme to add a compound: template, citations, dates, schema check, no database write by the agent.
4. Watch CI reject a file with no review date or empty sources.

---

## Phase 4. Stacks

**Effort:** ~2 weekends.
**Goal:** A researcher can pick catalog compounds and see catalog-derived notes, plus named conventions such as “Wolverine”, without a personal recommendation.

**Stack checker lands after the catalog is trusted.** Pair notes and WADA rollup are only honest if class, routes, and flags are already on the compound pages (Phases 1 to 2) and the research loop can cite them (Phase 3). Do not ship stack UI on an empty stacks folder.

This phase is EP-08 stories for F-18, F-19, and F-21. F-20 stays in EP-08 and is not started here. Closing this phase does not require EP-08 to be finished.

### Why this is fourth

PRD F-18 is P2 UI with schema in F-1. Ideation scored the checker as later. A stack page that says “safe to combine” is a clinic. This phase must not become that.

### In scope

- **F-18.** Pick two or more catalog compounds. Show same-class twice, route clash, known pair notes, and WADA rollup. If any member is prohibited, the stack is prohibited for tested athletes. Rules are data. Sources show. Disclaimer repeats. No ingest of the person’s other medicines. Copy is not “safe to combine”.
- **F-19.** Named stacks (origin vendor-named or commonly reported). Member compound ids must exist. Nickname is an alias. Search “Wolverine” or “CJC-1295 + Ipamorelin” reaches a catalog record. No “suggested for you” or “best for injury”. If a named stack fails the checker, do not publish it.
- **F-21.** Pair notes appear only inside the stack checker. Each note has a source. Not a general drug-interaction engine (no warfarin, SSRIs, metformin, alcohol). Melanotan II sun-exposure stays a research note, not a beach guide.

### Out of scope here

F-20 reconstitution arithmetic helper. It stays in EP-08 and waits for Phase 5. Do not pull it forward to close this phase.

### Why F-19 is not before F-18

A named stack without a checker is a vendor slogan on our domain. Ship the checker first. Then publish only stacks that pass it.

### Exit criteria

You can now:

1. Build a stack from catalog compounds and see class overlap, route clash, pair notes, and WADA rollup, with sources.
2. Open a named stack page that lists members and rolls up legal and WADA flags from F-18.
3. Fail to publish a named stack that the checker rejects.
4. Still not see medical advice, a dose, or a “best for injury” label.
5. Still not see an arithmetic helper. That waits for Phase 5.

---

## Phase 5. Later

**Effort:** later. Do not start on a weekend guess.
**Goal:** Returning researchers can sync saves, optional unit maths stays maths, and a native shell exists only after the PWA is real.

These wait because they change the product shape (accounts, App Store) or they look like dosing (reconstitution). They are in the PRD so the schema and scaffold do not pretend they will never exist.

F-20 is still EP-08. Closing Phase 4 does not require the helper. Do not treat EP-08 as unfinished work that blocks this phase from starting.

### In scope

- **F-20.** Reconstitution arithmetic helper (EP-08 stories, not a new epic). User types vial milligrams, diluent millilitres, and syringe units. Output is mcg per unit. Title states: research arithmetic, not a dose, not a protocol. Reported protocols must not pre-fill the helper. No body weight, no indication, no injection-site diagram, no vendor BAC-water link.
- **F-22.** Magic-link accounts. Saved compounds and stacks sync across devices. Browse still works logged out. No social login required. Do not sell the list. Password tooling only if passwords are chosen later.
- **F-23.** Thin native wrapper around the same catalog. Do not start iOS or Android while PWA routes are still commented or the service worker is still a no-op. Wrapper does not add checkout, push spam, or clinic features.

### Why these are last

- **F-20 after F-14 is proven.** Readers already risk treating cited protocols as instructions (PRD risk 2). A helper that pre-fills amounts would confirm that fear. It waits until disclaimer language is in use and still does not read protocol defaults. It does not move into Phase 4 with the stack checker.
- **F-22 after F-16.** Device-local saves prove the need. Accounts are for sync, not for locking the catalog behind a login.
- **F-23 after F-15.** PRD acceptance: do not start native work while PWA is a stub.

### Exit criteria (when this phase is chosen)

You can now:

1. Sign in with a magic link and see the same saved compounds and stacks on a second device, while browse still works logged out.
2. Type vial, diluent, and syringe numbers and see mcg per unit, with no peptide-specific default and no dose language.
3. Open a native shell that shows the same catalog as the PWA, with no extra shop or clinic features.

---

## What never joins a phase

Copied from the PRD non-goals table. If a later idea matches one of these, it is not a revisit. It is a no.

| Idea | Why never |
| --- | --- |
| Checkout, cart, payments, “order from this provider” | Pharmacy / shop |
| WhatsApp or email the seller to buy | Same as checkout |
| Live stock, restock alerts, “buy now” | Shop inventory |
| Clinic booking or telehealth | Clinic |
| Weight-based or indication-based dosing | Medical advice |
| Injection technique or reconstitution video as instruction | Medical instruction |
| AI protocol generator (“stack for fat loss”) | Clinic, plus hallucination |
| Full interaction checker against other medicines | Pharmacy product |
| User reviews of “it worked for my knee” | Efficacy claims |
| Affiliate ranking or “recommended seller” | Money changes the catalog |
| Hosting COA PDFs as proof of purity | Fake authority |
| Traffic-light “legal to buy in SA” | Intended use matters under the Medicines Act |
| Forum or comments as evidence | Citations stay in JSON |

Afrikaans and isiZulu are not a phase. English first. Keep UI strings out of application code so translation stays possible when that ask is real.

---

## Dependencies (why the order is this order)

```
Phase 1  JSON + pages + disclaimer
    │
    ▼
Phase 2  Search, filters, stamps, comparison
    │
    ▼
Phase 3  PWA + local saves + documented research loop
    │
    ▼
Phase 4  Stack checker, then named stacks + pair notes
    │         (EP-08 stack stories only; F-20 waits)
    ▼
Phase 5  Accounts, reconstitution helper, native wrapper
```

- Search without records invents nothing useful (F-6 after F-2).
- Stamps without import invent a second content model (F-7 to F-12 after F-1).
- The F-8 card stamp waits for Phase 2. The index already lists the stored grade in Phase 1 (F-2).
- Offline cache of an unsearchable catalog is not more useful (F-15 after Phase 2).
- Stack checker without trusted class, routes, and WADA is guesswork (F-18 after Phases 1 to 3).
- Named stacks without a checker are vendor slogans (F-19 after F-18).
- Native wrapper without a working PWA is a second content store (F-23 after F-15).
- Reconstitution helper without a proven disclaimer looks like a dose (F-20 after F-14, in Phase 5). It stays in EP-08. Phase 4 can close without it. EP-08 does not have to finish before Phase 5 starts.

---

## Constraints that apply to every phase

- **App:** Rails 8, Hotwire, Tailwind, PostgreSQL, Solid Stack. Module `PeptidesResearchSouthAfrica`.
- **Money:** Phase 1 to 3 must ship with zero external paid keys. Public regulator and vendor pages may be read during research. Live scrape in the app is not in any phase on this roadmap.
- **Auth:** No accounts until F-22. Password tooling stays unused until that phase needs it.
- **Language:** English UI first. Strings stay out of application code.
- **Legal posture:** Informational catalog. Research storefronts stay labelled as unregistered supply paths where that is the fact. “Research use only” on a vendor site is a commercial phrase, not a SAHPRA exemption.
- **Hosting / Kamal:** Out of scope for this roadmap (also out of scope for the PRD).

---

## Revisit triggers

Change the order or the contents of a later phase only when one of these happens. Do not add calendar dates because a trigger fired. Update this table in the same change as the phase text.

| Trigger | What to revisit |
| --- | --- |
| Public name chosen (PeptideSA, SourceSA, Compound Index, or other) | UI strings and this file’s working-name line. Repo name can stay. |
| Comp Pharm public peptide table confirmed as script vs open order | Provider prescription flag and F-9 default sort. Do not guess. |
| RPSA city and SKUs confirmed | Add as a ninth provider in the catalog drop, still Phase 1 shape. |
| BioPeptics, The Clinic, or AlphaHuman city confirmed | Patch provider JSON. No phase change. |
| Alchemi, Fagron, or Lycoderm grow a public peptide SKU list | Catalog as providers with products, or keep as infrastructure with no products. Still F-3, not a new phase. |
| SAHPRA peptide warning list or register changes | Refresh F-7 notes and maybe add compounds. Do not add a traffic-light. |
| WADA prohibited list year changes | Refresh F-10 (list year, class codes). Stack rollup in F-18 follows. |
| Catalog grows past the starter six compounds and search is painful while still in Phase 1 | Pull F-6 forward. Do not skip F-1 to F-4. |
| Readers treat reported protocols as instructions | Tighten F-14 copy. Delay F-20 further. Do not add a calculator early. |
| Athletes miss the WADA flag in testing | Move F-10 copy higher. Do not add a “can I compete?” wizard. |
| Grade inflation shows up in agent drafts | Keep four grades. Require a human pass before publish (F-8). |
| COA URLs go dead or look fake | Keep “provider states a COA”. Still never host PDFs. |
| Curator time cannot cover 20 to 40 honest citations | Stay on the starter six until citations exist. Do not bulk-scrape PMC or Examine. |
| Examine.com terms become readable | Still link-out only unless the terms allow more. Do not copy prose. |
| Demand for Afrikaans or isiZulu | Not a new phase until the English catalog is stable. Strings are already out of application code. |
| Pressure to add checkout, WhatsApp order, or “recommended seller” | Point at the never table. Not a trigger to add a shop phase. |
| App Store or Play Store pressure before the PWA works | Refuse F-23 until F-15 exit criteria pass. |
| Affiliate or paid-ranking offer | Disclose links later if they exist. Never sell sort order. Not a phase. |
| Paid search or scrape API looks tempting | Reject for Phases 1 to 3. Research remains public pages plus JSON. |
| Accounts demanded before local saves exist | Keep F-16 in Phase 3. F-22 stays Phase 5. |
| Named vendor stacks (“Wolverine”) appear in SA shops before F-18 | Record them as product blends in F-4. Do not publish stacks UI yet. |
| Pressure to ship the arithmetic helper with the stack checker | Refuse. F-20 stays Phase 5. EP-08 stack stories can finish without it. |

Open questions from scout §5 stay open until answered. They do not create extra phases.

---

## Changelog

- 2026-08-25: Consistency pass. Linked EPICS.md. F-8 is Phase 2 card-stamp chrome; Phase 1 index already lists the stored grade (F-2). F-20 stays in EP-08 and in Phase 5; Phase 4 can close without it. Feature index now names the primary epic.
- 2026-08-25: First roadmap. Five phases from P0 catalog to P2 accounts. F-1 to F-23 mapped. Stack checker after a trusted catalog. Phase 1 has no paid APIs and no accounts.
