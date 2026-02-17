# Planeación de seminarios

## Tarjeta

**ID:** g-HU-01

**Nombre:** Planeación de fechas y ponentes para seminarios

**Como** Coordinador del posgrado

**Quiero** elegir las semanas del trimestre y el número de ponentes por fecha

**Para** organizar el calendario de seminarios del trimestre

## Conversación

* El coordinador selecciona las semanas del trimestre en las que se realizarán seminarios.
* Para cada fecha seleccionada, define el número de ponentes que presentarán.
* Esta planeación es necesaria antes de que los usuarios puedan registrar sus seminarios.

## Criterios de Aceptación

```gherkin
Feature: Planeación de seminarios del trimestre

  Scenario: Configuración exitosa de fechas y ponentes
    Given que el coordinador se encuentra en la pantalla de "Planeación de seminarios"
    When selecciona las semanas disponibles en el calendario
    And asigna el número de ponentes para cada fecha seleccionada
    And guarda la planeación
    Then el sistema registra las fechas habilitadas para seminarios
    And establece el cupo de ponentes por fecha

  Scenario: Intento de registro sin planeación previa
    Given que no se ha realizado la planeación de seminarios
    When un usuario intenta registrar un seminario
    Then el sistema no debe permitir el registro
    And debe mostrar un mensaje indicando que no hay fechas disponibles
```
