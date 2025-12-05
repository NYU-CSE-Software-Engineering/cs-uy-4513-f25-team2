require 'rails_helper'

RSpec.describe 'TutorSessions', type: :request do
  let(:tutor_learner) do
    Learner.create!(
      email: 'tutor@example.com',
      password: 'password123'
    )
  end

  let(:tutor) { Tutor.create!(learner: tutor_learner) }

  # Simple helper to simulate logging in as a tutor
  def log_in_as(tutor)
    post login_path, params: {
      email: tutor.learner.email,
      password: 'password123'
    }
  end

  describe 'GET /tutor_sessions (upcoming sessions)' do
    it 'redirects to login when not signed in' do
      get tutor_sessions_path
      expect(response).to redirect_to(new_login_path)
    end

    it 'shows only upcoming sessions for the current tutor' do
      biology = Subject.create!(name: 'Biology', code: 'BIO101')
      math    = Subject.create!(name: 'Math', code: 'MATH101')

      # Upcoming session: in the future
      upcoming_session = TutorSession.create!(
        tutor: tutor,
        subject: biology,
        start_at: 2.days.from_now,
        end_at:   3.days.from_now,
        capacity: 1,
        status:   'scheduled',
        meeting_link: 'https://zoom.us/meeting/biology'
      )

      # Past session: in the past
      past_session = TutorSession.create!(
        tutor: tutor,
        subject: math,
        start_at: 5.days.ago,
        end_at:   4.days.ago,
        capacity: 2,
        status:   'completed'
      )

      log_in_as(tutor)
      get tutor_sessions_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('My Upcoming Sessions')
      expect(response.body).to include('Biology')
      expect(response.body).to include('Capacity:</strong> 1')
      expect(response.body).to include('https://zoom.us/meeting/biology')
      expect(response.body).not_to include('Math')
      expect(response.body).not_to include('Capacity:</strong> 2')
      # Ensure we have a link to the past sessions page
      expect(response.body).to include('View past sessions')
    end

    it 'shows a friendly message when there are no upcoming sessions' do
      math = Subject.create!(name: 'Math', code: 'MATH101')

      # Only a past session
      TutorSession.create!(
        tutor: tutor,
        subject: math,
        start_at: 4.days.ago,
        end_at:   3.days.ago,
        capacity: 2,
        status:   'completed'
      )

      log_in_as(tutor)
      get tutor_sessions_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('You have no upcoming sessions.')
      expect(response.body).to include('View past sessions')
    end
  end

  describe 'GET /tutor_sessions/past' do
    it 'redirects to login when not signed in' do
      get past_tutor_sessions_path
      expect(response).to redirect_to(new_login_path)
    end

    it 'shows only past sessions for the current tutor' do
      biology = Subject.create!(name: 'Biology', code: 'BIO101')
      math    = Subject.create!(name: 'Math', code: 'MATH101')

      # Upcoming session: in the future
      TutorSession.create!(
        tutor: tutor,
        subject: biology,
        start_at: 2.days.from_now,
        end_at:   3.days.from_now,
        capacity: 1,
        status:   'scheduled'
      )

      # Past session: in the past
      TutorSession.create!(
        tutor: tutor,
        subject: math,
        start_at: 5.days.ago,
        end_at:   4.days.ago,
        capacity: 2,
        status:   'completed',
        meeting_link: 'https://zoom.us/meeting/math'
      )

      log_in_as(tutor)
      get past_tutor_sessions_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('My Past Sessions')
      expect(response.body).to include('Math')
      expect(response.body).to include('Capacity:</strong> 2')
      expect(response.body).to include('https://zoom.us/meeting/math')
      expect(response.body).not_to include('Biology')
      expect(response.body).not_to include('Capacity:</strong> 1')
      # Ensure we have a link back to upcoming sessions
      expect(response.body).to include('Back to upcoming sessions')
    end

    it 'shows a friendly message when there are no past sessions' do
      biology = Subject.create!(name: 'Biology', code: 'BIO101')

      # Only upcoming
      TutorSession.create!(
        tutor: tutor,
        subject: biology,
        start_at: 2.days.from_now,
        end_at:   3.days.from_now,
        capacity: 1,
        status:   'scheduled'
      )

      log_in_as(tutor)
      get past_tutor_sessions_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('You have no past sessions.')
      expect(response.body).to include('Back to upcoming sessions')
    end
  end

  # tests for tutor updating session meeting link
  describe "GET /tutor_sessions/:id/edit" do
    it 'redirects to login when not signed in' do
      get past_tutor_sessions_path
      expect(response).to redirect_to(new_login_path)
    end

    it "renders the edit session page" do
      biology = Subject.create!(name: 'Biology', code: 'BIO101')

      session = TutorSession.create!(
        tutor: tutor,
        subject: biology,
        start_at: Time.zone.parse('2026-10-15T10:00:00Z'),
        end_at: Time.zone.parse('2026-10-15T10:59:00Z'),
        capacity: 1,
        status: 'scheduled',
        meeting_link: 'https://zoom.us/meeting/biology'
      )

      log_in_as(tutor)
      get edit_tutor_session_path(session)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Edit Session")
      expect(response.body).to include("Biology")
      expect(response.body).to include("Capacity:</strong> 1")
      expect(response.body).to include("2026-10-15T10:00:00Z")
    end

    it "pre-fills the meeting link field" do
      biology = Subject.create!(name: 'Biology', code: 'BIO101')

      session = TutorSession.create!(
        tutor: tutor,
        subject: biology,
        start_at: Time.zone.parse('2026-10-15T10:00:00Z'),
        end_at: Time.zone.parse('2026-10-15T10:59:00Z'),
        capacity: 1,
        status: 'scheduled',
        meeting_link: 'https://zoom.us/meeting/biology'
      )

      log_in_as(tutor)
      get edit_tutor_session_path(session)

      expect(response.body).to include('https://zoom.us/meeting/biology')
    end

    it "prevents editing another tutor's session" do
      biology = Subject.create!(name: 'Biology', code: 'BIO101')
      other_learner = Learner.create!(email: "other@example.com", password: "password123", first_name: "Other", last_name: "Tutor")
      other_tutor = Tutor.create!(learner: other_learner, bio: "Other bio", rating_avg: 4.0, rating_count: 5)

      other_tutor_session = TutorSession.create!(
        tutor: other_tutor,
        subject: biology,
        start_at: Time.zone.parse('2026-10-15T10:00:00Z'),
        end_at: Time.zone.parse('2026-10-15T10:59:00Z'),
        capacity: 1,
        status: 'scheduled',
        meeting_link: 'https://zoom.us/meeting/biology'
      )

      log_in_as(tutor)
      get edit_tutor_session_path(other_tutor_session)

      expect(flash[:alert]).to eq("You cannot edit another tutor's session")
    end
  end

  describe "PATCH /tutor/sessions/:id" do
    it "updates the meeting link and redirects to upcoming sessions" do
      biology = Subject.create!(name: 'Biology', code: 'BIO101')

      session = TutorSession.create!(
        tutor: tutor,
        subject: biology,
        start_at: Time.zone.parse('2026-10-15T10:00:00Z'),
        end_at: Time.zone.parse('2026-10-15T10:59:00Z'),
        capacity: 1,
        status: 'scheduled',
        meeting_link: 'https://zoom.us/meeting/biology'
      )

      log_in_as(tutor)
      patch tutor_session_path(session), params: {
        tutor_session: {
          meeting_link: 'https://zoom.us/updated'
        }
      }

      expect(response).to redirect_to(tutor_sessions_path)
      follow_redirect!
      expect(response.body).to include('https://zoom.us/updated')

      session.reload
      expect(session.meeting_link).to eq('https://zoom.us/updated')
    end

    it "displays a success message" do
      biology = Subject.create!(name: 'Biology', code: 'BIO101')

      session = TutorSession.create!(
        tutor: tutor,
        subject: biology,
        start_at: Time.zone.parse('2026-10-15T10:00:00Z'),
        end_at: Time.zone.parse('2026-10-15T10:59:00Z'),
        capacity: 1,
        status: 'scheduled',
        meeting_link: 'https://zoom.us/meeting/biology'
      )

      log_in_as(tutor)
      patch tutor_session_path(session), params: {
        tutor_session: {
          meeting_link: 'https://zoom.us/updated'
        }
      }

      expect(flash[:notice]).to eq('Session updated successfully')
    end
  end

  describe 'PATCH /tutor_sessions/:id/confirm_cancel' do
    it 'allows the tutor to cancel their own upcoming session' do
      biology = Subject.create!(name: 'Biology', code: 'BIO101')

      session = TutorSession.create!(
        tutor: tutor,
        subject: biology,
        start_at: 2.days.from_now,
        end_at: 3.days.from_now,
        capacity: 1,
        status: 'scheduled'
      )

      log_in_as(tutor)
      patch confirm_cancel_tutor_session_path(session)
      expect(response).to redirect_to(tutor_sessions_path)
      follow_redirect!
      expect(response.body).to include("Session cancelled")
      session.reload
      expect(session.status).to eq('cancelled')
    end

    it "does not allow a tutor to cancel another tutor's session" do
      other_learner = Learner.create!(
        email: "other@example.com",
        password: "password123"
      )

      other_tutor = Tutor.create!(learner: other_learner)
      biology = Subject.create!(name: "Biology", code: "BIO101")
      other_session = TutorSession.create!(
        tutor: other_tutor,
        subject: biology,
        start_at: 2.days.from_now,
        end_at: 3.days.from_now,
        capacity: 1,
        status: "scheduled"
      )

      log_in_as(tutor)
      patch confirm_cancel_tutor_session_path(other_session)
      expect(response).to redirect_to(tutor_sessions_path)
      follow_redirect!
      expect(response.body).to include("You are not authorized to cancel the session")
      other_session.reload
      expect(other_session.status).to eq("scheduled")
    end

    it 'does not allow a past session to be cancelled' do
      math = Subject.create!(name: "Math", code: "MATH101")

      past_session = TutorSession.create!(
        tutor: tutor,
        subject: math,
        start_at: 5.days.ago,
        end_at: 4.days.ago,
        capacity: 1,
        status: "completed"
      )

      log_in_as(tutor)
      patch confirm_cancel_tutor_session_path(past_session)
      expect(response).to redirect_to(tutor_sessions_path)
      follow_redirect!
      expect(response.body).to include("You can only cancel upcoming sessions")
      past_session.reload
      expect(past_session.status).to eq("completed")
    end
  end
end
