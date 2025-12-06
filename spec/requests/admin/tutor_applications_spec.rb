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
end
