# language: en
@module:academic @bounded-context:BC-02 @subdomain:core
Feature: Professor registration
  As a Graduate Program Coordinator
  I want to register a new professor in the system
  So that they can teach courses and advise students

  Reference: HU-21 | Schema: academic-management.schema.json#/definitions/RegisterProfessorCommand
  Bounded Context: BC-02 Academic Management (Core Domain)
  Upstream dependencies: BC-06 Identity & Access (R1 — User creation, PasswordEncoderPort), BC-04 Program Configuration (R2 — graduateProgramId)
  Downstream consumers: BC-01 Enrollment (R5 — advisorId verification), BC-03 Academic Offering (R9 — professorId for UEAGroup assignment)
  Domain Service: PasswordGenerationService (generates cryptographically secure 12-char passwords)

  Background:
    Given the user is authenticated with role "COORDINATOR" via BC-06 Identity & Access
    And graduate program "PCyTI" with id 1 exists in BC-04 Program Configuration
    And the header "X-Graduate-Id" is set to 1

  # --- Happy Path ---

  @requirement:HU-21 @priority:high
  Scenario: Successful professor registration with all required fields
    When the coordinator sends a RegisterProfessorCommand with:
      | field              | value                          |
      | employeeNumber     | 30568                          |
      | email              | humberto.cervantes@uam.mx      |
      | graduateProgramId  | 1                              |
      | firstName          | Humberto Gustavo               |
      | firstLastName      | Cervantes                      |
      | secondLastName     | Maceda                         |
    Then the system generates a secure password via PasswordGenerationService (12 chars, mixed complexity)
    And hashes the password via PasswordEncoderPort from BC-06 (BCrypt)
    And creates a User with role "PROFESSOR" in BC-06 Identity & Access
    And creates a Professor aggregate with PersonalData
    And associates the professor with graduate program id 1
    And persists both User and Professor in a single transaction
    And responds with HTTP 201
    And returns a ProfessorResponse including the one-time plaintext generatedPassword
    And emits a "ProfessorRegistered" event to BC-05 Audit with severity STANDARD

  @requirement:HU-21 @priority:medium
  Scenario: Professor registration without optional secondLastName
    When the coordinator sends a RegisterProfessorCommand without secondLastName
    Then the system creates the Professor with secondLastName null
    And responds with HTTP 201

  # --- Error and Alternative Flows ---

  @requirement:HU-21 @priority:high
  Scenario: Registration rejected with duplicate email
    Given a user with email "humberto.cervantes@uam.mx" already exists in BC-06
    When the coordinator sends a RegisterProfessorCommand with the same email
    Then the system responds with HTTP 409
    And returns the message: "A user with this email already exists"

  @requirement:HU-21 @priority:high
  Scenario: Registration rejected with duplicate employee number
    Given a professor with employeeNumber "30568" already exists
    When the coordinator sends a RegisterProfessorCommand with the same employeeNumber
    Then the system responds with HTTP 409
    And returns the message: "A professor with this employee number already exists"

  @requirement:HU-21 @priority:high
  Scenario: Registration rejected with missing required fields
    When the coordinator sends a RegisterProfessorCommand with employeeNumber empty
    Then the system responds with HTTP 400
    And returns validation errors listing all missing required fields

  @requirement:HU-21 @priority:high
  Scenario: Registration rejected with invalid email format
    When the coordinator sends a RegisterProfessorCommand with email "invalid"
    Then the system responds with HTTP 400
    And returns a validation error for the email field

  @requirement:HU-21 @priority:high
  Scenario: Registration rejected with non-existent graduate program
    When the coordinator sends a RegisterProfessorCommand with graduateProgramId 999
    Then the system responds with HTTP 404
    And returns the message: "Graduate program not found"

  @requirement:HU-21 @driver:QA-1 @priority:high
  Scenario: Registration rejected with unauthorized role
    Given the user is authenticated with role "STUDENT"
    When the user attempts to register a professor
    Then the system responds with HTTP 403
    And emits a "RBACViolationDetected" event to BC-05 Audit with severity HIGH
