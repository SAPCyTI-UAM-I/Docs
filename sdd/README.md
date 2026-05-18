# SDD — Spec-Driven Development for SAPCyTI

## Propósito

Metodología operativa: dominio DDD, specs de implementación, plantillas e índice maestro.

## Cuándo leer esto

- Al crear o usar specs
- Al entender el flujo dominio → código
- Teoría detallada: [`theory/SDD-theory.md`](theory/SDD-theory.md)

## Qué NO cargar al implementar

- Este README completo si ya tienes la spec asignada
- `theory/SDD-theory.md` durante implementación de código

---

## Estructura de este directorio

```text
sdd/                                  ← (carpeta en Docs/)
├── README.md                         ← Este archivo
├── SPEC_INDEX.md                     ← Índice maestro de todas las specs
├── theory/
│   └── SDD-theory.md                 ← Fundamentos teóricos y pipeline SDD
├── templates/                        ← Plantillas SDD (índice: templates/README.md)
├── domain/                           ← Artefactos DDD (Context Map, schemas, Gherkin)
│   ├── ContextMap.md
│   ├── schemas/
│   └── features/
└── specs/
    └── iteration-1/                  ← Specs actuales (iteration-2+ cuando existan)

Stack técnico (fuera de sdd/): ../technologies/{backend,frontend,testing,devops}.md
```

## Cómo usar SDD

### Flujo completo: del dominio a la implementación

1. **Especificar dominio** → Context Map, JSON Schema, Features Gherkin (en `domain/`)
2. **Descomponer en tareas** → `phaseX.md` con referencias a specs
3. **Redactar Spec** → `SPEC-XXX.md` usando template (en `specs/`)
4. **Implementar** → Código + Tests + PR (contra la spec)
5. **Cerrar** → Spec ✅, task ✅ en `phaseX.md`, decisión en `implementation/decisions/` si aplica, sesión en `implementation/sessions/`, coordinador actualiza `progress.md`

### Crear una nueva Spec de implementación

1. Verifica que los artefactos de dominio (Context Map, Schema, Features) existan en `domain/`
2. Copia [`templates/SPEC-TEMPLATE.md`](templates/SPEC-TEMPLATE.md) a `specs/iteration-{N}/SPEC-{NNN}_{nombre}.md` (ver [`templates/README.md`](templates/README.md))
3. Llena todas las secciones — **referencia, no dupliques**
4. Agrega la spec al `SPEC_INDEX.md`
5. Vincula la spec desde el `phaseX.md` correspondiente

### Crear especificaciones de dominio para un nuevo BC

Usar checklist [`templates/DOMAIN-BC-TEMPLATE.md`](templates/DOMAIN-BC-TEMPLATE.md):

1. Actualizar `domain/ContextMap.md` con el nuevo BC y relaciones
2. Crear `domain/schemas/{bc-name}.schema.json` con aggregates y commands
3. Crear `domain/features/{bc-name}/*.feature` con escenarios Gherkin
4. Actualizar `domain/Summary.md`

### Flujo de estados

```
🔲 Draft → 🔵 Approved → ✅ Implemented
                ↓
            ⛔ Blocked | 🔄 Amended
```

### Plantillas

| Carpeta | Contenido | Índice |
|---------|-----------|--------|
| `sdd/templates/` | SPEC, PHASE, PLAN, PROGRESS, DOMAIN-BC | [`templates/README.md`](templates/README.md) |
| `implementation/templates/` | SESSION, DECISION, BLOCKER | [`../implementation/templates/README.md`](../implementation/templates/README.md) |

Guía resumida: [`onboarding/01-como-trabajamos.md`](../onboarding/01-como-trabajamos.md) § Plantillas.

### Documentos relacionados

| Documento | Ubicación | Rol |
|-----------|-----------|-----|
| Teoría SDD | `theory/SDD-theory.md` | Fundamentos y planeación |
| Context Map | `domain/ContextMap.md` | Bounded Contexts y relaciones DDD |
| Schemas | `domain/schemas/` | Contratos de datos machine-readable |
| Features | `domain/features/` | Especificaciones Gherkin ejecutables |
| Arquitectura | `../design/Architecture.md` | Fuente de verdad arquitectónica |
| Plan de iteraciones | `../design/IterationPlan.md` | Orden de drivers ADD |
