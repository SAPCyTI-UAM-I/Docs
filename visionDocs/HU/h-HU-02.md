# Ver proyectos de investigación

## Tarjeta

**ID:** h-HU-02

**Nombre:** Visualización y consulta de proyectos registrados

**Como** Coordinador del posgrado

**Quiero** consultar la lista completa de proyectos de investigación dados de alta

**Para** supervisar los temas de investigación activos y gestionar la información histórica

## Conversación

* El coordinador selecciona la opción "Ver proyectos de investigación".
* El sistema despliega una tabla con una columna para el nombre de cada proyecto.
* Se pueden visualizar proyectos sobre diversos temas (algoritmos, gestión semántica, etc.).
* Es posible configurar la paginación para ver 5, 10, 15, 20 o 25 resultados por página.
* Se utilizan controles de navegación para avanzar entre las páginas.

## Criterios de Aceptación

```gherkin
Feature: Consulta de listado de proyectos

  Scenario: Navegación y paginación del listado
    Given que existen proyectos de investigación registrados
    When el coordinador accede a "Ver proyectos de investigación"
    Then el sistema muestra la tabla con la columna "Nombre Proyecto"
    And permite cambiar el tamaño de la página a 10 o 25 registros
    And habilita los botones de navegación para avanzar entre las páginas de resultados
```