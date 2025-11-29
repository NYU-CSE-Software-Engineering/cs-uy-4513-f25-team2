require 'rails_helper'
require 'cgi'

RSpec.describe "TutorSessions", type: :request do
  let(:tutor_learner) { Learner.create!(email: 'tutor@example.com', password: 'password123') }
  let(:tutor) { Tutor.create!(learner: tutor_learner) }
  let(:subject_math) { Subject.create!(name: "Math", code: "MATH101") }

  describe "POST /sessions" do
    before do
      allow_any_instance_of(TutorSessionsController)
        .to receive(:current_tutor)
        .and_return(tutor)
    end

    # happy path
    context "with valid information" do 
      it "creates a new session and redirects to show page" do 
        expect {
          post "/sessions", params: {
            tutor_session: {
              tutor: tutor,
              subject_id: subject_math.id,
              start_at: Time.parse('2026-10-15T10:00'),
              end_at: Time.parse('2026-10-15T10:59'),
              capacity: 1
            }
          }
        }.to change(TutorSession, :count).by(1)
        expect(response).to redirect_to(tutor_session_path(TutorSession.last))
      end
    end

    # missing info
    context "with missing information" do 
      it "does not create a session and shows an error" do 
        expect {
          post "/sessions", params: {
            tutor_session: {
              tutor: tutor,
              subject_id: nil,
              start_at: Time.parse('2026-10-15T08:00'), 
              end_at: Time.parse('2026-10-15T09:00'), 
              capacity: 1
            }
          }
        }.not_to change(TutorSession, :count)
        body = CGI.unescapeHTML(response.body)
        expect(body).to include("can't be blank")
      end
    end

    # overlapping session
    context "when overlapping with existing session" do
      before do
        TutorSession.create!(
          tutor: tutor,
          subject_id: subject_math.id,
          start_at: Time.parse('2026-10-15T11:00'),
          end_at: Time.parse('2026-10-15T11:59'),
          capacity: 1,
          status: "open"
        )
      end

      it "does not allow overlapping session" do
        expect {
          post "/sessions", params: {
            tutor_session: {
              tutor: tutor,
              subject_id: subject_math.id,
              start_at: Time.parse('2026-10-15T11:30'),
              end_at: Time.parse('2026-10-15T12:30'),
              capacity: 1
            }
          }
        }.not_to change(TutorSession, :count)
        body = CGI.unescapeHTML(response.body)
        expect(body).to include("Session overlaps with existing session")
      end
    end
  end
end