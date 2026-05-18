# Guía para agentes — SAPCyTI Docs

> Protocolo de carga de contexto para LLM (Cursor y similares). Complementa [`.cursor/rules/sapcyti.mdc`](.cursor/rules/sapcyti.mdc) y skills en [`.cursor/skills/`](.cursor/skills/).

## Proyectos Engram

| Proyecto | Cuándo usar |
|----------|-------------|
| `sapcyti` | Implementación de código (`sapcyti-api`, `sapcyti-spa`) |
| `plan-sdd-arc` | Especificaciones, arquitectura, este repo Docs |

Confirmar proyecto con el usuario al inicio de sesión si hay duda.

## Qué cargar por tipo de tarea

### Implementar una spec

| Cargar | No cargar |
|--------|-----------|
| Solo el archivo `SPEC-XXX.md` (autocontenida) | `SDD-theory.md`, `Architecture.md` completo |
| Contrato de spec dependiente si `Depends on` lo exige | `progress.md`, todas las HUs |
| — | `visionDocs/` completo |

**Skill:** [`.cursor/skills/implement-spec.md`](.cursor/skills/implement-spec.md)

### Escribir una spec

| Cargar | No cargar |
|--------|-----------|
| Tarea en `phaseX.md` | `Architecture.md` completo |
| Sección relevante de `Design/Architecture.md` | `SDD-theory.md` |
| HU referenciada (`visionDocs/HU/HU-XX.md`) | Specs no relacionadas |
| `SDD/technologies/{area}.md` | |
| `SDD/domain/ContextMap.md` (solo sección del BC) | |
| `SDD/domain/schemas/{bc}.schema.json` si existe | |
| `SDD/domain/features/{bc}/` si existe | |
| `SDD/templates/SPEC-TEMPLATE.md` | |

**Skill:** [`.cursor/skills/write-spec.md`](.cursor/skills/write-spec.md)

### Revisar código

| Cargar | No cargar |
|--------|-----------|
| Spec contra la que se revisa | Arquitectura completa |
| `SDD/technologies/testing.md` | |

**Skill:** [`.cursor/skills/review-code.md`](.cursor/skills/review-code.md)

### Trabajo ADD / arquitectura

| Cargar | No cargar |
|--------|-----------|
| `ArchitecturalDrivers.md` | Specs individuales |
| `Design/IterationPlan.md` | Código fuente |
| Secciones relevantes de `Design/Architecture.md` | |
| `ADD.md` o skill `arquitecture-add` | |

## Memoria: Git vs Engram

| Tipo | Dónde |
|------|-------|
| Decisiones duraderas (D-xxx), convenciones, estado de fase | `implementations/progress.md` (Git) |
| Specs, dominio DDD, arquitectura | Este repo (Git) |
| Continuidad de sesión, bugs en curso, "siguiente paso" | Engram MCP |
| Índice de rutas | [`CANONICAL.md`](CANONICAL.md) |

## Orden de lectura (inicio de sesión implementación)

1. [`implementations/progress.md`](implementations/progress.md) — fase actual
2. Spec asignada — único documento obligatorio para codificar
3. On-demand solo si la spec lo indica

## Enlaces rápidos

- [Banco de memoria](README.md)
- [Rutas canónicas](CANONICAL.md)
- [Teoría SDD](SDD/theory/SDD-theory.md)
- [Índice de specs](SDD/SPEC_INDEX.md)
- [Onboarding](onboarding/README.md) (tras Hito B)
