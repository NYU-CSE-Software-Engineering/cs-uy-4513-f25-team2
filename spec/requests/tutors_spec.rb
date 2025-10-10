require 'rails_helper'

RSpec.describe "Tutors", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/tutors/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/tutors/show"
      expect(response).to have_http_status(:success)
    end
  end

end
