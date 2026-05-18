# Phase 4 — SPA Core Architecture & Shell

> **ADD Iteration:** 1
> **Drivers:** CON-7 (browsers, responsive), CON-6 (predictable structure), QA-4 (tenant context), QA-6 (i18n)
> **Status:** 🔲 Not started

**Goal:** Implement the core providers (services, interceptors, guards as minimum functional shells), the Shell/Layout, the i18n infrastructure, and base shared components. At the end of this phase, the SPA has a navigable structure with Shell, language switching, and authentication shells ready to be completed in Phase 6.

> **Environment:** `ng serve` against backend API on `localhost:8080`.
> **Ref:** [`Architecture.md §6.2`](../Design/Architecture.md) — SPA component diagram
> **Ref:** [`technologies/frontend.md`](../SDD/technologies/frontend.md) — Angular stack and conventions

### User Stories (HU)

> **No user stories apply directly to this phase.** Phase 4 is SPA architectural scaffolding. It creates the foundation (core providers, Shell, i18n, tenant interceptor) that all feature implementations will use. HU-01 (login view), HU-15/HU-21 (entity forms), HU-07 (course selection view) are implemented in later phases on top of this scaffold.

### Stub Approach

> Core auth components (`AuthStateService`, `AuthGuard`, `JwtInterceptor`, `HttpErrorInterceptor`) are created as **minimum functional shells**: correct signatures and complete structure, with stub logic that allows the app to compile and navigate. Real implementation is completed in Phase 6 (Security). Each stub is marked with `// TODO: Phase 6 — implement real logic`.
>
> `TenantInterceptor` and `TenantService` are **fully implemented** in this phase — they do not depend on authentication.

---

## A4.1 — Application Bootstrap & Provider Registration 🔲

> Specs: [SPEC-008B](../SDD/specs/iteration-1/SPEC-008B_spa-core-providers-shell-i18n.md)

- [ ] **T4.1.1** Configure `app.config.ts` — register `provideHttpClient(withInterceptors([...]))`, `provideRouter(routes)`, `provideTranslateService()`, PrimeNG providers → SPEC-008B
- [ ] **T4.1.2** Configure `app.routes.ts` — base routes with lazy loading placeholder for features (`auth/`, `dashboard/`, `enrollment/`, `academic-catalog/`) → SPEC-008B

## A4.2 — Core Services & Interceptors (Minimum Shell) 🔲

> Specs: SPEC-008B

- [ ] **T4.2.1** Create `core/auth/auth.service.ts` — `AuthStateService` with `currentUser$: BehaviorSubject<null>`, methods `isAuthenticated()` → `false`, `hasRole()` → `false`, `login()`/`logout()` as no-op → SPEC-008B
- [ ] **T4.2.2** Create `core/auth/auth.guard.ts` — `CanActivateFn` that always returns `true` (allows navigation without auth) → SPEC-008B
- [ ] **T4.2.3** Create `core/auth/jwt.interceptor.ts` — `HttpInterceptorFn` that passes request without modification + injects `Accept-Language` header with current locale → SPEC-008B
- [ ] **T4.2.4** Create `core/http/tenant.interceptor.ts` — `HttpInterceptorFn` that attaches `X-Graduate-Id` header from `TenantService` (**full implementation**, not dependent on auth) → SPEC-008B
- [ ] **T4.2.5** Create `core/http/http-error.interceptor.ts` — `HttpInterceptorFn` with basic error handling: `console.error` + error propagation (no refresh token logic yet) → SPEC-008B
- [ ] **T4.2.6** Create `core/http/tenant.service.ts` — `TenantService` with `graduateProgramId$: BehaviorSubject<number | null>`, methods `set(id)`, `get()`, `clear()` → SPEC-008B

## A4.3 — Shell Layout & Navigation 🔲

> Specs: SPEC-008B

- [ ] **T4.3.1** Create `app/shell/` — `ShellComponent` standalone with top bar, sidebar placeholder, `<router-outlet>`, and Language Switcher slot → SPEC-008B
- [ ] **T4.3.2** Create `app/shell/` — navigation menu with placeholder items (visible for smoke test, no role filtering yet) → SPEC-008B

## A4.4 — Internationalization Infrastructure 🔲

> Specs: SPEC-008B

- [ ] **T4.4.1** Configure `@ngx-translate` — `provideTranslateService` with `HttpTranslateLoader`, default language `es`, key format `{MODULE}.{COMPONENT}.{KEY}` → SPEC-008B
- [ ] **T4.4.2** Create translation files `assets/i18n/es.json` and `assets/i18n/en.json` — base keys for Shell (`SHELL.MENU.*`, `SHELL.TOPBAR.*`, `COMMON.ERRORS.*`) → SPEC-008B
- [ ] **T4.4.3** Create `shared/components/language-switcher/` — standalone component that toggles between `es`/`en`, persists selection in `localStorage`, emits change to `TranslateService` → SPEC-008B

## A4.5 — Shared Components & Models 🔲

> Specs: SPEC-008B

- [ ] **T4.5.1** Create `shared/components/access-denied/` — 403 "Access Denied" standalone component with i18n → SPEC-008B
- [ ] **T4.5.2** Create `models/api-error.model.ts` — interface `ApiError { error: string; message: string; }` (mirrors backend `GlobalExceptionHandler`) → SPEC-008B
- [ ] **T4.5.3** Create `models/page-response.model.ts` — interface `PageResponse<T>` for paginated backend responses → SPEC-008B

---

## Deliverables

- [ ] **E4.1** `app.config.ts` registers all providers (HTTP, Router, i18n, interceptors) — Spec: SPEC-008B
- [ ] **E4.2** Shell renders with top bar, sidebar placeholder, and Language Switcher — Spec: SPEC-008B
- [ ] **E4.3** Language Switcher toggles correctly between Spanish and English — Spec: SPEC-008B
- [ ] **E4.4** `TenantInterceptor` attaches `X-Graduate-Id` header in HTTP requests (verifiable in DevTools → Network) — Spec: SPEC-008B
- [ ] **E4.5** 403 page renders with internationalized text — Spec: SPEC-008B
- [ ] **E4.6** Lazy loading routes configured (even though features are empty) — Spec: SPEC-008B

---

## Transition Criteria

- [ ] `ng build --configuration production` succeeds
- [ ] `npm run test` (Vitest) passes — unit tests for `TenantInterceptor`, `TenantService`, `LanguageSwitcherComponent`
- [ ] `npm run lint` passes
- [ ] Translation keys resolve correctly for both `es` and `en` locales
- [ ] `TenantInterceptor` attaches `X-Graduate-Id` in HTTP requests
- [ ] Shell navigates between placeholder routes without errors
- [ ] AuthGuard allows navigation (stub — always `true`)
- [ ] All linked specs are ✅ Implemented
- [ ] No regressions from Phase 4A

---

## Risks

| # | Risk | Impact | Probability | Mitigation |
|---|------|--------|-------------|------------|
| R-4.1 | `@ngx-translate` breaking changes with Angular 21 | Medio | Baja | Pin `@ngx-translate/core` compatible version in `package.json` |
| R-4.2 | CORS issues between SPA and backend | Bajo | Media | Backend `WebConfig` already allows `localhost:4200` |
| R-4.3 | Auth stubs cause confusion when implementing Phase 6 | Bajo | Media | Mark with `// TODO: Phase 6 — implement real logic` and document in spec |

---

## Notes and Decisions

> Las decisiones se registran en [`progress.md`](progress.md) Decision Log.

| # | Decision ID | Summary |
|---|-------------|---------|
| — | — | — |
