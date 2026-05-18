# Inventario de contenido en español — SAPCyTI Docs

> **Repositorio:** `/home/hrlm/SAPCyTI/Docs`  
> **Generado:** 2026-05-18  
> **Alcance:** 175 archivos de texto escaneados (`.md`, `.mdc`, `.feature`, `.json`, `.sh`, `.yml`, `.yaml`, `.txt`), excluyendo `.git/`.

## Criterios de detección

Un archivo se incluye si contiene **al menos uno** de:

- Caracteres con tilde o eñes: `á é í ó ú ñ ¿ ¡ ü`
- Frases o encabezados habituales del banco de memoria en español (`Propósito`, `Cuándo leer`, `Criterios de Aceptación`, `Conversación`, `especificación`, `implementación`, `Coordinador`, etc.)
- Texto de negocio en español (HUs, features Gherkin, descripciones de dominio)

**Nota:** Algunos archivos son **bilingües** (español + inglés técnico). Otros tienen **fragmentos** en español (p. ej. una pregunta en `engram.mdc` y el resto en inglés).


| Métrica                              | Cantidad                                                       |
| ------------------------------------ | -------------------------------------------------------------- |
| Archivos con español total o parcial | **136**                                                        |
| Archivos solo en inglés (referencia) | 39 — ver [§ Archivos solo en inglés](#archivos-solo-en-inglés) |


---

## Raíz del repositorio


| Ruta absoluta                                     | Notas                       |
| ------------------------------------------------- | --------------------------- |
| ✅ `/home/hrlm/SAPCyTI/Docs/AGENTS.md`               | Bilingüe (protocolo LLM)    |
| ✅ `/home/hrlm/SAPCyTI/Docs/CANONICAL.md`            | Español                     |
| ✅ `/home/hrlm/SAPCyTI/Docs/README.md`               | Español                     |
| ✅ `/home/hrlm/SAPCyTI/Docs/MERGE-GUIDE.md`          | Español (stub → onboarding) |
| ✅ `/home/hrlm/SAPCyTI/Docs/estructura-propuesta.md` | Español                     |
| ✅ `/home/hrlm/SAPCyTI/Docs/external-references.md`  | Español                     |
| ✅ `/home/hrlm/SAPCyTI/Docs/resumen-propuesta.md`    | Español                     |


---

## `.cursor/`


| Ruta absoluta                                                              | Notas                                                |
| -------------------------------------------------------------------------- | ---------------------------------------------------- |
| `/home/hrlm/SAPCyTI/Docs/.cursor/rules/engram.mdc`                         | Fragmentos (preguntas al usuario en español)         |
| `/home/hrlm/SAPCyTI/Docs/.cursor/skills/implementation-architect/SKILL.md` | Referencias / términos en español en enlaces o notas |


---

## `.windsurf/`


| Ruta absoluta                                       | Notas                             |
| --------------------------------------------------- | --------------------------------- |
| `/home/hrlm/SAPCyTI/Docs/.windsurf/rules/engram.md` | Fragmentos (equivalente a engram) |


---

## `design/`


| Ruta absoluta                                            | Notas                                                                  |
| -------------------------------------------------------- | ---------------------------------------------------------------------- |
| `/home/hrlm/SAPCyTI/Docs/design/Architecture.md`         | Bilingüe (mayoría inglés; drivers/HU y secciones con texto en español) |
| `/home/hrlm/SAPCyTI/Docs/design/Architecture-INDEX.md`   | Español                                                                |
| `/home/hrlm/SAPCyTI/Docs/design/ArchitecturalDrivers.md` | Bilingüe                                                               |
| `/home/hrlm/SAPCyTI/Docs/design/README.md`               | Español                                                                |


---

## `implementation/`


| Ruta absoluta                                                  | Notas                 |
| -------------------------------------------------------------- | --------------------- |
| `/home/hrlm/SAPCyTI/Docs/implementation/README.md`             | Español               |
| `/home/hrlm/SAPCyTI/Docs/implementation/implementationPlan.md` | Bilingüe              |
| `/home/hrlm/SAPCyTI/Docs/implementation/progress.md`           | Bilingüe              |
| `/home/hrlm/SAPCyTI/Docs/implementation/phase1.md`             | Fragmentos en español |
| `/home/hrlm/SAPCyTI/Docs/implementation/phase3.md`             | Fragmentos en español |
| `/home/hrlm/SAPCyTI/Docs/implementation/phase4a.md`            | Fragmentos en español |
| `/home/hrlm/SAPCyTI/Docs/implementation/phase6.md`             | Fragmentos en español |
| `/home/hrlm/SAPCyTI/Docs/implementation/phase7.md`             | Fragmentos en español |
| `/home/hrlm/SAPCyTI/Docs/implementation/phase8.md`             | Fragmentos en español |
| `/home/hrlm/SAPCyTI/Docs/implementation/phase9.md`             | Fragmentos en español |


### `implementation/blockers/`


| Ruta absoluta                                                              | Notas   |
| -------------------------------------------------------------------------- | ------- |
| `/home/hrlm/SAPCyTI/Docs/implementation/blockers/README.md`                | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/blockers/B-001-npm-unavailable.md` | Español |


### `implementation/decisions/`


| Ruta absoluta                                                                          | Notas   |
| -------------------------------------------------------------------------------------- | ------- |
| `/home/hrlm/SAPCyTI/Docs/implementation/decisions/README.md`                           | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-001-license-mit.md`                | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-002-conventional-commits.md`       | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-003-checkstyle-google.md`          | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-004-owasp-continue-on-error.md`    | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-005-docker-compose-api.md`         | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-006-quality-plugins-ci.md`         | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-007-manual-spring-boot-project.md` | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-008-tenant-shared-package.md`      | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-009-checkstyle-linelength.md`      | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-010-eslint-flat-config.md`         | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-011-eslint-mjs-extension.md`       | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-012-vitest-angular-build.md`       | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-013-postcss-json.md`               | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-014-postgres-port-5433.md`         | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-015-method-security-phase3.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-016-jacoco-mapper-exclude.md`      | Español |


### `implementation/example/`


| Ruta absoluta                                              | Notas   |
| ---------------------------------------------------------- | ------- |
| `/home/hrlm/SAPCyTI/Docs/implementation/example/README.md` | Español |


### `implementation/sessions/`


| Ruta absoluta                                                               | Notas   |
| --------------------------------------------------------------------------- | ------- |
| `/home/hrlm/SAPCyTI/Docs/implementation/sessions/README.md`                 | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/sessions/2026-04-19-phase0.md`      | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/sessions/2026-04-19-planning.md`    | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/sessions/2026-04-24-phase1.md`      | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/sessions/2026-05-12-phase1-docs.md` | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/sessions/2026-05-12-phase4a.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/sessions/2026-05-17-phases-2-3.md`  | Español |


### `implementation/templates/`


| Ruta absoluta                                                           | Notas   |
| ----------------------------------------------------------------------- | ------- |
| `/home/hrlm/SAPCyTI/Docs/implementation/templates/README.md`            | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/templates/BLOCKER-TEMPLATE.md`  | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/templates/DECISION-TEMPLATE.md` | Español |
| `/home/hrlm/SAPCyTI/Docs/implementation/templates/SESSION-TEMPLATE.md`  | Español |


---

## `onboarding/`


| Ruta absoluta                                                        | Notas   |
| -------------------------------------------------------------------- | ------- |
| `/home/hrlm/SAPCyTI/Docs/onboarding/README.md`                       | Español |
| `/home/hrlm/SAPCyTI/Docs/onboarding/01-como-trabajamos.md`           | Español |
| `/home/hrlm/SAPCyTI/Docs/onboarding/02-tour-directorios.md`          | Español |
| `/home/hrlm/SAPCyTI/Docs/onboarding/03-primera-tarea.md`             | Español |
| `/home/hrlm/SAPCyTI/Docs/onboarding/04-roles-y-responsabilidades.md` | Español |
| `/home/hrlm/SAPCyTI/Docs/onboarding/05-trabajo-en-equipo.md`         | Español |
| `/home/hrlm/SAPCyTI/Docs/onboarding/MERGE-GUIDE.md`                  | Español |


---

## `requirements/`


| Ruta absoluta                                                       | Notas   |
| ------------------------------------------------------------------- | ------- |
| `/home/hrlm/SAPCyTI/Docs/requirements/Atributos_y_Restricciones.md` | Español |
| `/home/hrlm/SAPCyTI/Docs/requirements/Reporte_Ejecucion_Agente.md`  | Español |


---

## `sdd/`


| Ruta absoluta                                      | Notas                                     |
| -------------------------------------------------- | ----------------------------------------- |
| `/home/hrlm/SAPCyTI/Docs/sdd/README.md`            | Español                                   |
| `/home/hrlm/SAPCyTI/Docs/sdd/SPEC_INDEX.md`        | Bilingüe                                  |
| `/home/hrlm/SAPCyTI/Docs/sdd/theory/SDD-theory.md` | Español (con términos técnicos en inglés) |


### `sdd/domain/`


| Ruta absoluta                                      | Notas    |
| -------------------------------------------------- | -------- |
| `/home/hrlm/SAPCyTI/Docs/sdd/domain/README.md`     | Español  |
| `/home/hrlm/SAPCyTI/Docs/sdd/domain/ContextMap.md` | Bilingüe |
| `/home/hrlm/SAPCyTI/Docs/sdd/domain/Summary.md`    | Español  |


### `sdd/domain/features/`


| Ruta absoluta                                                                                                  | Notas             |
| -------------------------------------------------------------------------------------------------------------- | ----------------- |
| `/home/hrlm/SAPCyTI/Docs/sdd/domain/features/academic-management/student_registration.feature`                 | Español (Gherkin) |
| `/home/hrlm/SAPCyTI/Docs/sdd/domain/features/academic-offering/csv_upload_and_term_management.feature`         | Español (Gherkin) |
| `/home/hrlm/SAPCyTI/Docs/sdd/domain/features/enrollment/student_selection.feature`                             | Español (Gherkin) |
| `/home/hrlm/SAPCyTI/Docs/sdd/domain/features/enrollment/enrollment_finalization.feature`                       | Español (Gherkin) |
| `/home/hrlm/SAPCyTI/Docs/sdd/domain/features/identity-access/authentication.feature`                           | Español (Gherkin) |
| `/home/hrlm/SAPCyTI/Docs/sdd/domain/features/identity-access/password_change.feature`                          | Español (Gherkin) |
| `/home/hrlm/SAPCyTI/Docs/sdd/domain/features/identity-access/password_recovery.feature`                        | Español (Gherkin) |
| `/home/hrlm/SAPCyTI/Docs/sdd/domain/features/program-configuration/configuration_parameter_management.feature` | Español (Gherkin) |
| `/home/hrlm/SAPCyTI/Docs/sdd/domain/features/program-configuration/graduate_program_management.feature`        | Español (Gherkin) |


### `sdd/domain/schemas/`


| Ruta absoluta                                                                  | Notas                    |
| ------------------------------------------------------------------------------ | ------------------------ |
| `/home/hrlm/SAPCyTI/Docs/sdd/domain/schemas/academic-management.schema.json`   | Descripciones en español |
| `/home/hrlm/SAPCyTI/Docs/sdd/domain/schemas/academic-offering.schema.json`     | Descripciones en español |
| `/home/hrlm/SAPCyTI/Docs/sdd/domain/schemas/enrollment.schema.json`            | Descripciones en español |
| `/home/hrlm/SAPCyTI/Docs/sdd/domain/schemas/program-configuration.schema.json` | Descripciones en español |


### `sdd/specs/iteration-1/`


| Ruta absoluta                                                                                             | Notas               |
| --------------------------------------------------------------------------------------------------------- | ------------------- |
| `/home/hrlm/SAPCyTI/Docs/sdd/specs/iteration-1/SPEC-001_spring-boot-project-and-maven-build.md`           | Bilingüe            |
| `/home/hrlm/SAPCyTI/Docs/sdd/specs/iteration-1/SPEC-002_application-configuration-profiles-logging.md`    | Bilingüe            |
| `/home/hrlm/SAPCyTI/Docs/sdd/specs/iteration-1/SPEC-003_hexagonal-packages-tenant-filter-cors.md`         | Bilingüe            |
| `/home/hrlm/SAPCyTI/Docs/sdd/specs/iteration-1/SPEC-004_graduate-program-domain-persistence.md`           | Bilingüe            |
| `/home/hrlm/SAPCyTI/Docs/sdd/specs/iteration-1/SPEC-005_configuration-parameter-persistence-isolation.md` | Bilingüe            |
| `/home/hrlm/SAPCyTI/Docs/sdd/specs/iteration-1/SPEC-008A_angular-project-scaffold-tooling.md`             | Inglés + fragmentos |
| `/home/hrlm/SAPCyTI/Docs/sdd/specs/iteration-1/SPEC-008B_spa-core-providers-shell-i18n.md`                | Inglés + fragmentos |


### `sdd/templates/`


| Ruta absoluta                                                           | Notas    |
| ----------------------------------------------------------------------- | -------- |
| `/home/hrlm/SAPCyTI/Docs/sdd/templates/README.md`                       | Español  |
| `/home/hrlm/SAPCyTI/Docs/sdd/templates/SPEC-TEMPLATE.md`                | Bilingüe |
| `/home/hrlm/SAPCyTI/Docs/sdd/templates/PHASE-TEMPLATE.md`               | Bilingüe |
| `/home/hrlm/SAPCyTI/Docs/sdd/templates/PROGRESS-TEMPLATE.md`            | Español  |
| `/home/hrlm/SAPCyTI/Docs/sdd/templates/IMPLEMENTATION-PLAN-TEMPLATE.md` | Bilingüe |
| `/home/hrlm/SAPCyTI/Docs/sdd/templates/DOMAIN-BC-TEMPLATE.md`           | Español  |


---

## `technologies/`


| Ruta absoluta                                     | Notas                 |
| ------------------------------------------------- | --------------------- |
| `/home/hrlm/SAPCyTI/Docs/technologies/README.md`  | Español               |
| `/home/hrlm/SAPCyTI/Docs/technologies/backend.md` | Fragmentos en español |


---

## `vision/`


| Ruta absoluta                              | Notas   |
| ------------------------------------------ | ------- |
| `/home/hrlm/SAPCyTI/Docs/vision/Vision.md` | Español |


### `vision/HU/` (35 historias + índice)


| Ruta absoluta                                    | Notas   |
| ------------------------------------------------ | ------- |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/README.md`    | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/00-INDICE.md` | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-01.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-02.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-03.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-04.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-05.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-06.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-07.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-08.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-09.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-10.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-11.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-12.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-13.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-14.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-15.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-16.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-17.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-18.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-19.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-20.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-21.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-22.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-23.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-24.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-25.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-26.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-27.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-28.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-29.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-30.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-31.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-32.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-33.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-34.md`     | Español |
| `/home/hrlm/SAPCyTI/Docs/vision/HU/HU-35.md`     | Español |


---

## Lista plana (136 rutas)

```
/home/hrlm/SAPCyTI/Docs/.cursor/rules/engram.mdc
/home/hrlm/SAPCyTI/Docs/.cursor/skills/implementation-architect/SKILL.md
/home/hrlm/SAPCyTI/Docs/.windsurf/rules/engram.md
/home/hrlm/SAPCyTI/Docs/AGENTS.md
/home/hrlm/SAPCyTI/Docs/CANONICAL.md
/home/hrlm/SAPCyTI/Docs/MERGE-GUIDE.md
/home/hrlm/SAPCyTI/Docs/README.md
/home/hrlm/SAPCyTI/Docs/design/ArchitecturalDrivers.md
/home/hrlm/SAPCyTI/Docs/design/Architecture-INDEX.md
/home/hrlm/SAPCyTI/Docs/design/Architecture.md
/home/hrlm/SAPCyTI/Docs/design/README.md
/home/hrlm/SAPCyTI/Docs/estructura-propuesta.md
/home/hrlm/SAPCyTI/Docs/external-references.md
/home/hrlm/SAPCyTI/Docs/implementation/README.md
/home/hrlm/SAPCyTI/Docs/implementation/blockers/B-001-npm-unavailable.md
/home/hrlm/SAPCyTI/Docs/implementation/blockers/README.md
/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-001-license-mit.md
/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-002-conventional-commits.md
/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-003-checkstyle-google.md
/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-004-owasp-continue-on-error.md
/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-005-docker-compose-api.md
/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-006-quality-plugins-ci.md
/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-007-manual-spring-boot-project.md
/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-008-tenant-shared-package.md
/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-009-checkstyle-linelength.md
/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-010-eslint-flat-config.md
/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-011-eslint-mjs-extension.md
/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-012-vitest-angular-build.md
/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-013-postcss-json.md
/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-014-postgres-port-5433.md
/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-015-method-security-phase3.md
/home/hrlm/SAPCyTI/Docs/implementation/decisions/D-016-jacoco-mapper-exclude.md
/home/hrlm/SAPCyTI/Docs/implementation/decisions/README.md
/home/hrlm/SAPCyTI/Docs/implementation/example/README.md
/home/hrlm/SAPCyTI/Docs/implementation/implementationPlan.md
/home/hrlm/SAPCyTI/Docs/implementation/phase1.md
/home/hrlm/SAPCyTI/Docs/implementation/phase3.md
/home/hrlm/SAPCyTI/Docs/implementation/phase4a.md
/home/hrlm/SAPCyTI/Docs/implementation/phase6.md
/home/hrlm/SAPCyTI/Docs/implementation/phase7.md
/home/hrlm/SAPCyTI/Docs/implementation/phase8.md
/home/hrlm/SAPCyTI/Docs/implementation/phase9.md
/home/hrlm/SAPCyTI/Docs/implementation/progress.md
/home/hrlm/SAPCyTI/Docs/implementation/sessions/2026-04-19-phase0.md
/home/hrlm/SAPCyTI/Docs/implementation/sessions/2026-04-19-planning.md
/home/hrlm/SAPCyTI/Docs/implementation/sessions/2026-04-24-phase1.md
/home/hrlm/SAPCyTI/Docs/implementation/sessions/2026-05-12-phase1-docs.md
/home/hrlm/SAPCyTI/Docs/implementation/sessions/2026-05-12-phase4a.md
/home/hrlm/SAPCyTI/Docs/implementation/sessions/2026-05-17-phases-2-3.md
/home/hrlm/SAPCyTI/Docs/implementation/sessions/README.md
/home/hrlm/SAPCyTI/Docs/implementation/templates/BLOCKER-TEMPLATE.md
/home/hrlm/SAPCyTI/Docs/implementation/templates/DECISION-TEMPLATE.md
/home/hrlm/SAPCyTI/Docs/implementation/templates/README.md
/home/hrlm/SAPCyTI/Docs/implementation/templates/SESSION-TEMPLATE.md
/home/hrlm/SAPCyTI/Docs/onboarding/01-como-trabajamos.md
/home/hrlm/SAPCyTI/Docs/onboarding/02-tour-directorios.md
/home/hrlm/SAPCyTI/Docs/onboarding/03-primera-tarea.md
/home/hrlm/SAPCyTI/Docs/onboarding/04-roles-y-responsabilidades.md
/home/hrlm/SAPCyTI/Docs/onboarding/05-trabajo-en-equipo.md
/home/hrlm/SAPCyTI/Docs/onboarding/MERGE-GUIDE.md
/home/hrlm/SAPCyTI/Docs/onboarding/README.md
/home/hrlm/SAPCyTI/Docs/requirements/Atributos_y_Restricciones.md
/home/hrlm/SAPCyTI/Docs/requirements/Reporte_Ejecucion_Agente.md
/home/hrlm/SAPCyTI/Docs/resumen-propuesta.md
/home/hrlm/SAPCyTI/Docs/sdd/README.md
/home/hrlm/SAPCyTI/Docs/sdd/SPEC_INDEX.md
/home/hrlm/SAPCyTI/Docs/sdd/domain/ContextMap.md
/home/hrlm/SAPCyTI/Docs/sdd/domain/README.md
/home/hrlm/SAPCyTI/Docs/sdd/domain/Summary.md
/home/hrlm/SAPCyTI/Docs/sdd/domain/features/academic-management/student_registration.feature
/home/hrlm/SAPCyTI/Docs/sdd/domain/features/academic-offering/csv_upload_and_term_management.feature
/home/hrlm/SAPCyTI/Docs/sdd/domain/features/enrollment/enrollment_finalization.feature
/home/hrlm/SAPCyTI/Docs/sdd/domain/features/enrollment/student_selection.feature
/home/hrlm/SAPCyTI/Docs/sdd/domain/features/identity-access/authentication.feature
/home/hrlm/SAPCyTI/Docs/sdd/domain/features/identity-access/password_change.feature
/home/hrlm/SAPCyTI/Docs/sdd/domain/features/identity-access/password_recovery.feature
/home/hrlm/SAPCyTI/Docs/sdd/domain/features/program-configuration/configuration_parameter_management.feature
/home/hrlm/SAPCyTI/Docs/sdd/domain/features/program-configuration/graduate_program_management.feature
/home/hrlm/SAPCyTI/Docs/sdd/domain/schemas/academic-management.schema.json
/home/hrlm/SAPCyTI/Docs/sdd/domain/schemas/academic-offering.schema.json
/home/hrlm/SAPCyTI/Docs/sdd/domain/schemas/enrollment.schema.json
/home/hrlm/SAPCyTI/Docs/sdd/domain/schemas/program-configuration.schema.json
/home/hrlm/SAPCyTI/Docs/sdd/specs/iteration-1/SPEC-001_spring-boot-project-and-maven-build.md
/home/hrlm/SAPCyTI/Docs/sdd/specs/iteration-1/SPEC-002_application-configuration-profiles-logging.md
/home/hrlm/SAPCyTI/Docs/sdd/specs/iteration-1/SPEC-003_hexagonal-packages-tenant-filter-cors.md
/home/hrlm/SAPCyTI/Docs/sdd/specs/iteration-1/SPEC-004_graduate-program-domain-persistence.md
/home/hrlm/SAPCyTI/Docs/sdd/specs/iteration-1/SPEC-005_configuration-parameter-persistence-isolation.md
/home/hrlm/SAPCyTI/Docs/sdd/specs/iteration-1/SPEC-008A_angular-project-scaffold-tooling.md
/home/hrlm/SAPCyTI/Docs/sdd/specs/iteration-1/SPEC-008B_spa-core-providers-shell-i18n.md
/home/hrlm/SAPCyTI/Docs/sdd/templates/DOMAIN-BC-TEMPLATE.md
/home/hrlm/SAPCyTI/Docs/sdd/templates/IMPLEMENTATION-PLAN-TEMPLATE.md
/home/hrlm/SAPCyTI/Docs/sdd/templates/PHASE-TEMPLATE.md
/home/hrlm/SAPCyTI/Docs/sdd/templates/PROGRESS-TEMPLATE.md
/home/hrlm/SAPCyTI/Docs/sdd/templates/README.md
/home/hrlm/SAPCyTI/Docs/sdd/templates/SPEC-TEMPLATE.md
/home/hrlm/SAPCyTI/Docs/sdd/theory/SDD-theory.md
/home/hrlm/SAPCyTI/Docs/technologies/README.md
/home/hrlm/SAPCyTI/Docs/technologies/backend.md
/home/hrlm/SAPCyTI/Docs/vision/HU/00-INDICE.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-01.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-02.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-03.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-04.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-05.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-06.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-07.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-08.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-09.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-10.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-11.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-12.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-13.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-14.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-15.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-16.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-17.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-18.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-19.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-20.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-21.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-22.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-23.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-24.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-25.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-26.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-27.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-28.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-29.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-30.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-31.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-32.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-33.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-34.md
/home/hrlm/SAPCyTI/Docs/vision/HU/HU-35.md
/home/hrlm/SAPCyTI/Docs/vision/HU/README.md
/home/hrlm/SAPCyTI/Docs/vision/Vision.md
```

---

## Archivos solo en inglés

Estos **39** archivos no coincidieron con los criterios de español (útil para planificar traducción o unificación de idioma):

```
/home/hrlm/SAPCyTI/Docs/.cursor/mcp.json
/home/hrlm/SAPCyTI/Docs/.cursor/rules/sapcyti.mdc
/home/hrlm/SAPCyTI/Docs/.cursor/rules/task_execution.mdc
/home/hrlm/SAPCyTI/Docs/.cursor/skills/arquitecture-add/ADD.md
/home/hrlm/SAPCyTI/Docs/.cursor/skills/arquitecture-add/SKILL.md
/home/hrlm/SAPCyTI/Docs/.cursor/skills/implement-spec.md
/home/hrlm/SAPCyTI/Docs/.cursor/skills/review-code.md
/home/hrlm/SAPCyTI/Docs/.cursor/skills/write-spec.md
/home/hrlm/SAPCyTI/Docs/.github/workflows/docs-verify.yml
/home/hrlm/SAPCyTI/Docs/.windsurf/mcp_config.json
/home/hrlm/SAPCyTI/Docs/.windsurf/rules/sapcyti.md
/home/hrlm/SAPCyTI/Docs/.windsurf/rules/task_execution.md
/home/hrlm/SAPCyTI/Docs/.windsurf/skills/arquitecture-add/ADD.md
/home/hrlm/SAPCyTI/Docs/.windsurf/skills/arquitecture-add/SKILL.md
/home/hrlm/SAPCyTI/Docs/.windsurf/skills/implement-spec.md
/home/hrlm/SAPCyTI/Docs/.windsurf/skills/implementation-architect/SKILL.md
/home/hrlm/SAPCyTI/Docs/.windsurf/skills/review-code.md
/home/hrlm/SAPCyTI/Docs/.windsurf/skills/write-spec.md
/home/hrlm/SAPCyTI/Docs/design/ADD.md
/home/hrlm/SAPCyTI/Docs/design/IterationPlan.md
/home/hrlm/SAPCyTI/Docs/implementation/example/implementationPlan.md
/home/hrlm/SAPCyTI/Docs/implementation/example/phase1-foundation.md
/home/hrlm/SAPCyTI/Docs/implementation/example/progress.md
/home/hrlm/SAPCyTI/Docs/implementation/phase0.md
/home/hrlm/SAPCyTI/Docs/implementation/phase2.md
/home/hrlm/SAPCyTI/Docs/implementation/phase4.md
/home/hrlm/SAPCyTI/Docs/implementation/phase5.md
/home/hrlm/SAPCyTI/Docs/requirements/Concerns.md
/home/hrlm/SAPCyTI/Docs/scripts/verify-docs.sh
/home/hrlm/SAPCyTI/Docs/sdd/domain/features/academic-management/professor_registration.feature
/home/hrlm/SAPCyTI/Docs/sdd/domain/features/audit/audit_event_capture.feature
/home/hrlm/SAPCyTI/Docs/sdd/domain/features/enrollment/advisor_approval.feature
/home/hrlm/SAPCyTI/Docs/sdd/domain/schemas/audit.schema.json
/home/hrlm/SAPCyTI/Docs/sdd/domain/schemas/identity-access.schema.json
/home/hrlm/SAPCyTI/Docs/sdd/specs/iteration-1/SPEC-006_graduate-program-application-rest-api.md
/home/hrlm/SAPCyTI/Docs/sdd/specs/iteration-1/SPEC-007_configuration-parameter-application-rest-global-errors.md
/home/hrlm/SAPCyTI/Docs/technologies/devops.md
/home/hrlm/SAPCyTI/Docs/technologies/frontend.md
/home/hrlm/SAPCyTI/Docs/technologies/testing.md
```

### Features Gherkin solo en inglés (sin coincidencia en esta pasada)


| Ruta absoluta                                                                                    |
| ------------------------------------------------------------------------------------------------ |
| `/home/hrlm/SAPCyTI/Docs/sdd/domain/features/academic-management/professor_registration.feature` |
| `/home/hrlm/SAPCyTI/Docs/sdd/domain/features/audit/audit_event_capture.feature`                  |
| `/home/hrlm/SAPCyTI/Docs/sdd/domain/features/enrollment/advisor_approval.feature`                |


---

## No escaneado

- Imágenes: `/home/hrlm/SAPCyTI/Docs/vision/diagramaContexto.PNG` (sin texto extraíble en este inventario)
- Binarios y carpeta `.git/`

