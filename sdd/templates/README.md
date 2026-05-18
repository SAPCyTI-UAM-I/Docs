# Plantillas — SAPCyTI Docs

> Índice maestro de plantillas. **Copiar** el archivo correspondiente; no editar la plantilla in situ.  
> Las specs y fases ya escritas (iteración 1) no se reescriben para alinearlas; estas plantillas aplican a **artefactos nuevos**.

## Dónde está cada cosa

| Carpeta | Para qué |
|---------|----------|
| [`sdd/templates/`](.) | Specs, fases, plan, dashboard, dominio DDD |
| [`implementation/templates/`](../implementation/templates/) | Sesiones, decisiones, blockers |

## Plantillas SDD (`sdd/templates/`)

| Plantilla | Cuándo usarla | Destino típico |
|-----------|---------------|----------------|
| [SPEC-TEMPLATE.md](SPEC-TEMPLATE.md) | Nueva spec de implementación | `sdd/specs/iteration-{N}/SPEC-{NNN}_{nombre}.md` |
| [PHASE-TEMPLATE.md](PHASE-TEMPLATE.md) | Nueva fase o sub-fase | `implementation/phase{N}.md` o `phase4a.md` |
| [IMPLEMENTATION-PLAN-TEMPLATE.md](IMPLEMENTATION-PLAN-TEMPLATE.md) | Plan macro (proyecto nuevo o iteración mayor) | `implementation/implementationPlan.md` |
| [PROGRESS-TEMPLATE.md](PROGRESS-TEMPLATE.md) | Dashboard global | `implementation/progress.md` |
| [DOMAIN-BC-TEMPLATE.md](DOMAIN-BC-TEMPLATE.md) | Nuevo bounded context en dominio | `sdd/domain/` (varios archivos) |

## Plantillas operativas (`implementation/templates/`)

| Plantilla | Cuándo usarla | Destino típico |
|-----------|---------------|----------------|
| [SESSION-TEMPLATE.md](../implementation/templates/SESSION-TEMPLATE.md) | Al cerrar cada sesión de trabajo | `implementation/sessions/YYYY-MM-DD-tema.md` |
| [DECISION-TEMPLATE.md](../implementation/templates/DECISION-TEMPLATE.md) | Decisión durable D-xxx | `implementation/decisions/D-{NNN}-slug.md` |
| [BLOCKER-TEMPLATE.md](../implementation/templates/BLOCKER-TEMPLATE.md) | Impedimento B-xxx | `implementation/blockers/B-{NNN}-slug.md` |

## Convenciones de nombres

| Tipo | Patrón | Ejemplo |
|------|--------|---------|
| Spec | `SPEC-{NNN}_{kebab-case}.md` | `SPEC-009_enrollment-api.md` |
| Sesión | `YYYY-MM-DD-{tema}.md` | `2026-05-18-phase4-core.md` |
| Decisión | `D-{NNN}-{slug}.md` | `D-017-cors-prod.md` |
| Blocker | `B-{NNN}-{slug}.md` | `B-002-docker-port.md` |

**Siguiente ID:** ver [`decisions/README.md`](../implementation/decisions/README.md) (D-xxx) y [`blockers/README.md`](../implementation/blockers/README.md) (B-xxx).

## Flujo rápido

```text
Dominio nuevo     → DOMAIN-BC-TEMPLATE → ContextMap + schema + features
Nueva fase        → PHASE-TEMPLATE → phaseX.md + entradas en implementationPlan
Nueva spec        → SPEC-TEMPLATE → sdd/specs/… + SPEC_INDEX.md
Implementar       → (spec Approved) → código en sapcyti-api / sapcyti-spa
Cerrar sesión     → SESSION-TEMPLATE → sessions/
Decisión          → DECISION-TEMPLATE → decisions/
Coordinador       → PROGRESS-TEMPLATE (solo § estado) → progress.md
```

## Referencias

- Cómo trabajamos (listado completo): [`onboarding/01-como-trabajamos.md`](../../onboarding/01-como-trabajamos.md)
- Guía SDD: [`sdd/README.md`](../README.md)
- Trabajo en equipo: [`onboarding/05-trabajo-en-equipo.md`](../../onboarding/05-trabajo-en-equipo.md)
- Plantillas operativas: [`implementation/templates/README.md`](../../implementation/templates/README.md)
- Rutas canónicas: [`CANONICAL.md`](../../CANONICAL.md)
