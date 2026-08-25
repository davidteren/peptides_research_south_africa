# Ideation: peptides_research_south_africa

**Date:** 2026-08-25
**Status:** first pass, opinionated
**Public name:** TBD. Working name is the repo.

This file scores **extra** features. It is not the PRD. Core catalog work is assumed: compounds, routes, typical research use, and South African providers, all from JSON files that agents update.

The product is a **research catalog**, not a clinic and not a pharmacy. Every feature below is judged against that line.

---

## Product frame

**What.** A South Africa portal for people who research peptides, nootropics, and related compounds. It lists local providers, compound types, routes (injectable, nasal, oral, topical), what a compound is, and typical research use and frequency. Later it lets people check or save stacks.

**Why.** The facts are scattered. People in SA cannot easily compare who sells what, in what form, or what a compound actually is. SAHPRA warned the public in May 2026 about unregistered peptide products (including BPC-157, TB-500, Melanotan II, CJC-1295, Ipamorelin, PT-141, AOD-9604, Selank, Semax). That warning is the local context. A US blog does not answer it.

**How.** JSON research files first. Rails 8.1 + Hotwire + Solid Stack + PostgreSQL + PWA later in the same repo. Accounts and saved stacks later. Native wrapper after the PWA works.

**Non-goals (v1 and identity):** medical advice, checkout, placing orders, claiming clinical efficacy. Do not become a clinic. Do not become a pharmacy.

---

## Guardrails (kill tests)

Reject a feature if it does any of these:

1. Tells a person what to take, how much, or where to inject.
2. Lets a person buy, book, or message a seller to order.
3. Ranks providers by money (affiliate, sponsored, “best”).
4. Treats a disclaimer as a licence to give a protocol.
5. Speaks as a doctor, pharmacist, or regulator.

“Research use only” on a vendor site is a commercial label, not a SAHPRA exemption. The catalog must say that. It must not hide behind the same phrase.

---

## Core (not scored as extras)

Ship these or there is no product:

- Compound pages: what it is, class, routes, forms, typical research use and frequency (descriptive notes, not a calculator).
- Provider pages: who they are, where they ship from, what they list.
- Browse and filter by route and form.
- JSON as source of truth. Rails reads it. Agents update it.
- Plain-language disclaimer on every compound and stack view: not medical advice, not an instruction to use.

The extras below either make that catalog usable in SA, or they wait until the catalog is real.

---

## Scoreboard

Value and effort: **H** / **M** / **L**.
Verdict: **MVP** / **later** / **never**.

| # | Feature | Value | Effort | Verdict |
|---|---|---|---|---|
| 1 | Alias and misspelling search | H | L | **MVP** |
| 2 | Legal and regulatory status flags | H | M | **MVP** |
| 3 | Evidence grades | H | M | **MVP** |
| 4 | Provider comparison (price, form, shipping) | H | M | **MVP** |
| 5 | Provider type taxonomy | H | L | **MVP** |
| 6 | WADA / SAIDS athlete flag | H | L | **MVP** |
| 7 | COA-stated flag (not hosted lab files) | H | L | **MVP** |
| 8 | PWA offline catalog | H | M | **MVP** |
| 9 | Last-verified stamps on every fact | H | L | **MVP** |
| 10 | Compound class taxonomy | M | L | **MVP** |
| 11 | Saved lists: device-local now, accounts later | M | L then M | **MVP** (local) / **later** (accounts) |
| 12 | Stack checker | H | M | **later** (schema now) |
| 13 | Named suggested stacks | M | M | **later** |
| 14 | Reconstitution arithmetic helper | M | L | **later** |
| 15 | Curated interaction pair flags | M | M | **later** |

Killed ideas sit after the scored list. Do not put them on a roadmap.

---

## 1. Alias and misspelling search

**Value H · Effort L · MVP**

People type `BPC157`, `bpc 157`, `BPC-157`, `body protection compound`, `tb500`, `cjc1295`, `semaglutide` vs `Ozempic`. If search is exact-name only, the catalog looks empty. That is a failed first visit.

**Do:** a JSON `aliases` array per compound, plus a normaliser (strip hyphens, spaces, case). Same for brand names of registered medicines (Ozempic, Wegovy, Mounjaro) that map to the compound, clearly labelled as brand vs research name.

**Do not:** fuzzy “did you mean” that invents a compound. Unknown string = no match + “report a missing alias”.

**JSON now:** `aliases: ["BPC157", "BPC 157", "body protection compound-157"]`.

---

## 2. Legal and regulatory status flags

**Value H · Effort M · MVP**

This is the SA product. Without it, the site is a shopping list of unregistered substances with a US accent.

Facts to store, not advice to give:

- SAHPRA registered medicine? Registration number if yes.
- Schedule if known (null is allowed; “unknown” is better than a guess).
- Named in SAHPRA’s May 2026 public peptide warning? Boolean.
- Typical supply path seen in SA: registered brand, compounding pharmacy, research vendor, international shipper, unknown.
- Personal import of unregistered medicines from abroad needs prior SAHPRA authorisation. Flag that on non-SA shippers.

**Do:** short flags and a dated note. Link the SAHPRA public page. Say “this is not legal advice”.

**Do not:** a traffic-light “legal to buy”. The Medicines Act cares about intended use, not the vendor’s “research” sticker. A green badge would be a lie.

**JSON now:** `sahpra: { registered, registration_numbers, schedule, in_2026_public_warning, notes, verified_on }`.

---

## 3. Evidence grades

**Value H · Effort M · MVP**

“What is this compound” without a grade becomes marketing. The non-goal is “do not claim clinical efficacy”. A grade is how you keep that promise.

Use four grades, nothing finer:

| Grade | Meaning |
|---|---|
| `anecdotal` | Forum and vendor talk only |
| `preclinical` | Animal or in-vitro papers |
| `early_human` | Small or early human studies, not a registered indication |
| `registered_medicine` | SAHPRA-registered product for a named indication |

**Do:** one grade per compound, plus DOI/PubMed citations in JSON. Show the grade on the card, not in a footnote.

**Do not:** five-star “works for tendons”. Do not invent a sixth grade called “promising”.

Effort is M because the first 30 compounds need honest citations, not a schema. Agents can fill citations. Humans (or a review pass) must stop grade inflation.

**JSON now:** `evidence_grade`, `citations: [{ doi, title, year, kind }]`.

---

## 4. Provider comparison (price, form, shipping)

**Value H · Effort M · MVP**

This is the “why” in the brief. Compare **form, route, ZAR as-of date, ships-from, cold-chain, provider type**. That is enough.

**Do:** curated rows in JSON. Price is `price_zar` + `price_checked_on`. Shipping is origin (ZA vs abroad) and a coarse region note (Gauteng / Western Cape / nationwide / courier). Cold-chain is a boolean plus a one-line note.

**Do not:** live scrape of vendor sites in v1 (ToS, breakage, looks like a shop bot). Do not show “in stock”. Do not sort by price as the default (cheapest unregistered powder is not a quality signal). Do not add “Buy” or WhatsApp order buttons.

Price will go stale. The as-of date is the feature. A missing date is a bug.

**JSON now:** listing records: `provider_id`, `compound_id`, `form`, `route`, `size_label`, `price_zar`, `price_checked_on`, `ships_from`, `cold_chain`.

---

## 5. Provider type taxonomy

**Value H · Effort L · MVP**

A compounding pharmacy (SAPC / SAHPRA-licensed), a research-chemical website, a wellness clinic, a gym seller, and an offshore store are not the same kind of listing. Putting them in one table with no type is reckless.

Types:

- `compounding_pharmacy`
- `research_vendor`
- `clinic`
- `international`
- `unknown`

**Do:** type on every provider. Filter by type. Default sort can prefer documented pharmacies over unknown, but do not label anyone “recommended” or “safe”.

**Do not:** “verified seller” badges you cannot defend. Type is a classification, not an endorsement.

This is L effort and H value. Ship it with the first provider JSON.

---

## 6. WADA / SAIDS athlete flag

**Value H · Effort L · MVP**

SA rugby, cycling, athletics, and amateur tested sport are a real audience. BPC-157 is WADA S0 (non-approved). TB-500 / thymosin-β4 sits in S2. Growth-hormone secretagogues are prohibited. A catalog that never says this will get someone banned.

**Do:** `wada_prohibited` boolean, class code, one-line note, link to the WADA list. Show it high on the compound page. Mention SAIDS as the local code signatory.

**Do not:** a “can I compete this weekend?” wizard. That is legal/medical advice for a named person.

**JSON now:** `wada: { prohibited, class, notes, verified_on }`.

---

## 7. COA-stated flag (not hosted lab files)

**Value H · Effort L · MVP**

Quality is the practical risk in SA. People ask “do they have a COA?”. The catalog can record whether the provider **states** a third-party certificate, with a URL and a date.

**Do:** `coa_stated`, `coa_url`, `coa_checked_on`. Label it “provider states a COA”. That is all.

**Do not:** host PDFs, score purity, or say “tested safe”. Hosting lab files makes the site a quality authority. It is not. A screenshot of HPLC is also easy to fake. Do not become that verifier.

---

## 8. PWA offline catalog

**Value H · Effort M · MVP**

The brief says PWA now. The Rails skeleton already has a manifest and a stub service worker; the routes are commented out. Offline browse is the reason to turn it on.

SA mobile data drops. People will open a compound page in a gym, a courier queue, or a clinic waiting room.

**Do:** cache compound and provider pages plus the JSON. Show a “cached, may be stale” banner when offline. Installable on the home screen.

**Do not:** offline accounts, web push, or a fake native shell. Push is in the stub file; leave it off until there is a real alert (feature 11 later, or a legal-status change alert).

Effort is M because caching strategy and stale UX need tests, not because the platform is missing.

---

## 9. Last-verified stamps on every fact

**Value H · Effort L · MVP**

Legal status, prices, and listings change. JSON without `verified_on` becomes folklore in three months.

**Do:** `verified_on` and `sources[]` on compound, provider, listing, and legal blocks. Show “Checked 2026-08-01” in the UI. A Grok update that cannot set a date should fail CI.

**Do not:** a live “last scraped” clock that implies the site is watching shops.

This is how agent-updated JSON stays honest.

---

## 10. Compound class taxonomy

**Value M · Effort L · MVP**

Classes: healing (BPC-157, TB-500), GHRH, GHRP / secretagogue, GLP-1 / metabolic, melanocortin, nootropic (Selank, Semax), copper (GHK-Cu), other.

Needed to browse. Needed later so a stack checker can say “two GLP-1s” without a neural net.

**Do:** one primary class, optional tags. Filter chips on the index.

**Do not:** a 40-node ontology. If a compound does not fit, `other` plus a note.

Ship with the first JSON so stack work does not require a rewrite.

---

## 11. Saved lists: device-local now, accounts later

**Value M · Effort L (local) / M (accounts) · MVP local, later accounts**

The brief wants saved research later. An empty heart icon on day one is theatre. Local save is cheap and does not need auth.

**MVP:** save compounds (and later stacks) in the browser (`localStorage` or IndexedDB). Survives refresh. Lost on clear-site-data. No email, no password. `has_secure_password` stays commented out.

**Later:** accounts so a list syncs across devices. Magic link is enough. Saved stacks then live in Postgres.

**Do not:** social login, profiles, or “follow a researcher”. Do not require an account to browse. Do not sell the list.

Accounts are not MVP because there is nothing durable to sync until the catalog is trusted.

---

## 12. Stack checker

**Value H · Effort M · later** (design the JSON in MVP)

The user asked for this later. Keep that. A checker on an empty catalog is a toy.

When it ships: the person picks two or more **catalog** compounds. The page returns **catalog-derived** notes:

- Same class twice (two GLP-1s, two secretagogues).
- Route clash (oral-only vs injectable-only in one named stack).
- A known pair note if one exists in JSON (CJC-1295 + Ipamorelin is a documented community pairing; two incretins is a documented overlap).
- WADA: if any item is prohibited, the stack is prohibited for tested athletes.

**Do:** rules as data. Show sources. Repeat “not medical advice, not a protocol”.

**Do not:** “safe to combine”. Do not ingest the person’s other medicines (blood pressure, SSRIs). That is a drug-interaction product. We are not that (see #15 and Killed).

**JSON now (so later is cheap):** `class`, `routes`, `stack_pair_notes: [{ other_id, kind: overlap|common_pair|caution, note }]`. Empty arrays are fine in v1.

---

## 13. Named suggested stacks

**Value M · Effort M · later**

Community names exist: “Wolverine” (BPC-157 + TB-500), CJC-1295 + Ipamorelin. People will search those strings. Treat them as **catalog records of a convention**, not as a recommendation engine.

**Do after the checker:** a stack page with member compounds, evidence grade (almost always `preclinical` or `anecdotal`), and the same legal/WADA rollup as the checker. Alias the nickname.

**Do not:** “suggested for you”, “best for injury”, or auto-build from goals (“fat loss”, “sleep”). That is a clinic protocol generator. Kill it.

Ship this after the checker so a named stack can reuse the same collision rules. If a named stack fails the checker, do not publish it.

---

## 14. Reconstitution arithmetic helper

**Value M · Effort L · later** (generic maths only)

**Never** for personal or indication-based dosing. **Later** for a labelled unit converter.

**Why later, not MVP.** The catalog already has “typical research use and frequency” as **descriptive text**. That is enough for v1. A calculator next to an injectable peptide is how the product starts to look like a clinic, before trust in the catalog exists.

**Why later, not never.** People already convert vial milligrams and diluent millilitres with insulin-syringe units. Getting the arithmetic wrong is a real research-lab problem. A helper that only uses **numbers the person types** is unit conversion, not a prescription.

**If it ships:**

- Inputs: vial milligrams, diluent millilitres, syringe units. Outputs: mcg per unit. No compound default fill from a “standard protocol”.
- Title: “Research arithmetic. Not a dose. Not a protocol.”
- No body weight. No “for tendon injury”. No BAC-water shopping link. No injection-site diagram.

**Never:** weight-based dose, mg/kg, “your weekly plan”, peptide-specific default amounts that ignore the user’s inputs, or anything that says “take”. Typical research amounts stay on the compound page as cited notes, not as calculator defaults.

A disclaimer does not convert a dose wizard into a catalog. If a future idea needs body weight or an indication, it is already in Killed.

---

## 15. Curated interaction pair flags

**Value M · Effort M · later**

**Later:** a small JSON list of compound–compound notes inside **this** catalog (two GLP-1s; secretagogue overlap; Melanotan II and the obvious sun-exposure caution as a research note, not a beach guide).

**Never:** a general drug-interaction engine (warfarin, SSRIs, metformin, alcohol). We do not have that database, we will not maintain it, and offering it makes the site a pharmacy tool.

The stack checker (#12) should consume these pairs. Do not build a second UI.

---

## Killed (never)

Be harsh. These ideas show up in every peptide startup deck. They would wreck the identity of this product.

| Idea | Why never |
|---|---|
| Checkout, cart, payments, “order from this provider” | Pharmacy / shop. Brief forbids it. |
| WhatsApp / email the seller to buy | Same as checkout with extra legal risk. |
| Live stock, restock alerts, “buy now” | Shop inventory. We do not run their warehouse. |
| Clinic booking, telehealth, “talk to a doctor” | Clinic. Out of scope forever for this product. |
| Weight-based or indication-based dosing | Medical advice. See #14. |
| Injection technique, site maps, reconstitution video as instruction | Medical instruction. |
| AI protocol generator (“stack for fat loss”) | Clinic, plus hallucination. |
| Full interaction checker against other medicines | Pharmacy product. |
| User reviews of “it worked for my knee” | Efficacy claims by another name. |
| Affiliate-bought ranking or “recommended seller” | Money changes the catalog. Disclose links later if they exist; never sell sort order. |
| Hosting COA PDFs as proof of purity | Fake authority. See #7. |
| Traffic-light “legal to buy in SA” | Not true; intended use matters. See #2. |
| Forum / comments as evidence | Unmoderated medical talk. Citations stay in JSON. |

Native mobile wrapper is not killed. It is **later**, after the PWA is actually installable and offline. Do not start iOS/Android while the service worker is still a commented route.

Afrikaans / isiZulu is **later**. English first. Keep strings out of Ruby so translation is possible. Do not delay v1 for it.

---

## MVP extra slice (what to actually build)

With the first useful catalog, also ship:

1. Aliases so search works.
2. Legal flags so the SA warning is visible.
3. Evidence grades so pages are not ads.
4. Provider type + comparison rows (form, ZAR as-of, origin, cold-chain).
5. WADA / SAIDS flag.
6. COA-stated flag.
7. `verified_on` everywhere.
8. Compound class (browse now, stacks later).
9. PWA offline browse.
10. Device-local saved compounds.

**Schema only, no UI yet:** stack pair notes, so #12 does not require a migration panic.

**Wait:** stack checker, named stacks, reconstitution maths, interaction UI, accounts, push, native wrapper.

**Never:** the Killed table.

That slice is a catalog people in SA can trust enough to bookmark. It is not a treatment service.

---

## JSON implications (for the next agent)

Minimum compound shape:

```json
{
  "id": "bpc-157",
  "name": "BPC-157",
  "aliases": ["BPC157", "BPC 157", "body protection compound-157"],
  "class": "healing",
  "routes": ["injectable", "oral"],
  "forms": ["lyophilized_vial", "capsule"],
  "summary": "Synthetic pentadecapeptide studied in animal models of tissue repair.",
  "researched_for": ["soft-tissue repair models"],
  "typical_research_use": {
    "amount_note": null,
    "frequency_note": null,
    "cycle_note": null
  },
  "evidence_grade": "preclinical",
  "citations": [],
  "sahpra": {
    "registered": false,
    "registration_numbers": [],
    "schedule": null,
    "in_2026_public_warning": true,
    "notes": "",
    "verified_on": "2026-08-25"
  },
  "wada": {
    "prohibited": true,
    "class": "S0",
    "notes": "",
    "verified_on": "2026-08-25"
  },
  "storage": {
    "lyophilized": "",
    "reconstituted": "",
    "cold_chain": true
  },
  "stack_pair_notes": [],
  "verified_on": "2026-08-25",
  "sources": []
}
```

Minimum provider shape: `type`, `ships_from`, `cold_chain`, `url`, `verified_on`.
Minimum listing shape: `form`, `route`, `price_zar`, `price_checked_on`, `coa_stated`.

`typical_research_use` stays text. It does not feed a calculator.

---

## Sequencing

1. JSON schema + 20–40 compounds + a handful of SA providers (with types).
2. Rails read path, index, compound page, provider page, comparison table.
3. Search with aliases. Flags: legal, evidence, WADA, COA-stated, verified-on.
4. Turn on PWA routes. Offline cache for catalog pages.
5. Device-local saved compounds.
6. Stop. Use the catalog. Then stack checker, then named stacks.
7. Reconstitution arithmetic only if people still ask after the catalog is trusted.
8. Accounts when saved stacks must leave the phone.

Do not start native apps, payments, or “protocol” UI in that list.

---

## Changelog

- 2026-08-25: First ideation pass. Scored 15 extra features. Killed clinic, pharmacy, checkout, personal dosing, and paid ranking.
