# Feature: Learner books a tutor’s posted availability slot

## User Story (Connextra)
As a **Learner**
So that **I can attend an online tutoring session**
I want to **book a tutor’s posted availability slot** (1:1 or group)

## Acceptance Criteria (SMART)
1. **Happy path:** From Tutor Catalog, I view a tutor’s profile, see posted slots, select a slot with remaining capacity, and book it. I see a confirmation showing **meeting link** and session details.
2. **No double-booking:** If I already booked the same slot, the second attempt is rejected with a clear message.
3. **Capacity enforced:** If the slot is full, booking is rejected with a clear “slot full” message.
4. **Time conflict:** If the slot overlaps another of my upcoming sessions, booking is rejected with a “time conflict” message.
5. **Auditability:** A successful booking stores a Session with `tutor_id`, `subject_id`, `availability_slot_id`, `start_at`, `end_at`, and a **meeting_link**.

## MVC Outline
### Models
- `Tutor(id, first_name, last_name, ...)`
- `Subject(id, code, name, ...)`
- `AvailabilitySlot(id, tutor_id, start_at, end_at, capacity, recurrence_rule)`
- `Session(id, tutor_id, subject_id, availability_slot_id, start_at, end_at, meeting_link, status, capacity)`
- `SessionsAttendee(id, session_id, learner_id, joined_at, attended, feedback_submitted, cancelled_at)`

### Controllers
- `TutorsController#index, show` – list/browse tutors, show availability
- `SessionsController#create` – create/join session respecting capacity & duplicates; `#show` – confirmation

### Views
- `tutors/index.html.erb` – catalog
- `tutors/show.html.erb` – profile & slots
- `sessions/show.html.erb` – confirmation