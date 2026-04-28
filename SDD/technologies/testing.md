# Testing Strategy & Tools — SAPCyTI

> **Fuente de verdad** para la estrategia de testing del proyecto.
> Referenciado desde specs y [`progress.md`](../../implementations/progress.md).

---

## Coverage Requirements

| Area | Tool | Minimum | Enforcement |
|------|------|---------|-------------|
| Backend | JaCoCo | ≥80% line coverage | CI pipeline, `jacoco-maven-plugin` |
| Frontend | istanbul/nyc | ≥80% line coverage | CI pipeline, `ng test --code-coverage` |

---

## Backend Testing

### Test Pyramid

| Level | Scope | Framework | Annotations | When to Use |
|-------|-------|-----------|-------------|-------------|
| **Unit** | Domain model, domain services | JUnit 5 + AssertJ | `@DataJpaTest` if persistence needed | Invariants, business logic, value objects |
| **Unit + Mock** | Use cases (application layer) | JUnit 5 + Mockito | `@ExtendWith(MockitoExtension.class)` | Orchestration logic, port interactions |
| **Adapter** | Repository adapters | JUnit 5 + Spring | `@DataJpaTest` | DB queries, repository port implementations |
| **Controller** | REST endpoints | JUnit 5 + Spring | `@WebMvcTest` + MockMvc | Request validation, response format, HTTP status |
| **Integration** | Full slice | JUnit 5 + Spring | `@SpringBootTest` + Testcontainers | Cross-layer flows, Flyway migrations |

### Naming Conventions

| Test Type | Class Name | Method Name |
|-----------|-----------|-------------|
| Unit | `{Class}Test` | `should{ExpectedBehavior}_when{Condition}` |
| Integration | `{Class}IT` | `should{ExpectedBehavior}_when{Condition}` |

### Rules

- **Domain tests:** JUnit 5 for logic/invariants; `@DataJpaTest` when testing persistence behavior
- **Use case tests:** Mock ALL output ports with Mockito — never use real DB
- **Adapter tests:** Use `@DataJpaTest` with embedded DB or Testcontainers — never `@SpringBootTest`
- **Controller tests:** Use `@WebMvcTest` + `MockMvc` — mock use case input ports
- **No `@SpringBootTest` for unit tests** — too slow, too broad
- **Testcontainers** for PostgreSQL integration tests (Flyway migrations, complex queries)

### Example Structure

```text
src/test/java/mx/uam/sapcyti/
├── configuration/
│   ├── domain/
│   │   └── model/
│   │       └── GraduateProgramTest.java          # Unit — invariants
│   ├── application/
│   │   └── service/
│   │       └── GetGraduateProgramUseCaseTest.java # Unit + Mockito
│   └── infrastructure/
│       ├── adapter/out/
│       │   └── GraduateProgramJpaAdapterIT.java   # @DataJpaTest
│       └── adapter/in/
│           └── GraduateProgramControllerIT.java   # @WebMvcTest
```

---

## Frontend Testing

### Test Types

| Level | Scope | Framework | When to Use |
|-------|-------|-----------|-------------|
| **Unit** | Services, pipes, utils | Jasmine + Karma | Business logic in services |
| **Component** | Isolated component | Jasmine + Karma + TestBed | Template rendering, event binding |
| **Integration** | Component + service | Jasmine + Karma + TestBed + HttpClientTestingModule | HTTP interactions, state changes |

### Rules

- **Services:** Test with `TestBed.configureTestingModule` — mock HttpClient with `HttpClientTestingModule`
- **Components:** Test with `ComponentFixture` — mock services with `jasmine.createSpyObj`
- **No E2E in MVP** — consider Cypress/Playwright post-Iteration 5
- **All user-facing text** tested via i18n keys, not hardcoded strings

### Naming Conventions

| Test Type | File Name |
|-----------|-----------|
| Unit/Component | `{name}.component.spec.ts` or `{name}.service.spec.ts` |

---

## CI Integration

> Ref: [`technologies/devops.md`](devops.md) for CI pipeline details.

### Backend CI Steps
1. `mvn checkstyle:check` — code style
2. `mvn test` — all tests
3. `mvn jacoco:report` — coverage report
4. Coverage gate: ≥80% or pipeline fails
5. `mvn org.owasp:dependency-check-maven:check` — CVE scan (`continue-on-error`)

### Frontend CI Steps
1. `npm run lint` — ESLint
2. `ng test --watch=false --code-coverage` — all tests + coverage
3. Coverage gate: ≥80% or pipeline fails
4. `npm audit` — dependency vulnerability scan
