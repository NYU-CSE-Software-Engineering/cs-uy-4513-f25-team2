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
  def make_tutor_session(tutor:, subject:, start_at:, end_at:, capacity: 1, status: "Scheduled")
    TutorSession.find_or_create_by!(
      tutor: tutor,
      subject: subject,
      start_at: start_at,
      end_at: end_at
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
end