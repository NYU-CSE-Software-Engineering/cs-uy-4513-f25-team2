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
- A **Tutor model** with `learner:references', 'bio:text', 'photo_url:string', 'rating_avg:decimal', and 'rating_count:int' attributes.
- A **Subject model** with `name:string` attribute.
- An **AvailabilitySlot model** with `tutor_id:integer`, `start_at:datetime`, `end_at:datetime`, and `capacity:integer` attributes.

### Controllers
- An **AvailabilitySlotController** with 'create', 'delete', and 'show' actions.

### Views
- An **availabilityslots/new.html.erb** with fields for a new tutoring availability slot
- An **availabilityslots/show.html.erb`** with display of availability slot
- A **tutors/show.html.erb** with display for all availability slots