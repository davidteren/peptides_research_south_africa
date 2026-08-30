# Loop worklist — Phase 2 plans

type: task
gate: each plan is implementation-ready, reviewed with ce-doc-review (headless) and ie-validate-plan, then committed on main
branch: main (AGENTS.md: Phase 1 to Phase 3 commit to main; plans are docs only)
merge-policy: commit to main after each reviewed plan
serial: true
decisions: see Assumed defaults

This is the runbook for writing implementation plans. It does not implement app code.

**Stop when:** plans exist for EP-04, EP-05, leftover Phase 2 work in EP-01 / EP-02 / EP-03, and EP-07. Do not start ce-work in this loop.

**Stop on red:** a plan that still has a blocking product or architecture question. Revise that plan. Do not continue.

## Assumed defaults

- Scope this loop → write plans only, not screens or JSON. Override: say "start building".
- Git → commit to `main`. Override: say "use a branch".
- One epic-shaped plan per commit is allowed. Related leftover stories may share a plan.
- Issues stay open until implementation. Plans cite issue numbers; they do not close tickets.
- No checkout, no "legal to buy", no hosted COA PDFs, no protocol, no AI stack generator.
- Review each plan with ce-doc-review (headless) then ie-validate-plan. Fix blocking gaps before the next plan.

## Board

- [x] P2-PLAN-01 · EP-04 Legal and athlete flags · `#7` `#9` `#10` `#11` `#13` `#15` `#18` `#21` · status:done · result: `docs/plans/2026-08-30-001-feat-legal-athlete-flags-plan.md`
- [x] P2-PLAN-02 · EP-05 Search, browse, last-verified · `#6` `#17` `#20` `#23` `#24` `#28` `#30` `#31` `#33` · status:done · result: `docs/plans/2026-08-30-002-feat-search-browse-verified-plan.md`
- [x] P2-PLAN-03 · Vendor-only summary gate and evidence-grade stamp · `#47` `#49` · status:done · result: `docs/plans/2026-08-30-003-feat-vendor-gate-and-evidence-stamp-plan.md`
- [x] P2-PLAN-04 · Comparison table and COA-stated flag · `#37` `#39` · status:done · result: `docs/plans/2026-08-30-004-feat-comparison-table-and-coa-plan.md`
- [x] P2-PLAN-05 · EP-07 Agent research workflow · `#51` `#58` `#59` `#61` `#62` `#63` `#64` · status:done · result: `docs/plans/2026-08-30-005-feat-agent-research-workflow-plan.md`

Do not plan in this loop: EP-06 PWA (`#56`), EP-08 stacks (`#60`), EP-09 accounts (`#50`), F-20 arithmetic helper (`#76` `#77`).

## How to run one item

1. Read this file, `docs/EPICS.md`, `docs/PRD.md`, and the cited GitHub issues.
2. Write `docs/plans/YYYY-MM-DD-NNN-feat-<name>-plan.md` with ce-plan structure.
3. Review with ce-doc-review (headless) and ie-validate-plan.
4. Fix blocking findings in the plan.
5. Commit on `main`. Tick the box. Update `STATUS.md` handoff.
6. Next unchecked item.

## Changelog

- 2026-08-30: Five plans written, reviewed (ce-doc-review + ie-validate-plan), and ready to implement. Implementation waits for a later loop.
- 2026-08-30: First Phase 2 planning runbook. Plans only. Implementation waits for a later loop.
