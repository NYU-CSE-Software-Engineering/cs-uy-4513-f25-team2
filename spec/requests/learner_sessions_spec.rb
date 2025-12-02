require 'rails_helper'

RSpec.describe 'LearnerSessions', type: :request do
  let(:learner) do
    Learner.create!(
      email: 'learner@example.com',
      password: 'password123'
    )
  end

  # Simple helper to simulate logging in as a learner
  def log_in_as(learner)
    post login_path, params: {
      email: learner.email,
      password: 'password123'
    }
  end

  describe 'GET /learner_sessions (upcoming)' do
    it 'redirects to login when not signed in' do
      get learner_sessions_path
      expect(response).to redirect_to(new_login_path)
    end

    it 'shows only upcoming bookings for the current learner' do
      subject_upcoming = Subject.create!(name: 'Calculus', code: 'MATH101')
      subject_past     = Subject.create!(name: 'Biology',  code: 'BIOL101')

      tutor_learner = Learner.create!(
        email: 'tutor@example.com',
        password: 'password123'
      )
      tutor = Tutor.create!(learner: tutor_learner)

      # Upcoming session: in the future
      upcoming_session = TutorSession.create!(
        tutor: tutor,
        subject: subject_upcoming,
        start_at: 2.days.from_now,
        end_at:   3.days.from_now,
        capacity: 3,
        status:   'scheduled'
      )

      # Past session: in the past
      past_session = TutorSession.create!(
        tutor: tutor,
        subject: subject_past,
        start_at: 2.days.ago,
        end_at:   1.day.ago,
        capacity: 3,
        status:   'completed'
      )

      # Bookings for current learner
      SessionAttendee.create!(
        tutor_session: upcoming_session,
        learner: learner
      )
      SessionAttendee.create!(
        tutor_session: past_session,
        learner: learner
      )

      # Booking for another learner (should never be shown)
      other_learner = Learner.create!(
        email: 'other@example.com',
        password: 'password123'
      )
      SessionAttendee.create!(
        tutor_session: upcoming_session,
        learner: other_learner
      )

      log_in_as(learner)
      get learner_sessions_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('My Upcoming Sessions')
      expect(response.body).to include('Calculus')
      expect(response.body).not_to include('Biology')
      # Ensure we have a link to the past sessions page
      expect(response.body).to include('View past sessions')
    end

    it 'shows a friendly message when there are no upcoming sessions' do
      log_in_as(learner)
      get learner_sessions_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('You have no upcoming sessions.')
      expect(response.body).to include('View past sessions')
    end
  end

  describe 'GET /learner_sessions/past' do
    it 'redirects to login when not signed in' do
      get past_learner_sessions_path
      expect(response).to redirect_to(new_login_path)
    end

    it 'shows past bookings with attendance labels for the current learner' do
      subject = Subject.create!(name: 'Math', code: 'MATH01')

      tutor_learner = Learner.create!(
        email: 'tutor@example.com',
        password: 'password123'
      )
      tutor = Tutor.create!(learner: tutor_learner)

      present_session = TutorSession.create!(
        tutor: tutor,
        subject: subject,
        start_at: 5.days.ago,
        end_at:   4.days.ago,
        capacity: 3,
        status:   'completed'
      )
      absent_session = TutorSession.create!(
        tutor: tutor,
        subject: subject,
        start_at: 7.days.ago,
        end_at:   6.days.ago,
        capacity: 3,
        status:   'completed'
      )
      unknown_session = TutorSession.create!(
        tutor: tutor,
        subject: subject,
        start_at: 9.days.ago,
        end_at:   8.days.ago,
        capacity: 3,
        status:   'completed'
      )

      SessionAttendee.create!(
        tutor_session: present_session,
        learner: learner,
        attended: true
      )
      SessionAttendee.create!(
        tutor_session: absent_session,
        learner: learner,
        attended: false
      )
      SessionAttendee.create!(
        tutor_session: unknown_session,
        learner: learner
        # attended: nil by default
      )

      log_in_as(learner)
      get past_learner_sessions_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('My Past Sessions')
      expect(response.body).to include('Present')
      expect(response.body).to include('Absent')
      expect(response.body).to include('Not recorded')
      expect(response.body).to include('Back to upcoming sessions')
    end

    it 'shows a friendly message when there are no past sessions' do
      log_in_as(learner)
      get past_learner_sessions_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('You have no past sessions.')
      expect(response.body).to include('Back to upcoming sessions')
    end
  end
end