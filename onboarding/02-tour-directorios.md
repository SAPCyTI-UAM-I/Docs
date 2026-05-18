# Tour de directorios — SAPCyTI Docs

## Árbol del repositorio

```text
Docs/
├── README.md, AGENTS.md, CANONICAL.md, external-references.md
├── onboarding/          ← Estás aquí
├── vision/              ← Visión y HUs
├── requirements/        ← Calidad y restricciones
├── design/              ← ADD, arquitectura, drivers
├── technologies/        ← Stack backend, frontend, testing, devops
├── implementation/      ← Plan, dashboard, phaseX, sessions/, decisions/
└── sdd/
    ├── theory/          ← Teoría SDD
    ├── domain/          ← DDD: Context Map, schemas, Gherkin
    ├── specs/           ← Specs de implementación
    └── templates/
```

## Qué pregunta responde cada carpeta

| Carpeta | Pregunta |
|---------|----------|
| `vision/` | ¿Qué es el sistema y qué necesitan los usuarios? |
| `requirements/` | ¿Qué calidad y restricciones debe cumplir? |
| `design/` | ¿Por qué se diseñó así? (ADD) |
| `technologies/` | ¿Con qué stack se construye? |
| `implementation/` | ¿En qué fase estamos? (`progress.md` dashboard, `phaseX.md`, `sessions/`, `decisions/`) |
| `sdd/domain/` | ¿Cuáles son los bounded contexts y contratos de datos? |
| `sdd/specs/` | ¿Qué implementar exactamente en código? |
| `.cursor/` | Reglas y skills para agentes Cursor |

## Siguiente paso

[03-primera-tarea.md](03-primera-tarea.md)
