# SPEC-005: ConfigurationParameter — persistencia, CRUD y aislamiento por programa

> **Status:** ✅ Implemented
> **Author:** SAPCyTI SDD
> **Date:** 2026-05-12
> **Phase:** 2 | **ADD Iteration:** 1
> **Bounded Context:** Program Configuration (BC-04)
> **Drivers:** [QA-3](../../../ArchitecturalDrivers.md), [QA-4](../../../ArchitecturalDrivers.md) — parametrización sin cambiar código; aislamiento multi-programa
> **Domain Schema:** [`program-configuration.schema.json`](../../domain/schemas/program-configuration.schema.json)
> **Domain Features:** [`domain/features/program-configuration/`](../../domain/features/program-configuration/) — especialmente `configuration_parameter_management.feature`
> **Depends on:** [SPEC-004](SPEC-004_graduate-program-domain-persistence.md) — debe existir tabla `graduate_programs` y entidad `GraduateProgram`
> **Blocks:** [SPEC-006](SPEC-006_graduate-program-application-rest-api.md), [SPEC-007](SPEC-007_configuration-parameter-application-rest-global-errors.md); puertos de lectura consumidos por Enrollment / Academic Offering / Academic Management (iteraciones posteriores)
> **External Dependencies:**
>   - [ ] Ninguna para Phase 2

---

## 1. Business Justification

Los parámetros de configuración externalizan reglas de negocio (fechas, cupos, límites) por programa sin despliegue de código ([QA-3](../../../ArchitecturalDrivers.md)). El aislamiento estricto entre programas ([QA-4](../../../ArchitecturalDrivers.md)) exige que toda lectura/escritura de parámetros esté acotada por `graduateProgramId`. Esta spec define el VO persistido como **entidad JPA** hijo de `GraduateProgram` (decisión R-2.1 en [phase2.md](../../../implementations/phase2.md)): tabla propia, FK y unicidad `(graduate_program_id, key)`.

**Acceptance Criteria (Business):**
- [ ] AC-1: CRUD de parámetros por `graduateProgramId` sin filtrar datos de otro programa.
- [ ] AC-2: Clave `key` en formato UPPER_SNAKE_CASE según pattern del schema; `value` y `description` acotados en longitud.
- [ ] AC-3: Escenario de aislamiento — dos programas con distinto `MAX_COURSES_PER_TERM` devuelven valores correctos ([`configuration_parameter_management.feature`](../../domain/features/program-configuration/configuration_parameter_management.feature) — *Parameter isolation between programs*).

---

## 2. Scope

### In Scope
- Entidad JPA `ConfigurationParameter` con FK a `GraduateProgram`; columnas alineadas a `#/definitions/ConfigurationParameter`.
- Actualización de `GraduateProgram` con `@OneToMany(mappedBy = ..., cascade = ..., orphanRemoval = ...)` hacia `ConfigurationParameter`.
- Puerto `ConfigurationParameterRepositoryPort` — operaciones CRUD explícitas por programa y por clave.
- Adaptador `ConfigurationParameterJpaAdapter` (`@Repository`).
- Migración Flyway `V2__create_configuration_parameters.sql`.
- Pruebas `@DataJpaTest`: CRUD, unicidad de clave por programa, aislamiento entre dos programas.

### Out of Scope
- API REST y comandos `SetConfigurationParameterCommand` / `DeleteConfigurationParameterCommand` como contratos HTTP (Iteration 3+ o fase de aplicación).
- Validación de JWT, `X-Graduate-Id`, RBAC y mensajes i18n de error HTTP.
- Publicación de eventos de auditoría BC-05.

### Assumptions
- [SPEC-004](SPEC-004_graduate-program-domain-persistence.md) implementada (tabla `graduate_programs`).
- Pattern de clave: `^[A-Z][A-Z0-9_]*$` (equivale a UPPER_SNAKE_CASE permitiendo dígitos tras el primer carácter).

---

## 3. Architecture Impact

### Affected Layers

| Layer | Artifact | Action | Notes |
|-------|----------|--------|-------|
| `domain/model` | `ConfigurationParameter.java` | CREATE | `@Entity`; FK `graduate_program_id` |
| `domain/model` | `GraduateProgram.java` | MODIFY | `@OneToMany` a parámetros |
| `domain/port/out` | `ConfigurationParameterRepositoryPort.java` | CREATE | CRUD por programa |
| `infrastructure/adapter/out` | `ConfigurationParameterJpaAdapter.java` | CREATE | Implementa puerto |
| `db/migration` | `V2__create_configuration_parameters.sql` | CREATE | Índices + UNIQUE compuesto |

### Package Location

```text
mx.uam.sapcyti.configuration/
├── domain/
│   ├── model/
│   │   ├── GraduateProgram.java              ← MODIFY
│   │   └── ConfigurationParameter.java       ← CREATE
│   └── port/out/
│       └── ConfigurationParameterRepositoryPort.java ← CREATE
└── infrastructure/
    └── adapter/out/
        └── ConfigurationParameterJpaAdapter.java ← CREATE
```

### Architectural Context

De [`Architecture.md` §4 — Description of domain model elements](../../../Design/Architecture.md):

```
| **ConfigurationParameter** | Value Object | Immutable key-value pair that externalizes a business rule of the graduate 
program. Allows modifying dates, quotas, and criteria without changing source code, in response to QA-3. |
```

Persistencia: el VO se materializa como fila versionada en BD con identidad surrogate (`id`) y vínculo al AR para soportar CRUD y consultas eficientes sin serializar colecciones embebidas complejas.

### Cross-Module Dependencies

- Consumidores downstream referencian `graduateProgramId` y leerán parámetros vía puertos de consulta futuros (Architecture — Customer/Supplier hacia Enrollment y Offering).
- Esta spec solo garantiza datos correctamente segregados en BD y en el adaptador.

---

## 4. Technical Design

### 4.1 Domain Model

> **Source of truth:** [`program-configuration.schema.json`](../../domain/schemas/program-configuration.schema.json) `#/definitions/ConfigurationParameter`.

```java
// ConfigurationParameter.java — persistido como Entity (patrón VO + surrogate id)
@Entity
@Table(name = "configuration_parameters",
       uniqueConstraints = @UniqueConstraint(
           name = "uq_configuration_parameters_program_key",
           columnNames = {"graduate_program_id", "param_key"}))
public class ConfigurationParameter {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "graduate_program_id", nullable = false)
    private GraduateProgram graduateProgram;

    @Column(name = "param_key", nullable = false, length = 100)
    private String key;

    @Column(name = "param_value", nullable = false, length = 500)
    private String value;

    @Column(length = 500)
    private String description;
}
```

> **Columnas SQL:** `key` es palabra reservada en PostgreSQL — usar `param_key` / `param_value` en BD y mapear al campo Java `key`/`value`.

**Invariants:**
- `key`: obligatorio; pattern `^[A-Z][A-Z0-9_]*$`; max 100 caracteres.
- `value`: obligatorio; max 500 caracteres.
- `description`: opcional; max 500 caracteres.
- Toda instancia está ligada a exactamente un `GraduateProgram`.

En `GraduateProgram`, agregar:

```java
@OneToMany(mappedBy = "graduateProgram", cascade = CascadeType.ALL, orphanRemoval = true)
private List<ConfigurationParameter> configurationParameters = new ArrayList<>();
```

### 4.2 Port Contracts

```java
public interface ConfigurationParameterRepositoryPort {

    ConfigurationParameter save(ConfigurationParameter parameter);

    Optional<ConfigurationParameter> findByGraduateProgramIdAndKey(Long graduateProgramId, String key);

    List<ConfigurationParameter> findAllByGraduateProgramId(Long graduateProgramId);

    void deleteByGraduateProgramIdAndKey(Long graduateProgramId, String key);

    boolean existsByGraduateProgramIdAndKey(Long graduateProgramId, String key);
}
```

**Regla de aislamiento:** todas las consultas JPQL/Criteria deben incluir predicado explícito `graduateProgramId = :id` (o navegación desde `GraduateProgram` cargado por id). No usar búsquedas solo por `key` sin programa.

### 4.3 Infrastructure

- **`ConfigurationParameterJpaAdapter`:** implementación del puerto; métodos delegan en `EntityManager` o Spring Data con métodos derivados que incluyan `graduateProgramId`.
- **Índices:** índice en `graduate_program_id` para listados y joins (ver migración).
- **Upsert:** “set” de negocio = buscar por `(programId, key)` y actualizar `value`/`description` o crear nueva fila — puede vivir en caso de uso posterior; el puerto expone `save` idempotente a nivel de persistencia.

### 4.4 API Contract (si aplica)

No aplica en Phase 2. Los códigos HTTP de `configuration_parameter_management.feature` se cubrirán con controllers + `@Valid` más adelante.

### 4.5 Frontend Contract (si aplica)

No aplica.

---

## 5. Security Considerations

| # | Threat | CWE | Mitigation | Validated By |
|---|--------|-----|------------|--------------|
| SEC-1 | IDOR / lectura cross-tenant | CWE-639 | Todas las queries filtran por `graduateProgramId`; invariant en adaptador | `@DataJpaTest` aislamiento |
| SEC-2 | SQL injection | CWE-89 | JPA named parameters | revisión estática |

**Access Control:** capa HTTP pendiente; datos ya discriminan por programa en BD.

---

## 6. Edge Cases & Error Handling

| # | Scenario | Expected Behavior | HTTP Status (si aplica) | Feature Ref |
|---|----------|-------------------|-------------------------|-------------|
| EC-1 | Clave inválida (`max-courses`) | Rechazo en validación de dominio/DTO | — (API futura: 400) | *Rejection of parameter with invalid key format* |
| EC-2 | Valor vacío | No persistir VO inválido | — | *Rejection of parameter with empty value* |
| EC-3 | `graduateProgramId` inexistente | No crear huérfanos; fallar al resolver programa | — | *Rejection of operation on non-existent program* |
| EC-4 | Duplicado `(programId, key)` | Restricción UNIQUE en BD + manejo en servicio | — | *Update the value of an existing parameter* |
| EC-5 | Dos programas, misma clave distinto valor | Lecturas por programa devuelven valores distintos | — | *Parameter isolation between programs* |

---

## 7. Performance & Scalability Notes

| Concern | Detail | Mitigation |
|---------|--------|------------|
| N+1 al listar programas con parámetros | Muchos programas × parámetros | `@EntityGraph` o fetch join cuando se exponga listado completo |
| Cardinalidad por programa | Acotada (conjunto pequeño de claves conocidas) | Índice `(graduate_program_id)` |

---

## 8. Migration & Rollback Strategy

- **V2** crea solo `configuration_parameters` con FK `ON DELETE CASCADE` hacia `graduate_programs` (ajustar si política de negocio prefiere RESTRICT).
- **Rollback:** migración complementaria `DROP TABLE configuration_parameters` en entornos controlados.

---

## 9. Testing Strategy

| Test Type | Class | Scope | Framework |
|-----------|-------|-------|-----------|
| Adapter | `ConfigurationParameterJpaAdapterTest` | save, find por programa+key, delete, lista por programa | `@DataJpaTest` |
| Scenario | método dedicado o clase IT | Dos `GraduateProgram`, mismos keys distintos valores — asserts aislados | `@DataJpaTest` |

> **Referencia:** [`technologies/testing.md`](../../technologies/testing.md)

Casos alineados a deliverables [phase2.md](../../../implementations/phase2.md): *Parameter isolation test: 2 programs with different MAX_COURSES_PER_TERM values*.

---

## 10. Conventions Checklist

- [ ] FK y unicidad reflejadas en migración SQL
- [ ] Puerto en `domain/port/out/`
- [ ] Adaptador `@Repository`
- [ ] Nombres de columna SQL seguros (`param_key`)
- [ ] Sin queries que exponan parámetros sin filtro de programa
- [ ] Cobertura ≥80% en código nuevo

---

## 11. References

- **Architecture:** [`Architecture.md`](../../../Design/Architecture.md) — QA-3, QA-4, BC-04
- **Context Map:** [`ContextMap.md`](../../domain/ContextMap.md) — Shared Kernel `graduateProgramId`
- **Domain Schema:** [`program-configuration.schema.json`](../../domain/schemas/program-configuration.schema.json)
- **Domain Features:** [`configuration_parameter_management.feature`](../../domain/features/program-configuration/configuration_parameter_management.feature)
- **Related Specs:** [SPEC-004](SPEC-004_graduate-program-domain-persistence.md)
- **Technologies:** [`technologies/backend.md`](../../technologies/backend.md), [`technologies/testing.md`](../../technologies/testing.md)

---

## 12. Review Log

| Date | Reviewer | Action | Notes |
|------|----------|--------|-------|
| — | — | — | — |
