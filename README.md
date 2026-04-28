# Banco de Memoria — SAPCyTI

Índice de toda la documentación del proyecto. Estos documentos son la **base de conocimiento** que alimenta el desarrollo guiado por especificaciones (SDD).

---

## Visión y Requerimientos

| Documento | Contenido |
|-----------|-----------|
| [`visionDocs/Vision.md`](visionDocs/Vision.md) | Visión general del sistema, alcance y stakeholders |
| [`visionDocs/HU/`](visionDocs/HU/) | 35 historias de usuario ([índice](visionDocs/HU/00-INDICE.md)) |
| [`Analisis_Requerimientos/Atributos_y_Restricciones.md`](Analisis_Requerimientos/Atributos_y_Restricciones.md) | Atributos de calidad y restricciones del sistema |
| [`Analisis_Requerimientos/Concerns.md`](Analisis_Requerimientos/Concerns.md) | Concerns arquitectónicos identificados |

## Diseño Arquitectónico

| Documento | Contenido |
|-----------|-----------|
| [`ArchitecturalDrivers.md`](ArchitecturalDrivers.md) | Drivers: HU-XX (funcionales), QA-X (calidad), CON-X (restricciones) |
| [`ADD.md`](ADD.md) | Proceso Attribute-Driven Design aplicado al proyecto |
| [`Design/Architecture.md`](Design/Architecture.md) | Decisiones arquitectónicas, modelo de dominio, estructura de paquetes |
| [`Design/IterationPlan.md`](Design/IterationPlan.md) | Plan de iteraciones ADD y drivers asignados a cada una |

## Tecnologías

| Documento | Contenido |
|-----------|-----------|
| [`SDD/technologies/backend.md`](SDD/technologies/backend.md) | Java 21, Spring Boot 3.x, dependencias, reglas de paquetes, naming |
| [`SDD/technologies/frontend.md`](SDD/technologies/frontend.md) | Angular 17+, TypeScript, módulos, interceptors, i18n |
| [`SDD/technologies/testing.md`](SDD/technologies/testing.md) | Pirámide de testing, frameworks, convenciones de naming, CI |
| [`SDD/technologies/devops.md`](SDD/technologies/devops.md) | GitFlow, CI/CD, Docker, environments, secrets |

## Implementación (operativo)

| Documento | Contenido |
|-----------|-----------|
| [`implementations/implementationPlan.md`](implementations/implementationPlan.md) | Fases, dependencias, criterios de transición |
| [`implementations/progress.md`](implementations/progress.md) | Estado actual, decisiones, blockers, sesiones |
| [`implementations/phase0.md`](implementations/phase0.md) … [`phase5.md`](implementations/phase5.md) | Tareas por fase con links a specs |

## SDD (Spec-Driven Development)

| Documento | Contenido |
|-----------|-----------|
| [`SDD-theory/SDD-theory.md`](SDD-theory/SDD-theory.md) | Teoría y reglas de SDD para el proyecto |
| [`SDD/README.md`](SDD/README.md) | Guía operativa: cómo crear y usar specs |
| [`SDD/SPEC_INDEX.md`](SDD/SPEC_INDEX.md) | Índice maestro de specs |
| [`SDD/templates/`](SDD/templates/) | Plantillas: SPEC, PHASE, PROGRESS, IMPLEMENTATION-PLAN |

---

## Orden de lectura por rol

**Estudiante nuevo:** Vision.md → este README → `progress.md` → `technologies/{área}.md` → la spec asignada

**LLM (inicio de sesión):** `progress.md` → `technologies/{área}.md` → la spec a implementar → secciones referenciadas de `Architecture.md`

**Arquitecto:** `ArchitecturalDrivers.md` → `Architecture.md` → `IterationPlan.md` → `implementationPlan.md`
