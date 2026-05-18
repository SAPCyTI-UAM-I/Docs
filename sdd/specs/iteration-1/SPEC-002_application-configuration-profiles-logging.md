---
spec_id: SPEC-002
status: implemented
phase: 1
bounded_context: platform
drivers: [QA-3, QA-4, CON-6]
depends_on: [SPEC-001]
---

# SPEC-002: Configuración, perfiles Spring y logging estructurado

> **Status:** ✅ Implemented
> **Author:** SAPCyTI SDD
> **Date:** 2026-05-12
> **Phase:** 1 | **ADD Iteration:** 1
> **Bounded Context:** Plataforma / observabilidad transversal
> **Drivers:** [QA-3](../../../design/ArchitecturalDrivers.md), [QA-4](../../../design/ArchitecturalDrivers.md), [CON-6](../../../design/ArchitecturalDrivers.md) — parametrización por entorno; trazabilidad multi-programa; config externa sin rebuild
> **Domain Schema:** _No aplica._
> **Domain Features:** _No aplica._
> **Depends on:** [SPEC-001](SPEC-001_spring-boot-project-and-maven-build.md)
> **Blocks:** [SPEC-003](SPEC-003_hexagonal-packages-tenant-filter-cors.md)
> **External Dependencies:**
>   - [ ] Variables de entorno `DB_URL`, `DB_USER`, `DB_PASS`, `SPRING_PROFILES_ACTIVE`, `CORS_ALLOWED_ORIGINS` documentadas para dev

---

## 1. Business Justification

Los atributos de calidad QA-3 y QA-4 requieren **configuración externa** y **discriminación por programa de posgrado** en tiempo de ejecución. Sin perfiles Spring y logging con correlación (`graduate_program_id`, `user_id`, `request_id` en MDC), no es posible operar ni diagnosticar el sistema multi-tenant descrito en [`ContextMap.md`](../../domain/ContextMap.md) §2.1–2.2. Esta spec define `application.yml`, perfiles `dev` / `preprod` / `prod`, Actuator para salud y métricas, y `logback-spring.xml` con formato texto en desarrollo y JSON en ambientes productivos.

**Acceptance Criteria (Business):**
- [ ] AC-1: La conexión JDBC se resuelve exclusivamente por variables de entorno (`DB_*`), sin credenciales en el repositorio.
- [ ] AC-2: Cambiar `SPRING_PROFILES_ACTIVE` altera comportamiento log y endpoints expuestos según tabla de esta spec.
- [ ] AC-3: En `preprod`/`prod`, cada línea de log puede serializarse como JSON con campos MDC acordados ([`technologies/backend.md`](../../technologies/backend.md)).

---

## 2. Scope

### In Scope
- `src/main/resources/application.yml` — datasource vía env, JPA `ddl-auto: validate`, Flyway habilitado, configuración base de Actuator.
- `application-dev.yml`, `application-preprod.yml`, `application-prod.yml` — diferencias documentadas (p. ej. nivel de log, exposición de endpoints Actuator).
- `logback-spring.xml` — perfil `dev`: salida legible; `preprod`/`prod`: encoder Logstash JSON; uso de MDC keys: `graduate_program_id`, `user_id`, `request_id`.
- Propiedades Actuator: exponer al menos `health`, `info`, `prometheus` donde aplique por seguridad operativa (detalle en §4).

### Out of Scope
- Implementación de `TenantFilter` y población de MDC — [SPEC-003](SPEC-003_hexagonal-packages-tenant-filter-cors.md).
- Secrets management externo (Vault); solo variables de entorno.

### Assumptions
- PostgreSQL de Phase 0 alcanzable con las URLs de dev documentadas en [`implementation/phase0.md`](../../../implementation/phase0.md) si existe.
- Flyway ejecutará migraciones cuando existan scripts en `db/migration` (Phase 2+); la configuración debe dejar Flyway activo.

---

## 3. Architecture Impact

### Affected Layers

| Layer | Artifact | Action | Notes |
|-------|----------|--------|-------|
| Resources | `application*.yml` | CREATE | Perfiles y datasource |
| Resources | `logback-spring.xml` | CREATE | Perfiles springProfile |

### Package Location

```text
src/main/resources/
├── application.yml
├── application-dev.yml
├── application-preprod.yml
├── application-prod.yml
└── logback-spring.xml
```

### Architectural Context

> [`Architecture.md`](../../../design/Architecture.md) — contenedor Backend API y observabilidad:

```
| **PostgreSQL Database** | Store domain data, configuration parameters per graduate program, multi-tenant data, 
audit events, and refresh tokens; ensure transactional consistency. |
```

> [`technologies/backend.md`](../../technologies/backend.md) — configuración:

```
- Key env vars: DB_URL, DB_USER, DB_PASS, SPRING_PROFILES_ACTIVE, CORS_ALLOWED_ORIGINS
- MDC fields: graduate_program_id, user_id, request_id
```

### Cross-Module Dependencies

- SPEC-003 pondrá valores en MDC; esta spec solo define el formato de salida y keys esperadas.

---

## 4. Technical Design

### 4.1 Domain Model

_No aplica._

### 4.2 Port Contracts

_No aplica._

### 4.3 Infrastructure

**application.yml (base):**
- `spring.datasource.url`, `username`, `password` desde `${DB_URL}`, `${DB_USER}`, `${DB_PASS}`.
- `spring.jpa.hibernate.ddl-auto: validate`.
- `spring.flyway.enabled: true` (ajustar `locations` si el proyecto usa prefijo común para migraciones).
- `management.endpoints.web.exposure.include`: al menos `health`, `info`, `prometheus` en base o por perfil (restringir `prometheus` en dev si se desea).

**Perfiles:**
- `dev`: logs DEBUG/INFO razonables para desarrollo local; opcionalmente exponer más endpoints para debug.
- `preprod` / `prod`: nivel INFO/WARN; confirmar que JSON logging está activo vía `logback-spring.xml`.

**logback-spring.xml:**
- `<springProfile name="dev">`: `ConsoleAppender` con patrón legible (no JSON obligatorio).
- `<springProfile name="preprod | prod">`: appenders con `net.logstash.logback.encoder.LoggingEventCompositeJsonEncoder` o equivalente documentado en [`technologies/backend.md`](../../technologies/backend.md).
- Incluir MDC en el payload JSON para las tres keys nombradas.

### 4.4 API Contract (si aplica)

Endpoints Actuator (sin autenticación de aplicación en Phase 1 — endurecer en Iteration 3):

```
GET /actuator/health
GET /actuator/info
GET /actuator/prometheus   (si está incluido en exposure)
```

### 4.5 Frontend Contract (si aplica)

_No aplica._

---

## 5. Security Considerations

| # | Threat | CWE | Mitigation | Validated By |
|---|--------|-----|------------|--------------|
| SEC-1 | Credenciales en repo | CWE-798 | Solo placeholders; valores reales vía env | Revisión PR |
| SEC-2 | Exposición excesiva Actuator | CWE-200 | Limitar exposure por perfil; documentar para prod | Checklist despliegue |

**Access Control:** Spring Security aún no activo; no exponer Actuator públicamente en prod sin reverse proxy / red privada (fuera de alcance Phase 1 — documentar riesgo residual).

---

## 6. Edge Cases & Error Handling

| # | Scenario | Expected Behavior | HTTP Status | Feature Ref |
|---|----------|-------------------|-------------|-------------|
| EC-1 | Variable `DB_URL` ausente | Fallo claro al arrancar (BindException / datasource) | — | — |
| EC-2 | Perfil desconocido | Spring usa default + warning; documentar perfiles válidos | — | — |

---

## 7. Performance & Scalability Notes

Logging JSON tiene overhead menor frente a I/O red; aceptable para QA operativa. Métricas Micrometer vía Actuator soportan escalado horizontal futuro (QA-5).

---

## 8. Migration & Rollback Strategy

- Revertir archivos YAML y logback elimina la spec; sin impacto en datos.

---

## 9. Testing Strategy

| Test Type | Class | Scope | Framework |
|-----------|-------|-------|-----------|
| Integration | Context load opcional | Arranque con `spring.profiles.active=dev` y datasource test/embebido o Testcontainers — **opcional** en Phase 1 si el equipo prioriza velocidad | Spring Boot Test |
| Manual | — | Verificar `/actuator/health` con perfil `dev` | — |

---

## 10. Conventions Checklist

- [ ] Sin secretos en YAML versionado
- [ ] MDC keys exactamente: `graduate_program_id`, `user_id`, `request_id`
- [ ] Perfiles nombrados: `dev`, `preprod`, `prod`

---

## 11. References

- **Architecture:** [`Architecture.md §5–6`](../../../design/Architecture.md)
- **Context Map:** [`ContextMap.md`](../../domain/ContextMap.md) §2.2 Multi-tenant Context
- **Technology Stack:** [`technologies/backend.md`](../../technologies/backend.md)
- **Related Specs:** [SPEC-001](SPEC-001_spring-boot-project-and-maven-build.md), [SPEC-003](SPEC-003_hexagonal-packages-tenant-filter-cors.md)

---

## 12. Review Log

| Date | Reviewer | Action | Notes |
|------|----------|--------|-------|
| 2026-05-12 | SAPCyTI SDD | 🔲 Draft | Creación inicial desde Phase 1 A1.2 |
