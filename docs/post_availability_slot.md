# Feature: Tutor posts availability slots

## User Story (Connextra)
As a **Tutor**
So that **I can have learners sign up for one-on-one sessions**
I want to **post availability slots** 

## Acceptance Criteria (SMART)
1. **Happy path:** I post my availability to the Tutor Catalog along with times, capacity, and subject, and learners can book from there. I will see a message indicating success and the slot post.
2. **Unknown information:** If I do not fully fill out all the information for the availability slot, creation is rejected with a “Missing information” message
3. **Overlapping slots:** If the slot is full, booking is rejected with a clear “slot full” message.
4. **Delete slots:** If I press the "delete" button inside the slot post, it will fully delete the slot. I will see a message indicating success.


## MVC Outline
### Models
- `Tutor(id, first_name, last_name, ..., subject, sessions)`
- `Subject(id, code, name, ...)`
- `Session(id, tutor_id, subject_id, availability_slot_id, start_at, end_at, meeting_link, status, capacity)`

### Controllers
- `SessionsController#create, delete, show` – create a new session, delete an existing session, show created sessions

### Views
- `sessions/new.html.erb` – make a new tutoring availability slot
- `session/show.html.erb` – show an availability slot
- `tutors/show.html.erb` – show availability slots in tutor’s profile