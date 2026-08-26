# Loop worklist — Phase 1 Honest catalog

type: task
gate: JSON files parse; compound/provider/product records keep required keys; `bin/rails test` green after any Ruby change
branch: main (AGENTS.md: Phase 1 to Phase 3 commit to main)
merge-policy: push main after each green item
serial: true for app code; parallel allowed for independent compound JSON
decisions: see Assumed defaults

This is the runbook. Work the first unchecked, dependency-ready item. Tick it. Report. Continue until stop.

**Stop when:** Phase 1 exit is true: a person can read six cited compounds, eight providers, visible-form product rows, a disclaimer, and empty-honest catalog screens. Do not start Phase 2 search, COA UI, or stacks.

**Stop on red:** invalid JSON, missing citations on a compound summary, or a red test suite. Revert that item. Log. Do not continue.

## Assumed defaults

- Scope this loop → Phase 1 Honest catalog only, not Phase 2 to 5. Override: say "keep going into Phase 2".
- Git → commit to `main` in small atomic commits (AGENTS.md). Override: say "use a branch".
- One compound JSON per commit. App stories may group if they are one screen.
- Citations → PubMed / PMC OA / SAHPRA / WADA. Vendor URLs are not enough for compound `summary`. Date every source `accessed_at` the day the URL was opened.
- Amounts → "commonly reported research protocols", never instructions. Do not invent a protocol if the paper does not state one; leave `reported_protocols` empty.
- No checkout, no "legal to buy", no hosted COA PDFs.
- Close GitHub issues with `Closes #N` when the commit finishes that story.

## Board (tick in this file and on GitHub)

- [x] P1-00 · Catalog folder layout · status:done · `#12` · result: bootstrap `0f6f5aa`
- [x] P1-01 · Compound JSON `bpc-157` · status:done · `#46` · result: cited preclinical, SAHPRA warning, WADA S0
- [x] P1-02 · Compound JSON `tb-500` · status:done · `#46` · result: cited preclinical, SAHPRA warning, WADA S2.3
- [x] P1-03 · Compound JSON `semax` · status:done · `#46` · result: cited early_human, SAHPRA warning, not named by WADA
- [x] P1-04 · Compound JSON `selank` · status:done · `#46` · result: cited early_human, SAHPRA warning, not named by WADA
- [x] P1-05 · Compound JSON `ghk-cu` · status:done · `#46` · result: cited early_human topical, not on SAHPRA peptide list
- [x] P1-06 · Compound JSON `noopept` · status:done · `#46` · result: cited early_human oral, not on SAHPRA peptide list
- [ ] P1-07 · Product rows where a live page shows a form · status:todo · `#41` `#43` · result:-
- [ ] P1-08 · Validate catalog JSON in CI / rake · status:todo · `#14` `#19` · result:-
- [ ] P1-09 · Import valid JSON into PostgreSQL · status:todo · `#16` · result:-
- [ ] P1-10 · Catalog nav and empty states · status:todo · `#22` · result:-
- [ ] P1-11 · Site-wide disclaimer + SAHPRA link · status:todo · `#25` `#27` `#29` · result:-
- [ ] P1-12 · Compound index and detail (Phase 1 only) · status:todo · `#38` `#40` `#42` `#44` `#45` `#47` `#48` · result:-
- [ ] P1-13 · Provider index and detail + listing rows · status:todo · `#32` `#34` `#35` `#36` · result:-

Do not do in this loop: `#49` card stamp, `#37` comparison table, `#39` COA UI, EP-04 to EP-09.

## How to run one item

1. Read this file and `data/README.md`.
2. Do the item. Open cited URLs in the session.
3. Gate: `python3 -c` parse of touched JSON; `bin/rails test` if Ruby changed.
4. Commit on `main`. Push. Close finished issues.
5. Tick the box here. Update `STATUS.md` handoff.
6. Next unchecked item.

## Compound research checklist (P1-01 to P1-06)

Copy `data/_templates/compound.json`. Keep every key.

Must include:

- Neutral `summary` with a literature or regulator source
- `evidence_grade` one of: `anecdotal`, `preclinical`, `early_human`, `registered_medicine`
- `sahpra` block; `on_unregistered_warning_list` true only if named on the SAHPRA peptide public page
- `wada` block; cite the 2026 list PDF or HTML; do not guess a class
- `last_reviewed_at` and `sources[].accessed_at` = the day URLs were opened
- `reviewer`: `grok`

SAHPRA warning names (checked 2026-08-26): BPC-157, TB-500, Melanotan II, CJC-1295, Ipamorelin, PT-141, AOD-9604, Selank, Semax.

WADA 2026 (official list): BPC-157 is named under S0. Thymosin-β4 and derivatives e.g. TB-500 are named under S2.3. Do not mark Semax, Selank, GHK-Cu, or Noopept prohibited unless the official list names them.

## Changelog

- 2026-08-26: First Phase 1 runbook. Assumed defaults from AGENTS.md. Loop started on starter compounds.
