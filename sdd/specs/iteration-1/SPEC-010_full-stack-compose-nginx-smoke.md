---
spec_id: SPEC-010
status: draft
phase: 5
bounded_context: platform
drivers: [CON-2, QA-5, CON-3]
depends_on: [SPEC-008B, SPEC-009]
---

# SPEC-010: Full Docker Compose Stack, Nginx Edge Proxy & Smoke Verification

> **Status:** 🔲 Draft
> **Author:** SAPCyTI SDD
> **Date:** 2026-05-19
> **Phase:** 5 (A5.2) | **ADD Iteration:** 1–2
> **Bounded Context:** — (platform / DevOps)
> **Drivers:** [CON-2](../../../requirements/Atributos_y_Restricciones.md), [QA-5](../../../requirements/Atributos_y_Restricciones.md), [CON-3](../../../requirements/Atributos_y_Restricciones.md) (export path readiness — stack only)
> **Domain Schema:** N/A — smoke uses existing [program-configuration API](SPEC-006_graduate-program-application-rest-api.md)
> **Domain Features:** Smoke maps to happy-path scenarios in [`graduate_program_management.feature`](../../domain/features/program-configuration/graduate_program_management.feature) (API-level only)
> **Depends on:** [SPEC-008B](SPEC-008B_spa-core-providers-shell-i18n.md) (✅ SPA shell buildable), [SPEC-009](SPEC-009_backend-dockerization-env-templates.md) (API image + env templates)
> **Blocks:** Phase 6 security work on verified deployable stack
> **External Dependencies:**
>   - [ ] Sibling repository layout: `sapcyti-api` and `sapcyti-spa` checked out side-by-side (see §4.3)

---

## 1. Business Justification

Iteration 1 requires proof that the SPA and API work together behind a single entry point, matching the container diagram (Architecture §5): browser → Nginx → static Angular assets + `/api` reverse proxy → Spring Boot → PostgreSQL. This spec delivers the **full local stack** and a repeatable smoke procedure used before Phase 6 security hardening.

**Refined expectation vs. original `phase5.md`:** Phase 4 does **not** implement Program Configuration UI—only shell and stubs ([SPEC-008B](SPEC-008B_spa-core-providers-shell-i18n.md)). Therefore end-to-end verification in Phase 5 is:

1. **SPA:** application loads at `http://localhost` (Shell visible).
2. **API:** GraduateProgram CRUD succeeds via HTTP through Nginx `/api/...` (scripted `curl`, not browser UI).

**Acceptance Criteria (Business):**
- [ ] AC-1: `docker compose up --build` starts Nginx, API, and PostgreSQL without manual steps.
- [ ] AC-2: User opens `http://localhost` and sees the SAPCyTI shell (no console errors blocking render).
- [ ] AC-3: Smoke script creates/lists a graduate program through `http://localhost/api/programs` and receives expected status codes (201/200).
- [ ] AC-4: `docker compose down -v && docker compose up --build` succeeds (Flyway idempotent on empty volume).

---

## 2. Scope

### In Scope
- SPA `Dockerfile` (multi-stage: **pnpm** install + `ng build` → Nginx static).
- `docker/nginx.conf` (or `nginx/default.conf`) in `sapcyti-spa/`:
  - Serve Angular `index.html` with `try_files` fallback for SPA routing.
  - Reverse proxy `location /api/` → `http://api:8080/` (strip prefix or preserve per backend context path — backend uses `/api/programs`, so proxy must forward `/api` unchanged).
  - Security headers (baseline): `X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy`.
- `docker-compose.yml` in **`sapcyti-api/`** orchestrating three services: `edge` (nginx+spa), `api`, `db`.
- Smoke assets:
  - `scripts/smoke-stack.sh` (POSIX) and `scripts/smoke-stack.ps1` (Windows) in `sapcyti-api/`.
  - Optional minimal Playwright spec `e2e/smoke-shell.spec.ts` in `sapcyti-spa/` (loads `/`, asserts title or shell marker).
- README updates in both repos for full-stack commands.

### Out of Scope
- Program Configuration **feature screens** in Angular (future phase).
- TLS termination (optional note for on-prem; not required locally).
- Playwright coverage of API CRUD (use shell script).
- Kubernetes / cloud manifests — QA-5 portability validated via Compose only.
- Updating CI to run full compose on every PR (optional follow-up; manual smoke sufficient for Phase 5).

### Assumptions
- [SPEC-008B](SPEC-008B_spa-core-providers-shell-i18n.md) is ✅ before implementation — production build must succeed.
- [SPEC-009](SPEC-009_backend-dockerization-env-templates.md) is ✅ — API `Dockerfile` and `docker` profile exist.
- Repositories are siblings, e.g.:

```text
UAM/SAP/
├── sapcyti-api/      ← docker-compose.yml lives here
└── sapcyti-spa/      ← build context ../sapcyti-spa
```

- `environment.prod.ts` already sets `apiBaseUrl: '/api'` — no code change required if proxy is correct.

---

## 3. Architecture Impact

### Affected Layers

| Layer | Artifact | Action | Notes |
|-------|----------|--------|-------|
| `sapcyti-spa/` | `Dockerfile` | CREATE | pnpm + Nginx |
| `sapcyti-spa/` | `docker/nginx/default.conf` | CREATE | Static + proxy |
| `sapcyti-spa/` | `.dockerignore` | CREATE | |
| `sapcyti-api/` | `docker-compose.yml` | CREATE | Full stack |
| `sapcyti-api/` | `scripts/smoke-stack.sh` | CREATE | API + health checks |
| `sapcyti-api/` | `scripts/smoke-stack.ps1` | CREATE | Windows |
| `sapcyti-spa/e2e/` | `smoke-shell.spec.ts` | CREATE (optional) | Shell load |
| Both READMEs | — | MODIFY | Full stack docs |

### Package Location

```text
sapcyti-api/
├── docker-compose.yml              ← CREATE (full stack)
├── docker-compose.dev.yml          ← unchanged (DB-only)
├── scripts/
│   ├── smoke-stack.sh
│   └── smoke-stack.ps1
└── ...

sapcyti-spa/
├── Dockerfile
├── .dockerignore
├── docker/
│   └── nginx/
│       └── default.conf
└── e2e/
    └── smoke-shell.spec.ts         ← optional
```

### Architectural Context

From [`Architecture.md` §5 — Container diagram](../../../design/Architecture.md):

> At runtime, these logical containers are deployed according to the **deployment view** (section 7): the Backend API and database as Docker containers, and the SPA as static assets served by the **Nginx container**.

From [`technologies/devops.md`](../../technologies/devops.md) — Docker Compose stack:

| Service | Image | Port | Depends On |
|---------|-------|------|------------|
| `nginx` / `edge` | Custom (SPA + reverse proxy) | 80 | `api` |
| `api` | Custom (Spring Boot) | 8080 (internal + optional host publish) | `db` |
| `db` | `postgres:16` | 5432 (internal) | — |

### Cross-Module Dependencies

- Smoke API calls hit BC-04 endpoints from [SPEC-006](SPEC-006_graduate-program-application-rest-api.md).
- Uses [SPEC-009](SPEC-009_backend-dockerization-env-templates.md) `docker` profile smoke basic auth for `COORDINATOR` role.

---

## 4. Technical Design

### 4.1 Domain Model

N/A.

### 4.2 `docker-compose.yml` (authoritative contract)

**File:** `sapcyti-api/docker-compose.yml`

| Service | Build / Image | Ports | Depends on | Health |
|---------|---------------|-------|------------|--------|
| `db` | `postgres:16-alpine` | none (internal 5432) | — | `pg_isready` |
| `api` | `build: .` (sapcyti-api Dockerfile) | `8080:8080` optional for debug | `db` healthy | Actuator (image HEALTHCHECK) |
| `edge` | `build: ../sapcyti-spa` | `80:80` | `api` started | `curl -f http://localhost/` |

**Networks:** default bridge; services resolve `api`, `db` by name.

**Volumes:** `sapcyti-db-data` named volume for PostgreSQL.

**Env file:** `env_file: .env` — developer copies `.env.docker.example` → `.env` (gitignored).

**Refinement vs. `phase5.md`:** Host PostgreSQL port is **5432 inside the compose network only** (not 5433). Port **5433** remains exclusive to `docker-compose.dev.yml` for host-native `mvn spring-boot:run` workflow — **no conflict**.

### 4.3 Nginx configuration

**Upstream API:** `proxy_pass http://api:8080;` for `location /api/`.

Requirements:

- Preserve `Host`, `X-Forwarded-For`, `X-Forwarded-Proto`.
- Proxy read timeout ≥ 60s (CSV/upload future-proofing).
- `client_max_body_size` ≥ 10m (future uploads).
- SPA: root `/usr/share/nginx/html`; `try_files $uri $uri/ /index.html;`

### 4.4 SPA Dockerfile

**Stage 1 (`node:22-alpine`):**

- Enable corepack / install pnpm 10.x (match `packageManager` in `package.json`).
- `pnpm install --frozen-lockfile`
- `pnpm run build` (production configuration)

**Stage 2 (`nginx:1.27-alpine`):**

- Copy `dist/sapcyti-spa/browser` (verify Angular 21 output path in `angular.json`) to html root.
- Copy `docker/nginx/default.conf` to `/etc/nginx/conf.d/default.conf`.

### 4.5 Smoke verification

**`scripts/smoke-stack.sh`** (exit non-zero on failure):

1. `curl -sf http://localhost/actuator/health` **or** `http://localhost/api/actuator/health` — document correct path after nginx routing (prefer proxied `/api/actuator/health` if exposed, else direct `http://localhost:8080/actuator/health` as secondary check per E5.3).
2. `curl -sf http://localhost/` — HTML contains app root (e.g. `<app-root` or project title).
3. **API CRUD** (Basic auth `coordinator` / `SMOKE_COORDINATOR_PASSWORD` from SPEC-009):
   - `POST /api/programs` → 201, capture `id`
   - `GET /api/programs` → 200, list contains name
   - `GET /api/programs/{id}` → 200
4. Print `SMOKE OK`.

**Gherkin mapping (API only):**

| Feature scenario | Smoke step |
|------------------|------------|
| Successful registration of a graduate program | POST 201 |
| Query all graduate programs | GET list 200 |
| Query a program with its configuration parameters | GET by id 200 |

**Playwright (optional):** `e2e/smoke-shell.spec.ts` — navigate to `/`, expect shell element `[data-testid="app-shell"]` or i18n key rendered (add `data-testid` in SPEC-008B shell if missing).

### 4.6 Frontend Contract

- Production build uses `environment.prod.ts`: `apiBaseUrl: '/api'`.
- Browser calls same origin `http://localhost/api/...` — no CORS issues.
- `TenantInterceptor` sends `X-Graduate-Id` when tenant set — not required for smoke API script.

### 4.7 Deliverables alignment (`phase5.md` refined)

| Deliverable | Refined acceptance |
|-------------|-------------------|
| E5.1 | `docker compose -f docker-compose.yml up --build` exits startup loop with all services healthy |
| E5.2 | SPA at `http://localhost`, API via `http://localhost/api/` |
| E5.3 | `curl` health returns `"status":"UP"` (via `:8080` or proxied path — document chosen URL in README) |
| E5.4 | CRUD via **scripted HTTP** through stack; SPA proves shell load only |

---

## 5. Security Considerations

| # | Threat | CWE | Mitigation | Validated By |
|---|--------|-----|------------|--------------|
| SEC-1 | Missing security headers at edge | CWE-693 | Nginx `add_header` directives | curl -I |
| SEC-2 | Exposed PostgreSQL port on host | CWE-284 | Do not publish `db` ports in full stack compose | `docker compose ps` |
| SEC-3 | Smoke credentials in repo | CWE-798 | Only in `.env.docker.example`; real `.env` gitignored | `.gitignore` review |

---

## 6. Edge Cases & Error Handling

| # | Scenario | Expected Behavior | Notes |
|---|----------|-------------------|-------|
| EC-1 | `sapcyti-spa` not sibling path | Build fails — README documents clone layout | |
| EC-2 | API 403 without basic auth | Smoke script must send `-u coordinator:password` | SPEC-009 profile |
| EC-3 | Stale volume with incompatible schema | `down -v` documented in transition criteria | |
| EC-4 | Port 80 in use | Compose fails — README says stop IIS/other nginx | |
| EC-5 | Windows line endings in shell script | Provide `.ps1` equivalent | |

---

## 7. Performance & Scalability Notes

First `--build` may take several minutes (Maven + pnpm). Document `COMPOSE_BAKE` / BuildKit recommendation in README. Not a runtime performance concern.

---

## 8. Migration & Rollback Strategy

- Additive files only; rollback = remove compose/nginx/dockerfiles.
- `docker-compose.dev.yml` workflow unchanged for developers preferring host-run API.

---

## 9. Testing Strategy

| Test Type | Artifact | Scope |
|-----------|----------|-------|
| Manual | `docker compose up --build` | Full stack boot |
| Script | `smoke-stack.sh` / `.ps1` | Health + API CRUD |
| E2E (optional) | `smoke-shell.spec.ts` | SPA shell render |
| CI (future) | Compose job on `develop` | Not required in Phase 5 |

> **Reference:** [`technologies/testing.md`](../../technologies/testing.md) — E2E section

---

## 10. Conventions Checklist

- [ ] Use **pnpm** in SPA Dockerfile (not `npm ci` — repo uses `pnpm-lock.yaml`)
- [ ] `apiBaseUrl: '/api'` unchanged in prod environment
- [ ] Compose file in `sapcyti-api/` with relative build to `../sapcyti-spa`
- [ ] Do not remove `docker-compose.dev.yml`
- [ ] Smoke scripts documented in README
- [ ] Security headers in Nginx config

---

## 11. References

- **Architecture:** [`Architecture.md` §5, §7, §8](../../../design/Architecture.md)
- **DevOps:** [`technologies/devops.md`](../../technologies/devops.md)
- **Frontend:** [`technologies/frontend.md`](../../technologies/frontend.md)
- **Phase plan:** [`phase5.md`](../../../implementation/phase5.md)
- **Related Specs:** [SPEC-009](SPEC-009_backend-dockerization-env-templates.md), [SPEC-008B](SPEC-008B_spa-core-providers-shell-i18n.md), [SPEC-006](SPEC-006_graduate-program-application-rest-api.md)
- **Features (API smoke):** [`graduate_program_management.feature`](../../domain/features/program-configuration/graduate_program_management.feature)

---

## 12. Review Log

| Date | Reviewer | Action | Notes |
|------|----------|--------|-------|
| — | — | — | — |
