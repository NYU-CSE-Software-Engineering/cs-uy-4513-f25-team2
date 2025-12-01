class TutorApplication < ApplicationRecord


    validates :reason, presence: true
    validates :status, presence: true


end