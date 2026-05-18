---
id: D-015
date: 2026-05-17
---

# D-015: MethodSecurity con `permitAll()` hasta Phase 6

## Decisión

Phase 3: `MethodSecurityConfig` habilita `@PreAuthorize` con `permitAll()` HTTP hasta Phase 6.

## Contexto

Spring Security completo diferido según riesgo R-3.1 en `phase3.md`.

## Alternativas descartadas

Bloquear todos los endpoints ya en Phase 6
