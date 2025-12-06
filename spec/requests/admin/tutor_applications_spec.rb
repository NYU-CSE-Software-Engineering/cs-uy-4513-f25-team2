require 'rails_helper'

RSpec.describe "Admin::TutorApplications", type: :request do
    let!(:admin) do
    Admin.create!(
        email: "admin@example.com",
        password: "password123",
        first_name: "Admin",
        last_name: "User"
    )
    end

  let!(:learner) do
    Learner.create!(
      email: "learner@example.com",
      first_name: "John",
      last_name: "Doe",
      password: "password123"
    )
  end

  let!(:application) do
    TutorApplication.create!(
      learner: learner,
      reason: "I like teaching lol",
      status: "pending"
    )
  end

  describe "GET /admin/tutor_applications/new" do
    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_admin)
        .and_return(admin)
    end

    it "returns a successful response" do
      get "/admin/tutor_applications/new"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /admin/tutor_applications/:id/approve" do
    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_admin)
        .and_return(admin)
    end

    context "when valid parameters are passed" do
      it "approves the application and creates a Tutor record succesfully" do
        expect {
          post "/admin/tutor_applications/#{application.id}/approve"
        }.to change { Tutor.count }.by(1)

        application.reload
        expect(application.status).to eq("approved")
        expect(response).to have_http_status(:success).or have_http_status(:redirect)
        follow_redirect! if response.redirect?
        expect(response.body).not_to include("application_container_#{application.id}")
        expect(response.body).to include("Application approved successfully")
      end
    end
  end
end
