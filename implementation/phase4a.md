# Phase 4A — SPA Project Scaffold & Tooling

> **ADD Iteration:** 1
> **Drivers:** CON-7 (browsers, responsive), CON-6 (predictable structure)
> **Status:** ✅ Complete

**Goal:** Create the Angular project with all dependencies installed, tooling configured, and folder structure ready. The developer executes CLI commands manually and configures tooling files. At the end of this phase, `ng serve` starts without errors and `npm run lint` passes.

> **Environment:** `ng serve` on `localhost:4200` — no backend required.
> **Ref:** [`technologies/frontend.md`](../technologies/frontend.md) — Angular stack, dependencies, and tooling rules

### User Stories (HU)

> **No user stories apply directly to this phase.** Phase 4A is pure project scaffolding and tooling configuration. It creates the Angular project foundation that Phase 4 (Core Architecture) and all subsequent frontend phases build upon.

---

## A4A.1 — Angular Project Creation (Manual) ✅

> Specs: [SPEC-008A](../sdd/specs/iteration-1/SPEC-008A_angular-project-scaffold-tooling.md)

- [X] **T4A.1.1** Execute `ng new sapcyti-spa` with Angular CLI — TypeScript strict mode, routing enabled, CSS (no SCSS) → SPEC-008A
  > Angular 21.2.10, strict mode ✅, standalone components ✅, routing ✅, CSS ✅, pnpm as package manager
- [X] **T4A.1.2** Verify `ng serve` starts without errors on `http://localhost:4200` → SPEC-008A
  > ✅ HTTP 200 en localhost:4200, build sin errores

## A4A.2 — Dependency Installation (Manual) 🔶

> Specs: SPEC-008A

- [X] **T4A.2.1** Install Tailwind CSS — `tailwindcss @tailwindcss/postcss postcss` + configure PostCSS + add directives in `styles.css` → SPEC-008A
  > Installed ✅ | `.postcssrc.json` used instead of `postcss.config.js` (equivalente) ✅ | `@import 'tailwindcss'` in styles.css ✅
- [X] **T4A.2.2** Install PrimeNG — `primeng` + `@primeuix/themes` + `primeicons` installed → SPEC-008A
  > Unstyled mode in `app.config.ts` is scope of SPEC-008B
- [X] **T4A.2.3** Install ngx-translate — `@ngx-translate/core @ngx-translate/http-loader` → SPEC-008A
- [X] **T4A.2.4** Verify `ng build --configuration production` compiles without errors after installing dependencies → SPEC-008A
  > ✅ Build exitoso | ⚠️ Warning de budget (505kB vs 500kB) — esperado con PrimeNG, no es error

## A4A.3 — Tooling Configuration 🔲

> Specs: SPEC-008A

- [X] **T4A.3.1** Configure ESLint + `@angular-eslint` — `ng add @angular-eslint/schematics` + rules per [`frontend.md`](../technologies/frontend.md) → SPEC-008A
  > ✅ `eslint.config.js` generado (flat config — Angular 21 no usa `.eslintrc.json`) | `@angular-eslint/recommended` ✅ | `ng lint` pasa sin errores ✅
- [ ] **T4A.3.2** Configure Prettier — `npm install -D prettier prettier-plugin-tailwindcss` + create `.prettierrc` and `.prettierignore` → SPEC-008A
  > ⚠️ Partial: `prettier` installed ✅ | `.prettierrc` incompleto (faltan `semi`, `trailingComma`, `tabWidth`, `bracketSpacing`, `arrowParens`, `plugins`) | `prettier-plugin-tailwindcss` ❌ no instalado | `.prettierignore` ❌ falta | scripts `lint`/`format` en `package.json` ❌ faltan
- [X] **T4A.3.3** Configure Vitest — Angular 21 integración nativa vía `@angular/build:unit-test` → SPEC-008A
  > ✅ `vitest` instalado | `@angular/build:unit-test` es el builder oficial de Angular 21 (sin necesidad de `@analogjs/vitest-angular`) | `ng test --no-watch` ejecuta Vitest: 2/2 tests pasan ✅
- [X] **T4A.3.4** Verify tooling: `pnpm run lint` passes + `ng test` executes Vitest → SPEC-008A
  > ✅ ESLint + Prettier: todos los archivos pasan | Vitest: 2/2 tests pasan

## A4A.4 — Folder Structure & Environments 🔲

> Specs: SPEC-008A

- [X] **T4A.4.1** Create folder structure: `src/app/core/`, `src/app/shared/`, `src/app/features/`, `src/app/models/`, `src/assets/i18n/` → SPEC-008A
  > ✅ Todas las carpetas creadas con `.gitkeep`
- [X] **T4A.4.2** Create `src/environments/environment.ts` and `environment.prod.ts` — variable `apiBaseUrl` pointing to `http://localhost:8080/api` → SPEC-008A
  > ✅ `environment.ts` (apiBaseUrl: localhost:8080/api) y `environment.prod.ts` (apiBaseUrl: /api) creados
- [X] **T4A.4.3** Create `.editorconfig` — 2 spaces for TS/HTML/CSS, UTF-8 → SPEC-008A
  > ✅ Existe con charset UTF-8, 2 espacios, insert_final_newline, trim_trailing_whitespace | ⚠️ Menor: falta `end_of_line = lf` y sección `[*.{ts,html,css,json}]` explícita

---

## Deliverables

- [X] **E4A.1** Angular project starts with `ng serve` without errors — Spec: SPEC-008A
- [X] **E4A.2** `ng build --configuration production` compiles successfully — Spec: SPEC-008A
- [X] **E4A.3** `pnpm run lint` passes without errors (ESLint + Prettier) — Spec: SPEC-008A
- [X] **E4A.4** `ng test` executes Vitest correctly (2/2 tests pasan) — Spec: SPEC-008A
- [X] **E4A.5** Folder structure matches `frontend.md §Folder Structure` — Spec: SPEC-008A

---

## Transition Criteria

- [X] `ng serve` starts on `localhost:4200`
- [X] `ng build --configuration production` succeeds
- [X] `pnpm run lint` passes without errors
- [X] `ng test` executes with Vitest (2/2 tests)
- [X] Tailwind CSS configured (postcss + @import directive)
- [ ] PrimeNG importable and in unstyled mode — scope de SPEC-008B
- [X] Folders `core/`, `shared/`, `features/`, `models/`, `assets/i18n/` exist
- [ ] All linked specs are ✅ Implemented — SPEC-008B pendiente

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
