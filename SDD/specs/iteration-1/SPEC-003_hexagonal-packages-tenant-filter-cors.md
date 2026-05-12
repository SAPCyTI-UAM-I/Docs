# SPEC-003: Paquetes hexagonales, TenantFilter y CORS

> **Status:** 🔲 Draft | 🔵 Approved | ✅ Implemented | ⛔ Blocked | 🔄 Amended
> **Author:** SAPCyTI SDD
> **Date:** 2026-05-12
> **Phase:** 1 | **ADD Iteration:** 1
> **Bounded Context:** Plataforma compartida + layout de los 6 BC (sin lógica de dominio aún)
> **Drivers:** [QA-4](../../../ArchitecturalDrivers.md), [CON-6](../../../ArchitecturalDrivers.md), [QA-3](../../../ArchitecturalDrivers.md) — multi-programa; estructura modular predecible; base para parametrización por programa ([`ContextMap.md`](../../domain/ContextMap.md) BC-04)
> **Domain Schema:** _No aplica_ — la identidad `graduateProgramId` como ancla multi-tenant está en [`ContextMap.md`](../../domain/ContextMap.md) §2.1; el schema [`program-configuration.schema.json`](../../domain/schemas/program-configuration.schema.json) se usará en Phase 2 ([SPEC-004](SPEC-004_graduate-program-domain-persistence.md)).
> **Domain Features:** _No aplica_ en Phase 1.
> **Depends on:** [SPEC-001](SPEC-001_spring-boot-project-and-maven-build.md), [SPEC-002](SPEC-002_application-configuration-profiles-logging.md)
> **Blocks:** [SPEC-004](SPEC-004_graduate-program-domain-persistence.md) — el código BC-04 debe ubicarse en el árbol creado aquí
> **External Dependencies:**
>   - [ ] Cliente HTTP (SPA futura) enviará `X-Graduate-Id`; en dev por defecto se permite origen `http://localhost:4200` ([`technologies/backend.md`](../../technologies/backend.md))

---

## 1. Business Justification

QA-4 exige que hasta **9 programas de posgrado** convivan sin cambios estructurales; el **tenant runtime** debe establecerse antes de cualquier caso de uso. Según [`ContextMap.md`](../../domain/ContextMap.md) §2.1, `graduateProgramId` es la identidad compartida emitida por BC-04 y consumida por los demás BC. Esta spec crea el **árbol de paquetes hexagonal** para los seis BC más `shared`, implementa `TenantContext` + `TenantFilter` (`X-Graduate-Id` → ThreadLocal + MDC + `X-Request-Id`), CORS desde env, y documenta la regla de dependencias en `src/README.md`, alineado a [`Architecture.md` §6.1](../../../Design/Architecture.md).

**Acceptance Criteria (Business):**
- [ ] AC-1: Cada petición HTTP autenticada o pre-auth puede portar `X-Graduate-Id`; el valor queda disponible en `TenantContext` y en MDC como `graduate_program_id` para logs ([SPEC-002](SPEC-002_application-configuration-profiles-logging.md)).
- [ ] AC-2: El árbol de directorios refleja los BC documentados (configuration, identity, academic, offering, enrollment, audit) más `shared`, con capas hexagonales y `package-info.java` que explican dependencias permitidas.
- [ ] AC-3: CORS permite el origen configurado por `CORS_ALLOWED_ORIGINS` (default `http://localhost:4200`) para habilitar la SPA sin hardcode en código Java salvo default documentado.

---

## 2. Scope

### In Scope
- Paquete **referencia** `configuration` con árbol completo: `domain/model`, `domain/port/in`, `domain/port/out`, `application/service`, `infrastructure/adapter/in/dto`, `infrastructure/adapter/out`, `infrastructure/mapper`, cada uno con `package-info.java`.
- Paquetes **placeholder**: `identity` (con `infrastructure/security/`), `academic` (con `domain/service/`, `infrastructure/mapper/`), `offering` (con `infrastructure/acl/`), `enrollment` (con `infrastructure/acl/`), `audit` — cada uno con `package-info.java` que documenta BC, subdominio y alcance de iteración.
- `shared/tenant/TenantContext.java` — `ThreadLocal<Long>` con `get()`, `set(Long)`, `clear()`.
- `shared/tenant/TenantFilter.java` — extiende `OncePerRequestFilter`; lee header `X-Graduate-Id`, valida/parsing según §4; escribe MDC; genera o reenvía `X-Request-Id`; `finally` llama `TenantContext.clear()` y limpia MDC keys definidas.
- `shared/config/WebConfig.java` — `WebMvcConfigurer` registrando CORS desde `${CORS_ALLOWED_ORIGINS:http://localhost:4200}` (lista separada por comas si se acuerda en implementación).
- `src/README.md` — visión de módulos, capas hexagonales, reglas de dependencia ([`technologies/backend.md`](../../technologies/backend.md)).
- Tests unitarios de `TenantContext` y `TenantFilter` (MockMvc o `MockHttpServletRequest`/`Response`) según §9.

### Out of Scope
- Validación de que el `graduateProgramId` exista en BD — Phase 2+.
- Spring Security y JWT — Iteration 3.
- Endpoints REST de negocio.

### Assumptions
- Base package Java: `mx.uam.sapcyti` con subpaquetes por BC como en [`Architecture.md` §6.1](../../../Design/Architecture.md).
- El filtro se registra como `@Bean` FilterRegistrationBean o componente con orden compatible con futura cadena de seguridad (orden documentado en código).

---

## 3. Architecture Impact

### Affected Layers

| Layer | Artifact | Action | Notes |
|-------|----------|--------|-------|
| `configuration/*` | `package-info.java` (+ dirs) | CREATE | Plantilla hexagonal BC-04 |
| `identity`, `academic`, `offering`, `enrollment`, `audit` | `package-info.java` (+ dirs) | CREATE | Placeholders |
| `shared/tenant` | `TenantContext.java`, `TenantFilter.java` | CREATE | QA-4 |
| `shared/config` | `WebConfig.java` | CREATE | CORS |
| Raíz fuente | `README.md` | CREATE | Documentación estructura |

### Package Location

```text
mx.uam.sapcyti/
├── configuration/
│   ├── domain/model/
│   ├── domain/port/in/
│   ├── domain/port/out/
│   ├── application/service/
│   └── infrastructure/
│       ├── adapter/in/dto/
│       ├── adapter/out/
│       └── mapper/
├── identity/
│   └── infrastructure/security/
├── academic/
│   ├── domain/service/
│   └── infrastructure/mapper/
├── offering/
│   └── infrastructure/acl/
├── enrollment/
│   └── infrastructure/acl/
├── audit/
└── shared/
    ├── tenant/
    │   ├── TenantContext.java
    │   └── TenantFilter.java
    └── config/
        └── WebConfig.java
```

> **Referencia arquitectónica:** [`Architecture.md` §6.1 — Module package structure](../../../Design/Architecture.md)

### Architectural Context

> Extracto de [`Architecture.md` §6.1 — Module package structure](../../../Design/Architecture.md):

```
Each bounded context module follows an identical hexagonal package layout.

identity/                           # Identity & Access bounded context
├── domain/
│   ├── model/
│   ├── port/in/
│   └── port/out/
├── application/
│   └── service/
└── infrastructure/
    ├── adapter/in/
    ├── adapter/out/
    └── security/

academic/                           # Academic Management bounded context
├── domain/
│   ├── model/
│   ├── service/
│   ├── port/in/
│   └── port/out/
...

offering/ ... acl/
enrollment/ ... acl/
```

> Context Map — identidad multi-tenant ([`ContextMap.md`](../../domain/ContextMap.md) §2.1):

```
| graduateProgramId | Program Configuration | Academic Management, Academic Offering, Enrollment, Audit | Reference by ID. Multi-tenant scope in all operations. |
```

### Cross-Module Dependencies

- Ningún BC importa clases de dominio de otro BC en Phase 1.
- `TenantFilter` es transversal; futuros controladores leerán `TenantContext` o MDC según convención del equipo.

---

## 4. Technical Design

### 4.1 Domain Model

_No aggregate en esta spec._ `TenantContext` es infraestructura de alcance request:

```java
// TenantContext.java — request-scoped tenant id (technical)
public final class TenantContext {

    private static final ThreadLocal<Long> CURRENT = new ThreadLocal<>();

    public static Long get() {
        return CURRENT.get();
    }

    public static void set(Long graduateProgramId) {
        CURRENT.set(graduateProgramId);
    }

    public static void clear() {
        CURRENT.remove();
    }

    private TenantContext() {}
}
```

**Invariants:**
- Tras cada request, `clear()` debe ejecutarse para evitar fugas entre hilos en el pool de Tomcat.

### 4.2 Port Contracts

_No aplica._

### 4.3 Infrastructure

**TenantFilter (comportamiento obligatorio):**
1. Leer header `X-Graduate-Id` (case-insensitive recomendado para robustez).
2. Si está presente y es numérico: `TenantContext.set(id)` y `MDC.put("graduate_program_id", String.valueOf(id))`.
3. Si está ausente o inválido: definir política explícita — **Phase 1:** no abortar request salvo que el equipo acuerde 400; documentar en §6 si se usa valor null y log WARN (endpoints públicos futuros pueden requerir header — endurecer en specs posteriores).
4. `X-Request-Id`: si el cliente envía, reusar; si no, generar UUID y añadir a respuesta `X-Request-Id`.
5. `MDC.put("request_id", ...)` alineado a SPEC-002.
6. `user_id` en MDC quedará vacío hasta JWT (Iteration 3) — no inventar valor.

**WebConfig:** `addCorsMappings` con `allowedOrigins` parseados desde env; métodos `GET, POST, PUT, PATCH, DELETE, OPTIONS` según necesidad SPA; headers permitidos incluyen `X-Graduate-Id`, `X-Request-Id`, `Authorization` (para no romper Iteration 3).

### 4.4 API Contract (si aplica)

Headers contract (cross-cutting):

```
X-Graduate-Id: <Long>     # ID del programa de posgrado (BC-04); obligatorio para operaciones multi-tenant cuando el endpoint lo requiera
X-Request-Id: <UUID>      # Correlación; opcional en request, siempre presente en response tras el filtro
```

### 4.5 Frontend Contract (si aplica)

La SPA enviará `X-Graduate-Id` desde el contexto de programa seleccionado ([`Architecture.md` §6.2](../../../Design/Architecture.md) — Tenant Context en Core). Phase 1 solo prepara el servidor.

---

## 5. Security Considerations

| # | Threat | CWE | Mitigation | Validated By |
|---|--------|-----|------------|--------------|
| SEC-1 | Header `X-Graduate-Id` falsificado | CWE-862 | JWT + validación de pertenencia en Iteration 3; Phase 1 solo propaga valor | Documentado |
| SEC-2 | CORS misconfiguration | CWE-942 | Orígenes solo desde env; sin `*` con credenciales | WebConfig test |

**Access Control:** Phase 1 no implementa RBAC; el filtro no sustituye autorización.

---

## 6. Edge Cases & Error Handling

| # | Scenario | Expected Behavior | HTTP Status | Feature Ref |
|---|----------|-------------------|-------------|-------------|
| EC-1 | `X-Graduate-Id` no numérico | Log WARN; no establecer tenant; o 400 si política estricta — **decidir en implementación y documentar** | 200 o 400 | — |
| EC-2 | Header ausente en API que más adelante requerirá tenant | Permitir en Phase 1; specs de Phase 2+ añaden validación | — | — |
| EC-3 | Doble invocación del filtro | `OncePerRequestFilter` garantiza una vez por request | — | — |

---

## 7. Performance & Scalability Notes

ThreadLocal O(1); sin preocupación de rendimiento. Request IDs permiten trazar carga en logs agregados.

---

## 8. Migration & Rollback Strategy

Solo código fuente y docs; rollback eliminando paquetes y filtro.

---

## 9. Testing Strategy

| Test Type | Class | Scope | Framework |
|-----------|-------|-------|-----------|
| Unit | `TenantContextTest` | set/get/clear y ausencia de fuga entre tests secuenciales | JUnit 5 |
| Unit / Slice | `TenantFilterTest` | Header presente → MDC + context; finally limpia; `X-Request-Id` generado o preservado | Spring Test `MockMvc` o mocks servlet |
| Unit | `WebConfigTest` *(opcional)* | CORS permite origen por defecto | Spring |

> **Transition criteria** (Phase 1): `mvn test` pasa tests de TenantFilter y TenantContext ([`phase1.md`](../../../implementations/phase1.md)).

---

## 10. Conventions Checklist

- [ ] Paquetes siguen diagrama §6.1 y reglas en [`technologies/backend.md`](../../technologies/backend.md)
- [ ] Sin lógica de negocio en filtros
- [ ] MDC limpiado en `finally`
- [ ] `package-info.java` describe capa y dependencias permitidas

---

## 11. References

- **Architecture:** [`Architecture.md §6.1`](../../../Design/Architecture.md)
- **Context Map:** [`ContextMap.md`](../../domain/ContextMap.md) — §1 (BC), §2.1–2.2
- **Technology Stack:** [`technologies/backend.md`](../../technologies/backend.md)
- **Implementation Phase:** [`phase1.md`](../../../implementations/phase1.md)
- **Decision Log:** [`progress.md`](../../../implementations/progress.md) — D-008 (TenantFilter en `shared/tenant`)
- **Related Specs:** [SPEC-002](SPEC-002_application-configuration-profiles-logging.md), [SPEC-004](SPEC-004_graduate-program-domain-persistence.md)

---

## 12. Review Log

| Date | Reviewer | Action | Notes |
|------|----------|--------|-------|
| 2026-05-12 | SAPCyTI SDD | 🔲 Draft | Creación inicial desde Phase 1 A1.3 |
