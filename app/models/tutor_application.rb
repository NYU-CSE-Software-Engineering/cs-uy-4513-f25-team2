class TutorApplication < ApplicationRecord
    belongs_to :learner
    has_one_attached :resume
end