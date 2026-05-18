# Implementación — SAPCyTI

## Propósito

Estado operativo del proyecto: dashboard (`progress.md`), plan de fases, mapas de tareas (`phaseX.md`), sesiones y decisiones en archivos separados.

## Cuándo leer esto

- Inicio de cada sesión de trabajo
- Para saber la fase actual y la siguiente spec
- Para registrar una sesión o decisión nueva (archivo propio)

## Índice

| Archivo / carpeta | Contenido | Quién edita |
|-------------------|-----------|-------------|
| [implementationPlan.md](implementationPlan.md) | Fases 0–9, dependencias, vista macro | Arquitecto / coordinador |
| [progress.md](progress.md) | Dashboard: estado global, fase actual | **Coordinador** |
| [sessions/](sessions/README.md) | Notas por sesión (`YYYY-MM-DD-nombre.md`) | **Cada integrante** (archivo nuevo) |
| [decisions/](decisions/README.md) | Decisiones D-xxx (`D-NNN-slug.md`) | **Cada integrante** (archivo nuevo) |
| [blockers/](blockers/) | Blockers B-xxx | Quien reporta |
| [phase0.md](phase0.md) … [phase9.md](phase9.md) | Tareas y links a specs | Dueño de la fase |
| [templates/](templates/) | SESSION, DECISION | — |
| [example/](example/) | Plantillas de ejemplo | No |

> Flujo en equipo: [`onboarding/05-trabajo-en-equipo.md`](../onboarding/05-trabajo-en-equipo.md)

## Rutas canónicas

- Estado fino: `progress.md` (prevalece sobre `implementationPlan.md` en conflictos)
- Specs: [`../sdd/specs/`](../sdd/specs/)

## Qué NO cargar al implementar

- `implementationPlan.md` completo si ya tienes la spec
- Fases distintas a la asignada

## Siguiente paso

Leer `progress.md` § Current Phase → abrir tu `phaseX.md` → spec enlazada. Al cerrar sesión: crear archivo en `sessions/` (y `decisions/` si aplica).
