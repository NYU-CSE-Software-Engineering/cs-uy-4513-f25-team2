# Feature: Learner finds an available slot by Subject + Time Range and books it

## User Story
As a **Learner (Tutee)**, I want to **search tutors’ posted availability by subject and time range and book one slot** so that **I can attend an online tutoring session at a convenient time**.

## Acceptance Criteria
1. **Happy path:** After I sign in and search by subject and time range, I see matching slots; choosing one and confirming shows “Booking confirmed” and a meeting link.
2. **No double-booking:** If I try to book the same slot twice, I see “You are already booked for that slot.”
3. **Capacity enforced:** If a slot is full, I see “This slot is full.”
4. **Time conflict:** If my chosen slot overlaps another upcoming session of mine, I see “This slot conflicts with another session.”
5. **Auditability:** A successful booking creates a `Session` linked to the chosen availability slot, tutor, and subject, with `start_at`, `end_at`, and a meeting link.

## MVC Outline
### Models
- A **Learner model** with `email:string`, `password:string`, `first_name:string`, and `last_name:string` attributes.
- A **Tutor model** with `first_name:string`, `last_name:string`, and `email:string` attributes.
- A **Subject model** with `name:string` attribute.
- A **Teach model** with `tutor_id:integer` and `subject_id:integer` attributes (table name `teaches`).
- An **AvailabilitySlot model** with `tutor_id:integer`, `start_at:datetime`, `end_at:datetime`, and `capacity:integer` attributes.
- A **Session model** with `tutor_id:integer`, `subject_id:integer`, `availability_slot_id:integer`, `start_at:datetime`, `end_at:datetime`, `meeting_link:string`, and `capacity:integer` attributes.
- A **SessionsAttendee model** with `session_id:integer`, `learner_id:integer`, and `joined_at:datetime` attributes.

### Views
- A **home/index.html.erb view** with a link to begin searching.
- A **sessions/search.html.erb view** with a form.
- A **sessions/results.html.erb view** with a list of matching slots and a select button per slot.
- A **sessions/confirm.html.erb view** with a confirm button.

### Controllers
- A **HomeController** with `index` action.
- A **SessionsController** with `search`, `results`, and `confirm` actions.