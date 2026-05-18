# Project Memory — SAPCyTI

> This file is the **central project memory**. It records phase status, decisions, blockers, and open items. Update after each work session.

---

## General Status

| Phase | Status | Progress | Last Updated |
|-------|--------|----------|--------------|
| 0 — Project setup | 🔵 In progress | 34/40 tasks (6 manual) | 2026-04-19 |
| 1 — Backend init | ✅ Completed | 17/17 checklist items | 2026-05-12 |
| 2 — Domain model | ✅ Completed | 10/10 tasks | 2026-05-17 |
| 3 — REST API | ✅ Completed | 12/12 tasks | 2026-05-17 |
| 4 — SPA init | 🔲 Not started | 0/16 tasks | — |
| 5 — Integration | 🔲 Not started | 0/17 tasks | — |

**Legend:** 🔲 Not started | 🔵 In progress | ✅ Completed | ⛔ Blocked

---

## Current Phase

**Phase:** 4A — SPA Scaffold & Tooling ✅ COMPLETED  
**Next phase:** 4 — SPA Core Architecture (SPEC-008B)  
**Next step:** Begin [`phase4.md`](phase4.md) — SPEC-008B (Core Providers, Shell, i18n)

## Phase History

| Phase | Completed | Notes |
|-------|-----------|-------|
| 3 — Program Configuration REST API | 2026-05-17 | SPEC-006, SPEC-007 |

### Pending Manual Tasks (Phase 0)

| Task | Action Required |
|------|-----------------|
| ❌ T0.1.3 | Configure branch protection on `develop` in both repos (GitHub Settings → Branches) |
| ❌ T0.1.4 | Configure branch protection on `main` in both repos (GitHub Settings → Branches) |
| ❌ T0.1.5 | Create `develop` branch: `git checkout -b develop; git push -u origin develop` in each repo |
| ❌ T0.2.1/T0.2.3 | Run `npm install` in `sapcyti-api/` to install commitlint + husky |
| ❌ T0.2.4/T0.2.5 | Run `npm install` in `sapcyti-spa/` (after Angular project init in Phase 4) |
| ❌ T0.5.5 | Configure GitHub secrets: `GHCR_TOKEN` (GitHub Settings → Secrets → Actions) |
| ❌ T0.7.1–T0.7.6 | All verification tasks (require prerequisites installed + code pushed to GitHub) |

---

## Decision Log

| # | Date | Decision | Context | Discarded Alternatives |
|---|------|----------|---------|------------------------|
| D-001 | 2026-04-19 | License: MIT | CON-1 requires OSS; MIT is simple and permissive | Apache 2.0, GPL |
| D-002 | 2026-04-19 | Conventional Commits with Node.js tooling on backend repo | commitlint + husky require Node.js; justified by consistency across repos | Manual commit validation, server-side hooks |
| D-003 | 2026-04-19 | Checkstyle based on Google Java Style (150-char line length) | Well-documented, widely adopted | SonarQube (too heavy for Phase 0), PMD |
| D-004 | 2026-04-19 | OWASP Dependency-Check as `continue-on-error: true` | Prevents blocking PRs for transitive vulnerabilities not under project control | Strict fail (blocks all PRs with any CVE) |
| D-005 | 2026-04-19 | `docker-compose.dev.yml` in `sapcyti-api/` only | Single DB instance shared by backend; SPA does not need its own DB | DB in root directory, separate repo |
| D-006 | 2026-04-19 | Quality tool plugins (JaCoCo, ESLint, istanbul) as CI steps | Maven/Angular plugins configured in Phase 1/4 when pom.xml/angular.json exist | Configure plugins before project exists |
| D-007 | 2026-04-24 | Project created manually (no Spring Initializr) | `start.spring.io` unreachable from dev environment; `pom.xml` written manually | Spring Initializr download |
| D-008 | 2026-04-24 | `TenantFilter` and `TenantContext` placed in `shared/tenant` | Cross-cutting concern not owned by any bounded context | Inside `configuration` module |
| D-009 | 2026-04-24 | `checkstyle.xml`: `LineLength` moved to `Checker` level | Checkstyle 10.x (maven-checkstyle-plugin 3.6.0) requires it outside `TreeWalker` | No change (broke build) |
| D-010 | 2026-05-12 | ESLint flat config (`eslint.config.mjs`) en lugar de `.eslintrc.json` | Angular 21 genera flat config por defecto; esquema más moderno y oficial | `.eslintrc.json` (legado, deprecado en ESLint 9+) |
| D-011 | 2026-05-12 | `eslint.config.mjs` (extensión `.mjs`) en lugar de `.js` | `commitlint.config.js` usa CJS; agregar `"type":"module"` al `package.json` lo rompería; `.mjs` fuerza ESM por archivo sin afectar el resto | Agregar `"type":"module"` al `package.json` |
| D-012 | 2026-05-12 | Vitest vía `@angular/build:unit-test` (integración nativa Angular 21) | Angular 21 incluye soporte Vitest nativo; `@analogjs/vitest-angular` no es necesario y genera conflictos de módulos ESM | `@analogjs/vitest-angular` |
| D-013 | 2026-05-12 | PostCSS configurado en `.postcssrc.json` en lugar de `postcss.config.js` | Formato JSON equivalente, ya existía en el proyecto; sin impacto funcional | `postcss.config.js` (especificado en SPEC-008A) |
| D-010 | 2026-05-12 | Dev PostgreSQL published on host **port 5433** (`docker-compose.dev.yml`); default `DB_URL` uses `localhost:5433` | Another PostgreSQL on Windows often owns **5432**, causing authentication failures when the app connected to the wrong instance | Keep **5432** inside the container only; document override via `DB_URL` |
| D-011 | 2026-05-17 | Phase 3: `MethodSecurityConfig` enables `@PreAuthorize` with `permitAll()` HTTP until Phase 6 | Full Spring Security deferred per `phase3.md` risk R-3.1 | Block all endpoints in Phase 6 |
| D-012 | 2026-05-17 | JaCoCo excludes `*MapperImpl` (MapStruct generated) from coverage gate | Generated mapper bytecode is exercised via integration paths; unit tests mock mappers in `@WebMvcTest` | Add dedicated mapper integration tests if policy changes |

---

## Blockers and Issues

| # | Date | Description | Status | Resolution |
|---|------|-------------|--------|------------|
| B-001 | 2026-04-19 | `npm` not available in current environment | ✅ Resolved | `pnpm` disponible y usado como package manager en `sapcyti-spa` |

---

## Lessons Learned

| # | Phase | Lesson |
|---|-------|--------|
| L-001 | 0 | Create all configuration files before running install commands — allows reviewing the complete setup before execution |
| L-002 | 0 | PowerShell on Windows uses `;` not `&&` for command chaining |

---

## Session Notes

### Session — 2026-04-19 (Planning)

- Created implementation plan with 6 phases (0–5) for Iteration 1
- Structured all documents following project template conventions
- Phase dependencies defined: P0 → P1 → P2 → P3 → P5; P0 → P4 → P5
- Technology stack confirmed: Spring Boot 3.x (Java 21) + Angular + PostgreSQL
- Deployment strategy: local Docker first, on-premise server after Iteration 2

### Session — 2026-05-17 (Phases 2–3 — BC-04 domain + REST API)

- **Phase 2** verificada en `sapcyti-api` (entidades, puertos, adaptadores JPA, Flyway V1/V2, tests `@DataJpaTest`); `phase2.md` y SPEC-004/005 → **✅ Implemented**.
- **Phase 3** implementada según SPEC-006/007: casos de uso, controladores REST, MapStruct, `GlobalExceptionHandler`, `MethodSecurityConfig`, excepciones de dominio.
- Endpoints: `POST/GET/PUT /api/programs`, rutas anidadas `/api/programs/{id}/parameters`.
- `mvn clean verify` ✅ (57 tests, cobertura ≥80% con exclusión `*MapperImpl`).
- Decisiones D-011, D-012 registradas.

### Session — 2026-05-12 (Phase 1 — Docs checklist + specs + local run)

- Cerrado el checklist completo en [`phase1.md`](phase1.md) (A1.1–A1.3, entregables, criterios de transición); fase marcada **✅ Completed**.
- [`SPEC_INDEX.md`](../sdd/SPEC_INDEX.md): **SPEC-001**, **SPEC-002**, **SPEC-003** → **✅ Implemented**; SPEC-004/005 siguen en borrador (Phase 2).
- Cabeceras de SPEC-001–003 alineadas con estado **Implemented**.
- Implementación y arranque local verificados en repo **`sapcyti-api`**: `mvn verify`, `spring-boot:run` con perfil `dev` y PostgreSQL vía Docker; decisión **D-010** (puerto host **5433**).
- **README** de `sapcyti-api`: sección explícita *Run locally* (PowerShell, variables, health check).

### Session — 2026-04-24 (Phase 1 Implementation)

- **Completed A1.1** (4/4 tasks): Spring Boot Project Creation
  - `pom.xml` created manually (Spring Initializr unreachable — D-007): Spring Boot 3.4.5, Java 21, Maven
  - Dependencies: `spring-boot-starter-web`, `data-jpa`, `validation`, `actuator`, `flyway-core`, `flyway-database-postgresql`, `postgresql`, `mapstruct`, `logstash-logback-encoder`
  - Plugins: `spring-boot-maven-plugin`, `maven-compiler-plugin` (MapStruct processor), `jacoco-maven-plugin` (≥80% coverage), `maven-checkstyle-plugin`
  - `application.yml`: datasource, JPA, Flyway, Actuator (`health`, `info`, `prometheus`) — all from env vars (Factor III)
  - `application-dev.yml`, `application-preprod.yml`, `application-prod.yml` created
  - `logback-spring.xml`: plain-text in `dev`, JSON (`logstash-logback-encoder`) in `preprod`/`prod`; MDC fields: `graduate_program_id`, `user_id`, `request_id`
  - Fixed `checkstyle.xml`: moved `LineLength` from `TreeWalker` to `Checker` level (D-009)
  - `mvn clean compile` → BUILD SUCCESS
- **Completed A1.2** (3/3 tasks): Hexagonal Package Structure
  - `configuration` module: 6 sub-packages with `package-info.java` documenting hexagonal layers
  - Placeholder modules `identity`, `academic`, `offering`, `enrollment`: each with `package-info.java` documenting bounded context, sub-domain classification, aggregates, context relationships, and iteration scope
  - `src/README.md`: package tree, layer rules table, design decisions reference
- **Completed A1.3** (3/3 tasks): Multi-Tenant Configuration
  - `TenantContext`: `ThreadLocal`-based store for `graduateProgramId`; `get/set/clear` API
  - `TenantFilter`: `OncePerRequestFilter`; reads `X-Graduate-Id`, writes to `TenantContext` + MDC; generates/echoes `X-Request-Id` correlation header; clears in `finally` block
  - `WebConfig`: `WebMvcConfigurer` CORS from `CORS_ALLOWED_ORIGINS` env var (default `http://localhost:4200`)
  - `TenantFilterTest`: 7/7 unit tests pass (context propagation, MDC propagation, context cleanup, exception safety)
- Decisions D-007 through D-009 recorded
- **All deliverables met:** E1.1 (`mvn clean compile` ✅), E1.2 (package structure ✅), E1.3 (7/7 tests ✅), E1.4 (profiles ✅)
- Next: Phase 2 — Domain model and persistence (GraduateProgram, ConfigurationParameter, JPA adapters, Flyway migrations)

### Session — 2026-05-12 (Phase 4A — SPA Scaffold & Tooling)

- **Completado A4A.1**: Angular 21.2.10 con strict mode, routing, CSS puro, standalone components, pnpm
- **Completado A4A.2**: Dependencias instaladas — Tailwind CSS 4 (PostCSS), PrimeNG 21 + @primeuix/themes + primeicons, @ngx-translate/core + http-loader
- **Completado A4A.3**: Tooling configurado
  - ESLint: `ng add @angular-eslint/schematics` → `eslint.config.mjs` (flat config ESM) — D-010, D-011
  - Prettier: `.prettierrc` completo + `prettier-plugin-tailwindcss` + `.prettierignore` + scripts `lint`/`format`
  - Vitest: `@angular/build:unit-test` (nativo Angular 21, sin `@analogjs`) — D-012; 2/2 tests pasan
- **Completado A4A.4**: Carpetas `core/`, `shared/`, `features/`, `models/`, `assets/i18n/` con `.gitkeep`; archivos `environment.ts` / `environment.prod.ts`
- **Verificaciones**: `ng serve` → HTTP 200 ✅ | `ng build --configuration production` → sin errores ✅ | `pnpm run lint` → ESLint + Prettier ✅ | `ng test` → Vitest 2/2 ✅
- Decisiones D-010 a D-013 registradas; B-001 resuelto
- **Siguiente:** Phase 4 — SPEC-008B (Core Providers, Shell & i18n)

### Session — 2026-04-19 (Phase 0 Implementation)

- **Completed A0.1** (5/7 tasks): Repository configuration
  - `.gitignore` (Java/Maven for API, Node for SPA), `LICENSE` (MIT), PR template, Issue templates (bug + feature) in both repos
  - Branch protection (T0.1.3, T0.1.4) and `develop` branch (T0.1.5) require manual GitHub configuration
- **Completed A0.2** (6/6 tasks — files created): Conventional Commits
  - `package.json` with commitlint + husky devDependencies, `commitlint.config.js`, `.husky/commit-msg` in both repos
  - User must run `npm install` to activate hooks
- **Completed A0.3** (6/6 tasks): Code quality tools
  - `checkstyle.xml` (Google Java Style adapted) for backend
  - ESLint, istanbul, npm audit configured in CI workflows
  - JaCoCo and OWASP configured in CI workflows with report artifacts
- **Completed A0.4** (6/6 tasks): Local development environment
  - `PREREQUISITES.md` with required tools and versions
  - `docker-compose.dev.yml` (PostgreSQL 16, persistent volume, health check)
  - `setup.sh` + `setup.ps1` (prerequisite check → PostgreSQL → npm install → build)
  - `.env.example` in both repos, `.editorconfig` (4sp Java, 2sp TS/HTML/CSS)
- **Completed A0.5** (4/5 tasks): CI/CD pipelines
  - PR Validation: Backend (3 jobs: lint/build-test/security), SPA (4 jobs: lint/test/audit/build)
  - Merge & Deploy: Both repos (build-test → Docker GHCR push → deploy stub)
  - GitHub secrets (T0.5.5) require manual configuration
- **Completed A0.6** (5/5 tasks): Base documentation
  - README.md (both repos): architecture, tech stack, quick start, project structure
  - CONTRIBUTING.md (both repos): GitFlow, Conventional Commits, PR process, code standards
  - TECH_DEBT.md, CHANGELOG.md in both repos
- **Pending A0.7** (0/6 tasks): All verification tasks require manual execution
- Decisions D-001 through D-006 recorded
- Next: Complete manual tasks (branch protection, npm install, develop branch), then Phase 1

---

## Future Iterations (Not Planned Yet)

The following iterations will be planned after Iteration 1 is complete:

| Iteration | Goal | Drivers |
|-----------|------|---------|
| **2** | DevOps and deployment infrastructure | QA-5, CON-2, CON-6 |
| **3** | Security cross-cutting concerns | QA-1, QA-2, HU-01 |
| **4** | Entity management and credentials | HU-15, HU-21, QA-6, HU-02, HU-28 |
| **4.1** | Bounded Context Map refinement | QA-3, QA-4, QA-5, CON-6 |
| **5** | Enrollment workflow | HU-06, HU-07, HU-08, HU-09, CON-3 |

---

## Quick Reference

- **General plan:** [`implementationPlan.md`](implementationPlan.md)
- **Architecture spec:** [`Architecture.md`](../design/Architecture.md) (all iterations)
- **Iteration plan:** [`IterationPlan.md`](../design/IterationPlan.md)
- **Phase guides:** [`phase0.md`](phase0.md) … [`phase5.md`](phase5.md)
