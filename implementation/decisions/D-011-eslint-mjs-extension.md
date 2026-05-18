---
id: D-011
date: 2026-05-12
---

# D-011: `eslint.config.mjs` (extensión `.mjs`)

## Decisión

`eslint.config.mjs` (extensión `.mjs`) en lugar de `.js`.

## Contexto

`commitlint.config.js` usa CJS; agregar `"type":"module"` al `package.json` lo rompería; `.mjs` fuerza ESM por archivo sin afectar el resto.

## Alternativas descartadas

Agregar `"type":"module"` al `package.json`
