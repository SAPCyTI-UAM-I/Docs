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

1. **Al cerrar spec:** actualizar `SDD/SPEC_INDEX.md`, checkbox en `phaseX.md`, decisiones en `implementations/progress.md`.
2. **Al cambiar arquitectura:** `Design/Architecture.md` + specs afectadas (estado 🔄 Amended).
3. **Al añadir bounded context:** completar `SDD/domain/` (ContextMap, schema, features) antes de la primera SPEC.
4. **Semanal:** ejecutar `scripts/verify-docs.sh`.
5. **Sesión con agente:** decisiones duraderas → `progress.md` Decision Log; continuidad de chat → Engram (`plan-sdd-arc` o `sapcyti`).

## Referencias

- Teoría completa: [`SDD/theory/SDD-theory.md`](../SDD/theory/SDD-theory.md)
- Guía operativa: [`SDD/README.md`](../SDD/README.md)
