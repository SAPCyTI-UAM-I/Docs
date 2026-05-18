# Guía de merge — reorganización del banco de memoria

> **Documento histórico** (rama `docs/reorganize-memory-bank`, 2026-05). Tras el merge, usar [`CANONICAL.md`](../CANONICAL.md) y [`AGENTS.md`](../AGENTS.md) como referencia operativa.

## Estrategia de PR

El plan original proponía **4 PRs** (hitos A–D). Se consolidó en **una rama con ~32 commits** ordenados cronológicamente para preservar historial `git mv` y revisión atómica por commit.

| Hito | Commits (aprox.) | Contenido |
|------|------------------|-----------|
| A | 12–14 | CANONICAL, AGENTS, canonización, verify script |
| B | 8–10 | onboarding, READMEs por carpeta |
| C | 3–4 | rename carpetas, links, eliminar `specifications/` |
| D | 8–10 | plantillas, SPEC_INDEX, Architecture-INDEX |

## Cómo revisar

1. Ejecutar `./scripts/verify-docs.sh` (también corre en CI — [`.github/workflows/docs-verify.yml`](../.github/workflows/docs-verify.yml)).
2. Revisar [`CANONICAL.md`](../CANONICAL.md) — mapa de rutas.
3. Spot-check: `README.md`, `AGENTS.md`, una spec (`sdd/specs/iteration-1/SPEC-006_*.md`).
4. Confirmar que `git log --follow design/Architecture.md` muestra historial preservado.

## Qué no cambió

- Contenido de specs, HUs, Architecture.md (salvo enlaces relativos).
- Repos de código `sapcyti-api` / `sapcyti-spa`.

## Post-merge

- Actualizar bookmarks locales a rutas nuevas (`vision/`, `sdd/`, `implementation/`).
- Configurar Engram proyecto `plan-sdd-arc` para este repo Docs.
