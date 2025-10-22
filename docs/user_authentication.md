# Feature: User Authentication (login, signup, logout)

## User Story:
As a learner or tutor, I want to create an account, log in, and log out, so that I can access the features of the app in the correct role

## Acceptance Criterion:
1. The user can sign up and create a new account with a valid email and password
2. The user cannot sign up without an email or password
3. A registered user can log in with valid credentials and will be redirected to their dashboard
4. An error is displayed if login credentials are invalid
5. A logged-in user can log out and be redirected to the login page

## MVC Components:
### Models
- `Tutor(tutor_id, first_name, last_name, ...)`
- `Learner(learner_id, first_name, last_name, …)`

### Views
- `users/new.html.erb` - Signup Page
- `sessions/new.html.erb` - Login Page
- `dashboards/show.html.erb` - Dashboard

### Controllers
- `SignupsController#new, create` - displays signup form, creates new account
- `LoginsController#new, create, delete` - displays login form, authenticates credentials + redirects to dashboard, logs out user + redirect to login page
- `DashboardsController# show` - displays user’s dashboard

