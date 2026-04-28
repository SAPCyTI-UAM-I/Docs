# Project Memory — SAPCyTI

> This file is the **central project memory**. It records phase status, decisions, blockers, conventions, and session notes.
> **Task tracking lives in `phaseX.md` files** — not here.
> Update after each work session.

---

## General Status

| Phase | Status | Last Updated |
|-------|--------|--------------|
| 0 — Project setup | {emoji} {status} | {date} |
| 1 — Backend init | {emoji} {status} | {date} |
| 2 — Domain model | {emoji} {status} | {date} |
| 3 — REST API | {emoji} {status} | {date} |
| 4 — SPA init | {emoji} {status} | {date} |
| 5 — Integration | {emoji} {status} | {date} |

> **Task details:** See [`phase0.md`](phase0.md) … [`phase5.md`](phase5.md)

**Legend:** 🔲 Not started | 🔵 In progress | ✅ Completed | ⛔ Blocked

---

## Current Phase

**Phase:** {N} — {nombre} {status}
**Next phase:** {N} — {nombre}
**Next step:** {descripción breve con link al phaseX.md y spec relevante}

---

## Active Conventions

> Rules that every implementor (human or LLM) MUST follow.
> For full technology details see [`SDD/technologies/`](../SDD/technologies/).

### Backend
- **Base package:** `mx.uam.sapcyti`
- **Module packages:** `configuration`, `identity`, `academic`, `offering`, `enrollment`
- **Hexagonal layers per module:** `domain/model`, `domain/port/in`, `domain/port/out`, `domain/service`, `application/service`, `infrastructure/adapter/in`, `infrastructure/adapter/out`, `infrastructure/mapper`, `infrastructure/acl`, `infrastructure/security`
- **Domain model:** Classes in `domain/model/` with JPA annotations (`@Entity`, `@Id`, `@Column`). Validation in constructors.
- **Mappers:** MapStruct, compile-time, in `infrastructure/mapper/` — for DTO ↔ Domain mapping only
- **DTOs:** Request/Response suffixed, in `infrastructure/adapter/in/dto/`
- **Cross-module:** ID-based references only. Via output ports. Single transaction.
- **Tenant:** `X-Graduate-Id` header → `TenantContext` ThreadLocal → MDC
- **Logging:** SLF4J, structured JSON in prod, plain in dev. NO `System.out.println`
- **Migrations:** `V{N}__{description}.sql` in `db/migration/`
- **Profiles:** `dev`, `preprod`, `prod`

### Frontend
- **Framework:** Angular 17+, TypeScript strict mode
- **Structure:** Shell + Core + Shared + Feature modules
- **i18n:** `@ngx-translate`, keys in `assets/i18n/{lang}.json`
- **HTTP:** `HttpClient` with interceptors for JWT and tenant header
- **Style:** SCSS, BEM naming, responsive-first

### DevOps
- **Branching:** GitFlow (`main`, `develop`, `feature/*`, `release/*`, `hotfix/*`)
- **Commits:** Conventional Commits (commitlint + husky)
- **CI:** GitHub Actions — lint → build → test → security scan → coverage
- **Docker:** Multi-stage builds, env vars only, no host paths
- **Coverage:** ≥80% JaCoCo (backend), ≥80% istanbul (frontend)

---

## Decision Log

| # | Date | Decision | Context | Discarded Alternatives |
|---|------|----------|---------|------------------------|
| D-001 | {date} | {decision} | {context} | {alternatives} |

---

## Blockers and Issues

| # | Date | Description | Status | Resolution |
|---|------|-------------|--------|------------|
| B-001 | {date} | {description} | {status emoji} | {resolution} |

---

## Lessons Learned

| # | Phase | Lesson |
|---|-------|--------|
| L-001 | {N} | {lesson} |

---

## Technical Debt Registry

> Deuda técnica aceptada conscientemente. Cada entrada justifica por qué se acepta y cuándo se planea resolver.

| # | Date | Description | Reason Accepted | Phase to Resolve | Status |
|---|------|-------------|-----------------|------------------|--------|
| TD-001 | {date} | {e.g., "No pagination on `findAll()` for ConfigurationParameter"} | {e.g., "Dataset <100 rows in MVP"} | {N} | 🔲 Open / ✅ Resolved |

---

## Spec Amendment Log

> Cuando una spec se modifica después de ser aprobada (🔵→🔄), registrar aquí el motivo y el impacto.
> La spec misma tiene su Review Log; esta tabla da visibilidad global.

| Date | Spec ID | Amendment | Reason | Impact |
|------|---------|-----------|--------|--------|
| {date} | [SPEC-{NNN}]({ruta}) | {qué cambió} | {por qué} | {specs afectadas, si hay} |

---

## Session Notes

### Session — {YYYY-MM-DD} ({topic})

- {bullet points summarizing what was done}
- {decisions referenced: D-{NNN}}
- {next steps}

---

## Future Iterations (Not Planned Yet)

| Iteration | Goal | Drivers |
|-----------|------|---------|
| **{N}** | {goal} | {drivers} |

---

## Quick Reference

- **General plan:** [`implementationPlan.md`](implementationPlan.md)
- **Architecture:** [`Architecture.md`](../Design/Architecture.md)
- **Iteration plan:** [`IterationPlan.md`](../Design/IterationPlan.md)
- **Phase guides:** [`phase0.md`](phase0.md) … [`phase5.md`](phase5.md)
- **Spec index:** [`SPEC_INDEX.md`](../SDD/SPEC_INDEX.md)
- **Technologies:** [`SDD/technologies/`](../SDD/technologies/)
- **SDD theory:** [`SDD-theory/SDD-theory.md`](../SDD-theory/SDD-theory.md)
