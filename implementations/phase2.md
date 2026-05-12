# Phase 2 — Program Configuration: Domain & Persistence (BC-04)

> **ADD Iteration:** 1
> **Drivers:** QA-3 (parameterization without code changes), QA-4 (multi-graduate program support)
> **Status:** 🔲 Not started

**Goal:** Implement the GraduateProgram aggregate root and ConfigurationParameter value object with JPA persistence, Flyway migrations, and repository adapters.

> **Environment:** Backend against PostgreSQL from `docker-compose.dev.yml`.
> **Domain Schema:** [`program-configuration.schema.json`](../SDD/domain/schemas/program-configuration.schema.json)
> **Domain Features:** [`features/program-configuration/`](../SDD/domain/features/program-configuration/)

### User Stories (HU)

> **No user stories apply directly to this phase.** BC-04 (Program Configuration) is a *supporting sub-domain* that enables QA-3 (parameterization) and QA-4 (multi-program support). It does not implement a user-facing story but is consumed by downstream BCs that implement HU-06, HU-07, HU-15, HU-21.

---

## A2.1 — GraduateProgram Aggregate Root 🔲

> Specs: [SPEC-004](../SDD/specs/iteration-1/SPEC-004_graduate-program-domain-persistence.md) — GraduateProgram domain model and persistence

- [ ] **T2.1.1** Create `GraduateProgram.java` — `@Entity`, fields from `program-configuration.schema.json#/definitions/GraduateProgram`: `id`, `name`, `division`; invariants: name not blank max 200, division not blank → SPEC-004
- [ ] **T2.1.2** Create `GraduateProgramRepositoryPort.java` — output port interface in `domain/port/out/` → SPEC-004
- [ ] **T2.1.3** Create `GraduateProgramJpaAdapter.java` — implements repository port; `@Repository`; queries scoped by tenant where applicable → SPEC-004
- [ ] **T2.1.4** Create Flyway migration `V1__create_graduate_programs.sql` → SPEC-004

## A2.2 — ConfigurationParameter Value Object 🔲

> Specs: [SPEC-005](../SDD/specs/iteration-1/SPEC-005_configuration-parameter-persistence-isolation.md) — ConfigurationParameter persistence and isolation

- [ ] **T2.2.1** Create `ConfigurationParameter.java` — `@Embeddable` or `@Entity` composed by GraduateProgram; fields from schema: `key` (UPPER_SNAKE_CASE), `value`, `description` → SPEC-005
- [ ] **T2.2.2** Create `ConfigurationParameterRepositoryPort.java` — output port for parameter CRUD scoped by `graduateProgramId` → SPEC-005
- [ ] **T2.2.3** Create `ConfigurationParameterJpaAdapter.java` — implements port → SPEC-005
- [ ] **T2.2.4** Create Flyway migration `V2__create_configuration_parameters.sql` → SPEC-005

---

## Deliverables

- [ ] **E2.1** GraduateProgram entity persists and retrieves from PostgreSQL — Specs: [SPEC-004](../SDD/specs/iteration-1/SPEC-004_graduate-program-domain-persistence.md)
- [ ] **E2.2** ConfigurationParameter CRUD works scoped by `graduateProgramId` — Specs: [SPEC-005](../SDD/specs/iteration-1/SPEC-005_configuration-parameter-persistence-isolation.md)
- [ ] **E2.3** Flyway migrations run clean on empty database — Specs: [SPEC-004](../SDD/specs/iteration-1/SPEC-004_graduate-program-domain-persistence.md), [SPEC-005](../SDD/specs/iteration-1/SPEC-005_configuration-parameter-persistence-isolation.md)
- [ ] **E2.4** Multi-tenant isolation: parameters from program 1 never visible to program 2 — Specs: [SPEC-005](../SDD/specs/iteration-1/SPEC-005_configuration-parameter-persistence-isolation.md)

---

## Transition Criteria

- [ ] `mvn clean verify` passes with ≥80% coverage on new code
- [ ] GraduateProgram CRUD verified via repository adapter tests (`@DataJpaTest`)
- [ ] Parameter isolation test: 2 programs with different MAX_COURSES_PER_TERM values return correct results
- [ ] Flyway migrations run on empty DB without errors
- [ ] All linked specs are ✅ Implemented
- [ ] No regressions from Phase 1

---

## Risks

| # | Risk | Impact | Probability | Mitigation |
|---|------|--------|-------------|------------|
| R-2.1 | ConfigurationParameter as `@Embeddable` vs `@Entity` decision | Medio | Media | Evaluate during spec writing; schema suggests key-value with lifecycle → likely `@Entity` with FK |
| R-2.2 | UPPER_SNAKE_CASE key validation complexity | Bajo | Baja | Regex constraint in domain model invariant |

---

## Notes and Decisions

> Las decisiones se registran en [`progress.md`](progress.md) Decision Log.

| # | Decision ID | Summary |
|---|-------------|---------|
| — | — | — |
