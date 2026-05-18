# SPEC-001: Proyecto Spring Boot y build Maven

> **Status:** ✅ Implemented | 🔲 Draft | 🔵 Approved | ⛔ Blocked | 🔄 Amended
> **Author:** SAPCyTI SDD
> **Date:** 2026-05-12
> **Phase:** 1 | **ADD Iteration:** 1
> **Bounded Context:** Plataforma / bootstrap (sin BC de dominio)
> **Drivers:** [CON-1](../../../ArchitecturalDrivers.md), [CON-6](../../../ArchitecturalDrivers.md) — Java + OSS; monolito modular predecible para prácticas cortas
> **Domain Schema:** _No aplica_ — esta spec solo establece el artefacto compilable y dependencias base ([`technologies/backend.md`](../../technologies/backend.md)).
> **Domain Features:** _No aplica_ — Phase 1 es scaffolding; [`ContextMap.md`](../../domain/ContextMap.md) §2.1 define `graduateProgramId` como ancla multi-tenant para fases posteriores.
> **Depends on:** —
> **Blocks:** [SPEC-002](SPEC-002_application-configuration-profiles-logging.md)
> **External Dependencies:**
>   - [ ] JDK 21 y Maven 3.9+ (o wrapper) en el entorno de desarrollo

---

## 1. Business Justification

Sin un proyecto Spring Boot coherente con el stack acordado, no es posible cumplir CON-1 ni iterar con estructura estable (CON-6). Esta spec materializa el **parent POM**, dependencias de [`technologies/backend.md`](../../technologies/backend.md), plugins de compilación, cobertura y estilo, y el punto de entrada `SapcytiApplication`, de modo que el repositorio compile de forma reproducible antes de dominio o multi-tenant.

**Acceptance Criteria (Business):**
- [ ] AC-1: El código fuente compila con `mvn clean compile` usando Java 21 y Spring Boot 3.4.5.
- [ ] AC-2: Las dependencias declaradas coinciden con la tabla “Core Dependencies” y “Observability” de [`technologies/backend.md`](../../technologies/backend.md) para esta fase (sin añadir aún Spring Security ni JWT — Iteration 3).
- [ ] AC-3: El pipeline de build puede fallar el build si el estilo (Checkstyle) o cobertura (Jacoco, umbral ≥80% cuando existan tests) no se cumplen según config del POM.

---

## 2. Scope

### In Scope
- `pom.xml` en la raíz del módulo backend con `spring-boot-starter-parent` 3.4.5 (o BOM equivalente que fije esa versión).
- Dependencias: `spring-boot-starter-web`, `spring-boot-starter-data-jpa`, `spring-boot-starter-validation`, `spring-boot-starter-actuator`, `flyway-core`, `flyway-database-postgresql`, `postgresql`, `mapstruct`, `logstash-logback-encoder` (versiones alineadas al parent Spring Boot salvo que [`technologies/backend.md`](../../technologies/backend.md) exija pin explícito).
- Plugins: `spring-boot-maven-plugin`, `maven-compiler-plugin` (release/source/target 21, annotation processor paths para MapStruct), `jacoco-maven-plugin` (≥80% líneas cuando existan clases instrumentadas), `maven-checkstyle-plugin` (Google Java Style; línea 150 a nivel Checker según decisión D-009 en [`progress.md`](../../../implementations/progress.md)).
- Maven Wrapper (`mvnw`, `mvnw.cmd`, `.mvn/wrapper`).
- Clase `SapcytiApplication` con `@SpringBootApplication` en el paquete raíz acordado (`mx.uam.sapcyti` o subpaquete estándar del repo).

### Out of Scope
- Perfiles `application-*.yml`, Flyway scripts, filtros HTTP, paquetes hexagonales por BC — [SPEC-002](SPEC-002_application-configuration-profiles-logging.md), [SPEC-003](SPEC-003_hexagonal-packages-tenant-filter-cors.md).
- Spring Security, JWT, endpoints REST de negocio.

### Assumptions
- PostgreSQL local disponible vía Phase 0 / `docker-compose.dev.yml` cuando se ejecute la app; esta spec no exige BD para `compile`.
- El grupo `artifactId` y paquete base siguen convención institucional ya usada en specs posteriores (`mx.uam.sapcyti`).

---

## 3. Architecture Impact

### Affected Layers

| Layer | Artifact | Action | Notes |
|-------|----------|--------|-------|
| Raíz del backend | `pom.xml` | CREATE | Parent Spring Boot + dependencias Phase 1 |
| Raíz del backend | `mvnw`, `.mvn/wrapper/*` | CREATE | Reproducibilidad |
| Bootstrap | `SapcytiApplication.java` | CREATE | `@SpringBootApplication` |

### Package Location

```text
mx.uam.sapcyti/
└── SapcytiApplication.java                    ← CREATE
```

> **Referencia arquitectónica:** [`Architecture.md §6.1`](../../../Design/Architecture.md) — el backend es monolito modular hexagonal; esta spec solo crea el contenedor Maven y el bootstrap.

### Architectural Context

> Fragmento de [`Architecture.md` §6.1 — SAPCyTI Backend API](../../../Design/Architecture.md):

```
The Backend API is structured as a modular monolith, following Hexagonal Architecture (Ports & Adapters) 
and DDD principles. Each bounded context (§4.1) is a module with the same internal hexagonal structure: 
driving adapters → application layer → domain layer → driven adapters.
```

### Cross-Module Dependencies

- Ninguna entre BCs; esta spec no introduce puertos de dominio.

---

## 4. Technical Design

### 4.1 Domain Model

_No aplica._

### 4.2 Port Contracts

_No aplica._

### 4.3 Infrastructure

- **POM:** `dependencyManagement` heredado de Spring Boot; sin BOM adicional salvo necesidad documentada.
- **Compiler:** `--release 21`; procesador MapStruct en `annotationProcessorPaths` junto con `lombok` si se introduce en el mismo proyecto más adelante (no obligatorio en SPEC-001).
- **Jacoco:** ejecutar en `verify`; umbral mínimo líneas 80% cuando haya código cubrible (tests introducidos en SPEC-003 en adelante).

### 4.4 API Contract (si aplica)

_No aplica_ — sin controladores en esta spec.

### 4.5 Frontend Contract (si aplica)

_No aplica._

---

## 5. Security Considerations

Impacto directo limitado a dependencias y superficie de arranque. No se expone aún API de negocio.

| # | Threat | CWE | Mitigation | Validated By |
|---|--------|-----|------------|--------------|
| SEC-1 | Dependencias con CVE conocidos | CWE-1104 | OWASP Dependency-Check en CI ([`technologies/backend.md`](../../technologies/backend.md)); revisión periódica | Pipeline |
| SEC-2 | Stack traces en logs por defecto | CWE-209 | Perfiles y logging estructurado en SPEC-002 | Revisión SPEC-002 |

**Access Control:** No aplica en SPEC-001.

---

## 6. Edge Cases & Error Handling

| # | Scenario | Expected Behavior | HTTP Status (si aplica) | Feature Ref |
|---|----------|-------------------|------------------------|-------------|
| EC-1 | Spring Initializr u otro generador externo no disponible | Crear `pom.xml` manualmente (precedente D-007) | — | — |
| EC-2 | Wrapper Maven corrupto en Windows | Documentar uso de `mvn` global como fallback (R-1.3 en phase1) | — | — |

---

## 7. Performance & Scalability Notes

No performance concerns — solo artefacto de build y clase main vacía.

---

## 8. Migration & Rollback Strategy

- **Código:** Eliminar `pom.xml`, wrapper y `SapcytiApplication` revierte la spec.
- **Datos:** Ninguno.

---

## 9. Testing Strategy

| Test Type | Class | Scope | Framework |
|-----------|-------|-------|-----------|
| Smoke | — | `mvn clean compile` sin errores | Maven |
| Unit | _(posterior)_ | Cobertura global ≥80% cuando existan tests | JUnit 5 |

---

## 10. Conventions Checklist

- [ ] Versiones de Spring Boot y Java alineadas a [`technologies/backend.md`](../../technologies/backend.md)
- [ ] Sin `System.out` en código de producción (aún no hay lógica)
- [ ] MapStruct configurado en compilador cuando se añadan mappers
- [ ] Checkstyle Google Style con reglas del proyecto

---

## 11. References

- **Architecture:** [`Architecture.md §6.1`](../../../Design/Architecture.md)
- **Context Map:** [`ContextMap.md`](../../domain/ContextMap.md) — identidad multi-tenant §2.1
- **Iteration Plan:** [`IterationPlan.md`](../../../Design/IterationPlan.md)
- **Decision Log:** [`progress.md`](../../../implementations/progress.md) — D-007, D-009
- **Technology Stack:** [`technologies/backend.md`](../../technologies/backend.md)

---

## 12. Review Log

| Date | Reviewer | Action | Notes |
|------|----------|--------|-------|
| 2026-05-12 | SAPCyTI SDD | 🔲 Draft | Creación inicial desde Phase 1 A1.1 |
