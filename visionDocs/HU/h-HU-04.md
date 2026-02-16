## 4.10.2 Listar programas

### 1. Tarjeta

**ID:** h-HU-04

**Título:** Consulta y seguimiento de programas académicos. 

**Como:** Coordinador del posgrado. 

**Quiero:** Visualizar una lista detallada de todos los programas registrados en el sistema. 

**Para:** Revisar promedios, créditos cubiertos y fechas de egreso de los alumnos. 

### 2. Conversación

- **Coordinador:** Entro a la opción **Ver lista de programas** en el menú **PROGRAMA**. 

- **Sistema:** Muestra una tabla con Matrícula, Tipo de Programa (Maestría/Doctorado), fechas y desempeño. 
 
- **Coordinador:** Puedo ver rápidamente quién tiene promedios altos (ej. 9.81) o cuántos créditos les faltan (ej. 192 cubiertos). 
 
- **Sistema:** Indica las fechas exactas de ingreso y egreso de cada programa. 

### 3. Criterios de Aceptación

```gherkin
Feature: Visualización del desempeño por programa académico

  Scenario: Consulta de métricas académicas
    Given que existen programas registrados
    When el coordinador accede a "Ver lista de programas"
    Then el sistema debe mostrar una tabla con: Matrícula, Tipo Programa, Fecha Ingreso, Fecha Egreso, Promedio y Créditos Cubiertos
    And permitir paginar los resultados para facilitar la lectura de las 18 páginas existentes

```