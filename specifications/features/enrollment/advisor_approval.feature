# language: es
@module:enrollment @bounded-context:BC-01 @subdomain:core
Feature: Aprobación de inscripción por tutor/asesor
  Como Profesor (Tutor o Asesor)
  Quiero acceder a la lista de mis alumnos asesorados y revisar las UEAs que han seleccionado
  Para validar que su carga académica sea la adecuada, realizando ajustes si es necesario, y autorizar formalmente su inscripción

  Referencia: HU-08 | Schema: enrollment.schema.json#/definitions/ApproveEnrollmentCommand, RejectEnrollmentCommand
  Bounded Context: BC-01 Enrollment (Core Domain)
  Dependencias upstream: BC-02 Academic Management (studentId, advisorId), BC-03 Academic Offering (uEAGroupId, availableQuota), BC-06 Identity & Access (RBAC)

  Background:
    Dado que existe un programa de posgrado "PCyTI" con id 1 según BC-04 Program Configuration
    Y que el trimestre "25P" con id 100 tiene estado "IN_ENROLLMENT" según BC-03 Academic Offering
    Y que existe el alumno "Valencia Franco Paulina" con matrícula "2123803361" y studentId 50 según BC-02
    Y que el alumno tiene asignado al asesor con professorId 10 y nombre "Cervantes Maceda Humberto" según BC-02
    Y que el asesor ha iniciado sesión con rol "PROFESSOR" y userId asociado según BC-06 Identity & Access
    Y que existe un Enrollment con id 300 para el alumno 50 en trimestre "25P" con estado "SELECTION_COMPLETED"
    Y que el Enrollment contiene las siguientes UEASelections:
      | uEAGroupId | claveUEA | nombreUEA                  | grupo | preselected | approvedByAdvisor |
      | 201        | 2156053  | Ingeniería de Software I   | CP33  | false       | false             |
      | 202        | 2156054  | Bases de Datos Avanzadas   | CP34  | true        | false             |

  # --- Flujo principal (Happy Path) ---

  @requirement:HU-08 @driver:QA-1 @priority:alta
  Escenario: Visualización de alumnos asesorados con inscripciones pendientes
    Cuando el asesor accede a la opción "Aprobar Elección de UEAS" del menú "ALUMNOS ASESORADOS"
    Entonces el sistema muestra la tabla "Seleccione el alumno para ver sus UEAs seleccionadas"
    Y despliega el nombre "Valencia Franco Paulina" con un botón "Ver"
    Y solo muestra alumnos cuyo Enrollment tenga estado "SELECTION_COMPLETED"

  @requirement:HU-08 @priority:alta
  Escenario: Revisión detallada de la selección del alumno
    Dado que el asesor selecciona al alumno "Valencia Franco Paulina" de la lista
    Cuando presiona el botón "Ver"
    Entonces el sistema muestra la pantalla "Datos del Alumno" con nivel, carrera y división
    Y presenta la tabla "UEA Seleccionadas" con horarios y profesores
    Y presenta la sección "Seleccione las materias a inscribir" con UEAs adicionales disponibles

  @requirement:HU-08 @priority:alta
  Escenario: Modificación de la carga académica por el asesor
    Dado que el asesor visualiza las UEAs seleccionadas por el alumno
    Cuando el asesor desmarca la UEA "2156054 - Bases de Datos Avanzadas"
    Y marca una nueva UEA "2156055 - Redes y Seguridad" desde la sección de materias disponibles
    Entonces el sistema actualiza la carga académica final con los uEAGroupIds [201, 203]

  @requirement:HU-08 @priority:alta
  Escenario: Aprobación exitosa de inscripción
    Dado que el asesor está conforme con la selección de UEAs [201, 202]
    Cuando presiona el botón "Aceptar" para aprobar la inscripción
    Entonces el Enrollment con id 300 transiciona a estado "APPROVED_BY_ADVISOR"
    Y cada UEASelection aprobada tiene "approvedByAdvisor" en true
    Y el sistema decrementa el cupoDisponible de cada UEAGroup aprobado vía BC-03
    Y el alumno aparece en la sección "Alumnos con UEAs aceptadas"
    Y el sistema emite el evento "EnrollmentApprovedByAdvisor" hacia BC-05 Audit

  @requirement:HU-08 @priority:alta
  Escenario: Rechazo de inscripción por el asesor
    Dado que el asesor no está conforme con la selección del alumno
    Cuando presiona el botón "Rechazar" con el motivo "Carga excesiva para el primer trimestre, reducir a 2 UEAs"
    Entonces el Enrollment con id 300 regresa a estado "PENDING_SELECTION"
    Y el sistema emite el evento "EnrollmentRejectedByAdvisor" hacia BC-05 Audit
    Y el alumno puede modificar su selección nuevamente (HU-07)

  @requirement:HU-08 @priority:alta
  Escenario: Consulta de alumnos ya aprobados
    Dado que el asesor se encuentra en el módulo de aprobación
    Cuando consulta la sección "Alumnos con UEAs aceptadas"
    Entonces el sistema muestra la lista de alumnos cuya inscripción fue autorizada
    Y permite ver el detalle presionando el botón "Ver"

  # --- Flujos alternativos y de error ---

  @requirement:HU-08 @driver:QA-1 @priority:alta
  Escenario: Rechazo de aprobación por asesor no asignado
    Dado que un profesor con professorId 99 NO es el asesor asignado del alumno 50
    Y ha iniciado sesión con rol "PROFESSOR"
    Cuando intenta aprobar el Enrollment con id 300
    Entonces el sistema deniega la acción con código HTTP 403
    Y muestra el mensaje: "No tiene permisos para aprobar esta inscripción. Solo el asesor asignado puede hacerlo."
    Y emite el evento "RBACViolationDetected" hacia BC-05 Audit

  @requirement:HU-08 @driver:QA-2 @priority:alta
  Escenario: Rechazo de aprobación sin motivo válido
    Dado que el asesor intenta rechazar el Enrollment con id 300
    Cuando envía el comando RejectEnrollment con reason vacío
    Entonces el sistema rechaza la solicitud con código HTTP 400
    Y muestra el mensaje: "El motivo de rechazo es obligatorio (mínimo 10 caracteres)"

  @requirement:HU-08 @priority:media
  Escenario: Validación de empalmes de horario al modificar selección
    Dado que el asesor intenta agregar una UEA cuyo horario se empalma con otra ya seleccionada
    Cuando marca la UEA con conflicto de horario
    Entonces el sistema muestra una advertencia: "Empalme de horario detectado con la UEA [nombre]"
    Y permite al asesor confirmar o descartar la adición

  @requirement:HU-08 @priority:media
  Escenario: Intento de aprobación con Enrollment en estado incorrecto
    Dado que el Enrollment con id 300 tiene estado "PENDING_SELECTION"
    Cuando el asesor intenta aprobar la inscripción
    Entonces el sistema rechaza la acción con código HTTP 409
    Y muestra el mensaje: "El alumno aún no ha completado su selección de UEAs"
