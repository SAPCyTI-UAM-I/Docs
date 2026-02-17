# Crear usuario

## Tarjeta

**ID:** g-HU-16

**Nombre:** Registro de nuevos usuarios administrativos

**Como** Coordinador del posgrado

**Quiero** dar de alta a un usuario administrativo

**Para** otorgarle acceso y permisos en el sistema

## Conversación

* El coordinador selecciona la opción "Crear usuario".
* Debe ingresar los datos del usuario:
  * Apellido Paterno
  * Apellido Materno
  * Nombre
  * Email
  * Password (autogenerado por el sistema)
  * Tipo de usuario (Ponente, Asistente Posgrado, Asistente Administrativo)

## Criterios de Aceptación

```gherkin
Feature: Alta de usuarios administrativos

  Scenario: Registro de usuarios con roles específicos
    Given que el coordinador está en el formulario de creación de usuario
    When ingresa los datos personales del usuario
    And asigna un "Tipo de usuario" válido
    And guarda el registro
    Then el sistema crea la cuenta con los permisos correspondientes al rol seleccionado
    And genera la contraseña de acceso
```
