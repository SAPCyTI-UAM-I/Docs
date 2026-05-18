# Phase 9 — Enrollment Workflow (BC-01, BC-05)

> **ADD Iteration:** 5
> **Drivers:** HU-07 (course selection), HU-08 (advisor approval), HU-09 (finalization), CON-3 (TXT/XLSX export), CON-5 (flexible rules)
> **Status:** 🔲 Not started

**Goal:** Implement the complete multi-actor enrollment workflow: student course selection, advisor approval/rejection, coordinator finalization, on-demand PDF generation, and TXT/XLSX export to School Systems. Also complete the remaining audit events for all domain mutations.

> **Environment:** Backend against PostgreSQL; integration tests with full workflow.
> **Domain Schema:** [`enrollment.schema.json`](../SDD/domain/schemas/enrollment.schema.json), [`audit.schema.json`](../SDD/domain/schemas/audit.schema.json)
> **Domain Features:** [`features/enrollment/`](../SDD/domain/features/enrollment/) — `student_selection.feature`, `advisor_approval.feature`, `enrollment_finalization.feature`
> **Cross-module:** BC-03 (AcademicOfferQueryPort), BC-02 (StudentQueryPort), BC-04 (ConfigurationParameter)

### User Stories (HU)

| HU | Title | Role in Phase |
|----|-------|---------------|
| [HU-07](../visionDocs/HU/HU-07.md) | Selección de UEA por el alumno | Primary — Course selection, schedule display, quota validation |
| [HU-08](../visionDocs/HU/HU-08.md) | Revisión, modificación y aprobación de la carga académica por el asesor | Primary — Advisor review, approve/reject workflow, quota decrement |
| [HU-09](../visionDocs/HU/HU-09.md) | Generación y descarga del formato PDF de inscripción | Primary — Enrollment finalization, PDF generation, TXT/XLSX export |
| [HU-10](../visionDocs/HU/HU-10.md) | Gestión administrativa y modificación de estados de inscripción | Secondary — Administrative enrollment state changes by Coordinator |

---

## A9.1 — Enrollment Domain Model 🔲

> Specs: SPEC-018 (TBD — Enrollment AR with state machine, UEASelection entity)

- [ ] **T9.1.1** Create `Enrollment.java` — AR with state machine: `PENDING_SELECTION` → `SELECTION_COMPLETED` → `APPROVED_BY_ADVISOR` → `FINALIZED`; transition methods: `completeSelection()`, `approveByAdvisor(advisorId)`, `rejectByAdvisor(advisorId, reason)`, `finalize()` (HU-07, HU-08, HU-09: enrollment lifecycle) → SPEC-018
- [ ] **T9.1.2** Create `UEASelection.java` — Entity: `id`, `preselected`, `approvedByAdvisor`, reference to `uEAGroupId` (HU-07: course selections) → SPEC-018
- [ ] **T9.1.3** Create repository ports, JPA adapter, and Flyway migrations → SPEC-018

## A9.2 — Course Selection (Student) 🔲

> Specs: SPEC-019 (TBD — SelectCourses use case, validation, cross-module queries)

- [ ] **T9.2.1** Create `SelectCoursesUseCase.java` — validates Term `IN_ENROLLMENT`, UEAGroup quota, schedule conflicts, program rules (MAX_COURSES_PER_TERM, CREDIT_LIMIT_PER_TERM) via cross-module ports (HU-07) → SPEC-019
- [ ] **T9.2.2** Create cross-module query ports: `AcademicOfferQueryPort`, `StudentQueryPort` — in Enrollment's `domain/port/out/` (HU-07, HU-08) → SPEC-019
- [ ] **T9.2.3** Create `EnrollmentController.java` — `POST /api/enrollments/select-courses` (STUDENT role) (HU-07) → SPEC-019

## A9.3 — Advisor Approval & Rejection 🔲

> Specs: SPEC-020 (TBD — Approve/Reject use cases, quota management)

- [ ] **T9.3.1** Create `ApproveEnrollmentUseCase.java` — validates caller is student's advisor → marks UEASelections approved → decrements `availableQuota` via `UeaGroupQuotaPort` (HU-08) → SPEC-020
- [ ] **T9.3.2** Create `RejectEnrollmentUseCase.java` — returns enrollment to `PENDING_SELECTION` (HU-08: rejection loop) → SPEC-020
- [ ] **T9.3.3** Create `GetAdvisorEnrollmentsUseCase.java` — returns enrollments in `SELECTION_COMPLETED` for advisor's students (HU-08: advisor review list) → SPEC-020
- [ ] **T9.3.4** Create controller endpoints: `GET /api/enrollments/advisor-pending`, `PUT /api/enrollments/{id}/approve`, `PUT /api/enrollments/{id}/reject` (HU-08) → SPEC-020

## A9.4 — Finalization, PDF & Export 🔲

> Specs: SPEC-021 (TBD — Finalization, PDF generation ACL, TXT/XLSX export ACL)

- [ ] **T9.4.1** Create `FinalizeEnrollmentUseCase.java` — transitions to FINALIZED, sets `finalizationDate` — COORDINATOR/ASSISTANT role (HU-09, HU-10) → SPEC-021
- [ ] **T9.4.2** Create `PdfGeneratorPort.java` + `PdfGeneratorAdapter.java` — OpenHTMLToPDF + Thymeleaf template (`enrollment-form.html`) (HU-09: PDF enrollment form) → SPEC-021
- [ ] **T9.4.3** Create `ExportPort.java` + `SchoolSystemsExportAdapter.java` — Apache POI for XLSX, BufferedWriter for TXT (CON-3) (HU-09: export to School Systems) → SPEC-021
- [ ] **T9.4.4** Create `DownloadEnrollmentFormUseCase.java` — collects data from 3 modules, delegates to PDF/export adapter (HU-09) → SPEC-021
- [ ] **T9.4.5** Create controller endpoints: `PUT /api/enrollments/{id}/finalize`, `GET /api/enrollments/{id}/form/download`, `GET /api/enrollments/{id}/export` (HU-09, HU-10) → SPEC-021
- [ ] **T9.4.6** Complete audit events: `COURSES_SELECTED`, `ENROLLMENT_APPROVED`, `ENROLLMENT_REJECTED`, `ENROLLMENT_FINALIZED` (HU-07, HU-08, HU-09) → SPEC-021

---

## Deliverables

- [ ] **E9.1** Student selects courses with validation (quota, schedule, program rules) — Specs: SPEC-019
- [ ] **E9.2** Advisor approves → quota decremented; rejects → student can resubmit — Specs: SPEC-020
- [ ] **E9.3** Coordinator finalizes → enrollment locked with finalization date — Specs: SPEC-021
- [ ] **E9.4** PDF download produces official enrollment form — Specs: SPEC-021
- [ ] **E9.5** TXT/XLSX export matches School Systems format (CON-3) — Specs: SPEC-021
- [ ] **E9.6** Full audit trail: all 14 domain events captured in `audit_events` — Specs: SPEC-021

---

## Transition Criteria

- [ ] `mvn clean verify` passes with ≥80% coverage
- [ ] Full workflow test: create term → upload CSV → open enrollment → student selects → advisor approves → coordinator finalizes → download PDF
- [ ] Rejection loop: advisor rejects → student resubmits → advisor approves
- [ ] State machine rejects invalid transitions (e.g., cannot finalize without approval)
- [ ] All Gherkin scenarios in `student_selection.feature`, `advisor_approval.feature`, `enrollment_finalization.feature` mapped to tests
- [ ] All 14 audit events from `audit_event_capture.feature` verified in DB
- [ ] All linked specs are ✅ Implemented
- [ ] No regressions from Phases 1–8

---

## Risks

| # | Risk | Impact | Probability | Mitigation |
|---|------|--------|-------------|------------|
| R-9.1 | Cross-module query performance (3 modules in PDF generation) | Medio | Media | Use `@EntityGraph` or `JOIN FETCH`; single transaction |
| R-9.2 | Enrollment form PDF template not finalized | Alto | Media | Create provisional template; mark as external dependency with PO |
| R-9.3 | TXT/XLSX export format not documented by School Systems | Alto | Media | Reverse-engineer from existing exports; validate with Lic. César |
| R-9.4 | Concurrent advisor approvals decrementing quota | Alto | Baja | Optimistic locking on `UEAGroup.availableQuota` |

---

## Notes and Decisions

> Las decisiones se registran en [`progress.md`](progress.md) Decision Log.

| # | Decision ID | Summary |
|---|-------------|---------|
| — | — | — |
