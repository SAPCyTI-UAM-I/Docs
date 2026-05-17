# SPEC-006: GraduateProgram — Application Layer, Use Cases, and REST API

> **Status:** ✅ Implemented
> **Author:** SAPCyTI SDD
> **Date:** 2026-05-13
> **Phase:** 3 | **ADD Iteration:** 1
> **Bounded Context:** Program Configuration (BC-04)
> **Drivers:** [QA-3](../../../ArchitecturalDrivers.md), [QA-4](../../../ArchitecturalDrivers.md), [CON-5](../../../ArchitecturalDrivers.md) — parameterization and multi-program support; flexible rules by program (per-program configuration context)
> **Domain Schema:** [`program-configuration.schema.json`](../../domain/schemas/program-configuration.schema.json) — `CreateGraduateProgramCommand`, `UpdateGraduateProgramCommand`, `GraduateProgramResponse`, `GraduateProgramListResponse`
> **Domain Features:** [`graduate_program_management.feature`](../../domain/features/program-configuration/graduate_program_management.feature)
> **Depends on:** [SPEC-004](SPEC-004_graduate-program-domain-persistence.md), [SPEC-005](SPEC-005_configuration-parameter-persistence-isolation.md) — domain model, repositories, and parameter relationship (listing with `parameterCount`)
> **Blocks:** [SPEC-007](SPEC-007_configuration-parameter-application-rest-global-errors.md) — nested routes under `/api/programs/{id}/parameters`
> **External Dependencies:**
>   - [ ] Optional Spring Security method security in dev (Phase 3 before full security — see risk R-3.1 in [`phase3.md`](../../../implementations/phase3.md)); `@PreAuthorize` annotations are introduced in this spec

---

## 1. Business Justification

The use cases and REST API implement registration, retrieval, and update of graduate programs that [SPEC-004](SPEC-004_graduate-program-domain-persistence.md) already persists. Without this layer, QA-4 is not satisfied in the product (the coordinator cannot establish multi-tenant context over HTTP), nor are the scenarios in [`graduate_program_management.feature`](../../domain/features/program-configuration/graduate_program_management.feature). Downstream consumers (Enrollment, Offering, Academic Management) rely on stable `graduateProgramId` identities exposed by this API.

**Acceptance Criteria (Business):**
- [ ] AC-1: A coordinator can create a program with `name` and `division` and receives `201` with the created resource (including generated `id`).
- [ ] AC-2: They can list all programs with basic data and a **parameter count** per program, aligned with `GraduateProgramListResponse` in the schema.
- [ ] AC-3: They can retrieve program detail **with** its `configurationParameters` collection.
- [ ] AC-4: They can update name and division without changing existing parameters (*Update basic data of a program*).
- [ ] AC-5: An attempt to create a program with a **duplicate name** returns `409` with a message agreed with the Gherkin scenarios.

---

## 2. Scope

### In Scope
- Input ports: `CreateGraduateProgramInputPort`, `GetGraduateProgramInputPort` (detail by id + listing), `UpdateGraduateProgramInputPort`.
- `@Service` implementations in `application/service/`: `CreateGraduateProgramUseCase`, `GetGraduateProgramUseCase`, `UpdateGraduateProgramUseCase`.
- Duplicate-name validation via `GraduateProgramRepositoryPort.existsByName` (create) and exclusion of the current id on update.
- Input/output DTOs: `CreateGraduateProgramRequest`, `UpdateGraduateProgramRequest`, `GraduateProgramResponse`, `GraduateProgramListItemResponse` (or an equivalent name mapped to schema `GraduateProgramListResponse`) with Bean Validation (`@Valid`).
- `GraduateProgramMapper` (MapStruct): request/response ↔ domain entities / projections.
- `GraduateProgramController` — `POST/GET /api/programs`, `GET/PUT /api/programs/{id}` with `@PreAuthorize("hasRole('COORDINATOR')")` per [`phase3.md`](../../../implementations/phase3.md).
- Minimal persistence contract extension for listing: `countByGraduateProgramId(Long)` on `ConfigurationParameterRepositoryPort` + adapter implementation (avoids loading collections solely to count).

### Out of Scope
- Emitting BC-05 audit events (*Successful registration* mentions audit — implementation in the Audit / security iteration).
- Explicit `SYSTEM_ADMIN` support in `@PreAuthorize` (Gherkin mentions administrator; [`phase3.md`](../../../implementations/phase3.md) specifies `COORDINATOR` — document as a future improvement during review).
- Pagination for `GET /api/programs` (volume bounded by QA-4 to ≤9 programs).
- Mandatory `X-Graduate-Id` header on these endpoints (global program catalog; tenant header applies to per-program operational flows in other BCs).

### Assumptions
- [SPEC-004](SPEC-004_graduate-program-domain-persistence.md) and [SPEC-005](SPEC-005_configuration-parameter-persistence-isolation.md) are implemented: output ports and entities are available.
- PostgreSQL and Flyway are aligned with earlier phases.
- Unified JSON error format is defined in [SPEC-007](SPEC-007_configuration-parameter-application-rest-global-errors.md) (`GlobalExceptionHandler`); this controller must throw mappable domain/application exceptions or use the same response payload contract.

---

## 3. Architecture Impact

### Affected Layers

| Layer | Artifact | Action | Notes |
|-------|----------|--------|-------|
| `domain/port/in` | `CreateGraduateProgramInputPort.java`, `GetGraduateProgramInputPort.java`, `UpdateGraduateProgramInputPort.java` | CREATE | Use case contracts |
| `domain/port/out` | `ConfigurationParameterRepositoryPort.java` | MODIFY | Add `long countByGraduateProgramId(Long programId)` |
| `application/service` | `CreateGraduateProgramUseCase.java`, `GetGraduateProgramUseCase.java`, `UpdateGraduateProgramUseCase.java` | CREATE | Orchestrate ports |
| `infrastructure/adapter/in` | `GraduateProgramController.java` | CREATE | REST |
| `infrastructure/adapter/in/dto` | `CreateGraduateProgramRequest.java`, `UpdateGraduateProgramRequest.java`, `GraduateProgramResponse.java`, `GraduateProgramListItemResponse.java` | CREATE | Jakarta validation |
| `infrastructure/mapper` | `GraduateProgramMapper.java` | CREATE | MapStruct |
| `infrastructure/adapter/out` | `ConfigurationParameterJpaAdapter.java` | MODIFY | Implement `countByGraduateProgramId` |

### Package Location

```text
mx.uam.sapcyti.configuration/
├── domain/port/in/
│   ├── CreateGraduateProgramInputPort.java
│   ├── GetGraduateProgramInputPort.java
│   └── UpdateGraduateProgramInputPort.java
├── application/service/
│   ├── CreateGraduateProgramUseCase.java
│   ├── GetGraduateProgramUseCase.java
│   └── UpdateGraduateProgramUseCase.java
└── infrastructure/
    ├── adapter/in/
    │   ├── GraduateProgramController.java
    │   └── dto/ …
    └── mapper/
        └── GraduateProgramMapper.java
```

> **Architecture reference:** [`Architecture.md` §6.1](../../../Design/Architecture.md) — hexagonal structure per module

### Architectural Context

From [`Architecture.md` §4 — Domain model](../../../Design/Architecture.md):

```
GraduateProgram "1" *-- "*" ConfigurationParameter

| **GraduateProgram** | Aggregate Root | Represents a UAM graduate program. Contains the parametric configuration 
of business rules, enabling the multi-graduate program support required by QA-4. |
```

The application layer coordinates persistence of the aggregate root and enforces business invariants (name uniqueness) before/after delegating to `GraduateProgramRepositoryPort`.

### Cross-Module Dependencies

- Ports **within** BC-04 only (`GraduateProgramRepositoryPort`, `ConfigurationParameterRepositoryPort`).
- No calls to Identity, Enrollment, or other BCs in this spec.

---

## 4. Technical Design

### 4.1 Domain Model

> **Source of truth:** [`program-configuration.schema.json`](../../domain/schemas/program-configuration.schema.json) — `GraduateProgram`, `CreateGraduateProgramCommand`, `UpdateGraduateProgramCommand`, `GraduateProgramResponse`, `GraduateProgramListResponse`.

No new JPA entities are introduced; `GraduateProgram` and `ConfigurationParameter` from SPEC-004/005 are reused.

**Invariants (application + DTO validation):**
- `name`, `division`: `NotBlank`, lengths 1–200 and 1–100 respectively.
- `name` unique on create; on update, if the name changes, it must not collide with another program (different `id`).
- `CreateGraduateProgramCommand.initialParameters` (optional): if included in `CreateGraduateProgramRequest`, each element satisfies schema `ConfigurationParameter` (`key` pattern, required `value`, length constraints).

### 4.2 Port Contracts

```java
// domain/port/in/CreateGraduateProgramInputPort.java
public interface CreateGraduateProgramInputPort {
    GraduateProgramResponse create(CreateGraduateProgramCommand command);
}

// domain/port/in/GetGraduateProgramInputPort.java
public interface GetGraduateProgramInputPort {
    Optional<GraduateProgramResponse> getById(Long id);
    List<GraduateProgramListItemResponse> listAll(); // read model with parameterCount
}

// domain/port/in/UpdateGraduateProgramInputPort.java
public interface UpdateGraduateProgramInputPort {
    GraduateProgramResponse update(UpdateGraduateProgramCommand command);
}
```

> The `…Response` types above may be application records/DTOs or reuse schema names in the `application` package — the controller must serialize JSON equivalent to the schema.

**Parameter port extension:**

```java
// domain/port/out/ConfigurationParameterRepositoryPort.java — ADD
long countByGraduateProgramId(Long graduateProgramId);
```

### 4.3 Infrastructure

- **MapStruct:** `GraduateProgramMapper` maps `CreateGraduateProgramRequest` → command/domain; entity `GraduateProgram` → `GraduateProgramResponse` / list item; include mapping for `configurationParameters` collection ↔ child DTO list (or inject a mapper for `ConfigurationParameter`).
- **Transactions:** `@Transactional` on write paths in use cases or application services.

### 4.4 API Contract

```
POST /api/programs
Authorization: Bearer {token}   (when Security is enabled)
Content-Type: application/json
Request Body (CreateGraduateProgramCommand):
{
  "name": "string",
  "division": "string",
  "initialParameters": [ { "key": "MAX_COURSES_PER_TERM", "value": "3", "description": "..." } ]  // optional
}
Response 201: GraduateProgramResponse (body with id, name, division, configurationParameters if applicable)
Response 400: { "error": "...", "message": "..." }  — validation; messages aligned with Gherkin where applicable
Response 409: duplicate name — message: "A graduate program with that name already exists"
Response 403: unauthorized role
```

```
GET /api/programs
Response 200: [ GraduateProgramListResponse ]  // id, name, division, parameterCount
```

```
GET /api/programs/{id}
Response 200: GraduateProgramResponse
Response 404: message "Graduate program not found"
```

```
PUT /api/programs/{id}
Request Body: { "name": "string", "division": "string" }  // UpdateGraduateProgramCommand (id from path)
Response 200: GraduateProgramResponse
Response 404 / 409 / 400: per rules above
```

> **Error reference:** standard format in [SPEC-007](SPEC-007_configuration-parameter-application-rest-global-errors.md).

### 4.5 Frontend Contract (if applicable)

Not applicable (backend only).

---

## 5. Security Considerations

| # | Threat | CWE | Mitigation | Validated By |
|---|--------|-----|------------|--------------|
| SEC-1 | Unauthorized access to program management | CWE-862 | `@PreAuthorize("hasRole('COORDINATOR')")` on controller | `@WebMvcTest` with `@WithMockUser` and distinct roles |
| SEC-2 | Elevation via IDOR on routes | CWE-639 | Operations are global program catalog in MVP; future `SYSTEM_ADMIN` vs per-program scope under review | 403 tests |

**Access Control:** `COORDINATOR` role per [`phase3.md`](../../../implementations/phase3.md). If method security is not configured, document expected behavior until Phase 6.

---

## 6. Edge Cases & Error Handling

| # | Scenario | Expected Behavior | HTTP Status | Feature Ref |
|---|----------|-------------------|-------------|-------------|
| EC-1 | Create program with an existing name | Do not persist; fixed agreed message | 409 | *Rejection of program with duplicate name* |
| EC-2 | Empty `name` on POST | Bean Validation | 400 | *Rejection of program with empty name* — "Program name is required" |
| EC-3 | Empty `division` on POST | Validation | 400 | *Rejection of program with empty division* — "Division is required" |
| EC-4 | GET non-existent id | Optional: no business body; clear message | 404 | *Query of non-existent program* |
| EC-5 | Update name to another program's name | Uniqueness conflict | 409 | (derived from business constraint) |
| EC-6 | User with STUDENT role calls POST | Access denied | 403 | *Rejection of access with unauthorized role* |

---

## 7. Performance & Scalability Notes

| Concern | Detail | Mitigation |
|---------|--------|------------|
| Listing with count | N programs | `countByGraduateProgramId` per id (N COUNT queries) acceptable for N≤9; document batch alternative if required |

---

## 8. Migration & Rollback Strategy

- No new Flyway migrations in this spec.
- **API:** new endpoints; rollback = remove controller and use cases on reverted deployment.
- **JSON contract:** aligned with the schema; prefer backward-compatible changes.

---

## 9. Testing Strategy

| Test Type | Class | Scope | Framework |
|-----------|-------|-------|-----------|
| Unit + Mock | `CreateGraduateProgramUseCaseTest`, `UpdateGraduateProgramUseCaseTest` | Duplicates, empty fields (via commands), port interactions | JUnit 5 + Mockito |
| Unit + Mock | `GetGraduateProgramUseCaseTest` | Logical 404, listing with parameterCount | Mockito |
| Controller | `GraduateProgramControllerTest` | Happy paths, 400/404/409/403, JSON | `@WebMvcTest` + MockMvc + `@MockBean` input ports |

> **Reference:** [`technologies/testing.md`](../../technologies/testing.md)  
> **Coverage:** ≥80% on new code ([`implementationPlan.md`](../../../implementations/implementationPlan.md)).

Map `graduate_program_management.feature` scenarios to test cases (`@DisplayName` or class-level documentation).

---

## 10. Conventions Checklist

- [ ] Input ports in `domain/port/in/`
- [ ] Use cases in `application/service/` with `@Service`
- [ ] Controller in `infrastructure/adapter/in/` with `@Valid`
- [ ] MapStruct in `infrastructure/mapper/`
- [ ] JSON errors consistent with SPEC-007
- [ ] SLF4J for logging
- [ ] No `System.out.println`

---

## 11. References

- **Architecture:** [`Architecture.md` §4, §6.1](../../../Design/Architecture.md)
- **Context Map:** [`ContextMap.md` §1.2 BC-04](../../domain/ContextMap.md)
- **Domain Schema:** [`program-configuration.schema.json`](../../domain/schemas/program-configuration.schema.json)
- **Domain Features:** [`graduate_program_management.feature`](../../domain/features/program-configuration/graduate_program_management.feature)
- **Phase plan:** [`phase3.md`](../../../implementations/phase3.md)
- **Technologies:** [`technologies/backend.md`](../../technologies/backend.md), [`technologies/testing.md`](../../technologies/testing.md)
- **Related Specs:** [SPEC-004](SPEC-004_graduate-program-domain-persistence.md), [SPEC-005](SPEC-005_configuration-parameter-persistence-isolation.md), [SPEC-007](SPEC-007_configuration-parameter-application-rest-global-errors.md)

---

## 12. Review Log

| Date | Reviewer | Action | Notes |
|------|----------|--------|-------|
| — | — | — | — |
