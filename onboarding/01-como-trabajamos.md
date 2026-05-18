# Cómo trabajamos — SAPCyTI

## Spec-Driven Development (SDD)

1. **Ningún código sin spec aprobada** (estado 🔵 Approved).
2. La spec es un **contrato** entre arquitecto, implementador y revisor.
3. Flujo: `phaseX.md` (tarea) → `SPEC-XXX.md` (cómo) → código + tests → PR.

### Estados de una spec

| Estado | Significado |
|--------|-------------|
| 🔲 Draft | En redacción |
| 🔵 Approved | Lista para implementar |
| ✅ Implemented | Mergeada y cerrada |
| ⛔ Blocked | Dependencia externa |
| 🔄 Amended | Cambió tras aprobación |

## Git y commits

- **GitFlow:** `develop` para integración, `main` para releases.
- **Conventional Commits:** `feat(module): SPEC-NNN descripción corta`
- Un PR por spec o unidad lógica acordada con el arquitecto.

## Repositorios

| Repo | Contenido |
|------|-----------|
| `Docs` (este) | Banco de memoria, specs, arquitectura |
| `sapcyti-api` | Backend Java / Spring Boot |
| `sapcyti-spa` | Frontend Angular |

## Mantenimiento del banco de memoria

1. **Al cerrar spec:** actualizar `sdd/SPEC_INDEX.md`, checkbox en `phaseX.md`; **coordinador** actualiza `implementation/progress.md` (dashboard).
2. **Al cerrar sesión de trabajo:** **crear** `implementation/sessions/YYYY-MM-DD-tema.md` con [`SESSION-TEMPLATE`](../implementation/templates/SESSION-TEMPLATE.md).
3. **Decisión durable (D-xxx):** **crear** `implementation/decisions/D-NNN-slug.md` con [`DECISION-TEMPLATE`](../implementation/templates/DECISION-TEMPLATE.md) (siguiente ID: [`decisions/README.md`](../implementation/decisions/README.md)).
4. **Blocker (B-xxx):** **crear** `implementation/blockers/B-NNN-slug.md` con [`BLOCKER-TEMPLATE`](../implementation/templates/BLOCKER-TEMPLATE.md) si algo impide avanzar.
5. **Al cambiar arquitectura:** `design/Architecture.md` + specs afectadas (estado 🔄 Amended).
6. **Al añadir bounded context:** seguir [`DOMAIN-BC-TEMPLATE`](../sdd/templates/DOMAIN-BC-TEMPLATE.md) en `sdd/domain/` antes de la primera SPEC.
7. **Semanal:** ejecutar `scripts/verify-docs.sh`.
8. **Sesión con agente:** continuidad de chat → Engram (`plan-sdd-arc` o `sapcyti`); decisiones duraderas → `decisions/`, no Engram como fuente única.

## Trabajo en equipo (3+ integrantes)

Evitar conflictos en Git: **un archivo por sesión/decisión**, dashboard compartido solo para el coordinador. Detalle: [`05-trabajo-en-equipo.md`](05-trabajo-en-equipo.md).

## Plantillas

> **Índice maestro:** [`sdd/templates/README.md`](../sdd/templates/README.md)  
> Hay **dos carpetas**; copiar la plantilla correspondiente, no editar el original.

### [`sdd/templates/`](../sdd/templates/) — planificación y specs

| Plantilla | Cuándo |
|-----------|--------|
| [SPEC-TEMPLATE.md](../sdd/templates/SPEC-TEMPLATE.md) | Nueva spec de implementación |
| [PHASE-TEMPLATE.md](../sdd/templates/PHASE-TEMPLATE.md) | Nueva fase o sub-fase (`phaseX.md`) |
| [DOMAIN-BC-TEMPLATE.md](../sdd/templates/DOMAIN-BC-TEMPLATE.md) | Nuevo bounded context (`sdd/domain/`) |
| [IMPLEMENTATION-PLAN-TEMPLATE.md](../sdd/templates/IMPLEMENTATION-PLAN-TEMPLATE.md) | Plan macro de fases |
| [PROGRESS-TEMPLATE.md](../sdd/templates/PROGRESS-TEMPLATE.md) | Dashboard global (solo coordinador) |

### [`implementation/templates/`](../implementation/templates/) — memoria operativa

| Plantilla | Cuándo |
|-----------|--------|
| [SESSION-TEMPLATE.md](../implementation/templates/SESSION-TEMPLATE.md) | Al cerrar cada sesión → `sessions/` |
| [DECISION-TEMPLATE.md](../implementation/templates/DECISION-TEMPLATE.md) | Decisión D-xxx → `decisions/` |
| [BLOCKER-TEMPLATE.md](../implementation/templates/BLOCKER-TEMPLATE.md) | Impedimento B-xxx → `blockers/` |

Índice local operativo: [`implementation/templates/README.md`](../implementation/templates/README.md).

## Referencias

- Teoría completa: [`sdd/theory/SDD-theory.md`](../sdd/theory/SDD-theory.md)
- Guía operativa: [`sdd/README.md`](../sdd/README.md)
- Trabajo en equipo: [`05-trabajo-en-equipo.md`](05-trabajo-en-equipo.md)
- Plantillas (índice maestro): [`sdd/templates/README.md`](../sdd/templates/README.md)
- Plantillas operativas: [`implementation/templates/README.md`](../implementation/templates/README.md)
