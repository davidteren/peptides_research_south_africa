# Peptides research South Africa — project status

## Last session handoff

**What this is:** A private South Africa research catalog for peptides, nootropics, and local providers.
**What we finished:** Rails skeleton, planning docs, JSON schemas, and eight live provider files.
**What you do next:** Research the first six compounds into `data/compounds/` (BPC-157, TB-500, Semax, Selank, GHK-Cu, Noopept). Phase 1 Honest catalog

_Last updated: 2026-08-25. Read this, then [AGENTS.md](AGENTS.md) and the `docs/` suite._

This is a research catalog. It is not a clinic. It is not a pharmacy. Public name is TBD (candidates: PeptideSA, SourceSA, Compound Index).

## Where we are

**Bootstrap is done. Phase 1 has not started building the catalog screens.**

| Board item | State |
| --- | --- |
| **Phase 1 · Honest catalog** | Docs and JSON layout exist. App screens not built. |
| **EP-01 Foundation** | Rails 8.1.3.1 boots on PostgreSQL. Schema files exist. Import and disclaimer not built. |
| **EP-02 Compound catalog** | No compound JSON yet. Starter list is named, not researched. |
| **EP-03 Providers and products** | Eight provider files in `data/providers/`. No product listings yet. |
| **EP-04 to EP-09** | Planned only. See [docs/EPICS.md](docs/EPICS.md). |
| **Phase 2 to Phase 5** | Planned only. See [docs/ROADMAP.md](docs/ROADMAP.md). |

Repo: private GitHub `davidteren/peptides_research_south_africa` (created at bootstrap).

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

Tracker: this file plus GitHub issues once the tracker skill has run. Do not invent private IDs.
