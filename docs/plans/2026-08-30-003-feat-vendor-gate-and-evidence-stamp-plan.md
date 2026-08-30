---
title: Vendor-only summary gate and evidence-grade stamp - Plan
type: feat
date: 2026-08-30
artifact_contract: ce-unified-plan/v1
artifact_readiness: implementation-ready
product_contract_source: legacy-requirements
execution: code
origin: docs/EPICS.md
---

# Vendor-only summary gate and evidence-grade stamp - Plan

## Goal Capsule

- **Objective:** Fail merge when a compound summary rests on vendor or encyclopedia-only sources, and show the evidence grade as a card stamp.
- **Authority:** `docs/PRD.md` F-8 and F-2 citation rule, `docs/EPICS.md` EP-01 / EP-02, GitHub `#47` and `#49`.
- **In scope:** Validator rule for summary and research uses, card-level grade stamp with citations, tests.
- **Out of scope:** Search chips (EP-05). A fifth "promising" grade. Star ratings. Hosting Examine.com text.
- **Stop when:** Vendor-only and Wikipedia-only summaries cannot merge. Each compound card shows the stored grade as a stamp, not only as list text.
- **Execution profile:** Extend `Catalog::Validator`. Small view change on the compound index.

---

## Product Contract

### Summary

Phase 1 already lists evidence grade as a fact on the compound index and stores four grades on each file. `#47` is still open: the merge check does not yet reject a summary that cites only vendor pages. `#49` is the Phase 2 card stamp: the grade must sit on the card as stamp chrome, with citations, still only four grades.

### Problem Frame

Vendor copy is marketing. Using it as a summary turns the catalog into an advert. Listing the grade only as a footnote lets a card read like a shop tile.

### Requirements

**Vendor-only gate (`#47`)**

- R1. A compound whose summary sources are only `vendor` fails `Catalog::Validator` and cannot merge.
- R2. A compound whose `research_uses[]` cite only `vendor` sources fails validation.
- R3. A Wikipedia / `encyclopedia`-only summary without `regulator` or `primary_literature` fails validation.
- R4. Product records may still cite vendor pages for listing facts.
- R5. Examine.com prose is not copied into compound records. The validator does not scrape Examine.com.

**Card stamp (`#49`, F-8)**

- R6. The compound card shows the grade as a stamp (`#compound-stamp-<slug>`), not only as a list fact.
- R7. Citations sit with the stamp (at least one source title or PMID from the compound `sources`).
- R8. Only four grades: anecdotal, preclinical, early_human, registered_medicine. No fifth grade. No star rating of efficacy.

### Actors

- A1. Agent or curator adding a compound file.
- A2. Visitor scanning the compound index.

### Key Flows

- F1. Run `bin/rails catalog:check` on a compound whose `sources` are all `kind: vendor`
  - **Outcome:** Check fails. Import does not load that file.
- F2. Open `/compounds`
  - **Outcome:** Each card has a grade stamp and a citation, with no stars.

### Acceptance Examples

- AE1. Covers R1, R3. Given a temp compound with only vendor or only encyclopedia sources, `Catalog::Validator.check` is not ok.
- AE2. Covers R4. Given a product with vendor sources only, validator stays ok (other product rules passing).
- AE3. Covers R6, R7. Given the live catalog, `/compounds` includes `#compound-stamp-bpc-157` and a citation element, and the page has no star characters used as a rating.

### Scope Boundaries

- **In:** `lib/catalog/validator.rb`, validator tests, compound index card chrome, locale for stamp labels (reuse `grades.*`).
- **Deferred:** Human review pass UI for grade inflation (`#63` in EP-07). That is a written curator checklist, not this stamp.
- **Outside this product's identity:** Efficacy stars. "Promising" as a fifth grade. Hosting COA PDFs. Examine.com scrape.

---

## Planning Contract

### Key Technical Decisions

- KTD1. **Summary source set is the record-level `sources` array.** Summary is a string, not a nested object. R1 treats record `sources[].kind` as the summary citations. Require at least one `regulator` or `primary_literature`. `review` alone is not enough for the summary. `encyclopedia` and `vendor` and `news` are not enough.
- KTD2. **Each research use is checked on its own `sources`.** Empty `research_uses` is allowed. A present use must include at least one `regulator`, `primary_literature`, or `review`. Vendor-only uses fail. Encyclopedia-only uses fail.
- KTD3. **Do not parse Examine.com URLs as a hard fail unless they appear as the only summary source.** A link-out in `sources` with a stronger primary source is allowed. Copying Examine.com prose is a curator rule (EP-07), not a HTML-strip in the validator.
- KTD4. **Stamp is a `<p>` or `<span>` with a border, not a badge component library.** Reuse `evidence_grade_label`. Place it on `#compound-card-<slug>` as `#compound-stamp-<slug>` (visual primary). Keep the existing F-2 list fact as plain text. Citation as `#compound-stamp-citation-<slug>` using `primary_citation`: first `regulator` or `primary_literature` source, else first `review`. Prefer `pmid` in the citation text when present, else title. Do not pick encyclopedia or vendor for the stamp citation.
- KTD5. **Keep the existing list fact.** F-2 already prints grade on the card line. The stamp is extra chrome. Do not remove the list fact in this plan.

### Assumptions

- Live starter compounds already have literature sources. Tightening the validator will not fail `bin/rails catalog:check` on `main` data.
- `review` may support research uses because `#47` says a literature review may support research uses. It may not carry the summary alone.

### Sequencing

U1 validator rule, U2 stamp on index, U3 tests including Playwright for the stamp id.

---

## Implementation Units

### U1. Reject vendor-only and encyclopedia-only compound citations

- **Goal:** Merge check fails when summary sources lack regulator or primary literature, and when any present research use lacks regulator, primary literature, or review.
- **Requirements:** R1, R2, R3, R4, R5
- **Dependencies:** none
- **Files:**
  - modify: `lib/catalog/validator.rb`
  - modify: `test/models/catalog_validator_test.rb`
  - modify: `data/README.md` with one sentence that the merge check now enforces this rule
- **Approach:** After existing source presence checks, if type is compound, collect record-level `sources[].kind`. Fail unless the set includes `regulator` or `primary_literature` (`review` alone is not enough for the summary; add a test for that). For every present `research_uses[]` entry, require a `sources` array that includes `regulator`, `primary_literature`, or `review`. Empty or missing `sources` on a present use fails. Skip this rule for products and providers. In `data/README.md`, rename the fail-list to live `catalog:check` rules and add vendor-only or encyclopedia-only summaries, plus vendor-only research uses.
- **Execution note:** Add failing validator tests for vendor-only summary and encyclopedia-only summary before changing the checker.
- **Patterns to follow:** Existing `check_file` error strings that name the relative path and the field.
- **Test scenarios:**
  - Covers AE1. Vendor-only compound sources fail with a message that names summary sources.
  - Encyclopedia-only compound sources fail.
  - Compound with one `primary_literature` source plus vendor sources passes this rule.
  - Covers AE2. Product with only vendor sources still passes (given other keys valid).
  - Research use with only vendor sources fails. Research use with a `review` source passes.
  - Live catalog still passes `Catalog::Validator.check`.
- **Verification:** `bin/rails test test/models/catalog_validator_test.rb` and `bin/rails catalog:check`.

### U2. Card-level evidence-grade stamp

- **Goal:** Each compound card shows the grade as stamp chrome with a citation.
- **Requirements:** R6, R7, R8
- **Dependencies:** none
- **Files:**
  - modify: `app/views/compounds/index.html.erb`
  - modify: `app/helpers/application_helper.rb`
  - modify: `config/locales/en.yml`
  - modify: `test/integration/catalog_browse_test.rb`
- **Approach:** Helper `primary_citation(compound)` returns the first payload source whose kind is `regulator` or `primary_literature` (fallback: first `review`). Render stamp and citation inside the existing `<li id="compound-card-...">`. Add locale key `compounds.stamp_citation` for the caption around that source. Do not use star characters or a numeric score. Grade values still come from `evidence_grade` and `grades.*` locale keys.
- **Patterns to follow:** Current card markup in `app/views/compounds/index.html.erb`. `evidence_grade_label`.
- **Test scenarios:**
  - Covers AE3. Index includes `#compound-stamp-bpc-157` and `#compound-stamp-citation-bpc-157`.
  - Stamp text uses Preclinical for BPC-157, not a fifth label.
  - Page body does not include a star-rating widget (assert no `data-testid="efficacy-stars"`).
- **Verification:** Integration test on ids. Visual check that the stamp is on the card, not only in a footer.

### U3. Playwright for the stamp

- **Goal:** Browser proof that the stamp id exists on the index.
- **Requirements:** R6, R7
- **Dependencies:** U2. Playwright scaffold from `docs/plans/2026-08-30-001-feat-legal-athlete-flags-plan.md` U4 (`package.json`, `e2e/playwright.config.ts`). If that scaffold is missing when this unit starts, create it using that plan's U4 rather than inventing a second config.
- **Files:**
  - create: `e2e/compound-stamp.spec.ts`
- **Approach:** Visit `/compounds`. Assert `#compound-stamp-bpc-157` and `#compound-stamp-citation-bpc-157`. Ids only.
- **Patterns to follow:** `e2e/compound-legal-flags.spec.ts` if present.
- **Test scenarios:**
  - Index shows the BPC-157 stamp id.
- **Verification:** `npx playwright test e2e/compound-stamp.spec.ts`.

---

## Verification Contract

| Gate | Command | Proves |
| --- | --- | --- |
| Validator | `bin/rails test test/models/catalog_validator_test.rb` | Vendor-only and encyclopedia-only fail |
| Merge check | `bin/rails catalog:check` | Live files still pass |
| Index | `bin/rails test test/integration/catalog_browse_test.rb` | Stamp ids |
| Full suite | `bin/rails test` | No import regression |
| Lint | `bin/rubocop` | Style |
| Browser | `npx playwright test` | Stamp visible by id |

---

## Definition of Done

- `#47` acceptance boxes are met by U1.
- `#49` acceptance is met by U2 and U3.
- Four grades only. No stars. No promising grade.
- Products may still use vendor sources.
- `data/README.md` states that vendor-only summaries fail the merge check.

---

## Risks and Dependencies

- **False fail on live data:** Run `catalog:check` before commit. If a starter file is vendor-heavy, fix that file in the same commit with a literature source already used in the summary text. Do not weaken the rule.
- **Depends on:** Phase 1 validator and compound index. Independent of search (EP-05) and legal flags (EP-04).
