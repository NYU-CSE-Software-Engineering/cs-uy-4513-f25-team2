Feature: Admin approves or rejects tutor applications
    As an admin
    I want to approve or reject a submitted tutor application
    So that I can manage the active list of tutors

    Background:
        Given I am a signed-in admin
        And the following learners exist:
            | email                 | password    | first_name | last_name |
            | janedoe@example.com   | password123 | Jane       | Doe       |
            | johnsmith@example.com | password123 | John       | Smith     |
        
    @happy
    Scenario: Approve a tutor application
        Given the following tutor applications exist:
            | learner    | reason                                                |
            | Jane Doe   | I have 3 years prior experience of tutoring Calculus. |
            | John Smith | I really enjoy tutoring!                              |
        And I am on the "Pending Tutor Applications" page
        When I select "Approve" from the dropdown for "Jane Doe"
        And I press "Confirm" for "Jane Doe"
        Then the application status for "Jane Doe" should be "Approved"
        And "Jane Doe" should be a tutor
        And I should see "Application approved."
        And I should not see a tutor application for "Jane Doe"

    @reject
    Scenario: Reject a tutor application
        Given the following tutor applications exist:
            | learner    | reason                                                |
            | Jane Doe   | I have 3 years prior experience of tutoring Calculus. |
            | John Smith | I really enjoy tutoring!                              |
        And I am on the "Pending Tutor Applications" page
        When I select "Reject" from the dropdown for "Jane Doe"
        And I press "Confirm" for "Jane Doe"
        Then the application status for "Jane Doe" should be "Rejected"
        And "Jane Doe" should not be a tutor
        And I should see "Application rejected."
        And I should not see a tutor application for "Jane Doe"

    @no_selection
    Scenario: No approval option selected
        Given the following tutor applications exist:
            | learner    | reason                                                |
            | Jane Doe   | I have 3 years prior experience of tutoring Calculus. |
            | John Smith | I really enjoy tutoring!                              |
        And I am on the "Pending Tutor Applications" page
        And I press "Confirm" for "Jane Doe"
        Then I should see "No option selected."
        And I should see a tutor application for "Jane Doe"

    @no_applications
    Scenario: No pending applications
        Given I am on the "Pending Tutor Applications" page
        Then I should see "There are no pending applications to review."
        And I should not see any tutor applications
