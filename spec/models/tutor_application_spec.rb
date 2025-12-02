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
  end
end
