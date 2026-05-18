# Diseño arquitectónico — SAPCyTI

## Propósito

Decisiones ADD: arquitectura detallada, plan de iteraciones y drivers que justifican el diseño.

## Cuándo leer esto

- Rol arquitecto o al escribir specs
- Secciones puntuales al implementar (copiadas en spec § Architectural Context)
- No el archivo `Architecture.md` completo en una sesión de implementación

## Índice

| Archivo | Contenido | Obligatorio |
|---------|-----------|-------------|
| [Architecture.md](Architecture.md) | Decisiones, dominio, paquetes (~2400 líneas) | Por sección |
| [IterationPlan.md](IterationPlan.md) | Iteraciones ADD y drivers | Planificación |
| [`../ArchitecturalDrivers.md`](../ArchitecturalDrivers.md) | HU/QA/CON drivers | Trazabilidad |
| [`../ADD.md`](../ADD.md) | Proceso ADD para agentes | Trabajo ADD |

## Rutas canónicas

- Arquitectura: `Design/Architecture.md`
- Drivers: `ArchitecturalDrivers.md` (moverá a `design/` en Hito C)

## Qué NO cargar

- `Architecture.md` entero al implementar una spec autocontenida

## Siguiente paso

- Dominio DDD: [`../SDD/domain/ContextMap.md`](../SDD/domain/ContextMap.md)
- Specs: [`../SDD/SPEC_INDEX.md`](../SDD/SPEC_INDEX.md)
