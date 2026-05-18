# language: en
@module:identity @bounded-context:BC-06 @subdomain:generic
Feature: Password change by user or coordinator
  As an authenticated user or Coordinator
  I want to change a user's password
  So that the account remains secure or access can be restored

  Reference: HU-28 | Schema: identity-access.schema.json#/definitions/ChangePasswordCommand
  Bounded Context: BC-06 Identity & Access (Generic Sub-Domain)
  Upstream dependencies: BC-04 Program Configuration (graduateProgramId context)
  Downstream effects: All refresh tokens for the target user are revoked after password change

  Background:
    Given a registered user exists with:
      | field  | value                        |
      | id     | 50                           |
      | email  | alumno@uam.mx                |
      | role   | STUDENT                      |
      | active | true                         |

  # --- Happy Path ---

  @requirement:HU-28 @priority:high
  Scenario: Self-change password by authenticated user
    Given the user is authenticated as userId 50 with role "STUDENT"
    When the user sends a ChangePasswordCommand with:
      | field           | value          |
      | userId          | 50             |
      | currentPassword | OldP@ssword1   |
      | newPassword     | NewS3cur3!Pass |
    Then the system verifies the currentPassword matches the stored BCrypt hash
    And hashes the new password via PasswordEncoderPort
    And updates the User's passwordHash
    And revokes all refresh tokens for userId 50
    And responds with HTTP 200
    And emits a "PasswordChanged" event to BC-05 Audit with changeType "SELF" and severity HIGH

  @requirement:HU-28 @priority:high
  Scenario: Coordinator changes another user's password
    Given the user is authenticated as userId 1 with role "COORDINATOR"
    When the coordinator sends a ChangePasswordCommand with:
      | field       | value          |
      | userId      | 50             |
      | newPassword | TempP@ss2026!  |
    And currentPassword is not provided
    Then the system skips current password verification
    And hashes the new password via PasswordEncoderPort
    And updates the target User's passwordHash
    And revokes all refresh tokens for userId 50
    And responds with HTTP 200
    And emits a "PasswordChanged" event to BC-05 Audit with changeType "COORDINATOR" and severity HIGH

  # --- Error and Alternative Flows ---

  @requirement:HU-28 @priority:high
  Scenario: Self-change rejected with incorrect current password
    Given the user is authenticated as userId 50
    When the user sends a ChangePasswordCommand with currentPassword "WrongOldPass"
    Then the system responds with HTTP 400
    And returns the message: "Current password is incorrect"

  @requirement:HU-28 @driver:QA-1 @priority:high
  Scenario: Non-coordinator cannot change another user's password
    Given the user is authenticated as userId 50 with role "STUDENT"
    When the user sends a ChangePasswordCommand with userId 99
    Then the system responds with HTTP 403
    And returns the message: "You can only change your own password"
    And emits a "RBACViolationDetected" event to BC-05 Audit with severity HIGH

  @requirement:HU-28 @priority:high
  Scenario: Password change rejected with empty new password
    When the user sends a ChangePasswordCommand with newPassword empty
    Then the system responds with HTTP 400
    And returns a validation error: "New password is required"

  @requirement:HU-28 @priority:medium
  Scenario: Password change rejected with weak new password
    When the user sends a ChangePasswordCommand with newPassword "123"
    Then the system responds with HTTP 400
    And returns a validation error: "Password must be at least 8 characters"

  @requirement:HU-28 @driver:QA-1 @priority:high
  Scenario: Password change rejected for unauthenticated user
    Given no user is authenticated
    When a ChangePasswordCommand is sent
    Then the system responds with HTTP 401
