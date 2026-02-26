# Análisis de Atributos de Calidad y Restricciones
Proyecto: SAPCyTI

## 1. Atributos de Calidad (Basado en ISO 25010)

### 1.1 Seguridad (Security)
* **Protección contra vulnerabilidades:** El sistema no debe ser vulnerable a los errores de la lista CWE MITRE Top 25. [Fuente: Docs/visionDocs/Vision.md - Sec 2.2.2]
* **Encriptación de datos:** Almacenamiento de toda información sensible de forma encriptada. [Fuente: Docs/visionDocs/Vision.md - Sec 2.2.2]
* **Control de accesos:** Permitir distintos tipos de usuario (Coordinador, Profesor, Alumno, Asistente, Ponente) y niveles de acceso a funciones. [Fuente: Docs/visionDocs/Vision.md - Sec 2.2.2; Context/Manual de usuario SAPCyTI.md - Sec 3]
* **Seguridad de Sesión y Navegador:** Las páginas protegidas no deben almacenarse en caché y se manejarán tokens seguros para recuperación de contraseña. Los errores de credenciales deben ser genéricos por seguridad. [Fuente: Docs/visionDocs/HU/HU-01.md, HU-02.md, HU-03.md]

### 1.2 Eficiencia de Desempeño (Performance Efficiency)
* **Tiempo de respuesta:** La generación de páginas web dinámicas deberá realizarse en un tiempo no mayor a 3 segundos (o lo razonable en usabilidad). [Fuente: Docs/visionDocs/Vision.md - Sec 2.2.2]
* **Concurrencia:** El sistema deberá soportar a un mínimo de 50 usuarios conectados de forma concurrente, con carga aceptable en momentos pico. [Fuente: Docs/visionDocs/Vision.md - Sec 2.2.1 CAR-17, Sec 2.2.2]

### 1.3 Fiabilidad (Reliability)
* **Disponibilidad y Resiliencia:** El sistema deberá respaldar la información periódicamente. En caso de fallo, debe permitir la recuperación de datos con un desfase máximo de 24 horas de antigüedad (RPO <= 24h). [Fuente: Docs/visionDocs/Vision.md - Sec 2.2.2]

### 1.4 Mantenibilidad (Maintainability)
* **Gestión de Errores:** El sistema debe generar una bitácora de errores para permitir trazar y entender el motivo de fallos. [Fuente: Docs/visionDocs/Vision.md - Sec 2.2.2]
* **Modificabilidad:** Permitir el cambio de parámetros y reglas de negocio de forma simple, en un solo punto de la aplicación, evitando dependencias de reglas fijas o nombres "quemados". [Fuente: Docs/visionDocs/Vision.md - Sec 2.2.2; Context/Junta-17-02-2026.md - Sec 8]

### 1.5 Portabilidad (Portability)
* **Adaptabilidad de Entorno:** El diseño debe facilitar una futura migración hacia un entorno de nube, interactuando con otros sistemas institucionales. [Fuente: Docs/visionDocs/Vision.md - Sec 2.2.2; Context/Junta-17-02-2026.md - Sec 8]
* **Compatibilidad de Dispositivos y Navegadores:** Acceso responsivo a través de navegadores estándar (Chrome 130, Safari 22, Firefox 129) y adaptación a tablets y dispositivos móviles. [Fuente: Docs/visionDocs/Vision.md - Sec 4.3]

### 1.6 Escalabilidad (Scalability)
* **Crecimiento Institucional:** Escalar de administrar un solo posgrado divisional a 9 posgrados, e incluso a nivel de Rectoría General, soportando diferentes reglas de negocio organizacionales. [Fuente: Docs/visionDocs/Vision.md - Sec 2.2.2; Context/Junta-17-02-2026.md - Sec 8]

### 1.7 Usabilidad (Usability) y Localización
* **Internacionalización:** Habilitar capacidad para mostrar interfaces en idioma inglés y español. [Fuente: Docs/visionDocs/Vision.md - Sec 2.2.2; Context/Junta-17-02-2026.md - Sec 8]
* **Experiencia de Usuario:** Reducir captura doble y automatizar tareas operativas para presentar información clara para auditorías (CONACYT). [Fuente: Context/Junta-17-02-2026.md - Sec 1]

---

## 2. Restricciones del Sistema

### 2.1 Restricciones de Negocio (Business Constraints)
* **Sincronización Operativa Institucional:** Los flujos (ej. Admisión) dependen potencialmente de la validación de otras áreas centrales (Rectoría o Sistemas Escolares); el agente o sistema no debe forzar reglas rígidas sin marcar la validación por la comisión. [Fuente: Context/Junta-17-02-2026.md - Sec 5]
* **Presupuesto y Tiempos de Desarrollo:** El proyecto está a cargo de estudiantes de licenciatura con estancias cortas o recursos limitados, siendo un esquema de liberación iterativo e incremental con riesgo de extensión extendida. [Fuente: Docs/visionDocs/Vision.md - Sec 1.5; Context/Junta-17-02-2026.md - Sec 9]

### 2.2 Restricciones Técnicas (Technical Constraints)
* **Stack Tecnológico Obligatorio:** Desarrollo back-end en **Java** usando estrictamente librerías **Open Source**. [Fuente: Docs/visionDocs/Vision.md - Sec 2.2.3]
* **Entorno de Despliegue Actual (On-Premise):** Base tecnológica sobre servidor dedicado físico con sistema Linux, 16 TB de almacenamiento y 32 GB de RAM. [Fuente: Context/Junta-17-02-2026.md - Sec 7; Docs/visionDocs/Vision.md - Sec 4.3]
* **Integraciones Exigidas:** 
    * Exportación a Sistemas Escolares obligatoria vía archivos estructurados (.txt, .xlsx). [Fuente: Context/Junta-17-02-2026.md - Sec 6.1; Docs/visionDocs/Vision.md - Sec 2.2.1]
    * Integración asíncrona pero necesaria con página web WordPress del Posgrado para evitar doble captura. [Fuente: Context/Junta-17-02-2026.md - Sec 6.2; Docs/visionDocs/Vision.md - Sec 2.2.1]

### 2.3 Restricciones Operativas (Operational Constraints)
* **Prioridad Temprana de Entrega:** Entrega urgente/prioritaria inicial del módulo de Admisiones para mitigar dependencia en plataformas externas. [Fuente: Context/Junta-17-02-2026.md - Sec 4]

---

## 3. Conflictos Identificados

* **Discrepancia en Capacidad de Infraestructura Inicial de Hospedaje:**
  * La minuta señala claramente que el servidor físico dedicado tiene **16 TB de almacenamiento y 32 GB de RAM** (`Context/Junta-17-02-2026.md - Sec 7` y validado también en entorno en `Docs/visionDocs/Vision.md - Sec 4.3`).
  * Sin embargo, la sección de Restricciones del documento Visión especifica un **"Hospedaje en una PC de escritorio de bajos recursos"** e incluso el caso de uso cita que se levantará alerta de certificado de seguridad indicando infraestructura precaria local (`Docs/visionDocs/Vision.md - Sec 2.2.3`; `HU-01.md`).
  * **Acción requerida (Atención al Equipo Humano):** No se ha asumido qué límite hardware rige el performance temprano. Se requiere que el equipo defina si se usará la PC de bajos recursos como entorno inicial temporal (Dev/Testing), o si el servidor dedicado es el definitivo en producción, dado que evaluar y priorizar la latencia y la concurrencia variará drásticamente.
