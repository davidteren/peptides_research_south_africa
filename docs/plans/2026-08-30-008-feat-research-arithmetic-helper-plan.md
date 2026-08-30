---
title: Labelled research arithmetic helper - Plan
type: feat
date: 2026-08-30
artifact_contract: ce-unified-plan/v1
artifact_readiness: implementation-ready
product_contract_source: legacy-requirements
execution: code
origin: docs/EPICS.md
---

# Labelled research arithmetic helper - Plan

## Goal Capsule

- **Objective:** A researcher types vial milligrams, diluent millilitres, and syringe units, and sees micrograms per unit. The page does not choose a dose.
- **Authority:** `docs/PRD.md` F-20, `docs/EPICS.md` EP-08 Phase 5 exception, GitHub `#76` `#77`.
- **In scope:** One labelled calculator page. User-typed numbers only. Locale title that says research arithmetic, not a dose, not a protocol.
- **Out of scope:** Prefill from `reported_protocols`. Body weight. Indication. Injection-site diagram. Vendor water link. Stack checker (plan 007).
- **Stop when:** The helper converts the three typed inputs to mcg per unit. Compound protocol amounts stay on the compound page as cited notes only.
- **Execution profile:** Phase 5 work. U1 (pure maths) may land early. Do not merge the public page (U2) until plan 007 `/stacks/check` is on `main`. Thin GET form. No catalog JSON writes.

---

## Product Contract

### Summary

The stack checker must exist first so this page is not the only "math next to peptides" surface. This helper is unit maths. It never reads a compound record.

### Problem Frame

A calculator next to an injectable peptide looks like a clinic if it ships before the catalog is trusted, or if it pre-fills a research protocol as if it were a dose.

### Requirements

- R1. Add a labelled arithmetic helper: vial milligrams, diluent millilitres, and syringe units in; amount per unit out (`#76`).
- R2. Do not pre-fill the helper from reported protocols. No body weight, no indication, no injection-site diagram, no vendor water link (`#77`).

### Actors

- A1. Researcher who already has vial, diluent, and syringe numbers.

### Key Flows

- F1. Open `/research-arithmetic`, type 5 mg, 2 ml, 100 units, submit
  - **Outcome:** `#arithmetic-result` shows 25 mcg per unit (see formula). Title still says research arithmetic, not a dose.
- F2. Open the helper from a compound page (if linked)
  - **Outcome:** Fields are empty. No protocol amount is copied.

### Acceptance Examples

- AE1. Covers R1. Given inputs 5, 2, 100, the result is 25 mcg per unit.
- AE2. Covers R2. The page has no hidden field or query param that reads `reported_protocols`. Compound show does not pass amounts into the helper URL.

### Scope Boundaries

- **In:** One public GET page and a small pure-Ruby calculator object.
- **Deferred:** Saving a calculation to an account.
- **Outside this product's identity:** Dosing advice. Protocol generator.

---

## Planning Contract

### Key Technical Decisions

- KTD1. **Ship after plan 007.** This plan is implementation-ready but sequenced behind the stack checker. Do not merge the helper while `/stacks/check` is missing.
- KTD2. **Formula (authoritative).** Syringe units means units that equal one millilitre (insulin-style 100 units = 1 ml).
  - `mcg_per_unit = (vial_mg * 1000) / (diluent_ml * units_per_ml)`
  - Example: 5 mg, 2 ml, 100 units/ml → 25 mcg per unit.
  - Document the formula on the page as research arithmetic, not a protocol.
- KTD3. **`Catalog::Arithmetic` in `lib/catalog/arithmetic.rb`.** Pure function. No Compound lookup. Invalid or non-positive inputs return an error struct, not zero.
- KTD4. **GET form to `/research-arithmetic`.** Shareable URL with query params is allowed. Still do not accept a `compound_id` param that pre-fills amounts. If `compound_id` is present, ignore it for numbers.
- KTD5. **No Stimulus required.** Server renders the result. Locale title: "Research arithmetic (not a dose, not a protocol)".
- KTD6. **Nav is the only entry in this plan.** Add `#site-nav-arithmetic`. Do not add a link on compound show. That keeps the helper away from injectable protocol copy.

### Assumptions

- Phase 4 stack UI is live before this work starts.
- Users know their syringe scale. The page states that 100 units = 1 ml is the usual insulin syringe scale and is not medical advice.

### Sequencing

U1 calculator object, U2 page and locale, U3 tests. Do not merge U2 until 007 is on `main`.

---

## Implementation Units

### U1. Arithmetic object

- **Goal:** Deterministic mcg per unit from three positive numbers.
- **Requirements:** R1, R2
- **Dependencies:** none
- **Files:**
  - create: `lib/catalog/arithmetic.rb`
  - create: `test/models/catalog_arithmetic_test.rb`
- **Approach:** `Catalog::Arithmetic.mcg_per_unit(vial_mg:, diluent_ml:, units_per_ml:)`. Reject nil, zero, negative, and non-numeric strings. Return an error struct, never zero. Do not read ActiveRecord.
- **Test scenarios:**
  - Covers AE1. 5, 2, 100 → 25.
  - 10, 1, 100 → 100.
  - Zero, negative, or non-numeric returns error, not a number.
- **Verification:** Unit tests only.

### U2. Public helper page

- **Goal:** Typed inputs in, labelled result out, empty defaults.
- **Requirements:** R1, R2
- **Dependencies:** U1, plan 007 on main
- **Files:**
  - create: `app/controllers/research_arithmetic_controller.rb`
  - create: `app/views/research_arithmetic/show.html.erb`
  - modify: `config/routes.rb`
  - modify: `app/views/layouts/application.html.erb`
  - modify: `config/locales/en.yml`
- **Approach:** Three states: empty GET shows empty fields; valid params show `#arithmetic-result` and keep `#arithmetic-error` absent; invalid params show `#arithmetic-error` and do not render a number (never 0). Fields `#arithmetic-vial-mg`, `#arithmetic-diluent-ml`, `#arithmetic-units-per-ml` have visible labels. Submit `#arithmetic-submit`. `#arithmetic-formula` states the formula and that 100 units = 1 ml is the usual insulin syringe scale, not medical advice. Render the existing disclaimer partial (`#catalog-disclaimer`). Nav link `#site-nav-arithmetic` only. Do not mention BAC water. Do not show body-weight inputs.
- **Patterns to follow:** Stack checker GET form. Locale-only English.
- **Test scenarios:**
  - Covers AE2. GET `/research-arithmetic` has empty fields.
  - GET with the three params shows `#arithmetic-result` 25 for the example.
  - GET with zero or non-numeric params shows `#arithmetic-error` and no numeric result.
  - GET with `compound_id=bpc-157` still has empty numeric fields.
  - Page includes `#arithmetic-formula` and `#catalog-disclaimer`.
  - Page title/h1 uses the not-a-dose locale string.
- **Verification:** Integration test.

### U3. Playwright for empty defaults and result

- **Goal:** Browser proof that protocols do not pre-fill.
- **Requirements:** R2
- **Dependencies:** U2. Playwright scaffold from plan 001.
- **Files:**
  - create: `e2e/research-arithmetic.spec.ts`
- **Approach:** Visit helper, assert empty inputs, fill 5/2/100, submit, assert `#arithmetic-result`. Visit a compound page then the helper and assert fields still empty.
- **Test scenarios:**
  - Empty on first load.
  - Example maths.
  - No prefill after visiting BPC-157.
- **Verification:** Playwright. Not added to `bin/ci` in this plan.

---

## Verification Contract

| Gate | Command | Proves |
| --- | --- | --- |
| Maths | `bin/rails test test/models/catalog_arithmetic_test.rb` | Formula |
| Page | `bin/rails test` integration for the helper | Empty defaults, ignore compound_id |
| Browser | `npx playwright test e2e/research-arithmetic.spec.ts` | No protocol prefill |

---

## Definition of Done

- `#76` and `#77` are covered.
- Title states research arithmetic, not a dose, not a protocol.
- Helper never reads `reported_protocols`.
- No body weight, indication, injection diagram, or vendor water link.

---

## Risks and Dependencies

- **Looks like a clinic if linked under an injectable heading.** Keep it in nav or a tools area, not inside protocols.
- **Depends on:** Plan 007 stack checker on `main` before U2. Independent of accounts.
