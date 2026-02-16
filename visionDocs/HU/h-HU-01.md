## 4.9.1 Creación de proyectos de investigación

### 1. Tarjeta

**ID:** h-HU-01

**Título:** Creación y registro de proyectos de investigación. 

**Como:** Coordinador del posgrado. 

**Quiero:** Registrar un nuevo proyecto de investigación asignando un nombre y fechas de vigencia. 

**Para:** Mantener un expediente actualizado de las investigaciones realizadas por los alumnos y sus respectivos títulos de tesis. 

### 2. Conversación

- **Coordinador:** Dentro del menú principal, accedo a la sección **PROYECTO INVESTIGACIÓN** y selecciono **Crear proyecto de investigación**. 

- **Sistema:** Muestra el formulario "Proyecto Investigación" con campos para capturar el nombre, título de proyecto y fechas. 

- **Coordinador:** Ingreso el nombre oficial del proyecto y, de ser posible, el título tentativo de la tesis. 

- **Sistema:** Solicita obligatoriamente la **Fecha Inicio** y permite capturar la **Fecha Terminación**. 

- **Coordinador:** Presiono el botón **GUARDAR** para almacenar el registro. 

### 3. Criterios de Aceptación

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