Feature: Search available slots by subject/time range and book one
  As a signed-in learner
  I want to search all tutors' availability by subject and time range
  So that I can book a convenient online session

  @happy
  Scenario: Successful booking from cross-tutor search
    Given I am a signed-in user
    And the subject "Calculus" exists
    And the following tutors and slots exist:
      | tutor_name      | subject  | slot_start             | slot_end               | capacity |
      | Emily Johnson   | Calculus | 2026-03-10T10:00:00Z   | 2026-03-10T11:00:00Z   | 3        |
      | Michael Chen    | Calculus | 2026-03-10T14:00:00Z   | 2026-03-10T15:00:00Z   | 2        |
    And I am learner "Mia Patel" with no upcoming sessions
    And I am on the "Find a Session" page
    When I choose subject "Calculus"
    And I enter start "2026-03-10T08:00:00Z" and end "2026-03-10T20:00:00Z"
    And I run the search
    And I select the slot for tutor "Emily Johnson" from "2026-03-10T10:00:00Z" to "2026-03-10T11:00:00Z"
    And I confirm the booking
    Then I should see "Booking confirmed"
    And I should see "Meeting link"

  @duplicate
  Scenario: Prevent double-booking of the same slot
    Given I am a signed-in user
    And the subject "Calculus" exists
    And the following tutors and slots exist:
      | tutor_name      | subject  | slot_start             | slot_end               | capacity |
      | Emily Johnson   | Calculus | 2026-03-10T10:00:00Z   | 2026-03-10T11:00:00Z   | 3        |
    And I am learner "Mia Patel" who has an existing session with tutor "Emily Johnson" from "2026-03-10T10:00:00Z" to "2026-03-10T11:00:00Z" in "Calculus"
    And I am on the "Find a Session" page
    When I choose subject "Calculus"
    And I enter start "2026-03-10T08:00:00Z" and end "2026-03-10T20:00:00Z"
    And I run the search
    And I select the slot for tutor "Emily Johnson" from "2026-03-10T10:00:00Z" to "2026-03-10T11:00:00Z"
    And I confirm the booking
    Then I should see "You are already booked for that slot"

  @capacity
  Scenario: Reject booking when slot is full
    Given I am a signed-in user
    And the subject "Calculus" exists
    And the following tutors and slots exist:
      | tutor_name      | subject  | slot_start             | slot_end               | capacity |
      | Emily Johnson   | Calculus | 2026-03-10T11:00:00Z   | 2026-03-10T12:00:00Z   | 0        |
    And I am learner "Mia Patel" with no upcoming sessions
    And I am on the "Find a Session" page
    When I choose subject "Calculus"
    And I enter start "2026-03-10T08:00:00Z" and end "2026-03-10T20:00:00Z"
    And I run the search
    And I select the slot for tutor "Emily Johnson" from "2026-03-10T11:00:00Z" to "2026-03-10T12:00:00Z"
    And I confirm the booking
    Then I should see "This slot is full"

  @conflict
  Scenario: Reject booking when slot overlaps another upcoming session (different tutors)
    Given I am a signed-in user
    And the subject "Calculus" exists
    And the following tutors and slots exist:
      | tutor_name      | subject  | slot_start             | slot_end               | capacity |
      | Emily Johnson   | Calculus | 2026-03-10T10:30:00Z   | 2026-03-10T11:30:00Z   | 2        |
      | Daniel Kim      | Calculus | 2026-03-10T10:15:00Z   | 2026-03-10T10:45:00Z   | 3        |
    And I am learner "Mia Patel" who has an existing session with tutor "Daniel Kim" from "2026-03-10T10:15:00Z" to "2026-03-10T10:45:00Z" in "Calculus"
    And I am on the "Find a Session" page
    When I choose subject "Calculus"
    And I enter start "2026-03-10T08:00:00Z" and end "2026-03-10T20:00:00Z"
    And I run the search
    And I select the slot for tutor "Emily Johnson" from "2026-03-10T10:30:00Z" to "2026-03-10T11:30:00Z"
    And I confirm the booking
    Then I should see "This slot conflicts with another session"