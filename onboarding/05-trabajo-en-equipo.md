# Trabajo en equipo — Sin conflictos en Git

> Reglas para 3 integrantes trabajando en paralelo en `Docs` y repos de código.

## Problema que evitamos

Si todos editan `implementation/progress.md` (decisiones, sesiones, estado), **cada merge genera conflictos**. La solución es **un archivo por autor/sesión/decisión**, no un monolito compartido.

## Estructura

```text
implementation/
├── progress.md           # Dashboard — solo coordinador actualiza estado global
├── sessions/             # Tú CREAS un archivo nuevo por sesión
├── decisions/            # Tú CREAS un archivo nuevo por decisión D-xxx
├── blockers/             # Opcional — un archivo por blocker
├── phaseX.md             # Un dueño por fase (asignación del equipo)
└── implementationPlan.md
```

## Asignación sugerida

| Rol | Archivos que puede editar |
|-----|---------------------------|
| **Cualquier integrante** | `sessions/YYYY-MM-DD-tuNombre.md` (nuevo), `decisions/D-xxx-*.md` (nuevo), tu `phaseX.md`, tu spec |
| **Coordinador** (rotativo) | `progress.md` § General Status, § Current Phase; `sdd/SPEC_INDEX.md` al integrar a `develop` |
| **Nadie en feature branch** | No editar `progress.md` en la misma rama que otro compañero |

Acordar en el equipo quién es dueño de cada `phase6.md`, `phase4.md`, etc.

## Flujo por sesión de trabajo

1. Leer `progress.md` (solo lectura) + tu `phaseX.md` + spec.
2. Implementar en `sapcyti-api` / `sapcyti-spa`.
3. Al terminar: **crear** `sessions/2026-05-18-maría.md` (no editar sesiones ajenas).
4. Si hay decisión durable: **crear** `decisions/D-017-descripcion-corta.md`.
5. Marcar checkboxes en **tu** `phaseX.md`.
6. PR de código: incluir solo tus archivos de `sessions/` y `decisions/`.
7. Tras merge a `develop`: coordinador actualiza `progress.md` y `SPEC_INDEX` una vez.

## Qué va dónde

| Contenido | Ubicación | Conflicto |
|-----------|-----------|-----------|
| "Hoy implementé X" | `sessions/` nuevo | Ninguno |
| Decisión D-xxx | `decisions/` nuevo | Ninguno |
| Tarea [ ] / [x] | Tu `phaseX.md` | Bajo si hay un dueño |
| Estado global del proyecto | `progress.md` | Solo coordinador |
| Chat / exploración | Engram | Fuera de Git |

## Reglas Git

1. **Nunca** editar el mismo `phaseX.md` que otro sin acordarlo.
2. **Nunca** añadir sesiones al final de `progress.md` — usar `sessions/`.
3. **Nunca** añadir filas al Decision Log en `progress.md` — usar `decisions/`.
4. PR de docs opcional separado del PR de código si el diff es grande.
5. Convención de nombre de sesión: `YYYY-MM-DD-nombreCorto.md` (minúsculas, sin espacios).

## Plantillas

- Sesión: [`implementation/templates/SESSION-TEMPLATE.md`](../implementation/templates/SESSION-TEMPLATE.md)
- Decisión: [`implementation/templates/DECISION-TEMPLATE.md`](../implementation/templates/DECISION-TEMPLATE.md)
