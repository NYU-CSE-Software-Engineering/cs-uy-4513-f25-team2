class TutorSession < ApplicationRecord
  validates :tutor , presence: true
  validates :subject, presence: true
  belongs_to :tutor
  belongs_to :subject
end
