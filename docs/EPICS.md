# Epics: peptides research South Africa

**Source:** [PRD](PRD.md) (2026-08-25). Phase order: [ROADMAP](ROADMAP.md).
**Status:** First epics. This document plans work. It does not claim the app already ships these features.
**Sizing:** S = half a day or less. M = 1 to 2 days. L = 3 or more days. Solo-dev estimates.

The Rails app skeleton exists. Schema files and copy-from templates exist under the catalog folder. The catalog does not: there are no compound, provider, or product records on disk yet.

Epics follow a rough build order. Foundation is first. Every PRD feature (F-1 to F-23) maps to exactly one primary epic and to at least one phase. See the coverage table at the end.

This is a research catalog. It is not a clinic. It is not a pharmacy. No epic may add checkout, order buttons, live stock, clinic booking, dosing advice, or a traffic-light "legal to buy" mark.

---

## EP-01 · Foundation

**What.** The groundwork the catalog stands on. The app skeleton already exists. This epic adds the catalog file layout, the rules each record must pass, a load path into the site database, a merge check that rejects bad files, and a shared disclaimer on every catalog screen.

**Why.** Agents and humans will edit facts in git. The site must not drift from those files. Invalid records must not merge. Visitors must see, on the first screen, that this site is not medical advice and not legal advice.

**How.** Add one folder tree for catalog files, with a short readme, copy-from templates, and a rules file per record type (compound, provider, product, stack, and shared source). Stacks stay empty except a placeholder. Load only valid files into the site database. Agents never write the database. Fail the merge check on invalid files, a missing review date, or empty sources. Show the same disclaimer on compound, provider, product, and later stack views, above the fold on compound and stack views. Keep English interface text out of application code so later translation stays possible.

**PRD features covered:** F-1 (JSON catalog as source of truth), F-14 (site-wide informational disclaimer).

**Stories**

1. Create the catalog folder layout, a short readme, copy-from templates, and an empty stacks placeholder — **S**
2. Write validation rules for sources, compounds, providers, products, and stacks, including shared fields (id, schema version, review date, reviewer, sources, confidence) — **L**
3. Load valid catalog files into the site database; skip rumour records unless a documented curator override exists — **M**
4. Fail the merge check when a file is invalid, the review date is missing, or sources are empty — **M**
5. Add catalog navigation with honest empty states for compounds, providers, and later stacks — **M**
6. Show the shared disclaimer on every catalog view: not medical advice, not legal advice, not an instruction to buy or use, not an endorsement of any provider — **S**
7. Keep interface strings out of application code (English first) — **S**
8. Link the SAHPRA public peptide page from the disclaimer; do not treat the disclaimer as a licence to give a protocol — **S**

**Dependencies:** none (first). The app skeleton is already generated.
**Definition of done:** A valid sample file loads into the database. An invalid file, a missing date, or empty sources fails the merge check. Every catalog screen shows the disclaimer. Stacks have a schema and an empty folder only. Price never lives on a compound file. No feature UI beyond placeholders and the disclaimer.
**Out of scope:** Real compound or provider research (EP-02, EP-03, EP-07). Search (EP-05). Offline install (EP-06). Auth. Hosting and deploy. Afrikaans or isiZulu.

---

## EP-02 · Compound catalog

**What.** A person in South Africa opens a compound list and a compound page. Each page says what the compound is, its class, its routes, and commonly reported research protocols. Amounts stay cited notes. The page is not a calculator.

**Why.** Those facts sit on vendor sites and overseas blogs today. A local catalog must say what a compound is without sounding like an advert. Listing a stored evidence grade on the index keeps the page honest. Extra stamp treatment on the card waits until a later phase.

**How.** Add one cited record per starter compound. The site shows an index (name, class, routes, and the stored evidence grade as a listed fact) and a detail page (summary, aliases, routes, forms, research uses, protocols). Label protocols **commonly reported research protocols**. Vendor pages cannot support the summary. Wikipedia is a jump-off only. Add a primary source before publish. Store four grades only: anecdotal, preclinical, early human, registered medicine. One primary class, optional tags. No fifth "promising" grade. No star rating of efficacy. Card-level stamp chrome is extra work in a later phase.

**PRD features covered:** F-2 (compound index and detail), F-8 (evidence grades; card stamp waits for Phase 2), F-13 (compound class taxonomy; filter chips are EP-05).

**Phase exception.** Compound pages and the stored grade on the index (F-2) land in Phase 1. The card-level evidence-grade stamp (F-8 extra chrome) is not started until Phase 2. Class is stored in Phase 1. Filter chips wait for EP-05. This epic does not have to finish before Phase 2 can start.

**Stories**

1. Show a compound index with name, class, routes, and evidence grade as a stored listed fact — **M**
2. Show a compound detail page with summary, aliases, routes, forms, and research uses — **M**
3. Render reported amounts as commonly reported research protocols, with citations; do not pre-fill a calculator — **S**
4. Store one primary class and optional tags (healing, GHRH, secretagogue, GLP-1 / metabolic, melanocortin, nootropic, copper, other) — **S**
5. Store one of four evidence grades on the record, with citations; reject a fifth grade in the rules. This story does not finish the card-level stamp — **S**
6. Add the starter compound set with literature citations: BPC-157, TB-500, Semax, Selank, GHK-Cu, Noopept — **L**
7. Reject vendor-only sources for compound summary and research uses — **S**
8. Show the shared disclaimer above the fold on every compound view (from EP-01) — **S**
9. Card-level evidence-grade stamp: grade on the card, not only as a list fact or footnote; citations with the stamp; no fifth "promising" grade; no star rating of efficacy — **M**. On `main` (plan 2026-08-30-003).

**Dependencies:** EP-01 (rules, load path, disclaimer, navigation).
**Definition of done:** Starter compounds appear on the index and detail pages. The index lists the stored evidence grade as a fact. Protocols are cited text, not a dose tool. Class is present for later filters and later stack checks. Empty catalog still shows an honest empty state. The card-level stamp is not done in the Phase 1 slice of this epic. This epic does not claim search or legal flags are done (EP-04, EP-05).
**Out of scope:** Search and misspellings (EP-05). SAHPRA and WADA flags (EP-04). Browse chips (EP-05). Stacks (EP-08). Arithmetic helper (Phase 5, still EP-08). F-8 card stamp waits for Phase 2.

---

## EP-03 · Providers and products

**What.** A person in South Africa sees who lists compounds locally, in what form and route, at what rand price as of a date. Each provider has a type: compounding pharmacy, clinic, research storefront, oral retailer, international, or unknown. Listings compare form, route, price date, origin, and cold-chain. There is no buy button.

**Why.** That comparison is the reason this product exists. A United States blog does not answer who ships in South Africa. Putting a research storefront next to a compounding pharmacy with no type is reckless.

**How.** Add provider records from the live first drop, then product rows only where a live page shows a form. Show type, city if known, website, listing posture, and prescription flag. Hide down and excluded providers from the public index. Research storefronts stay labelled as such. They are never presented as licensed medicines. A listing row names compound, provider, form, route, strength, pack, rand price, and the price date. A missing date on a non-null price is a bug. Login-gated prices store no price. COA copy is "provider states a COA" with a vendor URL and a date. Do not host files. Do not score purity.

**PRD features covered:** F-3 (provider index and detail), F-4 (product listings), F-9 (provider type taxonomy and comparison), F-11 (COA-stated flag).

**Phase exception.** Provider and product pages, including stored type and listing rows (F-3, F-4), land in Phase 1. The comparison table (F-9) and COA-stated flag UI (F-11) are not started until Phase 2. This epic does not have to finish before Phase 2 can start.

**Stories**

1. Show provider index and detail: type, city if known, website, listing posture, prescription flag, linked products — **M**
2. Label research storefronts as unregistered supply paths; never present them as licensed medicines — **S**
3. Hide status down and excluded from the public index — **S**
4. Show product listing rows: compound, provider, form, route, strength, pack, rand price, price date — **M**
5. Build the comparison table: form, route, rand as-of, ships-from (ZA vs abroad), cold-chain; no buy button; default sort is not cheapest first — **M**. On `main` (plan 2026-08-30-004).
6. Show "provider states a COA" with URL and date; do not host PDFs; do not say tested safe — **S**. On `main` (plan 2026-08-30-004).
7. Add starter providers seen live: Reschem, BioPeptics, Tetratide Labs, The Clinic, Comp Pharm, AlphaHuman, NeuroActive, PrimeSelf; add products only where form is visible — **L**
8. Store login-gated prices as no price, with a visible-without-login flag (The Clinic) — **S**

**Dependencies:** EP-01. Product rows need compound ids from EP-02 (those pages may still be stubs).
**Definition of done:** Starter providers appear. Type is on every provider. Comparison works without a shop sort or a buy path. Login-gated prices stay empty. COA is a stated-flag only. RPSA stays out until city and SKUs are confirmed. Takealot, Africa Peptide Guide, JCSG.org, BT BioLabs, PeptideLab/New Age Health, and iDexis / Sentra Pharmacy are not catalogued as sellers.
**Out of scope:** Checkout, WhatsApp order, live stock, restock alerts, affiliate ranking, "recommended seller". Alchemi, Fagron, and Lycoderm wait on the open question (providers with no public peptide list). Filter chips (EP-05).

---

## EP-04 · Legal and athlete flags

**What.** On the compound page, a reader sees the SAHPRA facts (registered or not, on the May 2026 public peptide warning or not) and, high on the page, whether WADA prohibits the substance. SAIDS is named as the local code signatory. The page says this is not legal advice.

**Why.** The May 2026 SAHPRA warning is the local context. A tested athlete in South Africa who misses a WADA flag can be banned. A green "legal to buy" badge would be a lie. Intended use matters under the Medicines Act.

**How.** Store dated SAHPRA and WADA notes on the compound record. Show registered yes / no / unknown, registration numbers if any, schedule if known (blank is allowed), and whether the compound is on the unregistered warning list. Link the official SAHPRA page. On non-SA shippers, state that prior SAHPRA authorisation is the stated rule for personal import of unregistered medicines. That sentence is not permission. Show WADA flag, class, list year, one-line note, and the official list link. Do not build a "can I compete this weekend?" wizard.

**PRD features covered:** F-7 (legal and regulatory flags), F-10 (WADA / SAIDS flag).

**Stories**

1. Show SAHPRA registered yes / no / unknown, registration numbers if any, and schedule if known — **M**
2. Flag compounds on the May 2026 unregistered peptide warning list, with dated notes and a link to the SAHPRA public page — **S**
3. Repeat "this is not legal advice" with the flags — **S**
4. On non-SA shippers, state the prior-authorisation rule for personal import; do not frame it as permission — **S**
5. Show the WADA flag, class, list year, one-line note, and official link high on the compound page — **M**
6. Name SAIDS as the local code signatory — **S**
7. Allow legal and athlete blocks to carry their own review date when those facts were checked on a different day — **S**

**Dependencies:** EP-02 (compound page).
**Definition of done:** Starter compounds that SAHPRA named in the 2026 warning show that flag. BPC-157 shows WADA S0. TB-500 / thymosin-β4 shows S2.3. No traffic-light "legal to buy". No compete-this-weekend wizard. Disclaimer remains visible.
**Out of scope:** Legal advice. Stack rollup of WADA (EP-08). Last-checked stamps and the 90-day "needs review" mark (EP-05).

---

## EP-05 · Search, browse, last-verified

**What.** A visitor filters the catalog by route, form, class, and provider type. They type an alias, a brand, or a misspelling and still reach the compound. Every compound, provider, listing, and legal block shows a "Checked" date. Old facts show "needs review".

**Why.** Without filters, the catalog is a wall of pages. Without alias search, a first visit looks empty. Without dates, prices and legal flags become folklore.

**How.** Index chips cover route (injectable, nasal, oral, topical), form, class, and provider type. Injectable covers both stored injection routes. Empty results say the result is empty. Default sort is not cheapest first. Search normalises hyphens, spaces, and case. Known aliases and brands resolve. An unknown string returns no match plus a way to report a missing alias. Search must not invent a compound. Show the review date, not a live scrape clock. Mark a fact "needs review" when that date is older than 90 days. Touch the date only when the cited URL was opened in that session.

**PRD features covered:** F-5 (browse and filter), F-6 (alias and misspelling search), F-12 (last-verified stamps).

**Stories**

1. Filter the catalog by route, form, class, and provider type; empty results state that fact — **M**
2. Treat injectable as covering both stored injection routes — **S**
3. Keep default sort off "cheapest first"; type may prefer documented pharmacies over unknown, and must not say "safe" — **S**
4. Search by alias, brand, and misspelling; normalise hyphens, spaces, and case — **M**
5. On unknown strings, return no match plus a way to report a missing alias; never invent a compound — **S**
6. Show "Checked YYYY-MM-DD" on compounds, providers, listings, and legal blocks — **S**
7. Mark "needs review" when the review date is older than 90 days — **S**
8. Map registered-medicine brand names to the international name, labelled brand vs research name — **S**

**Dependencies:** EP-02 (class, aliases, compound pages), EP-03 (provider type, listings), EP-04 (legal blocks to stamp). Merge-check for missing dates is already EP-01.
**Definition of done:** Filters work. `BPC157`, `bpc 157`, and a known brand reach the compound. Unknown input does not invent a row. Dates show. Facts older than 90 days show "needs review". No live scrape clock.
**Out of scope:** Live vendor scrape. Fuzzy search that guesses a compound. Offline cache (EP-06). Evidence-grade card stamp (EP-02, Phase 2).

---

## EP-06 · PWA and device-local saves

**What.** A person on mobile data in South Africa installs the catalog on the home screen, reads cached compound and provider pages when the network drops, and saves compounds on this device without an account.

**Why.** Mobile data drops. People will open a compound page in a queue or a waiting room. An empty heart icon with no local save is theatre. Accounts can wait until the catalog is trusted.

**How.** Turn on the installable app. Cache compound and provider pages. When offline, show a banner that the copy is cached and may be stale. Leave web push off. Save and unsave compounds on the device only. The list survives refresh. Clearing site data loses the list. Browse does not require an account. No social login. No profiles.

**PRD features covered:** F-15 (PWA offline catalog), F-16 (device-local saved compounds).

**Stories**

1. Enable the installable home-screen app (manifest and service worker routes) — **S**
2. Cache compound and provider pages for offline browse — **M**
3. Show a "cached, may be stale" banner when the network is down — **S**
4. Save and unsave compounds on this device; survive refresh — **M**
5. Confirm that clearing site data loses the list, and that browse still works with no account — **S**
6. Leave web push commented / off — **S**

**Dependencies:** EP-02 and EP-03 (pages to cache and save). Better after EP-05 so cached browse includes filters, but not required.
**Definition of done:** The app is installable. Offline browse of compound and provider pages works with a stale banner. Local save works without an account. No push. No server table for saves. Password tooling stays unused.
**Out of scope:** Offline accounts. Synced saves (EP-09). Native iOS or Android shell (EP-09). Push alerts. Saved stacks (later, with EP-08).

---

## EP-07 · Agent research workflow

**What.** David, as curator, follows a written loop so Grok and other agents add or refresh catalog files with citations and dates. A check rejects invalid files. There is no live scrape farm.

**Why.** There is no local catalog to import. The first 20 to 40 compounds need honest citations. Agents must not guess, inflate grades, or copy vendor dosing as truth. A written loop is how the catalog stays an audit trail in git.

**How.** Document the loop in the catalog readme: copy a template, keep keys, add at least one source, set the review date to the day the URL was opened, run the schema check, do not merge on failure. Compound summary cannot cite vendor-only sources. Wikipedia needs a primary source before publish. No bulk PMC download. No Examine.com scrape (link-out only). A human review pass can block grade inflation. The first drop order stays the scout list already used in EP-02 and EP-03.

**PRD features covered:** F-17 (agent research workflow documented).

**Stories**

1. Write the catalog readme: copy a template, keep keys, add sources, set the date to the day the URL was opened, run the check — **M**
2. Document citation rules: compound summary needs regulator or literature sources; vendor URLs are for products only — **S**
3. Document the first-drop order and the "open the URL in session, do not guess" rule — **S**
4. State the bans: no live scrape farm, no bulk PMC download, no Examine.com scrape — **S**
5. Add a human review pass for evidence grades before publish — **M**
6. Confirm the merge check from EP-01 is the gate this loop points at — **S**

**Dependencies:** EP-01 (rules, templates, merge check). Can run in parallel with EP-02 and EP-03. Should exist before a large agent write.
**Definition of done:** A new agent can add a compound from the readme alone. Invalid JSON, missing date, or empty sources fail the check. Vendor-only summaries are documented as invalid. No scrape farm is in the repo.
**Out of scope:** Building the compound UI (EP-02). Hosting COA files. Paid ranking. Translations.

---

## EP-08 · Stacks and research arithmetic (later)

**What.** Later, a researcher picks two or more catalog compounds and sees catalog-derived notes: same class twice, a route clash, a known pair note, and a WADA rollup. Named stacks such as "Wolverine" are catalog records of a convention, not a personal recommendation. A labelled arithmetic helper converts vial, diluent, and syringe units the person types. It does not choose a dose.

**Why.** Community names and pairings exist. A checker on an empty catalog is a toy. A calculator next to an injectable peptide looks like a clinic if it ships before the catalog is trusted. Schema for stacks already lands in EP-01 so this pass does not rewrite files.

**How.** Rules are data. Sources show. The disclaimer repeats. If any stack member is WADA-prohibited, the stack is prohibited for tested athletes. Do not ingest the person's other medicines. Do not say "safe to combine". Ship named stacks after the checker. If a named stack fails the checker, do not publish it. Pair notes appear only inside the checker. The arithmetic helper never reads protocol defaults, body weight, or indication. Title it as research arithmetic, not a dose, not a protocol.

**PRD features covered:** F-18 (stack checker), F-19 (named suggested stacks), F-20 (reconstitution arithmetic helper), F-21 (curated pair notes UI).

**Phase exception.** Stack checker, named stacks, and pair notes (F-18, F-19, F-21) land in Phase 4. The arithmetic helper (F-20) stays in this epic and is not started until Phase 5. Phase 4 can close without this epic being finished. Do not move F-20 into Phase 4.

**Stories**

1. Build the stack checker from catalog data: class overlap, route clash, known pair notes, WADA rollup — **L**
2. Repeat the disclaimer; never say "safe to combine"; do not ingest other medicines — **S**
3. Publish named stacks as records of a convention, with nickname search (example: Wolverine, CJC-1295 + Ipamorelin) — **M**
4. Block publish when a named stack fails the checker; roll up legal and WADA flags from members — **S**
5. Show pair notes only inside the checker, each with a source (not a general drug-interaction engine) — **M**
6. Add a labelled arithmetic helper: vial milligrams, diluent millilitres, and syringe units in; amount per unit out — **M**. Not started until Phase 5.
7. Do not pre-fill the helper from reported protocols; no body weight, no indication, no injection-site diagram, no vendor water link — **S**. Not started until Phase 5.

**Dependencies:** EP-01 (stack schema). EP-02 (class, routes, pair-note fields). EP-04 (WADA). Do not ship UI on an empty catalog. Named stacks ship after the checker. Arithmetic helper waits for Phase 5 and does not block Phase 4.
**Definition of done:** Checker notes are sourced and catalog-derived. Named stacks are conventions with rollups. Pair notes have no second UI. Disclaimer is above the fold on stack views. Arithmetic helper is out of the Phase 4 done line; it waits for Phase 5.
**Out of scope:** "Stack for fat loss" generators. Weight-based dosing. Full interaction check against warfarin, SSRIs, metformin, alcohol. User-saved stacks in the catalog files (those wait for accounts in EP-09). Shipping the arithmetic helper in Phase 4.

---

## EP-09 · Accounts and native wrapper (later)

**What.** Later, a returning researcher signs in with a magic link and sees the same saved compounds and stacks on another device. Later still, a thin native phone shell wraps the same catalog, only after the installable offline app already works.

**Why.** Device-local saves (EP-06) are enough until the catalog is trusted. A native app before offline browse works is a fake shell. Browse must still work logged out.

**How.** Magic link is enough. Saved stacks live in the site database after accounts exist. The JSON catalog remains the research source of truth. Do not sell the list. Do not require social login. Do not start iOS or Android while the home-screen app is still a no-op. The wrapper does not add checkout, push spam, or clinic features.

**PRD features covered:** F-22 (accounts and synced saved research or stacks), F-23 (native mobile wrapper).

**Stories**

1. Add magic-link sign-in; browse still works logged out — **L**
2. Sync saved compounds and stacks across devices; do not sell the list — **M**
3. Keep social login optional-off; do not require a profile to read the catalog — **S**
4. Start a thin native wrapper only after EP-06 is installable and offline — **L**
5. Confirm the wrapper uses the same catalog and adds no checkout, push spam, or clinic features — **S**

**Dependencies:** EP-06 before the native wrapper. EP-08 stack UI (Phase 4) before synced stacks are meaningful. Device-local saves in EP-06 stay as the no-account path. F-20 is not a dependency of this epic.
**Definition of done:** Magic link restores saves on a second device. Logged-out browse still works. Native work has not started while offline install is incomplete. Password tooling is in scope only if passwords are chosen later.
**Out of scope:** Social graphs. "Follow a researcher". Push spam. Clinic booking. Any shop feature. Starting native work on a commented-out service worker.

---

## Coverage table

Every PRD feature has exactly one primary epic and at least one phase. Phase numbers follow [ROADMAP](ROADMAP.md).

| Feature | Title | Priority | Primary epic | Lands |
| --- | --- | --- | --- | --- |
| F-1 | JSON catalog as source of truth | P0 | EP-01 Foundation | Phase 1 |
| F-2 | Compound index and detail | P0 | EP-02 Compound catalog | Phase 1 |
| F-3 | Provider index and detail (SA-first) | P0 | EP-03 Providers and products | Phase 1 |
| F-4 | Product listings (compound × provider × form) | P0 | EP-03 Providers and products | Phase 1 |
| F-5 | Browse and filter by route, form, class, and provider type | P0 | EP-05 Search, browse, last-verified | Phase 2 |
| F-6 | Alias and misspelling search | P0 | EP-05 Search, browse, last-verified | Phase 2 |
| F-7 | Legal and regulatory flags (SAHPRA) | P0 | EP-04 Legal and athlete flags | Phase 2 |
| F-8 | Evidence grades | P0 | EP-02 Compound catalog | Phase 2 |
| F-9 | Provider type taxonomy and comparison rows | P0 | EP-03 Providers and products | Phase 2 |
| F-10 | WADA / SAIDS flag | P0 | EP-04 Legal and athlete flags | Phase 2 |
| F-11 | COA-stated flag | P0 | EP-03 Providers and products | Phase 2 |
| F-12 | Last-verified stamps | P0 | EP-05 Search, browse, last-verified | Phase 2 |
| F-13 | Compound class taxonomy | P0 | EP-02 Compound catalog | Phase 2 |
| F-14 | Site-wide informational disclaimer | P0 | EP-01 Foundation | Phase 1 |
| F-15 | PWA offline catalog | P1 | EP-06 PWA and device-local saves | Phase 3 |
| F-16 | Device-local saved compounds | P1 | EP-06 PWA and device-local saves | Phase 3 |
| F-17 | Agent research workflow documented | P1 | EP-07 Agent research workflow | Phase 3 |
| F-18 | Stack checker (schema now) | P2 | EP-08 Stacks and research arithmetic | Phase 4 |
| F-19 | Named suggested stacks | P2 | EP-08 Stacks and research arithmetic | Phase 4 |
| F-20 | Reconstitution arithmetic helper | P2 | EP-08 Stacks and research arithmetic | Phase 5 |
| F-21 | Curated pair notes UI | P2 | EP-08 Stacks and research arithmetic | Phase 4 |
| F-22 | Accounts and synced saved research or stacks | P2 | EP-09 Accounts and native wrapper | Phase 5 |
| F-23 | Native mobile wrapper | P2 | EP-09 Accounts and native wrapper | Phase 5 |

Count: F-1 to F-23 appear once. No feature is unassigned. No feature has two primary epics. No P0 feature lands only in Phase 5.

Schema-only stack files in F-1 stay in EP-01. The stack UI is EP-08.

**F-8 split.** Primary epic stays EP-02. Phase 1 lists the stored grade on the index (F-2 acceptance). Phase 2 is the card-level stamp (extra chrome). Story 9 is that stamp. Story 5 does not finish F-8.

**F-20 split.** Primary epic stays EP-08. It lands in Phase 5. EP-08 stack stories (F-18, F-19, F-21) can finish in Phase 4. EP-08 as a whole is not a gate before Phase 5.

---

## Build order

1. EP-01 Foundation.
2. EP-02 Compound catalog and EP-03 Providers and products (starter records plus pages). F-8 card stamp in EP-02 waits for Phase 2.
3. EP-04 Legal and athlete flags on those compound pages.
4. EP-05 Search, browse, last-verified. EP-02 story 9 (F-8 card stamp) can land in the same phase.
5. EP-07 Agent research workflow (after EP-01; in parallel with 2 to 4 is fine; needed before a large agent write).
6. EP-06 PWA and device-local saves (P1, after catalog pages exist).
7. EP-08 stack checker, named stacks, and pair notes (Phase 4, after a trusted catalog). Arithmetic helper in the same epic waits for Phase 5.
8. EP-09 Accounts and native wrapper (P2; native after EP-06). F-20 may run in the same later window as EP-09; it does not belong to EP-09.

---

## Shared out of scope (never)

Copied from the PRD non-goals. Do not put these on any epic.

- Checkout, cart, payments, "order from this provider"
- WhatsApp or email the seller to buy
- Live stock, restock alerts, "buy now"
- Clinic booking, telehealth, "talk to a doctor"
- Weight-based or indication-based dosing
- Injection technique, site maps, reconstitution video as instruction
- AI protocol generator ("stack for fat loss")
- Full interaction checker against other medicines
- User reviews of "it worked for my knee"
- Affiliate ranking or "recommended seller"
- Hosting COA PDFs as proof of purity
- Traffic-light "legal to buy in SA"
- Forum or comments as evidence

Afrikaans and isiZulu are later, not a first-release goal.

---

## Changelog

- 2026-08-30: Comparison table (F-9) and COA-stated flag UI (F-11) landed on `main` (plan 2026-08-30-004).
- 2026-08-25: EP-03 phase exception: comparison table (F-9) and COA-stated flag UI (F-11) wait for Phase 2; provider and product pages stay Phase 1.
- 2026-08-25: Consistency pass. F-8 card stamp waits for Phase 2; index still lists the stored grade in Phase 1 (F-2). F-20 stays in EP-08 and is not started until Phase 5. Coverage table now includes phase. ROADMAP is linked. What/Why/How kept free of file paths.
- 2026-08-25: First epics. Nine epics from the PRD. Foundation first. Coverage table maps F-1 to F-23 each to one primary epic. Catalog is planned, not claimed as shipped.
