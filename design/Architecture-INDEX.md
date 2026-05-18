# Architecture.md — Índice por sección

> Usar este índice para cargar **solo la sección relevante** de [`Architecture.md`](Architecture.md) al escribir specs. No abrir el archivo completo (~2400 líneas).

| Tema | Sección en Architecture.md | Cuándo leer |
|------|---------------------------|-------------|
| Drivers y MVP | §3 Architectural drivers | Planificación, write-spec |
| Modelo de dominio | §4 Domain model | Specs de dominio/persistencia |
| Bounded Contexts | §4.1 Bounded Context Map | Cualquier spec por BC |
| Eventos de dominio | §4.1 Logical Domain Events | Integración entre módulos |
| Contenedores | §5 Container diagram | Fases de integración, Docker |
| Backend hexagonal | §6.1 SAPCyTI Backend API | Casi todas las specs backend |
| Estructura de paquetes | §6.1 Module package structure | Specs de scaffolding, nuevos módulos |
| SPA Angular | §6.2 SAPCyTI SPA | Specs frontend (008A, 008B, features) |
| Despliegue | §7 Deployment view | Phase 5, DevOps |
| CI/CD | §8 CI/CD | Phase 0, 5 |
| Login (HU-01) | §9.4 Login flow | Phase 6, identity-access |
| RBAC | §9.5 RBAC enforcement | Phase 6 |
| Auditoría | §9.6 Audit logging | Cross-cutting BC-05 |
| Registro alumno/profesor | §9.7 | Phase 7 |
| Recuperación/cambio password | §9.8, §9.9 | Phase 7 |
| CSV y oferta | §9.10 | Phase 8 |
| Selección materias | §9.11 | Phase 9 |
| Aprobación asesor | §9.12 | Phase 9 |
| Finalización inscripción | §9.13 | Phase 9 |
| Seguridad | §15 Security architecture | Phase 6+ |
| i18n | §16 Internationalization | Phase 4, 7 |

## Por Bounded Context

| BC | Secciones principales |
|----|----------------------|
| BC-04 Program Configuration | §4, §6.1, §9.1 |
| BC-06 Identity & Access | §4.1, §9.4–9.9, §15 |
| BC-02 Academic Management | §4.1, §9.7 |
| BC-03 Academic Offering | §4.1, §9.10 |
| BC-01 Enrollment | §4.1, §9.11–9.13 |
| BC-05 Audit | §4.1, §9.6, §15.5 |
