class Tutor < ApplicationRecord
    belongs_to :learner
    validates :learner_id, uniqueness: true
end