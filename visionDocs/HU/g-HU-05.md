# Alta de alumno

## Tarjeta

**ID:** g-HU-05

**Nombre:** Registro de nuevos alumnos en el sistema

**Como** Coordinador del posgrado

**Quiero** dar de alta a un alumno con sus datos personales y académicos

**Para** administrar su expediente y permitir su acceso al sistema

## Conversación

* El coordinador selecciona la opción "Crear alumno".
* Debe ingresar obligatoriamente:
  * Apellido Paterno, Materno y Nombre
  * Email
  * Password (autogenerado por el sistema)
  * Carrera de Licenciatura
  * Nacionalidad
* También debe ingresar la información del programa académico:
  * Matrícula
  * Tipo de programa (Maestría/Doctorado)
  * Fecha de ingreso

## Criterios de Aceptación

```gherkin
Feature: Registro de información de alumnos

  Scenario: Alta exitosa de alumno
    Given que el coordinador se encuentra en la pantalla "Crear alumno"
    When ingresa los campos obligatorios personales (Nombre, Apellidos, Email, etc.)
    And ingresa los datos del programa (Matrícula, Tipo, Fecha)
    And guarda el registro
    Then el sistema crea el usuario del alumno
    And genera una contraseña automática
    And asocia la información académica al perfil del alumno

  Scenario: Validación de campos obligatorios
    Given que el coordinador intenta registrar un alumno
    When omite algún campo obligatorio personal o académico
    Then el sistema impide el guardado
    And muestra una alerta indicando los campos faltantes
```
