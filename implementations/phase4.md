# Phase 4 — SPA Project Initialization

> **ADD Iteration:** 1
> **Drivers:** CON-7 (browsers, responsive), CON-6 (predictable structure), QA-4 (tenant context), QA-6 (i18n)
> **Status:** 🔲 Not started

**Goal:** Create the Angular SPA project with Core module (auth, tenant, i18n), Shared module, Shell layout, and responsive structure ready for feature modules.

> **Environment:** `ng serve` against backend API on `localhost:8080`.
> **Ref:** [`Architecture.md §6.2`](../Design/Architecture.md) — SPA component diagram
> **Ref:** [`technologies/frontend.md`](../SDD/technologies/frontend.md) — Angular stack and conventions

### User Stories (HU)

> **No user stories apply directly to this phase.** Phase 4 is SPA infrastructure scaffolding. It creates the foundation (Core module, Shell, i18n, tenant interceptor) that all feature modules will use. HU-01 (login view), HU-15/HU-21 (entity forms), HU-07 (course selection view) are implemented in later phases on top of this scaffold.

---

## A4.1 — Angular Project Creation 🔲

> Specs: SPEC-008 (TBD — Angular project scaffold and Core module)

- [ ] **T4.1.1** Create Angular project with Angular CLI — TypeScript strict mode, CSS, routing enabled → SPEC-008
- [ ] **T4.1.2** Configure ESLint + `@angular-eslint` — code quality rules per `technologies/frontend.md` → SPEC-008
- [ ] **T4.1.3** Create `CoreModule` — singleton services: `AuthService`, `TenantService`, `HttpErrorInterceptor` → SPEC-008
- [ ] **T4.1.4** Create `SharedModule` — reusable UI components, pipes, language switcher → SPEC-008

## A4.2 — Shell, Routing & i18n 🔲

> Specs: SPEC-008

- [ ] **T4.2.1** Create Shell/Layout component — main routing, role-based menu rendering placeholder → SPEC-008
- [ ] **T4.2.2** Configure `@ngx-translate` — `TranslateModule` in Core, translation files `assets/i18n/es.json`, `assets/i18n/en.json`, key format `{MODULE}.{COMPONENT}.{KEY}` → SPEC-008
- [ ] **T4.2.3** Create `TenantInterceptor` — attaches `X-Graduate-Id` header from `TenantService` → SPEC-008
- [ ] **T4.2.4** Create `environments/environment.ts` and `environment.prod.ts` — API base URL config → SPEC-008

---

## Deliverables

- [ ] **E4.1** Angular project builds with `ng build --configuration production` — Specs: SPEC-008
- [ ] **E4.2** Core module provides auth, tenant, and i18n infrastructure — Specs: SPEC-008
- [ ] **E4.3** Shell renders with language switcher (es/en toggle) — Specs: SPEC-008
- [ ] **E4.4** ESLint passes with no errors — Specs: SPEC-008

---

## Transition Criteria

- [ ] `ng build --configuration production` succeeds
- [ ] `ng test --watch=false --code-coverage` passes with ≥80% coverage
- [ ] `npm run lint` passes
- [ ] Translation keys resolve correctly for both `es` and `en` locales
- [ ] `TenantInterceptor` attaches `X-Graduate-Id` header in HTTP requests
- [ ] All linked specs are ✅ Implemented
- [ ] No regressions from Phase 3

---

## Risks

| # | Risk | Impact | Probability | Mitigation |
|---|------|--------|-------------|------------|
| R-4.1 | Angular version breaking changes with `@ngx-translate` | Medio | Baja | Pin `@ngx-translate/core` compatible with Angular |
| R-4.2 | CORS issues between SPA and backend | Bajo | Media | Backend `WebConfig` already allows `localhost:4200` |

---

## Notes and Decisions

> Las decisiones se registran en [`progress.md`](progress.md) Decision Log.

| # | Decision ID | Summary |
|---|-------------|---------|
| — | — | — |
