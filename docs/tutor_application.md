# Feature: Allow a user to apply to be a tutor

## User Story (Connextra)
As a **Learner**  
So that **I can access tutor privileges, like reserving a room and booking a session**  
I want to **apply to be a tutor**

## Acceptance Criteria (SMART)
1. **Happy path:** From the Settings page, I view the option to apply to be a tutor, submit my application, and see a confirmation message.  
2. **Already a tutor:** If I am already a tutor, the option to apply is hidden.  
3. **Pending review:** If my application is pending, the option is replaced with a “Pending review” message.
4. **Admin approval:** When an admin approves my application, I am now a Tutor.  
5. **Admin rejection:** When an admin rejects my application, I stay a learner.

## MVC Outline
### Models
- `Tutor(id, first_name, last_name, ...)`
- `Pending_Application(id, reason, recommendation ...)`
- `Learner(id, first_name, last_name, ...)`

### Controllers
- `ApplicationsController#create, approve, deny, status` – creates an record in the pending_applications table, approval removes a record from pending_applications table and adds one to the tutors table and emails the learner, denial removes a record from pending_applications table and emails the learner, status returns if the user has a record in the pending_applications

### Views
- `tutors/application.html.erb` – page/component to fill out application form and give confirmation that you applied. Or will inform you that you have a pending application
- `settings.html.erb` – page that will conditionally render a button to apply for being a tutor