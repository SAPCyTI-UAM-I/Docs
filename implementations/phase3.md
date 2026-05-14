# Phase 3 — Program Configuration: Application & API (BC-04)

> **ADD Iteration:** 1
> **Drivers:** QA-3 (parameterization), QA-4 (multi-tenant), CON-5 (flexible rules)
> **Status:** 🔲 Not started

**Goal:** Implement use cases, REST controllers, and MapStruct mappers for the Program Configuration bounded context, exposing a complete CRUD API for GraduateProgram and ConfigurationParameter.

> **Environment:** Backend against PostgreSQL from `docker-compose.dev.yml`.
> **Domain Schema:** [`program-configuration.schema.json`](../SDD/domain/schemas/program-configuration.schema.json) — Commands: `CreateGraduateProgramCommand`, `SetConfigurationParameterCommand`
> **Domain Features:** [`features/program-configuration/`](../SDD/domain/features/program-configuration/) — `graduate_program_management.feature`, `configuration_parameter_management.feature`

### User Stories (HU)

> **No user stories apply directly to this phase.** BC-04 (Program Configuration) is a *supporting sub-domain*. The CRUD API for programs and parameters supports QA-3/QA-4 and is consumed by downstream BCs that implement HU-06, HU-07, HU-15, HU-21.

---

## A3.1 — GraduateProgram Use Cases & API 🔲

> Specs: [SPEC-006 — GraduateProgram application layer and REST API](../SDD/specs/iteration-1/SPEC-006_graduate-program-application-rest-api.md)

- [ ] **T3.1.1** Create input ports: `CreateGraduateProgramInputPort`, `GetGraduateProgramInputPort`, `UpdateGraduateProgramInputPort` → SPEC-006
- [ ] **T3.1.2** Create use case implementations: `CreateGraduateProgramUseCase`, `GetGraduateProgramUseCase`, `UpdateGraduateProgramUseCase` — with duplicate name validation → SPEC-006
- [ ] **T3.1.3** Create DTOs: `CreateGraduateProgramRequest`, `GraduateProgramResponse` — with `@Valid` constraints → SPEC-006
- [ ] **T3.1.4** Create `GraduateProgramMapper.java` (MapStruct) — Request/Response ↔ Domain → SPEC-006
- [ ] **T3.1.5** Create `GraduateProgramController.java` — endpoints `POST /api/programs`, `GET /api/programs`, `GET /api/programs/{id}`, `PUT /api/programs/{id}` — `@PreAuthorize("hasRole('COORDINATOR')")` → SPEC-006

## A3.2 — ConfigurationParameter Use Cases & API 🔲

> Specs: [SPEC-007 — ConfigurationParameter application layer, nested API, and global errors](../SDD/specs/iteration-1/SPEC-007_configuration-parameter-application-rest-global-errors.md)

- [ ] **T3.2.1** Create input ports: `SetConfigurationParameterInputPort`, `GetConfigurationParametersInputPort`, `DeleteConfigurationParameterInputPort` → SPEC-007
- [ ] **T3.2.2** Create use case implementations — with UPPER_SNAKE_CASE key validation, program existence check → SPEC-007
- [ ] **T3.2.3** Create DTOs: `SetConfigurationParameterRequest`, `ConfigurationParameterResponse` → SPEC-007
- [ ] **T3.2.4** Create `ConfigurationParameterController.java` — nested under programs: `POST /api/programs/{id}/parameters`, `GET /api/programs/{id}/parameters`, `GET /api/programs/{id}/parameters/{key}`, `DELETE /api/programs/{id}/parameters/{key}` → SPEC-007
- [ ] **T3.2.5** Create `GlobalExceptionHandler.java` — `@ControllerAdvice` for standard error format (`{ "error": "...", "message": "..." }`) → SPEC-007

---

## Deliverables

- [ ] **E3.1** GraduateProgram CRUD returns 200/201/404/409 via REST API — Specs: SPEC-006
- [ ] **E3.2** ConfigurationParameter CRUD works scoped by program — Specs: SPEC-007
- [ ] **E3.3** Duplicate program name returns 409 — Specs: SPEC-006
- [ ] **E3.4** Invalid key format returns 400 with descriptive message — Specs: SPEC-007
- [ ] **E3.5** GlobalExceptionHandler produces consistent error format — Specs: SPEC-007

---

## Transition Criteria

- [ ] `mvn clean verify` passes with ≥80% coverage
- [ ] Controller tests (`@WebMvcTest`) cover happy path and error flows from Gherkin features
- [ ] Use case tests (Mockito) verify duplicate name, empty fields, UPPER_SNAKE_CASE validation
- [ ] All Gherkin scenarios in `graduate_program_management.feature` mapped to test cases
- [ ] All Gherkin scenarios in `configuration_parameter_management.feature` mapped to test cases
- [ ] All linked specs are ✅ Implemented
- [ ] No regressions from Phase 2

---

## Risks

| # | Risk | Impact | Probability | Mitigation |
|---|------|--------|-------------|------------|
| R-3.1 | Security annotations without Spring Security configured | Medio | Alta | Phase 3 is pre-security; use `@PreAuthorize` annotations but Security config deferred to Phase 6 |
| R-3.2 | GlobalExceptionHandler error format changes later | Bajo | Media | Define error contract in spec; all future phases conform to it |

---

## Notes and Decisions

> Las decisiones se registran en [`progress.md`](progress.md) Decision Log.

| # | Decision ID | Summary |
|---|-------------|---------|
| — | — | — |
