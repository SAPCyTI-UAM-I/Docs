# Memory Bank — SAPCyTI

Index of all project documentation. These documents are the **knowledge base** that powers specification-driven development (SDD).


| Guide                                                                       | Content                                           |
| -------------------------------------------------------------------------- | --------------------------------------------------- |
| `[AGENTS.md](AGENTS.md)`                                                   | Context loading protocol for LLM             |
| `[CANONICAL.md](CANONICAL.md)`                                             | Canonical and deprecated paths                        |
| `[onboarding/](onboarding/)`                                               | Guide for new team members                        |
| `[MERGE-GUIDE.md](MERGE-GUIDE.md)`                                         | Guide for reorganization PR reviewers        |
| `[sdd/templates/README.md](sdd/templates/README.md)`                       | Master template index (spec, phase, plan, BC) |
| `[implementation/templates/README.md](implementation/templates/README.md)` | Operational templates (session, decision, blocker)   |


---

## Vision and Requirements


| Document                                                                                | Content                                                  |
| ---------------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| `[vision/Vision.md](vision/Vision.md)`                                                   | System overview, scope, and stakeholders         |
| `[vision/HU/](vision/HU/)`                                                               | 35 user stories ([index](vision/HU/00-INDICE.md)) |
| `[requirements/Atributos_y_Restricciones.md](requirements/Atributos_y_Restricciones.md)` | System quality attributes and constraints           |
| `[requirements/Concerns.md](requirements/Concerns.md)`                                   | Identified architectural concerns                     |


## Architectural Design


| Document                                                   | Content                                                             |
| ----------------------------------------------------------- | --------------------------------------------------------------------- |
| `[ArchitecturalDrivers.md](design/ArchitecturalDrivers.md)` | Drivers: HU-XX (functional), QA-X (quality), CON-X (constraints)   |
| `[ADD.md](design/ADD.md)`                                   | Attribute-Driven Design process applied to the project                  |
| `[design/Architecture.md](design/Architecture.md)`          | Architectural decisions, domain model, package structure |
| `[design/IterationPlan.md](design/IterationPlan.md)`        | ADD iteration plan and drivers assigned to each one                |


## Technologies


| Document                                              | Content                                                          |
| ------------------------------------------------------ | ------------------------------------------------------------------ |
| `[technologies/backend.md](technologies/backend.md)`   | Java 21, Spring Boot 3.x, dependencies, package rules, naming |
| `[technologies/frontend.md](technologies/frontend.md)` | Angular, TypeScript, modules, interceptors, i18n                   |
| `[technologies/testing.md](technologies/testing.md)`   | Testing pyramid, frameworks, naming conventions, CI        |
| `[technologies/devops.md](technologies/devops.md)`     | GitFlow, CI/CD, Docker, environments, secrets                      |


## Implementation (operational)


| Document                                                                                        | Content                                                                           |
| ------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------- |
| `[implementation/implementationPlan.md](implementation/implementationPlan.md)`                   | Phases, dependencies, transition criteria                                        |
| `[implementation/progress.md](implementation/progress.md)`                                       | Dashboard: global status and current phase                                              |
| `[implementation/sessions/](implementation/sessions/README.md)`                                  | Notes per session (one file per member/session)                                 |
| `[implementation/decisions/](implementation/decisions/README.md)`                                | D-xxx decisions (one file per decision)                                          |
| `[implementation/phase0.md](implementation/phase0.md)` … `[phase9.md](implementation/phase9.md)` | Tasks per phase with links to specs (incl. `[phase4a.md](implementation/phase4a.md)`) |


## DDD Domain (machine-readable)


| Document                                              | Content                               |
| ------------------------------------------------------ | --------------------------------------- |
| `[sdd/domain/ContextMap.md](sdd/domain/ContextMap.md)` | Bounded Contexts and relationships           |
| `[sdd/domain/schemas/](sdd/domain/schemas/)`           | JSON Schema contracts per BC            |
| `[sdd/domain/features/](sdd/domain/features/)`         | Gherkin scenarios per BC               |
| `[sdd/domain/Summary.md](sdd/domain/Summary.md)`       | DDD specification session summary |


> See `[CANONICAL.md](CANONICAL.md)` and `[external-references.md](external-references.md)` for paths and documents outside the repo.

## SDD (Spec-Driven Development)


| Document                                              | Content                                                         |
| ------------------------------------------------------ | ----------------------------------------------------------------- |
| `[sdd/theory/SDD-theory.md](sdd/theory/SDD-theory.md)` | SDD theory and rules for the project                           |
| `[sdd/README.md](sdd/README.md)`                       | Operational guide: how to create and use specs                           |
| `[sdd/SPEC_INDEX.md](sdd/SPEC_INDEX.md)`               | Master spec index                                           |
| `[sdd/templates/README.md](sdd/templates/README.md)`   | Template index (SPEC, PHASE, session, decision, BC, blocker) |


## Tools and Cross-Agent Context

The project uses AI agents (Cursor) to assist with spec writing, implementation, and code review. The following tools maintain continuity across sessions:


| Tool                    | Purpose                                                                                                                                                                                                                                      |
| ------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Engram** (MCP server)        | Persistent memory shared across agents. Stores architectural decisions, conventions, resolved bugs, progress, and next steps. Organized by project: `plan-sdd-arc` (planning/architecture) and `sapcyti` (implementation). |
| **Rules** (`.cursor/rules/`)   | Rules loaded automatically in each session: project conventions (`sapcyti`), memory protocol (`engram`), and atomic task execution (`task_execution`).                                                                      |
| **Skills** (`.cursor/skills/`) | Step-by-step flows for specific tasks: `implement-spec`, `write-spec`, `review-code`.                                                                                                                                                     |


### How does Engram work?

Engram is an MCP (Model Context Protocol) server that provides persistent memory to agents. At the start of each session, the agent retrieves prior context (`mem_context` / `mem_search`). After significant work, it saves information (`mem_save`). On session close, it generates a summary (`mem_session_summary`). This lets future sessions start with knowledge of what was already decided.

### Session summaries


| Document                                      | Content                                                                |
| ---------------------------------------------- | ------------------------------------------------------------------------ |
| `[resumen-propuesta.md](resumen-propuesta.md)` | Summary of decisions, artifacts created, and changes to the documentation framework |


---

## Reading order by role

**New student:** Vision.md → this README → `progress.md` (dashboard) → `[05-trabajo-en-equipo.md](onboarding/05-trabajo-en-equipo.md)` if on a team → assigned spec

**LLM (session start):** `[AGENTS.md](AGENTS.md)` → `progress.md` (dashboard) → spec to implement (self-contained)

**Architect:** `ArchitecturalDrivers.md` → `Architecture.md` → `IterationPlan.md` → `sdd/domain/ContextMap.md` → `implementationPlan.md`