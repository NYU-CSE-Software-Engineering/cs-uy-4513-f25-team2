class Feedback < ApplicationRecord
  belongs_to :tutor_session
  belongs_to :learner

  validates :rating, presence: true,
                     inclusion: { in: 1..5 }
  validates :comment, presence: true

  validates :learner_id, uniqueness: {
    scope: :tutor_session_id,
    message: "has already submitted feedback for this session"
  }
end
