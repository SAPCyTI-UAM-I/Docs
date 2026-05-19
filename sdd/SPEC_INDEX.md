# Spec Index — SAPCyTI

> **Índice maestro de todas las specs.** Cada spec se vincula desde aquí y desde el `phaseX.md` correspondiente.
> Para crear una nueva spec, usa la plantilla [`templates/SPEC-TEMPLATE.md`](templates/SPEC-TEMPLATE.md).
> **Artefactos de dominio:** [`domain/ContextMap.md`](domain/ContextMap.md) | [`domain/schemas/`](domain/schemas/) | [`domain/features/`](domain/features/)

---

## Summary

| Total Specs | 🔲 Draft | 🔵 Approved | ✅ Implemented | ⛔ Blocked |
|-------------|----------|-------------|----------------|-----------|
| 11 | 3 | 0 | 8 | 0 |

---

## Próxima spec sugerida

| Spec | Phase | Estado | Acción |
|------|-------|--------|--------|
| [SPEC-008B](specs/iteration-1/SPEC-008B_spa-core-providers-shell-i18n.md) | 4 | 🔲 Draft | Completar spec → aprobar → implementar ([`progress.md`](../implementation/progress.md)) |

---

## Iteration 1 — System Structure (Phases 0–5)

> **Goal:** Establish overall system structure, technology stack, deployment model, multi-tenant strategy.
> **Drivers:** CON-1, CON-2, CON-3, CON-4, CON-5, CON-6, CON-7, QA-3, QA-4
> **Ref:** [`IterationPlan.md`](../design/IterationPlan.md) — Iteration 1

| Spec ID | Title | Phase | BC | Drivers | Depends On | Status |
|---------|-------|-------|----|---------|------------|--------|
| [SPEC-001](specs/iteration-1/SPEC-001_spring-boot-project-and-maven-build.md) | Spring Boot y build Maven | 1 | Plataforma | CON-1, CON-6 | — | ✅ Implemented |
| [SPEC-002](specs/iteration-1/SPEC-002_application-configuration-profiles-logging.md) | Configuración, perfiles y logging | 1 | Plataforma | QA-3, QA-4, CON-6 | SPEC-001 | ✅ Implemented |
| [SPEC-003](specs/iteration-1/SPEC-003_hexagonal-packages-tenant-filter-cors.md) | Paquetes hexagonales, tenant y CORS | 1 | Plataforma + layout BC | QA-4, CON-6, QA-3 | SPEC-001, SPEC-002 | ✅ Implemented |
| [SPEC-004](specs/iteration-1/SPEC-004_graduate-program-domain-persistence.md) | GraduateProgram — dominio y persistencia | 2 | BC-04 Program Configuration | QA-3, QA-4 | SPEC-003 | ✅ Implemented |
| [SPEC-005](specs/iteration-1/SPEC-005_configuration-parameter-persistence-isolation.md) | ConfigurationParameter — persistencia y aislamiento | 2 | BC-04 Program Configuration | QA-3, QA-4 | SPEC-004 | ✅ Implemented |
| [SPEC-006](specs/iteration-1/SPEC-006_graduate-program-application-rest-api.md) | GraduateProgram — application layer and REST API | 3 | BC-04 Program Configuration | QA-3, QA-4, CON-5 | SPEC-004, SPEC-005 | ✅ Implemented |
| [SPEC-007](specs/iteration-1/SPEC-007_configuration-parameter-application-rest-global-errors.md) | ConfigurationParameter — application layer, nested API, global errors | 3 | BC-04 Program Configuration | QA-3, QA-4, CON-5 | SPEC-005, SPEC-006 | ✅ Implemented |
| [SPEC-008A](specs/iteration-1/SPEC-008A_angular-project-scaffold-tooling.md) | Angular Project Scaffold & Tooling | 4A | — | CON-7, CON-6 | — | ✅ Implemented |
| [SPEC-008B](specs/iteration-1/SPEC-008B_spa-core-providers-shell-i18n.md) | SPA Core Providers, Shell & i18n | 4 | — | CON-7, CON-6, QA-4, QA-6 | SPEC-008A | 🔲 Draft |

> **Note:** Phase 0 (PostgreSQL dev via Docker) no tiene spec formal. Phases 0–1 están ✅ en código; Phase 1 queda cubierta por SPEC-001–003 — [`phase1.md`](../implementation/phase1.md).
> **Dependencies:** Each spec declares its own dependencies in its header (`Depends on:`, `Blocks:`, `External Dependencies:`). Open the spec to see the full detail.

---

## Iteration 1 (continued) — Phase 5 Integration & Docker

> **Goal:** Dockerize backend + SPA, full Compose stack, smoke verification.
> **Drivers:** CON-2, QA-5, CON-3
> **Ref:** [`phase5.md`](../implementation/phase5.md)

| Spec ID | Title | Phase | BC | Drivers | Depends On | Status |
|---------|-------|-------|----|---------|------------|--------|
| [SPEC-009](specs/iteration-1/SPEC-009_backend-dockerization-env-templates.md) | Backend Dockerization & environment templates | 5 | Platform | CON-2, QA-5, CON-6 | SPEC-003, SPEC-007 | 🔲 Draft |
| [SPEC-010](specs/iteration-1/SPEC-010_full-stack-compose-nginx-smoke.md) | Full Docker Compose stack, Nginx proxy & smoke verification | 5 | Platform | CON-2, QA-5, CON-3 | SPEC-008B, SPEC-009 | 🔲 Draft |

---

## Iteration 2 — DevOps & Deployment

> **Estado:** Parcialmente cubierto por SPEC-009/010 (Phase 5 local stack). Despliegue on-premise y GHCR deploy siguen en workflows stub.
> **Goal:** Containerization strategy, CI/CD pipeline, deployment automation.
> **Drivers:** QA-5, CON-2, CON-6
> **Ref:** [`IterationPlan.md`](../design/IterationPlan.md) — Iteration 2

| Spec ID | Title | Phase | BC | Drivers | Depends On | Status |
|---------|-------|-------|----|---------|------------|--------|
| _TBD_ | On-premise deploy & monitoring stack | 2 | — | QA-5 | SPEC-010 | Planificado |

---

## Iteration 3 — Security

> **Estado:** Planificado — descomponer [`implementation/phase6.md`](../implementation/phase6.md) antes de SPEC-009+.
> **Goal:** Authentication, RBAC, CWE Top 25 protection, login use case.
> **Drivers:** QA-1, QA-2, HU-01
> **Ref:** [`IterationPlan.md`](../design/IterationPlan.md) — Iteration 3

| Spec ID | Title | Phase | BC | Drivers | Depends On | Status |
|---------|-------|-------|----|---------|------------|--------|
| _TBD_ | Security infrastructure | 6 | identity-access | HU-01, QA-1 | Phase 5 | Planificado |

---

## Iteration 4 — Entity Management & Credentials

> **Estado:** Planificado — ver [`implementation/phase7.md`](../implementation/phase7.md).
> **Goal:** Student/Professor CRUD, password flows, i18n.
> **Drivers:** HU-15, HU-21, QA-6, HU-02, HU-28
> **Ref:** [`IterationPlan.md`](../design/IterationPlan.md) — Iteration 4

| Spec ID | Title | Phase | BC | Drivers | Depends On | Status |
|---------|-------|-------|----|---------|------------|--------|
| _TBD_ | Entity management | 7 | academic-management, identity-access | HU-15, HU-21 | Iteration 3 | Planificado |

---

## Iteration 4.1 — Bounded Context Refinement

> **Estado:** Parcialmente cubierto por artefactos en [`domain/`](domain/) — specs de refinamiento TBD.
> **Goal:** Sub-domain classification, DDD strategic patterns, domain event contracts.
> **Drivers:** QA-3, QA-4, QA-5, CON-6
> **Ref:** [`IterationPlan.md`](../design/IterationPlan.md) — Iteration 4.1

| Spec ID | Title | Phase | BC | Drivers | Depends On | Status |
|---------|-------|-------|----|---------|------------|--------|
| — | Domain events contracts | — | all | QA-3 | — | Planificado |

---

## Iteration 5 — Enrollment Workflow

> **Estado:** Planificado — ver [`implementation/phase8.md`](../implementation/phase8.md), [`phase9.md`](../implementation/phase9.md).
> **Goal:** CSV import, course selection, advisor approval, PDF generation, export to School Systems.
> **Drivers:** HU-06, HU-07, HU-08, HU-09, CON-3
> **Ref:** [`IterationPlan.md`](../design/IterationPlan.md) — Iteration 5

| Spec ID | Title | Phase | BC | Drivers | Depends On | Status |
|---------|-------|-------|----|---------|------------|--------|
| _TBD_ | Academic offering + CSV | 8 | academic-offering | HU-06 | Phase 7 | Planificado |
| _TBD_ | Enrollment workflow | 9 | enrollment | HU-07–09 | Phase 8 | Planificado |

