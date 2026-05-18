# SPEC-{NNN}: {Título descriptivo}

> **Status:** 🔲 Draft | 🔵 Approved | ✅ Implemented | ⛔ Blocked | 🔄 Amended
> **Author:** {nombre}
> **Date:** {YYYY-MM-DD}
> **Phase:** {N} | **ADD Iteration:** {N}
> **Bounded Context:** {nombre del módulo}
> **Drivers:** {HU-XX, QA-X, CON-X — referencia a [ArchitecturalDrivers.md](../../design/ArchitecturalDrivers.md)}
> **Domain Schema:** [`{bc-name}.schema.json`](../domain/schemas/{bc-name}.schema.json) — data contract for types, fields, and commands
> **Domain Features:** [`domain/features/{bc-name}/`](../domain/features/{bc-name}/) — Gherkin scenarios mapped to Acceptance Criteria
> **Depends on:** [SPEC-{NNN}]({ruta relativa}) — must be ✅ before implementation
> **Blocks:** [SPEC-{NNN}]({ruta relativa}) — cannot start until this is ✅
> **External Dependencies:**
>   - [ ] {Descripción de dependencia externa — e.g., "CSV format validated with Lic. César Hernández"}

---

## 1. Business Justification

{Por qué existe esta spec. Qué problema de negocio resuelve. Referencia directa
a la HU o QA driver — usar link: [HU-XX](../../vision/HU/HU-XX.md).
Máximo 3-4 oraciones.}

**Acceptance Criteria (Business):**
- [ ] AC-1: {criterio verificable desde perspectiva de negocio}
- [ ] AC-2: {criterio verificable}

---

## 2. Scope

### In Scope
- {Lo que SÍ se implementa en esta spec}

### Out of Scope
- {Lo que NO se toca — importante para que el implementador/LLM no se exceda}

### Assumptions
- {Qué debe ser verdad para que esta spec funcione}
- {Referencia a specs previas que deben estar implementadas}

---

## 3. Architecture Impact

### Affected Layers

| Layer | Artifact | Action | Notes |
|-------|----------|--------|-------|
| `domain/model` | `{Clase}.java` | CREATE / MODIFY | {breve nota} |
| `domain/port/out` | `{Interface}Port.java` | CREATE | {breve nota} |
| `infrastructure/adapter/out` | `{Clase}JpaAdapter.java` | CREATE | {breve nota} |
| `db/migration` | `V{N}__{description}.sql` | CREATE | {breve nota} |

### Package Location

```text
mx.uam.sapcyti.{modulo}/
├── domain/
│   ├── model/
│   │   └── {Clase}.java                    ← {ACTION}
│   └── port/out/
│       └── {Interface}Port.java            ← {ACTION}
└── infrastructure/
    └── adapter/out/
        ├── {Clase}Entity.java              ← {ACTION}
        └── {Clase}JpaAdapter.java          ← {ACTION}
```

> **Referencia arquitectónica:** [`Architecture.md §6.1`](../../design/Architecture.md) — Module package structure

### Architectural Context

> **Propósito:** Copiar aquí las líneas relevantes de `Architecture.md` que el implementador necesita para esta spec. Esto hace la spec autocontenida — el LLM no necesita abrir `Architecture.md`.

```
{Pegar aquí las 3-10 líneas relevantes de Architecture.md: modelo de dominio, relaciones, 
invariantes, o decisiones que aplican a esta spec. Incluir la sección de origen.}
```

### Cross-Module Dependencies

- {Qué ports de otros módulos consume — referencia a la spec que los define}
- {Qué domain events emite — referencia a [`Architecture.md §4.1`](../../design/Architecture.md) Logical Domain Events}

---

## 4. Technical Design

### 4.1 Domain Model

> **Source of truth:** Field names, types, and constraints MUST match the definitions in
> [`{bc-name}.schema.json`](../domain/schemas/{bc-name}.schema.json). Do NOT invent fields — derive them from the schema.

```java
// {Clase}.java — {DDD Type: Aggregate Root | Entity | Value Object}
// Puede usar anotaciones JPA (@Entity, @Id, @Column, etc.)
// Referencia: Architecture.md §4 — {nombre de la entidad}
// Schema: {bc-name}.schema.json#/definitions/{Clase}
public class {Clase} {
    // {campos con tipos y constraints — copied from schema definitions}
}
```

**Invariants:**
- {Invariante 1 — e.g., "`name` must not be blank, max 200 characters"}
- {Invariante 2}

### 4.2 Port Contracts

```java
// {referencia a capa: domain/port/in o domain/port/out}
public interface {Nombre}Port {
    // {métodos con firma completa}
}
```

### 4.3 Infrastructure

{MapStruct mappers (DTO ↔ Domain), Flyway migrations, repository adapters, etc.
Referencia a convenciones en [technologies/backend.md](../../technologies/backend.md)}

### 4.4 API Contract (si aplica)

```
{METHOD} /api/{recurso}/{id}
Headers: X-Graduate-Id: {programId}, Authorization: Bearer {token}
Request Body: { ... }
Response 200: { ... }
Response 4XX: { "error": "...", "message": "..." }
```

> **Referencia:** Formato de error definido en `GlobalExceptionHandler` — Phase 3

### 4.5 Frontend Contract (si aplica)

{Angular component, service, routing — referencia a [technologies/frontend.md](../../technologies/frontend.md)}

---

## 5. Security Considerations

> Evaluar si esta spec tiene implicaciones de seguridad. Referencia: [CWE Top 25](https://cwe.mitre.org/top25/), QA-1, QA-2.
> Si no aplica, escribir "No security impact" y justificar brevemente.

| # | Threat | CWE | Mitigation | Validated By |
|---|--------|-----|------------|-------------|
| SEC-1 | {e.g., SQL injection via user input} | CWE-89 | {e.g., parameterized queries via JPA} | {test o revisión} |
| SEC-2 | {e.g., unauthorized access to resource} | CWE-862 | {e.g., `@PreAuthorize` + RBAC} | {test o revisión} |

**Access Control:**
- {Qué roles pueden acceder a esta funcionalidad — referencia a RBAC specs}
- {¿Se valida que el usuario pertenece al tenant correcto?}

---

## 6. Edge Cases & Error Handling

> **Source:** Derive edge cases from the `@BadPath` and error flow scenarios in
> [`domain/features/{bc-name}/`](../domain/features/{bc-name}/). Each error scenario in a `.feature` file
> should map to a row below.

| # | Scenario | Expected Behavior | HTTP Status (si aplica) | Feature Ref |
|---|----------|-------------------|------------------------|-------------|
| EC-1 | {escenario} | {comportamiento esperado} | {código} | `{file}.feature` §{scenario name} |
| EC-2 | {escenario} | {comportamiento esperado} | {código} | `{file}.feature` §{scenario name} |

---

## 7. Performance & Scalability Notes

> Si no aplica, escribir "No performance concerns" y justificar.

| Concern | Detail | Mitigation |
|---------|--------|------------|
| {e.g., Query on large dataset} | {e.g., `findAll()` without pagination on 10k+ records} | {e.g., Add pagination via `Pageable`, DB index on `graduate_program_id`} |
| {e.g., N+1 queries} | {e.g., Loading parameters for each program} | {e.g., `@EntityGraph` or `JOIN FETCH`} |

---

## 8. Migration & Rollback Strategy

> Qué pasa si hay que revertir este cambio después de desplegado.

- **Flyway migration rollback:** {e.g., "V2 is additive (CREATE TABLE) — no destructive rollback needed. To undo: create V3 with DROP TABLE"}
- **API backward compatibility:** {e.g., "New endpoint, no existing consumers — safe to remove if reverted"}
- **Data migration:** {e.g., "No data transformation — rollback is safe" o "Requires manual data cleanup: {steps}"}

---

## 9. Testing Strategy

| Test Type | Class | Scope | Framework |
|-----------|-------|-------|-----------|
| Unit | `{Clase}Test` | {qué valida} | JUnit 5 |
| Adapter | `{Clase}AdapterTest` | {qué valida} | `@DataJpaTest` |
| Controller | `{Clase}ControllerIT` | {qué valida} | `@WebMvcTest` + MockMvc |

> **Referencia:** Estrategia completa en [`technologies/testing.md`](../../technologies/testing.md)
> **Coverage mínimo:** 80% (ver [`implementationPlan.md §4`](../../implementation/implementationPlan.md))

---

## 10. Conventions Checklist

- [ ] Domain model uses JPA annotations directly (no separate Entity class)
- [ ] MapStruct mapper is compile-time, for DTO ↔ Domain mapping only
- [ ] Output port interface is in `domain/port/out/`
- [ ] Flyway migration follows `V{N}__{description}.sql` naming
- [ ] Controller uses `@Valid` on request DTOs
- [ ] Error responses follow `GlobalExceptionHandler` format
- [ ] Structured logging (SLF4J) — no `System.out.println`
- [ ] Tests follow naming: `{Class}Test` (unit), `{Class}IT` (integration)
- [ ] Tenant scoping applied where required (QA-4)

> **Referencia completa de convenciones:** [`progress.md` → Active Conventions](../../implementation/progress.md)

---

## 11. References

- **Architecture:** [`Architecture.md §{N}`](../../design/Architecture.md) — {sección relevante}
- **Context Map:** [`ContextMap.md`](../domain/ContextMap.md) — {BC section and relevant relationships}
- **Domain Schema:** [`{bc-name}.schema.json`](../domain/schemas/{bc-name}.schema.json) — data contract
- **Domain Features:** [`domain/features/{bc-name}/`](../domain/features/{bc-name}/) — Gherkin scenarios
- **Iteration Plan:** [`IterationPlan.md`](../../design/IterationPlan.md) — Iteration {N}
- **Decision Log:** [`progress.md`](../../implementation/progress.md) — D-{NNN}
- **Technology Stack:** [`technologies/{area}.md`](../../technologies/{area}.md)
- **Related Specs:** [SPEC-{NNN}]({ruta relativa}) — {relación}
- **User Story:** [`HU-{NN}`](../../vision/HU/HU-{NN}.md)

---

## 12. Review Log

| Date | Reviewer | Action | Notes |
|------|----------|--------|-------|
| {YYYY-MM-DD} | {nombre} | 🔲→🔵 Approved | {comentarios o "No issues"} |
| {YYYY-MM-DD} | {nombre} | 🔵→🔄 Amended | {razón del cambio — registrar también en [progress.md](../../implementation/progress.md)} |
| {YYYY-MM-DD} | {nombre} | 🔄→🔵 Re-approved | {confirmación} |
