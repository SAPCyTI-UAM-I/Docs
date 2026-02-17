# Estadísticas en la página web del posgrado

## Tarjeta

**ID:** h-HU-06

**Nombre:** Publicación automática de indicadores en el sitio web institucional

**Como** Sistema SAPCyTI (en representación del Coordinador)

**Quiero** sincronizar periódicamente los datos estadísticos internos con la página oficial

**Para** proporcionar información transparente y actualizada a la comunidad

## Conversación

* Los datos capturados en SAPCyTI sirven como fuente única para el portal web.
* Al realizar cambios internos (actas, egresos), la actualización en la web es automática/periódica.
* La información se refleja en gráficas de candidatos y relaciones ingreso/egreso.
* Los usuarios web pueden ver el total de alumnos graduados y en tesis.

## Criterios de Aceptación

```gherkin
Feature: Sincronización de datos con portal externo

  Scenario: Actualización de gráficas públicas
    Given que se han modificado datos de egreso en SAPCyTI
    When el proceso de sincronización periódica se ejecuta
    Then el portal externo debe actualizar las gráficas de "Relación de candidatos registrados/aceptados"
    And actualizar las métricas de "Información estadística: Maestría" (Graduados total, En Tesis, etc.)
```