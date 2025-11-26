require 'rails_helper'

RSpec.describe Session, type: :model do
  context 'validations' do
    let(:learner_record) {Learner.create!(email: 'jane_doe@example.com', password: 'password123')}
    let(:tutor_record) {Tutor.create!(learner: Learner.create!(Learner.create!(email: 'jane_doe2@example.com', password: 'password123')))}
    let(:subject_record) {Subject.create!(name: 'Calculus', code: 'MATH101')}

    it 'is invalid without tutor' do
      s = Session.new(subject: subject_record)
      expect(a).not_to be_valid
      expect(a.errors[:email]).to include("can't be blank")
    end

  end
end
