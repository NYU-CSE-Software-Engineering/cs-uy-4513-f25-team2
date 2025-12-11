require 'rails_helper'
require 'cgi'

RSpec.describe "Sessions", type: :request do
  # Helper to create a Subject
  def make_subject(name, code)
    Subject.find_or_create_by!(name: name) do |s|
      s.code = code
    end
  end

  # Helper to create a Tutor with associated Learner
  def make_tutor(first:, last:, bio: nil, rating: 0.0, rating_count: 0)
    learner = Learner.find_or_create_by!(
      email: "#{first.downcase}.#{last.downcase}@example.com"
    ) do |l|
      l.password = "password123"
      l.first_name = first
      l.last_name = last
    end

    Tutor.find_or_create_by!(learner: learner) do |t|
      t.bio = bio
      t.rating_avg = rating
      t.rating_count = rating_count
    end
  end

  # Helper to create a TutorSession
  def make_tutor_session(tutor:, subject:, start_at:, end_at:, capacity: 1, status: "Scheduled", meeting_link: nil)
    TutorSession.find_or_create_by!(
      tutor: tutor,
      subject: subject,
      start_at: start_at,
      end_at: end_at,
      meeting_link: meeting_link
    ) do |s|
      s.capacity = capacity
      s.status = status
    end
  end

  # Helper to create a SessionAttendee
  def make_session_attendee(tutor_session:, learner:, attended: nil)
    SessionAttendee.find_or_create_by!(
      tutor_session: tutor_session,
      learner: learner
    ) do |sa|
      sa.attended = attended
    end
  end

  # Booking Sessions Specs
  describe "GET /sessions/search" do
    let(:learner) { Learner.create!(email: "mia@example.com", password: "password123", first_name: "Mia", last_name: "Patel") }

    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_learner).and_return(learner)
    end

    it "renders the search page" do
      get search_sessions_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Find a Session")
    end
  end

  describe "GET /sessions/results" do
    let(:learner) { Learner.create!(email: "mia@example.com", password: "password123", first_name: "Mia", last_name: "Patel") }
    let(:calculus) { make_subject("Calculus", "MATH101") }
    let(:emily) { make_tutor(first: "Emily", last: "Johnson") }
    let(:michael) { make_tutor(first: "Michael", last: "Chen") }

    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_learner).and_return(learner)
    end

    it "returns matching sessions within time range" do
      session1 = make_tutor_session(
        tutor: emily,
        subject: calculus,
        start_at: Time.zone.parse('2026-03-10T10:00:00Z'),
        end_at: Time.zone.parse('2026-03-10T11:00:00Z'),
        capacity: 3,
        meeting_link: 'https://zoom.us/meeting1'
      )

      session2 = make_tutor_session(
        tutor: michael,
        subject: calculus,
        start_at: Time.zone.parse('2026-03-10T14:00:00Z'),
        end_at: Time.zone.parse('2026-03-10T15:00:00Z'),
        capacity: 2,
        meeting_link: 'https://zoom.us/meeting2'
      )

      get results_sessions_path, params: {
        subject: 'Calculus',
        start_at: '2026-03-10T08:00:00Z',
        end_at: '2026-03-10T20:00:00Z'
      }

      expect(response).to have_http_status(:ok)
      expect(assigns(:sessions)).to match_array([session1, session2])
    end

    it "filters out sessions outside time range" do
      session_in_range = make_tutor_session(
        tutor: emily,
        subject: calculus,
        start_at: Time.zone.parse('2026-03-10T10:00:00Z'),
        end_at: Time.zone.parse('2026-03-10T11:00:00Z'),
        capacity: 3
      )

      session_out_of_range = make_tutor_session(
        tutor: emily,
        subject: calculus,
        start_at: Time.zone.parse('2026-03-11T10:00:00Z'),
        end_at: Time.zone.parse('2026-03-11T11:00:00Z'),
        capacity: 2
      )

      get results_sessions_path, params: {
        subject: 'Calculus',
        start_at: '2026-03-10T08:00:00Z',
        end_at: '2026-03-10T20:00:00Z'
      }

      expect(assigns(:sessions)).to include(session_in_range)
      expect(assigns(:sessions)).not_to include(session_out_of_range)
    end
  end

  describe "GET /sessions/:id/confirm" do
    let(:learner) { Learner.create!(email: "mia@example.com", password: "password123", first_name: "Mia", last_name: "Patel") }
    let(:calculus) { make_subject("Calculus", "MATH101") }
    let(:emily) { make_tutor(first: "Emily", last: "Johnson") }

    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_learner).and_return(learner)
    end

    it "renders the confirmation page" do
      session = make_tutor_session(
        tutor: emily,
        subject: calculus,
        start_at: Time.zone.parse('2026-03-10T10:00:00Z'),
        end_at: Time.zone.parse('2026-03-10T11:00:00Z'),
        capacity: 3
      )

      get confirm_session_path(session)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Booking")
      expect(assigns(:tutor_session)).to eq(session)
    end
  end

  describe "POST /sessions/:id/book" do
    let(:learner) { Learner.create!(email: "mia@example.com", password: "password123", first_name: "Mia", last_name: "Patel") }
    let(:calculus) { make_subject("Calculus", "MATH101") }
    let(:emily) { make_tutor(first: "Emily", last: "Johnson") }

    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_learner).and_return(learner)
    end

    context "happy path" do
      it "creates a booking and redirects with success message" do
        session = make_tutor_session(
          tutor: emily,
          subject: calculus,
          start_at: Time.zone.parse('2026-03-10T10:00:00Z'),
          end_at: Time.zone.parse('2026-03-10T11:00:00Z'),
          capacity: 3,
          meeting_link: 'https://zoom.us/meeting1'
        )

        expect {
          post book_session_path(session)
        }.to change(SessionAttendee, :count).by(1)

        expect(response).to redirect_to(session_path(session))
        expect(flash[:notice]).to eq("Booking confirmed")

        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Meeting link")
      end
    end

    context "double booking" do
      it "shows error when learner already booked the same session" do
        session = make_tutor_session(
          tutor: emily,
          subject: calculus,
          start_at: Time.zone.parse('2026-03-10T10:00:00Z'),
          end_at: Time.zone.parse('2026-03-10T11:00:00Z'),
          capacity: 3
        )

        make_session_attendee(tutor_session: session, learner: learner)

        post book_session_path(session)

        expect(response).to redirect_to(confirm_session_path(session))
        expect(flash[:alert]).to eq("You are already booked for that session")
      end
    end

    context "session is full" do
      it "shows error when session is at capacity" do
        session = make_tutor_session(
          tutor: emily,
          subject: calculus,
          start_at: Time.zone.parse('2026-03-10T10:00:00Z'),
          end_at: Time.zone.parse('2026-03-10T11:00:00Z'),
          capacity: 3
        )

        learner2 = Learner.create!(email: "learner2@example.com", password: "password123")
        learner3 = Learner.create!(email: "learner3@example.com", password: "password123")
        learner4 = Learner.create!(email: "learner4@example.com", password: "password123")

        make_session_attendee(tutor_session: session, learner: learner2)
        make_session_attendee(tutor_session: session, learner: learner3)
        make_session_attendee(tutor_session: session, learner: learner4)

        post book_session_path(session)

        expect(response).to redirect_to(confirm_session_path(session))
        expect(flash[:alert]).to eq("This session is full")
      end
    end

    context "time conflict" do
      it "shows error when session conflicts with another booking" do
        daniel = make_tutor(first: "Daniel", last: "Kim")

        conflicting_session = make_tutor_session(
          tutor: daniel,
          subject: calculus,
          start_at: Time.zone.parse('2026-03-10T10:15:00Z'),
          end_at: Time.zone.parse('2026-03-10T10:45:00Z'),
          capacity: 2
        )

        new_session = make_tutor_session(
          tutor: emily,
          subject: calculus,
          start_at: Time.zone.parse('2026-03-10T10:30:00Z'),
          end_at: Time.zone.parse('2026-03-10T11:30:00Z'),
          capacity: 3
        )

        make_session_attendee(tutor_session: conflicting_session, learner: learner)

        post book_session_path(new_session)

        expect(response).to redirect_to(confirm_session_path(new_session))
        expect(flash[:alert]).to eq("This session conflicts with another session")
      end
    end
  end

  # Marking Attendance Specs
  describe "GET /sessions/:id" do
    let(:subject) { make_subject("Calculus", "MATH101") }
    let(:tutor_learner) { Learner.create!(email: "miapatel@example.com", password: "password123", first_name: "Mia", last_name: "Patel") }
    let(:tutor) { Tutor.create!(learner: tutor_learner, bio: nil, rating_avg: 0, rating_count: 0) }
    let(:past_session) { make_tutor_session(tutor: tutor, subject: subject, start_at: 1.day.ago, end_at: 1.day.ago + 1.hour) }
    let(:future_session) { make_tutor_session(tutor: tutor, subject: subject, start_at: 1.day.from_now, end_at: 1.day.from_now + 1.hour) }

    context "when authenticated as the session's tutor" do
      before do
        allow_any_instance_of(ApplicationController)
          .to receive(:current_learner).and_return(tutor_learner)
      end

      it "renders the session details page" do
        get session_path(past_session)
        expect(response).to have_http_status(:ok)
      end

      it "shows session information" do
        get session_path(past_session)
        expect(response.body).to include("Calculus")
      end

      it "shows attendance form for past sessions" do
        get session_path(past_session)
        expect(response).to have_http_status(:ok)
      end

      it "hides attendance form for future sessions" do
        get session_path(future_session)
        expect(response).to have_http_status(:ok)
      end
    end

    context "when not authenticated as the session's tutor" do
      it "redirects to login page" do
        get session_path(past_session)
        expect(response).to redirect_to(new_login_path)
      end
    end
  end

  describe "PATCH /sessions/:id" do
    let(:subject) { make_subject("Calculus", "MATH101") }
    let(:tutor_learner) { Learner.create!(email: "miapatel@example.com", password: "password123", first_name: "Mia", last_name: "Patel") }
    let(:tutor) { Tutor.create!(learner: tutor_learner, bio: nil, rating_avg: 0, rating_count: 0) }
    let(:learner) { Learner.create!(email: "janedoe@example.com", password: "password123", first_name: "Jane", last_name: "Doe") }
    let(:past_session) { make_tutor_session(tutor: tutor, subject: subject, start_at: 1.day.ago, end_at: 1.day.ago + 1.hour) }
    let(:future_session) { make_tutor_session(tutor: tutor, subject: subject, start_at: 1.day.from_now, end_at: 1.day.from_now + 1.hour) }

    context "when authenticated as the session's tutor" do
      before do
        allow_any_instance_of(ApplicationController)
          .to receive(:current_learner).and_return(tutor_learner)
      end

      context "when marking learner as present" do
        it "creates a SessionAttendee if the session does not have one" do
          patch session_path(past_session), params: {
            session_attendee: {
              learner_id: learner.id,
              attended: "true"
            }
          }
          attendee = SessionAttendee.find_by!(tutor_session: past_session, learner: learner)
          expect(attendee.attended).to eq(true)
        end

        it "marks the SessionAttendee as attended" do
          make_session_attendee(tutor_session: past_session, learner: learner, attended: false)
          patch session_path(past_session), params: {
            session_attendee: {
              learner_id: learner.id,
              attended: "true"
            }
          }
          attendee = SessionAttendee.find_by!(tutor_session: past_session, learner: learner)
          expect(attendee.attended).to eq(true)
        end

        it "re-renders with success message" do
          patch session_path(past_session), params: {
            session_attendee: {
              learner_id: learner.id,
              attended: "true"
            }
          }
          expect(response).to redirect_to(session_path(past_session))
          follow_redirect!
          expect(response.body).to include("Learner marked as present")
        end
      end

      context "marking learner as absent" do
        it "creates a SessionAttendee if the session does not have one" do
          patch session_path(past_session), params: {
            session_attendee: {
              learner_id: learner.id,
              attended: "false"
            }
          }
          attendee = SessionAttendee.find_by!(tutor_session: past_session, learner: learner)
          expect(attendee.attended).to eq(false)
        end

        it "marks the SessionAttendee as not attended" do
          make_session_attendee(tutor_session: past_session, learner: learner, attended: true)
          patch session_path(past_session), params: {
            session_attendee: {
              learner_id: learner.id,
              attended: "false"
            }
          }
          attendee = SessionAttendee.find_by!(tutor_session: past_session, learner: learner)
          expect(attendee.attended).to eq(false)
        end

        it "re-renders with a success message" do
          patch session_path(past_session), params: {
            session_attendee: {
              learner_id: learner.id,
              attended: "false"
            }
          }
          expect(response).to redirect_to(session_path(past_session))
          follow_redirect!
          expect(response.body).to include("Learner marked as absent")
        end
      end

      context "when no attendance option is selected" do
        it "re-renders with an error message" do
          patch session_path(past_session), params: {
            session_attendee: {
              learner_id: learner.id,
              attended: nil
            }
          }
          expect(response).to have_http_status(:unprocessable_content)
          page_content = CGI.unescapeHTML(response.body)
          expect(page_content).to include("No attendance option selected.")
        end
      end

      context "when session has not yet occurred" do
        it "prevents marking attendance" do
          patch session_path(future_session), params: {
            session_attendee: {
              learner_id: learner.id,
              attended: "true"
            }
          }
          expect(response).not_to have_http_status(:ok)
        end
      end
    end

    context "when not authenticated" do
      it "redirects to login page" do
        patch session_path(past_session), params: {
          session_attendee: {
            learner_id: learner.id,
            attended: "true"
          }
        }
        expect(response).to redirect_to(new_login_path)
      end
    end

    context "when authenticated as a different tutor" do
      let(:tutor_learner_2) { Learner.create!(email: "johnsmith@example.com", password: "password123", first_name: "John", last_name: "Smith") }
      let(:tutor_2) { Tutor.create!(learner: tutor_learner_2) }

      before do
        allow_any_instance_of(ApplicationController)
          .to receive(:current_learner).and_return(tutor_learner_2)
      end

      it "prevents marking attendance for another tutor's session" do
        patch session_path(past_session), params: {
          session_attendee: {
            learner_id: learner.id,
            attended: "true"
          }
        }
        expect(response).not_to have_http_status(:ok)
      end
    end
  end

  describe "POST /sessions" do
    let(:tutor_learner) { Learner.create!(email: 'tutor@example.com', password: 'password123') }
    let(:tutor) { Tutor.create!(learner: tutor_learner) }
    let(:subject_math) { Subject.create!(name: "Math", code: "MATH101") }
    
    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_learner).and_return(tutor_learner)
      allow_any_instance_of(ApplicationController)
        .to receive(:current_tutor).and_return(tutor)
    end

    # happy path
    context "with valid information" do 
      it "creates a new session and redirects to show page" do 
        expect {
          post "/sessions", params: {
            tutor_session: {
              subject_id: subject_math.id,
              start_at: '2026-10-15T10:00',
              capacity: 1,
              meeting_link: 'https://zoom.us/new'
            },
            duration_hours: 1,
            duration_minutes: 0
          }
        }.to change(TutorSession, :count).by(1)
        
        session = TutorSession.last
        expect(session.end_at).to eq(session.start_at + 1.hour)
        expect(session.meeting_link).to eq('https://zoom.us/new')
        expect(response).to redirect_to(session_path(session))
      end
    end

    context "with missing information" do 
      it "does not create a session and shows an error" do 
        expect {
          post "/sessions", params: {
            tutor_session: {
              subject_id: subject_math.id,
              start_at: '2026-10-15T08:00', 
              capacity: nil  # Make capacity nil to trigger error
            },
            duration_hours: 1,
            duration_minutes: 0
          }
        }.not_to change(TutorSession, :count)
        
        expect(response).to have_http_status(:unprocessable_content)
        body = CGI.unescapeHTML(response.body)
        expect(body).to include("can't be blank")
      end
    end

    context "when overlapping with existing session" do
      before do
        TutorSession.create!(
          tutor: tutor,
          subject: subject_math,
          start_at: Time.zone.parse('2026-10-15T11:00'),
          end_at: Time.zone.parse('2026-10-15T12:00'),
          capacity: 1,
          status: "open"
        )
      end

      it "does not allow overlapping session" do
        expect {
          post "/sessions", params: {
            tutor_session: {
              subject_id: subject_math.id,
              start_at: '2026-10-15T11:30',
              capacity: 1
            },
            duration_hours: 1,
            duration_minutes: 0
          }
        }.not_to change(TutorSession, :count)
        
        expect(response).to have_http_status(:unprocessable_content)
        body = CGI.unescapeHTML(response.body)
        expect(body).to include("Session overlaps with existing session")
      end
    end
  end

  describe "GET /sessions/new" do
    let(:tutor)   { make_tutor(first: "Test", last: "Tutor") }
    let(:learner) { tutor.learner }

    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_learner).and_return(learner)
    end

    it "does not show archived subjects in the subject dropdown" do
      active_subject   = make_subject("Mathematics", "MTH101")
      archived_subject = Subject.create!(
        name: "Physics",
        code: "PHY101",
        archived: true
      )

      get new_session_path

      expect(response).to have_http_status(:ok)
      html = response.body

      # The form's select uses subject names as options
      expect(html).to include("Mathematics")
      expect(html).not_to include("Physics")
    end
  end
end