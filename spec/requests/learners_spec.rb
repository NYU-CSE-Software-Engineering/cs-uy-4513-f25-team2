require "rails_helper"
require "cgi"

RSpec.describe "Learners", type: :request do
  describe "GET /learners/new" do
    it "renders the sign-up page" do
      get new_learner_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Sign up")
    end
  end

  describe "POST /learners" do
    it "creates a learner and redirects with notice on success" do
      post learners_path, params: { learner: { email: "new@user.com", password: "secret" } }
      expect(response).to redirect_to(new_login_path)
      follow_redirect!
      expect(response.body).to include("Account Created!")
    end

    it "re-renders with errors when email missing" do
      post learners_path, params: { learner: { email: "", password: "x" } }
      expect(response).to have_http_status(:unprocessable_content)
      body = CGI.unescapeHTML(response.body)
      expect(body).to include("Email can't be blank")
    end

    it "re-renders with errors when password missing" do
      post learners_path, params: { learner: { email: "x@y.com", password: "" } }
      expect(response).to have_http_status(:unprocessable_content)
      body = CGI.unescapeHTML(response.body)
      expect(body).to include("Password can't be blank")
    end

    it "re-renders with errors when email is taken" do
      Learner.create!(email: "dup@site.com", password: "p")
      post learners_path, params: { learner: { email: "DUP@site.com", password: "p" } }
      expect(response).to have_http_status(:unprocessable_content)
      body = CGI.unescapeHTML(response.body)
      expect(body).to include("Email has already been taken")
    end
  end
end