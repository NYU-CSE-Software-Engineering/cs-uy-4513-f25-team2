class SessionAttendee < ApplicationRecord
  belongs_to :tutor_session, class_name: 'TutorSession'
  belongs_to :learner

  validates :tutor_session, presence: true
  validates :learner, presence: true

  # double booking validation
  validates :learner_id, uniqueness: {
    scope: :tutor_session_id,
    message: 'is already booked for this session'
  }

  validate :session_not_full
  validate :time_conflicts

  # Scopes to retrieve bookings for a given learner
  scope :for_learner, ->(learner) { where(learner:) }

  scope :upcoming_for, ->(learner) {
    for_learner(learner)
      .joins(:tutor_session)
      .where(cancelled: false)
      .where('tutor_sessions.start_at >= ?', Time.current)
      .order('tutor_sessions.start_at ASC')
  }

  scope :past_for, ->(learner) {
    for_learner(learner)
      .joins(:tutor_session)
      .where(cancelled: false)
      .where('tutor_sessions.start_at < ?', Time.current)
      .order('tutor_sessions.start_at DESC')
  }

  def session_not_full
    return unless tutor_session

    # get the number of people already signed up for the session
    attendee_count = SessionAttendee.where(tutor_session_id: tutor_session.id).count

    # When a new SessionAttendee is being created, check if it there is over capacity
    if new_record? && attendee_count >= tutor_session.capacity
      errors.add(:base, "This session is full")
    end
  end

  def time_conflicts
    return unless learner && tutor_session

    # get all sessions the learner is booked for
    learner_sessions = SessionAttendee
      .where(learner_id: learner.id)
      .where.not(tutor_session_id: tutor_session.id)
      .includes(:tutor_session)

    # check for time overlaps
    learner_sessions.each do |attendee|
      existing_session = attendee.tutor_session

      if tutor_session.start_at < existing_session.end_at &&
          tutor_session.end_at > existing_session.start_at
        errors.add(:base, "This session conflicts with another session")
        break
      end
    end
  end
end