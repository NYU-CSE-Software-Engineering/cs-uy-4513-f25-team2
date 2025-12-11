require 'rails_helper'
require 'cgi'

RSpec.describe "Sessions", type: :request do
  let(:learner) { create(:learner) }

  before do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_learner).and_return(learner)
  end

  describe "GET /sessions/search" do
    it "renders the search page" do
      get search_sessions_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Find a Session")
    end
  end

  describe "GET /sessions/results" do
    it "returns matching sessions within time range" do
      calculus = create(:subject, name: 'Calculus')
      session1 = create(:tutor_session, subject: calculus, start_at: '2026-03-10T10:00:00Z', end_at: '2026-03-10T11:00:00Z')
      session2 = create(:tutor_session, subject: calculus, start_at: '2026-03-10T14:00:00Z', end_at: '2026-03-10T15:00:00Z')

      get results_sessions_path, params: {
        subject: 'Calculus',
        start_at: '2026-03-10T08:00:00Z',
        end_at: '2026-03-10T20:00:00Z'
      }

      expect(response).to have_http_status(:ok)
      expect(assigns(:sessions)).to match_array([session1, session2])
    end
  end

  describe "POST /sessions/:id/book" do
    it "creates a booking and redirects with success message" do
      session = create(:tutor_session)

      expect {
        post book_session_path(session)
      }.to change(SessionAttendee, :count).by(1)

      expect(response).to redirect_to(learner_sessions_path)
      expect(flash[:notice]).to eq("Booking confirmed")
    end

    it "shows error when learner already booked" do
      session = create(:tutor_session)
      create(:session_attendee, tutor_session: session, learner: learner)

      post book_session_path(session)

      expect(flash[:alert]).to eq("You are already booked for that session")
    end

    it "shows error when session is full" do
      session = create(:tutor_session, capacity: 1)
      create(:session_attendee, tutor_session: session) # someone else

      post book_session_path(session)
      expect(flash[:alert]).to eq("This session is full")
    end
  end

  describe "PATCH /sessions/:id (Attendance)" do
    let(:tutor) { create(:tutor) }
    let(:session) { create(:tutor_session, tutor: tutor, start_at: 1.day.ago) }
    
    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_learner).and_return(tutor.learner)
    end

    it "marks learner as present" do
      learner_student = create(:learner)
      patch session_path(session), params: {
        session_attendee: { learner_id: learner_student.id, attended: "true" }
      }
      
      expect(SessionAttendee.last.attended).to be(true)
      expect(response).to redirect_to(session_path(session))
    end
  end

  describe "POST /sessions (Create)" do
    let(:tutor) { create(:tutor) }
    let(:subject) { create(:subject) }

    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_learner).and_return(tutor.learner)
      allow_any_instance_of(ApplicationController)
        .to receive(:current_tutor).and_return(tutor)
    end

    it "creates a new session" do
      expect {
        post "/sessions", params: {
          tutor_session: {
            subject_id: subject.id,
            start_at: '2026-10-15T10:00',
            capacity: 1,
            meeting_link: 'https://zoom.us/new'
          },
          duration_hours: 1,
          duration_minutes: 0
        }
      }.to change(TutorSession, :count).by(1)
      
      expect(response).to redirect_to(tutor_sessions_path)
    end
  end
end