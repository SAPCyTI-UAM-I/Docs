# Dominio DDD — SAPCyTI

## Propósito

Artefactos machine-readable del dominio: Context Map, contratos de datos (JSON Schema) y escenarios Gherkin por bounded context.

## Cuándo leer esto

- Al escribir una spec nueva (write-spec)
- Al añadir o modificar un bounded context
- Al trazar drivers HU → implementación

## Índice

| Archivo / carpeta | Contenido | Obligatorio |
|-------------------|-----------|-------------|
| [ContextMap.md](ContextMap.md) | 6 BCs, relaciones, integraciones | Sí (sección del BC) |
| [Summary.md](Summary.md) | Acta de sesión de especificación DDD | Referencia |
| [schemas/](schemas/) | JSON Schema por BC | Sí si existe para el BC |
| [features/](features/) | Gherkin por BC | Sí si existe para el BC |

## BC → schema → features

| BC | Schema | Features |
|----|--------|----------|
| BC-01 Enrollment | [enrollment.schema.json](schemas/enrollment.schema.json) | [features/enrollment/](features/enrollment/) |
| BC-02 Academic Management | [academic-management.schema.json](schemas/academic-management.schema.json) | [features/academic-management/](features/academic-management/) |
| BC-03 Academic Offering | [academic-offering.schema.json](schemas/academic-offering.schema.json) | [features/academic-offering/](features/academic-offering/) |
| BC-04 Program Configuration | [program-configuration.schema.json](schemas/program-configuration.schema.json) | [features/program-configuration/](features/program-configuration/) |
| BC-05 Audit | [audit.schema.json](schemas/audit.schema.json) | [features/audit/](features/audit/) |
| BC-06 Identity & Access | [identity-access.schema.json](schemas/identity-access.schema.json) | [features/identity-access/](features/identity-access/) |

## Rutas canónicas

- Fuente de verdad: esta carpeta (`SDD/domain/`)
- Deprecado: [`../../specifications/`](../../specifications/) — no editar

## Qué NO cargar

- Carpeta `features/` completa si solo trabajas un BC (lee el subdirectorio del BC)
- `Summary.md` al implementar código (solo al escribir specs de dominio)

## Siguiente paso

- Nueva spec: [`../templates/SPEC-TEMPLATE.md`](../templates/SPEC-TEMPLATE.md)
- Guía SDD: [`../README.md`](../README.md)
