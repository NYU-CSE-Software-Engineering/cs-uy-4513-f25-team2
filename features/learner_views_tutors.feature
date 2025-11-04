Feature: Learner views tutor profiles
As a signed-in learner
I want to view a tutor's profile
So I can see their information

Background:
Given I am a signed-in learner
And the following tutors exist:
      | tutor_name       | bio     | rating_avg | rating_count | subjects                                           | 
      | Emily Johnson  |           | 4.7             | 13                | Calculus, Biology                             |
      | Sarah Wu         | Hi.      |4.5              | 5                  |                                                         |
      | Michael Chen   | Hello. |4.1              | 45                | Statistics, Chemistry, Programming |
      | John Doe          | Hey.   |                   |                     | Physics                                            |

@happy
Scenario: Successfully views tutor profile
	And I am on the "All Tutors" page
	When I press on "Michael Chen"
	Then I am on the tutor's profile page
    And I should see "Name: Michael Chen"
	And I should see "Bio: Hello."
	And I should see "Rating average: 4.1"
	And I should see "Rating count: 45"
	And I should see "Subjects: Statistics, Chemistry, Programming"

@sad_missing_bio
Scenario: Tutor profile missing bio
    And I am on the "All Tutors" page
	When I press on "Emily Johnson"
	Then I am on the tutor's profile page
    And I should see "Name: Emily Johnson"
	And I should see "Bio: Not provided"
	And I should see "Rating average: 4.7"
	And I should see "Rating count: 13"
	And I should see "Subjects: Calculus, Biology"

@sad_missing_subjects
Scenario: Tutor missing subjects
	And I am on the "All Tutors" page
	When I press on "Sarah Wu"
	Then I am on the tutor's profile page
    And I should see "Name: Sarah Wu"
	And I should see "Bio: Hi!"
	And I should see "Rating average: 4.5"
	And I should see "Rating count: 5"
	And I should see "Subjects: None currently"

@sad_missing_ratings
Scenario: Tutor missing ratings
	And I am on the "All Tutors" page
	When I press on "John Doe"
	Then I am on the tutor's profile page
    And I should see "Name: John Doe"
	And I should see "Bio: Hey."
	And I should see "Rating average: N/A"
	And I should see "Rating count: N/A"
	And I should see "Subjects: Physics"
