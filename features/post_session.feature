Feature: Tutor posts a new session
  As a signed in and verified tutor,
  I want to post a session,
  So that I can allow others to sign up

  Background:
    Given I am a signed in user and tutor
	And the following session exists:
	| start_time       | end_time         | capacity| subject|
	| 2026-10-15T11:00Z| 2026-10-15T11:59Z| 1       | Math   |

  @happy
  Scenario: Tutor posts an session with valid information
    And I am on new session page,
    When I fill in "Start Time" with "2026-10-15T10:00Z"
    And I fill in "End Time" with "2026-10-15T10:59Z"
    And I fill in "Capacity" with "1"
    And I fill in "Subject" with "Math"
    And I press "Create new session"
    Then I am on the session's show page
    And I should see the message "Session successfully created"
    And I should see the session on the page

  @unknown
  Scenario: Tutor creates a post with missing/unknown information
    And I am on new session page,
    When I fill in "Start Time" with "2026-10-15T8:00Z"
    And I fill in "End Time" with "2026-10-15T9:00Z"
    And I fill in "Subject" with "Math"
    And I press "Create new session"
    Then I should see an error message saying it is missing information

  @overlap
  Scenario: Tutor creates a post overlapping with existing session
    And I am on new session page,
    When I fill in "Start Time" with "2026-10-15T8:00Z"
    And I fill in "End Time" with "2026-10-15T9:00Z"
    And I fill in "Capacity" with "1"
    And I fill in "Subject" with "Math"
    And I press "Create new session"
    And this session overlaps with existing session
	Then I should see an error message that there is a time conflict

  @delete
  Scenario: Tutor wants to delete existing session
    And I am on the session's show page
    When I press on "Delete"
    Then I should be on tutor's session's page
    And I should see the message that session is deleted
