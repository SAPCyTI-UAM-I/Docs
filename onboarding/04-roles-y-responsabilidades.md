# Roles y responsabilidades

## Arquitecto

- Mantiene `design/Architecture.md`, `IterationPlan.md`, `ArchitecturalDrivers.md`
- Descompone fases en `phaseX.md` y redacta o aprueba specs
- Aprueba specs (🔲 → 🔵); para BC nuevos: arquitecto + peer review
- Actualiza artefactos `sdd/domain/` al definir nuevos bounded contexts

## Implementador (estudiante o LLM)

- Implementa **solo** lo definido en la spec aprobada
- Escribe tests según la spec
- Abre PR con formato de commit acordado
- No modifica arquitectura ni scope sin spec amendada

## Revisor

- Valida PR **contra la spec**, no por criterio subjetivo
- Usa `technologies/testing.md` para convenciones de tests
- Rechaza cambios fuera de scope (§ Out of Scope de la spec)

## Coordinador / Product Owner

- Prioriza HUs y fases en `implementationPlan.md`
- No aprueba detalles técnicos de implementación (eso es la spec)

## Agente IA (Cursor + Engram)

- Sigue [`AGENTS.md`](../AGENTS.md) y skills en `.cursor/skills/`
- Proyecto Engram `sapcyti` para código; `plan-sdd-arc` para este repo Docs
- No sustituye `implementation/decisions/` para decisiones duraderas ni `progress.md` para el dashboard global
