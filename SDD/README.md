# SDD — Spec-Driven Development for SAPCyTI

> **Propuesta fusionada.** Integra la estructura operativa SDD con los artefactos de dominio DDD.
> Para la teoría y fundamentación ver [`theory/SDD-theory.md`](theory/SDD-theory.md).

---

## Estructura de este directorio

```text
SDD_fusion/
├── README.md                         ← Este archivo
├── SPEC_INDEX.md                     ← Índice maestro de todas las specs
├── theory/
│   └── SDD-theory.md                ← Fundamentos teóricos y pipeline SDD
├── templates/                        ← Plantillas para crear nuevos artefactos
│   ├── SPEC-TEMPLATE.md
│   ├── PHASE-TEMPLATE.md
│   ├── PROGRESS-TEMPLATE.md
│   └── IMPLEMENTATION-PLAN-TEMPLATE.md
├── technologies/                     ← Stack técnico de referencia
│   ├── backend.md
│   ├── frontend.md
│   ├── testing.md
│   └── devops.md
├── domain/                           ← Artefactos de dominio DDD (machine-readable)
│   ├── ContextMap.md                 ← Context Map — Bounded Contexts y relaciones
│   ├── Summary.md                    ← Resumen de la sesión de especificación DDD
│   ├── schemas/                      ← Contratos de datos JSON Schema por BC
│   │   └── enrollment.schema.json
│   └── features/                     ← Especificaciones Gherkin ejecutables por BC
│       └── enrollment/
│           ├── student_selection.feature
│           ├── advisor_approval.feature
│           └── enrollment_finalization.feature
└── specs/                            ← Specs de implementación por iteración ADD
    ├── iteration-1/
    ├── iteration-2/
    ├── iteration-3/
    ├── iteration-4/
    └── iteration-5/
```

## Cómo usar SDD

### Flujo completo: del dominio a la implementación

1. **Especificar dominio** → Context Map, JSON Schema, Features Gherkin (en `domain/`)
2. **Descomponer en tareas** → `phaseX.md` con referencias a specs
3. **Redactar Spec** → `SPEC-XXX.md` usando template (en `specs/`)
4. **Implementar** → Código + Tests + PR (contra la spec)
5. **Cerrar** → Spec ✅, task ✅, decision log actualizado

### Crear una nueva Spec de implementación

1. Verifica que los artefactos de dominio (Context Map, Schema, Features) existan en `domain/`
2. Copia `templates/SPEC-TEMPLATE.md` a `specs/iteration-{N}/SPEC-{NNN}_{nombre}.md`
3. Llena todas las secciones — **referencia, no dupliques**
4. Agrega la spec al `SPEC_INDEX.md`
5. Vincula la spec desde el `phaseX.md` correspondiente

### Crear especificaciones de dominio para un nuevo BC

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

### Documentos relacionados

| Documento | Ubicación | Rol |
|-----------|-----------|-----|
| Teoría SDD | `theory/SDD-theory.md` | Fundamentos y planeación |
| Context Map | `domain/ContextMap.md` | Bounded Contexts y relaciones DDD |
| Schemas | `domain/schemas/` | Contratos de datos machine-readable |
| Features | `domain/features/` | Especificaciones Gherkin ejecutables |
| Arquitectura | `../Design/Architecture.md` | Fuente de verdad arquitectónica |
| Plan de iteraciones | `../Design/IterationPlan.md` | Orden de drivers ADD |
