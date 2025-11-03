class Learner < ApplicationRecord
  validates :email,    presence: { message: 'is required' },
                       uniqueness: { case_sensitive: false, message: 'has already been taken.' }
  validates :password, presence: { message: 'is required' }
end
