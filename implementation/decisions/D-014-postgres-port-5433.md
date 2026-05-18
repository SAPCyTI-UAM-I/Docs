---
id: D-014
date: 2026-05-12
---

# D-014: PostgreSQL en host puerto 5433

## Decisión

Dev PostgreSQL publicado en host **puerto 5433** (`docker-compose.dev.yml`); `DB_URL` por defecto usa `localhost:5433`.

## Contexto

Otro PostgreSQL en Windows suele ocupar **5432**, provocando fallos de autenticación al conectar la app a la instancia equivocada.

## Alternativas descartadas

Mantener solo **5432** en el contenedor; documentar override vía `DB_URL`
