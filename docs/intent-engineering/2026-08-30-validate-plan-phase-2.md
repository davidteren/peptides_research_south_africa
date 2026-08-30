# Intent Engineering: validate Phase 2 plans

- **Skill:** ie-validate-plan
- **Context:** plan
- **Date:** 2026-08-30
- **Docs:** five unified plans under `docs/plans/2026-08-30-00{1-5}-*.md`
- **Lenses:** predictability, convention, simplicity, experience (skipped on EP-07 docs plan)
- **Config source:** defaults (no `.intense/` in this repo)

Blocking gaps from the first pass were applied in the plan files. Scores below are after those edits.

## Verdict

Ready to implement the five Phase 2 plans after the review edits landed in the same files.

| Plan | Epic / issues | Verdict |
| --- | --- | --- |
| 001 legal flags | EP-04 `#7` `#9` `#10` `#11` `#13` `#15` `#18` `#21` | Ready |
| 002 search browse | EP-05 `#6` `#17` `#20` `#23` `#24` `#28` `#30` `#31` `#33` | Ready |
| 003 vendor gate + stamp | `#47` `#49` | Ready |
| 004 comparison + COA | `#37` `#39` | Ready |
| 005 agent workflow | EP-07 `#51` `#58` `#59` `#61` `#62` `#63` `#64` | Ready (docs) |

## Applied review edits (ce-doc-review + ie-validate-plan)

**001**

- SAHPRA registration numbers, schedule, notes, and WADA prohibited flag now have ids and tests.
- Playwright scaffold is specified (`package.json`, `webServer`, seed). Not added to `bin/ci` in this plan.
- Compact flags under the existing disclaimer. Null WADA uses a temporary payload in tests.

**002**

- `Catalog::CompoundBrowse` lives in `lib/catalog/compound_browse.rb` (no `app/queries`).
- Compact-key match is exact equality, not substring.
- Three empty states: catalog empty, search no match, filter no match.
- GET param is `classification`. Search form has label and submit. Chips use `aria-current`.

**003**

- Stamp citation order is regulator / primary literature, then review.
- Every present research use must have a qualifying source (empty or missing sources fail).
- Playwright depends on plan 001 scaffold.

**004**

- `Catalog::ListingOrder` lives in `lib/catalog`.
- Shared row partial takes a parent id prefix. Kind label sits beside provider name. Strength stays. Price date is payload `price_checked_on`.

**005**

- `execution: knowledge-work`.
- First-drop history stays scout order (providers, then compounds, then products).
- Gate is `bin/rails catalog:check` and `config/ci.rb`. U3 folded into U1.

## Dimensional ratings (lowest first)

Scores are after the edits. Experience on 005 is skipped (no UI).

| Plan | Lowest dimension | Score | Residual gap |
| --- | --- | --- | --- |
| 001 | accessibility | 7 | Flag headings are specified; contrast of compact flags is implementer-owned |
| 001 | configuration_restraint | 7 | Playwright stays out of `bin/ci` on purpose |
| 002 | accessibility | 7 | Label, submit, and `aria-current` are now in the plan |
| 002 | repo_consistency | 8 | Query object now matches `lib/catalog` |
| 003 | representation_fidelity | 8 | Stamp vs list fact both required (F-2 + F-8) |
| 004 | experience | 8 | Kind shown as classification copy |
| 005 | simplicity | 8 | Two units, two files |

## Residual (not blocking)

- All starter providers are `ZA`. Import-rule UI needs a temporary test record until a non-SA provider exists.
- Grade-review checklist is a git gate only. Agents can still raise a grade until a human notices (`#63`).
- Playwright is local-only until a later CI story.
- If `#47` lands after EP-07 docs, update `data/README.md` so vendor-only wording matches live `catalog:check` failure.

## Coverage

| Lens | 001 | 002 | 003 | 004 | 005 |
| --- | --- | --- | --- | --- | --- |
| predictability | clean | clean | clean | clean | clean |
| convention | clean | clean | clean | clean | clean |
| simplicity | clean | clean | clean | clean | clean |
| experience | clean | clean | clean | clean | skipped |
| architecture | skipped (plan mode) | skipped | skipped | skipped | skipped |

ce-doc-review personas: coherence, feasibility, product, design (001-004), scope-guardian. Security lens off (no auth). Adversarial off after upstream EPICS/PRD contract.
