# Consulta de alumnos asesorados y tutorados

## 1. Tarjeta
**ID:** g-HU-15

**Título:** Consulta de alumnos asesorados y tutorados

**Como:** Coordinador del posgrado (o Profesor)

**Quiero:** ver la lista de alumnos que asesora o tutora un profesor

**Para:** dar seguimiento a su actividad académica

## 2. Conversación
* Se puede acceder desde los detalles del profesor (para el coordinador) o desde el menú principal (para el profesor).
* La pantalla despliega:
  * Alumnos anteriormente asesorados.
  * Alumnos actualmente asesorados.
  * Alumnos actualmente tutorados.
  * Alumnos anteriormente tutorados.
* Al presionar "ver" junto al nombre de un alumno, se muestran sus detalles.

## 3. Criterios de Aceptación
```gherkin
Feature: Listado de alumnos a cargo de un profesor

  Scenario: Visualización de asesorados y tutorados
    Given que se accede a la sección de "Alumnos asesorados" de un profesor
    Then el sistema muestra la lista clasificada por tipo de relación (asesor/tutor) y estado (actual/anterior)
    And permite acceder a los detalles de cada alumno listado
```
