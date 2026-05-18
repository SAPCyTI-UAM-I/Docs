# Canonical paths — SAPCyTI Docs

> Single source of truth for artifact location. If a document contradicts this table, **this table prevails**.


| Concept                                   | Canonical path                                                                  | Notes                                      |
| ------------------------------------------ | ------------------------------------------------------------------------------ | ------------------------------------------ |
| Memory bank index                | `[README.md](README.md)`                                                       | Entry point for humans and LLM             |
| LLM agent protocol                       | `[AGENTS.md](AGENTS.md)`                                                       | What to load by task type               |
| Onboarding                                 | `[onboarding/](onboarding/)`                                                   | New team members                         |
| Vision and scope                           | `[vision/Vision.md](vision/Vision.md)`                                         |                                            |
| User stories                       | `[vision/HU/](vision/HU/)`                                                     | Index: `00-INDICE.md`                     |
| Quality attributes                       | `[requirements/](requirements/)`                                               |                                            |
| Architectural drivers                    | `[design/ArchitecturalDrivers.md](design/ArchitecturalDrivers.md)`             |                                            |
| ADD architecture                           | `[design/Architecture.md](design/Architecture.md)`                             |                                            |
| ADD iteration plan                    | `[design/IterationPlan.md](design/IterationPlan.md)`                           |                                            |
| ADD process                                | `[design/ADD.md](design/ADD.md)`                                               |                                            |
| Stack (backend, frontend, testing, devops) | `[technologies/](technologies/)`                                               |                                            |
| DDD Context Map                            | `[sdd/domain/ContextMap.md](sdd/domain/ContextMap.md)`                         |                                            |
| Domain schemas                         | `[sdd/domain/schemas/](sdd/domain/schemas/)`                                   |                                            |
| Gherkin features                           | `[sdd/domain/features/](sdd/domain/features/)`                                 |                                            |
| DDD session summary                         | `[sdd/domain/Summary.md](sdd/domain/Summary.md)`                               |                                            |
| SDD theory                                 | `[sdd/theory/SDD-theory.md](sdd/theory/SDD-theory.md)`                         |                                            |
| Spec index                            | `[sdd/SPEC_INDEX.md](sdd/SPEC_INDEX.md)`                                       |                                            |
| Implementation specs                    | `[sdd/specs/](sdd/specs/)`                                                     |                                            |
| Template index                           | `[sdd/templates/README.md](sdd/templates/README.md)`                           | Spec, phase, session, decision, BC, blocker |
| SDD templates                             | `[sdd/templates/](sdd/templates/)`                                             |                                            |
| Operational templates                      | `[implementation/templates/](implementation/templates/)`                       | Session, decision, blocker                  |
| SDD operational guide                         | `[sdd/README.md](sdd/README.md)`                                               |                                            |
| Implementation plan                     | `[implementation/implementationPlan.md](implementation/implementationPlan.md)` | Macro view                                |
| Operational dashboard                        | `[implementation/progress.md](implementation/progress.md)`                     | Global status, current phase                 |
| Work sessions                        | `[implementation/sessions/](implementation/sessions/README.md)`                | One file per session                      |
| Decisions                                 | `[implementation/decisions/](implementation/decisions/README.md)`              | One file per D-xxx                       |
| Work phases                           | `[implementation/phaseX.md](implementation/)`                                  |                                            |
| External docs                              | `[external-references.md](external-references.md)`                             | Outside this repo                         |


## Rules

1. **Operational status:** `implementation/progress.md` prevails over `implementationPlan.md` in conflicts.
2. **Domain:** edit only `sdd/domain/` — folder `specifications/` does not exist.
3. **Maintenance:** run `scripts/verify-docs.sh` weekly (`STRICT_PATHS=1` after reorganization).