class Tutor < ApplicationRecord
    validates :tutor_name, presence: true
    validates :rating_avg, numericality: { allow_nil: true }
end