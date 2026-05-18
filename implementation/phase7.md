# Phase 7 — Entity Management & Credential Flows (BC-02, BC-06)

> **ADD Iteration:** 4
> **Drivers:** HU-15 (register student), HU-21 (register professor), QA-6 (i18n), HU-02 (password recovery), HU-28 (password change)
> **Status:** 🔲 Not started

**Goal:** Implement Student and Professor CRUD with cross-module user creation (Academic Management → Identity), password recovery and change flows, and email integration.

> **Environment:** Backend against PostgreSQL; email via MailHog or Mailtrap for dev.
> **Domain Schema:** [`academic-management.schema.json`](../sdd/domain/schemas/academic-management.schema.json), [`identity-access.schema.json`](../sdd/domain/schemas/identity-access.schema.json)
> **Domain Features:** [`features/academic-management/`](../sdd/domain/features/academic-management/), [`features/identity-access/password_recovery.feature`](../sdd/domain/features/identity-access/password_recovery.feature), [`features/identity-access/password_change.feature`](../sdd/domain/features/identity-access/password_change.feature)

### User Stories (HU)

| HU | Title | Role in Phase |
|----|-------|---------------|
| [HU-15](../vision/HU/HU-15.md) | Registro de nuevos alumnos en el sistema | Primary — Student aggregate, registration use case, one-time password |
| [HU-21](../vision/HU/HU-21.md) | Registro de nuevos profesores | Primary — Professor aggregate, registration use case, one-time password |
| [HU-02](../vision/HU/HU-02.md) | Recuperación de contraseña | Primary — Forgot/reset password flow, email with reset link |
| [HU-28](../vision/HU/HU-28.md) | Actualización de contraseña de usuario | Primary — Self-change and coordinator-change password |

---

## A7.1 — Student Registration 🔲

> Specs: SPEC-013 (TBD — Student aggregate, registration use case, controller)

- [ ] **T7.1.1** Create `Student.java` — AR with `PersonalData` VO and `AcademicInformation` VO from `academic-management.schema.json` (HU-15: student data) → SPEC-013
- [ ] **T7.1.2** Create `PersonalData.java`, `AcademicInformation.java` — VOs with field constraints (HU-15: personal and academic data) → SPEC-013
- [ ] **T7.1.3** Create `RegisterStudentUseCase.java` — orchestrates: validate uniqueness → generate password → create User via `UserRepositoryPort` → create Student → persist both → return one-time password (HU-15) → SPEC-013
- [ ] **T7.1.4** Create `PasswordGenerationService.java` — domain service using `SecureTokenGeneratorPort` (HU-15, HU-21: auto-generated passwords) → SPEC-013
- [ ] **T7.1.5** Create `StudentController.java` — `POST /api/students`, `GET /api/students` — COORDINATOR role (HU-15) → SPEC-013
- [ ] **T7.1.6** Create `StudentMapper.java` (MapStruct), DTOs, Flyway migration (HU-15) → SPEC-013

## A7.2 — Professor Registration 🔲

> Specs: SPEC-014 (TBD — Professor aggregate, registration use case)

- [ ] **T7.2.1** Create `Professor.java` — AR with `PersonalData` VO from schema (HU-21: professor data) → SPEC-014
- [ ] **T7.2.2** Create `RegisterProfessorUseCase.java` — same cross-module pattern as student (HU-21) → SPEC-014
- [ ] **T7.2.3** Create `ProfessorController.java` — `POST /api/professors`, `GET /api/professors` — COORDINATOR role (HU-21) → SPEC-014
- [ ] **T7.2.4** Create `ProfessorMapper.java`, DTOs, Flyway migration (HU-21) → SPEC-014

## A7.3 — Password Recovery & Change 🔲

> Specs: SPEC-015 (TBD — Password reset token, forgot/reset/change use cases, email adapter)

- [ ] **T7.3.1** Create `PasswordResetToken.java` — VO with `isExpired()`, `isUsed()`, `markAsUsed()`, factory method `create(tokenHash, ttl)` (HU-02) → SPEC-015
- [ ] **T7.3.2** Create `ForgotPasswordUseCase.java` — generate token → hash → persist → email → always return success (HU-02) → SPEC-015
- [ ] **T7.3.3** Create `ResetPasswordUseCase.java` — validate token → hash new password → update user → revoke refresh tokens (HU-02) → SPEC-015
- [ ] **T7.3.4** Create `ChangePasswordUseCase.java` — self-change (verify current) and coordinator-change (skip verify) (HU-28) → SPEC-015
- [ ] **T7.3.5** Create `EmailAdapter.java` — `EmailPort` with Spring Mail + Thymeleaf templates (`password-reset_es.html`, `password-reset_en.html`) (HU-02: reset email) → SPEC-015
- [ ] **T7.3.6** Create `SecureTokenGeneratorAdapter.java` — `SecureRandom` + URL-safe Base64 (HU-02, HU-15, HU-21) → SPEC-015
- [ ] **T7.3.7** Create `PasswordController.java` — `POST /api/auth/forgot-password`, `POST /api/auth/reset-password`, `PUT /api/users/{id}/password` (HU-02, HU-28) → SPEC-015

---

## Deliverables

- [ ] **E7.1** Register student creates User (STUDENT role) + Student in single transaction — Specs: SPEC-013
- [ ] **E7.2** Register professor creates User (PROFESSOR role) + Professor in single transaction — Specs: SPEC-014
- [ ] **E7.3** Forgot password sends email with reset link; reset password works with valid token — Specs: SPEC-015
- [ ] **E7.4** Change password works for self-change and coordinator-change — Specs: SPEC-015
- [ ] **E7.5** Audit events captured: STUDENT_REGISTERED, PROFESSOR_REGISTERED, PASSWORD_RESET, PASSWORD_CHANGE — Specs: SPEC-013, SPEC-014, SPEC-015

---

## Transition Criteria

- [ ] `mvn clean verify` passes with ≥80% coverage
- [ ] Student/Professor registration creates both User and entity in DB
- [ ] One-time password returned only during registration response
- [ ] Password recovery email contains valid reset link
- [ ] Token expiry (30 min) and single-use flag enforced
- [ ] All Gherkin scenarios in `student_registration.feature`, `professor_registration.feature`, `password_recovery.feature`, `password_change.feature` mapped to tests
- [ ] All linked specs are ✅ Implemented
- [ ] No regressions from Phases 1–6

---

## Risks

| # | Risk | Impact | Probability | Mitigation |
|---|------|--------|-------------|------------|
| R-7.1 | Email server not available in dev | Medio | Alta | Use MailHog/Mailtrap for local dev; mock `EmailPort` in tests |
| R-7.2 | Cross-module transaction complexity | Alto | Media | Single `@Transactional` in use case; both repos share same DataSource |
| R-7.3 | Password generation randomness insufficient | Alto | Baja | Use `java.security.SecureRandom`; 12 chars with mixed complexity |

---

## Notes and Decisions

> Las decisiones se registran en [`progress.md`](progress.md) Decision Log.

| # | Decision ID | Summary |
|---|-------------|---------|
| — | — | — |
