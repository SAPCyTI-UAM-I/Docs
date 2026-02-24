# Consulta de detalles del alumno

## 1. Tarjeta
**ID:** g-HU-07

**Título:** Consulta de detalles del alumno

**Como:** Coordinador del posgrado

**Quiero:** ver la información completa de un alumno seleccionado

**Para:** revisar sus datos personales y académicos

## 2. Conversación
* Al seleccionar un alumno de la búsqueda, se muestran sus detalles.
* Se visualiza la información personal y de contacto.
* El sistema ofrece opciones para:
  * Editar la información del alumno.
  * Ver detalles del programa (o programas) en los que está inscrito.

## 3. Criterios de Aceptación
```gherkin
Feature: Visualización del expediente del alumno

  Scenario: Consulta de información detallada
    Given que el coordinador ha realizado una búsqueda de alumnos
    When selecciona un alumno de la lista de resultados
    Then el sistema muestra la pantalla de detalles del alumno
    And habilita las opciones de edición y consulta de programa
```
