# language: en
@module:identity @bounded-context:BC-06 @subdomain:generic
Feature: Password recovery via email
  As a registered user who has forgotten their password
  I want to request a password reset link via email
  So that I can regain access to the system

  Reference: HU-02 | Schema: identity-access.schema.json#/definitions/ForgotPasswordCommand, ResetPasswordCommand
  Bounded Context: BC-06 Identity & Access (Generic Sub-Domain)
  Upstream dependencies: BC-04 Program Configuration (graduateProgramId context)
  Infrastructure: EmailPort (SMTP via Spring Mail + Thymeleaf templates), SecureTokenGeneratorPort (SecureRandom)

  Background:
    Given a registered user exists with email "alumno@uam.mx", role "STUDENT", and active true
    And the SMTP server is configured and operational

  # --- Happy Path ---

  @requirement:HU-02 @driver:QA-2 @priority:high
  Scenario: Successful password reset request with registered email
    When the user sends a ForgotPasswordCommand with email "alumno@uam.mx"
    Then the system generates a cryptographically secure token via SecureTokenGeneratorPort
    And stores the SHA-256 hash of the token as a PasswordResetToken with 30 minute TTL
    And sends a password recovery email via EmailPort with the plaintext token link
    And responds with HTTP 200
    And returns the message: "If an account with that email exists, a recovery email has been sent"
    And emits a "PasswordResetRequested" event to BC-05 Audit with severity HIGH

  @requirement:HU-02 @driver:QA-2 @priority:high
  Scenario: Password reset request with unregistered email (no enumeration)
    When the user sends a ForgotPasswordCommand with email "nonexistent@uam.mx"
    Then the system does NOT generate any token
    And does NOT send any email
    And responds with HTTP 200
    And returns the exact same message: "If an account with that email exists, a recovery email has been sent"

  @requirement:HU-02 @priority:high
  Scenario: Successful password reset with valid token
    Given the user has received a password reset email with a valid token
    When the user sends a ResetPasswordCommand with:
      | field       | value          |
      | token       | (valid token)  |
      | newPassword | NewS3cur3!Pass |
    Then the system validates the token hash, expiration, and used flag
    And hashes the new password via PasswordEncoderPort (BCrypt)
    And updates the User's passwordHash
    And marks the PasswordResetToken as used
    And revokes all existing refresh tokens for this user
    And responds with HTTP 200
    And emits a "PasswordChanged" event to BC-05 Audit with changeType "RESET" and severity HIGH

  # --- Error and Alternative Flows ---

  @requirement:HU-02 @priority:high
  Scenario: Password reset rejected with expired token
    Given a PasswordResetToken was created more than 30 minutes ago
    When the user sends a ResetPasswordCommand with the expired token
    Then the system responds with HTTP 400
    And returns the message: "The reset token has expired. Please request a new one"

  @requirement:HU-02 @priority:high
  Scenario: Password reset rejected with already-used token
    Given a PasswordResetToken has already been used
    When the user sends a ResetPasswordCommand with the used token
    Then the system responds with HTTP 400
    And returns the message: "This reset token has already been used"

  @requirement:HU-02 @priority:high
  Scenario: Password reset rejected with invalid token
    When the user sends a ResetPasswordCommand with a token that does not match any stored hash
    Then the system responds with HTTP 400
    And returns the message: "Invalid reset token"

  @requirement:HU-02 @driver:QA-2 @priority:high
  Scenario: Forgot password rejected with invalid email format
    When the user sends a ForgotPasswordCommand with email "not_an_email"
    Then the system responds with HTTP 400
    And returns a validation error for the email field

  @requirement:HU-02 @priority:high
  Scenario: Forgot password rejected with empty email
    When the user sends a ForgotPasswordCommand with email empty
    Then the system responds with HTTP 400
    And returns a validation error: "Email is required"

  @requirement:HU-02 @priority:medium
  Scenario: New reset request invalidates previous token
    Given the user already has an active PasswordResetToken
    When the user sends a new ForgotPasswordCommand with the same email
    Then the system replaces the previous token with a new one
    And the old token can no longer be used for reset
