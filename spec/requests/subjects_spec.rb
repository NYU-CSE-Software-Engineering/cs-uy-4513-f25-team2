require 'rails_helper'
require 'cgi'

RSpec.describe "Subjects", type: :request do
  let(:admin) { Admin.create!(email: "admin@example.com", password: "password123") }

  before do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_admin).and_return(admin)
  end

  describe "GET /subjects/new" do
    it "renders the new template" do
      get new_subject_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("New Subject")
    end
  end

  describe "POST /subjects" do
    it "creates a subject and redirects on success" do
      post subjects_path, params: { subject: { name: "Calculus", code: "MATH101" } }
      expect(response).to redirect_to(new_subject_path)
      follow_redirect!
      expect(response.body).to include("Subject created")
      expect(response.body).to include("Calculus")
      expect(response.body).to include("MATH101")
      expect(Subject.where(code: "MATH101")).to exist
    end

    it "re-renders with errors on failure (missing code)" do
      post subjects_path, params: { subject: { name: "Physics", code: "" } }
      expect(response).to have_http_status(:unprocessable_content) # 422 without Rack deprecation
      page_text = CGI.unescapeHTML(response.body)
      expect(page_text).to include("Code can't be blank")
    end
  end
end