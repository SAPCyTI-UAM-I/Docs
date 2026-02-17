# Cambiar password

## Tarjeta

**ID:** g-HU-18

**Nombre:** Actualización de contraseña de usuario

**Como** Coordinador del posgrado (o Usuario)

**Quiero** cambiar la contraseña de acceso

**Para** mantener la seguridad de la cuenta o recuperarla

## Conversación

* Esta funcionalidad es accesible para todos los usuarios.
* Cuando es ejecutada por el coordinador:
  * El sistema solicita primero que se seleccione al usuario.
  * Luego permite la modificación de la contraseña.
* Cuando es ejecutada por el propio usuario, permite cambiar su propia contraseña.

## Criterios de Aceptación

```gherkin
Feature: Gestión de contraseñas

  Scenario: Cambio de contraseña por el coordinador
    Given que el coordinador desea cambiar la contraseña de otro usuario
    When selecciona al usuario objetivo
    And ingresa la nueva contraseña
    Then el sistema actualiza las credenciales de ese usuario

  Scenario: Cambio de contraseña propia
    Given que un usuario autenticado desea cambiar su clave
    When ingresa la nueva contraseña en la opción correspondiente
    Then el sistema actualiza sus credenciales de acceso
```
