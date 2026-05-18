# Phase {N}{sub?} — {Nombre del Phase}

> **ADD Iteration:** {N}
> **Drivers:** {lista de drivers — referencia a [ArchitecturalDrivers.md](../../design/ArchitecturalDrivers.md)}
> **Status:** 🔲 Not started | 🔵 In progress | ✅ Completed | ✅ Complete

**Goal:** {Objetivo del phase en una oración}

> **Sub-fase:** opcional — ej. `4A` scaffold, `4` core (`phase4a.md` vs `phase4.md`).
> **Environment:** {Cómo se ejecuta — e.g., "Backend contra PostgreSQL de docker-compose.dev.yml"}

### User Stories (HU) — opcional

> **No user stories apply directly to this phase.** {Motivo — ej. scaffolding, BC supporting sub-domain.}

## Domain Artifacts (obligatorio si el phase toca un BC)

| Artifact | Path | Status |
|----------|------|--------|
| Context Map | [`sdd/domain/ContextMap.md`](../../sdd/domain/ContextMap.md) | {✅ / pendiente} |
| Schema | [`sdd/domain/schemas/{bc}.schema.json`](../../sdd/domain/schemas/) | {✅ / N/A} |
| Features | [`sdd/domain/features/{bc}/`](../../sdd/domain/features/) | {✅ / N/A} |

## Specs en este phase

| Spec | Status | Listo para implementar |
|------|--------|------------------------|
| [SPEC-{NNN}]({ruta}) | 🔲 Draft / 🔵 Approved / ✅ | {sí / no — requiere aprobación} |

---

## A{N}.1 — {Nombre del Feature Group} {status emoji}

> Specs: [SPEC-{NNN}]({ruta}) | [SPEC-{NNN}]({ruta})

- [ ] **T{N}.1.1** {Descripción breve de la tarea} → [SPEC-{NNN}](../../sdd/specs/iteration-{X}/SPEC-{NNN}_{nombre}.md)
- [ ] **T{N}.1.2** {Descripción breve} → [SPEC-{NNN}](../../sdd/specs/iteration-{X}/SPEC-{NNN}_{nombre}.md)
- [ ] **T{N}.1.3** {Descripción breve} → [SPEC-{NNN}](../../sdd/specs/iteration-{X}/SPEC-{NNN}_{nombre}.md)

## A{N}.2 — {Nombre del Feature Group} {status emoji}

> Specs: [SPEC-{NNN}]({ruta})

- [ ] **T{N}.2.1** {Descripción breve} → [SPEC-{NNN}](../../sdd/specs/iteration-{X}/SPEC-{NNN}_{nombre}.md)
- [ ] **T{N}.2.2** {Descripción breve} → [SPEC-{NNN}](../../sdd/specs/iteration-{X}/SPEC-{NNN}_{nombre}.md)

---

## Deliverables

> Cada deliverable referencia las specs que lo componen.

- [ ] **E{N}.1** {Descripción} — Specs: [SPEC-{NNN}]({ruta})
- [ ] **E{N}.2** {Descripción} — Specs: [SPEC-{NNN}]({ruta})

---

## Transition Criteria

> Criterios específicos para dar por terminado este phase. Complementan los criterios genéricos de [`implementationPlan.md §4`](../../implementation/implementationPlan.md).

- [ ] {Criterio concreto — e.g., "GraduateProgram CRUD returns 200/201/404 via Postman"}
- [ ] {Criterio concreto — e.g., "Flyway migrations run clean on empty DB"}
- [ ] {Criterio concreto — e.g., "JaCoCo ≥80% on new code"}
- [ ] All linked specs in this phase are ✅ Implemented
- [ ] No regressions from previous phases

---

## Risks

> Riesgos conocidos específicos de este phase. Registrar mitigación o aceptación.

| # | Risk | Impact | Probability | Mitigation |
|---|------|--------|-------------|------------|
| R-{N}.1 | {e.g., "MapStruct version conflict with Lombok"} | {Alto/Medio/Bajo} | {Alta/Media/Baja} | {e.g., "Pin MapStruct 1.5.5, test compatibility"} |
| R-{N}.2 | {e.g., "Student rotation mid-phase"} | {Medio} | {Alta} | {e.g., "Spec granularity allows handoff at task level"} |

---

## Notes and Decisions

> Las decisiones se registran en [`decisions/`](../../implementation/decisions/README.md) — crear `D-NNN-slug.md`.
> Aquí solo se referencian las relevantes a este phase.

| # | Decision ID | Summary |
|---|-------------|---------|
| — | [D-{NNN}](../../implementation/decisions/D-{NNN}-slug.md) | {resumen breve} |
