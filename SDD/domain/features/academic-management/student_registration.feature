# language: en
@module:academic @bounded-context:BC-02 @subdomain:core
Feature: Student registration
  As a Graduate Program Coordinator
  I want to register a new student with their personal and academic data
  So that they can be managed in the system and granted access to their account

  Reference: HU-15 | Schema: academic-management.schema.json#/definitions/RegisterStudentCommand
  Bounded Context: BC-02 Academic Management (Core Domain)
  Upstream dependencies: BC-06 Identity & Access (R1 — User creation, PasswordEncoderPort), BC-04 Program Configuration (R2 — graduateProgramId)
  Downstream consumers: BC-01 Enrollment (R5 — studentId, advisorId), BC-03 Academic Offering (R9 — professorId)
  Domain Service: PasswordGenerationService (generates cryptographically secure 12-char passwords)

  Background:
    Given the user is authenticated with role "COORDINATOR" via BC-06 Identity & Access
    And graduate program "PCyTI" with id 1 exists in BC-04 Program Configuration
    And the header "X-Graduate-Id" is set to 1
    And professor "Cervantes Maceda Humberto" with id 10 exists in the system

  # --- Happy Path ---

  @requirement:HU-15 @priority:high
  Scenario: Successful student registration with all required fields
    When the coordinator sends a RegisterStudentCommand with:
      | field                | value                    |
      | enrollmentId         | 2123803361               |
      | email                | paulina.valencia@uam.mx  |
      | graduateProgramId    | 1                        |
      | advisorId            | 10                       |
      | firstName            | Paulina                  |
      | firstLastName        | Valencia                 |
      | secondLastName       | Franco                   |
      | nationality          | Mexicana                 |
      | undergraduateDegree  | Computación              |
      | programType          | MAESTRIA                 |
      | admissionDate        | 2023-09-01               |
    Then the system generates a secure password via PasswordGenerationService (12 chars, mixed complexity)
    And hashes the password via PasswordEncoderPort from BC-06 (BCrypt)
    And creates a User with role "STUDENT" in BC-06 Identity & Access
    And creates a Student aggregate with PersonalData and AcademicInformation
    And associates the student with graduate program id 1
    And assigns advisor with professorId 10
    And persists both User and Student in a single transaction
    And responds with HTTP 201
    And returns a StudentResponse including the one-time plaintext generatedPassword
    And emits a "StudentRegistered" event to BC-05 Audit with severity STANDARD

  @requirement:HU-15 @priority:high
  Scenario: Student registration without advisor assignment
    When the coordinator sends a RegisterStudentCommand without advisorId
    Then the system creates the Student with advisorId null
    And the advisor can be assigned later
    And responds with HTTP 201

  @requirement:HU-15 @priority:medium
  Scenario: Student registration without optional secondLastName
    When the coordinator sends a RegisterStudentCommand without secondLastName
    Then the system creates the Student with secondLastName null
    And responds with HTTP 201

  # --- Error and Alternative Flows ---

  @requirement:HU-15 @priority:high
  Scenario: Registration rejected with duplicate email
    Given a user with email "paulina.valencia@uam.mx" already exists in BC-06
    When the coordinator sends a RegisterStudentCommand with the same email
    Then the system responds with HTTP 409
    And returns the message: "A user with this email already exists"

  @requirement:HU-15 @priority:high
  Scenario: Registration rejected with duplicate enrollment ID
    Given a student with enrollmentId "2123803361" already exists
    When the coordinator sends a RegisterStudentCommand with the same enrollmentId
    Then the system responds with HTTP 409
    And returns the message: "A student with this enrollment ID already exists"

  @requirement:HU-15 @priority:high
  Scenario: Registration rejected with missing required fields
    When the coordinator sends a RegisterStudentCommand with firstName empty
    Then the system responds with HTTP 400
    And returns validation errors listing all missing required fields

  @requirement:HU-15 @priority:high
  Scenario: Registration rejected with invalid email format
    When the coordinator sends a RegisterStudentCommand with email "not-an-email"
    Then the system responds with HTTP 400
    And returns a validation error for the email field

  @requirement:HU-15 @priority:high
  Scenario: Registration rejected with non-existent graduate program
    When the coordinator sends a RegisterStudentCommand with graduateProgramId 999
    Then the system responds with HTTP 404
    And returns the message: "Graduate program not found"

  @requirement:HU-15 @priority:medium
  Scenario: Registration rejected with non-existent advisor
    When the coordinator sends a RegisterStudentCommand with advisorId 999
    Then the system responds with HTTP 404
    And returns the message: "Professor not found"

  @requirement:HU-15 @driver:QA-1 @priority:high
  Scenario: Registration rejected with unauthorized role
    Given the user is authenticated with role "STUDENT"
    When the user attempts to register a student
    Then the system responds with HTTP 403
    And emits a "RBACViolationDetected" event to BC-05 Audit with severity HIGH
