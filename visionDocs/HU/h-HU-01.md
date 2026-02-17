# Creación de proyectos de investigación

## Tarjeta

**ID:** h-HU-01

**Nombre:** Creación y registro de proyectos de investigación

**Como** Coordinador del posgrado

**Quiero** registrar un nuevo proyecto de investigación asignando un nombre y fechas de vigencia

**Para** mantener un expediente actualizado de las investigaciones realizadas por los alumnos

## Conversación

* El coordinador accede a la sección "PROYECTO INVESTIGACIÓN" y selecciona "Crear proyecto de investigación".
* El sistema muestra el formulario con campos para capturar el nombre, título de proyecto y fechas.
* El coordinador ingresa el nombre oficial del proyecto y el título tentativo.
* Es obligatorio ingresar la "Fecha Inicio", mientras que la "Fecha Terminación" es opcional al inicio.
* Al presionar "GUARDAR", el sistema almacena el registro.

## Criterios de Aceptación

```gherkin
Feature: Registro de nuevos proyectos de investigación

  Scenario: Registro exitoso de proyecto con datos obligatorios
    Given que el coordinador está en el formulario de "Proyecto Investigación"
    When ingresa el "Nombre Proyecto"
    And selecciona una "Fecha Inicio" válida
    And presiona el botón "GUARDAR"
    Then el sistema almacena el proyecto en la base de datos
    And permite su posterior consulta en el listado de proyectos

  Scenario: Validación de campos obligatorios vacíos
    Given que el coordinador intenta registrar un proyecto
    When deja el campo "Nombre Proyecto" o "Fecha Inicio" vacío
    And presiona "GUARDAR"
    Then el sistema debe impedir el guardado
    And mostrar una alerta de campo obligatorio
```