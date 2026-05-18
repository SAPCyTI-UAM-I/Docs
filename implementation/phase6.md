# Phase 6 — Security Infrastructure & Authentication (BC-06)

> **ADD Iteration:** 3
> **Drivers:** QA-1 (RBAC), QA-2 (CWE Top 25 protection), HU-01 (login)
> **Status:** 🔲 Not started

**Goal:** Implement JWT-based authentication, Spring Security configuration, RBAC enforcement, and the login use case. This phase also instantiates the Audit infrastructure (BC-05) for security events.

> **Environment:** Backend against PostgreSQL; security tested via MockMvc + JWT.
> **Domain Schema:** [`identity-access.schema.json`](../sdd/domain/schemas/identity-access.schema.json), [`audit.schema.json`](../sdd/domain/schemas/audit.schema.json)
> **Domain Features:** [`features/identity-access/authentication.feature`](../sdd/domain/features/identity-access/authentication.feature), [`features/audit/audit_event_capture.feature`](../sdd/domain/features/audit/audit_event_capture.feature)

### User Stories (HU)

| HU | Title | Role in Phase |
|----|-------|---------------|
| [HU-01](../vision/HU/HU-01.md) | Ingreso al sistema SAPCyTI | Primary — login flow (email/password → JWT → main screen with role-based options) |
| [HU-03](../vision/HU/HU-03.md) | Cerrar sesión | Secondary — logout (revoke refresh token, clear session) |

---

## A6.1 — Identity Domain Model 🔲

> Specs: SPEC-010 (TBD — User aggregate, Role VO, RefreshToken entity)

- [ ] **T6.1.1** Create `User.java` — AR with fields from `identity-access.schema.json#/definitions/User`: `id`, `email`, `passwordHash`, `active` (HU-01: user credentials) → SPEC-010
- [ ] **T6.1.2** Create `Role.java` — VO enum: `COORDINATOR`, `PROFESSOR`, `STUDENT`, `ASSISTANT`, `SPEAKER`, `SYSTEM_ADMIN` (HU-01: role-based options) → SPEC-010
- [ ] **T6.1.3** Create `RefreshToken.java` — Entity: `id`, `tokenHash`, `expiresAt`, `revoked`, `deviceInfo` (HU-01, HU-03: session lifecycle) → SPEC-010
- [ ] **T6.1.4** Create repository ports and JPA adapters for User and RefreshToken → SPEC-010
- [ ] **T6.1.5** Create Flyway migrations for `users`, `roles`, `refresh_tokens` tables → SPEC-010

## A6.2 — Authentication & JWT 🔲

> Specs: SPEC-011 (TBD — Auth use case, JWT service, Spring Security config)

- [ ] **T6.2.1** Create `JwtService.java` — RSA-256 signed access tokens (15 min), refresh token management (HU-01) → SPEC-011
- [ ] **T6.2.2** Create `AuthUseCase.java` — login (email/password → JWT pair), refresh, logout (HU-01, HU-03) → SPEC-011
- [ ] **T6.2.3** Create `SecurityFilterChain` bean — stateless, JWT filter, URL whitelist, security headers (HU-01) → SPEC-011
- [ ] **T6.2.4** Create `JwtAuthFilter.java` — `OncePerRequestFilter`, extracts Bearer token, populates SecurityContext (HU-01) → SPEC-011
- [ ] **T6.2.5** Create `AuthController.java` — `POST /api/auth/login`, `POST /api/auth/refresh`, `POST /api/auth/logout` (HU-01, HU-03) → SPEC-011

## A6.3 — Audit Infrastructure (BC-05) 🔲

> Specs: SPEC-012 (TBD — AuditEvent domain, AuditOutputPort, SecurityAuditAspect)

- [ ] **T6.3.1** Create `AuditEvent.java` — AR from `audit.schema.json`: `id`, `timestamp`, `actorId`, `actorRole`, `action`, `entityType`, `entityId`, `details`, `severity`, `ipAddress`, `graduateProgramId` → SPEC-012
- [ ] **T6.3.2** Create `AuditOutputPort.java` + `AuditJpaAdapter.java` → SPEC-012
- [ ] **T6.3.3** Create `SecurityAuditAspect.java` — AOP capturing `LOGIN_SUCCESS`, `LOGIN_FAILED`, `RBAC_VIOLATION` at HIGH severity (HU-01: login events) → SPEC-012
- [ ] **T6.3.4** Create Flyway migration for `audit_events` table → SPEC-012

---

## Deliverables

- [ ] **E6.1** Login returns JWT pair (access + refresh) — Specs: SPEC-011
- [ ] **E6.2** Protected endpoints return 401 without JWT, 403 with wrong role — Specs: SPEC-011
- [ ] **E6.3** Security events (login success/failure, RBAC violation) persisted in `audit_events` — Specs: SPEC-012
- [ ] **E6.4** User CRUD with password hashing works — Specs: SPEC-010

---

## Transition Criteria

- [ ] `mvn clean verify` passes with ≥80% coverage
- [ ] Authentication flow: login → access token → protected endpoint → success
- [ ] RBAC: STUDENT cannot access COORDINATOR endpoints → 403
- [ ] Audit events visible in DB for login success, failure, and RBAC violations
- [ ] JWT expiry and refresh flow work correctly
- [ ] All Gherkin scenarios in `authentication.feature` mapped to test cases
- [ ] All linked specs are ✅ Implemented
- [ ] No regressions from Phases 1–5

---

## Risks

| # | Risk | Impact | Probability | Mitigation |
|---|------|--------|-------------|------------|
| R-6.1 | RSA key management complexity | Medio | Media | Externalize key paths via env vars; document in `.env.example` |
| R-6.2 | Spring Security 6.x API changes | Medio | Baja | Follow Spring Boot 3.4.5 reference docs; use `SecurityFilterChain` bean (not `WebSecurityConfigurerAdapter`) |
| R-6.3 | AOP aspect ordering with TenantFilter | Bajo | Media | Define explicit `@Order` on filters and aspects |

---

## Notes and Decisions

> Las decisiones se registran en [`decisions/README.md`](decisions/README.md).

| # | Decision ID | Summary |
|---|-------------|---------|
| — | — | — |
