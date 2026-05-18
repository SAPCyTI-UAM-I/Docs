# Phase 8 — Academic Offering & CSV Import (BC-03)

> **ADD Iteration:** 5
> **Drivers:** HU-06 (CSV upload), CON-3 (export format)
> **Status:** 🔲 Not started

**Goal:** Implement the Term lifecycle state machine, Academic Offer creation from CSV import, and enrollment period management.

> **Environment:** Backend against PostgreSQL; CSV test files in `src/test/resources/`.
> **Domain Schema:** [`academic-offering.schema.json`](../SDD/domain/schemas/academic-offering.schema.json)
> **Domain Features:** [`features/academic-offering/csv_upload_and_term_management.feature`](../SDD/domain/features/academic-offering/csv_upload_and_term_management.feature)

### User Stories (HU)

| HU | Title | Role in Phase |
|----|-------|---------------|
| [HU-06](../visionDocs/HU/HU-06.md) | Inicio del proceso de inscripción trimestral y carga de horarios | Primary — CSV upload, term creation, enrollment period opening |

---

## A8.1 — Term & Academic Offer Domain 🔲

> Specs: SPEC-016 (TBD — Term AR with state machine, AcademicOffer AR, UEAGroup entity, UEA AR)

- [ ] **T8.1.1** Create `Term.java` — AR with state machine: `PLANNING` → `OFFER_LOADED` → `IN_ENROLLMENT` → `IN_PROGRESS` → `COMPLETED`; transition methods with guard conditions (HU-06: term lifecycle) → SPEC-016
- [ ] **T8.1.2** Create `AcademicOffer.java` — AR owning `UEAGroup` entities (HU-06: course groupings) → SPEC-016
- [ ] **T8.1.3** Create `UEAGroup.java` — Entity with `groupCode`, `quota`, `availableQuota`, `Schedule` VOs (HU-06: schedules and quotas) → SPEC-016
- [ ] **T8.1.4** Create `UEA.java` — AR (course catalog reference): `code`, `name`, `credits` → SPEC-016
- [ ] **T8.1.5** Create `Schedule.java` — VO: `day`, `startTime`, `endTime` (HU-06: schedule display) → SPEC-016
- [ ] **T8.1.6** Create repository ports, JPA adapters, and Flyway migrations → SPEC-016

## A8.2 — CSV Import & Enrollment Period 🔲

> Specs: SPEC-017 (TBD — CSV import ACL, upload use case, open enrollment)

- [ ] **T8.2.1** Create `CsvParserPort.java` + `CsvAcademicOfferAdapter.java` — ACL that translates CSV rows to domain commands; validates fields; returns `CsvImportResult` with errors (HU-06: CSV parsing) → SPEC-017
- [ ] **T8.2.2** Create `UploadAcademicOfferUseCase.java` — validates Term in PLANNING → parses CSV → resolves UEA and Professor references → creates AcademicOffer → transitions Term to OFFER_LOADED (HU-06) → SPEC-017
- [ ] **T8.2.3** Create `OpenEnrollmentUseCase.java` — transitions Term from OFFER_LOADED to IN_ENROLLMENT (HU-06: enable enrollment) → SPEC-017
- [ ] **T8.2.4** Create `AcademicOfferController.java` — `POST /api/terms/{termId}/academic-offer/upload` (multipart), `GET /api/terms/{termId}/academic-offer`, `PUT /api/terms/{termId}/enrollment/open` (HU-06) → SPEC-017
- [ ] **T8.2.5** Audit events: `ACADEMIC_OFFER_UPLOADED`, `ENROLLMENT_PERIOD_OPENED` (HU-06) → SPEC-017

---

## Deliverables

- [ ] **E8.1** CSV upload creates AcademicOffer with UEAGroups and transitions Term — Specs: SPEC-017
- [ ] **E8.2** Invalid CSV rows produce error report without aborting import — Specs: SPEC-017
- [ ] **E8.3** Term state machine enforces valid transitions (e.g., cannot open enrollment without offer) — Specs: SPEC-016
- [ ] **E8.4** UEA catalog serves as reference data independent of terms — Specs: SPEC-016

---

## Transition Criteria

- [ ] `mvn clean verify` passes with ≥80% coverage
- [ ] CSV import with valid file creates offer and transitions term
- [ ] CSV import with invalid rows returns validation report
- [ ] Term state machine rejects invalid transitions with descriptive errors
- [ ] All Gherkin scenarios in `csv_upload_and_term_management.feature` mapped to tests
- [ ] All linked specs are ✅ Implemented
- [ ] No regressions from Phases 1–7

---

## Risks

| # | Risk | Impact | Probability | Mitigation |
|---|------|--------|-------------|------------|
| R-8.1 | CSV format not finalized with Lic. César Hernández | Alto | Media | Define provisional format in spec; mark as external dependency |
| R-8.2 | Large CSV files (10k+ rows) performance | Medio | Baja | Batch JPA inserts; test with realistic file sizes |
| R-8.3 | Professor reference resolution during import | Medio | Media | Use `ProfessorQueryPort` (cross-module); log warnings for unresolved |

---

## Notes and Decisions

> Las decisiones se registran en [`progress.md`](progress.md) Decision Log.

| # | Decision ID | Summary |
|---|-------------|---------|
| — | — | — |
