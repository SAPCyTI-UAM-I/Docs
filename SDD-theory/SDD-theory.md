# Spec-Driven Development (SDD) - Diseño guiado por especificaciones

- **Fecha**: 2026-04-27
- **Estado**: 🔵 En construcción

---

## 1. ¿Qué es Spec-Driven Development?

Spec-Driven Development (SDD) es un enfoque de desarrollo de software en el que la especificación precede y guía al código.

### 1.1 Definición Operativa

Una **Spec** es un documento Markdown autocontenido que describe:

| Aspecto | Pregunta que responde |
|---------|----------------------|
| **Qué** | ¿Qué artefactos de código se crean o modifican? |
| **Por qué** | ¿Qué driver (HU, QA, CON) justifica este trabajo? |
| **Dónde** | ¿En qué capa hexagonal y paquete vive cada artefacto? |
| **Cómo se verifica** | ¿Qué tests y acceptance criteria validan la implementación? |
| **Qué no se toca** | ¿Qué queda fuera del alcance para evitar sobre-ingeniería? |

### 1.2 SDD como Contrato

La spec funciona como **contrato entre tres partes**:

1. **El arquitecto** — define y aprueba la spec
2. **El implementador** (estudiante Jr. o LLM) — implementa exactamente lo que dice la spec
3. **El revisor** — valida el PR contra la spec

### 1.3 Diferencia entre Plan de Trabajo y Especificación

| Característica | Plan de Trabajo (`phaseX.md`) | Especificación (`SPEC-XXX.md`) |
|----------------|-------------------------------|-------------------------------|
| Granularidad | Tarea: "Crear GraduateProgram AR" | Contrato: campos, invariantes, excepciones, tests, paquete exacto |
| Propósito | Tracking de avance (checkboxes) | Guía de implementación (contrato técnico) |
| Audiencia | Project manager, equipo | Implementador (humano o LLM) |
| Mutabilidad | Se actualiza con ✅ al completar | Se versiona; cambios requieren revisión |
| Relación | Cada `- [ ]` **apunta** a una spec | Cada spec **es referenciada** desde un phase |

---

## 2. Ventajas de SDD en el Contexto de SAPCyTI

### 2.1 Rotación de Estudiantes (CON-6)

Los estudiantes de licenciatura tienen estancias cortas. Sin SDD, cada rotación requiere que el nuevo estudiante entienda toda la arquitectura antes de contribuir. Con SDD:

- El estudiante lee **una sola spec** — no la arquitectura completa
- La spec ya pre-filtra el contexto relevante y las convenciones aplicables
- El estudiante puede ser productivo en su primera sesión de trabajo

### 2.2 Uso de LLMs como Implementadores

Un LLM con una spec precisa genera código que:

- Respeta la arquitectura hexagonal y las convenciones de paquetes
- No alucina imports cruzados entre bounded contexts
- Produce tests que siguen la estrategia definida
- No se excede del scope (la sección "Out of Scope" lo restringe)

Sin spec, el LLM improvisa basándose en patrones genéricos que pueden no aplicar al stack de SAPCyTI.

### 2.3 Trazabilidad Bidireccional

1. **Necesidad de Negocio** (NEC-X)
2. **Característica** (CAR-X)
3. **Driver Arquitectónico** (HU-XX / QA-X / CON-X)
4. **ADD Iteration** (`IterationPlan.md`)
5. **Phase** (tarea en `phaseX.md`)
6. **Spec** (`SPEC-XXX.md`)
7. **Código + Tests**

Cada nivel referencia al anterior. Desde cualquier artefacto de código se puede trazar hacia atrás hasta la necesidad de negocio que lo justifica.

## 3. Pipeline SDD: del Plan de Implementación al Código

Este es el flujo que sigue SDD una vez que ya existen la arquitectura (`Architecture.md`), el plan de iteraciones (`IterationPlan.md`) y el plan de implementación (`implementationPlan.md`). SDD no cubre cómo se crean esos documentos — solo cómo se ejecuta el trabajo a partir de ellos.

> **Prerequisitos (fuera de SDD):** La arquitectura y el plan de iteraciones ya fueron definidos mediante ADD. El plan de implementación ya organizó las fases y sus dependencias. SDD entra cuando hay que **convertir fases en trabajo concreto**.

### 3.1 Pasos del pipeline SDD

**PASO 1 — Descomposición en tareas.** A partir de una fase definida en `implementationPlan.md`, el arquitecto descompone el trabajo en tareas dentro de `phaseX.md`. Cada tarea es una unidad de trabajo que será cubierta por una spec. La tarea describe QUÉ hacer; la spec describe CÓMO hacerlo.

**PASO 2 — Generación de specs.** Para cada tarea (o grupo de tareas relacionadas) en `phaseX.md`, se redacta una spec usando la plantilla [`SPEC-TEMPLATE.md`](../SDD/templates/SPEC-TEMPLATE.md). La spec se registra en [`SPEC_INDEX.md`](../SDD/SPEC_INDEX.md) y se vincula desde `phaseX.md`. No se escribe código sin spec aprobada (🔵). Quién lo hace: arquitecto, estudiante Sr., o LLM supervisado.

**PASO 3 — Implementación.** El implementador toma una spec aprobada y produce código + tests + PR. El PR referencia la spec. El reviewer valida contra la spec, no contra criterio subjetivo. Quién lo hace: estudiante o LLM.

**PASO 4 — Cierre.** Al mergear el PR se ejecutan estas acciones:
1. Spec status pasa a ✅ Implemented
2. Task en `phaseX.md` se marca como `[x]`
3. Decisiones relevantes se registran en `progress.md` Decision Log
4. Deuda técnica aceptada se registra en `progress.md` Technical Debt Registry

### 3.2 De fases a tareas

Cada fase se descompone en un archivo `phaseX.md` que funciona como **mapa de tareas**. La estructura es:

```markdown
## A2.1 — Domain Model Implementation 🔲

> Specs: [SPEC-001](../../SDD/specs/iteration-1/SPEC-001_xxx.md)

- [ ] **T2.1.1** Create GraduateProgram Aggregate Root → [SPEC-001](...)
- [ ] **T2.1.2** Create ConfigurationParameter Value Object → [SPEC-001](...)
- [ ] **T2.1.3** Define domain invariants and validation → [SPEC-001](...)

## A2.2 — Persistence Layer 🔲

> Specs: [SPEC-002](../../SDD/specs/iteration-1/SPEC-002_xxx.md)

- [ ] **T2.2.1** Create repository port interface → [SPEC-002](...)
- [ ] **T2.2.2** Implement JPA repository adapter → [SPEC-002](...)
- [ ] **T2.2.3** Create Flyway migration V1 → [SPEC-002](...)
```

**Reglas para descomponer una fase en tareas:**
1. Agrupar tareas por **feature group** (`A{N}.{M}`)
2. Cada tarea tiene un ID único (`T{N}.{M}.{K}`)
3. Cada tarea apunta a la spec que la cubre — **siempre un link, nunca descripción técnica**
4. Varias tareas pueden apuntar a la misma spec (si la spec cubre un bloque de trabajo)
5. Una tarea nunca puede apuntar a más de una spec

### 3.4 De tareas a specs

Al redactar la spec, se toma como entrada:
1. La tarea en `phaseX.md` (el QUÉ)
2. La sección relevante de [`Architecture.md`](../Design/Architecture.md) (el DÓNDE y POR QUÉ)
3. Las convenciones en [`technologies/`](../SDD/technologies/) (el CÓMO)

La spec se redacta usando la plantilla [`SPEC-TEMPLATE.md`](../SDD/templates/SPEC-TEMPLATE.md) y se registra en dos lugares:
- [`SPEC_INDEX.md`](../SDD/SPEC_INDEX.md) — tabla de lookup
- `phaseX.md` — link desde la tarea

### 3.5 Ejemplo concreto: Phase 2, Task T2.1.1

La tarea **T2.1.1** ("Create GraduateProgram Aggregate Root") en `phase2.md` pertenece a la fase "Domain Model and Persistence", que a su vez viene de Iteration 1 en `IterationPlan.md`.

Para esta tarea se genera **SPEC-001_graduate-program-domain.md** con:
- **Bounded Context:** Configuration
- **Drivers:** QA-3 (modifiability), QA-4 (multi-tenant)
- **Capas afectadas:** Dominio (model), Puertos (port/out), Persistencia (adapter/out), Migraciones (Flyway)
- **Invariantes:** name NOT NULL max 200, division NOT NULL max 100
- **Tests:** `GraduateProgramTest` (unit), `GraduateProgramRepositoryIT` (`@DataJpaTest`)
- **Edge cases:** duplicate name, blank fields, tenant scoping

Al implementar la spec se producen: `GraduateProgram.java`, `GraduateProgramRepositoryPort.java`, `GraduateProgramJpaAdapter.java`, `V1__create_graduate_programs.sql`.

Al cerrar: SPEC-001 pasa a ✅ Implemented, T2.1.1 se marca `[x]` en `phase2.md`, y se actualiza `SPEC_INDEX.md`.

---

## 4. Modelo de Integración con la Arquitectura Existente

### 4.1 Jerarquía de Documentos

| Documento | Propósito |
|-----------|----------|
| `Architecture.md` (ADD) | QUÉ se decidió y POR QUÉ (inmutable por iteración) |
| `IterationPlan.md` | CUÁNDO se construye (orden de drivers) |
| `implementationPlan.md` | CÓMO se organiza el trabajo (fases, dependencias) |
| `phaseX.md` | MAPA de tareas — cada task referencia una spec |
| `SPEC-XXX.md` | EXACTAMENTE QUÉ se implementa (contrato técnico) |
| `progress.md` | MEMORIA del proyecto (decisiones, blockers, convenciones) |
| `technologies/*.md` | STACK técnico de referencia (versiones, librerías, reglas) |

### 4.2 Flujo de Trabajo SDD

1. Identificar trabajo pendiente (`phaseX.md` — task sin check)
2. Redactar Spec (en `SDD/specs/iteration-X/SPEC-XXX.md`)
3. Revisión de Spec (peer review)
4. Implementar contra Spec (estudiante o LLM)
5. Verificar contra Acceptance Criteria de Spec
6. Marcar task en `phaseX.md` como ✅; Spec status pasa a ✅ Implemented
7. Registrar decisiones relevantes en `progress.md`

### 4.3 Capas Afectadas por una Spec

Cada spec declara exactamente qué capas del sistema toca. Esto permite al implementador saber de antemano el alcance del cambio sin ambigüedad.

| Capa | Qué se especifica | Ejemplo |
|------|-------------------|---------|
| **Dominio** | Entidades, objetos de valor, reglas de negocio | `GraduateProgram`, `ConfigurationParameter` |
| **Servicios de dominio** | Lógica de negocio que no pertenece a una sola entidad | `PasswordGenerationService` |
| **Puertos (contratos)** | Interfaces que definen qué necesita o expone el dominio | `GraduateProgramRepositoryPort`, `RegisterStudentInputPort` |
| **Servicios de aplicación** | Casos de uso que orquestan dominio y puertos | `RegisterStudentUseCase`, `GetGraduateProgramUseCase` |
| **Controladores / API** | Endpoints REST, DTOs de entrada/salida, validación | `StudentController`, `RegisterStudentRequest` |
| **Persistencia** | Entidades JPA, adaptadores de repositorio, mappers | `GraduateProgramEntity`, `GraduateProgramJpaAdapter` |
| **Integración externa** | Adaptadores para sistemas externos (CSV, PDF, export) | `CsvAcademicOfferAdapter`, `PdfGeneratorAdapter` |
| **Configuración / Infra** | Filtros, seguridad, CORS, profiles | `TenantFilter`, `SecurityFilterChain` |
| **Migraciones de BD** | Scripts SQL versionados | `V1__create_graduate_programs.sql` |

### 4.4 Capas del Frontend (repositorio separado)

El frontend Angular vive en su propio repositorio (`sapcyti-spa`) y **no forma parte de la arquitectura del backend**. Las specs de frontend especifican capas propias de la SPA:

| Capa | Qué se especifica | Ejemplo |
|------|-------------------|--------|
| **Servicios** | Lógica de negocio del cliente, llamadas HTTP | `AuthService`, `EnrollmentService` |
| **Guards** | Protección de rutas por autenticación y rol | `AuthGuard`, `RoleGuard` |
| **Componentes compartidos** | Componentes reutilizables, pipes, directivas | `LoadingSpinnerComponent` |
| **Feature modules** | Módulos lazy-loaded por funcionalidad | `enrollment/student/`, `entity-management/` |
| **Modelos** | Interfaces TypeScript que reflejan DTOs del backend | `StudentResponse`, `EnrollmentFormData` |
| **Internacionalización** | Archivos de traducción y claves i18n | `assets/i18n/es.json`, `assets/i18n/en.json` |

---

## 5. Principios de Diseño de Specs

### 5.1 Referenciación sobre Duplicación

> **Regla:** Nunca duplicar información que ya existe en otro documento. Siempre referenciar.

- La spec referencia [`Architecture.md §4`](../Design/Architecture.md) para el modelo de dominio — no lo copia
- La spec referencia [`technologies/backend.md`](../SDD/technologies/backend.md) para versiones de librerías
- La spec referencia la HU en [`visionDocs/HU/`](../visionDocs/HU/) para el contexto de negocio
- La spec referencia [`progress.md`](../implementations/progress.md) Decision Log para decisiones previas

Esto mitiga:
- **Pérdida de información**: la fuente de verdad es una sola
- **Inconsistencia**: si cambia la arquitectura, la referencia sigue apuntando al lugar correcto
- **Inflación de contexto**: el LLM carga solo lo necesario

### 5.2 Granularidad: Fragmentada por Capa, Agrupada por Feature

**Una spec por capa hexagonal, agrupadas por feature:**

```
SPEC-031_course-selection-backend.md    → Domain + Ports + UseCase + Controller
SPEC-032_course-selection-frontend.md   → Angular component + service + i18n
```

**Justificación:**
1. El equipo rota (CON-6) — un estudiante puede saber Spring pero no Angular
2. Los LLMs trabajan mejor con contexto acotado (~50 líneas vs ~200)
3. Backend y frontend viven en repositorios separados con arquitecturas independientes
4. La dependencia es unidireccional: el frontend consume los contratos REST que el backend define

**Excepción:** Features de infraestructura pura (Docker, CI/CD) → una sola spec.

### 5.3 Convención de Nombrado

```
SPEC-{NNN}_{kebab-case-descriptivo}.md
```

- `NNN`: Número secuencial global (001, 002, ..., 031, 032)
- `kebab-case`: Descripción corta del contenido

Ejemplos:
- `SPEC-001_graduate-program-domain.md`
- `SPEC-010_jwt-authentication.md`
- `SPEC-031_course-selection-backend.md`

### 5.4 Estados de una Spec

| Estado | Significado |
|--------|-------------|
| 🔲 Draft | Spec en redacción, no lista para implementar |
| 🔵 Approved | Revisada y aprobada, lista para implementar |
| ✅ Implemented | Código mergeado y verificado contra la spec |
| ⛔ Blocked | Dependencia externa o técnica impide avance |
| 🔄 Amended | Spec modificada después de aprobación (requiere re-review) |

---

## 6. Separación de Responsabilidades entre Artefactos

### 6.1 `phaseX.md` — Mapa de Tareas (Task Map)

**Contiene:**
- Lista de tareas con `- [ ]` / `- [x]` checkboxes
- Cada tarea referencia la spec que la implementa: `→ [SPEC-001](../SDD/specs/iteration-1/SPEC-001_xxx.md)`
- Agrupación lógica por feature (A2.1, A2.2, etc.)
- Deliverables del phase con referencia a specs

**No contiene:**
- Descripción técnica detallada (eso va en la spec)
- Decisiones (eso va en progress.md)
- Convenciones (eso va en progress.md o technologies/)

### 6.2 `progress.md` — Memoria del Proyecto

**Contiene:**
- General Status (tabla resumen de phases — solo estado, no tasks)
- Current Phase indicator
- Decision Log (D-001, D-002, ...)
- Blockers and Issues
- Lessons Learned
- Active Conventions (reglas que todo implementador debe seguir)
- Session Notes (resumen de sesiones de trabajo)

**No contiene:**
- Checkboxes de tareas (eso va en phaseX.md)
- Detalles técnicos de implementación (eso va en specs)

### 6.3 `technologies/*.md` — Stack Técnico

**Contiene:**
- Versiones exactas de librerías y frameworks
- Reglas de uso (qué usar, qué no usar, por qué)
- Patrones obligatorios del stack
- Referencias a docs oficiales

**No contiene:**
- Decisiones de proyecto (eso va en progress.md)
- Tareas de implementación (eso va en specs)

---

## 7. Dependencias entre Specs

### 7.1 Principio: una sola fuente de verdad por nivel

Cada tipo de dependencia se declara en **un solo lugar** — sin duplicación.

| Nivel | Qué describe | Fuente de verdad | No se repite en |
|-------|-------------|------------------|-----------------|
| **Fases (macro)** | "Phase 2 antes de Phase 3" | [`implementationPlan.md §3`](../implementations/implementationPlan.md) | specs, SPEC_INDEX |
| **Specs (micro)** | "SPEC-003 depende de SPEC-001" | Header de cada spec: `Depends on:` / `Blocks:` | SPEC_INDEX, implementationPlan |
| **Externas** | "CSV format must be validated con César Hernández" | Header de cada spec: `External Dependencies:` | ningún otro lugar |
| **Descubrimiento** | "¿Qué specs existen y en qué estado están?" | [`SPEC_INDEX.md`](../SDD/SPEC_INDEX.md) — tabla de lookup | ningún otro lugar |

### 7.2 Cómo se declaran las dependencias en una Spec

Cada spec tiene en su header tres campos para dependencias:

```markdown
> **Depends on:** [SPEC-001](SPEC-001_xxx.md), [SPEC-002](SPEC-002_xxx.md) — must be ✅
> **Blocks:** [SPEC-010](../iteration-3/SPEC-010_xxx.md) — cannot start until this is ✅
> **External Dependencies:**
>   - [ ] CSV format validated with Lic. César Hernández
>   - [ ] RSA key pair generated (DevOps)
```

- **`Depends on:`** — specs que deben estar ✅ Implemented antes de que esta pueda implementarse
- **`Blocks:`** — specs que no pueden arrancar hasta que esta esté ✅
- **`External Dependencies:`** — validaciones de negocio o acciones no-código que bloquean esta spec

### 7.3 Qué NO va en `SPEC_INDEX.md`

`SPEC_INDEX.md` es una **tabla de lookup** — sirve para encontrar specs por iteración, fase, bounded context y estado. **No contiene grafos de dependencias** porque eso duplicaría lo que cada spec ya declara en su header.

Si necesitas saber de qué depende una spec, abres la spec. La columna `Depends On` en la tabla del índice es una referencia rápida, pero la fuente de verdad es el header de la spec.

### 7.4 Qué NO va en `implementationPlan.md`

El implementation plan declara dependencias entre **fases** (Phase 2 → Phase 3), no entre specs individuales. Las dependencias spec-a-spec no se elevan al plan macro porque:

1. Cambiarían con cada nueva spec — el plan macro se volvería inestable
2. Duplicarían lo que ya dice cada spec
3. El plan macro es para visión general; el detalle fino vive en las specs

---

## 8. Contexto por Tipo de Tarea (Prompt Protocol)

El objetivo es **minimizar los tokens consumidos** en cada sesión. Las convenciones se cargan automáticamente desde el archivo de reglas del agente (`.windsurfrules` / `.cursor/rules/`). No se carga contexto preventivamente — solo lo que la tarea requiere.

### Implementar una spec
1. La spec `SPEC-XXX.md` — **único documento obligatorio**. La spec es autocontenida: incluye el contexto arquitectónico necesario en su campo "Architectural Context".
2. Si la spec depende de otra, leer el contrato (ports/interfaces) de la spec dependiente.

### Escribir una spec
1. La tarea en `phaseX.md` (el QUÉ).
2. La sección relevante de [`Architecture.md`](../Design/Architecture.md) (NO el archivo completo).
3. La HU referenciada.
4. [`technologies/{área}.md`](../SDD/technologies/) del área que se especifica.

### Revisar código
1. La spec contra la que se revisa.
2. [`technologies/testing.md`](../SDD/technologies/testing.md) para convenciones de testing.

### NO cargar en ningún caso
- `SDD-theory.md` — es documentación de proceso, no de implementación.
- `Architecture.md` completo — solo las secciones que la spec referencia.
- `progress.md` — las convenciones ya están en las reglas del agente.

---

## 9. Decisiones Pendientes

| # | Pregunta | Opciones | Decisión |
|---|----------|----------|----------|
| P-001 | ¿Las specs de Phases 0 y 1 se crean retroactivamente? | a) Sí, para completitud; b) No, ya están ✅ | Propuesta: No — no tiene valor post-facto |
| P-002 | ¿Quién aprueba specs? | a) Solo arquitecto; b) Arquitecto + peer | Pendiente |
| P-003 | ¿Se versionan las specs con Git tags? | a) Sí; b) No, basta con el estado | Pendiente |
| P-004 | ¿Commit message incluye Spec ID? | a) `feat(config): SPEC-001 GraduateProgram`; b) Solo en PR description | Propuesta: En commit message |

---

## 10. Estructura de Carpetas SDD

Referencia completa: [`SDD/README.md`](../SDD/README.md)

```text
Docs/
├── SDD-theory/
│   └── SDD-theory.md                  ← Este archivo (teoría y planeación)
├── SDD/
│   ├── README.md                       ← Guía operativa de SDD para el proyecto
│   ├── SPEC_INDEX.md                   ← Índice maestro de specs
│   ├── templates/
│   │   ├── SPEC-TEMPLATE.md            ← Plantilla para specs individuales
│   │   ├── PHASE-TEMPLATE.md           ← Plantilla para phase files (task map)
│   │   ├── PROGRESS-TEMPLATE.md        ← Plantilla para progress (solo memoria)
│   │   └── IMPLEMENTATION-PLAN-TEMPLATE.md
│   ├── technologies/
│   │   ├── backend.md                  ← Java / Spring Boot
│   │   ├── frontend.md                 ← Angular / TypeScript
│   │   ├── testing.md                  ← Estrategia y herramientas de testing
│   │   └── devops.md                   ← CI/CD, Docker, deployment
│   └── specs/
│       ├── iteration-1/
│       ├── iteration-2/
│       ├── iteration-3/
│       ├── iteration-4/
│       └── iteration-5/
```
