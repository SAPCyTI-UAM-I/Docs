# Frontend Technology Stack — SAPCyTI

> **Fuente de verdad** para versiones, librerías y reglas del frontend (SPA).
> Referenciado desde specs y [`progress.md`](../../implementations/progress.md).

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

> **Regla:** Utilizar componentes predefinidos de **PrimeNG** (modo _unstyled_). Crear componentes UI base desde cero solo si no existen en PrimeNG. Angular Material está descartado para evitar choques con Tailwind.

| Tool             | Purpose                                                                       |
| ---------------- | ----------------------------------------------------------------------------- |
| Tailwind CSS     | Utility-first CSS framework (sin usar convenciones BEM).                      |
| PrimeNG          | Componentes y directivas UI base.                                             |
| CSS Base         | CSS puro para overrides excepcionales. Sin SCSS.                              |
| Responsive-first | Mobile-first media queries vía modificadores Tailwind (`md:`, `lg:`). (CON-7) |

## Browser Support (CON-7)

| Browser | Minimum Version |
| ------- | --------------- |
| Chrome  | 130+            |
| Safari  | 22+             |
| Firefox | 129+            |

---

## Architecture Rules

> Ref: [`Architecture.md §6.2`](../../Design/Architecture.md) — SPA component diagram

### Folder Structure (Standalone Components)

Arquitectura basada exclusivamente en componentes Standalone (sin `NgModules`).

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

- **core/** — No se importa como módulo. Sus servicios usan `providedIn: 'root'` y los interceptores se registran en `app.config.ts`.
- **shared/** — Los componentes _standalone_ se importan directamente en el parámetro `imports: []` del componente destino solo cuando se necesitan.
- **features/** — Rutas lazy-loaded mediante `loadChildren: () => import('./features/enrollment/enrollment.routes').then(m => m.ENROLLMENT_ROUTES)`. Ningún feature folder debe importar de otro feature folder de forma transversal.
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

- `@ngx-translate` configured via `provideTranslateService` en `app.config.ts`.
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
| Vitest     | Unit Testing y Code Coverage (reemplaza Jasmine/Karma). |
| Playwright | End-to-End (E2E) Testing.                               |

### Deployment

| Component | Purpose                                                                               |
| --------- | ------------------------------------------------------------------------------------- |
| Nginx     | Servidor web HTTP en contenedor Docker. Fallback 404 siempre enrutado a `index.html`. |

### Linting & Formatting (Obligatorios)

| Tool            | Purpose                                                                            |
| --------------- | ---------------------------------------------------------------------------------- |
| ESLint          | Code quality (con `@angular-eslint`).                                              |
| Prettier        | Auto-formateo. Requiere `prettier-plugin-tailwindcss` para ordenamiento de clases. |
| `.editorconfig` | Reglas de identación unificadas sobre el editor.                                   |
