# Scout inventory: peptides research South Africa

Working name: `peptides_research_south_africa` (public name TBD).
Scout date: 2026-08-25.
Scope: real sources only. Informational catalog. No medical advice. No invented providers.

**Product in one line.** A South Africa-first catalog of peptides, nootropics, and related compounds, with local providers, forms, and cited compound notes.

**Hard constraints used here.** Cite sources. Do not invent provider claims. Mark unverified sites. Call protocols "commonly reported research protocols", never recommendations.

---

## 1. On this machine (read-only)

### 1.1 Finding

There is **no existing peptide or nootropic research catalog** on this machine. No structured compound notes. No provider lists. No protocol files.

The empty stub folder `/Users/davidteren/Projects/peptides` was created 2026-07-22 and contains **0 files** (size 0 B).

MemPalace search for peptides / nootropics / research chemicals returned no relevant drawers.

### 1.2 Paths checked

| Path | Result |
| --- | --- |
| `/Users/davidteren/Projects/peptides` | Empty directory, 0 B |
| `/Users/davidteren/notes` | Does not exist |
| `/Users/davidteren/Projects/notes` | Does not exist |
| `/Users/davidteren/Documents` | No peptide/nootropic markdown |
| `/Users/davidteren/Obsidian` | Does not exist |
| iCloud Obsidian (`Library/Mobile Documents/iCloud~md~obsidian`) | No peptide/nootropic markdown hits |
| This repo | Rails 8 scaffold only. No `data/` catalog yet |
| MemPalace | No peptide catalog memories |

### 1.3 Adjacent notes (budget, not catalog)

These mention nootropics as a **spend line**, not as compound data.

| Path | Format | Size | Key fields | Use for this product |
| --- | --- | --- | --- | --- |
| `/Users/davidteren/Projects/DT/finances/ANALYSIS.md` | Markdown | 17,076 bytes | Household budget analysis. Line: nootropics ~R2,000/mo | Context only. Not compound data |
| `/Users/davidteren/Projects/DT/finances/data/raw/Sheet4.json` | JSON (spreadsheet dump) | 1,883 bytes | Budget rows. One cell `"nootropics "` with `"R2,000.00"` | Context only |
| `/Users/davidteren/Projects/ClaudeCode/tool_chain/machines/m4-work/global/project-memory/-Users-david-teren-Projects-Personal-finances/memory/user_david_finances.md` | Markdown frontmatter + bullets | 1,088 bytes | "Uses nootropics and supplements regularly (~R2K/mo)". Location: Cape Town area | Personal context only. Do not import into public catalog |

Unrelated hits (ignore): `words.txt` dictionaries containing the English word "peptide"; finance sheet names.

### 1.4 Environment variable names (values never recorded)

**This repo references these names.** No `.env` file is present.

| Name | Where | Present as a file/value here |
| --- | --- | --- |
| `PEPTIDES_RESEARCH_SOUTH_AFRICA_DATABASE_PASSWORD` | `config/database.yml` production | Name only. No `.env` |
| `RAILS_MAX_THREADS` | `database.yml`, `puma.rb` | Name only |
| `RAILS_ENV` | `test/test_helper.rb` | Name only |
| `WEB_CONCURRENCY` | `config/puma.rb` | Name only |
| `SOLID_QUEUE_IN_PUMA` | `config/puma.rb` | Name only |
| `PIDFILE` | `config/puma.rb` | Name only |
| `PORT` | `config/puma.rb` | Name only |
| `BUNDLE_GEMFILE` | `config/boot.rb` | Name only |
| `JOB_CONCURRENCY` | `config/queue.yml` | Name only |
| `RAILS_LOG_LEVEL` | `config/environments/production.rb` | Name only |
| `CI` | `config/environments/test.rb` | Name only |
| `DATABASE_URL` | commented example in `database.yml` | Name only |

Encrypted Rails secrets: `config/credentials.yml.enc` is present. `config/master.key` is present. Values not opened.

**This shell also has these names set** (unrelated to the catalog; listed for completeness, no values): `ACCESS_KEY_ID`, `AMP_API_KEY`, `BRAVE_API_KEY`, `GEMINI_API_KEY`, `NIMBLE_API_KEY`, `OPENROUTER_API_KEY`, `SECRET_ACCESS_KEY`, `SOPS_AGE_KEY_FILE`.

---

## 2. External sources

### 2.1 South African providers (starter list)

Confidence:

- **seen live** = homepage or product page fetched on 2026-08-25
- **partial** = live site, but catalog, script rule, or city is incomplete
- **unverified** = named in search, but down, thin, or not independently confirmed
- **do not list as a seller** = marketplace, SEO farm, or enforcement target

#### Research-chemical / research-use storefronts (no script seen on public pages)

| Provider | URL | City | What they sell (seen on page) | Forms / routes (visible) | Script required (visible) | Confidence |
| --- | --- | --- | --- | --- | --- | --- |
| Reschem | https://reschem.co.za | Cape Town, Paarden Eiland (contact page) | Nootropics, racetams, peptide pens and nasal sprays, antimicrobials, longevity compounds. Example: BPC-157 + TB-500 blend, Semax, Selank, NAD+, Noopept, Aniracetam. ZAR. EFT. Free courier over R600 | Pre-filled SubQ pens, nasal sprays, oral capsules/powder | Public checkout. No prescription step seen | **seen live** |
| BioPeptics | https://biopeptics.co.za | South Africa (city not on homepage) | Research-grade lyophilized peptides. Labels "For Research Use Only". Shop lists CJC-1295 (no DAC), KPV, Retatrutide, Tesamorelin, Tirzepatide, Semaglutide, GHK-Cu powder. ZAR prices on page | Lyophilized vials; cosmetic GHK-Cu powder | Public add-to-cart. No prescription step seen | **seen live** |
| Tetratide Labs | https://www.tetratidelabs.co.za | Johannesburg (stated stock location) | Research peptides and accessories. BPC-157, TB-500, GHK-Cu, KPV, "Wolverine" BPC+TB blends. Also equine / dog / cat SKUs. Courier Guy. ZAR | Lyophilized vials, reusable pen kits, reconstitution kits | Public cart. No prescription step seen | **seen live** |
| Research Peptides SA (RPSA) | https://researchpeptides.co.za and https://peptides.co.za | South Africa (city not confirmed on pages fetched) | Research peptides. Claims operation since 2006. Product example: BPC-157 10 mg / TB-500 10 mg blend. WhatsApp order. Ships SA via Postnet or courier | Vials (injectable research use implied). Site says shipments include syringes and water | Public/login shop. No prescription step seen | **partial** (homepage live; category page was thin) |
| The Clinic | https://www.the-clinic.co.za | South Africa (city not on product page) | Peptide shop with stacks. BPC-157 5 mg cartridge, TB-500, GHK-Cu, KPV, named stacks. Prices hidden until account login | Pre-mixed pen cartridges, self-mix vials, capsules | Account required to see price. No medical-script step on "How to Order" | **seen live** |

#### Clinics / compounding pharmacies (script or practitioner channel)

| Provider | URL | City | What they sell (seen on page) | Forms / routes (visible) | Script required (visible) | Confidence |
| --- | --- | --- | --- | --- | --- | --- |
| Comp Pharm Pharmacy | https://comppharm.co.za/our-peptides-2/ | Parys, Free State (24 Buiten Street) | Compounded peptide list: BPC-157 (solution and capsules), TB-4, CJC-1295 + Ipamorelin, GHK-Cu, MOTS-c, PT-141, Selank nasal, Semax nasal, AOD-9604, 5-Amino-1MQ, TA-1, MENK, iRGD. SAPC / PSSA badges on site. Gold range at https://comppharmgold.net/ is practitioner exclusive | Injectable solutions, capsules, nasal sprays | Compounding pharmacy. Practitioner exclusive Gold range. Treat as **script / practitioner** until confirmed otherwise | **seen live** |
| AlphaHuman | https://alphahuman.co.za/pages/peptides | South Africa (city not confirmed; in-person and online consult) | Clinic. Lists BPC-157, Semaglutide, Tirzepatide, GHK-Cu, Sermorelin, Tesamorelin, Epithalon, CJC, AOD-9604, MOTS-c, KPV, 5-amino-1MQ, PT-141, TB-500, Selank, Semax, Melanotan II. Consult R1,800 | Subcutaneous injectables, topical. Cold-chain delivery after script | **Yes.** Intake, clinical review, "doctor issues a legal protocol", then dispatch | **seen live** |
| Alchemi Compounding Pharmacy | https://alchemicompoundingpharmacy.co.za | Phone 010 143 4390 (Gauteng-style). City not on homepage | Compounding for healthcare providers. Anti-ageing / longevity. NAD pen banner. Blog on hormone and peptide therapy. Order portal for doctors/pharmacists | Sterile compounding (formats not a public SKU list) | **Practitioner portal.** Not a public peptide shop | **partial** (live; peptide SKUs not public) |
| Fagron South Africa | https://fagron.co.za/quality/ | Johannesburg and Cape Town | Licensed sterile and non-sterile compounding. SAPC A-grade. ACPSA founding member. Not a public peptide catalog | Prescription compounds in licensed cleanrooms | **Yes.** Prescriber / pharmacist / patient enquiry form | **seen live** as compounding infrastructure, not a peptide SKU list |
| Lycoderm Compounding Pharmacy | https://www.lycoderm.co.za | Not stated on homepage | Custom compounds from a registered practitioner. Focus: topical, dermatology, anti-ageing. Not a peptide catalog | Oral, topical, transdermal, suppositories | **Yes.** Practitioner instruction | **seen live** as compounding; peptides **not listed** |

#### Nootropic / supplement retailers (oral, no injectables on homepage)

| Provider | URL | City | What they sell (seen on page) | Forms / routes (visible) | Script required (visible) | Confidence |
| --- | --- | --- | --- | --- | --- | --- |
| NeuroActive | https://neuroactive.co.za | South Africa (support hours listed; city not on homepage). Sitemap also on https://zanootropics.co.za | "SA's original nootropics store". Noopept 20 mg caps R189, Lion's Mane, Alpha GPC, L-Theanine, Magtein, Neuro Mind blend. Also red-light devices | Oral capsules | No | **seen live** |
| PrimeSelf | https://primeself.co.za | South Africa (free local delivery over R500) | Branded nootropic and wellness stacks (Prime Mind, Magtein, NMN, collagen peptides as food collagen, not research peptides). Third-party tested | Oral capsules / powders | No | **seen live** |

#### Seen in search but not catalogued as SA sellers

| Name | URL | Why excluded or flagged |
| --- | --- | --- |
| PeptideLab / New Age Health | https://www.newagehealth.co.za/ | **Unverified.** HTTP 404 on 2026-08-25 |
| Takealot / Amazon ZA | marketplace listings (e.g. BPC-157 capsules) | Marketplaces, not a provider entity. Quality unknown. Do not treat as a local peptide house |
| JCSG.org ZA store | https://jcsg.org/za/peptides/bpc-157/ | Sales copy for "Body Pharm". Not confirmed as an SA warehouse. Treat as **unverified reseller** |
| Africa Peptide Guide | https://africapeptideguide.com/vendors/reschem | Directory / affiliate, not a seller |
| BT BioLabs | https://btbiolabs.com/peptide-supplier-south-africa/ | Overseas B2B pitch. Not a verified SA storefront |
| SA Builder article | https://sabuilder.co.za/pages/best_suppliers_of_research_peptides_in_south_africa__what_you_need_to_know.html | SEO page, not a vendor |
| iDexis / Sentra Pharmacy (Silverton, Pretoria) | named in SAHPRA/SAPC action 2026-05-26 | **Enforcement target**, not a catalog provider. See regulatory section |

### 2.2 Compound knowledge sources (for citations)

Use these to write compound records. Do not copy vendor marketing into the "what it is" field.

| Source | URL | What to use | Licence / terms |
| --- | --- | --- | --- |
| PubMed | https://pubmed.ncbi.nlm.nih.gov/ | Titles, PMIDs, abstracts for identity and published research | Abstracts are free to read. Cite PMID. Do not bulk-scrape |
| PMC Open Access Subset | https://www.ncbi.nlm.nih.gov/pmc/about/copyright/ | Full text only when the article is OA | Per-article CC or similar. Check each article. Systematic download from the PMC website is prohibited. Use official OA datasets if bulk is needed |
| SAHPRA public pages | https://www.sahpra.org.za/peptide-products-public-information/ | SA regulatory status, named unregistered peptides, GLP-1 advice | Official public communication. Quote and cite |
| SAHPRA registered products search | https://www.sahpra.org.za/registered-health-products/ (redirects to medapps.sahpra.org.za) | Whether a branded medicine is registered in SA | Official register. Check per INN / brand |
| WADA Prohibited List 2026 | https://www.wada-ama.org/en/prohibited-list and PDF https://www.wada-ama.org/sites/default/files/2025-09/2026list_en_final_clean_september_2025.pdf | Athlete status. BPC-157 is named in S0. TB-500 / thymosin-β4 in S2.3. CJC-1295, ipamorelin, sermorelin, tesamorelin, AOD-9604, MOTS-c also listed | Official anti-doping list. Cite year |
| FDA compounding / USADA briefing on BPC-157 | https://www.usada.org/spirit-of-sport/bpc-157-peptide-prohibited/ (links FDA PCAC materials) | US compounding status is **not** SA law. Useful comparative note only | Public US government / USADA pages |
| Examine.com | https://examine.com | Human-evidence summaries for nootropics and some peptides | **Commercial.** Terms page was bot-walled on 2026-08-25. **Link out. Do not copy Examine prose** |
| Wikipedia | e.g. compound pages | Jump-off for INN, CAS, sequence, history | Text: CC BY-SA 4.0 (and often GFDL). Attribute. Not a primary source |
| Vendor pages | URLs in §2.1 | Product existence, form, strength, ZAR price, COA links | Copyright of the vendor. Quote short product facts. Never treat claims as efficacy |

**Starter compound set suggested by live SA pages + SAHPRA warning list** (not exhaustive): BPC-157, TB-500 / TB-4 / thymosin-β4, Semax, Selank, GHK-Cu, KPV, CJC-1295, Ipamorelin, MOTS-c, AOD-9604, PT-141, 5-Amino-1MQ, Semaglutide, Tirzepatide, Retatrutide, Tesamorelin, Sermorelin, Epithalon, Melanotan II, NAD+, Noopept, Piracetam, Aniracetam, Lion's Mane, Alpha-GPC, L-Theanine, Magnesium L-threonate.

SAHPRA's public example list of illegally marketed peptides (2026): BPC-157, TB-500, Melanotan II, CJC-1295, Ipamorelin, PT-141, AOD-9604, Selank, Semax. Source: https://www.sahpra.org.za/peptide-products-public-information/

### 2.3 SA regulatory context (facts with sources, not legal advice)

This product must stay informational. It must not tell people to buy unregistered medicines.

| Fact (plain language) | Source |
| --- | --- |
| SAHPRA warns that unregistered peptide products are sold in SA for weight loss, muscle, anti-ageing, injury recovery, concentration, and performance | https://www.sahpra.org.za/peptide-products-public-information/ |
| Those sales often happen online, on social media, in gyms, and through informal suppliers, without approval under the Medicines and Related Substances Act 101 of 1965 | Same SAHPRA page |
| SAHPRA names examples of illegally marketed peptides: BPC-157, TB-500, Melanotan II, CJC-1295, Ipamorelin, PT-141, AOD-9604, Selank, Semax | Same SAHPRA page |
| Under Act 101 of 1965, a product intended to treat, prevent, or alter bodily functions must be registered with SAHPRA before it can be sold in South Africa (SAHPRA's wording) | Same SAHPRA page |
| SAHPRA warns against self-administration without medical supervision, especially from online or unverified sources | Same SAHPRA page |
| Registered GLP-1 products are described as ready-to-use pens or vials. Powder forms are not registered and should be treated with caution | Same SAHPRA page |
| SAHPRA and SAPC inspected iDexis (Pty) Ltd t/a Sentra Pharmacy, Silverton, Pretoria (26 May 2026). They seized unregistered Semaglutide, Tirzepatide, and combination products. They said compounding is limited to individual patients with a valid prescription, and cannot be used for large-scale manufacture, advertising, or distribution of unregistered medicines | https://www.sanews.gov.za/south-africa/authorities-crack-down-pretoria-weight-loss-production-pharmacy |
| Compounding and dispensing licences for practitioners sit under section 22C(1)(a) of the Medicines Act, with pharmacy premises licensed with SAPC and SAHPRA | https://www.health.gov.za/licensing-home/ |
| Fagron (licensed compounder) states it follows Act 101 of 1965, Good Pharmacy Practice, and the Pharmacy Act, in Johannesburg and Cape Town | https://fagron.co.za/quality/ |
| Athletes: WADA 2026 list prohibits BPC-157 (S0, non-approved), TB-500 / thymosin-β4 (S2.3), several GHRH analogues and secretagogues, AOD-9604, MOTS-c | https://www.wada-ama.org/en/prohibited-list |

**Catalog implication.** Split providers into at least:

1. Licensed compounding / clinic (script path).
2. Research-use storefronts (no script on the public page; SAHPRA still treats therapeutic marketing of unregistered peptides as unlawful).
3. Oral nootropic retailers.

Do not present (2) as "legal medicines". Record `listing_posture` as the vendor's own label (`research_use_only`, `compounded_on_script`, `food_supplement`) plus a `sahpra_note` pointing at the public warning.

---

## 3. Proposed JSON catalog shape

Grounded in what live pages actually expose: compound name and aliases, category, route, strength, vial/pen/capsule size, ZAR price, stock, COA URL, city, script flag, and cited research use.

### 3.1 Shared types

Every record:

| Field | Type | Required | Notes |
| --- | --- | --- | --- |
| `id` | string (kebab-case slug) | yes | Stable. Never rename in place; add `aliases` |
| `schema_version` | string | yes | Start `"1.0.0"` |
| `last_reviewed_at` | string (ISO date `YYYY-MM-DD`) | yes | Date a human or agent last checked sources |
| `reviewer` | string | yes | Agent or person tag, e.g. `"grok-scout"` |
| `sources` | array of Source | yes (min 1) | Citations. Empty array is invalid |
| `confidence` | enum | yes | `seen_live` \| `partial` \| `unverified` \| `rumour` |

Source object:

| Field | Type | Required |
| --- | --- | --- |
| `url` | string (URI) | yes |
| `title` | string | yes |
| `accessed_at` | string (ISO date) | yes |
| `kind` | enum | yes: `regulator` \| `primary_literature` \| `review` \| `vendor` \| `encyclopedia` \| `news` |
| `quote` | string | no. Short verbatim only when needed |
| `pmid` | string | no |
| `license` | string | no. e.g. `CC-BY-SA-4.0`, `all-rights-reserved` |

### 3.2 `compounds[]` (one file per compound)

What it is. Typical research use. Commonly reported protocols. Not a shopping item.

| Field | Type | Required | Notes |
| --- | --- | --- | --- |
| `id` | string | yes | e.g. `bpc-157` |
| `name` | string | yes | Display name |
| `inn` | string \| null | no | International nonproprietary name if any |
| `aliases` | string[] | yes | Include empty array |
| `categories` | string[] | yes | `peptide` \| `nootropic` \| `glp1` \| `hormone_secretagogue` \| `copper_peptide` \| `other`. Multi-value OK |
| `cas` | string \| null | no | Do not invent |
| `sequence` | string \| null | no | Amino-acid sequence if published |
| `summary` | string | yes | Neutral, cited. What the compound is |
| `research_uses` | array | yes | `{ "use": string, "evidence_grade": "preclinical"\|"human"\|"anecdotal", "sources": Source[] }` |
| `reported_protocols` | array | no | **Label in UI as "commonly reported research protocols".** `{ "route": Route, "amount": string, "frequency": string, "duration": string, "context": string, "sources": Source[] }` |
| `routes_studied` | Route[] | yes | `injectable_subq` \| `injectable_im` \| `nasal` \| `oral` \| `topical` \| `other` |
| `sahpra` | object | yes | `{ "registered_medicine": boolean\|null, "on_unregistered_warning_list": boolean, "notes": string, "sources": Source[] }` |
| `wada` | object \| null | no | `{ "prohibited": boolean, "class": string, "list_year": number, "sources": Source[] }` |
| `related_compound_ids` | string[] | no | e.g. TB-500 next to BPC-157 |

Do not store medical advice, dosing instructions as recommendations, or vendor efficacy claims on the compound.

### 3.3 `providers[]` (one file per provider)

| Field | Type | Required | Notes |
| --- | --- | --- | --- |
| `id` | string | yes | e.g. `reschem` |
| `name` | string | yes | |
| `kind` | enum | yes | `research_storefront` \| `compounding_pharmacy` \| `clinic` \| `nootropic_retailer` \| `marketplace` \| `b2b` |
| `website` | string (URI) | yes | |
| `city` | string \| null | no | |
| `province` | string \| null | no | |
| `country` | string | yes | `"ZA"` |
| `ships_domestically` | boolean \| null | no | |
| `currency` | string | yes | `"ZAR"` |
| `prescription_required` | enum | yes | `yes` \| `no` \| `practitioner_only` \| `unknown` |
| `listing_posture` | enum | yes | `research_use_only` \| `compounded_on_script` \| `food_supplement` \| `clinic_protocol` \| `unknown` |
| `accepts_eft` | boolean \| null | no | |
| `notes` | string | no | Operational, not promotional |
| `status` | enum | yes | `active` \| `down` \| `excluded` |

### 3.4 `products[]` (compound × provider × form)

This is the join table the UI will filter on.

| Field | Type | Required | Notes |
| --- | --- | --- | --- |
| `id` | string | yes | `{provider}-{compound}-{form}-{strength}` |
| `compound_id` | string | yes | Must exist |
| `provider_id` | string | yes | Must exist |
| `product_url` | string (URI) | yes | Canonical product page |
| `title_on_page` | string | yes | Verbatim shop title |
| `form` | enum | yes | `lyophilized_vial` \| `prefilled_pen` \| `cartridge` \| `nasal_spray` \| `capsule` \| `tablet` \| `powder` \| `topical` \| `blend` |
| `route` | Route | yes | |
| `strength` | string | yes | As printed, e.g. `"10 mg"` |
| `pack_size` | string \| null | no | e.g. `"4 ml"`, `"30 caps"` |
| `price_zar` | number \| null | no | Integer cents optional later. v1: rand as number. Null if login-gated |
| `price_visible_without_login` | boolean | yes | |
| `in_stock` | boolean \| null | no | As of `last_reviewed_at` |
| `coa_url` | string \| null | no | |
| `blend_compound_ids` | string[] | no | If `form` is `blend` |
| `vendor_claim_quote` | string \| null | no | Short quote. Never rewrite as fact |

### 3.5 `stacks[]` (later)

Empty in v1 except schema. Do not invent "best stacks".

| Field | Type | Required | Notes |
| --- | --- | --- | --- |
| `id` | string | yes | |
| `name` | string | yes | Vendor name in quotes if copied, e.g. `"Wolverine"` |
| `compound_ids` | string[] | yes | |
| `origin` | enum | yes | `vendor_named` \| `commonly_reported` \| `user_saved` |
| `reported_use` | string | no | With sources |
| `sources` | Source[] | yes | |

### 3.6 Refresh strategy by field group

| Data | Who updates | How | Cadence (v1) |
| --- | --- | --- | --- |
| Compound identity, CAS, sequence | Agent research | PubMed / PMC OA / Wikipedia jump-off, then primary paper | On add; review yearly |
| Research uses and reported protocols | Agent research | Cite papers. Never copy vendor dosing as truth | On add; review when SAHPRA or a major paper changes |
| SAHPRA / WADA flags | Agent research | Re-fetch official pages | Quarterly, or on news |
| Provider existence, city, script flag | Agent research + manual | Fetch homepage and contact. Mark `down` if 404 | Quarterly |
| Product price, stock, form | Agent research (manual first) | Fetch product URL. Record `last_reviewed_at`. **No live scrape farm in v1** | Monthly for core SKUs |
| Vendor claims | Quote only | Copy a short quote + URL | With product refresh |
| User stacks | Later, accounts | Not in v1 JSON | n/a |

**Do not** scrape paywalled Examine content. **Do not** bulk-download PMC. **Do not** invent prices when login-gated (The Clinic).

---

## 4. Refresh / capture for Grok agents

### 4.1 File layout under `data/`

```
data/
  README.md                 # how to add a record (short)
  schema/
    source.schema.json
    compound.schema.json
    provider.schema.json
    product.schema.json
    stack.schema.json
  compounds/
    bpc-157.json
    tb-500.json
    noopept.json
    ...
  providers/
    reschem.json
    biopeptics.json
    ...
  products/
    reschem-bpc-157-tb500-pen.json
    ...
  stacks/                   # empty in v1 except .gitkeep
  _templates/
    compound.json
    provider.json
    product.json
```

One record per file. Rails can glob JSON. Git diffs stay readable.

### 4.2 How to add a compound without breaking schema

1. Copy `data/_templates/compound.json`.
2. Set `id` to a new kebab slug. Do not reuse a retired id.
3. Fill required fields. Put `null` or `[]` rather than deleting keys.
4. Add at least one `sources[]` entry with `url` and `accessed_at`.
5. Set `last_reviewed_at` to today (`YYYY-MM-DD`).
6. Run the schema check (to be added: JSON Schema via a rake task). Do not merge if invalid.
7. If a product exists, add `data/products/{provider}-{compound}-….json` that points at this `id`.
8. Never put price on the compound file.

### 4.3 How to add a provider

1. Confirm the site is live. If 404, do not add, or add with `"status": "down"` and `confidence: "unverified"`.
2. Record only facts on the page: name, URL, city, forms, script step, currency.
3. Quote marketing in `notes` or leave it off. Do not paraphrase efficacy.
4. Set `prescription_required` from the checkout/consult flow, not from guesswork.

### 4.4 `last_reviewed_at` rule

- Touch the date only when the agent opened the cited URL (or a replacement official URL) in that session.
- If a price or stock field changes, bump `last_reviewed_at` on that product file only.
- Stale rule for UI: if `last_reviewed_at` is older than 90 days, show "needs review".

### 4.5 Citation rule

- Compound `summary` and `research_uses` cite `regulator` or `primary_literature` (or `review`). Vendor URLs are not enough.
- Product files may cite `vendor` sources.
- Wikipedia is a jump-off. If used, set `kind: encyclopedia` and add a primary source before publish.
- Protocols go in `reported_protocols` with the UI string **commonly reported research protocols**.

### 4.6 v1 load order

Suggested first JSON drop (all seen live on 2026-08-25):

1. Providers: `reschem`, `biopeptics`, `tetratide-labs`, `the-clinic`, `comp-pharm`, `alphahuman`, `neuroactive`, `primeself`.
2. Compounds: `bpc-157`, `tb-500`, `semax`, `selank`, `ghk-cu`, `noopept`.
3. Products: only SKUs with a live URL and a visible form. Skip login-gated prices (`price_zar: null`).

---

## 5. Open gaps

- Comp Pharm: confirm whether the public peptide table is orderable without a script, versus Gold practitioner-only.
- RPSA (`peptides.co.za` / `researchpeptides.co.za`): city and full SKU list still thin.
- BioPeptics and The Clinic: city not on fetched pages.
- AlphaHuman: physical clinic city not confirmed.
- Examine.com ToS not retrieved (bot wall). Treat as link-only until a human opens the terms.
- No local compound notes to import. Catalog starts from this inventory plus live URLs.

---

## Changelog

- 2026-08-25: First scout inventory. Local notes: none. Live SA providers and SAHPRA/WADA sources recorded. JSON shape proposed.
