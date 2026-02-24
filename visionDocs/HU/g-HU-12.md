# Búsqueda y filtrado de profesores

## 1. Tarjeta
**ID:** g-HU-12

**Título:** Búsqueda y filtrado de profesores

**Como:** Coordinador del posgrado

**Quiero:** buscar profesores mediante diversos criterios

**Para:** localizar su información o editar sus datos

## 2. Conversación
* El sistema permite realizar búsquedas de profesores.
* Se pueden utilizar diversos criterios para filtrar los resultados.
* Al finalizar la búsqueda, se muestra la lista de profesores encontrados.

## 3. Criterios de Aceptación
```gherkin
Feature: Búsqueda de profesores

  Scenario: Filtrado de profesores
    Given que el coordinador accede a la opción de búsqueda de profesores
    When ingresa un criterio de búsqueda (nombre, número de empleado, etc.)
    And ejecuta la búsqueda
    Then el sistema muestra los profesores que coinciden con el criterio
```
