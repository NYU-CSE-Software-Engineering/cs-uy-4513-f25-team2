@wip
Feature: User Authentication/User Identity
    As a learner or tutor
    I want to create an account, log in, and log out
    So that I can access the features of the app in the correct role

    Scenario: User signs up with valid password
        Given I am on the sign-up page
        When I fill in "Email" with "example@gmail.com"
        And I fill in "Password" with "password"
        And I press "Sign up"
        Then I should see a message "Account Created!"
        And I should be redirected to login page

    Scenario: User fails to sign up with no password
        Given I am on the sign-up page
        When I fill in "Email" with "example@gmail.com"
        And I press "Sign up"
        Then I should see an error message "Password can't be blank"

    Scenario: User fails to sign up with no email
        Given I am on the sign-up page
        When I fill in "Password" with "password"
        And I press "Sign up"
        Then I should see an error message "Email can't be blank"

    Scenario: User fails to sign up with no email and no password
        Given I am on the sign-up page
        And I press "Sign up"
        Then I should see an error message "Email can't be blank"
        And I should see an error message "Password can't be blank"

    Scenario: User fails to sign up with an email taken by another user
        Given I am on the sign-up page
        And an account exists for "example@gmail.com" with password "password"
        When I fill in "Email" with "example@gmail.com"
        And I fill in "Password" with "password"
        And I press "Sign up"
        Then I should see an error message "Email has already been taken"

    Scenario: User logins in with valid credentials
        Given I am on the login page
        And an account exists for "example@gmail.com" with password "password"
        When I fill in "Email" with "example@gmail.com"
        And I fill in "Password" with "password"
        And I press "Log in"
        Then I should be redirected to the home page

    Scenario: User logins with invalid credentials
        Given I am on the login page
        And an account exists for "example@gmail.com" with password "password"
        When I fill in "Email" with "example@gmail.com"
        And I fill in "Password" with "incorrectpassword"
        And I press "Log in"
        Then I should see an error message "Invalid email or password"

    Scenario: Logged-in user logs out
        Given I am logged in as "example@gmail.com"
        When I press "Log out"
        Then I should be redirected to the login page

