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
| Solo el archivo `SPEC-XXX.md` (autocontenida) | `sdd/theory/SDD-theory.md`, `Architecture.md` completo |
| Contrato de spec dependiente si `Depends on` lo exige | `progress.md`, todas las HUs |
| — | `vision/` completo |

**Skill:** [`.cursor/skills/implement-spec.md`](.cursor/skills/implement-spec.md)

### Escribir una spec

| Cargar | No cargar |
|--------|-----------|
| Tarea en `phaseX.md` | `Architecture.md` completo |
| Sección relevante de `design/Architecture.md` | `SDD-theory.md` |
| HU referenciada (`vision/HU/HU-XX.md`) | Specs no relacionadas |
| `technologies/{area}.md` | |
| `sdd/domain/ContextMap.md` (solo sección del BC) | |
| `sdd/domain/schemas/{bc}.schema.json` si existe | |
| `sdd/domain/features/{bc}/` si existe | |
| `sdd/templates/SPEC-TEMPLATE.md` | |

**Skill:** [`.cursor/skills/write-spec.md`](.cursor/skills/write-spec.md)

### Revisar código

| Cargar | No cargar |
|--------|-----------|
| Spec contra la que se revisa | Arquitectura completa |
| `technologies/testing.md` | |

**Skill:** [`.cursor/skills/review-code.md`](.cursor/skills/review-code.md)

### Trabajo ADD / arquitectura

| Cargar | No cargar |
|--------|-----------|
| `ArchitecturalDrivers.md` | Specs individuales |
| `design/IterationPlan.md` | Código fuente |
| Secciones relevantes de `design/Architecture.md` | |
| `ADD.md` o skill `arquitecture-add` | |

## Memoria: Git vs Engram

| Tipo | Dónde |
|------|-------|
| Decisiones duraderas (D-xxx), convenciones, estado de fase | `implementation/progress.md` (Git) |
| Specs, dominio DDD, arquitectura | Este repo (Git) |
| Continuidad de sesión, bugs en curso, "siguiente paso" | Engram MCP |
| Índice de rutas | [`CANONICAL.md`](CANONICAL.md) |

## Orden de lectura (inicio de sesión implementación)

1. [`implementation/progress.md`](implementation/progress.md) — fase actual
2. Spec asignada — único documento obligatorio para codificar
3. On-demand solo si la spec lo indica

## Enlaces rápidos

- [Banco de memoria](README.md)
- [Rutas canónicas](CANONICAL.md)
- [Teoría SDD](sdd/theory/SDD-theory.md)
- [Índice de specs](sdd/SPEC_INDEX.md)
- [Onboarding](onboarding/README.md)
