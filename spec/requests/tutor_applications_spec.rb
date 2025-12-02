require "rails_helper"
require "cgi"

RSpec.describe "TutorApplications", type: :request do
  describe "GET /tutor_applications/new" do
    it "renders the new template" do
      get new_tutor_application_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Apply To Be A Tutor")
    end
  end
end
