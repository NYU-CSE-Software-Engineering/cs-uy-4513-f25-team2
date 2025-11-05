require 'rails_helper'

RSpec.describe Learner, type: :model do
  context 'validations' do
    it 'is invalid without an email' do
      l = Learner.new(password: "password")
      expect(l).not_to be_valid
      expect(l.errors[:email]).to include("can't be blank")
    end

    it 'is invalid without a password' do
      l = Learner.new(email: "example@email.com")
      expect(l).not_to be_valid
      expect(l.errors[:password]).to include("can't be blank")
    end

    it 'enforces case-insensitive unique email' do
      Learner.create!(email: "learner@email.com", password: "password")
      dup = Learner.new(email: "LEARNER@email.com", password: "pass")
      expect(dup).not_to be_valid
      expect(dup.errors[:email]).to include('has already been taken')
    end
  end
end
