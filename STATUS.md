# Peptides research South Africa — project status

## Last session handoff

**What this is:** A public South Africa research catalog for peptides, nootropics, and local providers.
**What we finished:** Phase 1 catalog data and screens: six compounds, 38 listings, import, disclaimer, browse pages.
**What you do next:** Start Phase 2 search, filters, and SAHPRA/WADA stamps. `#47` is still open.

_Last updated: 2026-08-26. Read this, then [AGENTS.md](AGENTS.md) and the `docs/` suite._

This is a research catalog. It is not a clinic. It is not a pharmacy. Public name is TBD (candidates: PeptideSA, SourceSA, Compound Index).

## Where we are

**Phase 1 Honest catalog is in the app.** Loop: `docs/loops/INDEX-phase-1.md`. Phase 2 search and flags are next.

| Board item | State |
| --- | --- |
| **Phase 1 · Honest catalog** | Compounds, providers, listings, import, and browse screens are on `main`. |
| **EP-01 Foundation** | JSON check, import, nav, and disclaimer are in. `#47` vendor-only summary gate is still open. |
| **EP-02 Compound catalog** | Six cited compounds with index and detail pages. Card stamp waits for Phase 2. |
| **EP-03 Providers and products** | Eight providers, 38 live listings, provider pages. Comparison table waits for Phase 2. |
| **EP-04 to EP-09** | Planned only. See [docs/EPICS.md](docs/EPICS.md). |
| **Phase 2 to Phase 5** | Planned only. See [docs/ROADMAP.md](docs/ROADMAP.md). |

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

1. Browse the catalog locally with `bin/dev`.
2. Start Phase 2: alias search, filters, SAHPRA and WADA stamps (`#47` is still open from Phase 1).

Tracker: this file plus GitHub issues and milestones. Do not invent private IDs.
