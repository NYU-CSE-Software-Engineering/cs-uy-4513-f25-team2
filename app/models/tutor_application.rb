class TutorApplication < ApplicationRecord
    belongs_to :learner
    has_one_attached :resume

    validates :reason, presence: true


end