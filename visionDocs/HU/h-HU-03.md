# Agregar programa de doctorado a alumno de maestría

## Tarjeta

**ID:** h-HU-03

**Nombre:** Alta de programa de doctorado para egresados de maestría

**Como** Coordinador del posgrado

**Quiero** registrar el nuevo programa de doctorado para un alumno que ya cursó la maestría

**Para** mantener la continuidad del expediente académico del alumno en el sistema

## Conversación

* El coordinador accede a la opción "Agregar programa de doctorado a alumno de maestría".
* El sistema muestra el formulario "Crear Programa" con campos para matrícula y tipo de programa.
* El coordinador ingresa la matrícula, selecciona el tipo "DOCTORADO", el área y la institución.
* Al presionar "GUARDAR", el sistema solicita elegir al alumno y su tutor.
* El coordinador selecciona el alumno y el profesor responsable de las listas desplegables.

## Criterios de Aceptación

```gherkin
Feature: Registro de doctorado para ex-alumnos de maestría

  Scenario: Registro inicial del programa
    Given que el coordinador ingresa a la creación de programa
    When captura la Matrícula, Tipo Programa (DOCTORADO) y Fecha de Ingreso
    And presiona el botón "GUARDAR"
    Then el sistema debe redirigir a la pantalla "Seleccione al Alumno y Tutor del Programa"

  Scenario: Asignación de alumno y tutor
    Given que se han guardado los datos del programa de doctorado
    When el coordinador selecciona a un alumno (ej. Aguirre Guerrero Daniela)
    And selecciona a un tutor (ej. Aguilar Cornejo Manuel)
    And presiona nuevamente "GUARDAR"
    Then el sistema vincula exitosamente el nuevo programa de nivel doctorado al alumno seleccionado
```