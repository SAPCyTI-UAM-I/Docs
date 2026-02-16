## 4.10.1 Agregar programa de doctorado a alumno de maestría

### 1. Tarjeta

**ID:** h-HU-03

**Título:** Alta de programa de doctorado para egresados de maestría. 

**Como:** Coordinador del posgrado. 

**Quiero:** Registrar el nuevo programa de doctorado para un alumno que ya cursó la maestría en el PCyTI. 

**Para:** Mantener la continuidad del expediente académico del alumno en el sistema al subir de nivel. 

### 2. Conversación

- **Coordinador:** Accedo a la opción **Agregar programa de doctorado a alumno de maestría**. 

- **Sistema:** Muestra el formulario "Crear Programa" con campos para matrícula, tipo de programa y fechas. 

- **Coordinador:** Ingreso la matrícula, selecciono el tipo "DOCTORADO", el área (ej. REDES) y la institución de procedencia (ej. UAMI). 

- **Sistema:** Al presionar **GUARDAR**, me solicita elegir específicamente al alumno y su tutor asignado. 

- **Coordinador:** Selecciono el nombre del alumno y el profesor responsable de una lista desplegable. 

### 3. Criterios de Aceptación

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