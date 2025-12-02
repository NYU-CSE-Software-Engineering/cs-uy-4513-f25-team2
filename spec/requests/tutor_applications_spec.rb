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
    before do
      allow_any_instance_of(ApplicationController).to receive(:current_learner).and_return(learner)
    end

    context "when learner has no existing tutor application" do
      it "renders the page and indicates no application exists" do
        get "/tutor_applications/new"

        expect(response).to have_http_status(:ok)
        expect(assigns(:tutor_application_status)).to eq(:none)
      end
    end

    context "when learner has a pending tutor application" do
      before do
        TutorApplication.create!(
          learner_id: learner.id,
          reason: "I want to help others",
          status: "pending"
        )
      end
      it "renders the page and indicates pending status" do
        get "/tutor_applications/new"
        expect(response).to have_http_status(:ok)
        expect(assigns(:tutor_application_status)).to eq(:pending)
      end
    end

    context "when learner has an approved tutor application" do
      before do
        TutorApplication.create!(
          learner_id: learner.id,
          reason: "I want to help others",
          status: "approved"
        )
      end
      it "renders the page and indicates approved status" do
        get "/tutor_applications/new"
        expect(response).to have_http_status(:ok)
        expect(assigns(:tutor_application_status)).to eq(:approved)
      end
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
