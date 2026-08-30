# Loop worklist — later epic plans (Phase 3 to 5)

type: task
gate: each plan is implementation-ready, reviewed with ce-doc-review (headless) and ie-validate-plan, then committed on main
branch: main (plans are docs only)
merge-policy: commit to main after reviewed plans
serial: true
decisions: see Assumed defaults

This runbook writes implementation plans. It does not implement app code.

**Stop when:** plans exist for EP-06, EP-08 Phase 4, F-20 arithmetic helper, and EP-09. Do not start ce-work in this loop.

**Depends on:** `docs/loops/INDEX-phase-2-plans.md` (already done).

## Assumed defaults

- Scope this loop → write plans only. Override: say "start building".
- Git → commit to `main`.
- Issues stay open until implementation.
- No checkout, no "legal to buy", no hosted COA PDFs, no protocol, no AI stack generator, no web push.
- Query objects stay in `lib/catalog` next to `Importer` and `Validator`.
- Playwright specs reuse the scaffold in plan 001. Do not add a second config.
- Review each plan with ce-doc-review then ie-validate-plan.

## Board

- [x] LATER-PLAN-01 · EP-06 PWA and device-local saves · `#56` `#65` `#67` `#69` `#71` `#73` `#75` · status:done · result: `docs/plans/2026-08-30-006-feat-pwa-and-device-saves-plan.md`
- [x] LATER-PLAN-02 · EP-08 stack checker, named stacks, pair notes · `#60` `#66` `#68` `#70` `#72` `#74` · status:done · result: `docs/plans/2026-08-30-007-feat-stack-checker-and-named-stacks-plan.md`
- [x] LATER-PLAN-03 · F-20 labelled arithmetic helper · `#76` `#77` · status:done · result: `docs/plans/2026-08-30-008-feat-research-arithmetic-helper-plan.md`
- [x] LATER-PLAN-04 · EP-09 accounts and native wrapper · `#50` `#52` `#53` `#54` `#55` `#57` · status:done · result: `docs/plans/2026-08-30-009-feat-accounts-and-native-wrapper-plan.md`

## Changelog

- 2026-08-30: Four plans written and reviewed. Remaining GitHub story issues now have a how-to plan.
- 2026-08-30: Second planning loop for remaining epics after Phase 2 plans landed.
