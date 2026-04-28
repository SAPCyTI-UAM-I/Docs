# DevOps & Deployment — SAPCyTI

> **Fuente de verdad** para CI/CD, Docker, y estrategia de despliegue.
> Referenciado desde specs y [`progress.md`](../../implementations/progress.md).

---

## Branching Strategy

| Branch | Purpose | Merge Target |
|--------|---------|-------------|
| `main` | Production-ready code | — |
| `develop` | Integration branch | `main` (via release) |
| `feature/{spec-id}-{description}` | Feature development | `develop` |
| `release/{version}` | Release preparation | `main` + `develop` |
| `hotfix/{description}` | Production fixes | `main` + `develop` |

### Commit Convention

- **Format:** Conventional Commits — enforced by commitlint + husky
- **Pattern:** `{type}({scope}): SPEC-{NNN} {description}`
- **Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `ci`
- **Scope:** bounded context name (`configuration`, `identity`, `academic`, `offering`, `enrollment`)

Examples:
```
feat(configuration): SPEC-001 implement GraduateProgram aggregate root
fix(identity): SPEC-010 handle expired JWT gracefully
test(academic): SPEC-015 add RegisterStudentUseCase unit tests
```

---

## CI/CD Pipeline (GitHub Actions)

### PR Validation (on pull_request → develop)

#### Backend (`sapcyti-api`)
```
Job 1: Lint         → mvn checkstyle:check
Job 2: Build & Test → mvn clean verify (includes JaCoCo ≥80%)
Job 3: Security     → OWASP Dependency-Check (continue-on-error)
```

#### Frontend (`sapcyti-spa`)
```
Job 1: Lint     → npm run lint (ESLint)
Job 2: Test     → ng test --watch=false --code-coverage (≥80%)
Job 3: Audit    → npm audit
Job 4: Build    → ng build --configuration production
```

### Merge & Deploy (on push → main)

```
1. Build & Test → same as PR validation
2. Docker Build → multi-stage Dockerfile
3. Push Image   → GitHub Container Registry (GHCR)
4. Deploy       → SSH to on-premise server (post-Iteration 2)
```

---

## Docker

### Backend Dockerfile (multi-stage)

```
Stage 1: Maven build with dependency caching
Stage 2: JRE 21 runtime, expose 8080
HEALTHCHECK: curl -f http://localhost:8080/actuator/health
```

### Frontend Dockerfile (multi-stage)

```
Stage 1: npm ci + ng build --configuration production
Stage 2: Nginx serving static assets from dist/
```

### Docker Compose Stack

| Service | Image | Port | Depends On |
|---------|-------|------|------------|
| `nginx` | Custom (SPA + reverse proxy) | 80 | `api` |
| `api` | Custom (Spring Boot) | 8080 | `db` (health) |
| `db` | `postgres:16` | 5432 | — |

### Compose Files

| File | Purpose |
|------|---------|
| `docker-compose.dev.yml` | Local development (PostgreSQL only) |
| `docker-compose.yml` | Full stack (Nginx + API + DB) |
| `.env.dev` | Environment variables for local dev |
| `.env.preprod` | Pre-production variables |
| `.env.prod` | Production variables (on server only) |

### Cloud-Ready Rules (QA-5)

| Rule | Description |
|------|-------------|
| **Environment variables** | All config via env vars — never hardcoded |
| **No local paths** | Docker volumes for persistent data |
| **Portable images** | Multi-stage builds, same image for all environments |
| **Health checks** | Actuator endpoints for Docker HEALTHCHECK |
| **Versioned migrations** | Flyway manages schema — no manual SQL |
| **Structured logs** | JSON logging compatible with aggregators |

---

## Deployment Environments

| Stage | Infrastructure | When |
|-------|---------------|------|
| **Development** | Local Docker (docker-compose.dev.yml) | Phases 0–5 |
| **Pre-production** | On-premise Linux server (namespaced Compose) | Post-Iteration 2 |
| **Production** | On-premise Linux server | Go-live |

### On-Premise Server Specs (CON-2)

| Resource | Specification |
|----------|--------------|
| OS | Linux |
| Storage | 16 TB |
| RAM | 32 GB |
| Container runtime | Docker + Docker Compose |

### What Changes per Environment

| Component | Local Docker | On-Premise |
|-----------|-------------|------------|
| PostgreSQL | Container with local volume | Container with named volume |
| API Server | Container on `localhost:8080` | Namespaced Compose project |
| SPA | `ng serve` dev server | Static build via Nginx |
| Secrets | Local `.env` | `.env.{env}` on server |
| TLS | Optional | Nginx TLS termination |
| Monitoring | Actuator only | VictoriaMetrics + Grafana |

---

## Secrets Management

| Secret | Local | CI | Production |
|--------|-------|----|------------|
| `DB_URL` | `.env` file | GitHub Secrets | `.env.prod` on server |
| `DB_USER` | `.env` file | GitHub Secrets | `.env.prod` on server |
| `DB_PASS` | `.env` file | GitHub Secrets | `.env.prod` on server |
| `GHCR_TOKEN` | N/A | GitHub Secrets (T0.5.5) | N/A |
| JWT RSA keys | Local files | GitHub Secrets | Mounted volume |

> **Rule:** Never commit secrets. `.env` files are in `.gitignore`. Use `.env.example` as template.
