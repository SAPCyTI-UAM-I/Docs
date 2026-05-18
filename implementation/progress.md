# Project Memory — SAPCyTI (dashboard)

> **Solo estado global.** Decisiones → [`decisions/`](decisions/README.md). Sesiones → [`sessions/`](sessions/README.md). Blockers → [`blockers/`](blockers/).  
> **Coordinador** actualiza este archivo tras merge a `develop`. Ver [`onboarding/05-trabajo-en-equipo.md`](../onboarding/05-trabajo-en-equipo.md).

---

## General Status

| Phase | Status | Progress | Last Updated |
|-------|--------|----------|--------------|
| 0 — Project setup | 🔵 In progress | 34/40 tasks (6 manual) | 2026-04-19 |
| 1 — Backend init | ✅ Completed | 17/17 checklist items | 2026-05-12 |
| 2 — Domain model | ✅ Completed | 10/10 tasks | 2026-05-17 |
| 3 — REST API | ✅ Completed | 12/12 tasks | 2026-05-17 |
| 4A — SPA scaffold & tooling | ✅ Completed | SPEC-008A | 2026-05-12 |
| 4 — SPA core (shell, i18n) | 🔲 Not started | 0/16 tasks — SPEC-008B Draft | — |
| 5 — Integration & Docker | 🔲 Not started | 0/17 tasks | — |
| 6 — Security & auth | 🔲 Not started | Planificado — [`phase6.md`](phase6.md) | — |
| 7 — Entity management | 🔲 Not started | Planificado — [`phase7.md`](phase7.md) | — |
| 8 — Academic offering & CSV | 🔲 Not started | Planificado — [`phase8.md`](phase8.md) | — |
| 9 — Enrollment workflow | 🔲 Not started | Planificado — [`phase9.md`](phase9.md) | — |

**Legend:** 🔲 Not started | 🔵 In progress | ✅ Completed | ⛔ Blocked

> **Vista macro:** [`implementationPlan.md`](implementationPlan.md). Tareas detalladas: `phaseX.md`.

---

## Current Phase

**Phase:** 4A — SPA Scaffold & Tooling ✅ COMPLETED  
**Next phase:** 4 — SPA Core Architecture (SPEC-008B)  
**Next step:** Aprobar e implementar [`SPEC-008B`](../sdd/specs/iteration-1/SPEC-008B_spa-core-providers-shell-i18n.md) — [`phase4.md`](phase4.md)

---

## Phase History

| Phase | Completed | Notes |
|-------|-----------|-------|
| 3 — Program Configuration REST API | 2026-05-17 | SPEC-006, SPEC-007 — [sesión](sessions/2026-05-17-phases-2-3.md) |
| 4A — SPA Scaffold & Tooling | 2026-05-12 | SPEC-008A — [sesión](sessions/2026-05-12-phase4a.md) |

---

### Pending Manual Tasks (Phase 0)

| Task | Action Required |
|------|-----------------|
| ❌ T0.1.3 | Configure branch protection on `develop` in both repos (GitHub Settings → Branches) |
| ❌ T0.1.4 | Configure branch protection on `main` in both repos (GitHub Settings → Branches) |
| ❌ T0.1.5 | Create `develop` branch: `git checkout -b develop; git push -u origin develop` in each repo |
| ❌ T0.2.1/T0.2.3 | Run `npm install` in `sapcyti-api/` to install commitlint + husky |
| ❌ T0.2.4/T0.2.5 | Run `npm install` in `sapcyti-spa/` (after Angular project init in Phase 4) |
| ❌ T0.5.5 | Configure GitHub secrets: `GHCR_TOKEN` (GitHub Settings → Secrets → Actions) |
| ❌ T0.7.1–T0.7.6 | All verification tasks (require prerequisites installed + code pushed to GitHub) |

---

## Lessons Learned

| # | Phase | Lesson |
|---|-------|--------|
| L-001 | 0 | Create all configuration files before running install commands — allows reviewing the complete setup before execution |
| L-002 | 0 | PowerShell on Windows uses `;` not `&&` for command chaining |

> Nuevas lecciones: añadir fila aquí (coordinador) o acordar en PR de docs.

---

## Índices (no editar aquí el detalle)

| Tipo | Índice |
|------|--------|
| Decisiones D-001… | [`decisions/README.md`](decisions/README.md) |
| Sesiones de trabajo | [`sessions/README.md`](sessions/README.md) |
| Blockers | [`blockers/`](blockers/) |

**Siguiente ID decisión:** D-017 — plantilla [`templates/DECISION-TEMPLATE.md`](templates/DECISION-TEMPLATE.md)

---

## Future Iterations (Not Planned Yet)

| Iteration | Goal | Drivers |
|-----------|------|---------|
| **2** | DevOps and deployment infrastructure | QA-5, CON-2, CON-6 |
| **3** | Security cross-cutting concerns | QA-1, QA-2, HU-01 |
| **4** | Entity management and credentials | HU-15, HU-21, QA-6, HU-02, HU-28 |
| **4.1** | Bounded Context Map refinement | QA-3, QA-4, QA-5, CON-6 |
| **5** | Enrollment workflow | HU-06, HU-07, HU-08, HU-09, CON-3 |

---

## Quick Reference

- **General plan:** [`implementationPlan.md`](implementationPlan.md)
- **Architecture spec:** [`Architecture.md`](../design/Architecture.md)
- **Iteration plan:** [`IterationPlan.md`](../design/IterationPlan.md)
- **Phase guides:** [`phase0.md`](phase0.md) … [`phase9.md`](phase9.md)
- **Trabajo en equipo:** [`onboarding/05-trabajo-en-equipo.md`](../onboarding/05-trabajo-en-equipo.md)
