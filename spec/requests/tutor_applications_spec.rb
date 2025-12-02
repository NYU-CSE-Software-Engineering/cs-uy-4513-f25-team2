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
    before do
      allow_any_instance_of(ApplicationController).to receive(:current_learner).and_return(learner)
    end

    context "when valid parameters are passed" do
      let(:valid_params) do { tutor_application: { reason: "I like helping others" } } end

      it "creates a TutorApplication with pending status and redirects/rerenders correctly" do
        expect {
          post "/tutor_applications", params: valid_params
        }.to change(TutorApplication, :count).by(1)

        application = TutorApplication.last
        expect(application.learner_id).to eq(learner.id)
        expect(application.status).to eq("pending")
        expect(application.reason).to eq("I like helping others")
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash[:notice]).to eq("Application Sent!")
      end
    end

    context "when invalid parameters are passed" do
      let(:invalid_params) do { tutor_application: { reason: "" } } end

      it "does not create a TutorApplication and rerenders the new template with flash notice" do
        expect { post "/tutor_applications", params: invalid_params }.not_to change(TutorApplication, :count)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash[:alert]).to eq("Could Not Apply")
      end
    end
  end
end
