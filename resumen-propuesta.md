# Resumen de Propuesta — Sesión 2026-04-27

Cambios al marco documental de SAPCyTI para mejorar la claridad del proceso SDD, organizar el banco de memoria del proyecto, y optimizar el uso de agentes IA.

---

## 1. Spec-Driven Development (SDD) — Cómo desarrollamos SAPCyTI

### Qué es SDD

SDD es nuestro enfoque de desarrollo: **la especificación precede y guía al código**. Ninguna línea de código se escribe sin una spec aprobada. La spec funciona como contrato entre el arquitecto (quien la define), el implementador (quien codifica) y el revisor (quien valida el PR).

Una spec responde 5 preguntas: **qué** artefactos se crean, **por qué** (qué driver lo justifica), **dónde** vive cada artefacto (capa y paquete), **cómo se verifica** (tests y criterios), y **qué no se toca**.

### Cómo se conecta la arquitectura con el código

El flujo completo tiene 3 etapas. Las dos primeras son prerequisitos (ya están hechas). SDD cubre la tercera:

**Etapa 1 — Diseño (ya hecho).** Mediante ADD se generaron `Architecture.md` (decisiones, modelo de dominio, estructura de paquetes) e `IterationPlan.md` (orden de iteraciones y drivers asignados).

**Etapa 2 — Planificación (ya hecho).** A partir de las iteraciones del `IterationPlan.md`, se creó `implementationPlan.md` con 6 fases (Phase 0–5) y sus dependencias. Cada fase tiene su archivo `phaseX.md` con tareas concretas.

**Etapa 3 — Ejecución (SDD).** Aquí entra SDD con su pipeline de 4 pasos:

1. **Descomposición en tareas** — El arquitecto toma una fase del `implementationPlan.md` y la descompone en tareas dentro de `phaseX.md`. Cada tarea tiene un ID (`T2.1.1`) y pertenece a un feature group (`A2.1`).

2. **Generación de specs** — Para cada tarea se redacta una spec usando la plantilla `SPEC-TEMPLATE.md`. La spec se registra en `SPEC_INDEX.md` y se vincula desde `phaseX.md`. No se codifica sin spec aprobada (🔵).

3. **Implementación** — El implementador (estudiante o LLM) toma la spec y produce código + tests + PR. El reviewer valida contra la spec, no contra criterio subjetivo.

4. **Cierre** — Al mergear: spec → ✅ Implemented, task → `[x]` en `phaseX.md`, decisiones → `progress.md`.

### Ejemplo: de la arquitectura al código

La **Iteration 1** de `IterationPlan.md` define los drivers QA-3 (modifiability) y QA-4 (multi-tenant). Esto genera la **Phase 2** ("Domain Model and Persistence") en `implementationPlan.md`, que a su vez contiene tareas en `phase2.md`:

```
## A2.1 — Domain Model Implementation
- [ ] T2.1.1 Create GraduateProgram Aggregate Root → SPEC-001
- [ ] T2.1.2 Create ConfigurationParameter Value Object → SPEC-001
```

Para T2.1.1 se genera **SPEC-001** con: bounded context (Configuration), drivers (QA-3, QA-4), capas afectadas (dominio, puertos, persistencia, migraciones), invariantes, tests y edge cases. Al implementar la spec se producen los archivos Java, el adapter JPA, y la migración Flyway.

### Jerarquía de documentos

| Documento | Propósito |
|-----------|----------|
| `Architecture.md` | QUÉ se decidió y POR QUÉ (inmutable por iteración) |
| `IterationPlan.md` | CUÁNDO se construye (orden de drivers) |
| `implementationPlan.md` | CÓMO se organiza el trabajo (fases, dependencias) |
| `phaseX.md` | MAPA de tareas — cada task referencia una spec |
| `SPEC-XXX.md` | EXACTAMENTE QUÉ se implementa (contrato técnico) |
| `progress.md` | MEMORIA del proyecto (decisiones, blockers) |

### Cambios realizados al documento teórico

- SDD-theory ahora describe únicamente el proceso SDD. La arquitectura y el plan de iteraciones se mencionan como prerequisitos, no como parte del flujo.
- Pipeline simplificado a 4 pasos claros.
- Diagramas ASCII reemplazados por listas y tablas.
- Coordinador removido como actor técnico (es usuario del sistema).

**Referencia completa:** [`SDD-theory/SDD-theory.md`](SDD-theory/SDD-theory.md)

---

## 2. Banco de Memoria — Índice general de documentación

**Solución:** `README.md` ahora funciona como índice del banco de memoria, organizado en 5 secciones:

| Sección | Qué contiene |
|---------|-------------|
| Visión y Requerimientos | Vision, HUs, atributos de calidad, concerns |
| Diseño Arquitectónico | ADD, drivers, Architecture.md, IterationPlan |
| Tecnologías | backend, frontend, testing, devops |
| Implementación | Plan, progress, phases |
| SDD | Teoría, guía operativa, specs, plantillas |

Incluye un **orden de lectura por rol** (estudiante nuevo, LLM, arquitecto).

**Referencia:** [`README.md`](README.md)

---

## 3. Estructura de carpetas propuesta

**Problema:** Archivos sueltos en la raíz (`ADD.md`, `ArchitecturalDrivers.md`), carpetas con nombres inconsistentes (`visionDocs`, `Analisis_Requerimientos`, `Design`), y `technologies/` dentro de `SDD/` cuando es un recurso general.

**Propuesta:**

```
Docs/
├── README.md                 ← Banco de memoria
├── vision/                   ← QUÉ es el sistema
├── requirements/             ← QUÉ necesita cumplir
├── design/                   ← POR QUÉ se diseñó así
├── technologies/             ← CON QUÉ se construye
├── implementation/           ← CÓMO se ejecuta el trabajo
└── sdd/                      ← METODOLOGÍA de desarrollo
```

Cada carpeta agrupa por propósito. Naming en lowercase, sin acentos, en inglés.

**Estado:** Propuesta aprobada, pendiente de ejecutar. Requiere actualizar links internos.

**Referencia:** [`estructura-propuesta.md`](estructura-propuesta.md)

---

## 4. Optimización de contexto para agentes IA

**Problema:** Antes, cada sesión de un LLM requería cargar ~15,000 tokens de contexto general (progress.md + technologies + Architecture.md + SDD-theory). Esto consumía ~25% del presupuesto de la sesión antes de escribir una línea de código, y mucha información era irrelevante para la tarea específica.

**Solución: 3 capas de contexto**

### Capa 1 — Rules (automáticas, ~350 tokens)

Archivo de reglas que el IDE carga automáticamente en cada sesión. Contiene solo convenciones ejecutables:

```
## Backend conventions
- Base package: mx.uam.sapcyti
- Modules: configuration, identity, academic, offering, enrollment
- Domain model uses JPA annotations directly — NO separate Entity classes
- MapStruct for DTO↔Domain only (compile-time)
- Logging: SLF4J only, NO System.out.println
...
```

Ubicación: `.cursor/rules/sapcyti.mdc` (Cursor).

### Capa 2 — La Spec (por tarea, ~1,000 tokens)

La spec es el **único documento obligatorio** al implementar. Para que funcione, la plantilla ahora incluye un campo **"Architectural Context"** donde se copian las líneas relevantes de `Architecture.md` directamente en la spec:

```markdown
### Architectural Context

> Copiar aquí las líneas relevantes de Architecture.md que el implementador
> necesita. Esto hace la spec autocontenida.
```

Esto evita que el LLM tenga que abrir `Architecture.md` completo (~5,000 tokens) por 3-10 líneas.

### Capa 3 — On-demand (solo si es necesario)

Otros documentos se consultan solo cuando la tarea lo requiere, nunca preventivamente.

### Resultado

| Tarea | Antes | Después |
|-------|-------|---------|
| Implementar spec | ~15,000 tokens | ~1,350 tokens |
| Escribir spec | ~12,000 tokens | ~3,500 tokens |
| Revisar código | ~10,000 tokens | ~2,500 tokens |

### Skills creados

3 skills disponibles en `.cursor/skills/` y `.windsurf/skills/`:

- **implement-spec** — Qué cargar y qué pasos seguir para implementar una spec
- **write-spec** — Qué cargar y qué pasos seguir para redactar una spec nueva
- **review-code** — Qué cargar y cómo revisar código contra una spec

**Referencia:** [`SDD-theory/SDD-theory.md` §8](SDD-theory/SDD-theory.md) (Prompt Protocol actualizado)

---

## 5. SPEC-TEMPLATE — Campo "Architectural Context"

**Cambio:** Nueva subsección dentro de §3 (Architecture Impact):

```markdown
### Architectural Context

> Propósito: Copiar aquí las líneas relevantes de Architecture.md que el
> implementador necesita para esta spec. Esto hace la spec autocontenida —
> el LLM no necesita abrir Architecture.md.
```

Esto **relaja** el principio de "referencia sobre duplicación" solo dentro de la spec, porque el costo de un LLM cargando un archivo completo por pocas líneas es mayor que duplicar esas líneas.

**Referencia:** [`SDD/templates/SPEC-TEMPLATE.md`](SDD/templates/SPEC-TEMPLATE.md)

---

## Próximos pasos

1. **Ejecutar la reorganización de carpetas** según `estructura-propuesta.md` y actualizar todos los links internos.
2. **Escribir la primera spec** (SPEC-001) usando la plantilla actualizada para validar el flujo completo.
3. **Validar el prompt protocol** en una sesión real de implementación con un LLM.
