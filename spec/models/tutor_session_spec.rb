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
        capacity: 3,
        meeting_link: "https://zoom.us/test"
      )
      expect(s).not_to be_valid
      expect(s.errors[:tutor]).to include("can't be blank")
    end

    it 'is invalid without a subject' do
      s = TutorSession.new(
        tutor: tutor_record,
        start_at: 1.hour.from_now,
        end_at: 2.hours.from_now,
        capacity: 3,
        meeting_link: "https://zoom.us/test"
      )
      expect(s).not_to be_valid
      expect(s.errors[:subject]).to include("can't be blank")
    end

    it 'is invalid without start_at time' do
      s = TutorSession.new(
        tutor: tutor_record,
        subject: subject_record,
        end_at: 2.hours.from_now,
        capacity: 3,
        meeting_link: "https://zoom.us/test"
      )
      expect(s).not_to be_valid
      expect(s.errors[:start_at]).to include("can't be blank")
    end

    it 'is invalid without end_at time' do
      s = TutorSession.new(
        tutor: tutor_record,
        subject: subject_record,
        start_at: 1.hour.from_now,
        capacity: 3,
        meeting_link: "https://zoom.us/test"
      )
      expect(s).not_to be_valid
      expect(s.errors[:end_at]).to include("can't be blank")
    end

    it 'is invalid without capacity' do
      s = TutorSession.new(
        tutor: tutor_record,
        subject: subject_record,
        start_at: 1.hour.from_now,
        meeting_link: "https://zoom.us/test"
      )
      expect(s).not_to be_valid
      expect(s.errors[:capacity]).to include("can't be blank")
    end

    it 'is invalid without status' do
      s = TutorSession.new(
        tutor: tutor_record,
        subject: subject_record,
        start_at: 1.hour.from_now,
        end_at: 2.hours.from_now,
        capacity: 3,
        meeting_link: "https://zoom.us/test"
      )
      expect(s).not_to be_valid
      expect(s.errors[:status]).to include("can't be blank")
    end

    it 'is invalid without a meeting_link' do
      s = TutorSession.new(
        tutor: tutor_record,
        subject: subject_record,
        start_at: 1.hour.from_now,
        end_at: 2.hours.from_now,
        capacity: 3,
        status: 'scheduled',
        meeting_link: nil
      )
      expect(s).not_to be_valid
      expect(s.errors[:meeting_link]).to include("can't be blank")
    end

    it 'is invalid with a negative or 0 capacity' do
      s = TutorSession.new(
        tutor: tutor_record,
        subject: subject_record,
        start_at: 1.hour.from_now,
        end_at: 2.hours.from_now,
        capacity: -1,
        meeting_link: "https://zoom.us/test"
      )
      expect(s).not_to be_valid
      expect(s.errors[:capacity]).to include("must be greater than 0")
    end

    it 'is invalid with an end_at time beforee start_at time' do
      s = TutorSession.new(
        tutor: tutor_record,
        subject: subject_record,
        start_at: 2.hour.from_now,
        end_at: 1.hours.from_now,
        capacity: 2,
        meeting_link: "https://zoom.us/test"
      )
      expect(s).not_to be_valid
      expect(s.errors[:end_at]).to include("must be after start time")
    end

    it 'is invalid if session overlaps with existing session for same tutor' do
      # existing session
      TutorSession.create!(
        tutor: tutor_record,
        subject: subject_record,
        start_at: Time.zone.parse('2026-04-11T10:00:00Z'),
        end_at: Time.zone.parse('2026-04-11T11:00:00Z'),
        capacity: 1,
        status: 'open',
        meeting_link: "https://zoom.us/existing"
      )
      # new session
      s = TutorSession.new(
        tutor: tutor_record,
        subject: subject_record,
        start_at: Time.zone.parse('2026-04-11T10:30:00Z'),
        end_at: Time.zone.parse('2026-04-11T11:30:00Z'),
        capacity: 1,
        meeting_link: "https://zoom.us/new"
      )
      expect(s).not_to be_valid
      expect(s.errors[:start_at]).to include("Session overlaps with existing session")
    end

  end
end