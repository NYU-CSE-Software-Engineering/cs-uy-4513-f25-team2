class TutorSession < ApplicationRecord
  validates :tutor , presence: true
  belongs_to :tutor
  belongs_to :subject
end
