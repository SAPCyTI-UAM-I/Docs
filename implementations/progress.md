# Project Memory — SAPCyTI

> This file is the **central project memory**. It records phase status, decisions, blockers, and open items. Update after each work session.

---

## General Status

| Phase | Status | Progress | Last Updated |
|-------|--------|----------|--------------|
| 0 — Project setup | 🔵 In progress | 34/40 tasks (6 manual) | 2026-04-19 |
| 1 — Backend init | 🔲 Not started | 0/10 tasks | — |
| 2 — Domain model | 🔲 Not started | 0/10 tasks | — |
| 3 — REST API | 🔲 Not started | 0/12 tasks | — |
| 4 — SPA init | 🔲 Not started | 0/16 tasks | — |
| 5 — Integration | 🔲 Not started | 0/17 tasks | — |

**Legend:** 🔲 Not started | 🔵 In progress | ✅ Completed | ⛔ Blocked

---

## Current Phase

**Phase:** 0 — Project setup and configuration 🔵 IN PROGRESS  
**Next phase:** 1 — Backend project initialization  
**Next step:** Complete manual tasks (❌) from Phase 0, then begin [`phase1.md`](phase1.md) — A1.1

### Pending Manual Tasks (Phase 0)

| Task | Action Required |
|------|-----------------|
| ❌ T0.1.3 | Configure branch protection on `develop` in both repos (GitHub Settings → Branches) |
| ❌ T0.1.4 | Configure branch protection on `main` in both repos (GitHub Settings → Branches) |
| ❌ T0.1.5 | Create `develop` branch: `git checkout -b develop; git push -u origin develop` in each repo |
| ❌ T0.2.1/T0.2.3 | Run `npm install` in `sapcyti-api/` to install commitlint + husky |
| ❌ T0.2.4/T0.2.5 | Run `npm install` in `sapcyti-spa/` (after Angular project init in Phase 4) |
| ❌ T0.5.5 | Configure GitHub secrets: `GHCR_TOKEN` (GitHub Settings → Secrets → Actions) |
| ❌ T0.7.1–T0.7.6 | All verification tasks (require prerequisites installed + code pushed to GitHub) |

---

## Decision Log

| # | Date | Decision | Context | Discarded Alternatives |
|---|------|----------|---------|------------------------|
| D-001 | 2026-04-19 | License: MIT | CON-1 requires OSS; MIT is simple and permissive | Apache 2.0, GPL |
| D-002 | 2026-04-19 | Conventional Commits with Node.js tooling on backend repo | commitlint + husky require Node.js; justified by consistency across repos | Manual commit validation, server-side hooks |
| D-003 | 2026-04-19 | Checkstyle based on Google Java Style (150-char line length) | Well-documented, widely adopted | SonarQube (too heavy for Phase 0), PMD |
| D-004 | 2026-04-19 | OWASP Dependency-Check as `continue-on-error: true` | Prevents blocking PRs for transitive vulnerabilities not under project control | Strict fail (blocks all PRs with any CVE) |
| D-005 | 2026-04-19 | `docker-compose.dev.yml` in `sapcyti-api/` only | Single DB instance shared by backend; SPA does not need its own DB | DB in root directory, separate repo |
| D-006 | 2026-04-19 | Quality tool plugins (JaCoCo, ESLint, istanbul) as CI steps | Maven/Angular plugins configured in Phase 1/4 when pom.xml/angular.json exist | Configure plugins before project exists |

---

## Blockers and Issues

| # | Date | Description | Status | Resolution |
|---|------|-------------|--------|------------|
| B-001 | 2026-04-19 | `npm` not available in current environment | ⚠️ Tracked | Configuration files created manually; user must run `npm install` on local machine |

---

## Lessons Learned

| # | Phase | Lesson |
|---|-------|--------|
| L-001 | 0 | Create all configuration files before running install commands — allows reviewing the complete setup before execution |
| L-002 | 0 | PowerShell on Windows uses `;` not `&&` for command chaining |

---

## Session Notes

### Session — 2026-04-19 (Planning)

- Created implementation plan with 6 phases (0–5) for Iteration 1
- Structured all documents following project template conventions
- Phase dependencies defined: P0 → P1 → P2 → P3 → P5; P0 → P4 → P5
- Technology stack confirmed: Spring Boot 3.x (Java 21) + Angular 17+ + PostgreSQL
- Deployment strategy: local Docker first, on-premise server after Iteration 2

### Session — 2026-04-19 (Phase 0 Implementation)

- **Completed A0.1** (5/7 tasks): Repository configuration
  - `.gitignore` (Java/Maven for API, Node for SPA), `LICENSE` (MIT), PR template, Issue templates (bug + feature) in both repos
  - Branch protection (T0.1.3, T0.1.4) and `develop` branch (T0.1.5) require manual GitHub configuration
- **Completed A0.2** (6/6 tasks — files created): Conventional Commits
  - `package.json` with commitlint + husky devDependencies, `commitlint.config.js`, `.husky/commit-msg` in both repos
  - User must run `npm install` to activate hooks
- **Completed A0.3** (6/6 tasks): Code quality tools
  - `checkstyle.xml` (Google Java Style adapted) for backend
  - ESLint, istanbul, npm audit configured in CI workflows
  - JaCoCo and OWASP configured in CI workflows with report artifacts
- **Completed A0.4** (6/6 tasks): Local development environment
  - `PREREQUISITES.md` with required tools and versions
  - `docker-compose.dev.yml` (PostgreSQL 16, persistent volume, health check)
  - `setup.sh` + `setup.ps1` (prerequisite check → PostgreSQL → npm install → build)
  - `.env.example` in both repos, `.editorconfig` (4sp Java, 2sp TS/HTML/SCSS)
- **Completed A0.5** (4/5 tasks): CI/CD pipelines
  - PR Validation: Backend (3 jobs: lint/build-test/security), SPA (4 jobs: lint/test/audit/build)
  - Merge & Deploy: Both repos (build-test → Docker GHCR push → deploy stub)
  - GitHub secrets (T0.5.5) require manual configuration
- **Completed A0.6** (5/5 tasks): Base documentation
  - README.md (both repos): architecture, tech stack, quick start, project structure
  - CONTRIBUTING.md (both repos): GitFlow, Conventional Commits, PR process, code standards
  - TECH_DEBT.md, CHANGELOG.md in both repos
- **Pending A0.7** (0/6 tasks): All verification tasks require manual execution
- Decisions D-001 through D-006 recorded
- Next: Complete manual tasks (branch protection, npm install, develop branch), then Phase 1

---

## Future Iterations (Not Planned Yet)

The following iterations will be planned after Iteration 1 is complete:

| Iteration | Goal | Drivers |
|-----------|------|---------|
| **2** | DevOps and deployment infrastructure | QA-5, CON-2, CON-6 |
| **3** | Security cross-cutting concerns | QA-1, QA-2, HU-01 |
| **4** | Entity management and credentials | HU-15, HU-21, QA-6, HU-02, HU-28 |
| **4.1** | Bounded Context Map refinement | QA-3, QA-4, QA-5, CON-6 |
| **5** | Enrollment workflow | HU-06, HU-07, HU-08, HU-09, CON-3 |

---

## Quick Reference

- **General plan:** [`implementationPlan.md`](implementationPlan.md)
- **Architecture spec:** [`Architecture.md`](../Design/Architecture.md) (all iterations)
- **Iteration plan:** [`IterationPlan.md`](../Design/IterationPlan.md)
- **Phase guides:** [`phase0.md`](phase0.md) … [`phase5.md`](phase5.md)
