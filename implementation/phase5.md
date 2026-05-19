# Phase 5 — Integration, Docker & End-to-End Verification

> **ADD Iteration:** 1–2
> **Drivers:** CON-2 (on-premise), QA-5 (cloud portability), CON-3 (export)
> **Status:** 🔲 Not started

**Goal:** Dockerize both projects, create the full Docker Compose stack (Nginx + API + DB), and perform end-to-end smoke testing of the Program Configuration API through the stack, with SPA shell load verification.

> **Environment:** Full Docker Compose stack on `localhost`.
> **Ref:** [`technologies/devops.md`](../technologies/devops.md) — Docker and deployment strategy

### Prerequisites (refined)

| Prerequisite | Status | Notes |
|--------------|--------|-------|
| Phase 3 — REST API (SPEC-006, SPEC-007) | ✅ Required | API + Flyway |
| Phase 4 — SPA Core (SPEC-008B) | ✅ Required before smoke | Production build + Shell; **not** Program Configuration UI |
| Sibling repos | Required | `sapcyti-api` and `sapcyti-spa` side-by-side for Compose build context |
| Docker Desktop | Required | See [`PREREQUISITES.md`](../../sapcyti-api/PREREQUISITES.md) |

> **`docker-compose.dev.yml`** (DB-only, host port **5433**) remains for `mvn spring-boot:run` — it is **not** replaced by the full stack file.

### User Stories (HU)

> **No user stories apply directly to this phase.** Phase 5 is DevOps infrastructure (Dockerization, Compose, Nginx). It packages the application for deployment but does not add user-facing functionality.

---

## A5.1 — Backend Dockerization 🔲

> Specs: [SPEC-009 — Backend Dockerization & environment templates](../sdd/specs/iteration-1/SPEC-009_backend-dockerization-env-templates.md)

- [ ] **T5.1.1** Create backend `Dockerfile` — multi-stage (Maven build → JRE 21 runtime), expose 8080, HEALTHCHECK via Actuator → SPEC-009
- [ ] **T5.1.2** Create `application-docker.yml` + profile `docker` (JDBC `db:5432`, `SERVER_PORT=8080`) → SPEC-009
- [ ] **T5.1.3** Create `.env.docker.example`, `.env.preprod.example`; smoke-only `DockerSecurityConfig` (`@Profile("docker")`) for API CRUD scripts → SPEC-009

## A5.2 — SPA Dockerization, Compose & Smoke 🔲

> Specs: [SPEC-010 — Full stack Compose, Nginx & smoke verification](../sdd/specs/iteration-1/SPEC-010_full-stack-compose-nginx-smoke.md)

- [ ] **T5.2.1** Create SPA `Dockerfile` — multi-stage (`pnpm install --frozen-lockfile` + `ng build` → Nginx static serve) → SPEC-010
- [ ] **T5.2.2** Create `docker/nginx/default.conf` — reverse proxy `/api/` → `api:8080`, SPA `try_files`, security headers → SPEC-010
- [ ] **T5.2.3** Create `docker-compose.yml` in `sapcyti-api/` — services `edge`, `api`, `db` (full stack, port 80) → SPEC-010
- [ ] **T5.2.4** Create `scripts/smoke-stack.sh` and `scripts/smoke-stack.ps1` — health + GraduateProgram CRUD via `http://localhost/api/` → SPEC-010
- [ ] **T5.2.5** (Optional) Playwright `e2e/smoke-shell.spec.ts` — SPA shell loads at `/` → SPEC-010

---

## Deliverables

- [ ] **E5.1** `docker compose -f docker-compose.yml up --build` starts full stack without errors — Specs: SPEC-009, SPEC-010
- [ ] **E5.2** SPA accessible on `http://localhost`, API on `http://localhost/api/` — Specs: SPEC-010
- [ ] **E5.3** Health check passes: `curl` against documented URL returns `"status":"UP"` — Specs: SPEC-009, SPEC-010
- [ ] **E5.4** Program Configuration **API** CRUD works through Docker stack (scripted); SPA proves shell load — Specs: SPEC-010 *(refined: no CRUD UI in Phase 4)*

---

## Transition Criteria

- [ ] `docker compose up --build` succeeds from clean state
- [ ] `docker compose down -v && docker compose up --build` starts clean (Flyway migrations idempotent)
- [ ] SPA loads through Nginx; API reachable via `/api/` proxy
- [ ] No port conflicts between full stack (`:80`, internal `:5432`) and dev DB (`docker-compose.dev.yml` host `:5433`)
- [ ] All linked specs are ✅ Implemented
- [ ] No regressions from Phases 1–4
- [ ] SPEC-008B is ✅ before claiming E5.2/E5.4 SPA criteria

---

## Risks

| # | Risk | Impact | Probability | Mitigation |
|---|------|--------|-------------|------------|
| R-5.1 | Docker not installed on dev machine | Alto | Baja | `PREREQUISITES.md` lists Docker as required; `setup.ps1` checks |
| R-5.2 | Nginx config routing issues | Medio | Media | Test with `curl` before SPA integration; SPEC-010 smoke script |
| R-5.3 | Phase 4 not complete blocks SPA smoke | Alto | Media | Explicit prerequisite on SPEC-008B; API-only smoke still possible with SPEC-009 |
| R-5.4 | `@PreAuthorize` blocks API smoke without docker profile auth | Medio | Alta | SPEC-009 `DockerSecurityConfig` + basic auth for smoke only |
| R-5.5 | SPA uses pnpm, not npm | Bajo | Alta | SPEC-010 mandates `pnpm` in Dockerfile |

---

## Notes and Decisions

> Las decisiones se registran en [`decisions/README.md`](decisions/README.md).

| # | Decision ID | Summary |
|---|-------------|---------|
| 1 | _(pending)_ | Split Phase 5 into **SPEC-009** (backend image) + **SPEC-010** (full stack & smoke) instead of monolithic SPEC-009 |
| 2 | _(pending)_ | E5.4 = API CRUD via smoke script; SPA = shell load only until Program Configuration feature UI exists |
| 3 | _(pending)_ | Full stack `docker-compose.yml` in `sapcyti-api/`; SPA build context `../sapcyti-spa` |
