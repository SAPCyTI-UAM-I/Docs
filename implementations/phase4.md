# Phase 4 — SPA Project Initialization (Angular)

> **Spec:** `Architecture.md` — Iteration 1, §5, §6.2 (SPA components) | **Status:** 🔲 Not started
> **Drivers:** CON-7 (Chrome 130, Safari 22, Firefox 129, responsive), CON-6 (predictable structure), QA-4 (multi-tenant)

**Goal:** Create the Angular project with Core module (tenant context, HTTP interceptors), Shared module (reusable components), Shell layout (navigation, program selector), and a functional dashboard placeholder.

> **Environment:** SPA runs locally via `ng serve` at `localhost:4200`, proxying API calls to backend at `localhost:8080`.

---

## A4.1 — Angular Project Creation 🔲

- [ ] **T4.1.1** Generate project with Angular CLI — `ng new sapcyti-spa --routing --style=scss`; Angular 17+; strict TypeScript mode
  - Project compiles with `ng build`; no errors
- [ ] **T4.1.2** Configure ESLint — `ng add @angular-eslint/schematics`; Angular + TypeScript recommended rules
  - `ng lint` runs without configuration errors
- [ ] **T4.1.3** Configure Karma + istanbul — coverage threshold 80% in `karma.conf.js`; HTML reports
  - `ng test --code-coverage` generates report; build fails below threshold
- [ ] **T4.1.4** Configure environments — `environment.ts` with `apiUrl: 'http://localhost:8080'`; `environment.prod.ts` with production URL placeholder
  - API URL configurable per build target

## A4.2 — Core Module 🔲

- [ ] **T4.2.1** Create `CoreModule` — singleton module with `providedIn: 'root'` services; guard against multiple imports
  - Core services instantiated exactly once
- [ ] **T4.2.2** Create `TenantContextService` — manages active `graduateProgramId`; observable `currentProgram$`; persists to `localStorage`
  - Tenant context accessible reactively across all components
- [ ] **T4.2.3** Create `HttpClientService` — base `HttpClient` configuration; timeout handling; API URL prefix
  - Consistent HTTP configuration across all API calls
- [ ] **T4.2.4** Create `TenantInterceptor` — `HttpInterceptor` attaching `X-Graduate-Id` header from `TenantContextService` to every `/api` request
  - Multi-tenant context propagated automatically (QA-4)

## A4.3 — Shared Module 🔲

- [ ] **T4.3.1** Create `SharedModule` — exports reusable components; imported by feature modules
  - Component reuse standardized
- [ ] **T4.3.2** Create generic data table component — `@Input()` for columns definition and data source; pagination support; sortable columns
  - Consistent table UX across all list views (Student List, Professor List, Term List)
- [ ] **T4.3.3** Create notification service and component — `NotificationService` with `success()`, `error()`, `warning()` methods; toast display
  - User feedback standardized across features
- [ ] **T4.3.4** Create loading spinner component — overlay spinner with configurable message; `*ngIf` integration
  - Loading state visually consistent

## A4.4 — Shell / Layout 🔲

- [ ] **T4.4.1** Create `ShellComponent` — top bar (program selector, user area), collapsible sidebar (navigation menu), main content area
  - Application layout functional; navigation working
- [ ] **T4.4.2** Configure main routing — `AppRoutingModule` with lazy-loaded feature modules; wildcard redirect
  - Feature modules loaded on demand; initial bundle minimized
- [ ] **T4.4.3** Implement graduate program selector — dropdown in top bar consuming `GET /api/programs`; updates `TenantContextService` on selection
  - User can switch between programs; all subsequent API calls scoped to selected program
- [ ] **T4.4.4** Responsive design — CSS breakpoints for desktop (≥1024px), tablet (768–1023px), mobile (<768px); sidebar collapses on small screens
  - Layout works on required browsers: Chrome 130, Safari 22, Firefox 129 (CON-7)

## A4.5 — Program Selection and Dashboard 🔲

- [ ] **T4.5.1** Create `ProgramSelectionComponent` — initial view when no program is selected; list of available programs from API
  - User cannot proceed without selecting a program
- [ ] **T4.5.2** Create `DashboardModule` placeholder — lazy-loaded module with basic welcome view per role (placeholder content)
  - Landing page after program selection; feature modules can be added incrementally
- [ ] **T4.5.3** Create `ProgramApiService` — Angular service consuming `GET /api/programs` and `GET /api/programs/{id}/parameters`
  - API communication encapsulated in a typed service

---

## Deliverables

- [ ] **E4.1** Compilable Angular project — `ng build` succeeds; `ng serve` runs at `localhost:4200`
- [ ] **E4.2** Core module with TenantContextService — `X-Graduate-Id` injected automatically in API requests
- [ ] **E4.3** Shared module — reusable data table, notification, and loading components
- [ ] **E4.4** Responsive Shell/Layout — sidebar + top bar + content area; works on Chrome 130, Safari 22, Firefox 129
- [ ] **E4.5** Program selection flow — dropdown connected to backend; tenant context persisted

---

## Notes and Decisions

| # | Date | Decision | Context |
|---|------|----------|---------|
| — | — | — | — |
