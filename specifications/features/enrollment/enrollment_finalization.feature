# language: es
@module:enrollment @bounded-context:BC-01 @subdomain:core
Feature: Generación de formato de inscripción y finalización
  Como Coordinador o Asistente del Posgrado
  Quiero seleccionar a un alumno cuya carga académica ya fue aprobada para generar su formato de inscripción
  Para obtener el documento oficial en PDF que formaliza el registro de materias ante Sistemas Escolares

  Referencia: HU-09, CON-3 | Schema: enrollment.schema.json#/definitions/FinalizeEnrollmentCommand, EnrollmentFormPDF, SchoolSystemsExport
  Bounded Context: BC-01 Enrollment (Core Domain)
  Dependencias upstream: BC-02 Academic Management (datos alumno), BC-03 Academic Offering (datos UEA), BC-04 Program Configuration (datos programa)
  Integraciones externas: R12 — SchoolSystemsExportAdapter (TXT/XLSX), PdfGeneratorAdapter (PDF)

  Background:
    Dado que existe un programa de posgrado "PCyTI" con id 1 según BC-04 Program Configuration
    Y que el trimestre "25P" con id 100 según BC-03 Academic Offering
    Y que existe el alumno con los siguientes datos según BC-02 Academic Management:
      | campo          | valor                                   |
      | studentId      | 50                                      |
      | matrícula      | 2123803361                              |
      | nombre         | Valencia Franco Paulina                 |
      | nivel          | MAESTRIA                                |
      | carrera        | Ciencias y Tecnologías de la Información|
      | división       | CBI                                     |
      | nacionalidad   | Mexicana                                |
    Y que existe un Enrollment con id 300 para el alumno 50 en estado "APPROVED_BY_ADVISOR"
    Y que el Enrollment contiene las UEAs aprobadas:
      | claveUEA | nombreUEA                  | créditos | grupo |
      | 2156053  | Ingeniería de Software I   | 9        | CP33  |
      | 2156054  | Bases de Datos Avanzadas   | 9        | CP34  |
    Y que el coordinador ha iniciado sesión con rol "COORDINATOR" según BC-06 Identity & Access

  # --- Flujo principal: Finalización ---

  @requirement:HU-09 @priority:alta
  Escenario: Visualización de alumnos pendientes de finalización
    Cuando el coordinador accede a "Imprimir formato de inscripcion" del menú "PROCESO DE INSCRIPCION"
    Entonces el sistema muestra la tabla "Seleccione el alumno para imprimir su inscripcion"
    Y despliega "Valencia Franco Paulina" con un botón "Imprimir"
    Y solo muestra alumnos cuyo Enrollment tenga estado "APPROVED_BY_ADVISOR"

  @requirement:HU-09 @priority:alta
  Escenario: Generación exitosa del formato PDF de inscripción
    Dado que el alumno "Valencia Franco Paulina" aparece en la lista de pendientes
    Cuando el coordinador presiona el botón "Imprimir"
    Entonces el sistema genera un documento PDF on-demand vía PdfGeneratorAdapter
    Y el documento se titula "SOLICITUD DE UEA - GRUPO A ESTUDIOS DE POSGRADO"
    Y el PDF no se persiste en base de datos — se genera cada vez que se solicita

  @requirement:HU-09 @priority:alta
  Escenario: Validación de datos completos en el documento PDF
    Dado que se ha generado el PDF para el alumno con matrícula "2123803361"
    Entonces el documento contiene correctamente:
      | campo         | valor                                    |
      | Nombre        | Valencia Franco Paulina                  |
      | Matrícula     | 2123803361                               |
      | Posgrado      | CIENCIAS Y TECNOLOGÍAS DE LA INF.        |
      | Trimestre     | 25P                                      |
      | División      | CBI                                      |
      | Nivel         | MAESTRIA                                 |
    Y incluye la tabla de UEAs con Clave, Créditos y Grupo
    Y marca con "X" los recuadros correspondientes a División "CBI" y Nivel "MAESTRIA"
    Y presenta espacios para firma del "SOLICITANTE" y "COORDINACION DE SISTEMAS ESCOLARES"

  @requirement:HU-09 @priority:alta
  Escenario: Finalización de inscripción por el coordinador
    Dado que el coordinador ha verificado el PDF del alumno
    Cuando ejecuta la acción de finalizar la inscripción
    Entonces el Enrollment con id 300 transiciona a estado "FINALIZED"
    Y se registra la fecha de finalización en el campo "finalizationDate"
    Y el sistema emite el evento "EnrollmentFinalized" hacia BC-05 Audit
    Y el alumno aparece en la sección "Alumnos con horario Impreso"

  @requirement:HU-09 @priority:media
  Escenario: Re-impresión del formato para alumno ya finalizado
    Dado que el alumno "Valencia Franco Paulina" tiene un Enrollment en estado "FINALIZED"
    Cuando el coordinador consulta la sección "Alumnos con horario Impreso"
    Y presiona el botón "Imprimir" junto al nombre del alumno
    Entonces el sistema genera nuevamente el PDF on-demand
    Y el estado del Enrollment no cambia

  # --- Exportación a Sistemas Escolares (CON-3) ---

  @requirement:HU-09 @driver:CON-3 @priority:alta
  Escenario: Exportación exitosa en formato TXT para Sistemas Escolares
    Dado que existen inscripciones finalizadas para el trimestre "25P"
    Cuando el coordinador solicita la exportación en formato "TXT"
    Entonces el sistema genera un archivo TXT vía SchoolSystemsExportAdapter
    Y cada registro contiene: matrícula, claveUEA, grupo, trimestre, programa y fechaFinalización
    Y el formato cumple con la especificación de la oficina de Control Escolar (Lic. César Hernández)
    Y el modelo de dominio NO se moldea por la estructura del archivo exportado

  @requirement:HU-09 @driver:CON-3 @priority:alta
  Escenario: Exportación exitosa en formato XLSX para Sistemas Escolares
    Dado que existen inscripciones finalizadas para el trimestre "25P"
    Cuando el coordinador solicita la exportación en formato "XLSX"
    Entonces el sistema genera un archivo XLSX vía SchoolSystemsExportAdapter
    Y la hoja de cálculo contiene las columnas requeridas por Control Escolar
    Y el Anti-Corruption Layer traduce del modelo de dominio al formato institucional

  # --- Flujos de error ---

  @requirement:HU-09 @driver:QA-1 @priority:alta
  Escenario: Rechazo de finalización por rol no autorizado
    Dado que un usuario ha iniciado sesión con rol "STUDENT"
    Cuando intenta finalizar el Enrollment con id 300
    Entonces el sistema deniega la acción con código HTTP 403
    Y emite el evento "RBACViolationDetected" hacia BC-05 Audit

  @requirement:HU-09 @priority:media
  Escenario: Intento de finalización con estado incorrecto
    Dado que el Enrollment con id 300 tiene estado "SELECTION_COMPLETED"
    Cuando el coordinador intenta finalizar la inscripción
    Entonces el sistema rechaza la acción con código HTTP 409
    Y muestra el mensaje: "La inscripción debe estar aprobada por el asesor antes de ser finalizada"

  @requirement:HU-09 @driver:CON-5 @priority:alta
  Escenario: Decisión final por la comisión del posgrado
    Dado que el Enrollment con id 300 tiene estado "APPROVED_BY_ADVISOR"
    Y que la comisión del posgrado ha decidido finalizar la inscripción a pesar de una observación administrativa
    Cuando el coordinador ejecuta la finalización
    Entonces el sistema permite la acción sin forzar reglas rígidas institucionales
    Y la decisión final queda registrada en BC-05 Audit con el actor coordinador
