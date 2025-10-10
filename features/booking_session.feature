Feature: Learner books a tutor’s posted availability slot
  As a learner
  I want to book a session from a tutor’s posted availability
  So that I can meet online at a convenient time

  Background:
    Given I am on the Tutor Catalog page

  @happy
  Scenario: Book a single open slot successfully (happy path)
    When I view tutor "Jane Doe"
    And I select an available slot starting at "2025-10-15T10:00Z"
    And I confirm the booking
    Then I should see "Booking confirmed"
    And I should see "Meeting link"

  @duplicate
  Scenario: Prevent double booking of the same slot
    When I view tutor "Jane Doe"
    And I select an available slot starting at "2025-10-15T10:00Z"
    And I confirm the booking
    And I confirm the booking
    Then I should see "You are already booked for that slot"

  @capacity
  Scenario: Reject when slot is full
    When I view tutor "Jane Doe"
    And I select an available slot starting at "2025-10-15T11:00Z"
    And I confirm the booking
    Then I should see "This slot is full"

  @conflict
  Scenario: Reject when slot overlaps another upcoming session
    When I view tutor "Jane Doe"
    And I select an available slot starting at "2025-10-15T10:30Z"
    And I confirm the booking
    Then I should see "This slot conflicts with another session"
