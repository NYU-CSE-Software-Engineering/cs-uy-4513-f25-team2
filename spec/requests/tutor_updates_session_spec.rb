require 'rails_helper'

RSpec.describe 'Tutor::Updates', type: :request do
  describe "GET /tutor/sessions/:id/edit" do
    let(:tutor_learner) { Learner.create!(email: "tutor@example.com", password: "password123", first_name: "John", last_name: "Tutor") }
    let(:tutor) { Tutor.create!(learner: tutor_learner, bio: "Bio", rating_avg: 4.5, rating_count: 10) }
    let(:biology) { Subject.create!(name: "Biology", code:"BIO101") }

    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_learner).and_return(tutor_learner)
      allow_any_instance_of(ApplicationController)
        .to receive(:current_tutor).and_return(tutor)
    end

    it "renders the edit session page" do
      session = make_tutor_session(
        tutor: tutor,
        subject: biology,
        start_at: Time.zone.parse('2026-10-15T10:00:00Z'),
        end_at: Time.zone.parse('2026-10-15T10:59:00Z'),
        capacity: 1,
        status: 'scheduled',
        meeting_link: 'https://zoom.us/old'
      )

      get edit_tutor_session_path(session)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Edit Session")
      expect(response.body).to include("Biology")
      expect(response.body).to include("Capacity: 1")
      expect(response.body).to include("2026-10-15T10:00:00Z")
    end

    it "pre-fills the meeting link field" do
      session = make_tutor_session(
        tutor: tutor,
        subject: biology,
        start_at: Time.zone.parse('2026-10-15T10:00:00Z'),
        end_at: Time.zone.parse('2026-10-15T10:59:00Z'),
        capacity: 1,
        status: 'scheduled',
        meeting_link: 'https://zoom.us/existing'
      )

      get edit_tutor_session_path(session)

      expect(response.body).to include('https://zoom.us/existing')
    end

    it "prevents editing another tutor's session" do
      other_learner = Learner.create!(email: "other@example.com", password: "password123")
      other_tutor = Tutor.create!(learner: other_learner)

      session = make_tutor_session(
        tutor: other_tutor,
        subject: biology,
        start_at: Time.zone.parse('2026-10-15T10:00:00Z'),
        end_at: Time.zone.parse('2026-10-15T10:59:00Z'),
        capacity: 1,
        status: 'scheduled'
      )

      get edit_tutor_session_path(session)

      expect(response).to redirect_to(new_login_path)
    end
  end

  describe "PATCH /tutor/sessions/:id" do
    let(:tutor_learner) { Learner.create!(email: "tutor@example.com", password: "password123", first_name: "John", last_name: "Tutor") }
    let(:tutor) { Tutor.create!(learner: tutor_learner, bio: "Bio", rating_avg: 4.5, rating_count: 10) }
    let(:biology) { make_subject("Biology", "BIO101") }

    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_learner).and_return(tutor_learner)
      allow_any_instance_of(ApplicationController)
        .to receive(:current_tutor).and_return(tutor)
    end

    context "successful update" do
      it "updates the meeting link and redirects to upcoming sessions" do
        session = make_tutor_session(
          tutor: tutor,
          subject: biology,
          start_at: Time.zone.parse('2026-10-15T10:00:00Z'),
          end_at: Time.zone.parse('2026-10-15T10:59:00Z'),
          capacity: 1,
          status: 'scheduled',
          meeting_link: 'https://zoom.us/old'
        )

        patch tutor_session_path(session), params: {
          tutor_session: {
            meeting_link: 'https://zoom.example.us'
          }
        }

        expect(response).to redirect_to(tutor_sessions_path)
        follow_redirect!
        expect(response.body).to include('https://zoom.example.us')

        session.reload
        expect(session.meeting_link).to eq('https://zoom.example.us')
      end

      it "displays a success message" do
        session = make_tutor_session(
          tutor: tutor,
          subject: biology,
          start_at: Time.zone.parse('2026-10-15T10:00:00Z'),
          end_at: Time.zone.parse('2026-10-15T10:59:00Z'),
          capacity: 1,
          status: 'scheduled'
        )

        patch tutor_session_path(session), params: {
          tutor_session: {
            meeting_link: 'https://zoom.example.us'
          }
        }

        expect(flash[:notice]).to eq('Session updated successfully')
      end
    end

    context "authorization" do
      it "prevents updating another tutor's session" do
        other_learner = Learner.create!(email: "other@example.com", password: "password123")
        other_tutor = Tutor.create!(learner: other_learner)

        session = make_tutor_session(
          tutor: other_tutor,
          subject: biology,
          start_at: Time.zone.parse('2026-10-15T10:00:00Z'),
          end_at: Time.zone.parse('2026-10-15T10:59:00Z'),
          capacity: 1,
          status: 'scheduled'
        )

        patch tutor_session_path(session), params: {
          tutor_session: {
            meeting_link: 'https://zoom.example.us'
          }
        }

        expect(response).to redirect_to(new_login_path)

        session.reload
        expect(session.meeting_link).to be_nil
      end
    end
  end

  describe "cancel update" do
    let(:tutor_learner) { Learner.create!(email: "tutor@example.com", password: "password123", first_name: "John", last_name: "Tutor") }
    let(:tutor) { Tutor.create!(learner: tutor_learner, bio: "Bio", rating_avg: 4.5, rating_count: 10) }
    let(:biology) { make_subject("Biology", "BIO101") }

    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_learner).and_return(tutor_learner)
      allow_any_instance_of(ApplicationController)
        .to receive(:current_tutor).and_return(tutor)
    end

    it "redirects back to upcoming sessions without saving changes" do
      session = make_tutor_session(
        tutor: tutor,
        subject: biology,
        start_at: Time.zone.parse('2026-10-15T10:00:00Z'),
        end_at: Time.zone.parse('2026-10-15T10:59:00Z'),
        capacity: 1,
        status: 'scheduled',
        meeting_link: 'https://zoom.us/original'
      )

      get tutor_sessions_path

      expect(response).to have_http_status(:ok)

      session.reload
      expect(session.meeting_link).to eq('https://zoom.us/original')
    end
  end
end
