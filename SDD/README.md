# SDD — Spec-Driven Development for SAPCyTI

> **Guía operativa.** Para la teoría y fundamentación ver [`SDD-theory.md`](../SDD-theory/SDD-theory.md).

---

## Estructura de este directorio

```text
SDD/
├── README.md                 ← Este archivo
├── SPEC_INDEX.md             ← Índice maestro de todas las specs
├── templates/                ← Plantillas para crear nuevos artefactos
│   ├── SPEC-TEMPLATE.md
│   ├── PHASE-TEMPLATE.md
│   ├── PROGRESS-TEMPLATE.md
│   └── IMPLEMENTATION-PLAN-TEMPLATE.md
├── technologies/             ← Stack técnico de referencia
│   ├── backend.md
│   ├── frontend.md
│   ├── testing.md
│   └── devops.md
└── specs/                    ← Specs organizadas por ADD iteration
    ├── iteration-1/
    ├── iteration-2/
    ├── iteration-3/
    ├── iteration-4/
    └── iteration-5/
```

## Cómo usar SDD

### Crear una nueva Spec

1. Copia [`templates/SPEC-TEMPLATE.md`](templates/SPEC-TEMPLATE.md) a `specs/iteration-{N}/SPEC-{NNN}_{nombre}.md`
2. Llena todas las secciones siguiendo las instrucciones del template
3. **Referencia, no dupliques** — apunta a [`Architecture.md`](../Design/Architecture.md), [`technologies/`](technologies/), y HUs en lugar de copiar
4. Agrega la spec al [`SPEC_INDEX.md`](SPEC_INDEX.md)
5. Vincula la spec desde el `phaseX.md` correspondiente

### Flujo de estados

```
🔲 Draft → 🔵 Approved → ✅ Implemented
                ↓
            ⛔ Blocked (dependencia pendiente)
                ↓
            🔄 Amended (spec modificada post-aprobación)
```

### Convención de nombrado

```
SPEC-{NNN}_{kebab-case-descriptivo}.md
```

### Documentos relacionados

| Documento | Ubicación | Rol |
|-----------|-----------|-----|
| Teoría SDD | [`SDD-theory/SDD-theory.md`](../SDD-theory/SDD-theory.md) | Fundamentos y planeación |
| Arquitectura | [`Design/Architecture.md`](../Design/Architecture.md) | Fuente de verdad arquitectónica |
| Plan de iteraciones | [`Design/IterationPlan.md`](../Design/IterationPlan.md) | Orden de drivers ADD |
| Plan de implementación | [`implementations/implementationPlan.md`](../implementations/implementationPlan.md) | Fases y dependencias macro |
| Memoria del proyecto | [`implementations/progress.md`](../implementations/progress.md) | Decisiones, blockers, convenciones |
| Phases (task maps) | [`implementations/phaseX.md`](../implementations/) | Checkboxes → refs a specs |
