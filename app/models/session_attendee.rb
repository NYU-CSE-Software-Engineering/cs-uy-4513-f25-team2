class SessionAttendee < ApplicationRecord
  belongs_to :tutor_session, class_name: 'TutorSession'
  belongs_to :learner

  validates :tutor_session, presence: true
  validates :learner, presence: true
end
