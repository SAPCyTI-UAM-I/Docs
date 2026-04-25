# Phase 1 — Backend Project Initialization

> **Spec:** `Architecture.md` — Iteration 1, §5, §6.1 | **Status:** ✅ Completed — 2026-04-24
> **Drivers:** CON-1 (Java + OSS), CON-6 (modular monolith, predictable structure), QA-3 (parameterization), QA-4 (multi-tenant)

**Goal:** Create the Spring Boot project with the hexagonal package structure, multi-tenant support via `X-Graduate-Id` header, structured logging, and configuration profiles for all environments.

> **Environment:** Backend runs locally via `mvn spring-boot:run` against the PostgreSQL from `docker-compose.dev.yml` (Phase 0).

---

## A1.1 — Spring Boot Project Creation ✅

- [x] **T1.1.1** Generate project with Spring Initializr — Java 21, Spring Boot 3.x, Maven; dependencies: `spring-boot-starter-web`, `spring-boot-starter-data-jpa`, `spring-boot-starter-validation`, `spring-boot-starter-actuator`, `flyway-core`, `postgresql`
  - Project compiles with `mvn clean compile`; all dependencies resolved ✅
- [x] **T1.1.2** Configure `application.yml` — profiles `dev`, `preprod`, `prod`; datasource PostgreSQL; Flyway enabled; Actuator endpoints (`/health`, `/prometheus`, `/info`)
  - Profile-specific behavior (logging, datasource) switches via `SPRING_PROFILES_ACTIVE` ✅
- [x] **T1.1.3** Configure environment variable externalization (Factor III) — `DB_URL`, `DB_USER`, `DB_PASS`, `SPRING_PROFILES_ACTIVE` from env vars in `application.yml`
  - Zero hardcoded values; `.env` for local, platform variables for deployment ✅
- [x] **T1.1.4** Configure structured logging — SLF4J + Logback; `logstash-logback-encoder` for `preprod`/`prod` profiles; plain-text for `dev`; MDC fields: `graduate_program_id`, `user_id`, `request_id`
  - JSON logs in prod/preprod; readable console output in dev ✅

## A1.2 — Hexagonal Package Structure ✅

- [x] **T1.2.1** Create root package for `configuration` module — `mx.uam.sapcyti.configuration` with sub-packages: `domain/model`, `domain/port/in`, `domain/port/out`, `application/service`, `infrastructure/adapter/in`, `infrastructure/adapter/out`
  - Package tree reflects hexagonal architecture from §6.1 of Architecture.md ✅
- [x] **T1.2.2** Create placeholder packages for future modules — `identity`, `academic`, `offering`, `enrollment` — each with `package-info.java` documenting bounded context, iteration, and IC constraints
  - All bounded context modules present as documented stubs; no business logic yet ✅
- [x] **T1.2.3** Document structure in `src/README.md` — module overview, hexagonal layer explanation, dependency rules
  - New developer understands the package organization ✅

## A1.3 — Multi-Tenant Configuration ✅

- [x] **T1.3.1** Create `TenantFilter` — `OncePerRequestFilter` reading `X-Graduate-Id` header, storing value in `ThreadLocal` + `MDC`
  - Every request with the header populates tenant context; MDC enables tenant-scoped log filtering ✅
- [x] **T1.3.2** Create `TenantContext` utility class — `getCurrentTenantId()`, `setCurrentTenantId()`, `clear()` methods; `ThreadLocal`-based
  - Tenant ID accessible from any layer without parameter passing ✅
- [x] **T1.3.3** Configure basic CORS — `WebMvcConfigurer` with allowed origins from `CORS_ALLOWED_ORIGINS` env var
  - SPA can communicate with the backend during development ✅

---

## Deliverables

- [x] **E1.1** Compilable Maven project — `mvn clean compile` succeeds with all dependencies ✅
- [x] **E1.2** Hexagonal package structure — directories created per §6.1 with placeholder `package-info.java` ✅
- [x] **E1.3** Functional tenant filter — unit test validates `X-Graduate-Id` propagation to `TenantContext` and MDC ✅ (7/7 tests pass)
- [x] **E1.4** Configuration profiles — `application.yml` + `application-dev.yml` functional with env var resolution ✅

---

## Notes and Decisions

| # | Date | Decision | Context |
|---|------|----------|---------|
|| D-007 | 2026-04-24 | Project created manually (no Spring Initializr) | `start.spring.io` unreachable from dev environment; `pom.xml` written manually with identical dependency set |
|| D-008 | 2026-04-24 | `TenantFilter` and `TenantContext` in `shared/tenant` | Cross-cutting concern not owned by any bounded context; `shared` package keeps them accessible without coupling |
|| D-009 | 2026-04-24 | `checkstyle.xml`: `LineLength` moved from `TreeWalker` to `Checker` | Checkstyle 10.x (maven-checkstyle-plugin 3.6.0) requires `LineLength` at `Checker` level |
