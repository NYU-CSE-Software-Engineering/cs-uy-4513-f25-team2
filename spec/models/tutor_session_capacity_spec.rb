require 'rails_helper'

RSpec.describe TutorSession, type: :model do
  describe "seat availability helpers" do
    let(:tutor_learner)  { Learner.create!(email: 'tutor@example.com', password: 'password123') }
    let(:tutor)          { Tutor.create!(learner: tutor_learner) }
    let(:subject_record) { Subject.create!(name: 'Linear Algebra', code: 'MATH201') }

    let(:session) do
      TutorSession.create!(
        tutor:    tutor,
        subject:  subject_record,
        start_at: 2.days.from_now.change(hour: 10),
        end_at:   2.days.from_now.change(hour: 11),
        capacity: 3,
        status:   'scheduled',
        meeting_link: 'https://zoom.us/capacity'
      )
    end

    it "counts only non-cancelled attendees" do
      learner1 = Learner.create!(email: 'l1@test.com', password: 'password123')
      learner2 = Learner.create!(email: 'l2@test.com', password: 'password123')
      learner3 = Learner.create!(email: 'l3@test.com', password: 'password123')

      SessionAttendee.create!(tutor_session: session, learner: learner1, cancelled: false)
      SessionAttendee.create!(tutor_session: session, learner: learner2, cancelled: false)
      SessionAttendee.create!(tutor_session: session, learner: learner3, cancelled: true)

      expect(session.active_attendee_count).to eq(2)
    end

    it "computes seats_remaining correctly" do
      learner1 = Learner.create!(email: 's1@test.com', password: 'password123')
      learner2 = Learner.create!(email: 's2@test.com', password: 'password123')

      SessionAttendee.create!(tutor_session: session, learner: learner1, cancelled: false)
      SessionAttendee.create!(tutor_session: session, learner: learner2, cancelled: false)

      expect(session.seats_remaining).to eq(1)
      expect(session.full?).to eq(false)
    end

    it "detects when a session is full" do
      session.update!(capacity: 2)

      learner1 = Learner.create!(email: 'f1@test.com', password: 'password123')
      learner2 = Learner.create!(email: 'f2@test.com', password: 'password123')

      SessionAttendee.create!(tutor_session: session, learner: learner1, cancelled: false)
      SessionAttendee.create!(tutor_session: session, learner: learner2, cancelled: false)

      expect(session.active_attendee_count).to eq(2)
      expect(session.seats_remaining).to eq(0)
      expect(session.full?).to eq(true)
    end
  end
end