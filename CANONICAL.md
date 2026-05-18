# Rutas canónicas — SAPCyTI Docs

> Fuente única de verdad para ubicación de artefactos. Si un documento contradice esta tabla, **esta tabla prevalece**.

| Concepto | Ruta canónica | Deprecado / eliminar | Notas |
|----------|---------------|----------------------|-------|
| Índice del banco de memoria | [`README.md`](README.md) | — | Punto de entrada humanos y LLM |
| Protocolo agente LLM | [`AGENTS.md`](AGENTS.md) | — | Qué cargar por tipo de tarea |
| Visión y alcance | [`visionDocs/Vision.md`](visionDocs/Vision.md) → `vision/` (Hito C) | — | |
| Historias de usuario | [`visionDocs/HU/`](visionDocs/HU/) → `vision/HU/` | — | Índice: `00-INDICE.md` |
| Atributos de calidad | [`Analisis_Requerimientos/`](Analisis_Requerimientos/) → `requirements/` | — | |
| Drivers arquitectónicos | [`ArchitecturalDrivers.md`](ArchitecturalDrivers.md) → `design/` | — | |
| Arquitectura ADD | [`Design/Architecture.md`](Design/Architecture.md) → `design/` | — | |
| Plan de iteraciones ADD | [`Design/IterationPlan.md`](Design/IterationPlan.md) → `design/` | — | |
| Proceso ADD | [`ADD.md`](ADD.md) → `design/` | — | |
| Stack backend | [`SDD/technologies/backend.md`](SDD/technologies/backend.md) → `technologies/` | — | |
| Stack frontend | [`SDD/technologies/frontend.md`](SDD/technologies/frontend.md) → `technologies/` | — | |
| Testing | [`SDD/technologies/testing.md`](SDD/technologies/testing.md) → `technologies/` | — | |
| DevOps | [`SDD/technologies/devops.md`](SDD/technologies/devops.md) → `technologies/` | — | |
| Context Map DDD | [`SDD/domain/ContextMap.md`](SDD/domain/ContextMap.md) → `sdd/domain/` | [`specifications/ContextMap.md`](specifications/ContextMap.md) | Deprecado 2026-05-17 |
| Schemas de dominio | [`SDD/domain/schemas/`](SDD/domain/schemas/) → `sdd/domain/schemas/` | [`specifications/schemas/`](specifications/schemas/) | Deprecado 2026-05-17 |
| Features Gherkin | [`SDD/domain/features/`](SDD/domain/features/) → `sdd/domain/features/` | [`specifications/features/`](specifications/features/) | Deprecado 2026-05-17 |
| Resumen sesión DDD | [`SDD/domain/Summary.md`](SDD/domain/Summary.md) → `sdd/domain/` | [`specifications/Summary.md`](specifications/Summary.md) | Deprecado 2026-05-17 |
| Teoría SDD | [`SDD/theory/SDD-theory.md`](SDD/theory/SDD-theory.md) → `sdd/theory/` | [`SDD-theory/`](SDD-theory/) | Deprecado 2026-05-17 |
| Índice de specs | [`SDD/SPEC_INDEX.md`](SDD/SPEC_INDEX.md) → `sdd/SPEC_INDEX.md` | — | |
| Specs de implementación | [`SDD/specs/`](SDD/specs/) → `sdd/specs/` | — | |
| Plantillas SDD | [`SDD/templates/`](SDD/templates/) → `sdd/templates/` | — | |
| Guía operativa SDD | [`SDD/README.md`](SDD/README.md) → `sdd/README.md` | `SDD_fusion/` (nombre obsoleto) | |
| Plan de implementación | [`implementations/implementationPlan.md`](implementations/implementationPlan.md) → `implementation/` | — | Vista macro |
| Memoria operativa | [`implementations/progress.md`](implementations/progress.md) → `implementation/` | — | Estado fino del proyecto |
| Fases de trabajo | [`implementations/phaseX.md`](implementations/) → `implementation/` | — | |
| Onboarding | [`onboarding/`](onboarding/) | — | Guía integrantes nuevos |
| Docs externos | [`external-references.md`](external-references.md) | — | Fuera de este repo |

## Reglas

1. **No editar** rutas deprecadas salvo `specifications/README.md` (aviso de redirección).
2. **Estado operativo:** `implementations/progress.md` es la fuente fina; `implementationPlan.md` es vista macro.
3. Tras el Hito C, actualizar enlaces en este archivo a las rutas finales en minúsculas.
