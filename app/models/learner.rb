class Learner < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  # A learner can be booked into many tutor sessions via session_attendees
  has_many :session_attendees, dependent: :destroy
  has_many :tutor_sessions, through: :session_attendees
end
