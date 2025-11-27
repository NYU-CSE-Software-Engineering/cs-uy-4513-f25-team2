class SessionAttendee < ApplicationRecord
  belongs_to :tutor_session, class_name: 'TutorSession'
  belongs_to :learner

  validates :tutor_session, presence: true
  validates :learner, presence: true
  validate :session_not_full

  def session_not_full
    return unless tutor_session
    # get the number of people already signed up for the session
    attendee_count = SessionAttendee.where(tutor_session_id: tutor_session.id).count
    # When a new SessionAttendee is being created, check if it there is over capacity
    if new_record? && attendee_count >= tutor_session.capacity
      errors.add(:base, "This session is full")
    end
  end
end
