class Tutor < ApplicationRecord
    belongs_to :learner
    validates :learner_id, uniqueness: true
    validates :rating_avg, numericality: { allow_nil: true }
end