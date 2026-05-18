# Phase 5 — Integration, Docker & End-to-End Verification

> **ADD Iteration:** 1–2
> **Drivers:** CON-2 (on-premise), QA-5 (cloud portability), CON-3 (export)
> **Status:** 🔲 Not started

**Goal:** Dockerize both projects, create the full Docker Compose stack (Nginx + API + DB), and perform end-to-end smoke testing of the Program Configuration API through the SPA.

> **Environment:** Full Docker Compose stack on `localhost`.
> **Ref:** [`technologies/devops.md`](../technologies/devops.md) — Docker and deployment strategy

### User Stories (HU)

> **No user stories apply directly to this phase.** Phase 5 is DevOps infrastructure (Dockerization, Compose, Nginx). It packages the application for deployment but does not add user-facing functionality.

---

## A5.1 — Backend Dockerization 🔲

> Specs: SPEC-009 (TBD — Docker and Compose configuration)

- [ ] **T5.1.1** Create backend `Dockerfile` — multi-stage (Maven build → JRE 21 runtime), expose 8080, HEALTHCHECK via Actuator → SPEC-009
- [ ] **T5.1.2** Create `docker-compose.yml` — full stack: Nginx (port 80) → API (port 8080) → PostgreSQL (port 5432) → SPEC-009
- [ ] **T5.1.3** Create `.env.dev`, `.env.preprod` templates for each environment → SPEC-009

## A5.2 — SPA Dockerization & Smoke Test 🔲

> Specs: SPEC-009

- [ ] **T5.2.1** Create SPA `Dockerfile` — multi-stage (`npm ci` + `ng build` → Nginx static serve) → SPEC-009
- [ ] **T5.2.2** Create Nginx config — reverse proxy `/api/` → backend, static assets for SPA, security headers → SPEC-009
- [ ] **T5.2.3** End-to-end smoke test — `docker compose up`, verify: SPA loads, GraduateProgram CRUD via API, Flyway migrations run → SPEC-009

---

## Deliverables

- [ ] **E5.1** `docker compose up` starts full stack without errors — Specs: SPEC-009
- [ ] **E5.2** SPA accessible on `localhost:80`, API on `localhost/api/` — Specs: SPEC-009
- [ ] **E5.3** Health check passes: `curl localhost:8080/actuator/health` returns UP — Specs: SPEC-009
- [ ] **E5.4** Program Configuration CRUD works end-to-end through Docker stack — Specs: SPEC-009

---

## Transition Criteria

- [ ] `docker compose up --build` succeeds from clean state
- [ ] `docker compose down -v && docker compose up` starts clean (Flyway migrations idempotent)
- [ ] SPA ↔ API communication works through Nginx reverse proxy
- [ ] No port conflicts, no volume permission issues
- [ ] All linked specs are ✅ Implemented
- [ ] No regressions from Phases 1–4

---

## Risks

| # | Risk | Impact | Probability | Mitigation |
|---|------|--------|-------------|------------|
| R-5.1 | Docker not installed on dev machine | Alto | Baja | `PREREQUISITES.md` lists Docker as required; `setup.ps1` checks |
| R-5.2 | Nginx config routing issues | Medio | Media | Test with curl before SPA integration |

---

## Notes and Decisions

> Las decisiones se registran en [`progress.md`](progress.md) Decision Log.

| # | Decision ID | Summary |
|---|-------------|---------|
| — | — | — |
