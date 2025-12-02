require "rails_helper"
RSpec.describe TutorApplication, type: :model do
  context 'validations' do
    it "is invalid without a reason" do
      app = TutorApplication.new(reason: nil)

      expect(app).not_to be_valid
      expect(app.errors[:reason]).to include("can't be blank")
    end

    it "is invalid without a status" do
      app = TutorApplication.new(status: nil)
      expect(app).not_to be_valid
      expect(app.errors[:status]).to include("can't be blank")
    end

    it "is valid when status is pending or approved" do
      learner = Learner.create!(
        email: "test@example.com",
        password: "password123",
        first_name: "Test",
        last_name: "Learner"
      )

      app = TutorApplication.new(status: "pending", reason: "I love teaching", learner: learner)
      expect(app).to be_valid

      app = TutorApplication.new(status: "approved", reason: "I love teaching", learner: learner)
      expect(app).to be_valid

      app = TutorApplication.new(status: "denied", reason: "I love teaching", learner: learner)
      expect(app).not_to be_valid
      expect(app.errors[:status]).to include("is not included in the list")
    end

    it "is invalid without a learner" do
      app = TutorApplication.new(reason: "I love teaching", status: "pending", learner: nil)
      expect(app).not_to be_valid
      expect(app.errors[:learner]).to include("must exist")
    end
  end
end
