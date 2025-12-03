Feature: Admin revokes Tutor Privilege
  As an admin
  So that I can remove tutor privileges from learners
  I want to revoke a tutor's privilege

  Scenario: Admin revokes tutor privilege (happy path)
    Given I am logged in as an admin
    And a learner "learner@example.com" exists
    And the learner "learner@example.com" is a tutor
    When I visit the tutors management page
    And I revoke tutor privilege for "learner@example.com"
    Then I should see a message that the tutor privilege was revoked
    And the learner "learner@example.com" should no longer be a tutor

