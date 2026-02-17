# Buscar alumnos

## Tarjeta

**ID:** g-HU-06

**Nombre:** Búsqueda y filtrado de alumnos

**Como** Coordinador del posgrado

**Quiero** buscar alumnos utilizando diferentes criterios

**Para** localizar rápidamente la información de un estudiante específico

## Conversación

* El sistema permite realizar consultas mediante diversos criterios de búsqueda.
* Muestra una lista de resultados con los alumnos que coinciden con los filtros.

## Criterios de Aceptación

```gherkin
Feature: Búsqueda de alumnos en el sistema

  Scenario: Búsqueda por criterios
    Given que el coordinador accede a la opción "Buscar alumnos"
    When ingresa un criterio de búsqueda (nombre, matrícula, etc.)
    And ejecuta la consulta
    Then el sistema muestra la lista de alumnos coincidentes
    And permite acceder a los detalles de cada resultado
```
