# Listar programas

## Tarjeta

**ID:** h-HU-04

**Nombre:** Consulta y seguimiento de programas académicos

**Como** Coordinador del posgrado

**Quiero** visualizar una lista detallada de todos los programas registrados en el sistema

**Para** revisar promedios, créditos cubiertos y fechas de egreso

## Conversación

* El coordinador entra a la opción "Ver lista de programas".
* El sistema muestra una tabla con Matrícula, Tipo de Programa, fechas y desempeño.
* Se pueden ver métricas como promedios y créditos cubiertos.
* La tabla indica las fechas exactas de ingreso y egreso de cada programa.

## Criterios de Aceptación

```gherkin
Feature: Visualización del desempeño por programa académico

  Scenario: Consulta de métricas académicas
    Given que existen programas registrados
    When el coordinador accede a "Ver lista de programas"
    Then el sistema debe mostrar una tabla con: Matrícula, Tipo Programa, Fecha Ingreso, Fecha Egreso, Promedio y Créditos Cubiertos
    And permitir paginar los resultados para facilitar la lectura
```