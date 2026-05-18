# Tour de directorios — SAPCyTI Docs

> **Nota:** Tras el Hito C de reorganización, las carpetas pasarán a nombres en inglés minúsculas (`vision/`, `design/`, `sdd/`, etc.). Las rutas actuales se indican entre paréntesis.

## Árbol objetivo

```text
Docs/
├── README.md, AGENTS.md, CANONICAL.md
├── onboarding/          ← Estás aquí
├── vision/              (hoy: visionDocs/)
├── requirements/        (hoy: Analisis_Requerimientos/)
├── design/              (hoy: Design/ + ADD.md, ArchitecturalDrivers.md en raíz)
├── technologies/        (hoy: SDD/technologies/)
├── implementation/      (hoy: implementations/)
└── sdd/                 (hoy: SDD/)
    ├── theory/
    ├── domain/          ← DDD: Context Map, schemas, Gherkin
    ├── specs/
    └── templates/
```

## Qué pregunta responde cada carpeta

| Carpeta | Pregunta |
|---------|----------|
| `visionDocs/` | ¿Qué es el sistema y qué necesitan los usuarios? |
| `Analisis_Requerimientos/` | ¿Qué calidad y restricciones debe cumplir? |
| `Design/` | ¿Por qué se diseñó así? (ADD) |
| `SDD/technologies/` | ¿Con qué stack se construye? |
| `implementations/` | ¿En qué fase estamos y qué tareas quedan? |
| `SDD/domain/` | ¿Cuáles son los bounded contexts y contratos de datos? |
| `SDD/specs/` | ¿Qué implementar exactamente en código? |
| `.cursor/` | Reglas y skills para agentes Cursor |

## Deprecado

- `specifications/` → usar `SDD/domain/`
- `SDD-theory/` → usar `SDD/theory/`

## Siguiente paso

[03-primera-tarea.md](03-primera-tarea.md)
