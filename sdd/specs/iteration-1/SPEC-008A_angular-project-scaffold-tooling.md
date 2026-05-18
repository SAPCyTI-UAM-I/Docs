---
spec_id: SPEC-008A
status: implemented
phase: 4A
bounded_context: spa-platform
drivers: [CON-7, CON-6]
depends_on: []
---

# SPEC-008A: Angular Project Scaffold & Tooling Configuration

> **Status:** ✅ Implemented
> **Author:** Antigravity (AI Architect)
> **Date:** 2026-05-12
> **Phase:** 4A | **ADD Iteration:** 1
> **Bounded Context:** — (SPA infrastructure, no bounded context)
> **Drivers:** CON-7 (browser support, responsive), CON-6 (predictable structure for student developers)
> **Domain Schema:** N/A — no domain model in this spec
> **Domain Features:** N/A — no Gherkin scenarios; this is infrastructure scaffolding
> **Depends on:** — (Phase 0 must be complete — repo exists, quality tools configured)
> **Blocks:** [SPEC-008B](SPEC-008B_spa-core-providers-shell-i18n.md) — cannot start until this is ✅
> **External Dependencies:**
>   - [ ] Node.js 22.12.0 installed on developer machine
>   - [ ] Angular CLI installed globally (`npm install -g @angular/cli`)
>   - [ ] `sapcyti-spa` Git repository created (Phase 0)

---

## 1. Business Justification

The SAPCyTI system requires a Single Page Application (SPA) to provide the user interface for all actors (Coordinator, Professor, Student, Assistant). Before any frontend feature can be built, the Angular project must exist with the correct dependencies, tooling, and folder structure. This spec creates the bare minimum project scaffold that enables all subsequent frontend development.

CON-7 mandates browser support (Chrome 130+, Safari 22+, Firefox 129+) and responsive design. CON-6 requires a predictable, well-documented structure for rotating student developers.

**Acceptance Criteria (Business):**
- [ ] AC-1: The Angular project compiles and serves locally without errors
- [ ] AC-2: Code quality tools (ESLint, Prettier) are configured and pass on the initial codebase
- [ ] AC-3: Test runner (Vitest) is configured and executable
- [ ] AC-4: Folder structure matches the documented conventions in `technologies/frontend.md`

---

## 2. Scope

### In Scope
- Angular 21 project creation via CLI
- Core dependency installation: Tailwind CSS, PrimeNG (unstyled mode), @ngx-translate
- Tooling: ESLint + @angular-eslint, Prettier + prettier-plugin-tailwindcss, Vitest + @analogjs/vitest-angular
- Folder structure creation (`core/`, `shared/`, `features/`, `models/`, `assets/i18n/`)
- Environment files (`environment.ts`, `environment.prod.ts`)
- `.editorconfig` for consistent formatting

### Out of Scope
- **No Angular services, components, or interceptors** — those are in SPEC-008B
- **No Shell/Layout** — SPEC-008B
- **No i18n configuration** (translation loading, key format) — SPEC-008B
- **No Playwright E2E setup** — deferred to Phase 5
- **No CI/CD pipeline updates** — existing PR Validation workflow from Phase 0 applies
- **No `app.config.ts` provider registration** — SPEC-008B

### Assumptions
- Phase 0 repo setup is complete (`.gitignore`, `package.json` for commitlint)
- Developer has Node.js 22.12.0 and npm/yarn available
- The project is created inside the `sapcyti-spa` repository root

---

## 3. Architecture Impact

### Affected Layers

> This spec creates the project skeleton only. No Angular application layers are affected — all layers start empty.

| Layer | Artifact | Action | Notes |
|-------|----------|--------|-------|
| Project root | `package.json` | CREATE | Angular CLI generates; dependencies added manually |
| Project root | `angular.json` | CREATE | Angular CLI generates; Vitest modifications applied |
| Project root | `tsconfig.json` | CREATE | Angular CLI generates; strict mode enabled |
| Project root | `postcss.config.js` | CREATE | Tailwind CSS PostCSS integration |
| Project root | `vite.config.ts` | CREATE | Vitest configuration for Angular |
| Project root | `.eslintrc.json` | CREATE | ESLint + @angular-eslint rules |
| Project root | `.prettierrc` | CREATE | Prettier configuration |
| Project root | `.prettierignore` | CREATE | Prettier ignore patterns |
| Project root | `.editorconfig` | CREATE | Editor formatting rules |
| `src/` | `styles.css` | MODIFY | Add Tailwind CSS directives |
| `src/environments/` | `environment.ts`, `environment.prod.ts` | CREATE | API base URL config |
| `src/app/` | `core/`, `shared/`, `features/`, `models/` | CREATE | Empty directories with placeholder |
| `src/assets/i18n/` | — | CREATE | Empty directory for translation files |

### Package Location

```text
sapcyti-spa/
├── .editorconfig                           ← CREATE
├── .eslintrc.json                          ← CREATE
├── .prettierrc                             ← CREATE
├── .prettierignore                         ← CREATE
├── postcss.config.js                       ← CREATE
├── vite.config.ts                          ← CREATE (Vitest)
├── angular.json                            ← CREATE (CLI) + MODIFY (Vitest)
├── package.json                            ← CREATE (CLI) + MODIFY (deps)
├── tsconfig.json                           ← CREATE (CLI)
├── src/
│   ├── styles.css                          ← MODIFY (Tailwind directives)
│   ├── environments/
│   │   ├── environment.ts                  ← CREATE
│   │   └── environment.prod.ts             ← CREATE
│   ├── assets/
│   │   └── i18n/                           ← CREATE (empty dir)
│   └── app/
│       ├── core/                           ← CREATE (empty dir)
│       ├── shared/                         ← CREATE (empty dir)
│       ├── features/                       ← CREATE (empty dir)
│       └── models/                         ← CREATE (empty dir)
```

> **Referencia arquitectónica:** [`Architecture.md §6.2`](../../design/Architecture.md) — SPA component diagram
> [`technologies/frontend.md §Folder Structure`](../../../technologies/frontend.md) — Folder structure conventions

### Architectural Context

> From `Architecture.md §5` — Container diagram:
> The SPA container is an Angular application running in the user's browser. It communicates with the Backend API via REST/JSON + JWT Bearer tokens. At deployment, SPA static assets are served by an Nginx container.

> From `technologies/frontend.md §Architecture Rules`:
> Architecture based exclusively on Standalone Components (no NgModules). `core/` services use `providedIn: 'root'`. `shared/` contains standalone components imported directly. `features/` uses lazy-loaded routes. `models/` contains pure TypeScript interfaces.

### Cross-Module Dependencies

- None — this is infrastructure scaffolding with no cross-module communication.

---

## 4. Technical Design

### 4.1 Domain Model

N/A — No domain model. This spec is project infrastructure.

### 4.2 Port Contracts

N/A — No ports or services.

### 4.3 Infrastructure

#### 4.3.1 Angular Project Creation

```bash
# T4A.1.1 — Create Angular project
ng new sapcyti-spa --strict --routing --style=css --ssr=false --skip-git
# --strict: enables TypeScript strict mode
# --routing: creates app.routes.ts with RouterModule
# --style=css: plain CSS (no SCSS) — Tailwind handles utility classes
# --ssr=false: SPA only, no server-side rendering
# --skip-git: repo already initialized in Phase 0
```

#### 4.3.2 Dependency Installation

```bash
# T4A.2.1 — Tailwind CSS
npm install -D tailwindcss @tailwindcss/postcss postcss

# T4A.2.2 — PrimeNG
npm install primeng

# T4A.2.3 — ngx-translate
npm install @ngx-translate/core @ngx-translate/http-loader
```

#### 4.3.3 PostCSS Configuration

```javascript
// postcss.config.js
module.exports = {
  plugins: {
    "@tailwindcss/postcss": {},
  },
};
```

#### 4.3.4 Tailwind Directives in styles.css

```css
/* src/styles.css */
@import "tailwindcss";
```

#### 4.3.5 Vitest Configuration

```bash
# T4A.3.3 — Install Vitest
npm install -D vitest @analogjs/vitest-angular
```

```typescript
// vite.config.ts
/// <reference types="vitest" />
import { defineConfig } from 'vite';
import angular from '@analogjs/vitest-angular';

export default defineConfig({
  plugins: [angular()],
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: ['src/test-setup.ts'],
    include: ['src/**/*.spec.ts'],
    coverage: {
      provider: 'istanbul',
      reporter: ['text', 'lcov'],
      include: ['src/app/**/*.ts'],
      exclude: ['src/app/**/*.spec.ts', 'src/app/**/*.routes.ts'],
    },
  },
});
```

```typescript
// src/test-setup.ts
import '@analogjs/vitest-angular/setup-zone';
```

Update `angular.json` — replace Karma test builder:
```json
{
  "test": {
    "builder": "@analogjs/vitest-angular:test"
  }
}
```

Update `package.json` scripts:
```json
{
  "scripts": {
    "test": "vitest run",
    "test:watch": "vitest",
    "test:coverage": "vitest run --coverage"
  }
}
```

#### 4.3.6 ESLint Configuration

```bash
# T4A.3.1 — Install @angular-eslint
ng add @angular-eslint/schematics
```

ESLint is auto-configured by the schematic. Verify `.eslintrc.json` includes `@angular-eslint/recommended`.

#### 4.3.7 Prettier Configuration

```bash
# T4A.3.2 — Install Prettier
npm install -D prettier prettier-plugin-tailwindcss
```

```json
// .prettierrc
{
  "semi": true,
  "singleQuote": true,
  "trailingComma": "all",
  "printWidth": 100,
  "tabWidth": 2,
  "bracketSpacing": true,
  "arrowParens": "always",
  "plugins": ["prettier-plugin-tailwindcss"]
}
```

```text
# .prettierignore
dist/
node_modules/
coverage/
.angular/
```

Update `package.json` scripts:
```json
{
  "scripts": {
    "lint": "ng lint && prettier --check \"src/**/*.{ts,html,css,json}\"",
    "format": "prettier --write \"src/**/*.{ts,html,css,json}\""
  }
}
```

#### 4.3.8 Environment Files

```typescript
// src/environments/environment.ts
export const environment = {
  production: false,
  apiBaseUrl: 'http://localhost:8080/api',
};
```

```typescript
// src/environments/environment.prod.ts
export const environment = {
  production: true,
  apiBaseUrl: '/api',  // Nginx reverse proxy handles routing
};
```

#### 4.3.9 .editorconfig

```ini
# .editorconfig
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.{ts,html,css,json}]
indent_style = space
indent_size = 2

[*.md]
trim_trailing_whitespace = false
```

#### 4.3.10 Folder Structure

Create empty directories with `.gitkeep` files:

```bash
mkdir -p src/app/core src/app/shared src/app/features src/app/models src/assets/i18n
touch src/app/core/.gitkeep src/app/shared/.gitkeep src/app/features/.gitkeep src/app/models/.gitkeep src/assets/i18n/.gitkeep
```

### 4.4 API Contract

N/A — No API interaction in this spec.

### 4.5 Frontend Contract

N/A — No Angular components or services. This spec creates the project shell only.

---

## 5. Security Considerations

No security impact. This spec creates the project scaffold with no user-facing functionality, no API communication, and no authentication. Security-relevant components (JWT interceptor, auth guard) are created in SPEC-008B as stubs and completed in Phase 6.

---

## 6. Edge Cases & Error Handling

> No Gherkin features apply to this spec. Edge cases are CLI/tooling related.

| # | Scenario | Expected Behavior | Feature Ref |
|---|----------|-------------------|-------------|
| EC-1 | `ng new` fails due to existing files in repo | Use `--force` flag or clean directory first | N/A |
| EC-2 | `npm install` fails for a dependency | Verify Node.js 22.12.0, clear `node_modules` and `package-lock.json`, retry | N/A |
| EC-3 | Vitest config conflicts with Angular CLI defaults | Remove Karma-related packages (`@types/jasmine`, `karma`, etc.) from `package.json` | N/A |
| EC-4 | Tailwind CSS classes not applying | Verify `postcss.config.js` exists and `styles.css` has `@import "tailwindcss"` | N/A |
| EC-5 | PrimeNG components render with default styling | Verify unstyled mode is configured (done in SPEC-008B `app.config.ts`) | N/A |

---

## 7. Performance & Scalability Notes

No performance concerns. This is project setup — no runtime code.

---

## 8. Migration & Rollback Strategy

- **Rollback:** Delete the entire `sapcyti-spa` project and recreate from scratch. No data migration involved.
- **API backward compatibility:** N/A — no API endpoints.
- **Data migration:** N/A — no database.

---

## 9. Testing Strategy

| Test Type | Scope | Framework | Criteria |
|-----------|-------|-----------|----------|
| Build verification | `ng build --configuration production` compiles | Angular CLI | Zero errors |
| Lint verification | `npm run lint` passes | ESLint + Prettier | Zero errors/warnings |
| Test runner verification | `npm run test` executes | Vitest | Runs successfully (0 tests is acceptable) |
| Visual verification | Tailwind utility class applies | Manual | Class `bg-blue-500` renders blue background |

> **Referencia:** [`technologies/testing.md`](../../../technologies/testing.md) — Vitest replaces Jasmine/Karma
> **Coverage mínimo:** Not applicable in Phase 4A — no logic to cover

---

## 10. Conventions Checklist

- [ ] Angular project uses TypeScript strict mode
- [ ] No NgModules — Standalone Components architecture (verify `app.component.ts` is standalone)
- [ ] Tailwind CSS configured via PostCSS (no `@angular-builders/custom-webpack`)
- [ ] PrimeNG installed (unstyled mode configured in SPEC-008B)
- [ ] Vitest replaces Jasmine/Karma — all Karma packages removed
- [ ] ESLint uses `@angular-eslint/recommended` ruleset
- [ ] Prettier uses `prettier-plugin-tailwindcss` for class sorting
- [ ] `.editorconfig` uses 2-space indentation for TS/HTML/CSS
- [ ] Folder structure matches [`technologies/frontend.md §Folder Structure`](../../../technologies/frontend.md)
- [ ] Environment files use `apiBaseUrl` variable (no hardcoded URLs)
- [ ] No SCSS — plain CSS only

> **Referencia completa de convenciones:** [`progress.md` → Active Conventions](../../implementation/progress.md)

---

## 11. References

- **Architecture:** [`Architecture.md §5`](../../design/Architecture.md) — Container diagram (SPA container)
- **Architecture:** [`Architecture.md §6.2`](../../design/Architecture.md) — SPA component diagram
- **Technology Stack:** [`technologies/frontend.md`](../../../technologies/frontend.md) — Angular stack, dependencies, conventions
- **Technology Stack:** [`technologies/testing.md`](../../../technologies/testing.md) — Vitest as test runner
- **Implementation Plan:** [`implementationPlan.md`](../../implementation/implementationPlan.md) — Phase 4A definition
- **Phase Tasks:** [`phase4a.md`](../../implementation/phase4a.md) — Task map for this spec
- **Blocked Spec:** [SPEC-008B](SPEC-008B_spa-core-providers-shell-i18n.md) — SPA Core Providers, Shell & i18n

---

## 12. Review Log

| Date | Reviewer | Action | Notes |
|------|----------|--------|-------|
| — | — | — | — |
