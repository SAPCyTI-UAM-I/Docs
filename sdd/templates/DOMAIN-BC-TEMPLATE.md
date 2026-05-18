# Nuevo Bounded Context — {nombre-bc}

> Checklist para añadir un BC a `sdd/domain/`. Completar **antes** de la primera SPEC del BC.  
> Referencia: [`ContextMap.md`](../domain/ContextMap.md), [`Summary.md`](../domain/Summary.md).

---

## 1. Identificación

| Campo | Valor |
|-------|-------|
| **ID BC** | BC-{NN} |
| **Nombre** | {nombre legible} |
| **Tipo DDD** | Core / Supporting / Generic |
| **Módulo Java** | `{module}` (`mx.uam.sapcyti.{module}`) |
| **Drivers** | HU-XX, QA-X, CON-X |

---

## 2. Context Map

- [ ] Actualizar [`ContextMap.md`](../domain/ContextMap.md): nodo del BC y relaciones (Customer/Supplier, ACL, etc.)
- [ ] Documentar integración con BCs existentes (IDs, eventos, puertos)

---

## 3. Contrato de datos

- [ ] Crear [`schemas/{bc-name}.schema.json`](../domain/schemas/{bc-name}.schema.json)
  - Aggregates / entities / value objects
  - Commands y responses alineados con [`Architecture.md`](../../design/Architecture.md)
- [ ] Validar nombres de campos con convenciones en [`technologies/backend.md`](../../technologies/backend.md)

---

## 4. Comportamiento (Gherkin)

- [ ] Crear carpeta [`features/{bc-name}/`](../domain/features/)
- [ ] Un `.feature` por capacidad o HU agrupada
- [ ] Escenarios `@HappyPath` y `@BadPath` mapeables a Acceptance Criteria de specs futuras

---

## 5. Trazabilidad

- [ ] Enlazar HUs en [`vision/HU/`](../../vision/HU/)
- [ ] Añadir fila en [`design/IterationPlan.md`](../../design/IterationPlan.md) si cambia el alcance de iteración
- [ ] Actualizar [`Summary.md`](../domain/Summary.md) (resumen de la sesión de dominio)

---

## 6. Siguiente paso (implementación)

- [ ] Crear o extender `implementation/phaseX.md` con tareas → specs
- [ ] Redactar specs con [SPEC-TEMPLATE.md](SPEC-TEMPLATE.md)
- [ ] Registrar en [`SPEC_INDEX.md`](../SPEC_INDEX.md)

---

## Notas

{Decisiones de modelado, límites del BC, deuda conocida — enlazar `implementation/decisions/D-xxx` si ya existe}
