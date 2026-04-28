# Backend Technology Stack — SAPCyTI

> **Fuente de verdad** para versiones, librerías y reglas del backend.
> Referenciado desde specs y [`progress.md`](../../implementations/progress.md).

---

## Runtime

| Component | Version | Notes |
|-----------|---------|-------|
| **Java** | 21 (LTS) | `JAVA_HOME` requerido |
| **Spring Boot** | 3.4.5 | Starter parent en `pom.xml` |
| **Maven** | 3.9+ | Build tool; wrapper incluido (`mvnw`) |

## Core Dependencies

| Library | Artifact | Purpose |
|---------|----------|---------|
| Spring Web | `spring-boot-starter-web` | REST API, embedded Tomcat |
| Spring Data JPA | `spring-boot-starter-data-jpa` | Repository abstraction, JPA |
| Spring Validation | `spring-boot-starter-validation` | Bean Validation (`@Valid`, `@NotBlank`) |
| Spring Actuator | `spring-boot-starter-actuator` | Health checks, metrics, info |
| Hibernate | 6.x (managed by Spring Boot) | ORM |
| PostgreSQL JDBC | `postgresql` | Database driver |
| Flyway | `flyway-core`, `flyway-database-postgresql` | Versioned DB migrations |
| MapStruct | `mapstruct` + `mapstruct-processor` | Compile-time DTO ↔ Domain mapping (Request/Response ↔ Domain) |

## Observability

| Library | Artifact | Purpose |
|---------|----------|---------|
| SLF4J + Logback | Managed by Spring Boot | Logging facade + implementation |
| Logstash Logback Encoder | `logstash-logback-encoder` | Structured JSON logging in `preprod`/`prod` |
| Micrometer | Managed by Actuator | Metrics export (Prometheus format) |

## Security (Iteration 3+)

| Library | Artifact | Purpose |
|---------|----------|---------|
| Spring Security | `spring-boot-starter-security` | Authentication, authorization |
| JJWT | `jjwt-api`, `jjwt-impl`, `jjwt-jackson` | JWT generation/validation (RSA-256) |
| BCrypt | Managed by Spring Security | Password hashing |

## Build Plugins

| Plugin | Purpose | Config |
|--------|---------|--------|
| `spring-boot-maven-plugin` | Executable JAR, build info | Default |
| `maven-compiler-plugin` | Java 21, MapStruct annotation processor | Source/target 21 |
| `jacoco-maven-plugin` | Code coverage | ≥80% line coverage |
| `maven-checkstyle-plugin` | Code style enforcement | Google Java Style, 150-char lines |

## Security Scanning

| Tool | Purpose | CI Behavior |
|------|---------|-------------|
| OWASP Dependency-Check | CVE scanning | `continue-on-error: true` (D-004) |

---

## Architecture Rules

> These rules are **mandatory** for all backend code. Violations break the hexagonal architecture.

### Package Structure

Every bounded context module follows this layout (ref: [`Architecture.md §6.1`](../../Design/Architecture.md)):

```text
{module}/
├── domain/
│   ├── model/          # AR, Entity, VO — with JPA annotations (@Entity, @Id, etc.)
│   ├── service/        # Domain services
│   ├── port/in/        # Input port interfaces — use case contracts
│   └── port/out/       # Output port interfaces — infrastructure contracts
├── application/
│   └── service/        # Use case implementations — @Service, inject ports
└── infrastructure/
    ├── adapter/in/     # Driving adapters — @RestController, DTOs
    │   └── dto/        # Request/Response DTOs
    ├── adapter/out/    # Driven adapters — @Repository, implements output ports
    ├── mapper/         # MapStruct mappers (DTO ↔ Domain)
    ├── acl/            # Anti-Corruption Layers (CSV, PDF, export)
    └── security/       # Security filters (Identity module only)
```

### Dependency Rules

```
adapter/in  →  application  →  domain  ←  adapter/out
               (imports)       (center)    (implements)
```

- **domain** can use JPA annotations (`jakarta.persistence.*`); avoids Spring-specific imports
- **application** imports domain ports; annotated with `@Service`
- **adapter/in** imports application input ports; annotated with `@RestController`
- **adapter/out** implements domain output ports; annotated with `@Repository`
- **Cross-module:** via output ports only; ID-based references; single transaction

### Naming Conventions

| Artifact | Convention | Example |
|----------|-----------|---------|
| Domain model | Class name = DDD concept, annotated with `@Entity` | `GraduateProgram`, `ConfigurationParameter` |
| Repository port | Domain name + `RepositoryPort` | `GraduateProgramRepositoryPort` |
| JPA adapter | Domain name + `JpaAdapter` | `GraduateProgramJpaAdapter` |
| Input port | UseCase name + `InputPort` | `RegisterStudentInputPort` |
| Use case | UseCase name + `UseCase` | `RegisterStudentUseCase` |
| Controller | Domain name + `Controller` | `StudentController` |
| Mapper | Domain name + `Mapper` | `StudentMapper` |
| DTO request | Domain name + `Request` | `RegisterStudentRequest` |
| DTO response | Domain name + `Response` | `StudentResponse` |
| Migration | `V{N}__{description}.sql` | `V1__create_graduate_programs.sql` |

### Configuration

- All external config via **environment variables** (Factor III)
- Profiles: `dev` (local), `preprod`, `prod`
- Key env vars: `DB_URL`, `DB_USER`, `DB_PASS`, `SPRING_PROFILES_ACTIVE`, `CORS_ALLOWED_ORIGINS`
- MDC fields: `graduate_program_id`, `user_id`, `request_id`

### Multi-Tenant

- Header: `X-Graduate-Id` → `TenantFilter` → `TenantContext` (ThreadLocal) → MDC
- All queries scoped by `graduate_program_id` where applicable (QA-4)
- Decision D-008: `TenantFilter` in `shared/tenant` package
