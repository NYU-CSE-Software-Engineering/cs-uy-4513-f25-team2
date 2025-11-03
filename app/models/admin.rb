class Admin < ApplicationRecord
  validates :email,    presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true
end