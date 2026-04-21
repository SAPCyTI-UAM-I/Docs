# Phase 3 — Application Layer and REST API

> **Spec:** `Architecture.md` — Iteration 1, §6.1 (component responsibilities), §10 (interfaces) | **Status:** 🔲 Not started
> **Drivers:** QA-3 (parameterization), QA-4 (multi-tenant), CON-5 (flexible rules), CON-6 (predictable structure)

**Goal:** Implement input ports, application services (use cases), REST controllers (driving adapters), the Configuration Adapter for cross-module parameter access, and Spring Boot Actuator for health checks and metrics.

> **Environment:** Backend runs against PostgreSQL with Flyway-migrated schema from Phase 2. API testable via `curl` or Postman.

---

## A3.1 — Input Ports 🔲

- [ ] **T3.1.1** Create `GetGraduateProgramInputPort` — interface with `getById(Long id)`, `getAll()`
  - Use case contract defined in domain layer
- [ ] **T3.1.2** Create `GetConfigurationParameterInputPort` — interface with `getByProgramAndKey(Long programId, String key)`, `getAllByProgram(Long programId)`
  - Parameter retrieval scoped by program (QA-4)
- [ ] **T3.1.3** Create `ManageConfigurationParameterInputPort` — interface with `create(...)`, `update(...)`, `delete(...)`
  - Mutation operations defined independently from REST layer

## A3.2 — Application Services (Use Cases) 🔲

- [ ] **T3.2.1** Create `GetGraduateProgramUseCase` — implements `GetGraduateProgramInputPort`; delegates to `GraduateProgramRepositoryPort`
  - Orchestration layer between driving adapters and domain; no business logic — pure delegation
- [ ] **T3.2.2** Create `GetConfigurationParameterUseCase` — implements `GetConfigurationParameterInputPort`; retrieves parameters filtered by `graduateProgramId`
  - Query results always scoped to tenant context (QA-4)
- [ ] **T3.2.3** Create `ManageConfigurationParameterUseCase` — implements `ManageConfigurationParameterInputPort`; validates uniqueness, creates/updates/deletes parameters
  - Business rule validation before persistence (QA-3)

## A3.3 — REST Controllers (Driving Adapters) 🔲

- [ ] **T3.3.1** Create `GraduateProgramController` — `GET /api/programs`, `GET /api/programs/{id}`; JSON responses
  - Programs endpoint functional and documented
- [ ] **T3.3.2** Create `ConfigurationParameterController` — `GET /api/programs/{programId}/parameters`, `GET /api/programs/{programId}/parameters/{key}`, `POST`, `PUT`, `DELETE`
  - Full CRUD for configuration parameters scoped per program
- [ ] **T3.3.3** Create request/response DTOs — `GraduateProgramResponse`, `ConfigurationParameterRequest`, `ConfigurationParameterResponse`
  - API contract separated from domain model
- [ ] **T3.3.4** Implement Bean Validation — `@Valid` on request DTOs; `@NotBlank`, `@Size` constraints; localized validation messages via `MessageSource`
  - Invalid input rejected at controller boundary with structured error response
- [ ] **T3.3.5** Implement `GlobalExceptionHandler` — `@ControllerAdvice` with `@ExceptionHandler`; standardized error format: `{error, message, timestamp, fieldErrors[]}`
  - Consistent error responses across all API endpoints

## A3.4 — Configuration Adapter 🔲

- [ ] **T3.4.1** Create `ConfigurationAdapter` — service that reads parameters from repository filtered by program; implements an output port consumable by other modules
  - Future modules (Enrollment, Academic Offering) can read program-specific rules without depending on the Configuration module directly
- [ ] **T3.4.2** Expose adapter as output port interface — `ConfigurationQueryPort` with `getParameter(String key, Long programId): String`
  - Cross-module access follows port-based communication policy (§4.1)

## A3.5 — Actuator and Health Checks 🔲

- [ ] **T3.5.1** Configure Actuator endpoints — `/actuator/health` (liveness + readiness), `/actuator/prometheus` (Micrometer metrics), `/actuator/info`
  - Health check usable by Docker `HEALTHCHECK` and monitoring stack
- [ ] **T3.5.2** Configure build info in `/actuator/info` — Git SHA and version via `spring-boot-maven-plugin`
  - Deployment traceability from running instance

---

## Deliverables

- [ ] **E3.1** Input ports — interfaces defining use case contracts in domain layer
- [ ] **E3.2** Application services — use case implementations orchestrating domain and ports
- [ ] **E3.3** REST controllers — functional endpoints with validation and error handling; testable via curl/Postman
- [ ] **E3.4** Configuration Adapter — cross-module port for program-specific parameter access
- [ ] **E3.5** Actuator configured — `/actuator/health` returns `UP`; `/actuator/prometheus` exports metrics

---

## Notes and Decisions

| # | Date | Decision | Context |
|---|------|----------|---------|
| — | — | — | — |
