# Evidence-grade review

A human can block a grade raise. Fill a row before you publish a new grade or raise an existing one.

There are four grades only: anecdotal, preclinical, early human, registered medicine. There is no fifth promising grade. There is no star rating of efficacy.

## Rules

1. Do not raise a grade without a source you opened in that session.
2. Anecdotal is the default when papers are only rodent or in vitro.
3. Preclinical needs animal or cell evidence, not a shop claim.
4. Early human needs a human study. A foreign clinic leaflet is not enough.
5. Registered medicine requires a SAHPRA registration number on file.
6. A curator answers no to block the change. Leave the stored grade as it is.

Operator steps live in [data/README.md](../../data/README.md). The merge check is `bin/rails catalog:check`.

## Checklist

Copy a blank row for the next compound. Curator is yes only after a human read the supporting source.

| Compound id | Proposed grade | Supporting source | Opened on | Curator | Notes |
| --- | --- | --- | --- | --- | --- |
| bpc-157 | preclinical | https://pubmed.ncbi.nlm.nih.gov/17657443/ | 2026-08-26 | yes | Rodent tendon and muscle models. No completed human registration trial. |
| tb-500 | preclinical | https://pubmed.ncbi.nlm.nih.gov/12581423/ | 2026-08-26 | yes | Animal wound-repair models for thymosin beta 4. |
| semax | early_human | https://pubmed.ncbi.nlm.nih.gov/9173745/ | 2026-08-26 | yes | Human nasal analogue papers. Not a SAHPRA registered medicine. |
| selank | early_human | https://pubmed.ncbi.nlm.nih.gov/18454096/ | 2026-08-26 | yes | Human anxiety-disorder papers. Not a SAHPRA registered medicine. |
| ghk-cu | early_human | https://pubmed.ncbi.nlm.nih.gov/17147644/ | 2026-08-26 | yes | Human cosmetic and skin papers. No SAHPRA registration number. |
| noopept | early_human | https://pubmed.ncbi.nlm.nih.gov/19234797/ | 2026-08-26 | yes | Human and rodent nootropic papers. No SAHPRA registration number. |
| | | | | | |

## Blank row

| Compound id | Proposed grade | Supporting source | Opened on | Curator | Notes |
| --- | --- | --- | --- | --- | --- |
| | anecdotal | | | no | Default until a source supports a higher grade. |
