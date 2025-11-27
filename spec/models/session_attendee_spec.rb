require 'rails_helper'

RSpec.describe SessionAttendee, type: :model do
  # Set up helpers
  let(:learner1) { Learner.create!(email: 'learner1@example.com', password: 'password123') }
  let(:learner2) { Learner.create!(email: 'learner2@example.com', password: 'password123') }
  let(:learner3) { Learner.create!(email: 'learner3@example.com', password: 'password123') }
  
  let(:tutor_learner) { Learner.create!(email: 'tutor@example.com', password: 'password123') }
  let(:tutor) { Tutor.create!(learner: tutor_learner) }
  
  let(:subject_record) { Subject.create!(name: 'Calculus', code: 'MATH101') }
  
  let(:session1) do
    TutorSession.create!(
      tutor: tutor,
      subject: subject_record,
      start_at: Time.zone.parse('2026-03-10T10:00:00Z'),
      end_at: Time.zone.parse('2026-03-10T11:00:00Z'),
      capacity: 2,
      status: 'scheduled'
    )
  end
  
  let(:session2) do
    TutorSession.create!(
      tutor: tutor,
      subject: subject_record,
      start_at: Time.zone.parse('2026-03-10T14:00:00Z'),
      end_at: Time.zone.parse('2026-03-10T15:00:00Z'),
      capacity: 3,
      status: 'scheduled'
    )
  end 

  let(:conflicting_session) do
    TutorSession.create!(
      tutor: tutor,
      subject: subject_record,
      start_at: Time.zone.parse('2026-03-10T10:30:00Z'),
      end_at: Time.zone.parse('2026-03-10T11:30:00Z'),
      capacity: 2,
      status: 'scheduled'
    )
  end

  context 'validations' do
    it 'is invalid without tutor_session' do
      attendee = SessionAttendee.new(learner: learner1)
      expect(attendee).not_to be_valid
      expect(attendee.errors[:tutorsession]).to include("can't be blank")
    end

    it 'is invalid without learner' do
      attendee = SessionAttendee.new(tutorsession: session1)
      expect(attendee).not_to be_valid
      expect(attendee.errors[:learner]).to include("can't be blank")
    end
  end

  context 'associations' do
  end
end
