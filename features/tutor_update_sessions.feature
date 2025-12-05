Feature: Tutor updates session link
    As a Tutor
    I want to update the meeting link for my tutor sessions
    so that I can fix mistakes on my session

  Background:
    Given I am a signed-in tutor
    And the subject "Math" exists
    And the subject "Biology" exists

  @edit_happy
  Scenario: View upcoming booked sessions from the home page
    Given I am a signed-in tutor
    And the following session exists:
      | start_at             | end_at               | capacity | subject | status    |
      | 2026-10-15T10:00:00Z | 2026-10-15T10:59:00Z | 1        | Biology | scheduled |
      | 2026-10-11T10:00:00Z | 2026-10-11T10:59:00Z | 2        | Math    | completed |
    And I am on the home page
    When I click on "View My Sessions"
    Then I should be on the tutor upcoming sessions page
    And I should see "My Upcoming Sessions"
    And I click Edit for the upcoming session starting at "2026-10-15T10:00:00Z"
    Then I should see the edit session page
    And I should see "Biology"
    And I should see "Capacity: 1"
    And I should see "2026-10-15T10:00:00Z"
    When I enter the meeting link "https://zoom.example.us"
    And I make the update
    Then I should be on the tutor upcoming sessions page
    And I should see "https://zoom.example.us"

  @edit_no
  Scenario: View upcoming booked sessions from the home page
    Given I am a signed-in tutor
    And the following session exists:
      | start_at             | end_at               | capacity | subject | status    |
      | 2026-10-15T10:00:00Z | 2026-10-15T10:59:00Z | 1        | Biology | scheduled |
      | 2026-10-11T10:00:00Z | 2026-10-11T10:59:00Z | 2        | Math    | completed |
    And I am on the home page
    When I click on "View My Sessions"
    Then I should be on the tutor upcoming sessions page
    And I should see "My Upcoming Sessions"
    And I click Edit for the upcoming session starting at "2026-10-15T10:00:00Z"
    Then I should see the edit session page
    And I should see "Biology"
    And I should see "Capacity: 1"
    And I should see "2026-10-15T10:00:00Z"
    When I enter the meeting link "https://zoom.example.us"
    And I cancel the update
    Then I should be on the tutor upcoming sessions page
    And I should not see "https://zoom.example.us"
