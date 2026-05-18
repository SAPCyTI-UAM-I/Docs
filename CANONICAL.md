# Rutas canónicas — SAPCyTI Docs

> Fuente única de verdad para ubicación de artefactos. Si un documento contradice esta tabla, **esta tabla prevalece**.

| Concepto | Ruta canónica | Notas |
|----------|---------------|-------|
| Índice del banco de memoria | [`README.md`](README.md) | Punto de entrada humanos y LLM |
| Protocolo agente LLM | [`AGENTS.md`](AGENTS.md) | Qué cargar por tipo de tarea |
| Onboarding | [`onboarding/`](onboarding/) | Integrantes nuevos |
| Visión y alcance | [`vision/Vision.md`](vision/Vision.md) | |
| Historias de usuario | [`vision/HU/`](vision/HU/) | Índice: `00-INDICE.md` |
| Atributos de calidad | [`requirements/`](requirements/) | |
| Drivers arquitectónicos | [`design/ArchitecturalDrivers.md`](design/ArchitecturalDrivers.md) | |
| Arquitectura ADD | [`design/Architecture.md`](design/Architecture.md) | |
| Plan de iteraciones ADD | [`design/IterationPlan.md`](design/IterationPlan.md) | |
| Proceso ADD | [`design/ADD.md`](design/ADD.md) | |
| Stack (backend, frontend, testing, devops) | [`technologies/`](technologies/) | |
| Context Map DDD | [`sdd/domain/ContextMap.md`](sdd/domain/ContextMap.md) | |
| Schemas de dominio | [`sdd/domain/schemas/`](sdd/domain/schemas/) | |
| Features Gherkin | [`sdd/domain/features/`](sdd/domain/features/) | |
| Resumen sesión DDD | [`sdd/domain/Summary.md`](sdd/domain/Summary.md) | |
| Teoría SDD | [`sdd/theory/SDD-theory.md`](sdd/theory/SDD-theory.md) | |
| Índice de specs | [`sdd/SPEC_INDEX.md`](sdd/SPEC_INDEX.md) | |
| Specs de implementación | [`sdd/specs/`](sdd/specs/) | |
| Índice de plantillas | [`sdd/templates/README.md`](sdd/templates/README.md) | Spec, phase, sesión, decisión, BC, blocker |
| Plantillas SDD | [`sdd/templates/`](sdd/templates/) | |
| Plantillas operativas | [`implementation/templates/`](implementation/templates/) | Sesión, decisión, blocker |
| Guía operativa SDD | [`sdd/README.md`](sdd/README.md) | |
| Plan de implementación | [`implementation/implementationPlan.md`](implementation/implementationPlan.md) | Vista macro |
| Dashboard operativo | [`implementation/progress.md`](implementation/progress.md) | Estado global, fase actual |
| Sesiones de trabajo | [`implementation/sessions/`](implementation/sessions/README.md) | Un archivo por sesión |
| Decisiones | [`implementation/decisions/`](implementation/decisions/README.md) | Un archivo por D-xxx |
| Fases de trabajo | [`implementation/phaseX.md`](implementation/) | |
| Docs externos | [`external-references.md`](external-references.md) | Fuera de este repo |

## Reglas

1. **Estado operativo:** `implementation/progress.md` prevalece sobre `implementationPlan.md` en conflictos.
2. **Dominio:** solo editar `sdd/domain/` — no existe carpeta `specifications/`.
3. **Mantenimiento:** ejecutar `scripts/verify-docs.sh` semanalmente (`STRICT_PATHS=1` tras reorganización).
