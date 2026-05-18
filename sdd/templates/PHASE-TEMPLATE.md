# Phase {N} — {Nombre del Phase}

> **ADD Iteration:** {N}
> **Drivers:** {lista de drivers — referencia a [ArchitecturalDrivers.md](../../ArchitecturalDrivers.md)}
> **Status:** 🔲 Not started | 🔵 In progress | ✅ Completed

**Goal:** {Objetivo del phase en una oración}

> **Environment:** {Cómo se ejecuta — e.g., "Backend contra PostgreSQL de docker-compose.dev.yml"}

---

## A{N}.1 — {Nombre del Feature Group} {status emoji}

> Specs: [SPEC-{NNN}]({ruta}) | [SPEC-{NNN}]({ruta})

- [ ] **T{N}.1.1** {Descripción breve de la tarea} → [SPEC-{NNN}](../../SDD/specs/iteration-{X}/SPEC-{NNN}_{nombre}.md)
- [ ] **T{N}.1.2** {Descripción breve} → [SPEC-{NNN}](../../SDD/specs/iteration-{X}/SPEC-{NNN}_{nombre}.md)
- [ ] **T{N}.1.3** {Descripción breve} → [SPEC-{NNN}](../../SDD/specs/iteration-{X}/SPEC-{NNN}_{nombre}.md)

## A{N}.2 — {Nombre del Feature Group} {status emoji}

> Specs: [SPEC-{NNN}]({ruta})

- [ ] **T{N}.2.1** {Descripción breve} → [SPEC-{NNN}](../../SDD/specs/iteration-{X}/SPEC-{NNN}_{nombre}.md)
- [ ] **T{N}.2.2** {Descripción breve} → [SPEC-{NNN}](../../SDD/specs/iteration-{X}/SPEC-{NNN}_{nombre}.md)

---

## Deliverables

> Cada deliverable referencia las specs que lo componen.

- [ ] **E{N}.1** {Descripción} — Specs: [SPEC-{NNN}]({ruta})
- [ ] **E{N}.2** {Descripción} — Specs: [SPEC-{NNN}]({ruta})

---

## Transition Criteria

> Criterios específicos para dar por terminado este phase. Complementan los criterios genéricos de [`implementationPlan.md §4`](../../implementations/implementationPlan.md).

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

> Las decisiones se registran en [`progress.md`](../../implementations/progress.md) Decision Log.
> Aquí solo se referencian las relevantes a este phase.

| # | Decision ID | Summary |
|---|-------------|---------|
| — | [D-{NNN}](../../implementations/progress.md) | {resumen breve} |
