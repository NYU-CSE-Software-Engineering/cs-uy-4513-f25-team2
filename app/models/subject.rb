class Subject < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, uniqueness: { case_sensitive: false }
end