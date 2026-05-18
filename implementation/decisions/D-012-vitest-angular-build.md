---
id: D-012
date: 2026-05-12
---

# D-012: Vitest vía `@angular/build:unit-test`

## Decisión

Vitest vía `@angular/build:unit-test` (integración nativa Angular 21).

## Contexto

Angular 21 incluye soporte Vitest nativo; `@analogjs/vitest-angular` no es necesario y genera conflictos de módulos ESM.

## Alternativas descartadas

`@analogjs/vitest-angular`
