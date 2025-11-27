require "rails_helper"

RSpec.describe Learner, type: :model do
  describe "validations" do
    it "is invalid without email" do
      learner = Learner.new(password: "secret")
      expect(learner).not_to be_valid
      expect(learner.errors[:email]).to include("can't be blank")
    end

    it "is invalid without password" do
      learner = Learner.new(email: "a@b.com")
      expect(learner).not_to be_valid
      expect(learner.errors[:password]).to include("can't be blank")
    end

    it "requires email to be unique case-insensitively" do
      Learner.create!(email: "user@site.com", password: "x")
      dup = Learner.new(email: "USER@site.com", password: "y")
      expect(dup).not_to be_valid
      expect(dup.errors[:email]).to include("has already been taken")
    end
  end
end