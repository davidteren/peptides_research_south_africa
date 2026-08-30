# Peptides research South Africa — project status

## Last session handoff

**What this is:** A public South Africa research catalog for peptides, nootropics, and local providers.
**What we finished:** Compound browse now has alias search, filter chips, and Checked / needs-review stamps.
**What you do next:** Build the vendor-only summary gate and evidence stamp from plan 003. `#47`

_Last updated: 2026-08-30. Read this, then [AGENTS.md](AGENTS.md) and the `docs/` suite._

This is a research catalog. It is not a clinic. It is not a pharmacy. Public name is TBD (candidates: PeptideSA, SourceSA, Compound Index).

## Where we are

**Phase 1 Honest catalog is in the app.** Loop: `docs/loops/INDEX-phase-1.md`. Phase 2 search and flags are next.

| Board item | State |
| --- | --- |
| **Phase 1 · Honest catalog** | Compounds, providers, listings, import, and browse screens are on `main`. |
| **EP-01 Foundation** | JSON check, import, nav, and disclaimer are in. `#47` vendor-only summary gate has a plan (2026-08-30-003). |
| **EP-02 Compound catalog** | Six cited compounds with index and detail pages. Card stamp `#49` and `#47` share plan 2026-08-30-003. |
| **EP-03 Providers and products** | Eight providers, 38 live listings, provider pages. Comparison `#37` and COA `#39` share plan 2026-08-30-004. |
| **EP-04 Legal and athlete flags** | Flags on compound pages (plan 001). Stories `#9` `#10` `#11` `#13` `#15` `#18` `#21`. |
| **EP-05 Search, browse, last-verified** | Search, chips, and Checked stamps are on `main` (plan 002). |
| **EP-07 Agent research workflow** | Plan ready: [2026-08-30-005](docs/plans/2026-08-30-005-feat-agent-research-workflow-plan.md). |
| **EP-06 PWA and device-local saves** | Plan ready: [2026-08-30-006](docs/plans/2026-08-30-006-feat-pwa-and-device-saves-plan.md). |
| **EP-08 Stacks** | Phase 4 plan: [2026-08-30-007](docs/plans/2026-08-30-007-feat-stack-checker-and-named-stacks-plan.md). F-20 helper: [2026-08-30-008](docs/plans/2026-08-30-008-feat-research-arithmetic-helper-plan.md). |
| **EP-09 Accounts and native wrapper** | Plan ready: [2026-08-30-009](docs/plans/2026-08-30-009-feat-accounts-and-native-wrapper-plan.md). Native unit waits for EP-06. |
| **Phase 2 to Phase 5** | How-to lives in `docs/plans/`. Sequence still [docs/ROADMAP.md](docs/ROADMAP.md). |

Repo: public GitHub [`davidteren/peptides_research_south_africa`](https://github.com/davidteren/peptides_research_south_africa). Tracker: [issues](https://github.com/davidteren/peptides_research_south_africa/issues) and [milestones](https://github.com/davidteren/peptides_research_south_africa/milestones) (9 epics, 64 stories).

## Run / test

```sh
bin/setup --skip-server    # gems + PostgreSQL databases
bin/dev                    # http://localhost:3000
bin/rails test             # Minitest
bin/rubocop                # lint
```

Needs Ruby 3.4.9 (rbenv) and local PostgreSQL. `DB_HOST` is only for the contributor devcontainer. Local dev uses the socket.

## How work is done here (see AGENTS.md)

- Catalog facts live in `data/` JSON. Agents update files, not the database.
- Every compound `summary` needs a literature or regulator citation. Vendor copy is not enough.
- Typical amounts are **commonly reported research protocols**, never instructions.
- Chat may only use IDs from this board, the PRD (F-1 to F-23), the epics (EP-01 to EP-09), or the roadmap phases.

## What you do next

1. Search `BPC157` on the compounds page and read a Checked date.
2. Build the vendor-only gate and evidence stamp from plan 003 (`#47` `#49`).

Tracker: this file plus GitHub issues and milestones. Do not invent private IDs.
