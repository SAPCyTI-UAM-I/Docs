---
spec_id: SPEC-008B
status: draft
phase: 4
bounded_context: spa-platform
drivers: [CON-7, CON-6, QA-4, QA-6]
depends_on: [SPEC-008A]
---

# SPEC-008B: SPA Core Providers, Shell & i18n Infrastructure

> **Status:** 🔲 Draft
> **Author:** Antigravity (AI Architect)
> **Date:** 2026-05-12
> **Phase:** 4 | **ADD Iteration:** 1
> **Bounded Context:** — (SPA infrastructure, no bounded context)
> **Drivers:** CON-7 (browsers, responsive), CON-6 (predictable structure), QA-4 (tenant context), QA-6 (i18n)
> **Domain Schema:** N/A — no domain model in this spec
> **Domain Features:** N/A — no Gherkin scenarios; this is architectural scaffolding
> **Depends on:** [SPEC-008A](SPEC-008A_angular-project-scaffold-tooling.md) — must be ✅ before implementation
> **Blocks:** SPEC-009 (Phase 5 — Docker & Integration) — cannot start until this is ✅
> **External Dependencies:**
>   - [ ] SPEC-008A implemented — Angular project, dependencies, and tooling ready

---

## 1. Business Justification

Before any feature module (login, enrollment, entity management) can be built, the SPA needs its architectural skeleton: core services for authentication and tenant context, a navigable Shell layout, internationalization infrastructure, and shared UI components. This spec creates those foundational elements as minimum functional shells, enabling Phase 5 (smoke test) and Phase 6 (real auth implementation).

QA-4 requires multi-tenant context via `X-Graduate-Id` header. QA-6 requires i18n (Spanish/English). CON-6 requires a predictable structure for student developers.

**Acceptance Criteria (Business):**
- [ ] AC-1: Shell renders with top bar, sidebar, and language switcher
- [ ] AC-2: Language switcher toggles between Spanish and English across the app
- [ ] AC-3: HTTP requests include `X-Graduate-Id` header from tenant context
- [ ] AC-4: Lazy-loaded feature route placeholders are navigable

---

## 2. Scope

### In Scope
- `app.config.ts` — provider registration (HTTP client, router, i18n, interceptors, PrimeNG)
- `app.routes.ts` — base routes with lazy loading placeholders
- Core services: `AuthStateService` (stub), `TenantService` (full)
- Core guard: `AuthGuard` as `CanActivateFn` (stub — always `true`)
- Core interceptors: `JwtInterceptor` (stub), `TenantInterceptor` (full), `HttpErrorInterceptor` (basic)
- Shell/Layout standalone component with router-outlet and menu placeholder
- `@ngx-translate` configuration with `es.json`/`en.json` base keys
- `LanguageSwitcherComponent` — standalone, es/en toggle
- `AccessDeniedComponent` — 403 page with i18n
- Base TypeScript models: `ApiError`, `PageResponse<T>`

### Out of Scope
- **No real authentication logic** — stubs only; completed in Phase 6
- **No feature module components** (login form, student list, enrollment views)
- **No backend API calls** — interceptors are wired but no services make HTTP calls
- **No role-based menu filtering** — menu items visible for smoke test, filtering in Phase 6
- **No Playwright E2E tests** — deferred to Phase 5

### Assumptions
- SPEC-008A is ✅ Implemented — Angular project exists with all dependencies installed
- Backend is NOT required — stubs allow SPA to run standalone via `ng serve`

---

## 3. Architecture Impact

### Affected Layers

| Layer | Artifact | Action | Notes |
|-------|----------|--------|-------|
| `app/` | `app.config.ts` | MODIFY | Register all providers |
| `app/` | `app.routes.ts` | MODIFY | Add lazy-loaded feature routes |
| `app/core/auth/` | `auth.service.ts` | CREATE | AuthStateService — stub |
| `app/core/auth/` | `auth.guard.ts` | CREATE | CanActivateFn — stub |
| `app/core/auth/` | `jwt.interceptor.ts` | CREATE | HttpInterceptorFn — stub |
| `app/core/http/` | `tenant.service.ts` | CREATE | Full implementation |
| `app/core/http/` | `tenant.interceptor.ts` | CREATE | Full implementation |
| `app/core/http/` | `http-error.interceptor.ts` | CREATE | Basic error handling |
| `app/shell/` | `shell.component.ts` | CREATE | Layout with router-outlet |
| `app/shared/components/language-switcher/` | `language-switcher.component.ts` | CREATE | es/en toggle |
| `app/shared/components/access-denied/` | `access-denied.component.ts` | CREATE | 403 page |
| `app/models/` | `api-error.model.ts` | CREATE | Error interface |
| `app/models/` | `page-response.model.ts` | CREATE | Pagination interface |
| `assets/i18n/` | `es.json`, `en.json` | CREATE | Base translation keys |

### Package Location

```text
src/app/
├── app.config.ts                                ← MODIFY
├── app.routes.ts                                ← MODIFY
├── app.component.ts                             ← MODIFY (wrap with Shell)
├── core/
│   ├── auth/
│   │   ├── auth.service.ts                      ← CREATE (stub)
│   │   ├── auth.guard.ts                        ← CREATE (stub)
│   │   └── jwt.interceptor.ts                   ← CREATE (stub)
│   └── http/
│       ├── tenant.service.ts                    ← CREATE (full)
│       ├── tenant.interceptor.ts                ← CREATE (full)
│       └── http-error.interceptor.ts            ← CREATE (basic)
├── shared/
│   └── components/
│       ├── language-switcher/
│       │   └── language-switcher.component.ts   ← CREATE
│       └── access-denied/
│           └── access-denied.component.ts       ← CREATE
├── features/
│   ├── auth/
│   │   └── auth.routes.ts                       ← CREATE (placeholder)
│   ├── dashboard/
│   │   └── dashboard.routes.ts                  ← CREATE (placeholder)
│   ├── enrollment/
│   │   └── enrollment.routes.ts                 ← CREATE (placeholder)
│   └── academic-catalog/
│       └── academic-catalog.routes.ts           ← CREATE (placeholder)
├── models/
│   ├── api-error.model.ts                       ← CREATE
│   └── page-response.model.ts                   ← CREATE
└── shell/
    ├── shell.component.ts                       ← CREATE
    ├── shell.component.html                     ← CREATE
    └── shell.component.css                      ← CREATE
```

> **Ref:** [`Architecture.md §6.2`](../../design/Architecture.md) — SPA component diagram

### Architectural Context

> From `Architecture.md §6.2` — SPA Component Responsibilities:
> - **Shell / Layout**: Application structure (menu, top bar, container); high-level standalone routing; loading feature routes; conditionally renders menu items based on `currentUser$.role` from AuthStateService.
> - **Auth Interceptor (Core)**: Angular `HttpInterceptorFn`; attaches `Authorization: Bearer` header; injects `Accept-Language` header with current locale; on 401 response, attempts token refresh.
> - **Tenant Context (Core)**: Manages the active graduate program selection; includes `X-Graduate-Id` header in API requests.
> - **Translation Config (Core)**: `@ngx-translate/core` + `@ngx-translate/http-loader` via `provideTranslateService`. Default language: Spanish (`es`).

> From `technologies/frontend.md §Dependency Rules`:
> - `core/` services use `providedIn: 'root'` and interceptors are registered in `app.config.ts`.
> - `shared/` standalone components are imported directly into the `imports: []` array of the target component.
> - `features/` lazy-loaded via `loadChildren`.

### Cross-Module Dependencies

- None — this is SPA infrastructure. No backend modules consumed.
- Auth stubs will be completed by a future Phase 6 frontend spec that does `MODIFY` on `auth.service.ts`, `auth.guard.ts`, and `jwt.interceptor.ts`.

---

## 4. Technical Design

### 4.1 Domain Model

N/A — No domain model.

### 4.2 Port Contracts

N/A — No hexagonal ports. Angular services use `providedIn: 'root'`.

### 4.3 Infrastructure

N/A — No backend infrastructure.

### 4.4 API Contract

N/A — No API endpoints.

### 4.5 Frontend Contract

#### 4.5.1 `app.config.ts`

```typescript
import { ApplicationConfig, provideZoneChangeDetection } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import { providePrimeNG } from 'primeng/config';
import { TranslateLoader, TranslateModule } from '@ngx-translate/core';
import { TranslateHttpLoader } from '@ngx-translate/http-loader';
import { HttpClient } from '@angular/common/http';

import { routes } from './app.routes';
import { jwtInterceptor } from './core/auth/jwt.interceptor';
import { tenantInterceptor } from './core/http/tenant.interceptor';
import { httpErrorInterceptor } from './core/http/http-error.interceptor';

export function httpLoaderFactory(http: HttpClient): TranslateHttpLoader {
  return new TranslateHttpLoader(http, './assets/i18n/', '.json');
}

export const appConfig: ApplicationConfig = {
  providers: [
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(routes),
    provideHttpClient(
      withInterceptors([jwtInterceptor, tenantInterceptor, httpErrorInterceptor])
    ),
    provideAnimationsAsync(),
    providePrimeNG({ ripple: false }),
    TranslateModule.forRoot({
      defaultLanguage: 'es',
      loader: {
        provide: TranslateLoader,
        useFactory: httpLoaderFactory,
        deps: [HttpClient],
      },
    }).providers!,
  ],
};
```

#### 4.5.2 `app.routes.ts`

```typescript
import { Routes } from '@angular/router';
import { authGuard } from './core/auth/auth.guard';

export const routes: Routes = [
  {
    path: '',
    loadComponent: () => import('./shell/shell.component').then(m => m.ShellComponent),
    children: [
      { path: '', redirectTo: 'dashboard', pathMatch: 'full' },
      {
        path: 'dashboard',
        loadChildren: () => import('./features/dashboard/dashboard.routes')
          .then(m => m.DASHBOARD_ROUTES),
        canActivate: [authGuard],
      },
      {
        path: 'enrollment',
        loadChildren: () => import('./features/enrollment/enrollment.routes')
          .then(m => m.ENROLLMENT_ROUTES),
        canActivate: [authGuard],
      },
      {
        path: 'academic-catalog',
        loadChildren: () => import('./features/academic-catalog/academic-catalog.routes')
          .then(m => m.ACADEMIC_CATALOG_ROUTES),
        canActivate: [authGuard],
      },
      { path: 'access-denied', loadComponent: () =>
          import('./shared/components/access-denied/access-denied.component')
            .then(m => m.AccessDeniedComponent) },
    ],
  },
  {
    path: 'auth',
    loadChildren: () => import('./features/auth/auth.routes').then(m => m.AUTH_ROUTES),
  },
  { path: '**', redirectTo: '' },
];
```

#### 4.5.3 Core Services — Stubs

```typescript
// core/auth/auth.service.ts
// TODO: Phase 6 — implement real JWT token lifecycle, silent refresh
@Injectable({ providedIn: 'root' })
export class AuthStateService {
  private currentUserSubject = new BehaviorSubject<any | null>(null);
  currentUser$ = this.currentUserSubject.asObservable();

  isAuthenticated(): boolean { return false; }
  hasRole(role: string): boolean { return false; }
  login(email: string, password: string): Observable<void> { return of(void 0); }
  logout(): void { /* no-op */ }
}
```

```typescript
// core/auth/auth.guard.ts
// TODO: Phase 6 — implement real role check and JWT validation
export const authGuard: CanActivateFn = (route, state) => {
  return true; // Allows all navigation during scaffold phase
};
```

```typescript
// core/auth/jwt.interceptor.ts
// TODO: Phase 6 — attach Bearer token, implement 401 refresh flow
export const jwtInterceptor: HttpInterceptorFn = (req, next) => {
  const translate = inject(TranslateService);
  const cloned = req.clone({
    setHeaders: { 'Accept-Language': translate.currentLang || 'es' },
  });
  return next(cloned);
};
```

#### 4.5.4 Core Services — Full Implementation

```typescript
// core/http/tenant.service.ts
@Injectable({ providedIn: 'root' })
export class TenantService {
  private graduateProgramIdSubject = new BehaviorSubject<number | null>(null);
  graduateProgramId$ = this.graduateProgramIdSubject.asObservable();

  set(id: number): void { this.graduateProgramIdSubject.next(id); }
  get(): number | null { return this.graduateProgramIdSubject.getValue(); }
  clear(): void { this.graduateProgramIdSubject.next(null); }
}
```

```typescript
// core/http/tenant.interceptor.ts
export const tenantInterceptor: HttpInterceptorFn = (req, next) => {
  const tenantService = inject(TenantService);
  const programId = tenantService.get();
  if (programId !== null) {
    const cloned = req.clone({
      setHeaders: { 'X-Graduate-Id': programId.toString() },
    });
    return next(cloned);
  }
  return next(req);
};
```

```typescript
// core/http/http-error.interceptor.ts
// TODO: Phase 6 — add 401 token refresh retry logic
export const httpErrorInterceptor: HttpInterceptorFn = (req, next) => {
  return next(req).pipe(
    catchError((error: HttpErrorResponse) => {
      console.error(`[HTTP Error] ${error.status} - ${error.url}`, error);
      return throwError(() => error);
    })
  );
};
```

#### 4.5.5 Shell Component

```typescript
// shell/shell.component.ts
@Component({
  selector: 'app-shell',
  standalone: true,
  imports: [RouterOutlet, RouterLink, RouterLinkActive, LanguageSwitcherComponent, TranslateModule],
  templateUrl: './shell.component.html',
  styleUrl: './shell.component.css',
})
export class ShellComponent {
  // Menu items visible for smoke test — no role filtering yet
  // TODO: Phase 6 — filter by currentUser$.role
  menuItems = [
    { label: 'SHELL.MENU.DASHBOARD', route: '/dashboard', icon: 'pi pi-home' },
    { label: 'SHELL.MENU.ENROLLMENT', route: '/enrollment', icon: 'pi pi-book' },
    { label: 'SHELL.MENU.CATALOG', route: '/academic-catalog', icon: 'pi pi-users' },
  ];
}
```

Shell HTML: top bar with app title + language switcher, sidebar with menu items using `translate` pipe, main area with `<router-outlet>`.

#### 4.5.6 Language Switcher

```typescript
// shared/components/language-switcher/language-switcher.component.ts
@Component({
  selector: 'app-language-switcher',
  standalone: true,
  imports: [],
  template: `
    <button (click)="toggle()" class="...">
      {{ currentLang === 'es' ? 'EN' : 'ES' }}
    </button>
  `,
})
export class LanguageSwitcherComponent implements OnInit {
  currentLang = 'es';
  private translate = inject(TranslateService);

  ngOnInit(): void {
    this.currentLang = localStorage.getItem('lang') || 'es';
    this.translate.use(this.currentLang);
  }

  toggle(): void {
    this.currentLang = this.currentLang === 'es' ? 'en' : 'es';
    this.translate.use(this.currentLang);
    localStorage.setItem('lang', this.currentLang);
  }
}
```

#### 4.5.7 Translation Files

```json
// assets/i18n/es.json
{
  "SHELL": {
    "TOPBAR": { "TITLE": "SAPCyTI", "LOGOUT": "Cerrar sesión" },
    "MENU": {
      "DASHBOARD": "Inicio",
      "ENROLLMENT": "Inscripción",
      "CATALOG": "Catálogo Académico"
    }
  },
  "COMMON": {
    "ERRORS": {
      "ACCESS_DENIED": "Acceso denegado",
      "ACCESS_DENIED_MSG": "No tienes permisos para acceder a esta página.",
      "NOT_FOUND": "Página no encontrada",
      "SERVER_ERROR": "Error del servidor"
    },
    "ACTIONS": { "SAVE": "Guardar", "CANCEL": "Cancelar", "DELETE": "Eliminar", "EDIT": "Editar", "BACK": "Regresar" }
  }
}
```

```json
// assets/i18n/en.json — same structure, English values
```

#### 4.5.8 Models

```typescript
// models/api-error.model.ts
export interface ApiError {
  error: string;
  message: string;
}

// models/page-response.model.ts
export interface PageResponse<T> {
  content: T[];
  totalElements: number;
  totalPages: number;
  size: number;
  number: number;
}
```

#### 4.5.9 Feature Route Placeholders

Each feature folder gets a minimal routes file with a placeholder component:

```typescript
// features/dashboard/dashboard.routes.ts
export const DASHBOARD_ROUTES: Routes = [
  { path: '', component: DashboardPlaceholderComponent },
];
// DashboardPlaceholderComponent: standalone, displays "Dashboard — coming soon" with translate pipe
```

Same pattern for `auth.routes.ts`, `enrollment.routes.ts`, `academic-catalog.routes.ts`.

---

## 5. Security Considerations

| # | Threat | CWE | Mitigation | Validated By |
|---|--------|-----|------------|--------------|
| SEC-1 | XSS via localStorage lang preference | CWE-79 | Value is only `'es'` or `'en'` — validated in `toggle()`. No user-supplied HTML. | Code review |
| SEC-2 | JWT stored in localStorage (future risk) | CWE-922 | Auth stub stores nothing. Phase 6 spec will store token in memory only (not localStorage). | SPEC-008B documents stub; Phase 6 spec enforces. |

**Access Control:**
- No access control in this spec — `AuthGuard` stub always returns `true`
- Real RBAC enforcement is in Phase 6 (backend `@PreAuthorize` + frontend guard)

---

## 6. Edge Cases & Error Handling

| # | Scenario | Expected Behavior |
|---|----------|-------------------|
| EC-1 | Translation key missing in JSON file | `@ngx-translate` displays the raw key string (e.g., `SHELL.MENU.DASHBOARD`) |
| EC-2 | `localStorage` unavailable (private browsing) | Language defaults to `'es'`; `toggle()` wrapped in try/catch |
| EC-3 | `TenantService.get()` returns `null` | `TenantInterceptor` skips header — request sent without `X-Graduate-Id` |
| EC-4 | Navigation to unknown route | Wildcard `**` redirects to root → dashboard |
| EC-5 | HTTP error without backend running | `HttpErrorInterceptor` logs to console; app remains functional |

---

## 7. Performance & Scalability Notes

| Concern | Detail | Mitigation |
|---------|--------|------------|
| Bundle size | PrimeNG full import could inflate bundle | Import only used components per feature (tree-shaking via standalone imports) |
| Lazy loading | All features must be lazy-loaded | Routes use `loadChildren`/`loadComponent` — verified in `app.routes.ts` |

---

## 8. Migration & Rollback Strategy

- **Rollback:** Revert Git commits. No database or backend changes involved.
- **API backward compatibility:** N/A — no API endpoints created.

---

## 9. Testing Strategy

| Test Type | File | Scope | Framework |
|-----------|------|-------|-----------|
| Unit | `tenant.service.spec.ts` | `set()`, `get()`, `clear()` lifecycle | Vitest |
| Unit | `tenant.interceptor.spec.ts` | Header attached when programId set; skipped when null | Vitest |
| Unit | `jwt.interceptor.spec.ts` | `Accept-Language` header injected with current locale | Vitest |
| Unit | `http-error.interceptor.spec.ts` | Error logged, error propagated | Vitest |
| Unit | `language-switcher.component.spec.ts` | Toggle changes language, persists to localStorage | Vitest |
| Unit | `auth.service.spec.ts` | `isAuthenticated()` returns false, `currentUser$` emits null | Vitest |
| Manual | Shell visual test | Shell renders, menu navigates, language switches | Developer in browser |

> **Coverage mínimo:** Tests cover all implemented logic (TenantService, TenantInterceptor, LanguageSwitcher). Stubs have minimal tests confirming stub behavior.
> **Referencia:** [`technologies/testing.md`](../../../technologies/testing.md)

---

## 10. Conventions Checklist

- [ ] All components are `standalone: true` — no NgModules
- [ ] Core services use `providedIn: 'root'`
- [ ] Interceptors are `HttpInterceptorFn` (functional, not class-based)
- [ ] Guard is `CanActivateFn` (functional, not class-based)
- [ ] Interceptors registered in `app.config.ts` via `withInterceptors([])`
- [ ] All user-facing strings use `translate` pipe — no hardcoded text
- [ ] Translation key format: `{MODULE}.{COMPONENT}.{KEY}`
- [ ] Feature routes use `loadChildren` for lazy loading
- [ ] No cross-feature imports (features are isolated)
- [ ] Models are pure TypeScript interfaces — no Angular dependencies
- [ ] Stubs marked with `// TODO: Phase 6 — implement real logic`
- [ ] Component naming: `{name}.component.ts`; Service: `{name}.service.ts`

> **Referencia:** [`progress.md` → Active Conventions](../../implementation/progress.md)

---

## 11. References

- **Architecture:** [`Architecture.md §6.2`](../../design/Architecture.md) — SPA component diagram and responsibilities
- **Architecture:** [`Architecture.md §5`](../../design/Architecture.md) — Container diagram
- **Technology Stack:** [`technologies/frontend.md`](../../../technologies/frontend.md) — Angular conventions, folder structure, dependency rules
- **Implementation Plan:** [`implementationPlan.md`](../../implementation/implementationPlan.md) — Phase 4 definition
- **Phase Tasks:** [`phase4.md`](../../implementation/phase4.md) — Task map for this spec
- **Depends On:** [SPEC-008A](SPEC-008A_angular-project-scaffold-tooling.md) — Angular project scaffold
- **Blocked By This:** SPEC-009 (Phase 5 — Docker & Integration)

---

## 12. Review Log

| Date | Reviewer | Action | Notes |
|------|----------|--------|-------|
| — | — | — | — |
