# Generación de avisos de seminarios

## Tarjeta

**ID:** g-HU-03

**Nombre:** Generación de invitaciones a seminarios

**Como** Asistente del posgrado

**Quiero** generar las invitaciones para los seminarios programados

**Para** difundir la información del evento a la comunidad

## Conversación

* La asistente accede a la opción "Invitación a seminarios".
* Debe completar los siguientes datos para la constancia/invitación:
  * Grado del ponente
  * Institución de procedencia
  * Lugar donde se llevará a cabo el seminario
* El sistema genera el documento de invitación con los datos ingresados.

## Criterios de Aceptación

```gherkin
Feature: Creación de invitaciones para seminarios

  Scenario: Generación exitosa de invitación
    Given que la asistente se encuentra en la pantalla "Invitación a seminarios"
    When selecciona un seminario programado
    And ingresa el "Grado del ponente"
    And ingresa la "Institución de procedencia"
    And ingresa el "Lugar del evento"
    And solicita generar la invitación
    Then el sistema crea el documento de invitación con la información del seminario y del ponente

  Scenario: Datos faltantes para invitación
    Given que la asistente intenta generar una invitación
    When omite uno de los campos obligatorios (Grado, Institución, Lugar)
    Then el sistema impide la generación
    And solicita completar la información requerida
```
