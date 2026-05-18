# Architectural Concerns

This document outlines key architectural concerns that need to be addressed during the system design phase. These concerns complement the requirements specified in the Vision Document, user stories, and quality attribute scenarios.

## 1. Data Management and Persistence

### Data Storage and Lifecycle

- **C001.1.1**: Retention policies for different types of data (applicant dossiers, SNP/Conacyt supporting documents, user history).
- **C001.1.2**: Storage mechanisms for heavy documents (e.g., thesis PDFs and evidence files), leveraging the 16TB server capacity.
- **C001.1.3**: Purge and archival strategy for historical data from graduated cohorts, optimizing long-term disk storage.

### Data Migration and Backup

- **C001.2.1**: Frequency of automated database and physical file backups (monthly, quarterly).
- **C001.2.2**: Disaster Recovery strategy, considering off-site physical backup copies away from the local UAM facility.
- **C001.2.3**: Considerations for migrating initial data from multiple pre-existing Excel spreadsheets to the new modeled system.

## 2. Integration Architecture

### Integration with Institutional Systems

- **C002.1.1**: Reliable generation and export of student information in institutional flat formats (TXT, XLSX) for compatibility with the corporate School Control System.
- **C002.1.2**: Management of potential future bidirectional integrations with SAP or Virtuami, isolating logic through adapters to avoid fragile dependencies.

### External APIs and Services

- **C002.2.1**: Automatic synchronization of events, seminars, and projects with the institutional WordPress site API.
- **C002.2.2**: Integration of automatic notifications via Facebook Graph and YouTube APIs.
- **C002.2.3**: Reliable internal service for bulk email delivery from the postgraduate coordination (managing quotas, avoiding blacklists).

## 3. Security Architecture

### Sensitive Data Protection

- **C003.1.1**: Protection against unauthorized public access to applicant and student dossiers and grades on the local file server.
- **C003.1.2**: Strategy for encrypting passwords and sensitive data stored in the database.
- **C003.1.3**: Secure mechanisms (e.g., signed or time-limited URLs) for uploading and downloading files.

### Access Control (RBAC)

- **C003.2.1**: Implementation of Role-Based Access Control (Applicant, Student, Professor/Tutor, Administrative Assistant, Coordinator, System Administrator).
- **C003.2.2**: Comprehensive real-time Audit Logging for modifications to grades, curricular approvals, and admission evaluations.
- **C003.2.3**: Robust concurrent session management.

## 4. Operational Architecture

### Environment and Deployment

- **C004.1.1**: Deployment in a monolithic or containerized environment on a single high-performance Linux server (16TB/32GB RAM).
- **C004.1.2**: Environment structuring that deliberately avoids incurring cloud costs (exclusive use of the aforementioned on-premise hardware).

### Observability and Load

- **C004.2.1**: Control and prevention of service degradation during "peak load" times, such as quarterly enrollment periods.
- **C004.2.2**: Health monitoring of local server hardware, including disk consumption and memory alerts.
- **C004.2.3**: Standardized access logs to facilitate error identification in production and respond to support requests.

## 5. Development Architecture

### Development Workflow and DevOps

- **C005.1.1**: Adoption of **GitFlow** strategy (using `main`, `develop`, and supporting branches: `feature/`, `release/`, `hotfix/`). Given the student rotation, this framework ensures control over what is deployed institutionally.
- **C005.1.2**: Implementation of mandatory Code Reviews via Pull/Merge Requests, led by senior/academic profiles prior to merging.
- **C005.1.3**: Standardization of history metadata format with **Conventional Commits** to ensure historical readability:
    - `feat:` (New features)
    - `fix:` (Bug fixes)
    - `docs:` (Documentation changes)
    - `refactor:` (Code changes without altering behavior)
    - `test:` (Adding tests)
    - `chore:` (Maintenance tasks, dependency updates)
- **C005.1.4**: Continuous linting automation and unit test suite execution prior to merging into the `develop` branch.
- **C005.1.5**: Automated deployment process to Pre-Production and Production environments.

### Code Organization

- **C005.2.1**: Management of logical boundaries and responsibilities by separating the SPA (Angular) from the Backend API (Spring Boot), assuming maintenance by students on semestral rotation.
- **C005.2.2**: Dependency management and code reuse strategies to share logic among different modules (Admission, Enrollment, etc.).
- **C005.2.3**: Rigorous requirement for technical documentation within the source code of each fundamental component.

### Technical Debt

- **C005.3.1**: Tracking technical debt derived from developments made by students during short stays.
- **C005.3.2**: Prioritizing constant refactoring to prevent long-term system degradation.
- **C005.3.3**: Clear documentation of "legacy" integrations or temporary patches implemented by previous teams.

## 6. Business Architecture

### Business Continuity

- **C006.1.1**: Impact analysis for critical processes such as CONACYT evaluations and the quarterly admission process.
- **C006.1.2**: Identification of critical processes where the system must be available, ensuring adequate redundancy on the local server.
- **C006.1.3**: Establishment of internal Service Level Agreements (SLAs) and Key Performance Indicators (KPIs) for postgraduate management.

### Cost Management

- **C006.2.1**: Limiting the system to use on-premise hardware (Linux 16TB/32GB RAM) to avoid recurring cloud infrastructure costs.
- **C006.2.2**: Optimization strategies and local resource monitoring to prevent the premature need for additional hardware acquisition.

### Vendor Management

- **C006.3.1**: Evaluation criteria when depending on third-party services or libraries (Open Source vs Commercial), prioritizing Open Source due to budget constraints.
- **C006.3.2**: Monitoring contract and license changes in selected dependencies on a quarterly basis.

## 7. Compliance and Legal

### Regulatory Requirements

- **C007.1.1**: Support for collecting academic metrics (admission/graduation rates, etc.) required by the Conacyt SNP and the POEP Institutional Framework.
- **C007.1.2**: Compliance with personal data protection regulations under Mexican legislation and UAM policies, tailored to students and applicants.
- **C007.1.3**: Report generation strictly following guidelines and formats stipulated by institutional authorities.

### Legal Considerations

- **C007.2.1**: Privacy policy management for handling dossiers and sensitive data of students and candidates within the 16TB storage.
- **C007.2.2**: Code intellectual property rights, considering developers are students fulfilling social service or terminal projects at UAM.

## 8. Future-Proofing

### Technology Evolution

- **C008.1.1**: Strategy for periodically updating the technology stack (Java 21, Spring Boot, Angular, PostgreSQL) to prevent vulnerabilities and obsolescence.
- **C008.1.2**: Deprecation policies for old APIs or file formats, anticipating future integration with newer versions of SAP or Virtuami.

### Business Evolution

- **C008.2.1**: Parameterization of the SAPCyTI system for easy replication to other UAM postgraduate programs (multi-program support).
- **C008.2.2**: Internationalization capabilities and support for features necessary for double-degree agreements, including English language support.

## 9. User Experience

### Accessibility

- **C009.1.1**: Compliance with usability principles (WCAG baseline) to ensure the system is usable by people with various cognitive or visual abilities.
- **C009.1.2**: Support for user-friendly consumption via responsive interfaces on mobile devices, especially aimed at professors and students.

### Performance Perception

- **C009.2.1**: Proper handling of load states when uploading or downloading heavy documents (PDF proof files to the 16TB local server).
- **C009.2.2**: Granular and user-friendly error notification mechanisms for failed integrations (e.g., school control, WordPress API).

## 10. Testing Architecture

### Test Strategy

- **C010.1.1**: Management of local test environments replicating the hardware and network conditions of the institutional production server.
- **C010.1.2**: Management of sanitized and anonymized test data (mock data) so students can test functionality without compromising real postgraduate data.
- **C010.1.3**: Unit test automation strategy implemented before crossing into `develop`.
- **C010.1.4**: Performance (Load testing) strategy to ensure operation during quarterly peak moments.

### Quality Assurance

- **C010.2.1**: Implementation of 'Quality Gates' supported by PR/MR validation flows to reject unstable student code submissions.
- **C010.2.2**: Recurrent practices of security scanning and vulnerability control over Java (Maven/Gradle) and Angular (npm) dependencies introduced by new students.
