class TutorSession < ApplicationRecord
  belongs_to :tutor
  belongs_to :subject

  validates :tutor , presence: true
  validates :subject, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :capacity, presence: true, numericality: {greater_than: 0}
  validates :status, presence: true
end
