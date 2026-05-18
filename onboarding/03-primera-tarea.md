# Primera tarea — Checklist

## Antes de codificar

- [ ] Leer [`implementation/progress.md`](../implementation/progress.md) — dashboard (fase actual y próximo paso)
- [ ] Si trabajáis en paralelo: leer [`05-trabajo-en-equipo.md`](05-trabajo-en-equipo.md)
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

## Al cerrar tu sesión (antes del PR)

- [ ] **Crear** `implementation/sessions/YYYY-MM-DD-tuNombre.md` ([plantilla](../implementation/templates/SESSION-TEMPLATE.md))
- [ ] Decisiones nuevas → **crear** `implementation/decisions/D-NNN-slug.md` ([plantilla](../implementation/templates/DECISION-TEMPLATE.md))

## Después del merge

- [ ] Spec → ✅ en `sdd/SPEC_INDEX.md` (coordinador)
- [ ] Task → `[x]` en tu `phaseX.md`
- [ ] Coordinador actualiza `progress.md` § General Status / Current Phase (no añadir sesiones ni decisiones ahí)

## Ayuda

- Convenciones código: `.cursor/rules/sapcyti.mdc`
- Revisión: skill `review-code` + spec + `technologies/testing.md`
