---
title: Agent research workflow - Plan
type: feat
date: 2026-08-30
artifact_contract: ce-unified-plan/v1
artifact_readiness: implementation-ready
product_contract_source: legacy-requirements
execution: knowledge-work
origin: docs/EPICS.md
---

# Agent research workflow - Plan

## Goal Capsule

- **Objective:** A new agent can add or refresh a catalog file from the readme alone, with the merge check as the only gate, and with bans and citation rules written down.
- **Authority:** `docs/PRD.md` F-17, `docs/EPICS.md` EP-07, GitHub `#51` `#58` `#59` `#61` `#62` `#63` `#64`.
- **In scope:** `data/README.md`, a short grade-review checklist, a pointer at `bin/rails catalog:check`, bans on scrape farms and Examine.com scraping.
- **Out of scope:** Building compound UI. A live scrape job. Hosting COA files. Translations. The vendor-only validator itself (`#47` has its own plan).
- **Stop when:** A new agent can add a compound from the readme. Invalid JSON, missing date, or empty sources fail the documented check. Vendor-only summaries are documented as invalid. No scrape farm is in the repo.
- **Execution profile:** Documentation plus a small curator checklist. Almost no Ruby unless the readme would lie about a command.

---

## Product Contract

### Summary

Phase 1 already has `data/README.md`, templates, schemas, and `bin/rails catalog:check`. EP-07 is the written loop so later agents do not guess, inflate grades, or copy vendor dosing. Most of the how-to already exists. This plan fills the gaps named in the open stories: citation rules, first-drop order, bans, human grade review, and an explicit pointer that the EP-01 merge check is the gate.

### Problem Frame

There is no local catalog to import beyond the first drop. The next 20 to 40 compounds need honest citations. Agents must not guess, inflate grades, or treat vendor dosing as truth. A written loop is the audit trail.

### Requirements

- R1. The catalog readme states: copy a template, keep keys, add sources, set the date to the day the URL was opened, run the check (`#58`).
- R2. Citation rules: compound summary needs regulator or literature sources; vendor URLs are for products only (`#59`).
- R3. First-drop order and the "open the URL in session, do not guess" rule are written (`#61`).
- R4. Bans are explicit: no live scrape farm, no bulk PMC download, no Examine.com scrape (`#62`).
- R5. A human review pass exists for evidence grades before publish (`#63`).
- R6. The loop points at the EP-01 merge check (`bin/rails catalog:check` / CI) as the gate (`#64`).

### Actors

- A1. David as curator.
- A2. An agent adding or refreshing JSON.

### Key Flows

- F1. Agent adds a compound from the readme
  - **Steps:** Copy template, keep keys, open sources, set dates, run check, do not merge on failure.
  - **Outcome:** File is valid or the check names the error.
- F2. Curator reviews a grade before publish
  - **Outcome:** Checklist is filled. Grade is not raised without a source that supports it.

### Acceptance Examples

- AE1. Covers R1, R6. Given only `data/README.md`, an agent finds the copy-template steps and the exact check command.
- AE2. Covers R2, R4. Readme says vendor-only summaries are invalid, and names the three bans.
- AE3. Covers R5. A grade-review checklist exists and says a human can block grade inflation.

### Scope Boundaries

- **In:** `data/README.md`, `docs/research/grade-review.md` (new), maybe one line in `STATUS.md` pointing at the loop.
- **Deferred:** Automating the grade checklist in CI. Tightening validator vendor-only rule is `#47`, not this plan. If `#47` has already landed, the readme should describe the live behaviour, not a future one.
- **Outside this product's identity:** Scrape farm. Bulk PMC mirror. Examine.com scrape. Paid ranking.

---

## Planning Contract

### Key Technical Decisions

- KTD1. **Keep one operator readme.** Expand `data/README.md` rather than adding a second "agent handbook" that will drift. Link out only for the grade checklist.
- KTD2. **Human review is a markdown checklist, not an app.** `docs/research/grade-review.md` is filled in git when a grade is set or raised. No Rails admin. No extra JSON key unless `#47` / schema work already needs it. Avoid a new `human_reviewed` field in this plan (schema change would force a rewrite of every compound file).
- KTD3. **Point at the real command.** Document `bin/rails catalog:check`. `config/ci.rb` already runs that step as `Catalog: JSON merge check`. Do not document a fictional `bin/catalog-validate`. Do not add a second workflow job that duplicates `bin/ci`.
- KTD4. **First-drop history stays the scout list.** Scout §4.6 and the current readme list providers first, then compounds, then products only where form is visible. New work after that drop still requires a compound file before its product file. Do not rewrite history as compounds-then-providers.
- KTD5. **Bans are a titled section.** A later agent grepping "Examine.com" or "scrape" must hit a hard no.

### Assumptions

- `data/README.md` already covers layout, add-compound, add-provider, add-product, and a short "rules that fail a future merge check" list. This plan tightens wording ("future" is now the live rake task) and adds the missing stories.
- No scrape code exists in the app today. The ban is preventative.

### Sequencing

U1 readme expansion (includes the live `config/ci.rb` gate). U2 grade-review checklist.

---

## Implementation Units

### U1. Expand the catalog readme into the operator loop

- **Goal:** The readme is enough to add a cited compound without reading chat history.
- **Requirements:** R1, R2, R3, R4, R6
- **Dependencies:** none
- **Files:**
  - modify: `data/README.md`
- **Approach:** Keep the existing layout table. Rewrite "Rules that fail a future merge check" to "Rules that fail `bin/rails catalog:check`". Add sections: Citation rules (summary vs product), Open the URL (no guessed dates), First-drop order (scout history: providers, then compounds, then products; ongoing rule: compound file before product file), Bans (scrape farm, bulk PMC, Examine.com scrape; Examine.com remains link-out only), Gate (local `bin/rails catalog:check`; `config/ci.rb` step `Catalog: JSON merge check`; GitHub Actions still runs `bin/rails test`, which includes `CatalogValidatorTest` live JSON). State that Wikipedia is encyclopedia kind and needs a primary source before publish. State that amounts are commonly reported research protocols, never instructions.
- **Patterns to follow:** Current short numbered how-to lists. AGENTS.md hard rules. Do not paste the whole PRD.
- **Test scenarios:**
  - Test expectation: none as behaviour code. Verification is a checklist read: each of R1 R2 R3 R4 R6 has a heading or numbered step a stranger can find.
  - If `#47` already enforces vendor-only failure, the readme must say the check fails, not "should fail later".
- **Verification:** Read the file end to end. Every EP-07 story except `#63` is present. README names `bin/rails catalog:check` and `config/ci.rb`.

### U2. Human evidence-grade review checklist

- **Goal:** A curator can block grade inflation in git before publish.
- **Requirements:** R5
- **Dependencies:** U1
- **Files:**
  - create: `docs/research/grade-review.md`
  - modify: `data/README.md` (link to the checklist)
- **Approach:** One table: compound id, proposed grade, supporting source URL, opened-on date, curator yes/no, notes. Seed rows for the six starter compounds with the grades already shipped so the format is obvious. Instructions: do not raise a grade without a source opened in that session; anecdotal is the default when papers are only rodent; registered_medicine requires a SAHPRA registration number. No star rating.
- **Patterns to follow:** `docs/loops/INDEX-phase-1.md` assumed-defaults style: short, numbered, no jargon stacks.
- **Test scenarios:**
  - Covers AE3. File exists and states that a human can block a grade raise.
  - Starter six are listed so the next compound has a row shape to copy.
- **Verification:** Link from README resolves. Table has a header row and the six ids.

---

## Verification Contract

| Gate | Command | Proves |
| --- | --- | --- |
| Merge check still works | `bin/rails catalog:check` | Live files valid |
| Validator tests | `bin/rails test test/models/catalog_validator_test.rb` | Empty sources still fail |
| Docs | Read `data/README.md` and `docs/research/grade-review.md` | R1 to R6 visible without the PRD |
| Local CI | `config/ci.rb` step `Catalog: JSON merge check` | Same command as the readme |
| GitHub Actions | `bin/rails test` includes `CatalogValidatorTest` live JSON | Remote suite still rejects invalid catalog files |

This plan is documentation-first. `config/ci.rb` already runs `bin/rails catalog:check`. U1 documents that fact. It does not add a second checker.

---

## Definition of Done

- `#51` stories `#58` `#59` `#61` `#62` `#63` `#64` are covered.
- A new agent can add a compound from `data/README.md` alone.
- Bans are greppable. Citation rules distinguish summary vs product.
- Human grade checklist exists in git.
- No scrape farm, no Examine.com scrape code, no bulk PMC downloader.

---

## Risks and Dependencies

- **Drift with `#47`.** If the vendor-only validator lands first, U1 must describe current failure, not hoped-for failure. If this plan lands first, say the readme rule is already policy and the checker tightening is `#47`.
- **Depends on:** EP-01 merge check (already shipped). Can run in parallel with EP-04 and EP-05 UI work.
