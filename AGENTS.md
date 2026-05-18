# Agent guide — SAPCyTI Docs

> Context loading protocol for LLM (Cursor and similar). Complements [`.cursor/rules/sapcyti.mdc`](.cursor/rules/sapcyti.mdc) and skills in [`.cursor/skills/`](.cursor/skills/).

## Engram projects

| Project | When to use |
|----------|-------------|
| `sapcyti` | Code implementation (`sapcyti-api`, `sapcyti-spa`) |
| `plan-sdd-arc` | Specifications, architecture, this Docs repo |

Confirm project with the user at session start if there is doubt.

## Source of truth by data type

| Data | Canonical file |
|------|-----------------|
| Global project status | `implementation/progress.md` (only coordinator edits § status) |
| Tasks and checkboxes | `implementation/phaseX.md` |
| Technical contract | `sdd/specs/iteration-{N}/SPEC-XXX.md` |
| Durable decision D-xxx | `implementation/decisions/D-NNN-slug.md` |
| Session note | `implementation/sessions/YYYY-MM-DD-tema.md` |
| Blocker B-xxx | `implementation/blockers/B-NNN-slug.md` |
| Code conventions | `.cursor/rules/sapcyti.mdc` + `technologies/{area}.md` |
| Spec index | `sdd/SPEC_INDEX.md` |
| Artifact paths | `CANONICAL.md` |

## Spec and implementation states

| State | Code? |
|--------|-------------|
| 🔲 Draft | **No** — requires review and move to 🔵 Approved |
| 🔵 Approved | Yes |
| ✅ Implemented | Agreed maintenance only |

## What to load by task type

### Implement a spec

| Load | Do not load |
|--------|-----------|
| Only the `SPEC-XXX.md` file (self-contained) | `sdd/theory/SDD-theory.md`, full `Architecture.md` |
| Dependent spec contract if `Depends on` requires it | `progress.md`, all HUs |
| — | Full `vision/` |

**Skill:** [`.cursor/skills/implement-spec.md`](.cursor/skills/implement-spec.md)

### Write a spec

| Load | Do not load |
|--------|-----------|
| Task in `phaseX.md` | Full `Architecture.md` |
| Relevant section of `design/Architecture.md` | `sdd/theory/SDD-theory.md` |
| Referenced HU (`vision/HU/HU-XX.md`) | Unrelated specs |
| `technologies/{area}.md` | |
| `sdd/domain/ContextMap.md` (BC section only) | |
| `sdd/domain/schemas/{bc}.schema.json` if it exists | |
| `sdd/domain/features/{bc}/` if it exists | |
| `sdd/templates/SPEC-TEMPLATE.md` | |

**Skill:** [`.cursor/skills/write-spec.md`](.cursor/skills/write-spec.md)

### Review code

| Load | Do not load |
|--------|-----------|
| Spec being reviewed against | Full architecture |
| `technologies/testing.md` | |

**Skill:** [`.cursor/skills/review-code.md`](.cursor/skills/review-code.md)

### ADD / architecture work

| Load | Do not load |
|--------|-----------|
| `ArchitecturalDrivers.md` | Individual specs |
| `design/IterationPlan.md` | Source code |
| Relevant sections of `design/Architecture.md` | |
| `ADD.md` or skill `arquitecture-add` | |

## Memory: Git vs Engram

| Type | Where |
|------|-------|
| Durable decisions (D-xxx) | `implementation/decisions/D-NNN-slug.md` (Git, one file per decision) |
| Global phase status (dashboard) | `implementation/progress.md` (Git — coordinator) |
| Session notes | `implementation/sessions/YYYY-MM-DD-nombre.md` (Git) |
| Specs, DDD domain, architecture | This repo (Git) |
| Session continuity, bugs in progress, "next step" | Engram MCP |
| Path index | [`CANONICAL.md`](CANONICAL.md) |

## Reading order (implementation session start)

1. [`implementation/progress.md`](implementation/progress.md) — dashboard (current phase; read-only except coordinator)
2. Assigned spec — sole mandatory document for coding
3. On-demand only if the spec indicates it
4. On session close: create `sessions/` and `decisions/` per [`onboarding/05-trabajo-en-equipo.md`](onboarding/05-trabajo-en-equipo.md)

## Quick links

- [Memory bank](README.md)
- [Canonical paths](CANONICAL.md)
- [SDD theory](sdd/theory/SDD-theory.md)
- [Spec index](sdd/SPEC_INDEX.md)
- [Onboarding](onboarding/README.md)
- [SDD templates](sdd/templates/README.md) · [Operational templates](implementation/templates/README.md)
