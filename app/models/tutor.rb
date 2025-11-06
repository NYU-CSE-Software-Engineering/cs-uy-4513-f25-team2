class Tutor < ApplicationRecord
    belongs_to :learner
    has_many :teaches, dependent: :destroy
    has_many :subjects, through: :teaches
    
    validates :learner, uniqueness: true
    validates :rating_avg, numericality: { 
        allow_nil: true, 
        greater_than_or_equal_to: 0, 
        less_than_or_equal_to: 5 
    }
    validates :rating_count, numericality: { 
        allow_nil: true,
        only_integer: true,
        greater_than_or_equal_to: 0
    }
end