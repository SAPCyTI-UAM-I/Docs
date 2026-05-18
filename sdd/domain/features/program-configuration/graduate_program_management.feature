# language: en
@module:configuration @bounded-context:BC-04 @subdomain:supporting
Feature: Graduate program management
  As a Graduate Program Coordinator or System Administrator
  I want to register, query, and update graduate programs
  So that the multi-tenant context that enables per-program parameterization is established (QA-4)

  Reference: QA-4 | Schema: program-configuration.schema.json#/definitions/CreateGraduateProgramCommand
  Bounded Context: BC-04 Program Configuration (Supporting Sub-Domain)
  Upstream dependencies: None — BC-04 is the root context with no dependencies
  Downstream consumers: BC-02 Academic Management, BC-03 Academic Offering, BC-01 Enrollment, BC-05 Audit

  Background:
    Given the user is authenticated with role "COORDINATOR" via BC-06 Identity & Access
    And no graduate programs are registered in the system

  # --- Main Flow (Happy Path) ---

  @driver:QA-4 @priority:high
  Scenario: Successful registration of a graduate program
    When the coordinator sends a CreateGraduateProgramCommand with:
      | field    | value                                    |
      | name     | Ciencias y Tecnologías de la Información |
      | division | CBI                                      |
    Then the system creates a GraduateProgram with an auto-generated id
    And the program has the name "Ciencias y Tecnologías de la Información"
    And the program has the division "CBI"
    And responds with HTTP 201
    And the system emits an audit event to BC-05 Audit with severity STANDARD

  @driver:QA-4 @priority:high
  Scenario: Registration of multiple divisional programs
    Given the program "Ciencias y Tecnologías de la Información" with id 1 exists in division "CBI"
    When the coordinator registers the following programs:
      | name                              | division |
      | Energía y Medio Ambiente          | CBI      |
      | Ciencias Sociales                 | CSH      |
      | Biología Experimental             | CBS      |
    Then the system contains 4 active graduate programs
    And each program has a unique id
    And the system supports operating with up to 9 divisional programs as per QA-4

  @driver:QA-4 @priority:high
  Scenario: Query all graduate programs
    Given the following programs exist:
      | id | name                                     | division |
      | 1  | Ciencias y Tecnologías de la Información | CBI      |
      | 2  | Energía y Medio Ambiente                 | CBI      |
    When the coordinator queries the list of programs
    Then the system responds with HTTP 200
    And returns the 2 programs with their basic data and parameter count

  @driver:QA-4 @priority:high
  Scenario: Query a program with its configuration parameters
    Given the program "PCyTI" with id 1 exists
    And the program has the following parameters:
      | key                    | value | description                                |
      | MAX_COURSES_PER_TERM   | 3     | Maximum UEAs per term for students         |
      | CREDIT_LIMIT_PER_TERM  | 27    | Credit limit per term                      |
    When the coordinator queries the detail of the program with id 1
    Then the system responds with the program data and its 2 parameters

  @driver:QA-4 @priority:medium
  Scenario: Update basic data of a program
    Given the program "PCyTI" with id 1 and division "CBI" exists
    When the coordinator sends an UpdateGraduateProgramCommand with:
      | field    | value                                              |
      | id       | 1                                                  |
      | name     | Posgrado en Ciencias y Tecnologías de la Información |
      | division | CBI                                                |
    Then the system updates the program name
    And responds with HTTP 200
    And existing configuration parameters are not modified

  # --- Alternative and Error Flows ---

  @driver:QA-4 @priority:high
  Scenario: Rejection of program with duplicate name
    Given the program "Ciencias y Tecnologías de la Información" with id 1 exists
    When the coordinator attempts to create another program with name "Ciencias y Tecnologías de la Información"
    Then the system rejects the request with HTTP 409
    And returns the message: "A graduate program with that name already exists"

  @driver:QA-4 @priority:high
  Scenario: Rejection of program with empty name
    When the coordinator sends a CreateGraduateProgramCommand with an empty name
    Then the system rejects the request with HTTP 400
    And returns the validation message: "Program name is required"

  @driver:QA-4 @priority:high
  Scenario: Rejection of program with empty division
    When the coordinator sends a CreateGraduateProgramCommand with an empty division
    Then the system rejects the request with HTTP 400
    And returns the validation message: "Division is required"

  @driver:QA-4 @priority:high
  Scenario: Rejection of access with unauthorized role
    Given a user is authenticated with role "STUDENT"
    When they attempt to create a graduate program
    Then the system denies access with HTTP 403
    And emits the "RBACViolationDetected" event to BC-05 Audit with severity HIGH

  @driver:QA-4 @priority:medium
  Scenario: Query of non-existent program
    When the coordinator queries the program with id 999
    Then the system responds with HTTP 404
    And returns the message: "Graduate program not found"
