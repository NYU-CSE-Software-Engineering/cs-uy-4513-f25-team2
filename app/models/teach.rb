class Teach < ApplicationRecord
    belongs_to :tutor
    belongs_to :subject
end