# Peptides research South Africa — project status

## Last session handoff

**What this is:** A public South Africa research catalog for peptides, nootropics, and local providers.
**What we finished:** Phase 1 runbook plus six cited starter compound files.
**What you do next:** Add product rows where a live page shows a form, then build import and catalog screens. Phase 1 Honest catalog

_Last updated: 2026-08-25. Read this, then [AGENTS.md](AGENTS.md) and the `docs/` suite._

This is a research catalog. It is not a clinic. It is not a pharmacy. Public name is TBD (candidates: PeptideSA, SourceSA, Compound Index).

## Where we are

**Phase 1 is in progress.** Six cited compounds exist. Catalog screens are not built yet. Loop: `docs/loops/INDEX-phase-1.md`.

| Board item | State |
| --- | --- |
| **Phase 1 · Honest catalog** | Docs and JSON layout exist. App screens not built. |
| **EP-01 Foundation** | Rails 8.1.3.1 boots on PostgreSQL. Schema files exist. Import and disclaimer not built. |
| **EP-02 Compound catalog** | Six starter compound JSON files exist. Catalog screens not built. |
| **EP-03 Providers and products** | Eight provider files in `data/providers/`. No product listings yet. |
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

1. Fill `data/compounds/` for the six starter compounds, with citations.
2. Add product rows only where a live page shows a form.
3. Then build EP-01 import + disclaimer, then compound and provider pages.

Tracker: this file plus GitHub issues and milestones. Do not invent private IDs.
