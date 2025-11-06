class Tutor < ApplicationRecord
    belongs_to :learner
    validates :learner_id, uniqueness: true
    validates :rating_avg, numericality: { 
        allow_nil: true, 
        greater_than_or_equal_to: 0, 
        less_than_or_equal_to: 5 
    }
end