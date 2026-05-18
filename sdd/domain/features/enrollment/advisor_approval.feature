# language: en
@module:enrollment @bounded-context:BC-01 @subdomain:core
Feature: Enrollment approval by advisor
  As a Professor (Advisor)
  I want to access the list of my advised students and review the UEAs they have selected
  So that I can validate their academic workload is appropriate, make adjustments if necessary, and formally authorize their enrollment

  Reference: HU-08 | Schema: enrollment.schema.json#/definitions/ApproveEnrollmentCommand, RejectEnrollmentCommand
  Bounded Context: BC-01 Enrollment (Core Domain)
  Upstream dependencies: BC-02 Academic Management (studentId, advisorId), BC-03 Academic Offering (uEAGroupId, availableQuota), BC-06 Identity & Access (RBAC)

  Background:
    Given a graduate program "PCyTI" with id 1 exists according to BC-04 Program Configuration
    And the term "25P" with id 100 has status "IN_ENROLLMENT" according to BC-03 Academic Offering
    And a student "Valencia Franco Paulina" with enrollment ID "2123803361" and studentId 50 exists according to BC-02
    And the student has advisor with professorId 10 and name "Cervantes Maceda Humberto" assigned according to BC-02
    And the advisor has logged in with role "PROFESSOR" and associated userId according to BC-06 Identity & Access
    And an Enrollment with id 300 exists for student 50 in term "25P" with status "SELECTION_COMPLETED"
    And the Enrollment contains the following UEASelections:
      | uEAGroupId | ueaCode | ueaName                    | group | preselected | approvedByAdvisor |
      | 201        | 2156053 | Software Engineering I     | CP33  | false       | false             |
      | 202        | 2156054 | Advanced Databases         | CP34  | true        | false             |

  # --- Main Flow (Happy Path) ---

  @requirement:HU-08 @driver:QA-1 @priority:high
  Scenario: Display of advised students with pending enrollments
    When the advisor accesses the "Approve UEA Selection" option from the "ADVISED STUDENTS" menu
    Then the system displays the table "Select a student to view their selected UEAs"
    And shows the name "Valencia Franco Paulina" with a "View" button
    And only shows students whose Enrollment has status "SELECTION_COMPLETED"

  @requirement:HU-08 @priority:high
  Scenario: Detailed review of the student's selection
    Given the advisor selects student "Valencia Franco Paulina" from the list
    When they press the "View" button
    Then the system shows the "Student Data" screen with level, degree program, and division
    And presents the "Selected UEAs" table with schedules and professors
    And presents the "Select courses to enroll" section with additional available UEAs

  @requirement:HU-08 @priority:high
  Scenario: Modification of the academic workload by the advisor
    Given the advisor views the UEAs selected by the student
    When the advisor unchecks UEA "2156054 - Advanced Databases"
    And checks a new UEA "2156055 - Networks and Security" from the available courses section
    Then the system updates the final academic workload with uEAGroupIds [201, 203]

  @requirement:HU-08 @priority:high
  Scenario: Successful enrollment approval
    Given the advisor is satisfied with the UEA selection [201, 202]
    When they press the "Accept" button to approve the enrollment
    Then the Enrollment with id 300 transitions to status "APPROVED_BY_ADVISOR"
    And each approved UEASelection has "approvedByAdvisor" set to true
    And the system decrements the availableQuota of each approved UEAGroup via BC-03
    And the student appears in the "Students with accepted UEAs" section
    And the system emits the "EnrollmentApprovedByAdvisor" event to BC-05 Audit

  @requirement:HU-08 @priority:high
  Scenario: Enrollment rejection by the advisor
    Given the advisor is not satisfied with the student's selection
    When they press the "Reject" button with the reason "Excessive workload for the first term, reduce to 2 UEAs"
    Then the Enrollment with id 300 returns to status "PENDING_SELECTION"
    And the system emits the "EnrollmentRejectedByAdvisor" event to BC-05 Audit
    And the student can modify their selection again (HU-07)

  @requirement:HU-08 @priority:high
  Scenario: Query of already approved students
    Given the advisor is in the approval module
    When they view the "Students with accepted UEAs" section
    Then the system shows the list of students whose enrollment has been authorized
    And allows viewing details by pressing the "View" button

  # --- Alternative and Error Flows ---

  @requirement:HU-08 @driver:QA-1 @priority:high
  Scenario: Approval denied for non-assigned advisor
    Given a professor with professorId 99 is NOT the assigned advisor for student 50
    And has logged in with role "PROFESSOR"
    When they attempt to approve Enrollment with id 300
    Then the system denies the action with HTTP code 403
    And displays the message: "You do not have permission to approve this enrollment. Only the assigned advisor can do so."
    And emits the "RBACViolationDetected" event to BC-05 Audit

  @requirement:HU-08 @driver:QA-2 @priority:high
  Scenario: Rejection denied without valid reason
    Given the advisor attempts to reject Enrollment with id 300
    When they send the RejectEnrollment command with an empty reason
    Then the system rejects the request with HTTP code 400
    And displays the message: "Rejection reason is required (minimum 10 characters)"

  @requirement:HU-08 @priority:medium
  Scenario: Schedule conflict validation when modifying selection
    Given the advisor attempts to add a UEA whose schedule conflicts with another already selected
    When they check the UEA with the schedule conflict
    Then the system displays a warning: "Schedule conflict detected with UEA [name]"
    And allows the advisor to confirm or discard the addition

  @requirement:HU-08 @priority:medium
  Scenario: Approval attempt with Enrollment in incorrect state
    Given Enrollment with id 300 has status "PENDING_SELECTION"
    When the advisor attempts to approve the enrollment
    Then the system rejects the action with HTTP code 409
    And displays the message: "The student has not yet completed their UEA selection"
