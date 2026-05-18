# Frontend Technology Stack — SAPCyTI

> **Source of truth** for frontend (SPA) versions, libraries, and rules.
> Referenced from specs and [`progress.md`](../../implementation/progress.md).

---

## Runtime

| Component      | Version | Notes                                   |
| -------------- | ------- | --------------------------------------- |
| **Angular**    | 21      | Angular CLI + ESBuild/Vite build system |
| **TypeScript** | 5.x     | Strict mode enabled                     |
| **Node.js**    | 22.12.0 | Required for build tooling              |
| **yarn**       | 1.22    | Package manager                         |

## Core Dependencies

| Library                      | Purpose                                                   |
| ---------------------------- | --------------------------------------------------------- |
| Angular CLI                  | Project scaffolding, build, serve                         |
| Angular HttpClient           | REST client with interceptors                             |
| Angular Router               | SPA routing, lazy loading                                 |
| Angular Forms (Reactive)     | Form handling, validation                                 |
| PrimeNG                      | Component library (preferred over custom implementations) |
| `@ngx-translate/core`        | Internationalization (QA-6)                               |
| `@ngx-translate/http-loader` | Load translation files from `assets/i18n/`                |

## Styling & UI Components

> **Rule:** Use pre-built **PrimeNG** components (_unstyled_ mode). Create base UI components from scratch only if they don't exist in PrimeNG. Angular Material is discarded to avoid conflicts with Tailwind.

| Tool             | Purpose                                                                       |
| ---------------- | ----------------------------------------------------------------------------- |
| Tailwind CSS     | Utility-first CSS framework (without using BEM conventions).                      |
| PrimeNG          | Base UI components and directives.                                             |
| CSS Base         | Pure CSS for exceptional overrides. No SCSS.                              |
| Responsive-first | Mobile-first media queries via Tailwind modifiers (`md:`, `lg:`). (CON-7) |

## Browser Support (CON-7)

| Browser | Minimum Version |
| ------- | --------------- |
| Chrome  | 130+            |
| Safari  | 22+             |
| Firefox | 129+            |

---

## Architecture Rules

> Ref: [`Architecture.md §6.2`](../../design/Architecture.md) — SPA component diagram

### Folder Structure (Standalone Components)

Architecture based exclusively on Standalone Components (no `NgModules`).

```text
src/app/
├── core/                    # Singleton services, guards, interceptors (providedIn: 'root')
│   ├── auth/
│   │   ├── auth.service.ts
│   │   ├── auth.guard.ts
│   │   └── jwt.interceptor.ts
│   └── http/
│       ├── http-error.interceptor.ts
│       └── tenant.interceptor.ts
├── shared/                  # Reusable standalone components, pipes, directives
│   ├── components/
│   │   └── data-table/
│   └── pipes/
├── features/                # Domain-driven feature folders (Lazy loaded routes)
│   ├── auth/                # Login, password recovery (HU-01, HU-02)
│   ├── dashboard/
│   ├── enrollment/          # Course selection, approval (HU-06 to HU-10)
│   │   ├── components/
│   │   ├── services/
│   │   └── enrollment.routes.ts
│   └── academic-catalog/    # Students, Professors CRUD (HU-15, HU-21)
├── models/                  # TypeScript interfaces (mirror backend DTOs)
├── assets/
│   └── i18n/
│       ├── es.json
│       └── en.json
└── environments/
    ├── environment.ts
    └── environment.prod.ts
```

### Dependency Rules

- **core/** — Not imported as a module. Its services use `providedIn: 'root'` and interceptors are registered in `app.config.ts`.
- **shared/** — _Standalone_ components are imported directly into the `imports: []` array of the target component only when needed.
- **features/** — Lazy-loaded routes using `loadChildren: () => import('./features/enrollment/enrollment.routes').then(m => m.ENROLLMENT_ROUTES)`. No feature folder should cross-import from another feature folder.
- **models/** — Pure TypeScript interfaces; no Angular dependencies.

### Naming Conventions

| Artifact    | Convention              | Example                         |
| ----------- | ----------------------- | ------------------------------- |
| Component   | `{name}.component.ts`   | `course-selection.component.ts` |
| Service     | `{name}.service.ts`     | `enrollment.service.ts`         |
| Guard       | `{name}.guard.ts`       | `auth.guard.ts`                 |
| Interceptor | `{name}.interceptor.ts` | `jwt.interceptor.ts`            |
| Model       | `{name}.model.ts`       | `student.model.ts`              |
| Routing     | `{name}.routes.ts`      | `enrollment.routes.ts`          |

### HTTP & Authentication

- JWT access token stored **in memory** (not localStorage — XSS protection)
- Refresh token via **HttpOnly cookie** (CSRF protection)
- `JwtInterceptor`: attaches `Authorization: Bearer {token}` to all API requests
- `TenantInterceptor`: attaches `X-Graduate-Id` header from `TenantService`
- `HttpErrorInterceptor`: global error handling, 401 → redirect to login

### Internationalization (QA-6)

- `@ngx-translate` configured via `provideTranslateService` in `app.config.ts`.
- Translation files: `assets/i18n/{lang}.json`
- Default language: `es` (Spanish)
- Key format: `{MODULE}.{COMPONENT}.{KEY}` — e.g., `ENROLLMENT.COURSE_SELECTION.TITLE`
- All user-facing strings MUST use translation keys — no hardcoded text

### State Management

- **No NgRx for MVP** — services with `BehaviorSubject` for reactive state
- Consider NgRx if state complexity grows beyond 3 interacting stores

### Testing

| Tool       | Purpose                                                 |
| ---------- | ------------------------------------------------------- |
| Vitest     | Unit Testing and Code Coverage (replaces Jasmine/Karma).|
| Playwright | End-to-End (E2E) Testing.                               |

### Deployment

| Component | Purpose                                                                               |
| --------- | ------------------------------------------------------------------------------------- |
| Nginx     | HTTP web server in a Docker container. 404 fallback always routed to `index.html`.    |

### Linting & Formatting (Mandatory)

| Tool            | Purpose                                                                            |
| --------------- | ---------------------------------------------------------------------------------- |
| ESLint          | Code quality (with `@angular-eslint`).                                             |
| Prettier        | Auto-formatting. Requires `prettier-plugin-tailwindcss` for class sorting.         |
| `.editorconfig` | Unified indentation rules across the editor.                                       |
