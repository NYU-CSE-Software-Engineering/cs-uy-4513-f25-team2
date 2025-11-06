class Teach < ApplicationRecord
    validates :tutor, uniqueness: { scope: :subject }
end