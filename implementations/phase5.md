# Phase 5 — Integration, Docker and Verification

> **Spec:** `Architecture.md` — Iteration 1, §5 (Container diagram), §7 (Deployment view) | **Status:** 🔲 Not started
> **Drivers:** CON-2 (on-premise), QA-5 (cloud portability), CON-6 (repeatable deployment), CON-3 (export adapter placeholder), CON-4 (WordPress adapter placeholder)

**Goal:** Dockerize both projects, configure Docker Compose for the full stack (Nginx + Backend API + PostgreSQL), create placeholder ports for future adapters, and verify the end-to-end flow.

> **Environment:** Full stack runs locally via `docker compose -p sapcyti-dev up -d`. SPA accessible at `localhost:80`, API at `localhost:8080`, PostgreSQL at `localhost:5432`.

---

## A5.1 — Backend API Dockerization 🔲

- [ ] **T5.1.1** Create multi-stage `Dockerfile` for Backend — Stage 1: Maven build with dependency caching; Stage 2: JRE 21 runtime; expose port 8080
  - Image builds reproducibly; final image contains only runtime dependencies
- [ ] **T5.1.2** Configure Docker `HEALTHCHECK` — `curl -f http://localhost:8080/actuator/health || exit 1`; interval 30s, timeout 10s, retries 3
  - Container restarts automatically on health failure
- [ ] **T5.1.3** Configure runtime environment variables — `DB_URL`, `DB_USER`, `DB_PASS`, `SPRING_PROFILES_ACTIVE` resolved from `.env`
  - Same image runs in any environment (Factor X)
- [ ] **T5.1.4** Create `.dockerignore` — exclude `target/`, `.idea/`, `.git/`, `*.md`
  - Docker context minimized; faster builds

## A5.2 — SPA Dockerization 🔲

- [ ] **T5.2.1** Create multi-stage `Dockerfile` for SPA — Stage 1: `npm ci` + `ng build --configuration production`; Stage 2: Nginx serving static assets from `dist/`
  - Production build optimized; Nginx serves static files efficiently
- [ ] **T5.2.2** Create `nginx.conf` — reverse proxy `/api` → `http://api:8080`; serve SPA static assets; security headers (CSP, X-Frame-Options, X-Content-Type-Options)
  - Single entry point for both SPA and API; security headers applied (QA-2 partial)
- [ ] **T5.2.3** Configure SPA client-side routing — `try_files $uri $uri/ /index.html` for Angular routing compatibility
  - Deep links and browser refresh work correctly

## A5.3 — Docker Compose Configuration 🔲

- [ ] **T5.3.1** Create `docker-compose.yml` — services: `nginx` (SPA + reverse proxy, port 80), `api` (Backend, port 8080), `db` (PostgreSQL, port 5432); shared internal network
  - Full stack defined in single file; topology matches §7 Deployment view
- [ ] **T5.3.2** Create `.env.dev` — all environment variables for local development with safe defaults
  - `docker compose --env-file .env.dev up` starts everything with correct configuration
- [ ] **T5.3.3** Configure named volumes — `sapcyti-db-data` for PostgreSQL data persistence
  - Database state survives `docker compose down` / `up` cycles
- [ ] **T5.3.4** Configure resource limits — `mem_limit` and `cpus` per service (API: 1GB/1cpu, DB: 512MB/0.5cpu, Nginx: 256MB/0.25cpu)
  - Services don't starve each other on shared host
- [ ] **T5.3.5** Configure service dependencies — `api` depends on `db` (health check); `nginx` depends on `api`
  - Services start in correct order; no connection errors on startup

## A5.4 — Future Adapter Placeholders 🔲

- [ ] **T5.4.1** Create `ExportPort` interface — output port placeholder in domain layer for TXT/XLSX generation (CON-3); javadoc documents future implementation with Apache POI
  - Port ready for implementation in Iteration 5 (HU-09)
- [ ] **T5.4.2** Create `WordPressPort` interface — output port placeholder for asynchronous REST integration with WordPress (CON-4); javadoc documents planned async HTTP client
  - Port ready for future implementation
- [ ] **T5.4.3** Document pending adapters in `PENDING_ADAPTERS.md` — list of ports without implementations, target iteration, driver reference
  - Technical debt tracked and visible (CON-6)

## A5.5 — End-to-End Verification 🔲

- [ ] **T5.5.1** Verify Docker Compose startup — `docker compose -p sapcyti-dev up -d`; all three services reach `healthy` state
  - Full stack operational with single command
- [ ] **T5.5.2** Verify tenant flow — SPA: select program → query parameters → verify `X-Graduate-Id` header arrives at backend with correct value
  - Multi-tenant pipeline working end-to-end (QA-4)
- [ ] **T5.5.3** Verify Flyway migrations — connect to PostgreSQL; verify `graduate_programs` and `configuration_parameters` tables exist; seed data present
  - Schema version-controlled and reproducible
- [ ] **T5.5.4** Verify Actuator — `curl http://localhost:8080/actuator/health` returns `{"status": "UP"}` with database indicator
  - Health check operational for monitoring and Docker HEALTHCHECK
- [ ] **T5.5.5** Run test suites — `mvn test` (backend, ≥80% JaCoCo) + `ng test --code-coverage` (SPA, ≥80% istanbul)
  - All quality gates pass in containerized environment
- [ ] **T5.5.6** Document final stack versions — record exact versions of all dependencies: Spring Boot, Java, PostgreSQL, Angular, Node, Nginx, Docker Compose
  - Reproducible environment baseline established

---

## Deliverables

- [ ] **E5.1** Backend Dockerfile — multi-stage build, health check, env var configuration
- [ ] **E5.2** SPA Dockerfile + nginx.conf — production build served by Nginx with reverse proxy and security headers
- [ ] **E5.3** docker-compose.yml + .env.dev — full stack starts with `docker compose up`; topology matches Architecture.md §7
- [ ] **E5.4** Adapter placeholders — `ExportPort`, `WordPressPort` interfaces documented with target iteration
- [ ] **E5.5** Verification report — end-to-end flow, test results, stack versions documented

---

## Verified Stack Versions

| Component | Version |
|-----------|---------|
| Spring Boot | — |
| Java | 21 |
| PostgreSQL | — |
| Angular | — |
| Node.js | — |
| Nginx | — |
| Docker Compose | — |
| Flyway | — |
| MapStruct | — |

> Versions will be recorded during implementation.

---

## Notes and Decisions

| # | Date | Decision | Context |
|---|------|----------|---------|
| — | — | — | — |
