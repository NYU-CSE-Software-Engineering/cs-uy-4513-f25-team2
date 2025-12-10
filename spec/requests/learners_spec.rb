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
    let(:valid_params) do
      {
        learner: {
          first_name: "First",
          last_name: "Last",
          email: "new@user.com",
          password: "secret123",
          password_confirmation: "secret123"
        }
      }
    end

    it "creates a learner and redirects with notice on success" do
      expect do
        post learners_path, params: valid_params
      end.to change(Learner, :count).by(1)

      expect(response).to redirect_to(new_login_path)
      follow_redirect!
      expect(response.body).to include("Account Created!")
    end

    it "re-renders with errors when email is missing" do
      params = valid_params.dup
      params[:learner] = params[:learner].dup
      params[:learner][:email] = ""

      post learners_path, params: params
      expect(response).to have_http_status(:unprocessable_content)

      body = CGI.unescapeHTML(response.body)
      expect(body).to include("Email can't be blank")
    end

    it "re-renders with errors when password is missing" do
      params = valid_params.dup
      params[:learner] = params[:learner].dup
      params[:learner][:password] = ""
      params[:learner][:password_confirmation] = ""

      post learners_path, params: params
      expect(response).to have_http_status(:unprocessable_content)

      body = CGI.unescapeHTML(response.body)
      expect(body).to include("Password can't be blank")
    end

    it "re-renders with errors when email is taken (case-insensitive)" do
      Learner.create!(
        first_name: "Existing",
        last_name: "User",
        email: "dup@site.com",
        password: "password",
        password_confirmation: "password"
      )

      params = valid_params.dup
      params[:learner] = params[:learner].dup
      params[:learner][:email] = "DUP@site.com"

      post learners_path, params: params
      expect(response).to have_http_status(:unprocessable_content)

      body = CGI.unescapeHTML(response.body)
      expect(body).to include("Email has already been taken")
    end
  end
end