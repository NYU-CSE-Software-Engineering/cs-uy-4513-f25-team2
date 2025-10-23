Feature: Learner submits feedback
  As a Learner
  I want to submit feedback about my tutoring session
  So that I can share my experience with my tutor to help others
  
  Background:
    Given I am a signed-in learner
    And I have completed a tutoring session with "Andrew"

  Scenario: Submit valid feedback (happy path)
    Given I am on the feedback page for "Andrew"
    When I select a rating of "5"
    And I fill in "Comment" with "Great tutor!"
    And I press "Submit Feedback"
    Then I should see "Thank you for your feedback!"

  Scenario: Submit feedback without rating
    Given I am on the feedback page for "Andrew"
    When I fill in "Comment" with "Good session"
    And I press "Submit Feedback"
    Then I should see "Rating can't be blank"

  Scenario: Tutor views feedback index
    When I sign in as tutor "Andrew"
    And I visit the feedbacks index
    Then I should see feedback from the learner for the session
