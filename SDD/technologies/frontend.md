# Frontend Technology Stack — SAPCyTI

> **Fuente de verdad** para versiones, librerías y reglas del frontend (SPA).
> Referenciado desde specs y [`progress.md`](../../implementations/progress.md).

---

## Runtime

| Component | Version | Notes |
|-----------|---------|-------|
| **Angular** | 17+ | Angular CLI for scaffolding |
| **TypeScript** | 5.x | Strict mode enabled |
| **Node.js** | 20 LTS | Required for build tooling |
| **npm** | 10+ | Package manager |

## Core Dependencies

| Library | Purpose |
|---------|---------|
| Angular CLI | Project scaffolding, build, serve |
| Angular HttpClient | REST client with interceptors |
| Angular Router | SPA routing, lazy loading |
| Angular Forms (Reactive) | Form handling, validation |
| `@ngx-translate/core` | Internationalization (QA-6) |
| `@ngx-translate/http-loader` | Load translation files from `assets/i18n/` |

## Styling

| Tool | Purpose |
|------|---------|
| SCSS | CSS preprocessor |
| BEM naming | CSS class naming convention |
| Responsive-first | Mobile-first media queries (CON-7) |

## Browser Support (CON-7)

| Browser | Minimum Version |
|---------|----------------|
| Chrome | 130+ |
| Safari | 22+ |
| Firefox | 129+ |

---

## Architecture Rules

> Ref: [`Architecture.md §6.2`](../../Design/Architecture.md) — SPA component diagram

### Module Structure

```text
src/app/
├── core/                    # Singleton services, guards, interceptors
│   ├── services/
│   │   ├── auth.service.ts
│   │   ├── tenant.service.ts
│   │   └── http-error.interceptor.ts
│   ├── guards/
│   │   ├── auth.guard.ts
│   │   └── role.guard.ts
│   └── core.module.ts
├── shared/                  # Reusable components, pipes, directives
│   ├── components/
│   ├── pipes/
│   └── shared.module.ts
├── features/                # Lazy-loaded feature modules
│   ├── login/
│   ├── dashboard/
│   ├── enrollment/
│   │   ├── coordinator/
│   │   ├── student/
│   │   └── advisor/
│   └── entity-management/
│       ├── students/
│       └── professors/
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

- **core/** — imported ONCE in `AppModule`; never in feature modules
- **shared/** — imported by any module that needs reusable components
- **features/** — lazy-loaded; each feature has its own module and routing
- **models/** — pure TypeScript interfaces; no Angular dependencies

### Naming Conventions

| Artifact | Convention | Example |
|----------|-----------|---------|
| Component | `{name}.component.ts` | `course-selection.component.ts` |
| Service | `{name}.service.ts` | `enrollment.service.ts` |
| Guard | `{name}.guard.ts` | `auth.guard.ts` |
| Interceptor | `{name}.interceptor.ts` | `jwt.interceptor.ts` |
| Model | `{name}.model.ts` | `student.model.ts` |
| Module | `{name}.module.ts` | `enrollment.module.ts` |
| Routing | `{name}-routing.module.ts` | `enrollment-routing.module.ts` |

### HTTP & Authentication

- JWT access token stored **in memory** (not localStorage — XSS protection)
- Refresh token via **HttpOnly cookie** (CSRF protection)
- `JwtInterceptor`: attaches `Authorization: Bearer {token}` to all API requests
- `TenantInterceptor`: attaches `X-Graduate-Id` header from `TenantService`
- `HttpErrorInterceptor`: global error handling, 401 → redirect to login

### Internationalization (QA-6)

- `@ngx-translate` configured in `CoreModule`
- Translation files: `assets/i18n/{lang}.json`
- Default language: `es` (Spanish)
- Key format: `{MODULE}.{COMPONENT}.{KEY}` — e.g., `ENROLLMENT.COURSE_SELECTION.TITLE`
- All user-facing strings MUST use translation keys — no hardcoded text

### State Management

- **No NgRx for MVP** — services with `BehaviorSubject` for reactive state
- Consider NgRx if state complexity grows beyond 3 interacting stores

### Linting

| Tool | Purpose |
|------|---------|
| ESLint | Code quality |
| `@angular-eslint` | Angular-specific rules |
| Prettier (optional) | Code formatting |
