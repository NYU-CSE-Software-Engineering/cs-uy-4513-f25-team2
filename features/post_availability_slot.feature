Feature: Tutor posts a new availability slot
  As a signed in and verified tutor,
  I want to post an availability slot,
  So that I can allow others to sign up

  Background:
    Given I am a signed in user and tutor
	And the following slot exists:
	| start_time       | end_time         | capacity| subject|
	| 2026-10-15T11:00Z| 2026-10-15T11:59Z| 1       | Math   |

  @happy
  Scenario: Tutor posts an availability slot with valid information
    And I am on new slot page,
    When I fill in "Start Time" with "2026-10-15T10:00Z"
    And I fill in "End Time" with "2026-10-15T10:59Z"
    And I fill in "Capacity" with "1"
    And I fill in "Subject" with "Math"
    And I press "Create new availability slot"
    Then I am on the slot's show page
    And I should see the message "Slot successfully created"
    And I should see the slot on the page

  @unknown
  Scenario: Tutor creates a post with missing/unknown information
    And I am on new slot page,
    When I fill in "Start Time" with "2026-10-15T8:00Z"
    And I fill in "End Time" with "2026-10-15T9:00Z"
    And I fill in "Subject" with "Math"
    And I press "Create new availability slot"
    Then I should see an error message saying it is missing information

  @overlap
  Scenario: Tutor creates a post overlapping with existing availability slot
    And I am on new slot page,
    When I fill in "Start Time" with "2026-10-15T8:00Z"
    And I fill in "End Time" with "2026-10-15T9:00Z"
    And I fill in "Capacity" with "1"
    And I fill in "Subject" with "Math"
    And I press "Create new availability slot"
    And this slot overlaps with existing slot
	Then I should see an error message that there is a time conflict

  @delete
  Scenario: Tutor wants to delete existing availability slot
    And I am on the slot's show page
    When I press on "Delete"
    Then I should be on tutor's slots page
    And I should see the message that slot is deleted
