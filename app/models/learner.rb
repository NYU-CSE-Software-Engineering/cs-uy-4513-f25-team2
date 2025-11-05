class Learner < ApplicationRecord
  validates :email, presence: true
end
