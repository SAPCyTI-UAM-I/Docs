# language: en
@module:configuration @bounded-context:BC-04 @subdomain:supporting
Feature: Configuration parameter management per program
  As a Graduate Program Coordinator
  I want to set, modify, and query the configuration parameters of a program
  So that I can modify business rules (dates, quotas, criteria) without changing source code (QA-3)

  Reference: QA-3 | Schema: program-configuration.schema.json#/definitions/SetConfigurationParameterCommand
  Bounded Context: BC-04 Program Configuration (Supporting Sub-Domain)
  Upstream dependencies: None
  Downstream consumers:
    - BC-01 Enrollment → reads MAX_COURSES_PER_TERM, CREDIT_LIMIT_PER_TERM (R10)
    - BC-03 Academic Offering → reads program scope parameters (R8)
    - BC-02 Academic Management → reads per-program business rules (R2)

  Background:
    Given the user is authenticated with role "COORDINATOR" via BC-06 Identity & Access
    And the graduate program "PCyTI" with id 1 and division "CBI" exists
    And the header "X-Graduate-Id" contains the value 1

  # --- Main Flow (Happy Path) ---

  @driver:QA-3 @priority:high
  Scenario: Set a new configuration parameter
    When the coordinator sends a SetConfigurationParameterCommand with:
      | field              | value                                  |
      | graduateProgramId  | 1                                      |
      | key                | MAX_COURSES_PER_TERM                   |
      | value              | 3                                      |
      | description        | Maximum UEAs per term per student      |
    Then the system creates the parameter within the program with id 1
    And responds with HTTP 200
    And the parameter is queryable by other Bounded Contexts via output ports

  @driver:QA-3 @priority:high
  Scenario: Update the value of an existing parameter
    Given the program "PCyTI" has the parameter:
      | key                  | value | description                     |
      | MAX_COURSES_PER_TERM | 3     | Maximum UEAs per term           |
    When the coordinator sends a SetConfigurationParameterCommand with:
      | field              | value                          |
      | graduateProgramId  | 1                              |
      | key                | MAX_COURSES_PER_TERM           |
      | value              | 4                              |
      | description        | Maximum UEAs updated to 4      |
    Then the system replaces the value of parameter MAX_COURSES_PER_TERM to "4"
    And the change is effective immediately for downstream Bounded Contexts
    And responds with HTTP 200

  @driver:QA-3 @priority:high
  Scenario: Set multiple parameters for a program
    When the coordinator sets the following parameters for the program with id 1:
      | key                      | value      | description                              |
      | MAX_COURSES_PER_TERM     | 3          | Maximum UEAs per term                    |
      | CREDIT_LIMIT_PER_TERM    | 27         | Credit limit per term                    |
      | ENROLLMENT_START_DATE    | 2026-06-01 | Enrollment period start date             |
      | ENROLLMENT_END_DATE      | 2026-06-15 | Enrollment period end date               |
      | MAX_STUDENTS_PER_ADVISOR | 10         | Maximum students advised per professor   |
    Then the program has 5 configuration parameters
    And each parameter has its correct key, value, and description

  @driver:QA-3 @priority:high
  Scenario: Query configuration parameters of a program
    Given the program "PCyTI" has the parameters:
      | key                    | value |
      | MAX_COURSES_PER_TERM   | 3     |
      | CREDIT_LIMIT_PER_TERM  | 27    |
    When the parameters of the program with id 1 are queried
    Then the system responds with HTTP 200
    And returns the 2 parameters with their keys, values, and descriptions

  @driver:QA-3 @priority:high
  Scenario: Query a specific parameter by key
    Given the program "PCyTI" has the parameter MAX_COURSES_PER_TERM with value "3"
    When the parameter with key "MAX_COURSES_PER_TERM" of the program with id 1 is queried
    Then the system responds with HTTP 200
    And returns the value "3" and the parameter description

  @driver:QA-3 @priority:medium
  Scenario: Delete a configuration parameter
    Given the program "PCyTI" has the parameter ENROLLMENT_START_DATE
    When the coordinator sends a DeleteConfigurationParameterCommand with:
      | field              | value                  |
      | graduateProgramId  | 1                      |
      | key                | ENROLLMENT_START_DATE  |
    Then the system removes the parameter from the program
    And responds with HTTP 204

  # --- Multi-tenant Isolation Scenarios (QA-4) ---

  @driver:QA-3 @driver:QA-4 @priority:high
  Scenario: Parameter isolation between programs
    Given the program "PCyTI" with id 1 has parameter MAX_COURSES_PER_TERM = "3"
    And the program "Energía y Medio Ambiente" with id 2 has parameter MAX_COURSES_PER_TERM = "5"
    When a downstream Bounded Context queries MAX_COURSES_PER_TERM for program 1
    Then it obtains the value "3"
    And when it queries MAX_COURSES_PER_TERM for program 2
    Then it obtains the value "5"
    And one program's parameters never affect another program

  @driver:QA-4 @priority:high
  Scenario: Each program operates with its own independent rules
    Given the program "PCyTI" (id 1) has CREDIT_LIMIT_PER_TERM = "27"
    And the program "Ciencias Sociales" (id 3) has CREDIT_LIMIT_PER_TERM = "36"
    When BC-01 Enrollment validates the course selection of a student from program 1
    Then it applies the limit of 27 credits
    And does not apply the limit of 36 credits from program 3

  # --- Error Flows ---

  @driver:QA-3 @priority:high
  Scenario: Rejection of parameter with empty key
    When the coordinator sends a SetConfigurationParameterCommand with an empty key
    Then the system rejects the request with HTTP 400
    And returns the message: "Parameter key is required"

  @driver:QA-3 @priority:high
  Scenario: Rejection of parameter with invalid key format
    When the coordinator sends a SetConfigurationParameterCommand with key "max-courses"
    Then the system rejects the request with HTTP 400
    And returns the message: "Key must be in UPPER_SNAKE_CASE format"

  @driver:QA-3 @priority:high
  Scenario: Rejection of parameter with empty value
    When the coordinator sends a SetConfigurationParameterCommand with an empty value
    Then the system rejects the request with HTTP 400
    And returns the message: "Parameter value is required"

  @driver:QA-3 @priority:high
  Scenario: Rejection of operation on non-existent program
    When the coordinator sends a SetConfigurationParameterCommand with graduateProgramId 999
    Then the system rejects the request with HTTP 404
    And returns the message: "Graduate program not found"

  @priority:high
  Scenario: Rejection of access with unauthorized role
    Given a user is authenticated with role "STUDENT"
    When they attempt to set a configuration parameter
    Then the system denies access with HTTP 403
    And emits the "RBACViolationDetected" event to BC-05 Audit with severity HIGH

  @driver:QA-3 @priority:medium
  Scenario: Deletion of non-existent parameter
    When the coordinator attempts to delete the parameter "NONEXISTENT_KEY" from the program with id 1
    Then the system responds with HTTP 404
    And returns the message: "Configuration parameter not found"
