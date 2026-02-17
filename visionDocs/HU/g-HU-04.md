# Generación de constancias de seminario

## Tarjeta

**ID:** g-HU-04

**Nombre:** Emisión de constancias de participación en seminarios

**Como** Asistente del posgrado

**Quiero** generar y entregar las constancias a los ponentes

**Para** acreditar su participación en el seminario

## Conversación

* La asistente selecciona la opción "Genera constancias".
* El sistema solicita elegir:
  * La ponencia para la cual se hará la constancia.
  * La duración de la ponencia.
* El sistema genera la constancia lista para ser entregada al ponente.

## Criterios de Aceptación

```gherkin
Feature: Emisión de constancias para ponentes

  Scenario: Generación de constancia individual
    Given que la asistente está en el módulo de constancias
    When selecciona una ponencia de la lista
    And especifica la "Duración" de la ponencia
    And confirma la generación
    Then el sistema produce el documento de constancia
    And incluye los datos del ponente y del seminario
```
