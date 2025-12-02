require "rails_helper"
require "cgi"

RSpec.describe "TutorApplications", type: :request do
  let!(:learner) { Learner.create!(
      email: "test@example.com",
      password: "password123",
      first_name: "Test",
      last_name: "Learner"
    )}

  describe "GET /tutor_applications/new" do
    it "renders the new template" do
      get new_tutor_application_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Apply To Be A Tutor")
    end
  end

  describe "POST /tutor_applications" do
    it "creates a TutorApplication with the current learner, pending status, and submitted reason" do
      # set the current logged-in user as this fake user we made
      allow_any_instance_of(ApplicationController).to receive(:current_learner).and_return(learner)
      post "/tutor_applications", params: {
        tutor_application: { reason: "I like helping others" }
      }

      expect(TutorApplication.count).to eq(1)
      expect(response).to render_template(:new)

      application = TutorApplication.last

      expect(application.learner_id).to eq(learner.id)
      expect(application.status).to eq("pending")
      expect(application.reason).to eq("I like helping others")
    end
  end
end
