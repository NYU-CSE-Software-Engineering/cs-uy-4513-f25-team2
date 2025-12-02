require 'rails_helper'

RSpec.describe Feedback, type: :model do
  let(:learner) do
    Learner.create!(
      email: 'learner@example.com',
      password: 'password123',
      first_name: 'Jane',
      last_name: 'Doe'
    )
  end

  let(:tutor_learner) do
    Learner.create!(
      email: 'tutor@example.com',
      password: 'password123',
      first_name: 'Test',
      last_name: 'Tutor'
    )
  end

  let(:tutor) do
    Tutor.create!(learner: tutor_learner, bio: 'Math & CS')
  end

  let(:subject) do
    Subject.create!(name: 'Calculus', code: 'MATH101')
  end

  let(:tutor_session) do
    TutorSession.create!(
      tutor: tutor,
      subject: subject,
      start_at: 5.days.ago,
      end_at: 4.days.ago,
      capacity: 5,
      status: 'completed'
    )
  end

  describe 'validations' do
    it 'is invalid without a score' do
      feedback = Feedback.new(
        tutor_session: tutor_session,
        learner: learner,
        tutor: tutor,
        comment: 'Great session!'
      )
      expect(feedback).not_to be_valid
      expect(feedback.errors[:score]).to include("can't be blank")
    end

    it 'is invalid without a comment' do
      feedback = Feedback.new(
        tutor_session: tutor_session,
        learner: learner,
        tutor: tutor,
        score: 5
      )
      expect(feedback).not_to be_valid
      expect(feedback.errors[:comment]).to include("can't be blank")
    end

    it 'is invalid with score less than 1' do
      feedback = Feedback.new(
        tutor_session: tutor_session,
        learner: learner,
        tutor: tutor,
        score: 0,
        comment: 'Test comment'
      )
      expect(feedback).not_to be_valid
      expect(feedback.errors[:score]).to be_present
    end

    it 'is invalid with score greater than 5' do
      feedback = Feedback.new(
        tutor_session: tutor_session,
        learner: learner,
        tutor: tutor,
        score: 6,
        comment: 'Test comment'
      )
      expect(feedback).not_to be_valid
      expect(feedback.errors[:score]).to be_present
    end

    it 'is invalid with non-integer score' do
      feedback = Feedback.new(
        tutor_session: tutor_session,
        learner: learner,
        tutor: tutor,
        score: 4.5,
        comment: 'Test comment'
      )
      expect(feedback).not_to be_valid
      expect(feedback.errors[:score]).to be_present
    end

    it 'is valid with score between 1 and 5' do
      feedback = Feedback.new(
        tutor_session: tutor_session,
        learner: learner,
        tutor: tutor,
        score: 5,
        comment: 'Great session!'
      )
      expect(feedback).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to tutor_session' do
      feedback = Feedback.create!(
        tutor_session: tutor_session,
        learner: learner,
        tutor: tutor,
        score: 5,
        comment: 'Test comment'
      )
      expect(feedback.tutor_session).to eq(tutor_session)
    end

    it 'belongs to learner' do
      feedback = Feedback.create!(
        tutor_session: tutor_session,
        learner: learner,
        tutor: tutor,
        score: 5,
        comment: 'Test comment'
      )
      expect(feedback.learner).to eq(learner)
    end

    it 'belongs to tutor' do
      feedback = Feedback.create!(
        tutor_session: tutor_session,
        learner: learner,
        tutor: tutor,
        score: 5,
        comment: 'Test comment'
      )
      expect(feedback.tutor).to eq(tutor)
    end
  end
end
