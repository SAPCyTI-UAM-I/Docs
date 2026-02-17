# Configuración del sistema

## Tarjeta

**ID:** h-HU-07

**Nombre:** Control de envío de notificaciones por correo electrónico

**Como** Coordinador del posgrado

**Quiero** habilitar o deshabilitar globalmente el envío de correos desde el sistema

**Para** realizar pruebas de desarrollo o mantenimiento sin enviar correos reales

## Conversación

* El coordinador entra a la opción "Cambiar estado de envío de correos".
* El sistema informa el estado actual (ej. "Desactivados").
* Se puede elegir entre tres modos:
  * **Desactivados**: No se envían correos.
  * **De Prueba**: Se envían a cuentas fijas de prueba.
  * **Activados**: Funcionamiento normal con correos reales.
* Al presionar "Modificar", se aplica el cambio.

## Criterios de Aceptación

```gherkin
Feature: Configuración de pasarela de correos

  Scenario: Activación de modo de pruebas
    Given que el administrador desea validar correos sin molestar a los usuarios reales
    When selecciona el estado "De Prueba"
    And presiona el botón "Modificar"
    Then el sistema debe redirigir todas las notificaciones salientes a las cuentas de prueba institucionales en Gmail

  Scenario: Suspensión total de notificaciones
    Given que el sistema entrará en mantenimiento
    When el administrador selecciona el estado "Desactivados"
    And presiona "Modificar"
    Then el sistema no debe enviar ningún correo electrónico bajo ninguna circunstancia
```