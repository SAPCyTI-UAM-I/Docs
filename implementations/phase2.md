# Phase 2 — Domain Model and Persistence

> **Spec:** `Architecture.md` — Iteration 1, §4 (Domain Model), §6.1 (Program Configuration module) | **Status:** 🔲 Not started
> **Drivers:** QA-3 (parameterization), QA-4 (multi-tenant), CON-1 (Java + OSS)

**Goal:** Implement the base domain model for the Program Configuration bounded context (`GraduateProgram` + `ConfigurationParameter`), create JPA driven adapters, and establish Flyway database migrations with seed data.

> **Environment:** Backend connects to PostgreSQL from `docker-compose.dev.yml`. Flyway runs migrations automatically on application startup.

---

## A2.1 — Domain Model Implementation 🔲

- [ ] **T2.1.1** Create `GraduateProgram` (Aggregate Root) — `id: Long`, `name: String`, `division: String`; constructor validates required fields; zero framework dependencies
  - Domain entity is pure Java — no JPA, no Spring annotations
- [ ] **T2.1.2** Create `ConfigurationParameter` (Value Object) — immutable class with `key: String`, `value: String`, `description: String`; composition relationship with `GraduateProgram`
  - Value object enforces immutability and valid state at construction time
- [ ] **T2.1.3** Define domain invariants — required field validation, key format constraints, key uniqueness per program
  - Invalid state is rejected at domain level before reaching persistence

## A2.2 — Output Ports 🔲

- [ ] **T2.2.1** Create `GraduateProgramRepositoryPort` — interface in `domain/port/out/` with `findById()`, `findAll()`, `save()`
  - Domain defines the contract; infrastructure provides the implementation
- [ ] **T2.2.2** Create `ConfigurationParameterPort` — interface in `domain/port/out/` with `findByProgramIdAndKey()`, `findAllByProgramId()`, `save()`
  - Parameter queries scoped by graduate program (QA-4)

## A2.3 — JPA Driven Adapters 🔲

- [ ] **T2.3.1** Create `GraduateProgramEntity` JPA entity — `@Entity`, `@Table("graduate_programs")`; mapper method to/from domain model
  - JPA annotations only on infrastructure entity; domain model stays clean
- [ ] **T2.3.2** Create `ConfigurationParameterEntity` JPA entity — `@ManyToOne` FK to `GraduateProgramEntity`; bidirectional mapper
  - Relationship mapped for efficient queries; domain model unaware of JPA structure
- [ ] **T2.3.3** Create Spring Data repositories — `JpaRepository<GraduateProgramEntity, Long>`, `JpaRepository<ConfigurationParameterEntity, Long>`
  - Spring Data provides query derivation and pagination
- [ ] **T2.3.4** Implement JPA adapters — `GraduateProgramJpaAdapter` and `ConfigurationParameterJpaAdapter` implementing output ports; map between domain and JPA entities
  - Hexagonal boundary preserved: adapters translate between domain and infrastructure

## A2.4 — Flyway Migrations 🔲

- [ ] **T2.4.1** Create `V1__create_graduate_programs.sql` — table `graduate_programs` with `id BIGSERIAL PK`, `name VARCHAR NOT NULL`, `division VARCHAR NOT NULL`, `created_at TIMESTAMP`, `updated_at TIMESTAMP`
  - Table created on first application startup
- [ ] **T2.4.2** Create `V2__create_configuration_parameters.sql` — table `configuration_parameters` with `id BIGSERIAL PK`, `key VARCHAR NOT NULL`, `value TEXT NOT NULL`, `description TEXT`, `graduate_program_id BIGINT FK REFERENCES graduate_programs(id)`, UNIQUE constraint on `(graduate_program_id, key)`
  - Parameters scoped per program; duplicate keys per program prevented at DB level
- [ ] **T2.4.3** Create `V3__seed_initial_data.sql` — insert PCyTI graduate program; insert example parameters (`MAX_COURSES_PER_TERM`, `ENROLLMENT_DEADLINE_DAYS`, `MAX_CREDITS_PER_TERM`)
  - Development environment has usable data immediately after migration

---

## Deliverables

- [ ] **E2.1** Domain model — `GraduateProgram` AR and `ConfigurationParameter` VO with invariant validation and unit tests
- [ ] **E2.2** Output ports — repository interfaces in `domain/port/out/` with no infrastructure dependencies
- [ ] **E2.3** JPA adapters — concrete implementations mapping domain ↔ JPA, registered as Spring beans
- [ ] **E2.4** Flyway migrations — V1–V3 scripts; schema created and seeded on startup; migration history verified

---

## Notes and Decisions

| # | Date | Decision | Context |
|---|------|----------|---------|
| — | — | — | — |
