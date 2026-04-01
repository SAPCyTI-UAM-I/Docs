### 1.- Introduction

This document describes the software architecture of the SAPCyTI system (Graduate Management Portal for Information Sciences and Technologies, PCyTI-UAM). It includes the system context, architectural drivers, domain model, container and component decomposition, main interfaces, and design decisions resulting from the Attribute-Driven Design (ADD) process, starting from Iteration 1 and subsequent iterations.

### 2.- Context diagram

The following diagram represents SAPCyTI as a black box and shows the **actors** (user types) and **external systems** with which it interacts. The five user types (Coordinator, Professor, Student, Assistant, Applicant) access the system via a browser; external systems include School Control Systems, the graduate program's WordPress site, Conacyt/SNP, the email server, and UAM institutional systems.

```mermaid
flowchart LR
    subgraph Users
        COORD["Graduate Coordinator"]
        PROF["Professor / Advisor"]
        ALUM["Student"]
        ASIS["Administrative Assistant"]
        ASP["Applicant"]
    end

    SAPCYTI[["SAPCyTI\nGraduate Management\nWeb Portal"]]

    subgraph External Systems
        SCE["UAM School Control\nSystems"]
        WP["Graduate WordPress\nWebsite"]
        SNP["Conacyt / SNP"]
        CORREO["Email Server"]
        SAP["UAM Institutional\nSystems"]
    end

    COORD -- "Manages planning,\nenrollment, students\nand professors" --> SAPCYTI
    PROF -- "Approves enrollments,\nregisters seminars,\nuploads work products" --> SAPCYTI
    ALUM -- "Selects courses,\nuploads evidence" --> SAPCYTI
    ASIS -- "Generates invitations,\ncertificates and\nenrollment forms" --> SAPCYTI
    ASP -- "Uploads documents\nfor admission" --> SAPCYTI

    SAPCYTI -- "Exports TXT / XLSX\nfiles" --> SCE
    SAPCYTI -- "Publishes information\nvia REST API" --> WP
    SAPCYTI -- "Generates reports\nand evidence packages" --> SNP
    SNP -- "Imports generated\nreports" --> SAPCYTI
    SAPCYTI -- "Sends notifications\nand invitations" --> CORREO
    SAP -- "Imports institutional\ndata" --> SAPCYTI
```

### 3.- Architectural drivers

The architectural drivers were taken from [ArchitecturalDrivers.md](../ArchitecturalDrivers.md). For the MVP, user stories comprising the enrollment flow and entity management are prioritized; Iteration 1 emphasizes constraints and quality attributes with the greatest structural impact (parameterization and multi-graduate program support).

#### User stories (MVP)

| ID | User Story |
| --- | ------------------- |
| **HU-01** | As a system user, I want to log in using a username and password to access the main screen with the options corresponding to my user type. |
| **HU-06** | As a Coordinator, I want to select a term and upload the CSV file for schedules and lotteries to enable enrollment so that students can view available courses. |
| **HU-07** | As a Student, I want to access the enrollment module to select the courses I will take during the term. |
| **HU-08** | As a Professor/Advisor, I want to review the UEAs my students have selected and formally authorize their enrollment. |
| **HU-09** | As a Coordinator or Assistant, I want to generate the enrollment form in PDF for an approved student to formalize the registration with School Systems. |
| **HU-15** | As a Coordinator, I want to register a student with their personal and academic data. |
| **HU-21** | As a Coordinator, I want to register a professor in the system. |

#### Quality attributes

| ID | Quality Attribute | Scenario |
| --- | ------------------- | --------- |
| **QA-1** | Security — Role-based access control | Restrict functions according to user type (Coordinator, Professor, Student, Assistant, Speaker). |
| **QA-2** | Security — CWE Top 25 Protection | Not be vulnerable to SQL injection, XSS, CSRF, etc. |
| **QA-3** | Modifiability — Parameterization | Changes in rules (dates, quotas, criteria) in a single configuration point without modifying code. |
| **QA-4** | Scalability — Multi-graduate program support | Adapt to up to 9 graduate programs with their own rules without structural changes in the core. |
| **QA-5** | Portability — Cloud migration | Facilitate future migration from on-premise → cloud without significant rewriting. |
| **QA-6** | Usability — Internationalization | Present the interface in Spanish and English. |

#### Constraints

| ID | Constraint |
| --- | ----------- |
| **CON-1** | Back-end in **Java**, exclusively **Open Source** libraries. |
| **CON-2** | Initial deployment **on-premise**: Linux, 16 TB storage, 32 GB RAM. |
| **CON-3** | Export to School Systems in **TXT or XLSX** format. |
| **CON-4** | **Asynchronous** integration with the graduate program's **WordPress** website. |
| **CON-5** | Flows with external institutional validation must not force rigid rules; the final decision rests with the graduate commission. |
| **CON-6** | Development by **undergraduate students** with short internships and incremental iterations. |
| **CON-7** | Accessible from **Chrome 130, Safari 22, Firefox 129** and responsive for tablets and phones. |

### 4.- Domain model

The domain model was derived by applying Domain-Driven Design (DDD) based on the primary functional requirements of the MVP (HU-01, HU-06, HU-07, HU-08, HU-09, HU-15, HU-21), the quality attributes QA-3 (business rule parameterization) and QA-4 (multi-graduate program support), and the security cross-cutting concerns QA-1 (RBAC) and QA-2 (CWE Top 25 protection) introduced in Iteration 3. The following DDD building blocks were identified:

  - **Aggregate Root (AR):** Root entity that ensures the transactional consistency of its aggregate. It is the only point of external access to the aggregate.
  - **Entity (E):** Object with its own identity that exists within the boundaries of an aggregate and is managed by its Aggregate Root.
  - **Value Object (VO):** Immutable object without its own identity, defined exclusively by its attributes.

Composition relationships (filled diamond) represent objects that belong to the lifecycle of their aggregate. Directed associations (arrow) represent references between different aggregates.


```mermaid
classDiagram

    class GraduateProgram {
        <<Aggregate Root>>
        +Long id
        +String name
        +String division
    }

    class ConfigurationParameter {
        <<Value Object>>
        +String key
        +String value
        +String description
    }

    class User {
        <<Aggregate Root>>
        +Long id
        +String email
        +String passwordHash
        +Boolean active
    }

    class Role {
        <<Value Object>>
        +RoleType type
    }

    class RefreshToken {
        <<Entity>>
        +Long id
        +String tokenHash
        +Instant expiresAt
        +Boolean revoked
        +String deviceInfo
    }

    class PasswordResetToken {
        <<Value Object>>
        +String tokenHash
        +Instant expiresAt
        +Boolean used
    }

    class AuditEvent {
        <<Aggregate Root>>
        +Long id
        +Instant timestamp
        +Long actorId
        +RoleType actorRole
        +String action
        +String entityType
        +Long entityId
        +String details
        +AuditSeverity severity
        +String ipAddress
        +Long graduateProgramId
    }

    class AuditSeverity {
        <<Value Object>>
        +AuditSeverityLevel level
    }

    class Student {
        <<Aggregate Root>>
        +Long id
        +String enrollmentId
    }

    class PersonalData {
        <<Value Object>>
        +String firstName
        +String firstLastName
        +String secondLastName
        +String nationality
    }

    class AcademicInformation {
        <<Value Object>>
        +String undergraduateDegree
        +ProgramType programType
        +Date admissionDate
    }

    class Professor {
        <<Aggregate Root>>
        +Long id
        +String employeeNumber
    }

    class Term {
        <<Aggregate Root>>
        +Long id
        +String code
        +TermStatus status
    }

    class AcademicOffer {
        <<Aggregate Root>>
        +Long id
    }

    class UEAGroup {
        <<Entity>>
        +Long id
        +String groupCode
        +Integer quota
    }

    class Schedule {
        <<Value Object>>
        +DayOfWeek day
        +LocalTime startTime
        +LocalTime endTime
    }

    class UEA {
        <<Aggregate Root>>
        +Long id
        +String code
        +String name
        +Integer credits
    }

    class Enrollment {
        <<Aggregate Root>>
        +Long id
        +EnrollmentStatus status
        +Date creationDate
    }

    class UEASelection {
        <<Entity>>
        +Long id
        +Boolean preselected
        +Boolean approvedByAdvisor
    }

    class EnrollmentForm {
        <<Entity>>
        +Long id
        +Date generationDate
        +Boolean printed
    }

    GraduateProgram "1" *-- "*" ConfigurationParameter

    User "1" *-- "1" Role
    User "1" *-- "0..*" RefreshToken
    User "1" *-- "0..1" PasswordResetToken

    AuditEvent "*" --> "1" User : actor
    AuditEvent "1" *-- "1" AuditSeverity

    Student "1" --> "1" User
    Student "1" *-- "1" PersonalData
    Student "1" *-- "1" AcademicInformation
    Student "*" --> "1" GraduateProgram
    Student "*" --> "1" Professor : advised by

    Professor "1" --> "1" User
    Professor "1" *-- "1" PersonalData

    Term "*" --> "1" GraduateProgram

    AcademicOffer "1" --> "1" Term
    AcademicOffer "1" *-- "*" UEAGroup

    UEAGroup "*" --> "1" UEA
    UEAGroup "*" --> "1" Professor : taught by
    UEAGroup "1" *-- "*" Schedule

    Enrollment "*" --> "1" Student
    Enrollment "*" --> "1" Term
    Enrollment "1" *-- "*" UEASelection
    Enrollment "1" *-- "0..1" EnrollmentForm

    UEASelection "*" --> "1" UEAGroup
```

#### Description of domain model elements

| Element | DDD Type | Description |
| :--- | :--- | :--- |
| **GraduateProgram** | Aggregate Root | Represents a UAM graduate program. Contains the parametric configuration of business rules, enabling the multi-graduate program support required by QA-4. |
| **ConfigurationParameter** | Value Object | Immutable key-value pair that externalizes a business rule of the graduate program. Allows modifying dates, quotas, and criteria without changing source code, in response to QA-3. |
| **User** | Aggregate Root | System access account. Stores credentials and activation status. Serves as the authentication identity for all system actors, per HU-01. |
| **Role** | Value Object | User type assigned to an account: COORDINATOR, PROFESSOR, STUDENT, ASSISTANT, SPEAKER, or SYSTEM_ADMIN. Determines menu options and visible permissions after login, per QA-1. Role hierarchy: SYSTEM_ADMIN > COORDINATOR > ASSISTANT > PROFESSOR > STUDENT > SPEAKER (pending PO validation). |
| **Student** | Aggregate Root | Student enrolled in a graduate program. Aggregates personal data and academic information and maintains a reference to their faculty advisor. Derived from HU-15. |
| **PersonalData** | Value Object | Identity data of a person: first name, last names, and nationality. Shared by the Student and Professor aggregates. |
| **AcademicInformation** | Value Object | Data from the student's academic program: original undergraduate degree, graduate program type, and admission date. Derived from HU-15. |
| **Professor** | Aggregate Root | Academic staff member who teaches courses and advises students. Identified by their institutional employee number. Derived from HU-21. |
| **Term** | Aggregate Root | Academic period with an identifying code and a lifecycle with statuses: PLANNING, IN\_ENROLLMENT, IN\_PROGRESS, and COMPLETED. The coordinator activates it by uploading the academic offer, per HU-06. |
| **AcademicOffer** | Aggregate Root | Set of UEA groups offered in a specific term. Created when processing the CSV file of schedules and lotteries uploaded by the coordinator in HU-06. |
| **UEAGroup** | Entity | Specific section of a UEA within the quarterly offer. Defines the group code, available quota, assigned professor, and schedules. It is the unit selectable by students in HU-07. |
| **Schedule** | Value Object | Time block assigned to a group: day of the week, start time, and end time. Derived from information shown to the student in HU-07. |
| **UEA** | Aggregate Root | Teaching-Learning Unit (Unidad de Enseñanza-Aprendizaje) from the academic catalog. Defines the code, name, and credits of a course. It is independent of any particular term or offer. |
| **Enrollment** | Aggregate Root | Process of a student enrolling in a specific term. Manages the complete lifecycle: course selection by the student in HU-07, approval by the advisor in HU-08, and generation of the official form in HU-09. Its statuses are: PENDING\_SELECTION, SELECTION\_COMPLETED, APPROVED\_BY\_ADVISOR, and FORM\_GENERATED. |
| **UEASelection** | Entity | Record of the choice of a specific UEA group within an enrollment. Indicates if it was automatically preselected by the system and if it was approved by the advisor. Derived from HU-07 and HU-08. |
| **EnrollmentForm** | Entity | PDF document generated as a result of the approved enrollment: the "UEA Request" delivered to School Systems. Records the generation date and if it has already been printed. Derived from HU-09. |
| **AuditEvent** | Aggregate Root | Records a system event for compliance and traceability. Captures the actor, action, target entity, severity, and context (including graduate program for multi-tenant filtering). Supports general-purpose auditing with enhanced verbosity for security events. Derived from C003.2.2 (Iteration 3). |
| **AuditSeverity** | Value Object | Enum indicating audit event importance: HIGH (security events — login, RBAC violations), STANDARD (domain mutations — entity CRUD), LOW (read operations — configurable per environment). |
| **RefreshToken** | Entity | Persisted refresh token within the User aggregate. Stores only the token hash (SHA-256) for security. Supports "Remember me" via configurable TTL (7 days default, 30 days for remember-me) and concurrent session awareness via device tracking (C003.2.3). Derived from HU-01 (Iteration 3). |
| **PasswordResetToken** | Value Object | Time-limited token for password recovery flow. Stores a hashed token with an expiry timestamp and a usage flag. Pattern established in Iteration 3; full implementation in Iteration 4 (HU-02). |

### 5.- Container diagram

The system is decomposed into two main containers within the SAPCyTI boundary: the **SPA** (Angular) running in the user's browser, and the **Backend API** (Java 21, Spring Boot) serving the REST API and hosting the business logic. Persistence is handled in **PostgreSQL**. Integrations with WordPress, School Systems, and other external systems are performed by the Backend API.

```mermaid
flowchart TB
    subgraph Users
        User["User\nbrowser"]
    end

    subgraph SAPCyTI["SAPCyTI"]
        SPA["SAPCyTI SPA\nAngular"]
        API["SAPCyTI Backend API\nSpring Boot"]
        DB[("PostgreSQL\nDatabase")]
    end

    subgraph Externals["External systems"]
        WP["WordPress"]
        SCE["School Systems"]
        CORREO["Email"]
    end

    User <-->|HTTPS / UI consumption| SPA
    SPA <-->|REST / JSON + JWT Bearer| API
    API <-->|SQL| DB
    API -.->|Async REST| WP
    API -->|TXT / XLSX| SCE
    API -->|Notifications| CORREO
```

#### Container Responsibilities

| Container | Responsibilities |
| ---------- | ----------------- |
| **SAPCyTI SPA** | Provide the user interface in the browser; routing and views by role; consumption of the REST API; sending tenant context (graduate program) in requests; manage authentication state (access token in memory, refresh token via HttpOnly cookie); role-based route protection via AuthGuard; compatibility with required browsers and responsive designs (CON-7). |
| **SAPCyTI Backend API** | Expose the REST API (JSON); JWT-based stateless authentication and RBAC enforcement via Spring Security; multi-tenant context (Graduate Program); business logic and orchestration; reading configuration parameters per graduate program; persistence and data access; audit logging for security events and domain mutations; generation of TXT/XLSX export; asynchronous integration with WordPress. |
| **PostgreSQL Database** | Store domain data, configuration parameters per graduate program, multi-tenant data, audit events, and refresh tokens; ensure transactional consistency. |

At runtime, these logical containers are deployed according to the **deployment view** (section 7): the Backend API and database as Docker containers, and the SPA as static assets served by the Nginx container.

### 6.- Component diagrams

#### 6.1.- SAPCyTI Backend API

The Backend API is structured as a **modular monolith**, following **Hexagonal Architecture (Ports & Adapters)** and **DDD principles**. The domain layer sits at the center with zero dependencies on infrastructure. Port interfaces define the contracts through which the domain communicates with external concerns. Infrastructure adapters implement these ports, keeping the domain framework-agnostic and testable in isolation. Each bounded context module follows the same hexagonal structure internally. In Iteration 3, the security cross-cutting concern was instantiated as a **Security Filter Chain** in the driving adapters layer (before REST Controllers), a **JWT Service** in the application layer, and audit/security-related driven adapters.

```mermaid
flowchart TB
    subgraph API["SAPCyTI Backend API - Modular Monolith"]
        subgraph Adapters_In["Driving Adapters - Infrastructure In"]
            SECCHAIN["Security Filter Chain\nSpring Security"]
            JWTFILT["JWT Authentication Filter\nToken extraction and validation"]
            REST["REST Controllers\nHTTP entry point"]
        end

        subgraph Application["Application Layer"]
            USECASES["Use Cases\nApplication Services"]
            JWTSVC["JWT Service\nToken generation, validation, refresh"]
            AUDITASP["Audit Aspect\nAOP security event capture"]
        end

        subgraph Domain["Domain Layer - Hexagonal Core"]
            AGG["Aggregates, Entities\nValue Objects"]
            DOMSVC["Domain Services"]
            PORTS_IN["Input Ports\nUse case interfaces"]
            PORTS_OUT["Output Ports\nRepository, security, audit interfaces"]
        end

        subgraph Adapters_Out["Driven Adapters - Infrastructure Out"]
            JPA["JPA Repositories\nPostgreSQL"]
            CONFSVC["Configuration Adapter\nParameter store"]
            EXPSVC["Export Adapter\nTXT / XLSX - Apache POI"]
            WPCLIENT["WordPress Adapter\nAsync HTTP client"]
            FLYWAY["Flyway\nDB migrations"]
            PWDENC["Password Encoder Adapter\nBCrypt"]
            AUDITADP["Audit Adapter\nJPA + EntityListeners"]
            FILEACC["File Access Service\nHMAC signed URLs"]
        end
    end

    SECCHAIN --> JWTFILT
    JWTFILT --> REST
    REST --> USECASES
    USECASES --> JWTSVC
    USECASES --> PORTS_IN
    PORTS_IN --> AGG
    PORTS_IN --> DOMSVC
    USECASES --> PORTS_OUT
    AUDITASP -.-> PORTS_OUT
    PORTS_OUT --> JPA
    PORTS_OUT --> CONFSVC
    PORTS_OUT --> EXPSVC
    PORTS_OUT --> WPCLIENT
    PORTS_OUT --> PWDENC
    PORTS_OUT --> AUDITADP
    PORTS_OUT --> FILEACC
```

| Component | Responsibilities |
| ---------- | ----------------- |
| **Security Filter Chain** (Driving Adapter) | Spring Security `SecurityFilterChain` bean; first component in the HTTP request pipeline; applies URL-pattern security rules (default-deny, whitelist `/api/auth/**`); configures security headers (CSP, X-Frame-Options, X-Content-Type-Options); manages CORS policy (allowed origins from env vars, Factor III); enforces `SessionCreationPolicy.STATELESS` (Factor VI). |
| **JWT Authentication Filter** (Driving Adapter) | Custom `OncePerRequestFilter`; extracts JWT from `Authorization: Bearer` header; validates signature using RSA public key; populates Spring `SecurityContext` with user identity, role, and tenant. Passes through to REST Controllers on success; returns 401 on invalid/expired token. |
| **REST Controllers** (Driving Adapter) | Receive authenticated HTTP requests; validate input via Bean Validation (`@Valid`); enforce method-level RBAC via `@PreAuthorize` + SpEL; delegate to use cases via input ports; return JSON responses. |
| **Use Cases / Application Services** | Orchestrate business operations; coordinate aggregates and domain services through input ports; invoke output ports for persistence, configuration, export, WordPress integration, and audit logging. |
| **JWT Service** (Application Layer) | Generate access tokens (RSA-256 signed, 15 min TTL) and refresh tokens (opaque, hashed with SHA-256, 7/30 day TTL); validate and refresh tokens; revoke refresh tokens on logout. Token TTLs and RSA key paths externalized via environment variables (Factor III). |
| **Audit Aspect** (Application Layer) | AOP aspect intercepting authentication and authorization methods; captures security events (LOGIN_SUCCESS, LOGIN_FAILURE, RBAC_VIOLATION, TOKEN_REFRESH) at HIGH severity; delegates to Audit Adapter via output port. |
| **Aggregates, Entities, Value Objects** (Domain) | Core business model as defined in the domain model (§4) including AuditEvent, RefreshToken, and PasswordResetToken; business rules; invariant enforcement. Zero dependencies on infrastructure. |
| **Domain Services** (Domain) | Complex business logic spanning multiple aggregates; domain event handling. |
| **Input Ports** (Domain) | Interfaces defining use case contracts. Implemented by the application layer. |
| **Output Ports** (Domain) | Interfaces defining contracts for persistence, configuration, export, integration, password encoding (`PasswordEncoderPort`), audit logging (`AuditOutputPort`), and file access (`FileAccessPort`). Implemented by driven adapters. |
| **JPA Repositories** (Driven Adapter) | Implement output ports for data access; access PostgreSQL; filtering by tenant (graduate\_program\_id) where applicable. |
| **Configuration Adapter** (Driven Adapter) | Implement output port for reading configuration parameters per Graduate Program; support for QA-3 and QA-4. |
| **Export Adapter** (Driven Adapter) | Implement output port for generating TXT and XLSX files for School Systems (CON-3); uses Apache POI. |
| **WordPress Adapter** (Driven Adapter) | Implement output port for asynchronous HTTP calls to WordPress (CON-4); retries and error handling. |
| **Flyway** (Infrastructure) | SQL-based database schema versioning; migrations run on application startup (Factor XII); scripts in `db/migration/`. |
| **Password Encoder Adapter** (Driven Adapter) | Implements `PasswordEncoderPort`; wraps Spring Security's `BCryptPasswordEncoder` with configurable work factor (default 12, via env var). Isolates the domain from the concrete hashing algorithm. |
| **Audit Adapter** (Driven Adapter) | Implements `AuditOutputPort`; persists `AuditEvent` entities to PostgreSQL; integrates with JPA `@EntityListeners` for domain mutation events at STANDARD severity; writes structured audit log entries to stdout (Factor XI) in addition to database persistence. |
| **File Access Service** (Driven Adapter) | Implements `FileAccessPort`; generates HMAC-SHA256 signed, time-limited URLs for file download; validates signatures with constant-time comparison; streams files via `StreamingResponseBody`. HMAC key externalized (Factor III). |

#### 6.2.- SAPCyTI SPA (Angular)

The SPA is organized into a shell, feature modules, core services (authentication, HTTP, tenant context), and shared components. In Iteration 3, the Core module was refined to explicitly define the authentication and authorization sub-components, and a Login feature module was added.

```mermaid
flowchart TB
    subgraph SPA["SAPCyTI SPA"]
        SHELL["Shell / Layout\nMain Routing\nRole-based menu rendering"]

        subgraph Features["Feature Modules"]
            LOGIN["Login Module\nHU-01"]
            DASH["Dashboard Module"]
            ENROLL["Enrollment Module"]
            ENTITIES["Entity Management Module"]
        end

        subgraph Core["Core"]
            AUTHINT["Auth Interceptor\nJWT attachment + 401 refresh"]
            AUTHGUARD["Role Auth Guard\nCanActivate + role check"]
            AUTHSTATE["Auth State Service\ncurrentUser$ + token lifecycle"]
            TENANT["Tenant Context\nGraduate program selection"]
            HTTP["HTTP Client\nBase API configuration"]
        end

        SHARED["Shared\nUI components, Pipes"]
    end

    SHELL --> Features
    SHELL --> Core
    Features --> Core
    Features --> SHARED
    AUTHINT --> HTTP
    AUTHGUARD --> AUTHSTATE
    LOGIN --> AUTHSTATE
```

| Component | Responsibilities |
| ---------- | ----------------- |
| **Shell / Layout** | Application structure (menu, top bar, container); high-level routing; loading feature modules; conditionally renders menu items based on `currentUser$.role` from AuthStateService — only role-appropriate options visible after login (HU-01). |
| **Login Module** (Feature) | Login form (email, password, "Remember me" checkbox); calls AuthStateService.login(); displays generic error on failure; navigates to role-specific dashboard on success. Implements HU-01 UI. |
| **Dashboard Module** (Feature) | Role-specific landing page after login; summary views per user type. |
| **Enrollment Module** (Feature) | Enrollment-related views (CSV upload, course selection, advisor approval, form generation). |
| **Entity Management Module** (Feature) | Student and professor CRUD views (Iteration 4). |
| **Auth Interceptor** (Core) | Angular `HttpInterceptor`; attaches `Authorization: Bearer <accessToken>` header to all API requests (except auth endpoints); on 401 response, transparently attempts token refresh via refresh token cookie — retries original request on success, redirects to login on failure. |
| **Role Auth Guard** (Core) | Angular `CanActivate` guard; reads `data.roles` from route definition; decodes JWT to extract role claim; allows navigation if user role is in allowed list; redirects to 403 page (wrong role) or login page (unauthenticated). UX convenience only — all authorization enforced server-side. |
| **Auth State Service** (Core) | Holds access token in memory (never localStorage — XSS mitigation); exposes `currentUser$` Observable with decoded JWT claims (id, email, role, graduateProgramId); provides `login()`, `logout()`, `isAuthenticated()`, `hasRole()` methods; on bootstrap, attempts silent refresh via HttpOnly refresh token cookie to restore session. |
| **Tenant Context** (Core) | Manages the active graduate program selection; includes `X-Graduate-Id` header in API requests. |
| **HTTP Client** (Core) | Base Angular HttpClient configuration; base API URL; timeout handling. |
| **Shared** | Reusable components (tables, forms, messages, error pages including 403 Access Denied); pipes; common styles and utilities. |

### 7.- Deployment view

The deployment topology is based on **Docker** and **Docker Compose** on the on-premise Linux server (CON-2). Three environments — **Development (Dev)**, **Pre-production (Pre-prod)**, and **Production (Prod)** — run as **namespaced Compose projects** (`sapcyti-dev`, `sapcyti-preprod`, `sapcyti-prod`) on the same physical host, each with an isolated Docker network and a separate `.env` file. Each environment runs an identical stack of seven services. Runtime configuration is externalized via environment variables, ensuring the same `docker-compose.yml` is used across all environments (Factor X — Dev/prod parity). This topology supports portability to cloud environments (QA-5) and provides a repeatable deployment cycle for the rotating student team (CON-6).

```mermaid
flowchart TB
    subgraph Host["On-premise Linux Host - 16 TB / 32 GB RAM"]
        subgraph Dev["sapcyti-dev"]
            NGINX_D["Nginx"]
            API_D["Backend API"]
            PG_D[("PostgreSQL")]
            VM_D["VictoriaMetrics"]
            NE_D["Node Exporter"]
            GF_D["Grafana"]
        end
        subgraph PreProd["sapcyti-preprod"]
            NGINX_P["Nginx"]
            API_P["Backend API"]
            PG_P[("PostgreSQL")]
            VM_P["VictoriaMetrics"]
            NE_P["Node Exporter"]
            GF_P["Grafana"]
        end
        subgraph Prod["sapcyti-prod"]
            NGINX_R["Nginx"]
            API_R["Backend API"]
            PG_R[("PostgreSQL")]
            VM_R["VictoriaMetrics"]
            NE_R["Node Exporter"]
            GF_R["Grafana"]
        end
        VOL["Named Volumes per env"]
    end
    GHCR["GitHub Container Registry"]
    GHA["GitHub Actions"]
    GHA -.->|push images| GHCR
    GHCR -.->|pull images| Dev
    GHCR -.->|pull images| PreProd
    GHCR -.->|pull images| Prod
```

#### Deployment Element Responsibilities

| Element | Responsibilities |
| -------- | ----------------- |
| **Linux Host** | Run Docker Engine and Docker Compose; host all three namespaced Compose projects; house persistent volumes; single point of on-premise deployment. Resource limits (`mem_limit`, `cpus`) set per service to prevent starvation on the shared 32 GB host. |
| **Nginx Container** | Act as reverse proxy (unique port per environment); route `/api` to the Backend API; serve SPA static assets; optionally terminate TLS. |
| **Backend API Container** | Run the Spring Boot application (stateless process, Factor VI); connect to PostgreSQL and external services; read configuration from environment variables (Factor III); expose `/actuator/health` for Docker `HEALTHCHECK` and `/actuator/prometheus` for metrics scraping; Flyway runs DB migrations on startup (Factor XII). Embedded Tomcat exports service via port binding (Factor VII). Graceful shutdown enabled (Factor IX). |
| **PostgreSQL Container** | Provide the database; persist data in an environment-specific named volume. |
| **VictoriaMetrics Container** | Single-node metrics storage; scrapes Node Exporter and Backend API Actuator `/actuator/prometheus` endpoint; evaluates alert rules; sends notifications via SMTP. Prometheus-compatible API. |
| **Node Exporter Container** | Expose host-level metrics (disk, CPU, RAM) for VictoriaMetrics scraping (C004.2.2). |
| **Grafana Container** | OSS dashboards for host health, JVM metrics, HTTP request rates, and Docker container resource usage. Data source: VictoriaMetrics. |
| **Named Volumes** | Persist PostgreSQL data and VictoriaMetrics time-series data between container restarts, per environment. |
| **Docker Compose** | Define services, networks, and volumes; the `-p` flag creates namespaced projects (`sapcyti-dev`, `sapcyti-preprod`, `sapcyti-prod`) with isolated networks on the same host. |
| **Environment files** | `.env.dev`, `.env.preprod`, `.env.prod` — contain all environment-specific configuration (DB credentials, API URLs, feature flags). No secrets in code (Factor III). |

### 8.- CI/CD (Build and release)

The system uses **two separate GitHub repositories** (`sapcyti-api` for the Backend API and `sapcyti-spa` for the SPA), each with **two GitHub Actions workflows**: a **PR Validation** workflow that runs on pull requests (lint, build, test, scan — no image build), and a **Merge & Deploy** workflow that runs on merges to `develop`, `release/*`, or `main` (full pipeline including Docker image build, push to GHCR, and deployment). This separation avoids building and publishing images for code that hasn't been reviewed and approved yet. The pipelines enforce quality gates including a minimum **80% unit test code coverage** threshold, automated security scanning, and required reviewer approval before any merge.

#### 8.1.- Backend API — PR Validation Workflow (`sapcyti-api`)

Triggered on **PR to `develop`**. Validates code quality without building or publishing a Docker image.

```mermaid
flowchart LR
    subgraph PR_CI["PR Validation - sapcyti-api"]
        L["Lint +\nCommit check"]
        B["Maven\nBuild"]
        UT["JUnit 5\nUnit tests\n80% JaCoCo"]
        IT["JUnit 5\nIntegration\ntests"]
        SEC["OWASP\nDep-Check"]
    end
    L --> B --> UT --> IT --> SEC
```

#### 8.2.- Backend API — Merge & Deploy Workflow (`sapcyti-api`)

Triggered on **push (merge) to `develop`, `release/*`, `main`**. Runs the full pipeline including image build, publish, and deployment.

```mermaid
flowchart LR
    subgraph Merge_CI["Merge & Deploy - sapcyti-api"]
        L["Lint +\nCommit check"]
        B["Maven\nBuild"]
        UT["JUnit 5\nUnit tests\n80% JaCoCo"]
        IT["JUnit 5\nIntegration\ntests"]
        SEC["OWASP\nDep-Check"]
        IMG["Docker\nimage build"]
        PUSH["Push to\nGHCR"]
        DEP["Deploy to\nenvironment"]
    end
    L --> B --> UT --> IT --> SEC --> IMG --> PUSH --> DEP
```

#### 8.3.- SPA — PR Validation Workflow (`sapcyti-spa`)

Triggered on **PR to `develop`**. Validates code quality without building or publishing a Docker image.

```mermaid
flowchart LR
    subgraph PR_CI["PR Validation - sapcyti-spa"]
        L["Lint +\nCommit check"]
        NI["npm ci"]
        UT["Unit tests\n80% istanbul"]
        AUD["npm audit"]
        BLD["ng build\nproduction"]
    end
    L --> NI --> UT --> AUD --> BLD
```

#### 8.4.- SPA — Merge & Deploy Workflow (`sapcyti-spa`)

Triggered on **push (merge) to `develop`, `release/*`, `main`**. Runs the full pipeline including image build, publish, and deployment.

```mermaid
flowchart LR
    subgraph Merge_CI["Merge & Deploy - sapcyti-spa"]
        L["Lint +\nCommit check"]
        NI["npm ci"]
        UT["Unit tests\n80% istanbul"]
        AUD["npm audit"]
        BLD["ng build\nproduction"]
        IMG["Docker\nNginx image"]
        PUSH["Push to\nGHCR"]
        DEP["Deploy to\nenvironment"]
    end
    L --> NI --> UT --> AUD --> BLD --> IMG --> PUSH --> DEP
```

#### 8.5.- Deployment Promotion Flow

All three environments run on the same physical server as namespaced Compose projects. Manual approval is required at **every stage**, including merges to `develop`. All changes on a PR to `develop` must be locally tested with passing unit tests before submission.

```mermaid
flowchart LR
    subgraph Promotion["Environment Promotion"]
        PR["PR to develop"]
        CI_PASS["PR Validation\npasses"]
        REV["Reviewer\napproval"]
        MERGE["Merge to\ndevelop"]
        BUILD["Merge workflow:\nbuild + image +\npush"]
        DEV["Deploy to\nDev"]
        SMOKE_D["Karate\nsmoke tests"]
        REL["release/* branch"]
        APPR_P["Manual\napproval"]
        PREPROD["Deploy to\nPre-prod"]
        TESTS_P["Regression +\nLoad tests"]
        MAIN["Merge to main"]
        APPR_R["Manual\napproval"]
        PROD["Deploy to\nProd"]
        SMOKE_R["Karate\nsmoke tests"]
    end
    PR --> CI_PASS --> REV --> MERGE --> BUILD --> DEV --> SMOKE_D --> REL --> APPR_P --> PREPROD --> TESTS_P --> MAIN --> APPR_R --> PROD --> SMOKE_R
```

#### Pipeline Stage Responsibilities

| Stage | Workflow | Repository | Responsibilities |
| ----- | -------- | ---------- | ----------------- |
| **Lint + Commit check** | PR Validation + Merge & Deploy | Both | Validate code style (ESLint / Checkstyle) and enforce Conventional Commits format via `commitlint`. |
| **Build** | PR Validation + Merge & Deploy | API: Maven/Gradle, SPA: `npm ci` + `ng build` | Compile the application; produce build artifacts. |
| **Unit tests** | PR Validation + Merge & Deploy | API: JUnit 5 + JaCoCo, SPA: Karma + istanbul | Run unit tests; enforce **minimum 80% code coverage**; fail pipeline if threshold not met. |
| **Integration tests** | PR Validation + Merge & Deploy | API: JUnit 5 | Run integration tests against embedded database or testcontainers. |
| **Security scanning** | PR Validation + Merge & Deploy | API: OWASP Dependency-Check, SPA: `npm audit` | Scan transitive dependencies for known CVEs; fail on critical vulnerabilities (C010.2.2). |
| **Docker image build** | Merge & Deploy only | Both | Build multi-stage Docker image; tag with Git SHA + branch. Only runs after merge, not on PRs. |
| **Push to GHCR** | Merge & Deploy only | Both | Push image to GitHub Container Registry; authentication via `GITHUB_TOKEN`. Only runs after merge. |
| **Deploy** | Merge & Deploy only | Both (deployment job) | SSH to host → `docker compose -p sapcyti-{env} --env-file .env.{env} pull` → `docker compose -p sapcyti-{env} --env-file .env.{env} up -d` → health check via `curl /actuator/health`. |
| **Smoke tests** | Merge & Deploy only | Both (post-deploy) | Run Karate automated smoke tests (API + UI) against the deployed environment. |
| **Regression + Load tests** | Merge & Deploy only | Pre-prod only | Run Karate regression suite + Gatling load tests (50+ concurrent users) before production promotion. |

### 9.- Sequence diagrams

#### 9.1.- Request flow with tenant context and parameter resolution

This diagram illustrates how elements instantiated in Iteration 1 collaborate when a user performs an action in the SPA: the request includes the tenant context (graduate program), the Backend resolves configuration parameters for that program, and executes business logic against the database.

```mermaid
sequenceDiagram
    actor User
    participant SPA as SAPCyTI SPA
    participant API as Backend API
    participant Config as Configuration Service
    participant DB as PostgreSQL

    User->>SPA: UI Action
    SPA->>SPA: Includes X-Graduate-Id or context
    SPA->>API: HTTP Request + tenant context
    API->>API: Resolves tenant, validates auth
    API->>Config: Get parameters for graduate program
    Config->>DB: Read ConfigurationParameter
    DB-->>Config: Parameters
    Config-->>API: Parameters
    API->>DB: Business logic / persistence
    DB-->>API: Result
    API-->>SPA: JSON Response
    SPA-->>User: Updates view
```

**Description:** The user interacts with the SPA (Angular). The SPA sends each request to the Backend API with the active graduate program identifier (header or path). The API validates the session and tenant, consults the configuration parameters associated with that graduate program via the Configuration Service, and executes the business logic on the database. The response is returned in JSON, and the SPA updates the interface. This flow supports QA-3 (single-point parameterization) and QA-4 (multi-tenancy per graduate program).

#### 9.2.- Deployment promotion cycle

This diagram illustrates the collaboration of DevOps elements instantiated in Iteration 2: the full lifecycle from PR creation through multi-environment deployment with quality gates, manual approvals, and automated testing at each stage.

```mermaid
sequenceDiagram
    actor Dev as Developer
    participant Local as Local Environment
    participant PR as GitHub PR
    participant CI as GitHub Actions
    participant Rev as Reviewer
    participant GHCR as GHCR
    participant DevEnv as Dev (sapcyti-dev)
    participant Karate as Karate Tests
    participant PreProd as Pre-prod (sapcyti-preprod)
    participant Gatling as Gatling
    participant Prod as Prod (sapcyti-prod)

    Dev->>Local: Develop on feature/* branch
    Dev->>Local: Run unit tests locally (≥80%)
    Dev->>PR: Create PR to develop
    PR->>CI: Triggers CI pipeline
    CI->>CI: Lint + Conventional Commit check
    CI->>CI: Build (Maven/npm ci)
    CI->>CI: Unit tests (JUnit 5 / Karma, 80% coverage gate)
    CI->>CI: Integration tests (JUnit 5)
    CI->>CI: Security scan (OWASP / npm audit)
    CI->>CI: Build Docker image
    CI->>GHCR: Push image (tagged by SHA)
    CI-->>PR: Status ✅ / ❌
    Rev->>PR: Manual review + approval
    PR->>DevEnv: Auto-deploy on merge to develop
    DevEnv->>Karate: Run smoke tests (API + UI)
    Karate-->>DevEnv: Results ✅
    Note over Dev,DevEnv: ── Release phase ──
    Dev->>PR: Create release/* branch
    Rev->>PR: Manual approval for Pre-prod
    PR->>PreProd: Deploy to Pre-prod
    PreProd->>Karate: Run regression + API contract tests
    PreProd->>Gatling: Run load tests (50+ concurrent)
    Gatling-->>PreProd: HTML report
    Note over Dev,Prod: ── Production phase ──
    Dev->>PR: Merge release/* to main
    Rev->>PR: Manual approval for Prod
    PR->>Prod: Deploy to Prod
    Prod->>Karate: Run smoke tests (API + UI)
    Karate-->>Prod: Results ✅
```

**Description:** The developer works on a `feature/*` branch, running unit tests locally to ensure ≥80% coverage before creating a PR to `develop`. GitHub Actions runs the full CI pipeline (lint, build, tests, security scan, image build); the pipeline fails if coverage drops below 80% or critical CVEs are found. A reviewer must manually approve the PR before merge. On merge to `develop`, the new image is auto-deployed to the Dev environment, followed by Karate smoke tests. For production promotion, a `release/*` branch is created, manually approved for Pre-prod, where regression tests (Karate) and load tests (Gatling) validate the release. Finally, merging to `main` with manual approval deploys to Production, with post-deploy smoke tests.

#### 9.3.- Monitoring and alerting flow

This diagram illustrates the observability stack instantiated in Iteration 2: the Backend API and host export metrics, VictoriaMetrics collects and evaluates alert rules, Grafana provides dashboards, and alerts are sent via SMTP.

```mermaid
sequenceDiagram
    participant API as Backend API
    participant Actuator as Spring Boot Actuator
    participant NE as Node Exporter
    participant VM as VictoriaMetrics
    participant GF as Grafana
    participant SMTP as Email Server
    actor Admin as Administrator

    API->>Actuator: /actuator/prometheus (JVM, HTTP, DB pool)
    NE->>NE: Collect host metrics (disk, CPU, RAM)
    VM->>Actuator: Scrape metrics (interval)
    VM->>NE: Scrape host metrics (interval)
    VM->>VM: Store time-series data
    VM->>VM: Evaluate alert rules
    alt Alert triggered (disk > 80%, RAM > 90%, health failure)
        VM->>SMTP: Send alert notification
        SMTP->>Admin: Email alert
    end
    GF->>VM: Query metrics (PromQL)
    GF->>GF: Render dashboards
    Admin->>GF: View dashboards
```

**Description:** The Backend API exposes JVM, HTTP, and database pool metrics via Spring Boot Actuator in Prometheus format. Node Exporter collects host-level metrics (disk, CPU, RAM). VictoriaMetrics scrapes both sources at regular intervals, stores the time-series data, and evaluates alert rules. When thresholds are breached (disk > 80%, memory > 90%, or service health failure), VictoriaMetrics sends notifications via the existing SMTP integration. Grafana queries VictoriaMetrics using PromQL and renders dashboards for the team and administrators.

#### 9.4.- Login and authentication flow (HU-01)

This diagram illustrates the complete login flow instantiated in Iteration 3: the user submits credentials via the SPA Login module, the Backend validates credentials, issues JWT tokens, and the SPA stores the access token in memory.

```mermaid
sequenceDiagram
    actor User
    participant SPA as Login Module
    participant AuthState as Auth State Service
    participant Interceptor as Auth Interceptor
    participant API as Backend API
    participant SecFilter as Security Filter Chain
    participant AuthUC as Auth Use Case
    participant PwdPort as Password Encoder Port
    participant JwtSvc as JWT Service
    participant RefRepo as Refresh Token Repository
    participant AuditSvc as Audit Service
    participant DB as PostgreSQL

    User->>SPA: Enter email, password, remember me
    SPA->>AuthState: login(email, password, rememberMe)
    AuthState->>API: POST /api/auth/login
    API->>SecFilter: Request (whitelisted path)
    SecFilter->>AuthUC: Delegate to auth use case
    AuthUC->>DB: Find user by email
    DB-->>AuthUC: User record
    AuthUC->>PwdPort: matches(rawPassword, user.passwordHash)
    PwdPort-->>AuthUC: true / false
    alt Credentials valid
        AuthUC->>JwtSvc: generateAccessToken(user)
        JwtSvc-->>AuthUC: accessToken (RSA-256, 15 min)
        AuthUC->>JwtSvc: generateRefreshToken(user, rememberMe)
        JwtSvc->>RefRepo: Persist hashed refresh token
        RefRepo->>DB: INSERT refresh_tokens
        JwtSvc-->>AuthUC: refreshToken
        AuthUC->>AuditSvc: log LOGIN_SUCCESS (HIGH)
        AuditSvc->>DB: INSERT audit_events
        AuthUC-->>API: 200 + accessToken JSON + Set-Cookie HttpOnly refresh
        API-->>AuthState: Response
        AuthState->>AuthState: Store access token in memory
        AuthState->>SPA: currentUser$ emits user
        SPA->>User: Navigate to role-specific dashboard
    else Credentials invalid
        AuthUC->>AuditSvc: log LOGIN_FAILURE (HIGH)
        AuditSvc->>DB: INSERT audit_events
        AuthUC-->>API: 401 + generic error
        API-->>AuthState: Error response
        AuthState->>SPA: Error notification
        SPA->>User: Display "Invalid credentials"
    end
```

**Description:** The user enters email, password, and optionally checks "Remember me" on the Login Module (HU-01). The SPA's AuthStateService calls `POST /api/auth/login`. The Security Filter Chain passes the request (login endpoint is whitelisted). The Auth Use Case retrieves the user from PostgreSQL, validates the password via the PasswordEncoderPort (BCrypt), and on success, the JWT Service generates a short-lived access token (RSA-256 signed, 15 min) and a refresh token (7 days default, 30 days if remember-me). The refresh token hash is persisted for revocation support. An audit event is recorded at HIGH severity. The access token is returned in the JSON body; the refresh token is set as an HttpOnly, Secure, SameSite=Strict cookie. The AuthStateService stores the access token in memory (never localStorage) and emits the decoded user via `currentUser$`. On failure, a generic error is returned (no information leakage) and the failure is audit-logged.

#### 9.5.- RBAC enforcement on a protected request

This diagram illustrates how the security components collaborate to enforce role-based access control on every authenticated API request.

```mermaid
sequenceDiagram
    actor User
    participant SPA as SPA
    participant Interceptor as Auth Interceptor
    participant Guard as Role Auth Guard
    participant API as Backend API
    participant JwtFilter as JWT Authentication Filter
    participant SecCtx as Security Context
    participant Controller as REST Controller
    participant AuditSvc as Audit Service
    participant DB as PostgreSQL

    User->>SPA: Navigate to protected view
    SPA->>Guard: canActivate(route)
    Guard->>Guard: Check role from JWT payload
    alt Role allowed for route
        Guard-->>SPA: Allow navigation
        SPA->>Interceptor: HTTP request to API
        Interceptor->>Interceptor: Attach Authorization Bearer header
        Interceptor->>API: GET /api/students (example)
        API->>JwtFilter: Extract JWT from header
        JwtFilter->>JwtFilter: Validate RSA signature + expiry
        JwtFilter->>SecCtx: Set authentication (userId, role, tenant)
        SecCtx-->>Controller: SecurityContext available
        Controller->>Controller: @PreAuthorize hasRole COORDINATOR
        alt Role matches
            Controller->>DB: Execute business logic
            DB-->>Controller: Result
            Controller-->>API: 200 JSON response
            API-->>SPA: Response data
            SPA-->>User: Render view
        else Role does not match
            Controller-->>API: 403 Forbidden
            AuditSvc->>DB: log RBAC_VIOLATION (HIGH)
            API-->>SPA: 403 error
            SPA-->>User: Access Denied page
        end
    else Role not allowed for route
        Guard-->>SPA: Redirect to 403 page
        SPA-->>User: Access Denied page
    end
```

**Description:** When the user navigates to a protected view, the SPA's RoleAuthGuard first checks the JWT payload's role claim against the route's allowed roles. If allowed, the Auth Interceptor attaches the Bearer token to the HTTP request. The Backend's JWT Authentication Filter validates the RSA signature and expiry, then populates the Spring SecurityContext. The REST Controller evaluates `@PreAuthorize("hasRole('COORDINATOR')")` via SpEL. If the role matches, business logic executes normally. If not, a 403 response is returned and the Audit Service logs an RBAC_VIOLATION at HIGH severity. The SPA guard provides an immediate UX check, but all authorization is enforced server-side.

#### 9.6.- Audit logging flow for domain mutations

This diagram illustrates how the general-purpose audit infrastructure captures domain entity changes via JPA lifecycle listeners.

```mermaid
sequenceDiagram
    participant UseCase as Use Case
    participant Entity as Domain Entity
    participant JPA as JPA Repository
    participant Listener as JPA Entity Listener
    participant AuditPort as Audit Output Port
    participant AuditAdapter as Audit Adapter
    participant DB as PostgreSQL
    participant Stdout as Stdout (Factor XI)

    UseCase->>Entity: Modify entity (e.g., register student)
    UseCase->>JPA: save(entity)
    JPA->>JPA: EntityManager.persist / merge
    JPA->>Listener: @PrePersist / @PreUpdate callback
    Listener->>Listener: Build AuditEvent (STANDARD severity)
    Note over Listener: Fields: actor, action, entityType,<br/>entityId, changedFields, tenant
    Listener->>AuditPort: persist(auditEvent)
    AuditPort->>AuditAdapter: Adapter implementation
    AuditAdapter->>DB: INSERT INTO audit_events
    AuditAdapter->>Stdout: Structured JSON log (Factor XI)
    JPA->>DB: INSERT / UPDATE entity
    DB-->>JPA: Confirmation
    JPA-->>UseCase: Saved entity
```

**Description:** When a Use Case modifies a domain entity (e.g., registering a student, updating a grade), the JPA Repository triggers the entity's lifecycle listener (`@PrePersist` or `@PreUpdate`). The listener constructs an `AuditEvent` with STANDARD severity, capturing the actor, action, entity type, entity ID, and changed fields. The event is persisted to the `audit_events` table via the Audit Adapter (implementing the `AuditOutputPort`) and simultaneously written to stdout as structured JSON (Factor XI). This dual-write approach ensures audit events are both queryable (database) and streamable (log aggregation). Security events (login, RBAC) are captured separately via the Audit Aspect (AOP) at HIGH severity.

### 10.- Interfaces

#### Application interfaces

  - **Backend API:** REST API over HTTPS. Content in JSON for both request and response. Authentication is JWT-based (stateless, RSA-256 signed tokens) as defined in Iteration 3. All endpoints require a valid JWT in the `Authorization: Bearer` header, except authentication endpoints (`/api/auth/**`). The tenant context (active graduate program) is sent in every request via the `X-Graduate-Id` header.
  - **Main API Areas** (details in later iterations): authentication (Iteration 3); graduate programs and tenant selection; configuration and parameters; enrollment and academic offer; student and professor management; export (TXT/XLSX). Concrete contracts (OpenAPI or equivalent) will be documented as endpoints are defined per iteration.

#### Authentication and security interfaces

  - **Login:** `POST /api/auth/login` — Request body: `{email: string, password: string, rememberMe: boolean}`. Response: `{accessToken: string, expiresIn: number}` (200 OK) + `Set-Cookie: refreshToken=<token>; HttpOnly; Secure; SameSite=Strict; Path=/api/auth; Max-Age=<ttl>`. Error: `{error: string, message: string, timestamp: string}` (401 Unauthorized).
  - **Token refresh:** `POST /api/auth/refresh` — No request body; reads refresh token from HttpOnly cookie. Response: `{accessToken: string, expiresIn: number}` + rotated refresh cookie. Error: 401 if refresh token is expired, revoked, or missing.
  - **Logout:** `POST /api/auth/logout` — Requires valid access token. Revokes the refresh token server-side and clears the refresh cookie. Response: 204 No Content.
  - **Password recovery (pattern only — full flow in Iteration 4):** `POST /api/auth/forgot-password` — Request body: `{email: string}`. Response: always 200 OK with generic message (no information leakage on whether email exists).
  - **RBAC error contract:** All protected endpoints return `401 Unauthorized` (missing/invalid/expired JWT) or `403 Forbidden` (insufficient role). Response body: `{error: string, message: string, timestamp: string, path: string}`.
  - **Security headers** (applied by Security Filter Chain to all responses): `Content-Security-Policy: default-src 'self'`, `X-Frame-Options: DENY`, `X-Content-Type-Options: nosniff`, `Strict-Transport-Security: max-age=31536000; includeSubDomains` (when TLS is active).
  - **File download:** `GET /api/files/{fileId}?signature=<hmac>&expires=<timestamp>&userId=<id>` — Validates HMAC-SHA256 signature and expiry before streaming file. Returns 403 if signature invalid or expired.

#### Observability interfaces

  - **Health check endpoint:** `/actuator/health` — used by Docker `HEALTHCHECK` directive and the deployment job's post-deploy verification (`curl /actuator/health`). Returns liveness and readiness status. Exposed on the internal Compose network.
  - **Metrics endpoint:** `/actuator/prometheus` — exports JVM, HTTP request, and database connection pool metrics in Prometheus exposition format. Scraped by VictoriaMetrics at a configurable interval. Exposed on the internal Compose network only (not publicly accessible).
  - **Build info endpoint:** `/actuator/info` — returns build version and Git SHA for deployment traceability (C005.1.3).

#### DevOps and operational interfaces

  - **Pipeline ↔ Image Registry:** GitHub Actions uploads Docker images (Backend API and SPA/Nginx) to GitHub Container Registry (ghcr.io) via OCI push, tagged by Git SHA and branch. Authentication via `GITHUB_TOKEN` in the pipeline; PAT/credentials on the server for pull.
  - **Pipeline ↔ Server (deploy):** The deployment job connects to the target server via SSH, executes `docker compose -p sapcyti-{env} --env-file .env.{env} pull` followed by `docker compose -p sapcyti-{env} --env-file .env.{env} up -d`, then verifies health via `curl /actuator/health`. The `-p` flag targets the correct namespaced Compose project.
  - **Inter-environment promotion:** Images flow from GHCR to Dev (auto on `develop` merge) → Pre-prod (manual approval on `release/*`) → Prod (manual approval on `main` merge). All environments pull the same immutable image from GHCR — no re-building between environments.
  - **VictoriaMetrics ↔ Targets:** VictoriaMetrics scrapes Node Exporter (`:9100/metrics`) and Backend API Actuator (`:8080/actuator/prometheus`) on the internal Compose network. Prometheus-compatible scrape configuration.
  - **VictoriaMetrics ↔ Grafana:** Grafana uses VictoriaMetrics as a Prometheus-compatible data source for dashboards and PromQL queries.

#### Runtime container interfaces

  - **Nginx ↔ Backend API:** Nginx proxies `/api` requests to the Backend API via HTTP on the internal Compose network (e.g., `http://api:8080`).
  - **Backend API ↔ PostgreSQL:** JDBC connection via TCP on the internal Compose network; connection string and credentials from environment variables (Factor III).
  - **VictoriaMetrics ↔ SMTP:** Alert notifications sent via the existing email server when alert rules trigger.

### 11.- Design decisions

Design decisions from **Iteration 1** (general system structure), associated with the addressed drivers.

| Driver | Decision | Rationale | Discarded Alternatives |
| ------ | -------- | --------- | ------------------------- |
| **CON-1** | Back-end in **Java 21** with **Spring Boot 3.x** and Open Source libraries. | Meets Java and OSS constraints; Java 21 is LTS and offers good long-term support; mature ecosystem and documentation facilitate student rotation (CON-6). | Jakarta EE (heavier), Quarkus/Micronaut (lower adoption for learning). |
| **CON-2** | **On-premise** deployment on a single Linux server with a **reverse proxy** (e.g., Nginx) in front of the application. | A single host and single application process simplify operation and debugging for the team (CON-6). | Kubernetes or orchestration in Iteration 1 (unnecessary for one server). |
| **CON-3** | **Export Adapter** module generating **TXT and XLSX** files (Apache POI) for School Systems. | Encapsulates the format required by School Control as a driven adapter implementing an output port; maintains OSS libraries. | CSV only (does not meet CON-3); proprietary libraries (violate CON-1). |
| **CON-4** | Integration with WordPress via **asynchronous HTTP client** (WebClient/Async) or scheduled jobs from the Backend API. | Avoids UI blocking and double entry; does not introduce a message broker in this iteration. | Synchronous integration (couples availability to WordPress). |
| **CON-5** | Validation rules depending on external systems are **parameterizable**; the graduate commission has the final decision. | Validations are not hardened in code; supported through configuration and operational criteria. | Rigid code validations imposing fixed institutional rules. |
| **CON-6** | **Modular Monolith** following Hexagonal Architecture and DDD principles; modules by bounded context; **Angular** for the SPA; predictable documentation and structure. | A single deployment and known stack reduce the cognitive load for rotating developers. Domain is framework-agnostic and testable in isolation. | Microservices (too much operational complexity); Layered architecture (tight coupling, domain depends on persistence); SPA with poorly documented stack. |
| **CON-7** | **Angular SPA** with support for specified browsers and **responsive** design (CSS, viewport). | Angular has broad support and standard practices for compatibility and responsiveness. | Thymeleaf only (user preference for SPA); SPA without framework (greater maintenance effort). |
| **QA-3** | **Externalized configuration**: parameters per Graduate Program in the database (parameter table/s); Configuration Adapter exposes them at runtime via an output port. | Single point of configuration; changes without code deployment; aligned with the domain model (ConfigurationParameter). | Fixed values in code; configuration files only (no support per graduate program). |
| **QA-4** | **Multi-tenant by discriminator**: same database and schema, **graduate\_program\_id** in tenant-scoped tables; tenant context in every request. | Supports up to 9 graduate programs without multiple databases or schemas; simple operation aligned with the GraduateProgram aggregate. | Database per tenant (excessive); schema per tenant (higher operational complexity). |

Design decisions from **Iteration 2** (DevOps infrastructure and deployment), associated with the addressed drivers.

| Driver | Decision | Rationale | Discarded Alternatives |
| ------ | -------- | --------- | ------------------------- |
| **QA-5** | Backend API and PostgreSQL run as **Docker containers**; runtime configuration via **environment variables** (Spring Boot profiles + `.env` files); topology defined in a single **Docker Compose** file used identically across three environments (Factor X). Nginx in a container serves SPA static assets. | Same image and topology in any environment; decoupling from specific infrastructure; facilitates future cloud migration. | Bare metal deployment only (less portable); exclusive cloud orchestration. |
| **CON-2** | **Docker Compose** on the single Linux server runs three **namespaced Compose projects** (`sapcyti-dev`, `sapcyti-preprod`, `sapcyti-prod`), each with the same 7-service stack (Nginx, Backend API, PostgreSQL, VictoriaMetrics, Node Exporter, Grafana, shared network). No Kubernetes. | Respects the single-server constraint; isolated environments via `-p` namespacing; the same stack can be reproduced in development. | Kubernetes; multi-node orchestration; separate servers (budget constraint). |
| **CON-6** | **Two independent GitHub Actions CI/CD pipelines** (one per repository: `sapcyti-api`, `sapcyti-spa`); **GitFlow** branching model; **Conventional Commits** enforced via `commitlint` + `husky`; **PR-based quality gates** with required status checks and reviewer approval at every stage. | Repeatable build–test–deploy cycle; independent release cadences; reduces dependency on a single person; compatible with GitHub and on-premise server; structured process ideal for rotating students. | Jenkins (more maintenance); trunk-based development (too risky for junior developers); GitHub Flow (too simple for three environments); single monorepo pipeline (contradicts two-repo decision). |
| **CON-6, C005.1.2, C010.2.1** | **Minimum 80% unit test code coverage** enforced in CI via **JaCoCo** (API) and **istanbul** (SPA); pipeline fails if threshold not met. All PR changes must be **locally tested** before submission. **Manual reviewer approval** required before merge to `develop`. | Ensures code quality even with rotating student developers; prevents untested code from entering shared environments. | No coverage threshold (risk of untested code); post-merge testing only (catches issues too late). |
| **C004.1.1, Factor IX, XII** | **Hexagonal Architecture (Ports & Adapters)** for the Backend API internal structure within the modular monolith. Domain layer has zero infrastructure dependencies. **Flyway** for SQL-based DB schema versioning on startup. | Enforces DDD boundaries; domain testable in isolation (mock adapters); backing services swappable via adapter replacement (Factor IV). Flyway provides version-controlled, reproducible migrations (Factor XII). | Clean Architecture (more boilerplate, overkill for project scale); Traditional layered (tight coupling); Liquibase (more complex); manual DDL scripts (no versioning). |
| **C004.2.2, C004.2.3** | **VictoriaMetrics** (single-node, community edition) + **Node Exporter** + **Grafana** for monitoring; **Spring Boot Actuator** for health checks and metrics (`/actuator/health`, `/actuator/prometheus`, `/actuator/info`); alert rules for disk > 80%, RAM > 90%, health failures → SMTP notification. | Lower resource consumption than Prometheus (~7x less RAM) on the shared 32 GB host; Prometheus-compatible API ensures no lock-in; Grafana provides visual dashboards. | Prometheus (higher resource footprint, would require earlier vertical scaling); commercial monitoring (budget constraint); no monitoring (blind operation). |
| **C004.2.3, Factor XI** | **Structured JSON logging** to stdout via SLF4J + Logback with `logstash-logback-encoder`. Dev profile uses plain-text console output. Log fields include timestamp, level, logger, thread, message, MDC context (graduate\_program\_id, user\_id, request\_id). | Logs as event streams (Factor XI); machine-parseable for future aggregation; Docker log driver captures stdout natively; MDC context enables filtering by tenant for multi-program debugging. | File-based logging (violates Factor XI); plain text logging (not machine-parseable). |
| **C010.1.x, C010.2.x** | Comprehensive test strategy: **JUnit 5** for unit and integration tests; **Karate** framework for automated smoke, regression, and API contract tests (API + UI); **Gatling** for load/performance testing (50+ concurrent users); **Postman** for manual API testing. Sanitized test data via **Flyway** test migrations. | All automated tools are JVM-based (consistent with Java stack and Maven/Gradle integration). Karate provides unified BDD framework for API and UI testing. Gatling produces HTML reports. Postman gives GUI for manual API exploration. | k6 (JavaScript, less natural for Java team); JMeter (XML config, clunky GUI); unit tests only (insufficient coverage). |
| **C010.2.2** | **OWASP Dependency-Check** (backend) + **npm audit** (SPA) in CI pipeline; fail on critical CVEs. | Automated security scanning catches known vulnerabilities before merge; OSS; integrates with GitHub Actions. | Snyk (commercial for advanced features); no scanning (unacceptable security risk). |
| **C005.1.5, Factor X** | **Three-environment deployment** (Dev, Pre-prod, Prod) with **identical topology** differentiated only by `.env` files. Manual approval at every promotion stage including `develop`. | True dev/prod parity; Pre-prod serves as full QA gate before production; prevents untested code from reaching any shared environment. | Two environments (no QA gate); four+ environments (over-engineering). |

Design decisions from **Iteration 3** (security cross-cutting concerns), associated with the addressed drivers.

| Driver | Decision | Rationale | Discarded Alternatives |
| ------ | -------- | --------- | ------------------------- |
| **QA-1, QA-2, HU-01** | **Spring Security filter chain** with stateless JWT authentication as the single HTTP security entry point. `SecurityFilterChain` configures URL-pattern rules (default-deny), security headers, CORS, and `SessionCreationPolicy.STATELESS`. | Industry-proven framework; integrates natively with Spring Boot; configurable pipeline; handles CORS, CSRF, headers out of the box; compatible with hexagonal architecture (filter chain is a driving adapter); Factor VI compliance. | Apache Shiro (smaller ecosystem); custom servlet filters (reinvents solved problems, CON-6 risk); Keycloak/external IdP (adds infrastructure, overkill for 6 roles). |
| **HU-01, C003.2.3** | **JWT with asymmetric RSA-256 key pair**. Access token (15 min TTL) + refresh token (7/30 day TTL for "Remember me") with rotation. Refresh token stored as HttpOnly cookie; access token in memory. | Stateless verification (Factor VI); no token store for access tokens; refresh token rotation mitigates theft; "Remember me" maps to longer refresh TTL; portable to future services. | Symmetric HMAC-SHA256 (shared secret risk); opaque tokens + Redis (violates Factor VI, adds infrastructure); Spring Session (adds Redis dependency). |
| **QA-1, C003.2.1** | Method-level RBAC via **`@PreAuthorize` + SpEL** with Spring `RoleHierarchy` bean. Roles embedded in JWT claims. Hierarchy: SYSTEM_ADMIN > COORDINATOR > ASSISTANT > PROFESSOR > STUDENT > SPEAKER (pending PO validation). SPA AuthGuard provides UX-only route protection. | Declarative; close to business logic; easy for students to read; auto-generates 403 responses; supports complex expressions; auditable. All authorization enforced server-side. | Custom RBAC interceptor (manual, error-prone); ACL (overkill for 6 roles); OPA/Casbin (external dependency, steep learning curve). |
| **C003.1.2, QA-2** | **BCrypt** password hashing via `BCryptPasswordEncoder` with configurable work factor (default 12, externalized via Factor III). Wrapped as a driven adapter implementing `PasswordEncoderPort`. | Adaptive cost function; built-in salt; industry standard; zero additional dependencies; widely understood by students. | Argon2 (superior but less mature Spring support, unfamiliar to students); SCrypt (less adoption); SHA-256 + salt (unsuitable for passwords, OWASP discourages). |
| **QA-2** | **Spring Security defaults + explicit CWE Top 25 hardening**: CSP, X-Frame-Options, X-Content-Type-Options headers; JPA parameterized queries (CWE-89); Angular auto-escaping (CWE-79); SameSite cookies + CORS (CWE-352); Bean Validation (CWE-20); path normalization (CWE-22); no ObjectInputStream deserialization (CWE-502); secrets in `.env` only (CWE-798). | Comprehensive defense-in-depth; uses framework defaults; each layer addresses specific CWE entries; minimal custom code; CI scans enforce automatically. | WAF only (doesn't protect app-logic vulnerabilities); manual filters (reinvents the wheel, CON-6 risk). |
| **C003.2.2** | **General-purpose audit logging** via JPA `@EntityListeners` (domain mutations at STANDARD level) + AOP `SecurityAuditAspect` (auth/RBAC events at HIGH level). `AuditEvent` aggregate persisted to PostgreSQL + structured JSON to stdout (Factor XI). | Non-invasive; general-purpose (any entity); centralized persistence; queryable for compliance reports; dual-write (DB + stdout) ensures both queryability and streamability. | Event Sourcing (excessive complexity, CON-6); ELK/Splunk (budget constraint); log-only (not queryable for compliance). |
| **C003.1.1, C003.1.3** | **Signed time-limited URLs** via HMAC-SHA256 for file access. Backend generates signed URL with file ID, expiry, user scope. Download endpoint validates signature with constant-time comparison. Files never directly exposed via web server. | Files never publicly accessible; URL useless after expiry; compatible with future S3 pre-signed URLs (QA-5); simple to implement. | Nginx X-Accel-Redirect (Nginx-specific, no time limit); direct file paths (CWE-22 risk); S3 pre-signed URLs (not applicable to on-premise, CON-2). |
| **QA-1, HU-01** | **Angular HttpInterceptor** for JWT attachment + **RoleAuthGuard** for route protection + **AuthStateService** for token lifecycle. Access token stored **in memory only** (XSS mitigation). Refresh token as HttpOnly cookie (secure from JavaScript). | Clean separation; Angular built-in patterns; consistent JWT handling; memory storage mitigates XSS theft; HttpOnly cookie secure from JS access. | localStorage (XSS-accessible, OWASP discourages); session cookies (violates Factor VI); third-party auth SDK (unnecessary dependency, CON-6). |

### 12.- Development workflow

This section documents the development practices, branching model, and quality policies that govern how code flows through the SAPCyTI system. It serves as the primary reference for rotating student developers.

#### 12.1.- GitFlow branching model

Both repositories (`sapcyti-api` and `sapcyti-spa`) follow the **GitFlow** branching model:

```mermaid
gitGraph
    commit id: "init"
    branch develop
    checkout develop
    commit id: "setup"
    branch feature/enrollment
    checkout feature/enrollment
    commit id: "feat: enrollment form"
    commit id: "feat: enrollment validation"
    checkout develop
    merge feature/enrollment id: "PR + review"
    branch release/1.0
    checkout release/1.0
    commit id: "fix: enrollment edge case"
    checkout main
    merge release/1.0 id: "v1.0.0" tag: "v1.0.0"
    checkout develop
    merge release/1.0 id: "back-merge"
    checkout main
    branch hotfix/1.0.1
    commit id: "fix: critical bug"
    checkout main
    merge hotfix/1.0.1 id: "v1.0.1" tag: "v1.0.1"
    checkout develop
    merge hotfix/1.0.1 id: "hotfix back-merge"
```

| Branch | Purpose | Deploys to |
| ------ | ------- | ---------- |
| `main` | Production-ready code. Only receives merges from `release/*` and `hotfix/*`. | Prod (manual approval) |
| `develop` | Integration branch for the next release. Receives merges from `feature/*`. | Dev (auto after merge) |
| `feature/*` | Individual feature or fix development. Created from `develop`. | — (local/CI only) |
| `release/*` | Release preparation and stabilization. Created from `develop`. | Pre-prod (manual approval) |
| `hotfix/*` | Urgent production fixes. Created from `main`, merged back to `main` and `develop`. | Prod (manual approval) |

#### 12.2.- Conventional Commits

All commits must follow the [Conventional Commits](https://www.conventionalcommits.org/) specification, enforced via `commitlint` + `husky` pre-commit hooks.

**Format:** `<type>(<scope>): <description>`

| Type | Purpose | Example |
| ---- | ------- | ------- |
| `feat` | New feature | `feat(enrollment): add PDF generation` |
| `fix` | Bug fix | `fix(auth): correct session timeout handling` |
| `docs` | Documentation only | `docs(readme): update setup instructions` |
| `style` | Formatting, no logic change | `style(api): apply Checkstyle rules` |
| `refactor` | Code refactoring | `refactor(domain): extract enrollment service` |
| `test` | Adding or modifying tests | `test(enrollment): add JUnit integration test` |
| `chore` | Build, config, tooling | `chore(ci): add OWASP Dependency-Check stage` |

#### 12.3.- PR/Code review process

1. **Developer** creates a `feature/*` branch from `develop`.
2. Developer runs unit tests locally and ensures ≥80% coverage before submitting.
3. Developer creates a **Pull Request** to `develop` on GitHub.
4. **GitHub Actions CI pipeline** runs automatically (lint, build, tests, security scan, coverage gate).
5. If CI passes, a **reviewer** (senior student, academic supervisor, or coordinator) performs a code review.
6. Reviewer **approves** or requests changes.
7. On approval, the PR is **merged** to `develop`, triggering auto-deployment to Dev.

**GitHub branch protection rules** on `develop` and `main`:
- Require CI status checks to pass
- Require at least 1 approving review
- Require up-to-date branches before merging
- No direct pushes (all changes via PR)

#### 12.4.- Unit test coverage policy

All code changes must maintain a **minimum 80% unit test code coverage**. This is enforced automatically in the CI pipeline:

- **Backend API:** JaCoCo coverage report; pipeline fails if line coverage < 80%.
- **SPA:** istanbul/nyc coverage report via Karma; pipeline fails if statement coverage < 80%.

Coverage reports are generated as pipeline artifacts and available for review.

#### 12.5.- Technical debt tracking

A `TECH_DEBT.md` file is maintained in each repository's root directory, serving as a technical debt register:

| Column | Description |
| ------ | ----------- |
| **ID** | Unique identifier (e.g., `TD-001`) |
| **Description** | What the tech debt is |
| **Priority** | High / Medium / Low |
| **Rationale** | Why it was incurred |
| **Impact** | What happens if not addressed |
| **Target iteration** | When it should be resolved |

### 13.- Test infrastructure

This section documents the comprehensive test strategy across the three deployment environments, the tooling used at each level of the test pyramid, and the approach to test data management.

#### 13.1.- Test pyramid and tooling

```mermaid
flowchart TB
    subgraph Pyramid["Test Pyramid"]
        UNIT["Unit Tests\nJUnit 5 / Karma\nFastest, most numerous"]
        INT["Integration Tests\nJUnit 5 + Testcontainers"]
        API["API Contract Tests\nKarate"]
        SMOKE["Smoke Tests\nKarate - API + UI"]
        REG["Regression Tests\nKarate"]
        LOAD["Load / Performance Tests\nGatling"]
        USAB["Usability Tests\nManual"]
    end
    UNIT --- INT --- API --- SMOKE --- REG --- LOAD --- USAB
```

#### 13.2.- Test type / environment matrix

| Test Type | Tool | Dev | Pre-prod | Prod | Automated/Manual |
| --------- | ---- | --- | -------- | ---- | ---------------- |
| **Unit tests** | JUnit 5 (API), Karma (SPA) | ✅ CI gate (80% coverage) | — | — | Automated |
| **Integration tests** | JUnit 5 + Testcontainers | ✅ CI gate | — | — | Automated |
| **Smoke tests** | Karate (API + UI) | ✅ Post-deploy | ✅ Post-deploy | ✅ Post-deploy | Automated |
| **Regression tests** | Karate (API + UI) | — | ✅ Before promotion | — | Automated |
| **API contract tests** | Karate | — | ✅ Before promotion | — | Automated |
| **Load / Performance tests** | Gatling | — | ✅ Before promotion | — | Automated |
| **Usability tests** | Manual (coordinated with stakeholders) | — | ✅ Scheduled | — | Manual |
| **Manual API testing** | Postman | ✅ Ad-hoc | ✅ Ad-hoc | — | Manual |

#### 13.3.- Tooling details

| Tool | Purpose | Integration | Reports |
| ---- | ------- | ----------- | ------- |
| **JUnit 5** | Unit and integration tests for Backend API | Maven/Gradle Surefire/Failsafe plugins; runs in CI pipeline | JaCoCo HTML/XML coverage reports |
| **Karma + istanbul** | Unit tests for SPA | Angular CLI (`ng test`); runs in CI pipeline | istanbul/nyc HTML coverage reports |
| **Karate** | BDD-style automated API and UI tests (smoke, regression, API contract) | Maven/Gradle plugin; runs as post-deploy job in CI/CD | Cucumber HTML reports |
| **Gatling** | Load and performance testing | Maven/Gradle plugin; simulates 50+ concurrent users (enrollment peak per C004.2.1) | HTML reports with response time distributions |
| **Postman** | Manual API exploration and ad-hoc validation | Standalone GUI application; shared collections in repository | JSON collections exportable to HTML |

#### 13.4.- Sanitized test data

Test data for Dev and Pre-prod environments is managed through **Flyway test migrations**:

- Test migration scripts are stored in `src/test/resources/db/testdata/` following the naming convention `V{version}__test_{description}.sql`.
- Test data is **sanitized** — no real student, applicant, or professor personal information is used.
- Test data seeds are applied automatically when Flyway runs in Dev and Pre-prod profiles.
- Production uses only production Flyway migrations (`src/main/resources/db/migration/`); test data scripts are never executed in Prod.

### 14.- Observability and monitoring

This section documents the monitoring, logging, and alerting architecture that supports operational health visibility across all three environments.

#### 14.1.- Monitoring stack architecture

```mermaid
flowchart TB
    subgraph App["Application"]
        API["Backend API"]
        ACT["Spring Boot Actuator\n/actuator/prometheus\n/actuator/health\n/actuator/info"]
    end
    subgraph Monitoring["Monitoring Stack"]
        NE["Node Exporter\nHost metrics"]
        VM["VictoriaMetrics\nSingle-node\nMetrics storage + Alert rules"]
        GF["Grafana\nDashboards"]
    end
    subgraph Alerting["Alerting"]
        SMTP["Email Server"]
        ADMIN["Administrator"]
    end

    API --> ACT
    VM -->|scrape| ACT
    VM -->|scrape| NE
    VM -->|alert| SMTP
    SMTP --> ADMIN
    GF -->|query PromQL| VM
```

#### 14.2.- Structured JSON logging

The Backend API writes logs as **event streams to stdout** (Factor XI), captured by the Docker log driver:

| Profile | Format | Encoder |
| ------- | ------ | ------- |
| **dev** | Plain-text console | Logback `PatternLayout` |
| **preprod, prod** | Structured JSON | `logstash-logback-encoder` |

**Standard log fields:**
- `timestamp` — ISO-8601
- `level` — DEBUG, INFO, WARN, ERROR
- `logger` — class name
- `thread` — thread name
- `message` — log message
- `graduate_program_id` — MDC tenant context
- `user_id` — MDC authenticated user
- `request_id` — MDC correlation ID for request tracing

#### 14.3.- Alert rules

| Metric | Threshold | Action |
| ------ | --------- | ------ |
| Host disk usage | > 80% | Email notification to administrator |
| Host memory usage | > 90% | Email notification to administrator |
| Backend API health check | Failure (unhealthy) | Email notification to administrator |
| Container restart count | > 3 in 5 minutes | Email notification to administrator |
| HTTP 5xx error rate | > 5% over 5 minutes | Email notification to administrator |

Alert rules are configured in VictoriaMetrics' alerting configuration and notifications are sent via the existing SMTP integration.

#### 14.4.- Observability element responsibilities

| Element | Responsibilities |
| ------- | ----------------- |
| **Spring Boot Actuator** | Expose health checks (liveness + readiness), build info (version, Git SHA), and JVM/HTTP/DB pool metrics in Prometheus format. |
| **Node Exporter** | Collect and expose host-level metrics: disk utilization, CPU usage, memory usage, network I/O. |
| **VictoriaMetrics** | Scrape, store, and query metrics; evaluate alert rules; send alert notifications via SMTP. Lower resource footprint than Prometheus (~7x less RAM). |
| **Grafana** | Render dashboards for the team; provide visual monitoring of system health, performance trends, and resource consumption. |
| **SMTP integration** | Deliver alert email notifications to the system administrator and/or coordinator. |

### 15.- Security architecture

This section documents the security architecture established in Iteration 3, covering the HTTP security pipeline, CWE Top 25 mitigations, security configuration externalization, role hierarchy, and audit event infrastructure.

#### 15.1.- Security filter chain architecture

The following diagram shows the HTTP request pipeline from the Nginx reverse proxy through the Spring Security filter chain to the REST Controllers. Security is enforced as a layered pipeline — each layer addresses a specific concern.

```mermaid
flowchart LR
    subgraph Pipeline["HTTP Security Pipeline"]
        NGINX["Nginx\nReverse Proxy\nTLS termination"]
        CORS["CORS Filter\nAllowed origins from env"]
        HEADERS["Security Headers\nCSP, X-Frame, X-Content-Type"]
        JWTF["JWT Auth Filter\nToken extraction\nRSA validation"]
        PREAUTH["@PreAuthorize\nSpEL role check"]
        CTRL["REST Controller\nBean Validation"]
    end
    NGINX --> CORS --> HEADERS --> JWTF --> PREAUTH --> CTRL
```

| Pipeline Stage | Responsibility | CWE Coverage |
| -------------- | -------------- | ------------ |
| **Nginx** | TLS termination; rate limiting; static asset serving; reverse proxy to API. | CWE-319 (cleartext transmission) |
| **CORS Filter** | Restricts API access to SPA origin only. Origin URL externalized (Factor III). | CWE-352 (CSRF) |
| **Security Headers** | Sets `Content-Security-Policy`, `X-Frame-Options: DENY`, `X-Content-Type-Options: nosniff`, `Strict-Transport-Security`. | CWE-79 (XSS), CWE-1021 (clickjacking) |
| **JWT Auth Filter** | Extracts and validates JWT (RSA-256 public key); populates SecurityContext; rejects invalid/expired tokens with 401. | CWE-287 (improper auth), CWE-306 (missing auth) |
| **@PreAuthorize** | Evaluates SpEL role expressions; rejects unauthorized requests with 403; logs violations via Audit Aspect. | CWE-862 (missing authorization), CWE-863 (incorrect authorization) |
| **REST Controller** | Bean Validation (`@Valid`) on all request bodies and path variables; JPA parameterized queries; no raw SQL. | CWE-20 (input validation), CWE-89 (SQL injection) |

#### 15.2.- CWE Top 25 coverage matrix

| CWE ID | Vulnerability | Mitigation | Layer |
| ------ | ------------- | ---------- | ----- |
| CWE-89 | SQL Injection | JPA parameterized queries; no raw SQL string concatenation | REST Controller + JPA |
| CWE-79 | Cross-Site Scripting (XSS) | Angular auto-escaping; `Content-Security-Policy` header; `X-Content-Type-Options: nosniff` | SPA + Security Headers |
| CWE-352 | Cross-Site Request Forgery | `SameSite=Strict` on refresh cookie; CORS origin restriction; JWT Bearer in header (not cookie-based auth) | CORS Filter + Cookie config |
| CWE-287 | Improper Authentication | Spring Security authentication filter; BCrypt password hashing; audit-logged failed login attempts | JWT Auth Filter + Password Encoder |
| CWE-862 | Missing Authorization | `@PreAuthorize` on all endpoints; `SecurityFilterChain` default-deny; Angular AuthGuard (UX) | @PreAuthorize + SecurityFilterChain |
| CWE-306 | Missing Authentication for Critical Function | `SecurityFilterChain` requires authentication for all paths except `/api/auth/**` and static assets | SecurityFilterChain |
| CWE-22 | Path Traversal | File access via signed URLs (no direct path exposure); Spring resource handling with path normalization | File Access Service |
| CWE-798 | Hard-coded Credentials | Factor III — all secrets in `.env` files; no credentials in source code; CI scan for secrets | Environment config + CI |
| CWE-502 | Deserialization of Untrusted Data | Jackson strict typing; no `ObjectInputStream` usage; Spring Boot built-in deserialization protections | REST Controller |
| CWE-20 | Improper Input Validation | Bean Validation (`@Valid`, `@NotBlank`, `@Email`, custom validators); Angular form validation (client-side) | REST Controller + SPA |
| CWE-319 | Cleartext Transmission | TLS termination at Nginx; `Strict-Transport-Security` header | Nginx |
| CWE-1021 | Improper Restriction of Rendered UI Layers | `X-Frame-Options: DENY` prevents clickjacking | Security Headers |

#### 15.3.- Security configuration externalization (Factor III)

All security-related configuration is externalized via environment variables in `.env.{dev,preprod,prod}` files. No secrets in source code.

| Variable | Description | Default |
| -------- | ----------- | ------- |
| `JWT_RSA_PRIVATE_KEY_PATH` | Path to RSA private key file (mounted as Docker volume) | — (required) |
| `JWT_RSA_PUBLIC_KEY_PATH` | Path to RSA public key file (mounted as Docker volume) | — (required) |
| `JWT_ACCESS_TOKEN_TTL_MINUTES` | Access token time-to-live | 15 |
| `JWT_REFRESH_TOKEN_TTL_DAYS` | Default refresh token time-to-live | 7 |
| `JWT_REMEMBER_ME_TTL_DAYS` | Refresh token TTL when "Remember me" is checked | 30 |
| `BCRYPT_WORK_FACTOR` | BCrypt cost parameter | 12 |
| `CORS_ALLOWED_ORIGINS` | Comma-separated list of allowed origins for CORS | — (required) |
| `FILE_HMAC_SECRET` | HMAC-SHA256 key for signed file URLs | — (required) |
| `FILE_SIGNED_URL_TTL_MINUTES` | Signed URL time-to-live | 60 |

RSA keys are mounted as files via Docker volumes (not embedded in environment variables) to protect the private key via filesystem permissions.

#### 15.4.- Role hierarchy

The Spring `RoleHierarchy` bean defines the following hierarchy, where higher roles inherit all permissions of lower roles:

```
SYSTEM_ADMIN > COORDINATOR > ASSISTANT > PROFESSOR > STUDENT > SPEAKER
```

> **Note:** This hierarchy is pending validation with the product owner. The `SYSTEM_ADMIN` role has full system access including user management, configuration, and monitoring.

| Role | Description | Access Level |
| ---- | ----------- | ------------ |
| **SYSTEM_ADMIN** | Platform-level administrator. Not tied to a specific graduate program. Full access to all system functions, user management, and configuration. | All functions |
| **COORDINATOR** | Graduate program coordinator. Manages planning, enrollment, students, professors, and reports for their program. | Full program management |
| **ASSISTANT** | Administrative assistant. Generates invitations, certificates, enrollment forms, and supports coordinator tasks. | Administrative support |
| **PROFESSOR** | Faculty member. Teaches courses, advises students, approves enrollments, uploads work products. | Teaching + advisory |
| **STUDENT** | Enrolled student. Selects courses, uploads evidence, views academic information. | Self-service academic |
| **SPEAKER** | Guest speaker for seminars. Limited access to seminar-related functions only. | Seminar access only |

#### 15.5.- Audit event infrastructure

The audit infrastructure captures system events at different verbosity levels, persisted to the `audit_events` table and simultaneously logged to stdout as structured JSON (Factor XI).

##### Audit event schema

| Field | Type | Description |
| ----- | ---- | ----------- |
| `id` | Long | Auto-generated primary key |
| `timestamp` | Instant | ISO-8601 event timestamp |
| `actor_id` | Long | FK to `users.id` — who performed the action |
| `actor_role` | RoleType | Role of the actor at the time of the event |
| `action` | String | Event identifier (e.g., `LOGIN_SUCCESS`, `STUDENT_CREATED`, `ENROLLMENT_APPROVED`) |
| `entity_type` | String | Target entity type (e.g., `Student`, `Enrollment`, `User`) |
| `entity_id` | Long | Target entity ID |
| `details` | String | JSON blob with additional context (changed fields, old/new values for mutations) |
| `severity` | AuditSeverity | `HIGH`, `STANDARD`, or `LOW` |
| `ip_address` | String | Client IP address |
| `graduate_program_id` | Long | Tenant context for multi-program filtering (QA-4) |

##### Verbosity levels

| Category | Severity | Captured By | Examples |
| -------- | -------- | ----------- | -------- |
| **Security — Authentication** | HIGH | AOP `SecurityAuditAspect` | `LOGIN_SUCCESS`, `LOGIN_FAILURE`, `TOKEN_REFRESH`, `LOGOUT`, `PASSWORD_CHANGE` |
| **Security — Authorization** | HIGH | AOP `SecurityAuditAspect` | `RBAC_VIOLATION`, `UNAUTHORIZED_ACCESS`, `ROLE_ESCALATION_ATTEMPT` |
| **Domain Mutations** | STANDARD | JPA `@EntityListeners` | `STUDENT_CREATED`, `GRADE_UPDATED`, `ENROLLMENT_APPROVED`, `PROFESSOR_REGISTERED` |
| **Read Operations** | LOW (configurable) | Optional — disabled by default in Prod | `DASHBOARD_VIEWED`, `REPORT_GENERATED` |

