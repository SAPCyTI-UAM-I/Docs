# Editar información de profesor

## Tarjeta

**ID:** g-HU-14

**Nombre:** Modificación de datos del profesor

**Como** Coordinador del posgrado

**Quiero** editar la información de un profesor

**Para** corregir o actualizar sus datos registrados

## Conversación

* Desde la pantalla de detalles del profesor, se presiona "Editar".
* El sistema permite modificar diversas informaciones relacionadas con el profesor.

## Criterios de Aceptación

```gherkin
Feature: Edición de datos de profesor

  Scenario: Actualización de información
    Given que el coordinador está visualizando los detalles de un profesor
    When selecciona la opción "Editar"
    And modifica los datos permitidos
    And guarda los cambios
    Then el sistema actualiza el registro del profesor
```
