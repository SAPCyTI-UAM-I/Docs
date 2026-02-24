# Modificación de datos del alumno

## 1. Tarjeta
**ID:** g-HU-08

**Título:** Modificación de datos del alumno

**Como:** Coordinador del posgrado

**Quiero:** editar la información personal de un alumno

**Para:** mantener actualizados sus datos en el sistema

## 2. Conversación
* Desde la pantalla de detalles, se puede acceder a la edición.
* El sistema permite modificar los datos del alumno (excepto aquellos que sean inmutables por regla de negocio, si los hubiera).

## 3. Criterios de Aceptación
```gherkin
Feature: Actualización de datos del alumno

  Scenario: Edición de información personal
    Given que el coordinador está viendo los detalles de un alumno
    When selecciona la opción "Editar información"
    And modifica los datos permitidos
    And guarda los cambios
    Then el sistema actualiza la información del alumno en la base de datos
```
