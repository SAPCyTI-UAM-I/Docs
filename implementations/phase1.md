# Phase 1 — Backend Project Initialization

> **ADD Iteration:** 1
> **Drivers:** CON-1 (Java + OSS), CON-6 (modular monolith, predictable structure), QA-3 (parameterization), QA-4 (multi-tenant)
> **Status:** 🔲 Pending

**Goal:** Create the Spring Boot project with the hexagonal package structure, multi-tenant support via `X-Graduate-Id` header, structured logging, and configuration profiles for all environments.

> **Environment:** Backend runs locally via `mvn spring-boot:run` against the PostgreSQL from `docker-compose.dev.yml` (Phase 0).

### User Stories (HU)

> **No user stories apply to this phase.** Phase 1 is pure infrastructure scaffolding (project skeleton, package structure, multi-tenant filter). It enables all subsequent HU implementations but does not deliver any user-facing functionality.

---

## A1.1 — Spring Boot Project Creation 🔲

> Specs: [SPEC-001 — Spring Boot y build Maven](../SDD/specs/iteration-1/SPEC-001_spring-boot-project-and-maven-build.md)

- [ ] **T1.1.1** Create `pom.xml` — Java 21, Spring Boot 3.4.5, Maven wrapper; all dependencies from [`technologies/backend.md`](../SDD/technologies/backend.md): `spring-boot-starter-web`, `data-jpa`, `validation`, `actuator`, `flyway-core`, `flyway-database-postgresql`, `postgresql`, `mapstruct`, `logstash-logback-encoder` → SPEC-001
- [ ] **T1.1.2** Add build plugins: `spring-boot-maven-plugin`, `maven-compiler-plugin` (Java 21 + MapStruct processor), `jacoco-maven-plugin` (≥80%), `maven-checkstyle-plugin` (Google Java Style) → SPEC-001
- [ ] **T1.1.3** Create `SapcytiApplication.java` — `@SpringBootApplication` entry point → SPEC-001
- [ ] **T1.1.4** Verify `mvn clean compile` succeeds with all dependencies resolved → SPEC-001

## A1.2 — Configuration & Profiles 🔲

> Specs: [SPEC-002 — Configuración, perfiles y logging](../SDD/specs/iteration-1/SPEC-002_application-configuration-profiles-logging.md)

- [ ] **T1.2.1** Create `application.yml` — DataSource via env vars (`DB_URL`, `DB_USER`, `DB_PASS`), JPA ddl-auto=validate, Flyway enabled, Actuator endpoints (`/health`, `/info`, `/prometheus`) → SPEC-002
- [ ] **T1.2.2** Create profile files: `application-dev.yml`, `application-preprod.yml`, `application-prod.yml` — switching behavior via `SPRING_PROFILES_ACTIVE` → SPEC-002
- [ ] **T1.2.3** Create `logback-spring.xml` — plain-text in `dev`, JSON (`logstash-logback-encoder`) in `preprod`/`prod`; MDC fields: `graduate_program_id`, `user_id`, `request_id` → SPEC-002

## A1.3 — Hexagonal Package Structure 🔲

> Specs: [SPEC-003 — Paquetes hexagonales, tenant y CORS](../SDD/specs/iteration-1/SPEC-003_hexagonal-packages-tenant-filter-cors.md)
> Ref: [`Architecture.md §6.1`](../Design/Architecture.md) — Module package structure

**Paquete base Java:** `mx.uam.sapcyti` (subpaquetes por BC como en SPEC-003 y Architecture §6.1).

- [ ] **T1.3.1** Create `configuration` module package tree: `domain/model`, `domain/port/in`, `domain/port/out`, `application/service`, `infrastructure/adapter/in/dto`, `infrastructure/adapter/out`, `infrastructure/mapper` — each with `package-info.java` documenting hexagonal layer → SPEC-003
- [ ] **T1.3.2** Create placeholder module packages: `identity` (with `security/`), `academic` (with `domain/service/`, `mapper/`), `offering` (with `acl/`), `enrollment` (with `acl/`), `audit` — each with `package-info.java` documenting BC, sub-domain, and iteration scope → SPEC-003
- [ ] **T1.3.3** Create `shared/tenant/TenantContext.java` — `ThreadLocal<Long>`-based; `get()`, `set()`, `clear()` methods → SPEC-003
- [ ] **T1.3.4** Create `shared/tenant/TenantFilter.java` — `OncePerRequestFilter`; reads `X-Graduate-Id` → `TenantContext` + MDC; generates/echoes `X-Request-Id`; clears in `finally` block → SPEC-003
- [ ] **T1.3.5** Create `shared/config/WebConfig.java` — `WebMvcConfigurer` CORS from `CORS_ALLOWED_ORIGINS` env var (default `http://localhost:4200`) → SPEC-003
- [ ] **T1.3.6** Document structure in `src/README.md` — module overview, hexagonal layer explanation, dependency rules → SPEC-003

---

## Deliverables

- [ ] **E1.1** Compilable Maven project — `mvn clean compile` succeeds with all dependencies — [SPEC-001](../SDD/specs/iteration-1/SPEC-001_spring-boot-project-and-maven-build.md)
- [ ] **E1.2** Configuration profiles — `application.yml` + profiles functional with env var resolution — [SPEC-002](../SDD/specs/iteration-1/SPEC-002_application-configuration-profiles-logging.md)
- [ ] **E1.3** Hexagonal package structure — directories per §6.1 with `package-info.java` — [SPEC-003](../SDD/specs/iteration-1/SPEC-003_hexagonal-packages-tenant-filter-cors.md)
- [ ] **E1.4** Functional tenant filter — unit tests validate `X-Graduate-Id` propagation to `TenantContext` and MDC — [SPEC-003](../SDD/specs/iteration-1/SPEC-003_hexagonal-packages-tenant-filter-cors.md)

---

## Transition Criteria

- [ ] `mvn clean compile` succeeds without errors
- [ ] `mvn test` passes all TenantFilter and TenantContext tests
- [ ] Package tree matches `Architecture.md §6.1` exactly (6 BC modules + shared)
- [ ] Configuration profiles switch via `SPRING_PROFILES_ACTIVE` env var
- [ ] Las specs [SPEC-001](../SDD/specs/iteration-1/SPEC-001_spring-boot-project-and-maven-build.md), [SPEC-002](../SDD/specs/iteration-1/SPEC-002_application-configuration-profiles-logging.md) y [SPEC-003](../SDD/specs/iteration-1/SPEC-003_hexagonal-packages-tenant-filter-cors.md) están ✅ Implemented
- [ ] No regressions from Phase 0

---

## Risks

| # | Risk | Impact | Probability | Mitigation |
|---|------|--------|-------------|------------|
| R-1.1 | Spring Initializr unreachable | Bajo | Media | Create `pom.xml` manually (precedent: D-007) |
| R-1.2 | Checkstyle version incompatibility | Bajo | Baja | Pin `maven-checkstyle-plugin` 3.6.0+ (precedent: D-009) |
| R-1.3 | Maven wrapper not working on Windows | Bajo | Baja | Use global `mvn` as fallback |

---

## Notes and Decisions

> Las decisiones se registran en [`progress.md`](progress.md) Decision Log.
> Aquí solo se referencian las relevantes a este phase.

| # | Decision ID | Summary |
|---|-------------|---------|
| — | [D-007](progress.md) | Project created manually — Spring Initializr unreachable |
| — | [D-008](progress.md) | TenantFilter in `shared/tenant` — cross-cutting concern |
| — | [D-009](progress.md) | Checkstyle LineLength at Checker level |
