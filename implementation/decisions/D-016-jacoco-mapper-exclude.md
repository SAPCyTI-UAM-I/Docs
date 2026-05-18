---
id: D-016
date: 2026-05-17
---

# D-016: JaCoCo excluye `*MapperImpl`

## Decisión

JaCoCo excluye `*MapperImpl` (MapStruct generado) del umbral de cobertura.

## Contexto

Bytecode de mapper generado se ejercita vía integración; tests unitarios mockean mappers en `@WebMvcTest`.

## Alternativas descartadas

Tests de integración dedicados al mapper si cambia la política
