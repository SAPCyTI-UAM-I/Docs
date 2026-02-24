# Configuración del sistema (Sólo correos electronicos)

## 1. Tarjeta

**ID:** h-HU-07

**Título:** Control de envío de notificaciones por correo electrónico. 

**Como:** Coordinador del posgrado (Administrador). 

**Quiero:** Habilitar o deshabilitar globalmente el envío de correos desde el sistema. 

**Para:** Realizar pruebas de desarrollo o mantenimiento sin enviar correos reales a los usuarios. 

## 2. Conversación

- **Coordinador:** Entro a la opción **Cambiar estado de envío de correos** en el menú de configuración. 

- **Sistema:** Me informa el estado actual (ej. "Desactivados" en letras rojas). 

- **Coordinador:** Abro la lista desplegable de "Cambiar el estado actual" para elegir un modo. 

- **Sistema:** Ofrece tres opciones: **Desactivados** (nada sale), **De Prueba** (sale a correos fijos de Gmail) o **Activados** (funcionamiento normal). 

- **Coordinador:** Si elijo **De Prueba**, los correos irán a `sapcytialumno@gmail.com` o `sapcytiprofesor@gmail.com`. 

- **Coordinador:** Presiono el botón **Modificar** para aplicar el cambio. 

## 3. Criterios de Aceptación

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