# SPEC-007: ConfigurationParameter — Application Layer, Nested REST API, and Global Error Handling

> **Status:** ✅ Implemented
> **Author:** SAPCyTI SDD
> **Date:** 2026-05-13
> **Phase:** 3 | **ADD Iteration:** 1
> **Bounded Context:** Program Configuration (BC-04)
> **Drivers:** [QA-3](../../../ArchitecturalDrivers.md), [QA-4](../../../ArchitecturalDrivers.md), [CON-5](../../../ArchitecturalDrivers.md) — per-program parameterization; multi-tenant isolation; operational flexibility without rigid rules in code
> **Domain Schema:** [`program-configuration.schema.json`](../../domain/schemas/program-configuration.schema.json) — `SetConfigurationParameterCommand`, `DeleteConfigurationParameterCommand`, `ConfigurationParameter`
> **Domain Features:** [`configuration_parameter_management.feature`](../../domain/features/program-configuration/configuration_parameter_management.feature)
> **Depends on:** [SPEC-005](SPEC-005_configuration-parameter-persistence-isolation.md), [SPEC-006](SPEC-006_graduate-program-application-rest-api.md) — parameter persistence and program existence via API/repository; routes under `/api/programs`
> **Blocks:** Read/query ports for parameters consumed by Enrollment / Academic Offering / Academic Management (later phases)
> **External Dependencies:**
>   - [ ] Same security convention as SPEC-006 (`@PreAuthorize`); full Spring Security configuration deferred per [`phase3.md`](../../../implementations/phase3.md)

---

## 1. Business Justification

This spec exposes HTTP management of configuration parameters scoped by `graduateProgramId`, satisfying QA-3 (change rules without deployment) and QA-4 (per-program isolation). `GlobalExceptionHandler` defines the backend **JSON error contract** for this iteration and subsequent phases, mitigating risk R-3.2 in [`phase3.md`](../../../implementations/phase3.md).

**Acceptance Criteria (Business):**
- [ ] AC-1: Create or update a parameter (`set`) over HTTP under an existing program; response consistent with *Set a new configuration parameter* and *Update the value of an existing parameter*.
- [ ] AC-2: List and retrieve a parameter by key with strict filtering by route `programId` (no cross-tenant leakage).
- [ ] AC-3: Delete an existing parameter → `204`; non-existent key → `404` with agreed message.
- [ ] AC-4: UPPER_SNAKE_CASE key validation and required values with messages aligned to Gherkin.
- [ ] AC-5: All error responses follow `{ "error": "<code or type>", "message": "<human-readable detail>" }`.

---

## 2. Scope

### In Scope
- Input ports: `SetConfigurationParameterInputPort`, `GetConfigurationParametersInputPort` (list + get by key), `DeleteConfigurationParameterInputPort`.
- Use cases: `SetConfigurationParameterUseCase`, `GetConfigurationParametersUseCase`, `DeleteConfigurationParameterUseCase` — key format validation, program existence check (`GraduateProgramRepositoryPort.findById`), operations via `ConfigurationParameterRepositoryPort`.
- DTOs: `SetConfigurationParameterRequest`, `ConfigurationParameterResponse` (+ wrapped list type if desired).
- `ConfigurationParameterMapper` (MapStruct).
- `ConfigurationParameterController` — nested routes:
  - `POST /api/programs/{id}/parameters`
  - `GET /api/programs/{id}/parameters`
  - `GET /api/programs/{id}/parameters/{key}`
  - `DELETE /api/programs/{id}/parameters/{key}`
- `@PreAuthorize("hasRole('COORDINATOR')")` on the parameters controller.
- **`GlobalExceptionHandler`** — `@ControllerAdvice` in an application-scanned package (recommended: `mx.uam.sapcyti.shared.web`) that maps:
  - `MethodArgumentNotValidException` / `ConstraintViolationException` → `400`
  - domain exception “program not found” → `404`
  - domain exception “parameter not found” → `404`
  - optional conflict (e.g. integrity) → `409` if applicable
  - `AccessDeniedException` → `403`
  - unhandled errors → `500` with a generic client message and server-side logging (do not expose stack traces to the client)

### Out of Scope
- Validating `X-Graduate-Id` header against route `{id}` (SPA tenant consistency — security iteration / middleware).
- Publishing BC-05 audit events (*RBACViolationDetected*, etc.).
- Full i18n for messages (fixed English strings per features, aligned with repo Gherkin).

### Assumptions
- [SPEC-005](SPEC-005_configuration-parameter-persistence-isolation.md) is implemented.
- [SPEC-006](SPEC-006_graduate-program-application-rest-api.md) defines the `/api/programs` prefix and coexistence in the same Spring MVC context.

---

## 3. Architecture Impact

### Affected Layers

| Layer | Artifact | Action | Notes |
|-------|----------|--------|-------|
| `domain/port/in` | `SetConfigurationParameterInputPort`, `GetConfigurationParametersInputPort`, `DeleteConfigurationParameterInputPort` | CREATE | |
| `application/service` | `SetConfigurationParameterUseCase`, `GetConfigurationParametersUseCase`, `DeleteConfigurationParameterUseCase` | CREATE | |
| `infrastructure/adapter/in` | `ConfigurationParameterController.java` | CREATE | Nested routes |
| `infrastructure/adapter/in/dto` | `SetConfigurationParameterRequest.java`, `ConfigurationParameterResponse.java` | CREATE | |
| `infrastructure/mapper` | `ConfigurationParameterMapper.java` | CREATE | |
| `shared/web` (or equivalent) | `GlobalExceptionHandler.java` | CREATE | Cross-cutting; see package note |

### Package Location

```text
mx.uam.sapcyti.configuration/
├── domain/port/in/ …ConfigurationParameter*InputPort.java
├── application/service/ …UseCase.java
└── infrastructure/
    ├── adapter/in/ConfigurationParameterController.java
    ├── adapter/in/dto/
    └── mapper/ConfigurationParameterMapper.java

mx.uam.sapcyti.shared.web/
└── GlobalExceptionHandler.java
```

> If the team prefers `GlobalExceptionHandler` under `configuration/infrastructure/adapter/in/`, ensure `@SpringBootApplication` scans the package and that future controllers from other BCs share the same advice or refactor to `shared` in the same phase.

### Architectural Context

From [`ContextMap.md` §2.1](../../domain/ContextMap.md):

| `graduateProgramId` | Program Configuration | Academic Management, Academic Offering, Enrollment, Audit | ID reference. Multi-tenant scope on all operations. |

Every operation in this API **must** use route `{id}` as `graduateProgramId` when calling repositories — never rely solely on a duplicated JSON body; if the DTO includes `graduateProgramId`, it must match the path or be omitted from the public contract.

### Cross-Module Dependencies

- BC-04 ports only. `GlobalExceptionHandler` is cross-cutting but has no dependencies on other modules.

---

## 4. Technical Design

### 4.1 Domain Model

> **Source of truth:** [`program-configuration.schema.json`](../../domain/schemas/program-configuration.schema.json) — `ConfigurationParameter`, `SetConfigurationParameterCommand`, `DeleteConfigurationParameterCommand`.

**Invariants (application + DTO):**
- `key`: required; pattern `^[A-Z][A-Z0-9_]*$` (UPPER_SNAKE_CASE); max 100.
- `value`: required; max 500.
- `description`: optional; max 500.
- `graduateProgramId` implied from path `{id}`.

### 4.2 Port Contracts

```java
public interface SetConfigurationParameterInputPort {
    ConfigurationParameterResponse set(Long graduateProgramId, SetConfigurationParameterCommand command);
}

public interface GetConfigurationParametersInputPort {
    List<ConfigurationParameterResponse> listByProgram(Long graduateProgramId);
    Optional<ConfigurationParameterResponse> getByProgramAndKey(Long graduateProgramId, String key);
}

public interface DeleteConfigurationParameterInputPort {
    void delete(Long graduateProgramId, String key);
}
```

### 4.3 Infrastructure

- **Set / upsert:** the use case resolves the program; finds the parameter by `(programId, key)`; if it exists, updates `value` and `description`; otherwise creates the child entity and persists with `save`.
- **Delete:** `deleteByGraduateProgramIdAndKey`; if prior `find` is empty → domain exception mapped to 404.
- **MapStruct:** mapping between JPA `ConfigurationParameter` and `ConfigurationParameterResponse`; request → command.

### 4.4 API Contract

```
POST /api/programs/{id}/parameters
Request Body:
{ "key": "MAX_COURSES_PER_TERM", "value": "3", "description": "optional" }
Response 200: ConfigurationParameterResponse (body with final parameter state)
Response 400/404/403: standard JSON error
```

```
GET /api/programs/{id}/parameters
Response 200: [ ConfigurationParameterResponse ]
```

```
GET /api/programs/{id}/parameters/{key}
  // {key} path segment URL-encoded if necessary
Response 200: ConfigurationParameterResponse
Response 404: "Configuration parameter not found" | "Graduate program not found"
```

```
DELETE /api/programs/{id}/parameters/{key}
Response 204: no body
Response 404: non-existent parameter or program
```

**Error payload (required for handled 4xx/5xx):**

```json
{
  "error": "VALIDATION_ERROR",
  "message": "Human readable message"
}
```

> Concrete `error` values may be short enums (`NOT_FOUND`, `VALIDATION_ERROR`, `CONFLICT`, `FORBIDDEN`) documented in `GlobalExceptionHandler` code.

### 4.5 Frontend Contract (if applicable)

Not applicable.

---

## 5. Security Considerations

| # | Threat | CWE | Mitigation | Validated By |
|---|--------|-----|------------|--------------|
| SEC-1 | IDOR — tampering with `{id}` to read/write another program's parameters | CWE-639 | Always filter by path `graduateProgramId` in the repository | Service tests with two programs |
| SEC-2 | Injection via path `{key}` | CWE-22 | Sanitize/normalize key; validate pattern before query | Unit tests with invalid keys |
| SEC-3 | RBAC | CWE-862 | `@PreAuthorize` + 403 tests | `@WebMvcTest` |

---

## 6. Edge Cases & Error Handling

| # | Scenario | Expected Behavior | HTTP | Feature Ref |
|---|----------|-------------------|------|-------------|
| EC-1 | Empty key | Do not persist | 400 | *Rejection of parameter with empty key* — "Parameter key is required" |
| EC-2 | Key `max-courses` (invalid format) | | 400 | *Rejection of parameter with invalid key format* — "Key must be in UPPER_SNAKE_CASE format" |
| EC-3 | Empty value | | 400 | *Rejection of parameter with empty value* — "Parameter value is required" |
| EC-4 | Program id 999 | | 404 | *Rejection of operation on non-existent program* — "Graduate program not found" |
| EC-5 | DELETE non-existent key | | 404 | *Deletion of non-existent parameter* — "Configuration parameter not found" |
| EC-6 | STUDENT role | | 403 | *Rejection of access with unauthorized role* |
| EC-7 | Program 1 vs 2, same key, different values | Reads by id return correct values | 200 | *Parameter isolation between programs* |

---

## 7. Performance & Scalability Notes

No performance concerns: low cardinality per program and ≤9 programs.

---

## 8. Migration & Rollback Strategy

- No new migrations.
- **API rollback:** remove controller and handler if deployment is reverted; keep JSON error compatibility once published to other teams.

---

## 9. Testing Strategy

| Test Type | Class | Scope | Framework |
|-----------|-------|-------|-----------|
| Unit + Mock | `SetConfigurationParameterUseCaseTest` | Key format, non-existent program, upsert | Mockito |
| Unit + Mock | `DeleteConfigurationParameterUseCaseTest` | 404 when missing | Mockito |
| Controller | `ConfigurationParameterControllerTest` | All relevant status codes, JSON | `@WebMvcTest` |
| Unit | dedicated tests or advice tests | `GlobalExceptionHandler` maps exceptions | standalone `WebMvcTest` or `@ExtendWith` Mockito |

> **Reference:** [`technologies/testing.md`](../../technologies/testing.md)

---

## 10. Conventions Checklist

- [ ] `@Valid` on POST requests
- [ ] Errors via unified `GlobalExceptionHandler`
- [ ] Queries always include `graduateProgramId`
- [ ] MapStruct at compile time
- [ ] Coverage ≥80%

---

## 11. References

- **Architecture:** [`Architecture.md`](../../../Design/Architecture.md) — QA-3, QA-4, Configuration Adapter
- **Context Map:** [`ContextMap.md`](../../domain/ContextMap.md) — BC-04, relationships R2, R8, R10
- **Domain Schema:** [`program-configuration.schema.json`](../../domain/schemas/program-configuration.schema.json)
- **Domain Features:** [`configuration_parameter_management.feature`](../../domain/features/program-configuration/configuration_parameter_management.feature)
- **Phase plan:** [`phase3.md`](../../../implementations/phase3.md)
- **Technologies:** [`technologies/backend.md`](../../technologies/backend.md), [`technologies/testing.md`](../../technologies/testing.md)
- **Related Specs:** [SPEC-005](SPEC-005_configuration-parameter-persistence-isolation.md), [SPEC-006](SPEC-006_graduate-program-application-rest-api.md)

---

## 12. Review Log

| Date | Reviewer | Action | Notes |
|------|----------|--------|-------|
| — | — | — | — |
