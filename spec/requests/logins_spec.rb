require "rails_helper"

RSpec.describe "Logins", type: :request do
  describe "GET /login" do
    it "renders the login page" do
      get new_login_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Log in")
    end
  end

  describe "POST /login" do
    it "logs in learner and redirects to home on success" do
      Learner.create!(email: "ok@site.com", password: "secret")
      post login_path, params: { email: "ok@site.com", password: "secret" }
      expect(response).to redirect_to(home_path)
    end

    it "re-renders login with error on invalid credentials" do
      Learner.create!(email: "ok@site.com", password: "secret")
      post login_path, params: { email: "ok@site.com", password: "NOPE" }
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include("Invalid email or password")
    end
  end

  describe "DELETE /logout" do
    it "logs out and redirects to login page" do
      delete logout_path
      expect(response).to redirect_to(new_login_path)
    end
  end
end