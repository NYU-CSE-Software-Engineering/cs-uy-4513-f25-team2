class TutorSession < ApplicationRecord
  belongs_to :tutor
  belongs_to :subject
  has_many :session_attendees
  has_many :learners, through: :session_attendees

  validates :tutor, presence: true
  validates :subject, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :capacity, presence: true, numericality: {greater_than: 0}
  validates :status, presence: true
  validate :end_at_after_start_at

  def end_at_after_start_at
    return if end_at.blank? || start_at.blank?

    if end_at <= start_at
      errors.add(:end_at, "must be after start time")
    end
  end
end
