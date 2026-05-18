# Spec Index — SAPCyTI

> **Índice maestro de todas las specs.** Cada spec se vincula desde aquí y desde el `phaseX.md` correspondiente.
> Para crear una nueva spec, usa la plantilla [`templates/SPEC-TEMPLATE.md`](templates/SPEC-TEMPLATE.md).
> **Artefactos de dominio:** [`domain/ContextMap.md`](domain/ContextMap.md) | [`domain/schemas/`](domain/schemas/) | [`domain/features/`](domain/features/)

---

## Summary

| Total Specs | 🔲 Draft | 🔵 Approved | ✅ Implemented | ⛔ Blocked |
|-------------|----------|-------------|----------------|-----------|
| 9 | 2 | 0 | 7 | 0 |

---

## Iteration 1 — System Structure (Phases 0–5)

> **Goal:** Establish overall system structure, technology stack, deployment model, multi-tenant strategy.
> **Drivers:** CON-1, CON-2, CON-3, CON-4, CON-5, CON-6, CON-7, QA-3, QA-4
> **Ref:** [`IterationPlan.md`](../Design/IterationPlan.md) — Iteration 1

| Spec ID | Title | Phase | BC | Drivers | Depends On | Status |
|---------|-------|-------|----|---------|------------|--------|
| [SPEC-008A](specs/iteration-1/SPEC-008A_angular-project-scaffold-tooling.md) | Angular Project Scaffold & Tooling | 4A | — | CON-7, CON-6 | — | 🔲 Draft |
| [SPEC-008B](specs/iteration-1/SPEC-008B_spa-core-providers-shell-i18n.md) | SPA Core Providers, Shell & i18n | 4 | — | CON-7, CON-6, QA-4, QA-6 | SPEC-008A | 🔲 Draft |

<!-- Example:
| [SPEC-001](specs/iteration-1/SPEC-001_graduate-program-domain.md) | GraduateProgram Domain Model | 2 | Configuration | QA-3, QA-4 | — | 🔲 Draft |
| [SPEC-002](specs/iteration-1/SPEC-002_configuration-parameter-persistence.md) | ConfigurationParameter VO & Persistence | 2 | Configuration | QA-3, QA-4 | SPEC-001 | 🔲 Draft |
-->

> **Note:** Phases 0 and 1 are ✅ Completed — no retroactive specs needed.
| [SPEC-001](specs/iteration-1/SPEC-001_spring-boot-project-and-maven-build.md) | Spring Boot y build Maven | 1 | Plataforma | CON-1, CON-6 | — | ✅ Implemented |
| [SPEC-002](specs/iteration-1/SPEC-002_application-configuration-profiles-logging.md) | Configuración, perfiles y logging | 1 | Plataforma | QA-3, QA-4, CON-6 | SPEC-001 | ✅ Implemented |
| [SPEC-003](specs/iteration-1/SPEC-003_hexagonal-packages-tenant-filter-cors.md) | Paquetes hexagonales, tenant y CORS | 1 | Plataforma + layout BC | QA-4, CON-6, QA-3 | SPEC-001, SPEC-002 | ✅ Implemented |
| [SPEC-004](specs/iteration-1/SPEC-004_graduate-program-domain-persistence.md) | GraduateProgram — dominio y persistencia | 2 | BC-04 Program Configuration | QA-3, QA-4 | SPEC-003 | ✅ Implemented |
| [SPEC-005](specs/iteration-1/SPEC-005_configuration-parameter-persistence-isolation.md) | ConfigurationParameter — persistencia y aislamiento | 2 | BC-04 Program Configuration | QA-3, QA-4 | SPEC-004 | ✅ Implemented |
| [SPEC-006](specs/iteration-1/SPEC-006_graduate-program-application-rest-api.md) | GraduateProgram — application layer and REST API | 3 | BC-04 Program Configuration | QA-3, QA-4, CON-5 | SPEC-004, SPEC-005 | ✅ Implemented |
| [SPEC-007](specs/iteration-1/SPEC-007_configuration-parameter-application-rest-global-errors.md) | ConfigurationParameter — application layer, nested API, global errors | 3 | BC-04 Program Configuration | QA-3, QA-4, CON-5 | SPEC-005, SPEC-006 | ✅ Implemented |

> **Note:** Phase 0 (PostgreSQL dev via Docker) no tiene spec formal. Phase 1 queda cubierta por SPEC-001–003; [`phase1.md`](../implementations/phase1.md) enlaza las tareas a esas specs.
> **Dependencies:** Each spec declares its own dependencies in its header (`Depends on:`, `Blocks:`, `External Dependencies:`). Open the spec to see the full detail.

---

## Iteration 2 — DevOps & Deployment

> **Goal:** Containerization strategy, CI/CD pipeline, deployment automation.
> **Drivers:** QA-5, CON-2, CON-6
> **Ref:** [`IterationPlan.md`](../Design/IterationPlan.md) — Iteration 2

| Spec ID | Title | Phase | BC | Drivers | Depends On | Status |
|---------|-------|-------|----|---------|------------|--------|
| — | — | — | — | — | — | — |

---

## Iteration 3 — Security

> **Goal:** Authentication, RBAC, CWE Top 25 protection, login use case.
> **Drivers:** QA-1, QA-2, HU-01
> **Ref:** [`IterationPlan.md`](../Design/IterationPlan.md) — Iteration 3

| Spec ID | Title | Phase | BC | Drivers | Depends On | Status |
|---------|-------|-------|----|---------|------------|--------|
| — | — | — | — | — | — | — |

---

## Iteration 4 — Entity Management & Credentials

> **Goal:** Student/Professor CRUD, password flows, i18n.
> **Drivers:** HU-15, HU-21, QA-6, HU-02, HU-28
> **Ref:** [`IterationPlan.md`](../Design/IterationPlan.md) — Iteration 4

| Spec ID | Title | Phase | BC | Drivers | Depends On | Status |
|---------|-------|-------|----|---------|------------|--------|
| — | — | — | — | — | — | — |

---

## Iteration 4.1 — Bounded Context Refinement

> **Goal:** Sub-domain classification, DDD strategic patterns, domain event contracts.
> **Drivers:** QA-3, QA-4, QA-5, CON-6
> **Ref:** [`IterationPlan.md`](../Design/IterationPlan.md) — Iteration 4.1

| Spec ID | Title | Phase | BC | Drivers | Depends On | Status |
|---------|-------|-------|----|---------|------------|--------|
| — | — | — | — | — | — | — |

---

## Iteration 5 — Enrollment Workflow

> **Goal:** CSV import, course selection, advisor approval, PDF generation, export to School Systems.
> **Drivers:** HU-06, HU-07, HU-08, HU-09, CON-3
> **Ref:** [`IterationPlan.md`](../Design/IterationPlan.md) — Iteration 5

| Spec ID | Title | Phase | BC | Drivers | Depends On | Status |
|---------|-------|-------|----|---------|------------|--------|
| — | — | — | — | — | — | — |

