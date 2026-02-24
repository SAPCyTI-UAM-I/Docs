# Registro y edición de seminarios

## 1. Tarjeta
**ID:** g-HU-02

**Título:** Registro y edición de seminarios

**Como:** usuario del sistema (alumno o profesor)

**Quiero:** registrar un nuevo seminario o editar uno existente

**Para:** participar como ponente en las fechas habilitadas

## 2. Conversación
* Una vez realizada la planeación, los usuarios pueden registrar seminarios.
* Se debe capturar:
  * Título de la ponencia
  * Resumen de la ponencia
* El usuario debe marcar la opción "Formato terminado" al finalizar.
* Si no se marca "Formato terminado", el sistema enviará recordatorios semanales.

## 3. Criterios de Aceptación
```gherkin
Feature: Registro de información de seminarios

  Scenario: Registro de nuevo seminario
    Given que existe una planeación de seminarios vigente
    And el usuario selecciona la opción de registrar seminario
    When ingresa el "Título de ponencia"
    And ingresa el "Resumen de la ponencia"
    And selecciona la opción "Formato terminado"
    And guarda los cambios
    Then el sistema almacena la información del seminario
    And confirma el registro exitoso

  Scenario: Edición de seminario existente
    Given que el usuario tiene un seminario registrado
    When modifica el título o el resumen
    And guarda los cambios
    Then el sistema actualiza la información del seminario

  Scenario: Seminario incompleto (sin formato terminado)
    Given que el usuario guarda un seminario
    But no selecciona la opción "Formato terminado"
    Then el sistema guarda la información preliminar
    And programa el envío automático de recordatorios semanales hasta que se complete
```
