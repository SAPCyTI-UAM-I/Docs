# Primera tarea — Checklist

## Antes de codificar

- [ ] Leer [`implementations/progress.md`](../implementations/progress.md) — fase actual y próximo paso
- [ ] Confirmar spec asignada en `phaseX.md` (estado 🔵 Approved)
- [ ] Leer la spec **completa** — es autocontenida
- [ ] Si usas Cursor: revisar [`AGENTS.md`](../AGENTS.md) y skill `implement-spec`

## Durante la implementación

- [ ] Crear solo archivos listados en la spec
- [ ] Tests según § Testing Strategy
- [ ] Commits: `feat(module): SPEC-NNN descripción`
- [ ] No importar entre bounded contexts (usar output ports)

## Antes del PR

- [ ] Todos los Acceptance Criteria cumplidos
- [ ] CI local: build + tests
- [ ] PR referencia SPEC-XXX y enlaza la spec

## Después del merge

- [ ] Spec → ✅ en `SDD/SPEC_INDEX.md`
- [ ] Task → `[x]` en `phaseX.md`
- [ ] Decisiones relevantes → `progress.md` Decision Log

## Ayuda

- Convenciones código: `.cursor/rules/sapcyti.mdc`
- Revisión: skill `review-code` + spec + `SDD/technologies/testing.md`
