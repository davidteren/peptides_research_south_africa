# Peptides research South Africa

Public name: TBD (candidates: PeptideSA, SourceSA, Compound Index).

**What.** A South Africa portal for people who research peptides, nootropics, and related compounds. It lists local providers, forms and routes (injectable, nasal, oral, topical), what each compound is, and commonly reported research use. Later it lets people check or save stacks.

**Why.** The facts sit on vendor sites, forums, and overseas databases. People in South Africa cannot easily compare who sells what, in what form, or what a compound is. SAHPRA's 2026 public peptide warning is the local context.

**How.** Structured JSON files in `data/` come first. Grok and other agents research public sources and update those files. A Rails 8 app then presents the catalog. Later: accounts, saved research, and a stack checker.

This is a research catalog. It is not a clinic. It is not a pharmacy. It is not medical advice.

## Status

**Bootstrap.** The Rails skeleton boots on PostgreSQL. Planning docs exist. Eight South African provider files exist in `data/providers/`. Compound research has not started. Work is tracked in [STATUS.md](STATUS.md) and in [docs/ROADMAP.md](docs/ROADMAP.md).

## Stack

- Rails 8.1.3.1 · Ruby 3.4.9 · Hotwire (Turbo + Stimulus) · Solid Queue, Solid Cache, Solid Cable
- PostgreSQL · Tailwind · importmap + Propshaft · PWA stubs (routes off until Phase 3)
- Docker present. Kamal is not in this repo yet.

## Getting started

You need **Ruby 3.4.9** (rbenv) and a local PostgreSQL server.

```sh
bin/setup   # gems, database, then boots the app
bin/dev     # (re)boots on http://localhost:3000
```

`bin/setup` starts the server unless you pass `--skip-server`.

```sh
bin/rails test    # Minitest
bin/rubocop       # lint
```

Playwright e2e lives in `e2e/` once catalog screens exist. Select elements by stable DOM id only. See [AGENTS.md](AGENTS.md).

## Catalog data

JSON in `data/` is the research source of truth. How to add a record: [data/README.md](data/README.md).

First provider drop (seen live 2026-08-25): Reschem, BioPeptics, Tetratide Labs, The Clinic, Comp Pharm, AlphaHuman, NeuroActive, PrimeSelf.

Starter compounds still to research: BPC-157, TB-500, Semax, Selank, GHK-Cu, Noopept.

## Documentation

| Doc | Purpose |
| --- | --- |
| [STATUS.md](STATUS.md) | Board and session handoff |
| [AGENTS.md](AGENTS.md) | How agents work in this repo |
| [docs/PRD.md](docs/PRD.md) | Product requirements (F-1 to F-23) |
| [docs/EPICS.md](docs/EPICS.md) | Epics EP-01 to EP-09 |
| [docs/ROADMAP.md](docs/ROADMAP.md) | Phased delivery |
| [docs/research/scout-inventory.md](docs/research/scout-inventory.md) | Live SA sources and schema notes |
| [docs/research/ideation.md](docs/research/ideation.md) | Extra features, keep and kill |

## Roadmap at a glance

| Phase | Delivers |
| --- | --- |
| 1 Honest catalog | JSON import, compound / provider / product pages, disclaimer |
| 2 Find and judge | Search, filters, SAHPRA / WADA / evidence / COA stamps |
| 3 Offline and the research loop | PWA, device-local saves, documented Grok loop |
| 4 Stacks | Stack checker, named stacks |
| 5 Later | Accounts, reconstitution helper, native wrapper |
