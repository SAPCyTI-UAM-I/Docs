# language: en
@module:identity @bounded-context:BC-06 @subdomain:generic
Feature: User authentication and session management
  As a system user (Coordinator, Professor, Student, Assistant, or Speaker)
  I want to log in using my email and password
  So that I can access the main screen with the options corresponding to my user type

  Reference: HU-01 | Schema: identity-access.schema.json#/definitions/LoginCommand
  Bounded Context: BC-06 Identity & Access (Generic Sub-Domain)
  Upstream dependencies: BC-04 Program Configuration (graduateProgramId for JWT claims)
  Downstream consumers: BC-02 Academic Management (R1), BC-01 Enrollment (R7), BC-05 Audit (R3)

  Background:
    Given a registered user exists with the following data:
      | field        | value                    |
      | email        | profesor@uam.mx          |
      | role         | PROFESSOR                |
      | active       | true                     |
      | passwordHash | (BCrypt hash of "S3cur3!Pass") |
    And the user is associated with graduate program id 1 "PCyTI" via BC-04

  # --- Happy Path ---

  @requirement:HU-01 @driver:QA-1 @priority:high
  Scenario: Successful login with valid credentials
    When the user sends a LoginCommand with:
      | field      | value            |
      | email      | profesor@uam.mx  |
      | password   | S3cur3!Pass      |
      | rememberMe | false            |
    Then the system validates the credentials against the stored BCrypt hash
    And responds with HTTP 200
    And returns an AuthResponse containing:
      | field        | value     |
      | role         | PROFESSOR |
      | expiresIn    | 900       |
    And the accessToken is a JWT signed with RSA-256 containing claims: sub, role, graduateProgramId, iat, exp
    And the refreshToken is an opaque token with TTL of 7 days
    And the system emits a "LoginSucceeded" event to BC-05 Audit with severity HIGH

  @requirement:HU-01 @priority:high
  Scenario: Successful login with "Remember me" enabled
    When the user sends a LoginCommand with rememberMe set to true
    Then the system issues a refreshToken with TTL of 30 days instead of 7 days
    And the deviceInfo is stored alongside the refresh token hash for session tracking

  @requirement:HU-01 @priority:high
  Scenario: Role-based menu rendering after login
    Given the user logs in successfully with role "COORDINATOR"
    Then the system includes the role "COORDINATOR" in the JWT claims
    And the SPA renders only the menu options permitted for COORDINATOR

  @requirement:HU-01 @priority:high
  Scenario: Successful token refresh
    Given the user has a valid, non-revoked refresh token
    When the user sends a RefreshTokenCommand with the refresh token
    Then the system validates the token hash and expiration
    And responds with HTTP 200 and a new AuthResponse with a fresh accessToken
    And the previous access token is no longer valid after expiration

  @requirement:HU-01 @priority:high
  Scenario: Successful logout
    Given the user has an active session with a refresh token
    When the user sends a LogoutCommand with the refresh token
    Then the system revokes the refresh token by setting revoked to true
    And responds with HTTP 200
    And the revoked token cannot be used for refresh

  # --- Error and Alternative Flows ---

  @requirement:HU-01 @driver:QA-2 @priority:high
  Scenario: Login rejected with invalid password
    When the user sends a LoginCommand with email "profesor@uam.mx" and password "WrongPass"
    Then the system responds with HTTP 401
    And returns a generic error message: "Invalid credentials"
    And does NOT reveal whether the email exists
    And emits a "LoginFailed" event to BC-05 Audit with severity HIGH

  @requirement:HU-01 @driver:QA-2 @priority:high
  Scenario: Login rejected with non-existent email
    When the user sends a LoginCommand with email "unknown@uam.mx"
    Then the system responds with HTTP 401
    And returns the same generic message: "Invalid credentials"
    And emits a "LoginFailed" event to BC-05 Audit with severity HIGH

  @requirement:HU-01 @priority:high
  Scenario: Login rejected for inactive account
    Given the user account has active set to false
    When the user sends a LoginCommand with valid email and password
    Then the system responds with HTTP 401
    And returns the generic message: "Invalid credentials"

  @requirement:HU-01 @driver:QA-2 @priority:high
  Scenario: Login rejected with empty fields
    When the user sends a LoginCommand with email or password empty
    Then the system responds with HTTP 400
    And returns validation messages for the missing fields

  @requirement:HU-01 @priority:medium
  Scenario: Token refresh rejected with expired token
    Given the user has a refresh token that has expired
    When the user sends a RefreshTokenCommand with the expired token
    Then the system responds with HTTP 401
    And the user must re-authenticate via login

  @requirement:HU-01 @priority:medium
  Scenario: Token refresh rejected with revoked token
    Given the user has a refresh token that was revoked via logout
    When the user sends a RefreshTokenCommand with the revoked token
    Then the system responds with HTTP 401

  @requirement:HU-01 @driver:QA-2 @priority:high
  Scenario: Protection against JWT manipulation
    When a request arrives with a tampered JWT (invalid RSA signature)
    Then the JwtAuthenticationFilter rejects the request with HTTP 401
    And does NOT populate the Spring SecurityContext
