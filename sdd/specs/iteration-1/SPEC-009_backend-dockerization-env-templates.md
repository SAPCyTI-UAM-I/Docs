---
spec_id: SPEC-009
status: draft
phase: 5
bounded_context: platform
drivers: [CON-2, QA-5, CON-6]
depends_on: [SPEC-003, SPEC-007]
---

# SPEC-009: Backend Dockerization & Environment Templates

> **Status:** 🔲 Draft
> **Author:** SAPCyTI SDD
> **Date:** 2026-05-19
> **Phase:** 5 (A5.1) | **ADD Iteration:** 1–2
> **Bounded Context:** — (platform / DevOps; no domain BC)
> **Drivers:** [CON-2](../../../requirements/Atributos_y_Restricciones.md) (on-premise deployment), [QA-5](../../../requirements/Atributos_y_Restricciones.md) (cloud portability), [CON-6](../../../requirements/Atributos_y_Restricciones.md) (repeatable ops for student team)
> **Domain Schema:** N/A
> **Domain Features:** N/A
> **Depends on:** [SPEC-003](SPEC-003_hexagonal-packages-tenant-filter-cors.md), [SPEC-007](SPEC-007_configuration-parameter-application-rest-global-errors.md) — runnable API with Flyway and Actuator
> **Blocks:** [SPEC-010](SPEC-010_full-stack-compose-nginx-smoke.md) — Compose `api` service image and env contract
> **External Dependencies:**
>   - [ ] Docker Engine + Compose v2 on developer machine ([`PREREQUISITES.md`](../../../../sapcyti-api/PREREQUISITES.md))

---

## 1. Business Justification

Phase 5 packages the backend for the same deployment model described in Architecture §7: a containerized Spring Boot process with externalized configuration (Factor III) and health probes (Factor XII). Without a production-grade `Dockerfile` and environment templates, the team cannot run the full stack locally nor reuse images in CI (`merge-deploy.yml` already expects a root `Dockerfile`).

**Acceptance Criteria (Business):**
- [ ] AC-1: The API image builds from a clean Git checkout with `docker build` (no manual JAR copy).
- [ ] AC-2: The container starts against PostgreSQL using only environment variables (no hardcoded JDBC URLs).
- [ ] AC-3: `GET /actuator/health` returns `UP` when the database is healthy.
- [ ] AC-4: Flyway migrations apply automatically on container startup against an empty database.

---

## 2. Scope

### In Scope
- Multi-stage `Dockerfile` in `sapcyti-api/` (Maven build → Eclipse Temurin 21 JRE runtime).
- `.dockerignore` to keep build context small.
- Spring profile `docker` + `application-docker.yml` for Compose networking (`db:5432`, `SERVER_PORT=8080`).
- Environment templates: `.env.docker.example`, `.env.preprod.example` (committed); document `.env.prod` as server-only (not committed).
- `HEALTHCHECK` calling Actuator health on port 8080 inside the container.
- Align defaults with existing `docker-compose.dev.yml` credentials pattern (same user/db naming; different host/port for standalone dev DB).

### Out of Scope
- Full multi-service `docker-compose.yml` (Nginx + SPA) — [SPEC-010](SPEC-010_full-stack-compose-nginx-smoke.md)
- SPA image — SPEC-010
- GHCR push / deploy SSH — Iteration 2 / existing stub in workflows
- Production monitoring stack (VictoriaMetrics, Grafana) — Architecture §7 future envs
- Real JWT authentication — Phase 6; this spec may add a **smoke-only** security profile (see §4.3)

### Assumptions
- [SPEC-007](SPEC-007_configuration-parameter-application-rest-global-errors.md) is ✅ — REST API and Flyway migrations exist.
- `docker-compose.dev.yml` remains the **database-only** workflow for local JVM development (host port **5433**); it is **not** replaced by this spec.
- CI `merge-deploy.yml` `docker-build` job uses `context: .` at repository root — `Dockerfile` must live at `sapcyti-api/Dockerfile`.

---

## 3. Architecture Impact

### Affected Layers

| Layer | Artifact | Action | Notes |
|-------|----------|--------|-------|
| Repo root | `Dockerfile` | CREATE | Multi-stage build |
| Repo root | `.dockerignore` | CREATE | Exclude `target/`, `.git`, etc. |
| `src/main/resources` | `application-docker.yml` | CREATE | Compose profile |
| Repo root | `.env.docker.example` | CREATE | Vars for SPEC-010 compose |
| Repo root | `.env.preprod.example` | CREATE | Template for on-prem preprod |
| `shared/config` | `DockerSecurityConfig.java` (optional) | CREATE | `@Profile("docker")` — see §4.3 |
| `README.md` | — | MODIFY | Docker build/run section |

### Package Location

```text
sapcyti-api/
├── Dockerfile
├── .dockerignore
├── .env.docker.example
├── .env.preprod.example
├── docker-compose.dev.yml          ← UNCHANGED (DB-only dev)
└── src/main/resources/
    ├── application.yml
    └── application-docker.yml        ← CREATE
```

### Architectural Context

From [`Architecture.md` §7 — Deployment view](../../../design/Architecture.md):

> The deployment topology is based on **Docker** and **Docker Compose** on the on-premise Linux server (CON-2). … Runtime configuration is externalized via environment variables, ensuring the same `docker-compose.yml` is used across all environments (Factor X — Dev/prod parity). … **Backend API Container** — Run the Spring Boot application (stateless process, Factor VI); connect to PostgreSQL … expose `/actuator/health` for Docker `HEALTHCHECK` … Flyway runs DB migrations on startup (Factor XII).

From [`technologies/devops.md`](../../technologies/devops.md):

> **Backend Dockerfile (multi-stage):** Stage 1 Maven build; Stage 2 JRE 21 runtime, expose 8080; HEALTHCHECK via Actuator.

### Cross-Module Dependencies

- None at domain level. Image is consumed by Compose in SPEC-010.

---

## 4. Technical Design

### 4.1 Domain Model

N/A.

### 4.2 Port Contracts

N/A.

### 4.3 Infrastructure — Dockerfile

**Stage 1 — build (`eclipse-temurin:21-jdk`):**

- Copy `pom.xml`, `mvnw`, `.mvn/` first for dependency layer cache.
- Run `./mvnw -B -DskipTests package` (or `clean package` if cache not used).
- Output: `target/*.jar` (Spring Boot repackaged JAR).

**Stage 2 — runtime (`eclipse-temurin:21-jre-jammy` or `-alpine` if team validates Alpine+glibc):**

- Create non-root user `sapcyti` (UID 10001).
- Copy JAR as `/app/app.jar`.
- `EXPOSE 8080`
- `ENV SPRING_PROFILES_ACTIVE=docker`
- `ENTRYPOINT ["java", "-jar", "/app/app.jar"]`
- **HEALTHCHECK:**

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1
```

> Install `curl` in runtime image if base image lacks it, or use `wget`/`java` alternative documented in README.

### 4.4 `application-docker.yml`

| Property | Value | Notes |
|----------|-------|-------|
| `spring.datasource.url` | `${DB_URL:jdbc:postgresql://db:5432/sapcyti_dev}` | Compose service name `db` |
| `spring.datasource.username` | `${DB_USER:sapcyti}` | |
| `spring.datasource.password` | `${DB_PASS}` | Required — no default in prod |
| `server.port` | `${SERVER_PORT:8080}` | Align with Architecture/devops |
| `logging.level.mx.uam.sapcyti` | `INFO` | Less verbose than local `dev` |

**CORS:** `CORS_ALLOWED_ORIGINS` must include `http://localhost` (port 80) for SPEC-010 Nginx origin.

### 4.5 Smoke profile — method security (Phase 3 → 5 gap)

Program Configuration endpoints use `@PreAuthorize("hasRole('COORDINATOR')")` ([SPEC-006](SPEC-006_graduate-program-application-rest-api.md)). Until Phase 6, automated stack smoke cannot call `/api/programs` without a test principal.

**Decision (implement in this spec):** Add `@Profile("docker")` configuration class `DockerSecurityConfig` that:

- Keeps `SecurityFilterChain` with `permitAll()` for HTTP (same as `MethodSecurityConfig`).
- Adds an in-memory `UserDetailsService` with user `coordinator` / password from env `SMOKE_COORDINATOR_PASSWORD` (default `changeme` in `.env.docker.example` only) and role `COORDINATOR`.
- Enables `httpBasic` for smoke scripts only (documented as **non-production**).

> **Out of scope for preprod/prod profiles** — `.env.preprod.example` must NOT enable smoke basic auth; Phase 6 replaces this.

### 4.6 Environment templates

**`.env.docker.example`** (committed):

```env
# Used by docker compose -f docker-compose.yml (SPEC-010)
COMPOSE_PROJECT_NAME=sapcyti-local

DB_URL=jdbc:postgresql://db:5432/sapcyti_dev
DB_USER=sapcyti
DB_PASS=sapcyti_dev_pass

POSTGRES_DB=sapcyti_dev
POSTGRES_USER=sapcyti
POSTGRES_PASSWORD=sapcyti_dev_pass

SPRING_PROFILES_ACTIVE=docker
SERVER_PORT=8080
CORS_ALLOWED_ORIGINS=http://localhost

# Smoke only — do not use in production
SMOKE_COORDINATOR_PASSWORD=changeme
```

**`.env.preprod.example`** (committed): same keys with placeholders `CHANGE_ME` for secrets; document pairing with namespaced project `sapcyti-preprod` per Architecture §7.

### 4.7 API Contract

No new REST endpoints. Existing Actuator:

```
GET /actuator/health
Response 200: { "status": "UP", ... }
```

---

## 5. Security Considerations

| # | Threat | CWE | Mitigation | Validated By |
|---|--------|-----|------------|--------------|
| SEC-1 | Secrets in image layers | CWE-798 | Build-args only for non-secrets; runtime env from Compose | Image inspect / review |
| SEC-2 | Running as root | CWE-250 | Non-root `USER sapcyti` in Dockerfile | Dockerfile review |
| SEC-3 | Smoke basic auth left enabled in prod | CWE-1188 | `@Profile("docker")` only; preprod/prod templates exclude smoke password | Profile activation test |

**Access Control:** Smoke basic auth is **development/stack verification only** — documented in README and TECH_DEBT.

---

## 6. Edge Cases & Error Handling

| # | Scenario | Expected Behavior | HTTP Status | Notes |
|---|----------|-------------------|-------------|-------|
| EC-1 | DB not ready on first start | API container restarts until `depends_on: db` healthy | — | Compose healthcheck on `db` |
| EC-2 | Flyway migration failure | Container exits non-zero; logs show Flyway error | — | `docker compose logs api` |
| EC-3 | Wrong `DB_URL` (host `localhost` inside container) | Connection refused | — | Use `db` hostname in docker profile |
| EC-4 | Missing `DB_PASS` | Fail fast at startup | — | Spring binding error |

---

## 7. Performance & Scalability Notes

No performance concerns — single-instance smoke stack. Maven layer caching recommended to keep rebuild time acceptable on student laptops.

---

## 8. Migration & Rollback Strategy

- **Flyway:** unchanged migrations; rollback = redeploy previous image tag.
- **Dockerfile rollback:** revert commit; rebuild image.
- **`docker-compose.dev.yml`:** unchanged — no migration path required for developers using host JVM.

---

## 9. Testing Strategy

| Test Type | Scope | Framework |
|-----------|-------|-----------|
| Manual | `docker build -t sapcyti-api:local .` succeeds | Docker CLI |
| Manual | Run container with ephemeral Postgres (`docker run` / compose `api`+`db` only) → health UP | curl |
| CI | Existing `merge-deploy.yml` `docker-build` job must pass after Dockerfile added | GitHub Actions |

> **Reference:** [`technologies/devops.md`](../../technologies/devops.md), [`technologies/testing.md`](../../technologies/testing.md)

No new JUnit tests required in this spec (infrastructure only).

---

## 10. Conventions Checklist

- [ ] Multi-stage Dockerfile at repo root
- [ ] No secrets committed — `.env.*.example` only
- [ ] `application-docker.yml` uses env var placeholders
- [ ] HEALTHCHECK uses Actuator
- [ ] README updated with Docker commands
- [ ] Profile `docker` isolated from `dev`/`prod`

---

## 11. References

- **Architecture:** [`Architecture.md` §5, §7, §8](../../../design/Architecture.md)
- **DevOps:** [`technologies/devops.md`](../../technologies/devops.md)
- **Phase plan:** [`phase5.md`](../../../implementation/phase5.md) — A5.1
- **Related Specs:** [SPEC-010](SPEC-010_full-stack-compose-nginx-smoke.md), [SPEC-007](SPEC-007_configuration-parameter-application-rest-global-errors.md)
- **Existing dev DB:** [`sapcyti-api/docker-compose.dev.yml`](../../../../sapcyti-api/docker-compose.dev.yml)

---

## 12. Review Log

| Date | Reviewer | Action | Notes |
|------|----------|--------|-------|
| — | — | — | — |
