# Estadísticas dentro de SAPCyTI

## Tarjeta

**ID:** h-HU-05

**Nombre:** Generación de indicadores estadísticos del posgrado

**Como** Coordinador del posgrado

**Quiero** generar un reporte de estadísticas comparativas por generación

**Para** evaluar el éxito del programa mediante tasas de graduación y eficiencia terminal

## Conversación

* El coordinador selecciona "Estadísticas del posgrado" en el menú.
* El sistema genera una tabla desglosada por años (generaciones).
* Se muestran filas de Matriculados, Graduados Total, % Graduados en 2.5 años y Retención.
* Se puede observar cuántos alumnos están en fase de tesis por generación.

## Criterios de Aceptación

```gherkin
Feature: Reporte de estadísticas de eficiencia terminal

  Scenario: Visualización de indicadores por generación
    Given que el sistema tiene datos de ingresos y egresos históricos
    When el coordinador accede al módulo de estadísticas
    Then el sistema debe desplegar una tabla comparativa con las filas: Matriculados, Graduados Total, % Graduados Total, Graduados en 2.5 años, % Graduados en 2.5 años, En tesis y % Retención
    And mostrar el "Total" histórico acumulado en la columna final de la tabla
```
