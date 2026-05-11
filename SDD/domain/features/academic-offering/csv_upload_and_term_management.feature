# language: en
@module:offering @bounded-context:BC-03 @subdomain:core
Feature: CSV upload and academic offer creation
  As a Graduate Program Coordinator
  I want to select a term and upload the CSV file with schedules and lotteries
  So that the enrollment system is enabled and students can view the available courses

  Reference: HU-06 | Schema: academic-offering.schema.json#/definitions/UploadAcademicOfferCommand
  Bounded Context: BC-03 Academic Offering (Core Domain)
  Upstream dependencies: BC-04 Program Configuration (R8 — graduateProgramId scope), BC-02 Academic Management (R9 — professorId resolution)
  Downstream consumers: BC-01 Enrollment (R6 — termId, uEAGroupId, availableQuota)
  ACL: CsvAcademicOfferAdapter (Apache Commons CSV) — Anti-Corruption Layer for CSV parsing

  Background:
    Given the user is authenticated with role "COORDINATOR" via BC-06 Identity & Access
    And graduate program "PCyTI" with id 1 exists in BC-04 Program Configuration
    And the header "X-Graduate-Id" is set to 1
    And a Term with id 100 and code "25P" exists in state "PLANNING"
    And the following professors exist in BC-02 Academic Management:
      | professorId | employeeNumber | name                              |
      | 10          | 30568          | Cervantes Maceda Humberto Gustavo |
      | 11          | 30245          | García López María Elena          |

  # --- Happy Path ---

  @requirement:HU-06 @priority:high
  Scenario: Successful CSV upload and academic offer creation
    When the coordinator uploads a valid CSV file for term id 100 via UploadAcademicOfferCommand
    And the CSV contains the following rows:
      | ueaCode | ueaName                  | credits | groupCode | quota | professorEmployeeNumber | day      | startTime | endTime  |
      | 2156053 | Ingeniería de Software I | 9       | CP33      | 25    | 30568                   | THURSDAY | 09:30     | 11:00    |
      | 2156054 | Bases de Datos Avanzadas | 9       | CP34      | 20    | 30245                   | TUESDAY  | 11:00     | 12:30    |
    Then the CsvAcademicOfferAdapter (ACL) parses, validates, and maps CSV rows to domain commands
    And the system resolves or creates UEA references for codes "2156053" and "2156054"
    And resolves Professor references via ProfessorQueryPort from BC-02
    And creates an AcademicOffer aggregate with 2 UEAGroups
    And each UEAGroup has availableQuota initialized equal to quota
    And the Term with id 100 transitions from "PLANNING" to "OFFER_LOADED"
    And persists everything in a single transaction
    And responds with HTTP 200
    And returns a CsvImportResult with totalGroupsImported: 2, totalUeasResolved: 2
    And emits an "AcademicOfferUploaded" event to BC-05 Audit with severity STANDARD

  @requirement:HU-06 @priority:high
  Scenario: Coordinator reviews the imported academic offer
    Given the Term "25P" is in state "OFFER_LOADED" with an academic offer
    When the coordinator queries the academic offer for term id 100
    Then the system responds with HTTP 200
    And returns an AcademicOfferResponse with all UEAGroups, schedules, and professor names
    And the coordinator can verify that the data matches the CSV before opening enrollment

  @requirement:HU-06 @priority:high
  Scenario: Opening the enrollment period
    Given the Term "25P" is in state "OFFER_LOADED" with at least one UEAGroup
    When the coordinator sends an OpenEnrollmentCommand for term id 100
    Then the Term transitions from "OFFER_LOADED" to "IN_ENROLLMENT"
    And students can now select courses for this term (HU-07 via BC-01)
    And responds with HTTP 200
    And emits an "EnrollmentPeriodOpened" event to BC-05 Audit with severity STANDARD

  # --- Error and Alternative Flows ---

  @requirement:HU-06 @priority:high
  Scenario: CSV upload rejected for non-PLANNING term
    Given the Term "25P" is in state "IN_ENROLLMENT"
    When the coordinator attempts to upload a CSV for term id 100
    Then the system responds with HTTP 409
    And returns the message: "Academic offer can only be uploaded when the term is in PLANNING state"

  @requirement:HU-06 @priority:high
  Scenario: CSV upload rejected with invalid file format
    When the coordinator uploads a PDF file instead of a CSV
    Then the system responds with HTTP 400
    And returns the message: "Invalid file format. Only CSV files are accepted"

  @requirement:HU-06 @priority:high
  Scenario: CSV upload with row-level validation errors
    When the coordinator uploads a CSV with missing required fields in some rows
    Then the CsvAcademicOfferAdapter reports row-level errors in CsvImportResult
    And valid rows are still processed
    And the coordinator receives a detailed error report per row

  @requirement:HU-06 @priority:high
  Scenario: CSV upload rejected with unresolvable professor reference
    When the CSV contains an employeeNumber "99999" that does not exist in BC-02
    Then the system reports an error for that row: "Professor with employee number 99999 not found"
    And the row is skipped

  @requirement:HU-06 @priority:high
  Scenario: Opening enrollment rejected for term without academic offer
    Given the Term "25P" is in state "PLANNING" and has no academic offer
    When the coordinator sends an OpenEnrollmentCommand for term id 100
    Then the system responds with HTTP 409
    And returns the message: "Cannot open enrollment without a loaded academic offer"

  @requirement:HU-06 @priority:high
  Scenario: Opening enrollment rejected for already-open term
    Given the Term "25P" is already in state "IN_ENROLLMENT"
    When the coordinator sends an OpenEnrollmentCommand
    Then the system responds with HTTP 409
    And returns the message: "Enrollment period is already open for this term"

  @requirement:HU-06 @driver:QA-1 @priority:high
  Scenario: CSV upload rejected with unauthorized role
    Given the user is authenticated with role "STUDENT"
    When the user attempts to upload a CSV
    Then the system responds with HTTP 403
    And emits a "RBACViolationDetected" event to BC-05 Audit with severity HIGH

  @requirement:HU-06 @priority:medium
  Scenario: CSV upload with duplicate group codes in same term
    When the CSV contains two rows with the same ueaCode and groupCode
    Then the system skips the duplicate row
    And includes a warning in CsvImportResult: "Duplicate group CP33 for UEA 2156053 skipped"
