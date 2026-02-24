# Consulta de detalles del programa académico del alumno

## 1. Tarjeta
**ID:** g-HU-09

**Título:** Consulta de detalles del programa académico del alumno

**Como:** Coordinador del posgrado

**Quiero:** ver la información específica del programa que cursa el alumno

**Para:** conocer su matrícula, tutor y asesores asignados

## 2. Conversación
* Dependiendo del tipo de programa (Maestría/Doctorado), se muestran botones para ver los detalles.
* La pantalla de detalles del programa incluye:
  * Matrícula
  * Tutor asignado
  * Asesor(es) asignado(s)

## 3. Criterios de Aceptación
```gherkin
Feature: Visualización de información académica

  Scenario: Consulta de programa de alumno
    Given que el coordinador está en los detalles de un alumno
    When selecciona la opción para ver el programa
    Then el sistema muestra la información académica asociada
    And incluye matrícula, tutor y asesores
```
