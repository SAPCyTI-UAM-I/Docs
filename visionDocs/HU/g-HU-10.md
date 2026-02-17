# Editar programa

## Tarjeta

**ID:** g-HU-10

**Nombre:** Asignación de tutores y asesores al programa

**Como** Coordinador del posgrado

**Quiero** editar los detalles del programa académico de un alumno

**Para** asignar o cambiar su tutor y asesores

## Conversación

* Desde los detalles del programa, se puede ingresar a la edición.
* Esta funcionalidad permite asignar asesores o tutor al alumno.

## Criterios de Aceptación

```gherkin
Feature: Gestión de tutores y asesores

  Scenario: Asignación de tutor a un alumno
    Given que el coordinador está editando el programa de un alumno
    When selecciona un profesor de la lista de tutores disponibles
    And guarda la asignación
    Then el sistema registra al profesor como tutor del alumno

  Scenario: Asignación de asesores
    Given que el coordinador está editando el programa de un alumno
    When agrega profesores a la lista de asesores
    And guarda los cambios
    Then el sistema actualiza los asesores del alumno
```
