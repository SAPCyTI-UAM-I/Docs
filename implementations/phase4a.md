# Phase 4A — SPA Project Scaffold & Tooling

> **ADD Iteration:** 1
> **Drivers:** CON-7 (browsers, responsive), CON-6 (predictable structure)
> **Status:** 🔲 Not started

**Goal:** Create the Angular project with all dependencies installed, tooling configured, and folder structure ready. The developer executes CLI commands manually and configures tooling files. At the end of this phase, `ng serve` starts without errors and `npm run lint` passes.

> **Environment:** `ng serve` on `localhost:4200` — no backend required.
> **Ref:** [`technologies/frontend.md`](../SDD/technologies/frontend.md) — Angular stack, dependencies, and tooling rules

### User Stories (HU)

> **No user stories apply directly to this phase.** Phase 4A is pure project scaffolding and tooling configuration. It creates the Angular project foundation that Phase 4 (Core Architecture) and all subsequent frontend phases build upon.

---

## A4A.1 — Angular Project Creation (Manual) 🔲

> Specs: [SPEC-008A](../SDD/specs/iteration-1/SPEC-008A_angular-project-scaffold-tooling.md)

- [ ] **T4A.1.1** Execute `ng new sapcyti-spa` with Angular CLI — TypeScript strict mode, routing enabled, CSS (no SCSS) → SPEC-008A
- [ ] **T4A.1.2** Verify `ng serve` starts without errors on `http://localhost:4200` → SPEC-008A

## A4A.2 — Dependency Installation (Manual) 🔲

> Specs: SPEC-008A

- [ ] **T4A.2.1** Install Tailwind CSS — `npm install -D tailwindcss @tailwindcss/postcss postcss` + configure `postcss.config.js` + add directives in `styles.css` → SPEC-008A
- [ ] **T4A.2.2** Install PrimeNG — `npm install primeng` + configure unstyled mode in `app.config.ts` → SPEC-008A
- [ ] **T4A.2.3** Install ngx-translate — `npm install @ngx-translate/core @ngx-translate/http-loader` → SPEC-008A
- [ ] **T4A.2.4** Verify `ng build --configuration production` compiles without errors after installing dependencies → SPEC-008A

## A4A.3 — Tooling Configuration 🔲

> Specs: SPEC-008A

- [ ] **T4A.3.1** Configure ESLint + `@angular-eslint` — `ng add @angular-eslint/schematics` + rules per [`frontend.md`](../SDD/technologies/frontend.md) → SPEC-008A
- [ ] **T4A.3.2** Configure Prettier — `npm install -D prettier prettier-plugin-tailwindcss` + create `.prettierrc` and `.prettierignore` → SPEC-008A
- [ ] **T4A.3.3** Configure Vitest — `npm install -D vitest @analogjs/vitest-angular` + create `vite.config.ts` (replaces Jasmine/Karma) → SPEC-008A
- [ ] **T4A.3.4** Verify tooling: `npm run lint` passes + `npm run test` executes Vitest → SPEC-008A

## A4A.4 — Folder Structure & Environments 🔲

> Specs: SPEC-008A

- [ ] **T4A.4.1** Create folder structure: `src/app/core/`, `src/app/shared/`, `src/app/features/`, `src/app/models/`, `src/assets/i18n/` → SPEC-008A
- [ ] **T4A.4.2** Create `src/environments/environment.ts` and `environment.prod.ts` — variable `apiBaseUrl` pointing to `http://localhost:8080/api` → SPEC-008A
- [ ] **T4A.4.3** Create `.editorconfig` — 2 spaces for TS/HTML/CSS, UTF-8 → SPEC-008A

---

## Deliverables

- [ ] **E4A.1** Angular project starts with `ng serve` without errors — Spec: SPEC-008A
- [ ] **E4A.2** `ng build --configuration production` compiles successfully — Spec: SPEC-008A
- [ ] **E4A.3** `npm run lint` passes without errors (ESLint + Prettier) — Spec: SPEC-008A
- [ ] **E4A.4** `npm run test` executes Vitest correctly — Spec: SPEC-008A
- [ ] **E4A.5** Folder structure matches [`frontend.md §Folder Structure`](../SDD/technologies/frontend.md) — Spec: SPEC-008A

---

## Transition Criteria

- [ ] `ng serve` starts on `localhost:4200`
- [ ] `ng build --configuration production` succeeds
- [ ] `npm run lint` passes without errors
- [ ] `npm run test` executes with Vitest (0 tests is acceptable — no logic yet)
- [ ] Tailwind CSS works (utility class applies on a test component)
- [ ] PrimeNG importable and in unstyled mode
- [ ] Folders `core/`, `shared/`, `features/`, `models/`, `assets/i18n/` exist
- [ ] All linked specs are ✅ Implemented

---

## Risks

| # | Risk | Impact | Probability | Mitigation |
|---|------|--------|-------------|------------|
| R-4A.1 | Angular CLI version incompatible with Node.js 22 | Medio | Baja | `frontend.md` pins Angular 21 + Node 22.12.0 |
| R-4A.2 | Vitest + Angular integration issues | Medio | Media | `@analogjs/vitest-angular` is the officially recommended package |
| R-4A.3 | PrimeNG unstyled mode requires additional configuration with Tailwind | Bajo | Media | Document exact preset configuration in spec |

---

## Notes and Decisions

> Las decisiones se registran en [`progress.md`](progress.md) Decision Log.

| # | Decision ID | Summary |
|---|-------------|---------|
| — | — | — |
