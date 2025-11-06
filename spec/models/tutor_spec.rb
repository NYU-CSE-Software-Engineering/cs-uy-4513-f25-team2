require 'rails_helper'

RSpec.describe Tutor, type: :model do
    context 'validations' do
        it 'is invalid without a learner' do
            t = Tutor.new(bio: '4 years of experience tutoring Calculus')
            expect(t).not_to be_valid
            expect(t.errors[:learner]).to include("must exist")
        end

        it 'requires learner to be unique' do
            l = Learner.create!(email: 'jane_doe@example.com', password: 'password123')
            Tutor.create!(learner: l)
            dup_tutor = Tutor.new(learner: l)
            expect(dup_tutor).not_to be_valid
            expect(dup_tutor.errors[:learner_id]).to include('has already been taken')
        end

        it 'requires rating_avg to be a number' do
            l = Learner.create!(email: 'jane_doe@example.com', password: 'password123')
            t = Tutor.new(learner: l, rating_avg: 'rating')
            expect(t).not_to be_valid
            expect(t.errors[:rating_avg]).to include("is not a number")
        end
    end
end