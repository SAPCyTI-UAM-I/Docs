## 4.11.1 Estadísticas dentro de SAPCyTI

### 1. Tarjeta

**ID:** h-HU-05

**Título:** Generación de indicadores estadísticos del posgrado. 

**Como:** Coordinador del posgrado. 

**Quiero:** Generar un reporte de estadísticas comparativas por generación. 

**Para:** Evaluar el éxito del programa mediante tasas de graduación, retención y eficiencia terminal. 

### 2. Conversación
 
- **Coordinador:** Selecciono **Estadísticas del posgrado** dentro del menú **ESTADISTICAS**. 

- **Sistema:** Genera automáticamente la tabla "Estadísticas" desglosada por años (desde 2005 hasta el presente). 
 
- **Coordinador:** Reviso la fila de **Matriculados** y **Graduados Total** para ver el avance histórico. 

- **Sistema:** Calcula porcentajes críticos como el **% Graduados en 2.5 años** y la tasa de **Retención**. 

- **Coordinador:** Observo cuántos alumnos están actualmente en fase de tesis por generación. 

### 3. Criterios de Aceptación

```gherkin
Feature: Reporte de estadísticas de eficiencia terminal

  Scenario: Visualización de indicadores por generación
    Given que el sistema tiene datos de ingresos y egresos históricos
    When el coordinador accede al módulo de estadísticas
    Then el sistema debe desplegar una tabla comparativa con las filas: Matriculados, Graduados Total, % Graduados Total, Graduados en 2.5 años, % Graduados en 2.5 años, En tesis y % Retención
    And mostrar el "Total" histórico acumulado en la columna final de la tabla 
```
