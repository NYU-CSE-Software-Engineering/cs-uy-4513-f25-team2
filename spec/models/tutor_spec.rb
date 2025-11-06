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
            expect(dup_tutor.errors[:learner]).to include('has already been taken')
        end

        it 'requires rating_avg to be a number' do
            l = Learner.create!(email: 'jane_doe@example.com', password: 'password123')
            t = Tutor.new(learner: l, rating_avg: 'rating')
            expect(t).not_to be_valid
            expect(t.errors[:rating_avg]).to include("is not a number")
        end

        it 'requires rating_avg to be between 0 and 5' do
            l1 = Learner.create!(email: 'jane_doe@example.com', password: 'password123')
            l2 = Learner.create!(email: 'john_smith@example.com', password: 'password123')
            t1 = Tutor.new(learner: l1, rating_avg: -0.5)
            t2 = Tutor.new(learner: l2, rating_avg: 7.2)
            expect(t1).not_to be_valid
            expect(t2).not_to be_valid
            expect(t1.errors[:rating_avg]).to include("must be greater than or equal to 0")
            expect(t2.errors[:rating_avg]).to include("must be less than or equal to 5")
        end

        it 'requires rating_count to be an integer' do
            l1 = Learner.create!(email: 'jane_doe@example.com', password: 'password123')
            l2 = Learner.create!(email: 'john_smith@example.com', password: 'password123')
            t1 = Tutor.new(learner: l1, rating_count: 'rating')
            t2 = Tutor.new(learner: l2, rating_count: 9.42)
            expect(t1).not_to be_valid
            expect(t2).not_to be_valid
            expect(t1.errors[:rating_count]).to include("is not a number")
            expect(t2.errors[:rating_count]).to include("must be an integer")
        end

        it 'requires rating_count to be non-negative' do
            l = Learner.create!(email: 'jane_doe@example.com', password: 'password123')
            t = Tutor.new(learner: l, rating_count: -5)
            expect(t).not_to be_valid
            expect(t.errors[:rating_count]).to include("must be greater than or equal to 0")
        end
    end
end