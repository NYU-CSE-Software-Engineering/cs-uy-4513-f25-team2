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
      expect(attendee.errors[:tutor_session]).to include("can't be blank")
    end

    it 'is invalid without learner' do
      attendee = SessionAttendee.new(tutor_session: session1)
      expect(attendee).not_to be_valid
      expect(attendee.errors[:learner]).to include("can't be blank")
    end

    it 'is invalid when session is at full capacity' do
      attendee1 = SessionAttendee.create!(tutor_session: session1, learner: learner1)
      attendee2 = SessionAttendee.create!(tutor_session: session1, learner: learner2)
      # Session1 is already at fully capacity from attendee1 and attendee2
      attendee3 = SessionAttendee.new(tutor_session: session1, learner: learner3)
      expect(attendee3).not_to be_valid
      expect(attendee3.errors[:base]).to include("This session is full")
    end

    it 'is invalid when learner is already booked for the same session (double booking)' do
      SessionAttendee.create!(tutor_session: session1, learner: learner1)
      dupe = SessionAttendee.new(tutor_session: session1, learner: learner1)
      expect(dupe).not_to be_valid
      expect(dupe.errors[:learner_id]).to include("is already booked for this session")
    end
    it 'is invalid when learner has a conflicting session (overlapping times)' do
      # Book learner1 for session1 (10:00-11:00)
      SessionAttendee.create!(tutor_session: session1, learner: learner1)

      # Try to book same learner for conflicting_session (10:30-11:30)
      conflicting_attendee = SessionAttendee.new(tutor_session: conflicting_session, learner: learner1)

      expect(conflicting_attendee).not_to be_valid
      expect(conflicting_attendee.errors[:base]).to include("This session conflicts with another session")
    end
  end

  context 'associations' do
    it 'belongs to a tutor_session and a learner' do
        attendee = SessionAttendee.new(tutor_session: session1, learner: learner1)
        expect(attendee.tutor_session.start_at).to eq(Time.zone.parse('2026-03-10T10:00:00Z'))
        expect(attendee.tutor_session.end_at).to eq(Time.zone.parse('2026-03-10T11:00:00Z'))
        expect(attendee.learner.email).to eq('learner1@example.com')
    end
  end
end
