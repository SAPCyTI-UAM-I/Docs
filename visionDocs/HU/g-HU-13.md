# Consulta de información detallada del profesor

## 1. Tarjeta
**ID:** g-HU-13

**Título:** Consulta de información detallada del profesor

**Como:** Coordinador del posgrado

**Quiero:** ver los detalles de un profesor seleccionado

**Para:** revisar su información personal y académica

## 2. Conversación
* Al seleccionar el ícono "ver" en la lista de resultados de búsqueda, se muestran los detalles del profesor.
* Desde esta pantalla se puede acceder a la edición o a la lista de alumnos asesorados.

## 3. Criterios de Aceptación
```gherkin
Feature: Visualización de detalles del profesor

  Scenario: Consulta de perfil de profesor
    Given que el coordinador ha realizado una búsqueda de profesores
    When selecciona la opción "ver" de un registro
    Then el sistema despliega la pantalla con la información detallada del profesor
```
