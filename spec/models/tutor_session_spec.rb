require 'rails_helper'

RSpec.describe TutorSession, type: :model do
  context 'validations' do
    # helper methods to define a learner, tutor, and subject
    let(:learner_record) {Learner.create!(email: 'jane_doe@example.com', password: 'password123')}
    let(:tutor_learner) {Learner.create!(email: 'jane_doe2@example.com', password: 'password123')}
    let(:tutor_record) {Tutor.create!(learner: tutor_learner)}
    let(:subject_record) {Subject.create!(name: 'Calculus', code: 'MATH101')}

    it 'is invalid without tutor' do
      s = TutorSession.new(
        subject: subject_record,
        start_at: 1.hour.from_now,
        end_at: 2.hours.from_now,
        capacity: 3
      )
      expect(s).not_to be_valid
      expect(s.errors[:tutor]).to include("can't be blank")
    end

    it 'is invalid without a subject' do
      s = TutorSession.new(
        tutor: tutor_record,
        start_at: 1.hour.from_now,
        end_at: 2.hours.from_now,
        capacity: 3
      )
      expect(s).not_to be_valid
      expect(s.errors[:subject]).to include("can't be blank")
    end

    it 'is invalid without start_at' do
      s = TutorSession.new(
        tutor: tutor_record,
        subject: subject_record,
        end_at: 2.hours.from_now,
        capacity: 3
      )
      expect(s).not_to be_valid
      expect(s.errors[:start_at]).to include("can't be blank")
    end
  end
end
