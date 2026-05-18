# Banco de Memoria — SAPCyTI

Índice de toda la documentación del proyecto. Estos documentos son la **base de conocimiento** que alimenta el desarrollo guiado por especificaciones (SDD).

| Guía | Contenido |
|------|-----------|
| [`AGENTS.md`](AGENTS.md) | Protocolo de carga de contexto para LLM |
| [`CANONICAL.md`](CANONICAL.md) | Rutas canónicas y deprecadas |
| [`onboarding/`](onboarding/) | Guía para integrantes nuevos |

---

## Visión y Requerimientos

| Documento | Contenido |
|-----------|-----------|
| [`vision/Vision.md`](vision/Vision.md) | Visión general del sistema, alcance y stakeholders |
| [`vision/HU/`](vision/HU/) | 35 historias de usuario ([índice](vision/HU/00-INDICE.md)) |
| [`requirements/Atributos_y_Restricciones.md`](requirements/Atributos_y_Restricciones.md) | Atributos de calidad y restricciones del sistema |
| [`requirements/Concerns.md`](requirements/Concerns.md) | Concerns arquitectónicos identificados |

## Diseño Arquitectónico

| Documento | Contenido |
|-----------|-----------|
| [`ArchitecturalDrivers.md`](design/ArchitecturalDrivers.md) | Drivers: HU-XX (funcionales), QA-X (calidad), CON-X (restricciones) |
| [`ADD.md`](design/ADD.md) | Proceso Attribute-Driven Design aplicado al proyecto |
| [`design/Architecture.md`](design/Architecture.md) | Decisiones arquitectónicas, modelo de dominio, estructura de paquetes |
| [`design/IterationPlan.md`](design/IterationPlan.md) | Plan de iteraciones ADD y drivers asignados a cada una |

## Tecnologías

| Documento | Contenido |
|-----------|-----------|
| [`technologies/backend.md`](technologies/backend.md) | Java 21, Spring Boot 3.x, dependencias, reglas de paquetes, naming |
| [`technologies/frontend.md`](technologies/frontend.md) | Angular, TypeScript, módulos, interceptors, i18n |
| [`technologies/testing.md`](technologies/testing.md) | Pirámide de testing, frameworks, convenciones de naming, CI |
| [`technologies/devops.md`](technologies/devops.md) | GitFlow, CI/CD, Docker, environments, secrets |

## Implementación (operativo)

| Documento | Contenido |
|-----------|-----------|
| [`implementation/implementationPlan.md`](implementation/implementationPlan.md) | Fases, dependencias, criterios de transición |
| [`implementation/progress.md`](implementation/progress.md) | Estado actual, decisiones, blockers, sesiones |
| [`implementation/phase0.md`](implementation/phase0.md) … [`phase9.md`](implementation/phase9.md) | Tareas por fase con links a specs (incl. [`phase4a.md`](implementation/phase4a.md)) |

## Dominio DDD (machine-readable)

| Documento | Contenido |
|-----------|-----------|
| [`sdd/domain/ContextMap.md`](sdd/domain/ContextMap.md) | Bounded Contexts y relaciones |
| [`sdd/domain/schemas/`](sdd/domain/schemas/) | Contratos JSON Schema por BC |
| [`sdd/domain/features/`](sdd/domain/features/) | Escenarios Gherkin por BC |
| [`sdd/domain/Summary.md`](sdd/domain/Summary.md) | Resumen de sesión de especificación DDD |

> Ver [`CANONICAL.md`](CANONICAL.md) y [`external-references.md`](external-references.md) para rutas y documentos fuera del repo.

## SDD (Spec-Driven Development)

| Documento | Contenido |
|-----------|-----------|
| [`sdd/theory/SDD-theory.md`](sdd/theory/SDD-theory.md) | Teoría y reglas de SDD para el proyecto |
| [`sdd/README.md`](sdd/README.md) | Guía operativa: cómo crear y usar specs |
| [`sdd/SPEC_INDEX.md`](sdd/SPEC_INDEX.md) | Índice maestro de specs |
| [`sdd/templates/`](sdd/templates/) | Plantillas: SPEC, PHASE, PROGRESS, IMPLEMENTATION-PLAN |

## Herramientas y Contexto entre Agentes

El proyecto utiliza agentes IA (Cursor) para asistir en la redacción de specs, implementación y revisión de código. Para mantener continuidad entre sesiones se emplean las siguientes herramientas:

| Herramienta | Propósito |
|-------------|-----------|
| **Engram** (MCP server) | Memoria persistente compartida entre agentes. Almacena decisiones arquitectónicas, convenciones, bugs resueltos, progreso y próximos pasos. Organizada por proyecto: `plan-sdd-arc` (planificación/arquitectura) y `sapcyti` (implementación). |
| **Rules** (`.cursor/rules/`) | Reglas cargadas automáticamente en cada sesión: convenciones del proyecto (`sapcyti`), protocolo de memoria (`engram`), y ejecución atómica de tareas (`task_execution`). |
| **Skills** (`.cursor/skills/`) | Flujos paso a paso para tareas específicas: `implement-spec`, `write-spec`, `review-code`. |

### ¿Cómo funciona Engram?

Engram es un servidor MCP (Model Context Protocol) que provee memoria persistente a los agentes. Al inicio de cada sesión, el agente recupera contexto previo (`mem_context` / `mem_search`). Tras trabajo significativo, guarda la información (`mem_save`). Al cerrar sesión, genera un resumen (`mem_session_summary`). Esto permite que sesiones futuras arranquen con conocimiento de lo ya decidido.

### Resumen de sesiones

| Documento | Contenido |
|-----------|-----------|
| [`resumen-propuesta.md`](resumen-propuesta.md) | Síntesis de decisiones, artefactos creados y cambios al marco documental |

---

## Orden de lectura por rol

**Estudiante nuevo:** Vision.md → este README → `progress.md` → `technologies/{área}.md` → la spec asignada

**LLM (inicio de sesión):** [`AGENTS.md`](AGENTS.md) → `progress.md` → la spec a implementar (autocontenida)

**Arquitecto:** `ArchitecturalDrivers.md` → `Architecture.md` → `IterationPlan.md` → `sdd/domain/ContextMap.md` → `implementationPlan.md`
