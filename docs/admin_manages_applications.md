# Feature: Admin approves or rejects tutor applications

## User Story
As an **Admin**, I want to **approve or reject a submitted tutor application** so that **I can manage the active list of tutors**.

## Acceptance Criteria
1. **Happy path**: If I approve a tutor application, I 
2. **Reject application**: If I reject a tutor application,

# TODO BELOW

## MVC Outline
### Models
- An **Admin model** with `first_name:string` and `last_name:string` attributes.
- A **Tutor model** with `learner:references` attribute.
- A **TutorSession model** with `tutor:references`, `start_at:datetime`, and `end_at:datetime` attributes.
- A **SessionAttendee model** with `session:references`, `learner:references`, `attended:boolean`, and `cancelled:boolean` attributes.

### Views
- A **sessions/show.html.erb** that shows the details of a session (including the attendance function).

### Controllers
- A **SessionsController** with the `show` action.
