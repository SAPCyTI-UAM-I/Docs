# Tecnologías — SAPCyTI

## Propósito

Convenciones de stack y herramientas por área (backend, frontend, testing, devops).

## Cuándo leer esto

- Al **escribir** una spec (área correspondiente)
- Al **revisar** tests (`testing.md`)
- No es obligatorio al **implementar** si la spec es autocontenida

## Índice

| Archivo | Contenido | Obligatorio |
|---------|-----------|-------------|
| [backend.md](backend.md) | Java 21, Spring Boot, hexagonal, MapStruct, Flyway | Al especificar/implementar backend |
| [frontend.md](frontend.md) | Angular, TypeScript, i18n, PrimeNG | Al especificar/implementar SPA |
| [testing.md](testing.md) | Pirámide de tests, naming, cobertura ≥80% | Al revisar código |
| [devops.md](devops.md) | GitFlow, CI/CD, Docker | Fases 0, 5, integración |

## Rutas canónicas

- Canónico: `technologies/` en la raíz del repo Docs

## Qué NO cargar

- Los cuatro archivos a la vez — solo el del área de tu spec

## Siguiente paso

- Escribir spec: skill `write-spec` + plantilla SPEC
- Implementar: solo la spec (convenciones mínimas en `.cursor/rules/sapcyti.mdc`)
