# language: es
@module:enrollment @bounded-context:BC-01 @subdomain:core
Feature: Selección de UEAs por el alumno
  Como Alumno del posgrado
  Quiero acceder al módulo de inscripción para seleccionar las materias que cursaré en el trimestre
  Para registrar mi carga académica y avanzar en mi programa de estudios

  Referencia: HU-07 | Schema: enrollment.schema.json#/definitions/SelectCoursesCommand
  Bounded Context: BC-01 Enrollment (Core Domain)
  Dependencias upstream: BC-02 Academic Management (studentId), BC-03 Academic Offering (termId, uEAGroupId), BC-04 Program Configuration (graduateProgramId)

  Background:
    Dado que existe un programa de posgrado "PCyTI" con id 1 según BC-04 Program Configuration
    Y que el trimestre "25P" con id 100 tiene estado "IN_ENROLLMENT" según BC-03 Academic Offering
    Y que la oferta académica del trimestre "25P" contiene los siguientes grupos de UEA:
      | uEAGroupId | claveUEA | nombreUEA                  | grupo | cupo | cupoDisponible | profesor                          | horario                          |
      | 201        | 2156053  | Ingeniería de Software I   | CP33  | 25   | 10             | Cervantes Maceda Humberto Gustavo | JUEVES: 09:30 AM - 11:00 AM     |
      | 202        | 2156054  | Bases de Datos Avanzadas   | CP34  | 20   | 5              | García López María Elena          | MARTES: 11:00 AM - 12:30 PM     |
      | 203        | 2156055  | Redes y Seguridad          | CP35  | 15   | 0              | Pérez Sánchez Juan Carlos         | LUNES: 14:00 PM - 15:30 PM      |
    Y que existe el alumno con matrícula "2123803361" y studentId 50 con estado ACTIVO según BC-02 Academic Management
    Y que el alumno tiene asignado al asesor con professorId 10 según BC-02 Academic Management
    Y que el alumno ha iniciado sesión con rol "STUDENT" y userId asociado según BC-06 Identity & Access

  # --- Flujo principal (Happy Path) ---

  @requirement:HU-07 @driver:QA-1 @priority:alta
  Escenario: Acceso exitoso al módulo de inscripción
    Cuando el alumno selecciona la opción "Inscripción" en el menú "ALUMNO"
    Entonces el sistema muestra la pantalla de inscripción
    Y despliega los datos personales del alumno: nombre, nivel, carrera, división y nacionalidad
    Y solicita al alumno verificar que la información sea correcta

  @requirement:HU-07 @driver:QA-1 @priority:alta
  Escenario: Visualización de la oferta de UEA disponible
    Dado que el alumno se encuentra en la pantalla de inscripción
    Cuando visualiza la sección "UEA Seleccionadas"
    Entonces el sistema muestra una tabla con las columnas: Selección, Clave, Nombre, Grupo, Horario y Profesor
    Y cada horario especifica los días y los intervalos de tiempo
    Y solo se muestran grupos con cupoDisponible mayor a 0

  @requirement:HU-07 @priority:alta
  Escenario: Pre-selección automática de UEAs según plan académico
    Dado que el alumno carga la lista de UEAs
    Cuando existen materias obligatorias o sugeridas según su avance académico
    Entonces el sistema las muestra seleccionadas automáticamente mediante un checkbox marcado
    Y cada UEASelection pre-seleccionada tiene el campo "preselected" en true
    Y despliega el mensaje informativo: "Algunas UEA aparecen seleccionadas automáticamente, aun así puede editarlas."

  @requirement:HU-07 @priority:alta
  Escenario: Selección manual de UEAs por el alumno
    Dado que el alumno revisa la lista de UEAs disponibles
    Cuando el alumno marca el checkbox de la UEA "2156053 - Ingeniería de Software I" grupo "CP33"
    Y marca el checkbox de la UEA "2156054 - Bases de Datos Avanzadas" grupo "CP34"
    Entonces el sistema actualiza visualmente la lista de UEAs que formarán parte de su inscripción
    Y el total de UEAs seleccionadas es 2

  @requirement:HU-07 @priority:alta
  Escenario: Deselección de UEA previamente marcada
    Dado que el alumno tiene seleccionada la UEA "2156053 - Ingeniería de Software I"
    Cuando desmarca el checkbox de dicha UEA
    Entonces el sistema la remueve de la lista de selección
    Y el campo "preselected" no impide la deselección

  @requirement:HU-07 @priority:alta
  Escenario: Confirmación de selección y transición de estado
    Dado que el alumno ha seleccionado las UEAs con ids de grupo [201, 202]
    Cuando confirma su selección presionando "Guardar selección"
    Entonces el sistema crea un Enrollment con estado "SELECTION_COMPLETED"
    Y registra las UEASelections con los uEAGroupIds [201, 202]
    Y cada UEASelection tiene "approvedByAdvisor" en false
    Y el sistema emite el evento "CoursesSelected" hacia BC-05 Audit

  # --- Flujos alternativos y de error ---

  @requirement:HU-07 @driver:QA-3 @priority:alta
  Escenario: Validación de límite máximo de UEAs por programa
    Dado que el programa "PCyTI" tiene configurado un máximo de 3 UEAs por trimestre según BC-04
    Y el alumno ya tiene seleccionadas 3 UEAs
    Cuando intenta seleccionar una cuarta UEA
    Entonces el sistema muestra el mensaje de error: "Ha alcanzado el máximo de UEAs permitidas para este trimestre"
    Y no permite agregar la selección

  @requirement:HU-07 @driver:QA-1 @priority:alta
  Escenario: Rechazo de acceso al módulo con rol incorrecto
    Dado que un usuario ha iniciado sesión con rol "PROFESSOR"
    Cuando intenta acceder al módulo de inscripción de alumnos
    Entonces el sistema deniega el acceso con código HTTP 403
    Y emite el evento "RBACViolationDetected" hacia BC-05 Audit

  @requirement:HU-07 @priority:media
  Escenario: Intento de inscripción con cupo agotado
    Dado que el alumno visualiza la UEA "2156055 - Redes y Seguridad" grupo "CP35"
    Y dicho grupo tiene cupoDisponible igual a 0
    Cuando intenta marcar el checkbox de dicha UEA
    Entonces el sistema muestra el mensaje: "No hay cupo disponible para este grupo"
    Y el checkbox permanece deshabilitado

  @requirement:HU-07 @priority:media
  Escenario: Intento de inscripción fuera del periodo
    Dado que el trimestre "25P" tiene estado "PLANNING" según BC-03
    Cuando el alumno intenta acceder al módulo de inscripción
    Entonces el sistema muestra el mensaje: "El periodo de inscripción no está activo para este trimestre"
    Y no permite la selección de UEAs

  @requirement:HU-07 @driver:QA-2 @priority:alta
  Escenario: Protección contra manipulación de IDs de grupo
    Dado que el alumno envía un request con un uEAGroupId inexistente 999
    Cuando el sistema procesa el comando SelectCourses
    Entonces rechaza la solicitud con código HTTP 400
    Y registra el intento en BC-05 Audit con severidad HIGH
