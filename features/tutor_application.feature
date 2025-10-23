

Feature: Tutor Application
  As a learner
  So that I can access tutor privileges like reserving a room and booking sessions
  I want to apply to become a tutor

  Scenario: Learner goes to the settings page
    Given I am logged in as a learner
    When I visit the Settings page
    Then I should see the "Apply to be a tutor" button

  Scenario: Learner goes to the application page
    Given I am logged in as a learner
    When I visit the Settings page
    And I click the "Apply to be a tutor" button
    Then I should see the tutor application page

  Scenario: Learner submits an application
    Given I am logged in as a learner
    And I visit the tutor application page
    When I submit my reason
    Then I should see a message that my application was submitted

  Scenario: Learner who is already a tutor
    Given I am logged in as a tutor
    When I visit the Settings page
    Then I should not see the "Apply to be a tutor" button
    And I should not see the "Pending review" message

  Scenario: Learner with a pending application
    Given I am logged in as a learner
    And I have a pending application
    When I visit the Settings page
    Then I should not see the "Apply to be a tutor" button
    And I should see "Pending review"
  
  Scenario: Admin approves a learner’s application
    Given an admin has approved my application
    When I log in as a learner
    Then I should see tutor options available on my dashboard