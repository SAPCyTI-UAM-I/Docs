# language: en
@module:enrollment @bounded-context:BC-01 @subdomain:core
Feature: Enrollment form generation and finalization
  As a Coordinator or Graduate Program Assistant
  I want to select a student whose academic workload has been approved to generate their enrollment form
  So that I can obtain the official PDF document that formalizes the course registration with School Systems

  Reference: HU-09, CON-3 | Schema: enrollment.schema.json#/definitions/FinalizeEnrollmentCommand, EnrollmentFormPDF, SchoolSystemsExport
  Bounded Context: BC-01 Enrollment (Core Domain)
  Upstream dependencies: BC-02 Academic Management (student data), BC-03 Academic Offering (UEA data), BC-04 Program Configuration (program data)
  External integrations: R12 — SchoolSystemsExportAdapter (TXT/XLSX), PdfGeneratorAdapter (PDF)

  Background:
    Given a graduate program "PCyTI" with id 1 exists according to BC-04 Program Configuration
    And the term "25P" with id 100 according to BC-03 Academic Offering
    And a student exists with the following data according to BC-02 Academic Management:
      | field          | value                                   |
      | studentId      | 50                                      |
      | enrollmentId   | 2123803361                              |
      | name           | Valencia Franco Paulina                 |
      | level          | MAESTRIA                                |
      | degree         | Information Sciences and Technologies   |
      | division       | CBI                                     |
      | nationality    | Mexican                                 |
    And an Enrollment with id 300 exists for student 50 with status "APPROVED_BY_ADVISOR"
    And the Enrollment contains the approved UEAs:
      | ueaCode | ueaName                    | credits | group |
      | 2156053 | Software Engineering I     | 9       | CP33  |
      | 2156054 | Advanced Databases         | 9       | CP34  |
    And the coordinator has logged in with role "COORDINATOR" according to BC-06 Identity & Access

  # --- Main Flow: Finalization ---

  @requirement:HU-09 @priority:high
  Scenario: Display of students pending finalization
    When the coordinator accesses "Print enrollment form" from the "ENROLLMENT PROCESS" menu
    Then the system displays the table "Select a student to print their enrollment"
    And shows "Valencia Franco Paulina" with a "Print" button
    And only shows students whose Enrollment has status "APPROVED_BY_ADVISOR"

  @requirement:HU-09 @priority:high
  Scenario: Successful PDF enrollment form generation
    Given student "Valencia Franco Paulina" appears in the pending list
    When the coordinator presses the "Print" button
    Then the system generates a PDF document on-demand via PdfGeneratorAdapter
    And the document is titled "UEA REQUEST - GROUP FOR GRADUATE STUDIES"
    And the PDF is not persisted in the database — it is generated each time it is requested

  @requirement:HU-09 @priority:high
  Scenario: Validation of complete data in the PDF document
    Given the PDF has been generated for the student with enrollment ID "2123803361"
    Then the document correctly contains:
      | field         | value                                    |
      | Name          | Valencia Franco Paulina                  |
      | Enrollment ID | 2123803361                               |
      | Program       | INFORMATION SCIENCES AND TECHNOLOGIES    |
      | Term          | 25P                                      |
      | Division      | CBI                                      |
      | Level         | MAESTRIA                                 |
    And includes the UEA table with Code, Credits, and Group
    And marks with "X" the checkboxes corresponding to Division "CBI" and Level "MAESTRIA"
    And presents spaces for the signature of the "APPLICANT" and "SCHOOL SYSTEMS COORDINATION"

  @requirement:HU-09 @priority:high
  Scenario: Enrollment finalization by the coordinator
    Given the coordinator has verified the student's PDF
    When they execute the finalization action
    Then the Enrollment with id 300 transitions to status "FINALIZED"
    And the finalization date is recorded in the "finalizationDate" field
    And the system emits the "EnrollmentFinalized" event to BC-05 Audit
    And the student appears in the "Students with printed schedule" section

  @requirement:HU-09 @priority:medium
  Scenario: Re-printing of the form for an already finalized student
    Given student "Valencia Franco Paulina" has an Enrollment with status "FINALIZED"
    When the coordinator views the "Students with printed schedule" section
    And presses the "Print" button next to the student's name
    Then the system generates the PDF on-demand again
    And the Enrollment status does not change

  # --- Export to School Systems (CON-3) ---

  @requirement:HU-09 @driver:CON-3 @priority:high
  Scenario: Successful export in TXT format for School Systems
    Given finalized enrollments exist for term "25P"
    When the coordinator requests the export in "TXT" format
    Then the system generates a TXT file via SchoolSystemsExportAdapter
    And each record contains: enrollment ID, ueaCode, group, term, program, and finalizationDate
    And the format complies with the School Control office specification (Lic. César Hernández)
    And the domain model is NOT shaped by the structure of the exported file

  @requirement:HU-09 @driver:CON-3 @priority:high
  Scenario: Successful export in XLSX format for School Systems
    Given finalized enrollments exist for term "25P"
    When the coordinator requests the export in "XLSX" format
    Then the system generates an XLSX file via SchoolSystemsExportAdapter
    And the spreadsheet contains the columns required by School Control
    And the Anti-Corruption Layer translates from the domain model to the institutional format

  # --- Error Flows ---

  @requirement:HU-09 @driver:QA-1 @priority:high
  Scenario: Finalization denied for unauthorized role
    Given a user has logged in with role "STUDENT"
    When they attempt to finalize Enrollment with id 300
    Then the system denies the action with HTTP code 403
    And emits the "RBACViolationDetected" event to BC-05 Audit

  @requirement:HU-09 @priority:medium
  Scenario: Finalization attempt with incorrect state
    Given Enrollment with id 300 has status "SELECTION_COMPLETED"
    When the coordinator attempts to finalize the enrollment
    Then the system rejects the action with HTTP code 409
    And displays the message: "The enrollment must be approved by the advisor before it can be finalized"

  @requirement:HU-09 @driver:CON-5 @priority:high
  Scenario: Final decision by the graduate program commission
    Given Enrollment with id 300 has status "APPROVED_BY_ADVISOR"
    And the graduate program commission has decided to finalize the enrollment despite an administrative observation
    When the coordinator executes the finalization
    Then the system allows the action without enforcing rigid institutional rules
    And the final decision is recorded in BC-05 Audit with the coordinator as the actor
