Feature: Tutor posts a new session
  As a signed in and verified tutor,
  I want to post a session,
  So that I can allow others to sign up

  Background:
    Given I am a signed-in tutor
	And the following session exists:
	| start_at       | end_at         | capacity| subject|
	| 2026-10-15T10:30Z| 2026-10-15T11:29Z| 1       | Math   |

  @happy
  Scenario: Tutor posts an session with valid information
    And I am on new session page,
    When I fill in the session start time with "2026-10-15T12:00Z"
    And I fill in the session end time with "2026-10-15T12:59Z"
    And I fill in "Capacity" with "1"
    And I select "Math" from "Subject"
    And I press "Create new session"
    Then I am on the session's show page
    And I should see the message "Session successfully created"
    And I should see the session on the page

  @unknown
  Scenario: Tutor creates a post with missing/unknown information
    And I am on new session page,
    When I fill in the session start time with "2026-10-15T10:00Z"
    And I fill in the session end time with "2026-10-15T10:59Z"
    And I select "Math" from "Subject"
    And I press "Create new session"
    Then I should see an error message saying it is missing information

  @overlap
  Scenario: Tutor creates a post overlapping with existing session
    And I am on new session page,
    When I fill in the session start time with "2026-10-15T10:00Z"
    And I fill in the session end time with "2026-10-15T10:59Z"
    And I fill in "Capacity" with "1"
    And I select "Math" from "Subject"
    And I press "Create new session"
    And this session overlaps with existing session
	Then I should see an error message that there is a time conflict

# tutor deleting session will have its own feature
#  @delete
#  Scenario: Tutor wants to delete existing session
#    And I am on the session's show page
#    When I press on "Delete"
#    Then I should be on tutor's session's page
#    And I should see the message that session is deleted
