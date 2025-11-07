@wip
Feature: Learner submits feedback
  As a Learner
  I want to submit feedback about my tutoring session
  So that I can share my experience with my tutor to help others

  Background:
    Given I am a logged-in learner
    And I have completed a tutoring session with "tutor"

  Scenario: Submit valid feedback (happy path)
    Given I am on the feedback page for "tutor"
    When I select a rating of "5"
    And I fill in "Comment" with "Great tutor!"
    And I press "Submit Feedback"
    Then I should see "Thank you for your feedback!"

  Scenario: Submit feedback without rating
    Given I am on the feedback page for "tutor"
    When I fill in "Comment" with "Good session"
    And I press "Submit Feedback"
    Then I should see "Rating can't be blank"


Scenario: Learner marked present can leave feedback
  Given I am a logged-in learner
  And I have a completed session with "tutor" where I was marked present
  When I navigate to the feedback form for "tutor"
  And I select a rating of "5"
  And I fill in "Comment" with "Very helpful!"
  And I press "Submit Feedback"
  Then I should see "Thank you for your feedback!"

Scenario: Learner not marked present cannot leave feedback
  Given I am a logged-in learner
  And I have a completed session with "tutor" where I was marked absent
  When I visit the session page for "tutor"
  Then I should not see "Leave Feedback"
  And I should see "You were not marked present for this session"