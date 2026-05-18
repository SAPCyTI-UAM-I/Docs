# SPEC-004: GraduateProgram — modelo de dominio y persistencia JPA

> **Status:** ✅ Implemented
> **Author:** SAPCyTI SDD
> **Date:** 2026-05-12
> **Phase:** 2 | **ADD Iteration:** 1
> **Bounded Context:** Program Configuration (BC-04)
> **Drivers:** [QA-3](../../../design/ArchitecturalDrivers.md), [QA-4](../../../design/ArchitecturalDrivers.md) — parametrización multi-programa; soporte hasta 9 posgrados divisionales
> **Domain Schema:** [`program-configuration.schema.json`](../../domain/schemas/program-configuration.schema.json) — contrato para tipos, campos y comandos
> **Domain Features:** [`domain/features/program-configuration/`](../../domain/features/program-configuration/) — escenarios Gherkin enlazados a criterios de aceptación
> **Depends on:** [SPEC-003](SPEC-003_hexagonal-packages-tenant-filter-cors.md) — árbol de paquetes `configuration` y convenciones hexagonales
> **Blocks:** [SPEC-005](SPEC-005_configuration-parameter-persistence-isolation.md) — la tabla y entidad de parámetros referencian `graduate_programs`; [SPEC-006](SPEC-006_graduate-program-application-rest-api.md) — API y casos de uso sobre este aggregate
> **External Dependencies:**
>   - [ ] Ninguna — Phase 2 solo dominio + Flyway + adaptador JPA

---

## 1. Business Justification

El aggregate root `GraduateProgram` es el ancla multi-tenant del sistema: todo dato de negocio scope-able se discrimina por `graduateProgramId` ([ContextMap §2.1](../../domain/ContextMap.md)). Sin persistencia estable del programa, no hay QA-4 (multi-programa) ni base para QA-3 (parámetros por programa). Esta spec materializa el modelo y el repositorio del BC-04 según el schema, sin exponer aún API REST (fases posteriores).

**Referencia de drivers:** QA-3 y QA-4 en [ArchitecturalDrivers.md](../../../design/ArchitecturalDrivers.md).

**Acceptance Criteria (Business):**
- [ ] AC-1: Un programa de posgrado puede crearse y recuperarse desde PostgreSQL con `id` generado por la BD.
- [ ] AC-2: Los campos `name` y `division` cumplen longitudes y obligatoriedad definidas en `program-configuration.schema.json#/definitions/GraduateProgram`.
- [ ] AC-3: La integridad del modelo permite que [SPEC-005](SPEC-005_configuration-parameter-persistence-isolation.md) asocie parámetros mediante FK sin ambigüedad.
- [ ] AC-4: El nombre del programa es **único en base de datos** (`UNIQUE` en columna `name`), alineado con *Rejection of program with duplicate name* y con protección ante concurrencia.

---

## 2. Scope

### In Scope
- Entidad JPA `GraduateProgram` con `id`, `name`, `division` alineados al schema (sin mapear aún la colección `configurationParameters`; eso se añade en SPEC-005).
- Puerto de salida `GraduateProgramRepositoryPort` en `domain/port/out/`.
- Adaptador `GraduateProgramJpaAdapter` que implementa el puerto (`@Repository`).
- Migración Flyway `V1__create_graduate_programs.sql` (PostgreSQL).
- Pruebas de adaptador con `@DataJpaTest` para persistencia y lectura.

### Out of Scope
- Endpoints REST, DTOs, validación HTTP y reglas de negocio de aplicación (p. ej. rechazo 409 por nombre duplicado en API — escenarios en `graduate_program_management.feature`; se implementan cuando exista capa web y casos de uso).
- Entidad `ConfigurationParameter`, tabla de parámetros y puerto `ConfigurationParameterRepositoryPort` — [SPEC-005](SPEC-005_configuration-parameter-persistence-isolation.md).
- Auditoría explícita BC-05 en mutaciones (Iteration 3+).

### Assumptions
- Base PostgreSQL según `docker-compose.dev.yml` y perfil `dev`.
- Flyway activo en arranque; numeración `V1` es la primera migración del módulo compartido `db/migration`.
- Convención de paquetes `mx.uam.sapcyti.configuration` alineada a [technologies/backend.md](../../technologies/backend.md).

---

## 3. Architecture Impact

### Affected Layers

| Layer | Artifact | Action | Notes |
|-------|----------|--------|-------|
| `domain/model` | `GraduateProgram.java` | CREATE | `@Entity`; tabla `graduate_programs` |
| `domain/port/out` | `GraduateProgramRepositoryPort.java` | CREATE | Contrato de persistencia |
| `infrastructure/adapter/out` | `GraduateProgramJpaAdapter.java` | CREATE | Implementa puerto; Spring Data o `EntityManager` según convención del repo |
| `db/migration` | `V1__create_graduate_programs.sql` | CREATE | DDL idempotente Flyway |

### Package Location

```text
mx.uam.sapcyti.configuration/
├── domain/
│   ├── model/
│   │   └── GraduateProgram.java              ← CREATE
│   └── port/out/
│       └── GraduateProgramRepositoryPort.java ← CREATE
└── infrastructure/
    └── adapter/out/
        └── GraduateProgramJpaAdapter.java     ← CREATE
```

> **Referencia arquitectónica:** [`Architecture.md §6.1`](../../../design/Architecture.md) — estructura de módulos hexagonal

### Architectural Context

> Fragmento de [`Architecture.md` §4 — Domain model](../../../design/Architecture.md) (diagrama y tabla de elementos):

```
GraduateProgram "1" *-- "*" ConfigurationParameter

| **GraduateProgram** | Aggregate Root | Represents a UAM graduate program. Contains the parametric configuration 
of business rules, enabling the multi-graduate program support required by QA-4. |
```

Relación de composición AR–VO documentada en el modelo; la persistencia de `ConfigurationParameter` se implementa en SPEC-005.

### Cross-Module Dependencies

- Ningún otro bounded context importa clases de dominio de Configuration en esta fase; los consumidores futuros (Enrollment, Offering, Academic Management) usarán **puertos de consulta** definidos en iteraciones posteriores.
- Eventos de dominio lógicos no son obligatorios para esta spec de persistencia pura.

---

## 4. Technical Design

### 4.1 Domain Model

> **Source of truth:** [`program-configuration.schema.json`](../../domain/schemas/program-configuration.schema.json) `#/definitions/GraduateProgram`.

```java
// GraduateProgram.java — Aggregate Root
// Schema: program-configuration.schema.json#/definitions/GraduateProgram
@Entity
@Table(
    name = "graduate_programs",
    uniqueConstraints = @UniqueConstraint(
        name = "uq_graduate_program_name",
        columnNames = {"name"}))
public class GraduateProgram {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String name;

    @Column(nullable = false, length = 100)
    private String division;

    // configurationParameters: OneToMany se agrega en SPEC-005
}
```

**Invariants (dominio / Bean Validation donde aplique en capa de aplicación):**
- `name`: no en blanco; longitud 1–200 (schema `minLength`/`maxLength`); **único globalmente** (invariante reforzado en BD).
- `division`: no en blanco; longitud 1–100.

**Decisión de persistencia:** restricción **`UNIQUE` sobre `name`** obligatoria en `V1__create_graduate_programs.sql` y reflejada en `@Table(uniqueConstraints = …)` arriba. Refuerza el escenario Gherkin *Rejection of program with duplicate name* (`graduate_program_management.feature`) y evita duplicados bajo concurrencia; la capa API (cuando exista) puede además usar `existsByName` para respuesta 409 explícita.

**DDL de referencia (fragmento):**

```sql
CREATE TABLE graduate_programs (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    division VARCHAR(100) NOT NULL,
    CONSTRAINT uq_graduate_program_name UNIQUE (name)
);
```

### 4.2 Port Contracts

```java
// domain/port/out/GraduateProgramRepositoryPort.java
public interface GraduateProgramRepositoryPort {

    GraduateProgram save(GraduateProgram program);

    Optional<GraduateProgram> findById(Long id);

    List<GraduateProgram> findAll();

    boolean existsByName(String name);

    void deleteById(Long id);
}
```

> Nota: `existsByName` y `deleteById` preparan casos de uso y pruebas; si el equipo reduce alcance, documentar en revisión.

### 4.3 Infrastructure

- **`GraduateProgramJpaAdapter`:** `@Repository`, `@Transactional` en métodos de escritura; implementa `GraduateProgramRepositoryPort`.
- **Consultas:** sin filtro tenant adicional en esta entidad — el propio `id` del programa **es** el discriminante multi-tenant para tablas hijas ([QA-4 en Architecture.md AD — multi-tenant by discriminator](../../../design/Architecture.md)).
- **Flyway:** script SQL compatible PostgreSQL; nombres de tabla/columnas en snake_case.

### 4.4 API Contract (si aplica)

No aplica en Phase 2. Los escenarios HTTP de `graduate_program_management.feature` quedan para cuando existan `Controller` + casos de uso.

### 4.5 Frontend Contract (si aplica)

No aplica.

---

## 5. Security Considerations

Persistencia vía JPA con parámetros enlazados — sin SQL concatenado. RBAC y JWT no aplican en esta capa.

| # | Threat | CWE | Mitigation | Validated By |
|---|--------|-----|------------|--------------|
| — | No security impact en capa de persistencia pura | — | Consultas parametrizadas JPA | Code review |

**Access Control:** Los endpoints que restrinjan COORDINATOR/SYSTEM_ADMIN se especificarán con Identity & Access (Iteration 3+).

---

## 6. Edge Cases & Error Handling

| # | Scenario | Expected Behavior | HTTP Status (si aplica) | Feature Ref |
|---|----------|-------------------|-------------------------|-------------|
| EC-1 | Insertar segundo programa con mismo `name` | Fallo por constraint `UNIQUE (name)` en BD (`DataIntegrityViolationException`); capa futura puede pre-validar con `existsByName` → 409 | — (persistencia: excepción de integridad) | `graduate_program_management.feature` — *Rejection of program with duplicate name* |
| EC-2 | `name` o `division` vacíos | Validación en dominio o aplicación antes de persistir | — | *Rejection of program with empty name/division* |
| EC-3 | `findById` inexistente | `Optional.empty()` | — | *Query of non-existent program* (capa API después) |

---

## 7. Performance & Scalability Notes

| Concern | Detail | Mitigation |
|---------|--------|------------|
| Volumen de programas | ≤9 programas divisionales (QA-4) | `findAll()` aceptable para MVP; índice PK suficiente |

---

## 8. Migration & Rollback Strategy

- **Flyway:** `V1` solo crea `graduate_programs` — rollback operativo = nueva migración `V{N}__drop_graduate_programs.sql` si hiciera falta en entornos no productivos; en prod coordinar con datos existentes.
- **API:** sin cambios de contrato.
- **Datos:** tabla vacía al migrar desde cero.

---

## 9. Testing Strategy

| Test Type | Class | Scope | Framework |
|-----------|-------|-------|-----------|
| Adapter | `GraduateProgramJpaAdapterTest` o `GraduateProgramPersistenceIT` | save + findById + findAll; **segundo insert con mismo `name` debe fallar** (constraint) | `@DataJpaTest` |

> **Referencia:** [`technologies/testing.md`](../../technologies/testing.md)
> **Coverage mínimo:** ≥80% en código nuevo ([`implementation/implementationPlan.md`](../../../implementation/implementationPlan.md) si aplica)

---

## 10. Conventions Checklist

- [ ] Modelo de dominio con anotaciones JPA en `domain/model`
- [ ] Puerto de salida en `domain/port/out/`
- [ ] Adaptador en `infrastructure/adapter/out/` con `@Repository`
- [ ] Migración Flyway `V1__create_graduate_programs.sql` incluye `UNIQUE (name)`
- [ ] Tests `@DataJpaTest` para el adaptador
- [ ] Sin `System.out.println`; logging SLF4J donde corresponda

---

## 11. References

- **Architecture:** [`Architecture.md` §4 — Domain model](../../../design/Architecture.md)
- **Context Map:** [`ContextMap.md` §1.2 BC-04](../../domain/ContextMap.md)
- **Domain Schema:** [`program-configuration.schema.json`](../../domain/schemas/program-configuration.schema.json)
- **Domain Features:** [`graduate_program_management.feature`](../../domain/features/program-configuration/graduate_program_management.feature)
- **Iteration Plan:** [`IterationPlan.md`](../../../design/IterationPlan.md)
- **Decision Log:** [`progress.md`](../../../implementation/progress.md)
- **Technology Stack:** [`technologies/backend.md`](../../technologies/backend.md), [`technologies/testing.md`](../../technologies/testing.md)
- **Related Specs:** [SPEC-003](SPEC-003_hexagonal-packages-tenant-filter-cors.md), [SPEC-005](SPEC-005_configuration-parameter-persistence-isolation.md)

---

## 12. Review Log

| Date | Reviewer | Action | Notes |
|------|----------|--------|-------|
| — | — | — | — |
