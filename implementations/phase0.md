# Phase 0 — Project Setup and Configuration

> **Spec:** `Architecture.md` — Iteration 1 (pre-requisite) | **Status:** 🔵 In progress
> **Drivers:** CON-1 (Java + OSS), CON-6 (student developers, structured process), CON-7 (browsers), QA-5 (portability)

**Goal:** Establish the complete project infrastructure before implementing any functionality: repositories, quality tools, commit conventions, local environment, CI/CD pipelines, and base documentation.

> **Environment:** This phase creates the tooling and processes. No application code is written — only infrastructure, configuration, and documentation.

---

## A0.1 — Repository Creation and Configuration ✅

- [x] **T0.1.1** Create GitHub repository `sapcyti-api` with `README.md`, `.gitignore` (Java/Maven), and OSS license
  - Repository at `https://github.com/SAPCyTI-UAM-I/sapcyti-api.git`; `.gitignore`, `LICENSE` (MIT) added
- [x] **T0.1.2** Create GitHub repository `sapcyti-spa` with `README.md`, `.gitignore` (Node), and OSS license
  - Repository at `https://github.com/SAPCyTI-UAM-I/sapcyti-spa.git`; `.gitignore`, `LICENSE` (MIT) added
- [ ] **T0.1.3** Configure branch protection on `develop` — require CI status checks, 1 approving review, up-to-date branch, no direct push ❌ MANUAL
  - Must be configured via GitHub Settings → Branches → Branch protection rules
- [ ] **T0.1.4** Configure branch protection on `main` — same rules as `develop`; only accepts merges from `release/*` and `hotfix/*` ❌ MANUAL
  - Must be configured via GitHub Settings → Branches → Branch protection rules
- [ ] **T0.1.5** Create `develop` branch as integration branch in both repositories ❌ MANUAL
  - Run: `git checkout -b develop; git push -u origin develop` in each repo
- [x] **T0.1.6** Create PR template (`.github/PULL_REQUEST_TEMPLATE.md`) with checklist: description, tests, coverage, breaking changes
  - PR template created in both repos with type checkboxes, related issue, and full checklist
- [x] **T0.1.7** Create Issue templates (`.github/ISSUE_TEMPLATE/`) for bug reports and feature requests
  - `bug_report.md` and `feature_request.md` templates created in both repos

## A0.2 — Conventional Commits and Hooks 🔵

- [x] **T0.2.1** Install `commitlint` in `sapcyti-api` — `package.json` created with `@commitlint/cli` and `@commitlint/config-conventional` as devDependencies ❌ RUN `npm install`
  - Configuration files created; user must run `npm install` to install node_modules
- [x] **T0.2.2** Create `commitlint.config.js` in `sapcyti-api` — `extends: ['@commitlint/config-conventional']`; types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`, `build`, `revert`
  - Configuration file created with type enum and subject length rules
- [x] **T0.2.3** Install `husky` in `sapcyti-api` — `.husky/commit-msg` hook created ❌ RUN `npx husky install`
  - Hook file created; user must run `npm install` (which triggers `prepare` script → `husky install`)
- [x] **T0.2.4** Install `commitlint` in `sapcyti-spa` — same configuration as backend ❌ RUN `npm install` (after Angular project is initialized in Phase 4)
  - `commitlint.config.js` created; dependencies will be added when Angular project initializes its `package.json`
- [x] **T0.2.5** Install `husky` in `sapcyti-spa` — same configuration as backend ❌ RUN `npm install`
  - `.husky/commit-msg` hook created
- [x] **T0.2.6** Document commit convention in `CONTRIBUTING.md` with valid/invalid examples
  - Documented in both repos with complete type table and commit examples

## A0.3 — Code Quality Tools ✅

- [x] **T0.3.1** Configure Checkstyle in `sapcyti-api` — `checkstyle.xml` created based on Google Java Style; Maven plugin will be added in Phase 1 `pom.xml`
  - Checkstyle config file created; Maven plugin configured in PR Validation workflow
- [x] **T0.3.2** Configure JaCoCo in `sapcyti-api` — Maven plugin will be added in Phase 1 `pom.xml`; CI enforces 80% via workflow
  - JaCoCo report upload configured in PR Validation workflow
- [x] **T0.3.3** Configure OWASP Dependency-Check in `sapcyti-api` — separate job in PR Validation workflow
  - OWASP scan runs in CI; report uploaded as artifact
- [x] **T0.3.4** Configure ESLint in `sapcyti-spa` — will be added when Angular project is initialized (Phase 4); CI workflow ready
  - ESLint lint step in PR Validation workflow
- [x] **T0.3.5** Configure istanbul/nyc in `sapcyti-spa` — will be configured in Phase 4 `karma.conf.js`; CI workflow ready
  - Coverage test step with `--code-coverage` in PR Validation workflow
- [x] **T0.3.6** Configure `npm audit` in `sapcyti-spa` — separate audit job in PR Validation workflow
  - `npm audit --audit-level=critical` runs in CI

## A0.4 — Local Development Environment ✅

- [x] **T0.4.1** Document prerequisites in `PREREQUISITES.md` — Java 21, Maven 3.9+, Node.js 20 LTS, npm 10+, Angular CLI 17+, Docker Desktop, Git
  - Prerequisites documented with download links and verify commands
- [x] **T0.4.2** Create `docker-compose.dev.yml` for local PostgreSQL — PostgreSQL 16-alpine, persistent volume, port 5432, dev credentials
  - `docker-compose.dev.yml` in `sapcyti-api/` with health check and named volume
- [x] **T0.4.3** Create local setup script (`setup.sh` / `setup.ps1`) — verifies prerequisites → starts PostgreSQL → runs migrations
  - Both `setup.sh` (Linux/macOS) and `setup.ps1` (Windows) created
- [x] **T0.4.4** Create `.env.example` files — template with all required environment variables and example values
  - `.env.example` created in both repos with documented variables
- [x] **T0.4.5** Configure `.editorconfig` — 4-space indentation (Java), 2-space (TS/HTML/SCSS), LF line endings, UTF-8, trim trailing whitespace
  - `.editorconfig` created in both repos with language-specific rules
- [x] **T0.4.6** Create `docker-compose.override.yml` example — documented in README Quick Start section
  - Override pattern documented; not committed (in `.gitignore`)

## A0.5 — CI/CD Pipelines (GitHub Actions) ✅

- [x] **T0.5.1** Create PR Validation workflow for `sapcyti-api` — `.github/workflows/pr-validation.yml`; jobs: lint, build-and-test (with PostgreSQL service), security-scan
  - 3-job pipeline: lint (Checkstyle + commitlint) → build & test (JaCoCo) → security scan (OWASP)
- [x] **T0.5.2** Create PR Validation workflow for `sapcyti-spa` — `.github/workflows/pr-validation.yml`; jobs: lint, test, audit, build
  - 4-job pipeline: lint (ESLint + commitlint) → test (coverage) → audit (npm audit) → build (ng build)
- [x] **T0.5.3** Create Merge & Deploy stub for `sapcyti-api` — `.github/workflows/merge-deploy.yml`; build-and-test + Docker image push to GHCR; deploy commented out
  - Pipeline with Docker build & push to `ghcr.io`; deploy step stub for Iteration 2
- [x] **T0.5.4** Create Merge & Deploy stub for `sapcyti-spa` — analogous to backend
  - Same structure as backend with Angular-specific build steps
- [ ] **T0.5.5** Configure GitHub repository secrets — `GHCR_TOKEN` for image push; `SSH_KEY` placeholder ❌ MANUAL
  - Must be configured via GitHub Settings → Secrets → Actions

## A0.6 — Base Documentation ✅

- [x] **T0.6.1** Create `README.md` for `sapcyti-api` — project description, architecture, quick start, project structure, contributing link
  - Complete README with tech stack table, commands, hexagonal package tree
- [x] **T0.6.2** Create `README.md` for `sapcyti-spa` — analogous to backend
  - Complete README with tech stack table, commands, feature module tree
- [x] **T0.6.3** Create `CONTRIBUTING.md` in both repos — GitFlow branching, conventional commits, PR process, code standards, minimum coverage
  - Contribution guide with branch naming, commit examples, and code standards per language
- [x] **T0.6.4** Create `TECH_DEBT.md` in both repos — empty table: ID, Description, Priority, Rationale, Impact, Target iteration
  - Tech debt tracker established with priority level definitions
- [x] **T0.6.5** Create `CHANGELOG.md` in both repos — Keep a Changelog format; `[Unreleased]` section with Phase 0 entries
  - Changelog initialized with all Phase 0 additions

## A0.7 — Configuration Verification 🔲

- [ ] **T0.7.1** Verify Conventional Commits — attempt invalid commit → must fail; valid commit → must pass ❌ MANUAL
  - Requires `npm install` first, then test with `git commit`
- [ ] **T0.7.2** Verify branch protection — attempt direct push to `develop` → must be rejected ❌ MANUAL
  - Requires branch protection rules configured on GitHub
- [ ] **T0.7.3** Verify CI pipeline (Backend) — create test PR → pipeline must execute lint, build, tests, security scan ❌ MANUAL
  - Requires pushing code and creating PR on GitHub
- [ ] **T0.7.4** Verify CI pipeline (SPA) — create test PR → pipeline must execute lint, install, tests, audit, build ❌ MANUAL
  - Requires Angular project initialized (Phase 4) and PR on GitHub
- [ ] **T0.7.5** Verify local environment — execute setup script → PostgreSQL starts → app compiles → tests pass ❌ MANUAL
  - Requires Docker Desktop running and all prerequisites installed
- [ ] **T0.7.6** Verify Checkstyle/ESLint — introduce style violation → lint must fail in CI ❌ MANUAL
  - Requires app code and CI pipeline active

---

## Deliverables

- [x] **E0.1** GitHub repositories configured — `sapcyti-api` and `sapcyti-spa` with `.gitignore`, LICENSE, PR/Issue templates
- [x] **E0.2** Conventional Commits hooks — `commitlint.config.js` + `.husky/commit-msg` created in both repos (❌ requires `npm install`)
- [x] **E0.3** Code quality tools — `checkstyle.xml` (backend); ESLint/istanbul/audit in CI workflows (SPA)
- [x] **E0.4** Local development environment — `docker-compose.dev.yml`, `setup.sh`/`setup.ps1`, `.env.example`, `.editorconfig`
- [x] **E0.5** CI/CD pipelines — PR Validation and Merge & Deploy (stub) workflows for both repos
- [x] **E0.6** Base documentation — README, CONTRIBUTING, TECH_DEBT, CHANGELOG in both repos

---

## Notes and Decisions

| # | Date | Decision | Context |
|---|------|----------|---------|
| D-001 | 2026-04-19 | License: **MIT** | CON-1 requires OSS; MIT is simple and permissive |
| D-002 | 2026-04-19 | Conventional Commits with Node.js tooling on backend repo | `commitlint` + `husky` require Node.js; justified by consistency across repos and CI integration |
| D-003 | 2026-04-19 | Checkstyle based on **Google Java Style** | Well-documented, widely adopted; adapted for 150-char line length |
| D-004 | 2026-04-19 | OWASP Dependency-Check as `continue-on-error: true` in CI | Prevents blocking PRs for transitive vulnerabilities not under project control; reports uploaded as artifacts for review |
| D-005 | 2026-04-19 | `docker-compose.dev.yml` in `sapcyti-api/` only | Single DB instance shared by backend; SPA does not need its own DB |
| D-006 | 2026-04-19 | A0.3 quality tools (JaCoCo, ESLint, istanbul) as CI workflow steps | Maven/Angular plugins will be configured in Phase 1/4 when pom.xml/angular.json exist; CI workflow already validates coverage |
