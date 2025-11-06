Feature: Learner views tutor profiles
As a signed-in learner
I want to view a tutor's profile
So I can see their information

Background:
Given I am a signed-in learner
And the following tutors exist:
    | tutor_name       | bio    | rating_avg | rating_count | subjects                           | 
    | Emily Johnson    | Hey.   | 4.7        | 13           | Calculus, Biology                  |
    | Sarah Miller     | Hi.    | 4.6        | 6            | Calculus                           |
    | Michael Chen     | Hello. | 4.1        | 45           | Statistics, Chemistry, Programming |

@happy_views_profile
Scenario: Successfully views tutor profile
	And I am on the "All Tutors" page
	When I press on "Michael Chen"
	Then I am on the tutor's profile page
    And I should see "Name: Michael Chen"
	And I should see "Bio: Hello."
	And I should see "Rating average: 4.1"
	And I should see "Rating count: 45"
	And I should see "Subjects: Statistics, Chemistry, Programming"

@happy_searches_profiles
Scenario: Successfully views tutors of a certain subject
    And I am on the "All Tutors" page
	And I press "filter" 
	When I select "Calculus"
	And I press "submit"
	Then I should see the following tutors: "Emily Johnson", "Sarah Miller"
	And I should not see the following tutors: "Michael Chen"


@sad_missing_subject
Scenario: Does not have a subject in the search
    And I am on the "All Tutors" page
	And I press "filter"
	And I do not select a subject
	When I press "submit"
	Then I should see "No subject to filter"