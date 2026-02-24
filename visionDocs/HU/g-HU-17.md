# Búsqueda y consulta de usuarios del sistema

## 1. Tarjeta
**ID:** g-HU-17

**Título:** Búsqueda y consulta de usuarios del sistema

**Como:** Coordinador del posgrado

**Quiero:** listar y buscar usuarios registrados

**Para:** administrar sus cuentas o ver detalles

## 2. Conversación
* El sistema proporciona un listado de los usuarios registrados.
* Es posible aplicar criterios de búsqueda.
* Al presionar "Ver", el sistema muestra los detalles del usuario.

## 3. Criterios de Aceptación
```gherkin
Feature: Consulta de usuarios

  Scenario: Listado y búsqueda
    Given que el coordinador accede a la opción "Buscar usuarios"
    Then el sistema muestra la lista de usuarios actuales
    And permite filtrar por criterios específicos
    And permite seleccionar un usuario para ver su detalle
```
