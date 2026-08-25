# Product requirements: peptides research South Africa

| Field | Value |
| --- | --- |
| Public name | TBD. Candidates: PeptideSA, SourceSA, Compound Index. Renaming later is cheap. |
| Working name | `peptides_research_south_africa` |
| Rails module | `PeptidesResearchSouthAfrica` |
| Owner | David Teren |
| Repo | Private GitHub: `davidteren/peptides_research_south_africa` |
| Date | 2026-08-25 |
| Status | First PRD. This document states requirements. It does not promise that the app already ships them. |

This is a research catalog. It is not a clinic. It is not a pharmacy.

---

## 1. Overview

**What.** A South Africa portal for people who research peptides, nootropics, and related compounds. It lists local providers. It lists compound types and routes (injectable, nasal, oral, topical). It says what each compound is. It records typical research use and frequency as cited notes. Later it lets people check or save stacks.

**Why.** The facts sit on vendor sites, forums, and overseas databases. People in South Africa cannot easily compare who sells what, in what form, or what a compound is. In May 2026 SAHPRA warned the public about unregistered peptide products. That warning is the local context. A United States blog does not answer it.

**How.** Structured JSON files come first. Grok and other agents research sources, write citations, and update those files. A Rails 8 app then presents the catalog (Hotwire, Solid Stack, PostgreSQL, PWA). Later: accounts, saved research, a stack checker, and suggested stacks.

Typical use text is descriptive and cited. The UI labels it **commonly reported research protocols**. It is not a dose. It is not a recommendation. Research-chemical storefronts are not licensed medicines. A vendor "research use only" label is a commercial phrase, not a SAHPRA exemption.

---

## 2. Goals and non-goals

### Goals

1. Give people in South Africa one honest catalog of compounds, forms, routes, and local providers.
2. Keep JSON in `data/` as the research source of truth. Rails imports that JSON into PostgreSQL for the site.
3. Show SAHPRA, WADA/SAIDS, evidence grade, provider type, and last-checked dates on the same page as the compound.
4. Make search work for aliases, brands, and common misspellings.
5. Stay informational. Never tell a person what to take, how much, or where to inject.

### Non-goals (never)

Copied from the ideation killed table. Do not put these on a roadmap.

| Idea | Why never |
| --- | --- |
| Checkout, cart, payments, "order from this provider" | Pharmacy / shop. The brief forbids it. |
| WhatsApp or email the seller to buy | Same as checkout, with extra legal risk. |
| Live stock, restock alerts, "buy now" | Shop inventory. This product does not run their warehouse. |
| Clinic booking, telehealth, "talk to a doctor" | Clinic. Out of scope for this product. |
| Weight-based or indication-based dosing | Medical advice. |
| Injection technique, site maps, reconstitution video as instruction | Medical instruction. |
| AI protocol generator ("stack for fat loss") | Clinic, plus hallucination. |
| Full interaction checker against other medicines | Pharmacy product. |
| User reviews of "it worked for my knee" | Efficacy claims by another name. |
| Affiliate ranking or "recommended seller" | Money changes the catalog. Disclose links later if they exist. Never sell sort order. |
| Hosting COA PDFs as proof of purity | Fake authority. |
| Traffic-light "legal to buy in SA" | Not true. Intended use matters under the Medicines Act. |
| Forum or comments as evidence | Unmoderated medical talk. Citations stay in JSON. |

Afrikaans and isiZulu are later, not a v1 goal. English first. Keep UI strings out of Ruby so translation stays possible.

---

## 3. User and context

**Primary user: a person in South Africa who is researching compounds and providers.** They want to know what a compound is, who lists it locally, in what form and route, and what regulators and anti-doping bodies already said. They may be an athlete, a clinic patient, or someone who found a vendor on social media. They are not asking this site for a prescription.

**Secondary user: David as curator, using Grok agents.** He does not type every PubMed row by hand. Agents fetch public pages, write JSON with citations and `last_reviewed_at`, and fail a check when the file is invalid. David reviews grades and legal notes so they do not inflate.

**Context, not catalog data.** Household notes mention nootropics as a spend line. That is personal context. Do not import it into public JSON. There is no existing compound catalog on this machine. The catalog starts from live SA pages plus official sources in the scout inventory.

---

## 4. Features

Priority: **P0** is the first useful catalog. **P1** is still first-release, after the catalog reads. **P2** is later. Schema-only items for later features live in P0 JSON so the next pass does not rewrite the files.

Each feature maps to a real source from `docs/research/scout-inventory.md`. The `data/` folder tree exists. Schemas and copy-from templates exist. Compound, provider, and product records do not. Paths below are that layout. Phase order is in `docs/ROADMAP.md`. Primary epic is in `docs/EPICS.md`.

### P0. Core catalog

#### F-1. JSON catalog as source of truth

**Priority:** P0

**User story.** As the curator, I keep compounds, providers, products, and later stacks as one JSON file per record, so agents can update facts in git and the site cannot drift.

**Data source.** Layout from scout §4.1, with shared source rules in `defs.schema.json` (scout named `source.schema.json`):

- `data/README.md`
- `data/schema/defs.schema.json`, `compound.schema.json`, `provider.schema.json`, `product.schema.json`, `stack.schema.json`
- `data/compounds/*.json`
- `data/providers/*.json`
- `data/products/*.json`
- `data/stacks/` (empty in v1 except `.gitkeep`)
- `data/_templates/*.json`

**Acceptance sketch.** One record per file. Required keys from the schema are present (`id`, `schema_version`, `last_reviewed_at`, `reviewer`, `sources` with at least one entry, `confidence`). Rails loads valid files into PostgreSQL. Invalid JSON or a failed schema check cannot merge. Agents do not write the database. `data/stacks/` exists with schema only. Price never lives on a compound file. Schema files on disk are not the catalog. Records still have to be written.

#### F-2. Compound index and detail

**Priority:** P0

**User story.** As a person in SA, I open a compound list and a detail page that says what the compound is, its class, routes, and commonly reported research protocols, with citations, not a calculator.

**Data source.** `data/compounds/{id}.json`. Identity and research notes cite PubMed (`https://pubmed.ncbi.nlm.nih.gov/`), PMC OA when the article is OA, SAHPRA (`https://www.sahpra.org.za/peptide-products-public-information/`), and the WADA 2026 list. Vendor pages are not enough for `summary` or `research_uses`. Starter set from scout §2.2 (examples): BPC-157, TB-500, Semax, Selank, GHK-Cu, Noopept.

**Acceptance sketch.** Index lists name, class, routes, evidence grade. That listed grade is the stored fact. The card-level stamp is F-8. Detail shows summary, aliases, routes, forms, research uses, and **commonly reported research protocols** from `reported_protocols`. Amount, frequency, and cycle stay cited text. They do not pre-fill a calculator. Wikipedia, if used, is `kind: encyclopedia` plus a primary source before publish.

#### F-3. Provider index and detail (SA-first)

**Priority:** P0

**User story.** As a person in SA, I see who lists compounds locally, where they ship from, and whether the public page is a research storefront, a compounding pharmacy, a clinic, or an oral retailer.

**Data source.** `data/providers/{id}.json` plus live homepages in scout §2.1. First drop (seen live on 2026-08-25): Reschem `https://reschem.co.za`, BioPeptics `https://biopeptics.co.za`, Tetratide Labs `https://www.tetratidelabs.co.za`, The Clinic `https://www.the-clinic.co.za`, Comp Pharm `https://comppharm.co.za/our-peptides-2/`, AlphaHuman `https://alphahuman.co.za/pages/peptides`, NeuroActive `https://neuroactive.co.za`, PrimeSelf `https://primeself.co.za`. RPSA (`https://researchpeptides.co.za`, `https://peptides.co.za`) is partial until city and SKUs are confirmed. Do not catalog Takealot, Africa Peptide Guide, JCSG.org, BT BioLabs, or PeptideLab/New Age Health (404). Do not list iDexis / Sentra Pharmacy as a seller (enforcement target, 2026-05-26).

**Acceptance sketch.** Provider page shows name, `kind`, city if known, website, listing posture, prescription flag, and linked products. Research storefronts are labelled as such. They are never presented as licensed medicines. Status `down` or `excluded` does not appear in the public index.

#### F-4. Product listings (compound × provider × form)

**Priority:** P0

**User story.** As a person in SA, I compare one compound across providers by form, route, pack, and ZAR price as of a date.

**Data source.** `data/products/{provider}-{compound}-{form}-{strength}.json`. Facts come from the vendor `product_url` only (scout §3.4). First products: SKUs with a live URL and a visible form. Login-gated prices (The Clinic) store `price_zar: null` and `price_visible_without_login: false`.

**Acceptance sketch.** A listing row names compound, provider, form, route, strength, pack, `price_zar`, and the price date. Missing date on a non-null price is a bug. No Buy button. No WhatsApp order. No live stock badge. Vendor marketing, if shown, is a short quote, never rewritten as efficacy.

#### F-5. Browse and filter by route, form, class, and provider type

**Priority:** P0

**User story.** As a person in SA, I filter the catalog to nasal nootropics, injectable peptides from compounding pharmacies, or oral capsules from retailers, without reading every page.

**Data source.** Compound `categories` / class and `routes_studied`. Product `form` and `route`. Provider `kind`. Enums in scout §3.2 to §3.4.

**Acceptance sketch.** Index chips cover route (injectable, nasal, oral, topical), form, class, and provider type. Empty result states that fact. Default sort is not cheapest first. Injectable covers `injectable_subq` and `injectable_im` as stored routes.

#### F-6. Alias and misspelling search **(extended)**

**Priority:** P0. Ideation #1.

**User story.** As a visitor, I type `BPC157`, `bpc 157`, `body protection compound`, `tb500`, or a brand such as Ozempic, and I still reach the compound.

**Data source.** `compounds[].aliases` (scout §3.2). Brand names of registered medicines map to the INN and are labelled brand vs research name. SAHPRA register: `https://www.sahpra.org.za/registered-health-products/`.

**Acceptance sketch.** Search normalises hyphens, spaces, and case. Known aliases and brands resolve. An unknown string returns no match plus a way to report a missing alias. Search must not invent a compound.

#### F-7. Legal and regulatory flags (SAHPRA) **(extended)**

**Priority:** P0. Ideation #2.

**User story.** As a person in SA, I see whether a compound is a registered medicine, whether it appears on SAHPRA’s May 2026 public peptide warning, and that this site is not legal advice.

**Data source.** `compounds[].sahpra` (scout §3.2). Primary page: `https://www.sahpra.org.za/peptide-products-public-information/`. Register search as above. Enforcement context: `https://www.sanews.gov.za/south-africa/authorities-crack-down-pretoria-weight-loss-production-pharmacy`. Named warning examples: BPC-157, TB-500, Melanotan II, CJC-1295, Ipamorelin, PT-141, AOD-9604, Selank, Semax.

**Acceptance sketch.** Compound page shows registered yes/no/unknown, registration numbers if any, schedule if known (null allowed), `on_unregistered_warning_list`, dated notes, and a link to the SAHPRA public page. No traffic-light "legal to buy". Personal import of unregistered medicines is flagged on non-SA shippers as "prior SAHPRA authorisation is the stated rule", not as permission. "This is not legal advice" sits with the flags.

#### F-8. Evidence grades **(extended)**

**Priority:** P0. Ideation #3.

**User story.** As a reader, I see one honest grade on the compound card so the page is not an advert.

**Data source.** Compound `evidence_grade` and `citations` / `research_uses[].sources`. Cite DOI or PMID from PubMed. Do not copy Examine.com prose (`https://examine.com` is link-out only; terms were bot-walled on 2026-08-25).

**Grades (four only):** `anecdotal` (forum and vendor talk), `preclinical` (animal or in-vitro papers), `early_human` (small or early human studies, not a registered indication), `registered_medicine` (SAHPRA-registered product for a named indication).

**Acceptance sketch.** Grade is visible on the card, not only in a footnote. Citations are listed. There is no fifth "promising" grade and no star rating of efficacy. A human review pass can block grade inflation before publish. The compound index already lists the stored grade as a fact (F-2). This feature is the card-level stamp and the four-grade gate, not the first time the grade appears.

#### F-9. Provider type taxonomy and comparison rows **(extended)**

**Priority:** P0. Ideation #4 and #5.

**User story.** As a person in SA, I can tell a compounding pharmacy from a research storefront from a clinic from an oral retailer, and I can compare form, route, ZAR as-of, origin, and cold-chain without a shop sort.

**Data source.** Provider `kind`, `listing_posture`, `prescription_required`, `city`, `country` (scout §3.3). Product comparison fields (scout §3.4, ideation listing shape): `form`, `route`, `price_zar`, price date, origin, `cold_chain`. Licensed compounding context: Fagron `https://fagron.co.za/quality/`, health licensing `https://www.health.gov.za/licensing-home/`.

**Provider `kind`:** `compounding_pharmacy`, `clinic`, `research_storefront`, `nootropic_retailer`, `international`, `unknown`. Do not publish `marketplace` or `b2b` as sellers. `listing_posture`: `research_use_only`, `compounded_on_script`, `food_supplement`, `clinic_protocol`, `unknown`.

**Acceptance sketch.** Type is on every provider. Filter by type works. Comparison table shows form, route, ZAR as-of, ships-from (ZA vs abroad, coarse region if known), cold-chain. Type is a classification, not a "verified seller" or "recommended" badge. Default sort may prefer documented pharmacies over `unknown`. It must not say "safe".

#### F-10. WADA / SAIDS flag **(extended)**

**Priority:** P0. Ideation #6.

**User story.** As a tested athlete in SA, I see high on the compound page whether WADA prohibits the substance, with class code and a link, and that SAIDS is the local code signatory.

**Data source.** `compounds[].wada`. WADA Prohibited List 2026: `https://www.wada-ama.org/en/prohibited-list` and PDF `https://www.wada-ama.org/sites/default/files/2025-09/2026list_en_final_clean_september_2025.pdf`. Scout facts: BPC-157 is S0; TB-500 / thymosin-β4 is S2.3; several GHRH analogues, secretagogues, AOD-9604, and MOTS-c are listed.

**Acceptance sketch.** Flag, class, list year, one-line note, and official link sit high on the page. No "can I compete this weekend?" wizard. If any stack member is prohibited, the stack (when F-18 exists) is prohibited for tested athletes.

#### F-11. COA-stated flag **(extended)**

**Priority:** P0. Ideation #7.

**User story.** As a reader, I see whether a provider states a third-party certificate, with a URL and a date, labelled only as "provider states a COA".

**Data source.** Product `coa_url` (scout §3.4) plus `coa_stated` and `coa_checked_on` on the listing. URL is the vendor’s own page or file link, not a file hosted here.

**Acceptance sketch.** UI copy is "provider states a COA". No hosted PDFs. No purity score. No "tested safe".

#### F-12. Last-verified stamps **(extended)**

**Priority:** P0. Ideation #9.

**User story.** As a reader, I see "Checked YYYY-MM-DD" on compounds, providers, listings, and legal blocks so I know when a human or agent last opened the source.

**Data source.** Record `last_reviewed_at`, `reviewer`, `sources[]` with `accessed_at` (scout §3.1 and §4.4). Nested `sahpra` and `wada` may carry their own `last_reviewed_at` when those facts were checked on a different day.

**Acceptance sketch.** UI shows the date, not a live scrape clock. An agent update with no date fails CI. UI marks a fact "needs review" when `last_reviewed_at` is older than 90 days. Touch the date only when the cited URL was opened in that session.

#### F-13. Compound class taxonomy **(extended)**

**Priority:** P0. Ideation #10.

**User story.** As a visitor, I browse by class (healing, GHRH, secretagogue, GLP-1 / metabolic, melanocortin, nootropic, copper, other) so the index is usable and a later stack checker can detect "two GLP-1s".

**Data source.** Compound `categories` (scout §3.2) and one primary `class` (ideation JSON). Values stay a short list. `other` plus a note is allowed.

**Acceptance sketch.** One primary class, optional tags. Filter chips on the index. No 40-node ontology. Stack pair notes may key off class later (F-18) without a schema rewrite.

#### F-14. Site-wide informational disclaimer

**Priority:** P0

**User story.** As a visitor, I see on every compound, provider, product, and later stack view that this site is not medical advice and not legal advice, and that it does not instruct use.

**Data source.** Site copy. Grounded in SAHPRA public wording (scout §2.3) and the ideation guardrails. Link the SAHPRA peptide page. Do not treat the disclaimer as a licence to give a protocol.

**Acceptance sketch.** Disclaimer is visible without scrolling past the fold on compound and stack views. It states: not medical advice, not legal advice, not an instruction to buy or use, not an endorsement of any provider. Research storefronts stay labelled as unregistered supply paths where that is the fact.

### P1. First-release extras

#### F-15. PWA offline catalog **(extended)**

**Priority:** P1. Ideation #8.

**User story.** As a person on mobile data in SA, I install the catalog on the home screen and read cached compound and provider pages when the network drops, with a stale banner.

**Data source.** Cached catalog pages plus JSON already loaded from `data/` through the app. Rails PWA stubs: `app/views/pwa/manifest.json.erb`, `app/views/pwa/service-worker.js`. Routes in `config/routes.rb` are commented (`manifest`, `service-worker`) and must be enabled for this feature.

**Acceptance sketch.** Installable. Offline browse of compound and provider pages works. Banner says the copy is cached and may be stale. No web push (leave the stub commented). No offline accounts.

#### F-16. Device-local saved compounds **(extended)**

**Priority:** P1. Ideation #11 (local only).

**User story.** As a visitor, I save compounds on this device without an account, and they survive refresh until I clear site data.

**Data source.** Browser `localStorage` or IndexedDB. No server table. `has_secure_password` stays commented in the Gemfile.

**Acceptance sketch.** Save and unsave compounds (stacks later) on one device. Browse does not require an account. Clearing site data loses the list. No social login, profiles, or "follow a researcher". An empty heart with no local save is not this feature.

#### F-17. Agent research workflow documented

**Priority:** P1

**User story.** As the curator, I follow a written loop so Grok (and other agents) add or refresh JSON with citations and dates, and CI rejects invalid files.

**Data source.** `data/README.md`, `data/schema/*`, `data/_templates/*`, scout §4 (add compound, add provider, citation rules, v1 load order). Compound knowledge table in scout §2.2.

**Acceptance sketch.** README states: copy a template, keep keys, add at least one `sources[]` row, set `last_reviewed_at` to the day the URL was opened, run schema validation (rake task), do not merge on failure. Compound summary cannot cite vendor-only sources. A check fails on invalid JSON, missing `last_reviewed_at`, or empty `sources`. No live scrape farm in v1. No bulk PMC download. No Examine.com scrape.

### P2. Later

#### F-18. Stack checker (schema now) **(extended)**

**Priority:** P2 UI. Schema in F-1. Ideation #12.

**User story.** As a researcher, I pick two or more catalog compounds and see catalog-derived notes: same class twice, route clash, a known pair note, and WADA rollup. Not "safe to combine".

**Data source.** `data/stacks/` schema (scout §3.5). Compound `class`, `routes_studied`, `stack_pair_notes: [{ other_id, kind: overlap|common_pair|caution, note }]`. Empty arrays are valid in v1.

**Acceptance sketch.** Rules are data. Sources show. Disclaimer repeats. No ingest of the person’s other medicines. Do not ship UI on an empty catalog.

#### F-19. Named suggested stacks **(extended)**

**Priority:** P2. Ideation #13.

**User story.** As a visitor, I search "Wolverine" or "CJC-1295 + Ipamorelin" and reach a catalog record of that convention, not a personal recommendation.

**Data source.** `data/stacks/{id}.json` with `origin` `vendor_named` or `commonly_reported`. Member `compound_ids` must exist. Vendor names stay in quotes if copied from a shop.

**Acceptance sketch.** Stack page lists members, evidence grade (usually `preclinical` or `anecdotal`), legal and WADA rollup from F-18. Nickname is an alias. No "suggested for you" or "best for injury". If a named stack fails the checker, do not publish it. Ship after F-18.

#### F-20. Reconstitution arithmetic helper **(extended)**

**Priority:** P2. Ideation #14. Unit maths only.

**User story.** As a researcher, I type vial milligrams, diluent millilitres, and syringe units, and I see mcg per unit. The page does not choose a dose.

**Data source.** User-typed numbers only. Compound `reported_protocols` must not pre-fill the helper. No vendor BAC-water link.

**Acceptance sketch.** Title states: research arithmetic, not a dose, not a protocol. No body weight, no indication, no injection-site diagram, no peptide-specific default amounts. Typical research amounts stay on the compound page as cited notes. This feature waits until after the stack checker (F-18). It does not ship in the same phase as that checker.

#### F-21. Curated pair notes UI **(extended)**

**Priority:** P2. Ideation #15.

**User story.** As a reader using the stack checker, I see the small JSON list of compound–compound notes (two GLP-1s, secretagogue overlap, and similar).

**Data source.** `stack_pair_notes` on compound JSON. Consumed by F-18. No second UI. Never a general drug-interaction engine (warfarin, SSRIs, metformin, alcohol).

**Acceptance sketch.** Pair notes appear only inside the stack checker. Each note has a source. Melanotan II sun-exposure stays a research note, not a beach guide.

#### F-22. Accounts and synced saved research or stacks

**Priority:** P2. Ideation #11 (accounts).

**User story.** As a returning researcher, I sign in with a magic link and see the same saved compounds and stacks on another device.

**Data source.** PostgreSQL after accounts exist. JSON catalog remains the research source of truth. User stacks may use `origin: user_saved` (scout §3.5) but are not v1 JSON.

**Acceptance sketch.** Magic link is enough. Browse still works logged out. No social login required. Saved stacks live in Postgres. Do not sell the list. bcrypt / `has_secure_password` is only in scope if passwords are chosen later; magic link does not need that gem.

#### F-23. Native mobile wrapper

**Priority:** P2

**User story.** As a phone user, I open a thin native shell only after the PWA is installable and offline (F-15).

**Data source.** Same catalog as the web app. Not a separate content store.

**Acceptance sketch.** Do not start iOS or Android while PWA routes are still commented or the service worker is still a no-op. Wrapper does not add checkout, push spam, or clinic features.

---

## 5. Data and integration appendix

JSON in `data/` is the research source of truth. Rails imports or reads it into PostgreSQL. Git remains the audit trail for agent edits. Schema files and templates may already sit in that folder. That is not a shipped catalog. Compound, provider, and product records still have to be written.

### File layout

See F-1. One record per file. Rails can glob JSON. Diffs stay readable.

### Shared fields (every record)

| Field | Notes |
| --- | --- |
| `id` | Kebab slug. Never rename in place. Add `aliases`. |
| `schema_version` | Start `"1.0.0"`. |
| `last_reviewed_at` | ISO date. Required. |
| `reviewer` | Agent or person tag, e.g. `grok-scout`. |
| `sources` | Min 1. `{ url, title, accessed_at, kind, quote?, pmid?, license? }`. `kind`: `regulator` \| `primary_literature` \| `review` \| `vendor` \| `encyclopedia` \| `news`. |
| `confidence` | `seen_live` \| `partial` \| `unverified` \| `rumour`. |

Empty `sources` is invalid. Rumour does not publish to the public index without a curator override documented in README.

### Refresh strategy (scout §3.6)

| Data | Who | How | Cadence (v1) |
| --- | --- | --- | --- |
| Compound identity, CAS, sequence | Agent | PubMed / PMC OA / Wikipedia jump-off, then primary paper | On add; review yearly |
| Research uses and reported protocols | Agent | Cite papers. Never copy vendor dosing as truth | On add; review when SAHPRA or a major paper changes |
| SAHPRA / WADA flags | Agent | Re-fetch official pages | Quarterly, or on news |
| Provider existence, city, script flag | Agent + manual | Fetch homepage and contact. Mark `down` on 404 | Quarterly |
| Product price, form | Agent, manual first | Fetch product URL. Record `last_reviewed_at`. No scrape farm | Monthly for core SKUs |
| Vendor claims | Quote only | Short quote + URL | With product refresh |
| User stacks | Later, accounts | Not in v1 JSON | n/a |

### Grok research loop (constraint)

1. Open the cited URL in the session. Do not guess.
2. Copy `data/_templates/{type}.json`. Keep keys. Use `null` or `[]` rather than deleting keys.
3. Write facts only. Quote vendor marketing. Do not paraphrase efficacy into `summary`.
4. Set `last_reviewed_at` and each `sources[].accessed_at` to that day.
5. Run schema validation. Invalid JSON fails the check. A missing date fails the check.
6. First JSON drop (scout §4.6): providers `reschem`, `biopeptics`, `tetratide-labs`, `the-clinic`, `comp-pharm`, `alphahuman`, `neuroactive`, `primeself`; compounds `bpc-157`, `tb-500`, `semax`, `selank`, `ghk-cu`, `noopept`; products only where form is visible.

### Source → path or URL (quick map)

| Need | Path or command | Format |
| --- | --- | --- |
| Compound records | `data/compounds/*.json` | JSON, one file |
| Provider records | `data/providers/*.json` | JSON, one file |
| Listings | `data/products/*.json` | JSON, one file |
| Stacks (later) | `data/stacks/*.json` | JSON, schema now |
| Schemas | `data/schema/*.schema.json` | JSON Schema. Shared source object is `defs.schema.json` |
| SAHPRA peptide warning | `https://www.sahpra.org.za/peptide-products-public-information/` | Official HTML |
| SAHPRA register | `https://www.sahpra.org.za/registered-health-products/` | Official search |
| WADA 2026 list | `https://www.wada-ama.org/en/prohibited-list` | Official HTML + PDF |
| Literature | `https://pubmed.ncbi.nlm.nih.gov/` | PMID citations |
| Live SA shops | Scout §2.1 URLs | Vendor HTML; quote facts |
| This PRD’s research base | `docs/research/scout-inventory.md`, `docs/research/ideation.md` | Markdown |
| Phase order | `docs/ROADMAP.md` | Markdown |
| Primary epic per feature | `docs/EPICS.md` | Markdown |

Do not scrape paywalled Examine content. Do not bulk-download PMC from the website.

---

## 6. Technical constraints

- **App:** Rails 8.1.3.1 (`config.load_defaults 8.1`), module `PeptidesResearchSouthAfrica`, Ruby 3.4.9 (`.ruby-version`, Docker `RUBY_VERSION`).
- **Database:** PostgreSQL only (`gem "pg"`, `config/database.yml`). Not a dual-adapter SQLite setup. Production also uses PostgreSQL for Solid Cache, Solid Queue, and Solid Cable.
- **UI:** Hotwire (`turbo-rails`, `stimulus-rails`), Tailwind, import maps, Propshaft. jbuilder is present. PWA stubs exist; routes are commented until F-15.
- **Jobs / cache / cable:** Solid Queue, Solid Cache, Solid Cable. Puma. Thruster in production Docker.
- **Auth:** `bcrypt` / `has_secure_password` stays commented until F-22 needs it.
- **Deploy skeleton:** Docker is present. Kamal is not in this repo. Deployment hosting is out of scope for this PRD.
- **Catalog path:** Agents update JSON. Rails imports into PostgreSQL. Requests do not depend on an agent being online.
- **Grok loop:** Citations + `last_reviewed_at` on every write. Invalid JSON fails CI.
- **Language:** English UI first. Strings stay out of Ruby.
- **Legal posture:** Informational catalog. No medical advice. No legal advice. No presentation of research-chemical storefronts as licensed medicines.

This PRD does not require those features to be implemented in the current scaffold. The scaffold today is the Rails 8 default plus this document. Schema files under `data/` are not a shipped catalog.

---

## 7. Risks and open questions

**Risks**

1. Stale prices and legal flags. Mitigation: F-12 dates, 90-day "needs review", no live stock theatre.
2. Readers treat cited protocols as instructions. Mitigation: F-14 wording, calculator stays P2 and never reads protocol defaults.
3. Research storefronts look like pharmacies in a comparison table. Mitigation: F-9 types, F-7 flags, no Buy button.
4. Grade inflation by agents. Mitigation: four grades only, human review on evidence, vendor URLs banned for compound summary.
5. COA URLs go dead or are fake. Mitigation: "provider states a COA" only. Do not host files.
6. Athletes miss the WADA flag. Mitigation: F-10 high on the page; stack rollup later.
7. Curator time. Scout found no local notes to import. The first 20 to 40 compounds need honest citations.

**Open questions (from scout §5, still open)**

- Comp Pharm: is the public peptide table orderable without a script, versus Gold practitioner-only?
- RPSA: city and full SKU list still thin.
- BioPeptics, The Clinic, AlphaHuman: city not confirmed on fetched pages.
- Examine.com terms still unread (bot wall). Link-out only until a human opens the terms.
- Public name: PeptideSA, SourceSA, Compound Index, or something else?
- Alchemi, Fagron, Lycoderm: compounding infrastructure without a public peptide SKU list. Catalog as providers with no products, or wait?

**Out of scope until answered:** live scrape, paid ranking, translations, push alerts, native apps.

---

## Changelog

- 2026-08-25: Consistency pass. F-2 lists the stored grade; F-8 is the card-level stamp. Schema path is `defs.schema.json`, not `source.schema.json`. Folder tree exists; records do not. Linked ROADMAP and EPICS.
- 2026-08-25: First PRD. Catalog JSON, SA-first providers, SAHPRA/WADA/evidence flags, PWA and local saves as P1, stacks and accounts as P2.
