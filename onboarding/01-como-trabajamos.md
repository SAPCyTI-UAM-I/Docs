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
2. **Al cerrar sesión de trabajo:** **crear** `implementation/sessions/YYYY-MM-DD-nombre.md` (no editar sesiones ajenas ni volcar notas en `progress.md`).
3. **Decisión durable (D-xxx):** **crear** `implementation/decisions/D-NNN-slug.md` (siguiente ID en [`decisions/README.md`](../implementation/decisions/README.md)).
4. **Al cambiar arquitectura:** `design/Architecture.md` + specs afectadas (estado 🔄 Amended).
5. **Al añadir bounded context:** completar `sdd/domain/` (ContextMap, schema, features) antes de la primera SPEC.
6. **Semanal:** ejecutar `scripts/verify-docs.sh`.
7. **Sesión con agente:** continuidad de chat → Engram (`plan-sdd-arc` o `sapcyti`); decisiones duraderas → `decisions/`, no Engram como fuente única.

## Trabajo en equipo (3+ integrantes)

Evitar conflictos en Git: **un archivo por sesión/decisión**, dashboard compartido solo para el coordinador. Detalle: [`05-trabajo-en-equipo.md`](05-trabajo-en-equipo.md).

## Referencias

- Teoría completa: [`sdd/theory/SDD-theory.md`](../sdd/theory/SDD-theory.md)
- Guía operativa: [`sdd/README.md`](../sdd/README.md)
- Trabajo en equipo: [`05-trabajo-en-equipo.md`](05-trabajo-en-equipo.md)
