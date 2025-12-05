require 'rails_helper'

RSpec.describe "Admin::Tutors", type: :request do
  let(:admin) { Admin.create!(email: "admin@example.com", password: "password123") }
  let(:learner) { Learner.create!(email: "learner@example.com", password: "password123") }
  let(:tutor) { Tutor.create!(learner: learner) }

  before do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_admin).and_return(admin)
  end

  describe "GET /admin/tutors" do
    it "renders the index template" do
      get admin_tutors_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /admin/tutors/:id" do
    it "destroys the tutor and redirects with a success message" do
      tutor # Ensure tutor is created
      expect {
        delete admin_tutor_path(tutor)
      }.to change(Tutor, :count).by(-1)
      
      expect(response).to redirect_to(admin_tutors_path)
      follow_redirect!
      expect(response.body).to include("Tutor privilege revoked")
    end
  end
end

