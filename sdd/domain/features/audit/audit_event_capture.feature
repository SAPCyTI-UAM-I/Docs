# language: en
@module:audit @bounded-context:BC-05 @subdomain:supporting
Feature: Cross-cutting audit event capture and querying
  As a System Administrator or Coordinator
  I want the system to automatically capture audit events for security and domain actions
  So that there is a compliance-ready audit trail for institutional traceability

  Reference: Architecture.md §4.1 Logical Domain Events | Schema: audit.schema.json#/definitions/AuditEvent
  Bounded Context: BC-05 Audit (Supporting Sub-Domain)
  Upstream dependencies: BC-06 Identity & Access (R3 — actorId, actorRole), BC-04 Program Configuration (R4 — graduateProgramId)
  Event sources: All other BCs emit events consumed by Audit via AuditOutputPort
  Implementation: JPA @EntityListener (domain mutations) + AOP SecurityAuditAspect (security events)

  Background:
    Given the AuditOutputPort is available to all Bounded Contexts
    And graduate program "PCyTI" with id 1 exists in BC-04

  # --- Security Events (HIGH severity) ---

  @driver:QA-1 @driver:QA-2 @priority:high
  Scenario: Capture successful login event
    When a user with id 50 and role "PROFESSOR" logs in successfully from IP "192.168.1.100"
    Then the system persists an AuditEvent with:
      | field              | value              |
      | action             | LOGIN_SUCCESS      |
      | actorId            | 50                 |
      | actorRole          | PROFESSOR          |
      | severityLevel      | HIGH               |
      | ipAddress          | 192.168.1.100      |
      | graduateProgramId  | 1                  |
    And writes a structured log entry to stdout (12-Factor App)

  @driver:QA-1 @driver:QA-2 @priority:high
  Scenario: Capture failed login attempt
    When a login attempt fails for email "unknown@uam.mx" from IP "10.0.0.5"
    Then the system persists an AuditEvent with:
      | field              | value              |
      | action             | LOGIN_FAILED       |
      | severityLevel      | HIGH               |
      | ipAddress          | 10.0.0.5           |
    And the actorId is null (unknown user)
    And the actorRole is "ANONYMOUS"

  @driver:QA-1 @priority:high
  Scenario: Capture RBAC violation
    When user 50 with role "STUDENT" attempts to access a COORDINATOR-only resource
    Then the system persists an AuditEvent with:
      | field              | value                    |
      | action             | RBAC_VIOLATION_DETECTED  |
      | actorId            | 50                       |
      | actorRole          | STUDENT                  |
      | severityLevel      | HIGH                     |

  @driver:QA-2 @priority:high
  Scenario: Capture password reset request
    When user 50 requests a password reset from IP "192.168.1.100"
    Then the system persists an AuditEvent with action "PASSWORD_RESET_REQUESTED" and severity HIGH

  @driver:QA-2 @priority:high
  Scenario: Capture password change event
    When user 50 changes their password (changeType "SELF")
    Then the system persists an AuditEvent with action "PASSWORD_CHANGED" and severity HIGH
    And the details field contains changeType "SELF"

  # --- Domain Mutation Events (STANDARD severity) ---

  @priority:high
  Scenario: Capture student registration
    When a student with id 60 is registered by coordinator 1
    Then the system persists an AuditEvent with:
      | field              | value               |
      | action             | STUDENT_REGISTERED  |
      | actorId            | 1                   |
      | entityType         | Student             |
      | entityId           | 60                  |
      | severityLevel      | STANDARD            |

  @priority:high
  Scenario: Capture professor registration
    When a professor with id 10 is registered by coordinator 1
    Then the system persists an AuditEvent with action "PROFESSOR_REGISTERED" and severity STANDARD

  @priority:high
  Scenario: Capture academic offer upload
    When the academic offer for term 100 is uploaded with 15 groups
    Then the system persists an AuditEvent with action "ACADEMIC_OFFER_UPLOADED" and severity STANDARD
    And the details field contains totalGroups: 15

  @priority:high
  Scenario: Capture enrollment period opening
    When the coordinator opens enrollment for term 100
    Then the system persists an AuditEvent with action "ENROLLMENT_PERIOD_OPENED" and severity STANDARD

  @priority:high
  Scenario: Capture course selection by student
    When student 50 completes course selection for enrollment 300
    Then the system persists an AuditEvent with action "COURSES_SELECTED" and severity STANDARD
    And the details field contains the selected group IDs

  @priority:high
  Scenario: Capture enrollment approval by advisor
    When advisor 10 approves enrollment 300 for student 50
    Then the system persists an AuditEvent with action "ENROLLMENT_APPROVED_BY_ADVISOR" and severity STANDARD

  @priority:high
  Scenario: Capture enrollment rejection by advisor
    When advisor 10 rejects enrollment 300 with reason "Excessive course load"
    Then the system persists an AuditEvent with action "ENROLLMENT_REJECTED_BY_ADVISOR" and severity STANDARD
    And the details field contains the rejection reason

  @priority:high
  Scenario: Capture enrollment finalization
    When coordinator 1 finalizes enrollment 300
    Then the system persists an AuditEvent with action "ENROLLMENT_FINALIZED" and severity STANDARD

  # --- Querying and Multi-tenant Filtering ---

  @driver:QA-4 @priority:medium
  Scenario: Query audit events filtered by graduate program
    Given audit events exist for program id 1 and program id 2
    When the coordinator queries audit events with graduateProgramId 1
    Then the system returns only events scoped to program 1
    And events from program 2 are not included

  @priority:medium
  Scenario: Query audit events filtered by severity
    Given audit events exist with severity HIGH and STANDARD
    When the coordinator queries audit events with severityLevel "HIGH"
    Then the system returns only HIGH severity events

  @priority:medium
  Scenario: Query audit events filtered by date range
    When the coordinator queries audit events between "2026-05-01" and "2026-05-31"
    Then the system returns only events within that date range
    And results are ordered by timestamp descending
