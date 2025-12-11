Feature: Show remaining seats for tutoring sessions
  As a signed-in learner
  I want to see how many seats are left in each session
  So that I can choose sessions that are not already full

  Background:
    Given I am a signed-in learner

  @seats_remaining
  Scenario: Seats remaining shown in search results and on session details
    And the subject "Linear Algebra" exists
    And the following tutors and sessions exist:
      | tutor_name  | subject        | session_start          | session_end            | capacity |
      | Alice Wong  | Linear Algebra | 2035-01-10T10:00:00Z   | 2035-01-10T11:00:00Z   | 3        |
    And I am on the "Find a Session" page
    When I choose subject "Linear Algebra"
    And I enter start "2035-01-10T09:00:00Z" and end "2035-01-10T12:00:00Z"
    And I run the search
    Then I should see "Seats remaining:" in the search results
    And I should see "3 / 3" in the search results

    When I select the session for tutor "Alice Wong" from "2035-01-10T10:00:00Z" to "2035-01-10T11:00:00Z"
    And I confirm the booking
    Then I should see "Seats remaining:" on the session details page
    And I should see "2 of 3 seats available" on the session details page
