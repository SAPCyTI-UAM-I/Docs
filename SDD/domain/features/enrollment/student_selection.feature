# language: en
@module:enrollment @bounded-context:BC-01 @subdomain:core
Feature: Course selection by the student
  As a graduate program Student
  I want to access the enrollment module to select the courses I will take during the term
  So that I can register my academic workload and progress in my program of studies

  Reference: HU-07 | Schema: enrollment.schema.json#/definitions/SelectCoursesCommand
  Bounded Context: BC-01 Enrollment (Core Domain)
  Upstream dependencies: BC-02 Academic Management (studentId), BC-03 Academic Offering (termId, uEAGroupId), BC-04 Program Configuration (graduateProgramId)

  Background:
    Given a graduate program "PCyTI" with id 1 exists according to BC-04 Program Configuration
    And the term "25P" with id 100 has status "IN_ENROLLMENT" according to BC-03 Academic Offering
    And the academic offer for term "25P" contains the following UEA groups:
      | uEAGroupId | ueaCode | ueaName                    | group | quota | availableQuota | professor                         | schedule                          |
      | 201        | 2156053 | Software Engineering I     | CP33  | 25    | 10             | Cervantes Maceda Humberto Gustavo | THURSDAY: 09:30 AM - 11:00 AM     |
      | 202        | 2156054 | Advanced Databases         | CP34  | 20    | 5              | García López María Elena          | TUESDAY: 11:00 AM - 12:30 PM      |
      | 203        | 2156055 | Networks and Security      | CP35  | 15    | 0              | Pérez Sánchez Juan Carlos         | MONDAY: 02:00 PM - 03:30 PM       |
    And a student with enrollment ID "2123803361" and studentId 50 with status ACTIVE exists according to BC-02 Academic Management
    And the student has advisor with professorId 10 assigned according to BC-02 Academic Management
    And the student has logged in with role "STUDENT" and associated userId according to BC-06 Identity & Access

  # --- Main Flow (Happy Path) ---

  @requirement:HU-07 @driver:QA-1 @priority:high
  Scenario: Successful access to the enrollment module
    When the student selects the "Enrollment" option in the "STUDENT" menu
    Then the system displays the enrollment screen
    And shows the student's personal data: name, level, degree program, division, and nationality
    And asks the student to verify that the information is correct

  @requirement:HU-07 @driver:QA-1 @priority:high
  Scenario: Display of available UEA offerings
    Given the student is on the enrollment screen
    When they view the "Selected UEAs" section
    Then the system displays a table with columns: Selection, Code, Name, Group, Schedule, and Professor
    And each schedule specifies the days and time intervals
    And only groups with availableQuota greater than 0 are shown

  @requirement:HU-07 @priority:high
  Scenario: Automatic pre-selection of UEAs based on academic plan
    Given the student loads the UEA list
    When there are mandatory or suggested courses according to their academic progress
    Then the system shows them automatically selected via a checked checkbox
    And each pre-selected UEASelection has the "preselected" field set to true
    And displays the informational message: "Some UEAs appear automatically selected; you can still edit them."

  @requirement:HU-07 @priority:high
  Scenario: Manual selection of UEAs by the student
    Given the student reviews the list of available UEAs
    When the student checks the checkbox for UEA "2156053 - Software Engineering I" group "CP33"
    And checks the checkbox for UEA "2156054 - Advanced Databases" group "CP34"
    Then the system visually updates the list of UEAs that will be part of their enrollment
    And the total number of selected UEAs is 2

  @requirement:HU-07 @priority:high
  Scenario: Deselection of a previously checked UEA
    Given the student has selected UEA "2156053 - Software Engineering I"
    When they uncheck the checkbox for that UEA
    Then the system removes it from the selection list
    And the "preselected" field does not prevent deselection

  @requirement:HU-07 @priority:high
  Scenario: Selection confirmation and state transition
    Given the student has selected UEAs with group ids [201, 202]
    When they confirm their selection by pressing "Save selection"
    Then the system creates an Enrollment with status "SELECTION_COMPLETED"
    And registers UEASelections with uEAGroupIds [201, 202]
    And each UEASelection has "approvedByAdvisor" set to false
    And the system emits the "CoursesSelected" event to BC-05 Audit

  # --- Alternative and Error Flows ---

  @requirement:HU-07 @driver:QA-3 @priority:high
  Scenario: Validation of maximum UEAs per program limit
    Given the program "PCyTI" has a maximum of 3 UEAs per term configured in BC-04
    And the student has already selected 3 UEAs
    When they attempt to select a fourth UEA
    Then the system displays the error message: "You have reached the maximum number of UEAs allowed for this term"
    And does not allow the selection to be added

  @requirement:HU-07 @driver:QA-1 @priority:high
  Scenario: Access denied for incorrect role
    Given a user has logged in with role "PROFESSOR"
    When they attempt to access the student enrollment module
    Then the system denies access with HTTP code 403
    And emits the "RBACViolationDetected" event to BC-05 Audit

  @requirement:HU-07 @priority:medium
  Scenario: Enrollment attempt with exhausted quota
    Given the student views UEA "2156055 - Networks and Security" group "CP35"
    And that group has availableQuota equal to 0
    When they attempt to check the checkbox for that UEA
    Then the system displays the message: "No quota available for this group"
    And the checkbox remains disabled

  @requirement:HU-07 @priority:medium
  Scenario: Enrollment attempt outside the enrollment period
    Given the term "25P" has status "PLANNING" according to BC-03
    When the student attempts to access the enrollment module
    Then the system displays the message: "The enrollment period is not active for this term"
    And does not allow UEA selection

  @requirement:HU-07 @driver:QA-2 @priority:high
  Scenario: Protection against group ID manipulation
    Given the student sends a request with a non-existent uEAGroupId 999
    When the system processes the SelectCourses command
    Then it rejects the request with HTTP code 400
    And logs the attempt in BC-05 Audit with severity HIGH
