require "rails_helper"

RSpec.describe Admin, type: :model do
  describe "validations" do
    it "is invalid without email" do
      admin = Admin.new(password: "secret")
      expect(admin).not_to be_valid
      expect(admin.errors[:email]).to include("can't be blank")
    end

    it "is invalid without password" do
      admin = Admin.new(email: "admin@site.com")
      expect(admin).not_to be_valid
      expect(admin.errors[:password]).to include("can't be blank")
    end

    it "requires email to be unique case-insensitively" do
      Admin.create!(email: "admin@site.com", password: "x")
      dup = Admin.new(email: "ADMIN@site.com", password: "y")
      expect(dup).not_to be_valid
      expect(dup.errors[:email]).to include("has already been taken")
    end
  end
end