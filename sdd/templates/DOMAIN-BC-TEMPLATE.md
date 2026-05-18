# Checklist — Nuevo Bounded Context: {bc-name}

> Completar **antes** de redactar la primera SPEC del BC.

## 1. Context Map

- [ ] Actualizar [`sdd/domain/ContextMap.md`](../domain/ContextMap.md) con el BC, aggregates y relaciones
- [ ] Documentar integraciones (Customer-Supplier, ACL, etc.)

## 2. JSON Schema

- [ ] Crear [`sdd/domain/schemas/{bc-name}.schema.json`](../domain/schemas/)
- [ ] Definir aggregates, commands, field types y constraints

## 3. Gherkin Features

- [ ] Crear [`sdd/domain/features/{bc-name}/`](../domain/features/)
- [ ] Escenarios happy path y `@BadPath` para edge cases

## 4. Summary

- [ ] Actualizar [`sdd/domain/Summary.md`](../domain/Summary.md) con el BC añadido

## 5. Trazabilidad

- [ ] Enlazar drivers en [`design/ArchitecturalDrivers.md`](../../design/ArchitecturalDrivers.md)
- [ ] Verificar sección relevante en [`design/Architecture.md`](../../design/Architecture.md)

## 6. Primera SPEC

- [ ] Descomponer tareas en `implementation/phaseX.md`
- [ ] Redactar SPEC con [`SPEC-TEMPLATE.md`](SPEC-TEMPLATE.md)
- [ ] Registrar en [`sdd/SPEC_INDEX.md`](../SPEC_INDEX.md)
