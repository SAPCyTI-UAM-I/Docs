# Iteration Plan — SAPCyTI

- **Autor**: Humberto Cervantes Maceda  
- **Fecha**: 27/02/2026

---

## Overview

This iteration plan follows the Attribute-Driven Design (ADD) process described in `ADD.md`. The design is organized into five iterations: the first establishes the overall system structure, the second addresses DevOps and deployment infrastructure, and the subsequent three address the high-priority architectural drivers progressively, building on the decisions made in previous iterations.

---

## Iteration Plan

| Iteration | Goal | Drivers Addressed |
| :---: | :--- | :--- |
| **1** | **Establish the overall system structure.** Define the reference architecture, technology stack, deployment model, and multi-tenant strategy. Decompose the system into its primary containers and establish the foundational patterns that address the key structural constraints and quality attributes. | CON-1, CON-2, CON-3, CON-4, CON-5, CON-6, CON-7, QA-3, QA-4 |
| **2** | **Establish DevOps and deployment infrastructure.** Design the containerization strategy, CI/CD pipeline, and deployment automation. Ensure the deployment architecture supports portability to cloud environments and provides a repeatable build-and-deploy cycle for the rotating student development team. | QA-5, CON-2, CON-6 |
| **3** | **Address security cross-cutting concerns.** Design the authentication and role-based authorization mechanisms, and establish the security practices that protect the system against CWE Top 25 vulnerabilities. This iteration also supports the login use case, which is a prerequisite for all other functional requirements. | QA-1, QA-2, HU-01 |
| **4** | **Support entity management and internationalization.** Design the components responsible for managing core entities (students and professors), including CRUD operations, data validation, and the internationalization infrastructure that will apply to all user-facing views. | HU-15, HU-21, QA-6 |
| **5** | **Support the enrollment workflow.** Design the end-to-end enrollment flow: loading the academic offering from a CSV file, student course selection, advisor approval, and generation of the official enrollment document for Sistemas Escolares. This iteration addresses the stateful business process that spans multiple actors and integrates with external systems. | HU-06, HU-07, HU-08, HU-09, CON-3 |

---

## Rationale

- **Iteration 1** tackles the full system as a single element (greenfield). The constraints (CON-1–CON-7) and the quality attributes with the highest structural impact (QA-3 parametrization, QA-4 multi-tenant) are addressed here because they shape the overall decomposition, technology choices, and logical architecture. Decisions made in this iteration define the "skeleton" upon which all subsequent iterations build.

- **Iteration 2** focuses on the physical deployment architecture and DevOps practices. QA-5 (portability / cloud readiness) is addressed here through containerization and infrastructure-as-code decisions. CON-2 (on-premise deployment) and CON-6 (student developers with short internships) are revisited because a well-designed CI/CD pipeline and deployment automation are critical for team continuity when developers rotate frequently. This iteration must be completed before feature development begins so that the student teams have a repeatable build-test-deploy cycle from day one.

- **Iteration 3** is dedicated to security because QA-1 (RBAC) and QA-2 (CWE Top 25 protection) are cross-cutting concerns with high business relevance and high implementation difficulty. Designing them early avoids costly retrofitting and ensures that the patterns are in place before any functional requirement is implemented. HU-01 (login) is included here as it is the concrete use case that exercises the authentication and authorization infrastructure.

- **Iteration 4** groups HU-15 (register student) and HU-21 (register professor) because they are structurally similar CRUD operations over core domain entities. Addressing them together allows establishing reusable patterns for entity management, validation, and persistence. QA-6 (internationalization) is included in this iteration because entity management views are the first user-facing screens to be designed, making this the natural point to embed the i18n infrastructure that will propagate to all subsequent views.

- **Iteration 5** addresses the most complex functional scenario: the multi-step enrollment workflow involving the Coordinator, Student, and Advisor across HU-06, HU-07, HU-08, and HU-09. This iteration depends on the security infrastructure (Iteration 3) and the entity management patterns (Iteration 4). CON-3 (TXT/XLSX export for Sistemas Escolares) is addressed here because it is directly tied to the enrollment format generation in HU-09.
