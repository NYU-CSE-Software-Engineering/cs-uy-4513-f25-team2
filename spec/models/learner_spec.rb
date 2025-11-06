require 'rails_helper'

RSpec.describe Learner, type: :model do
  context 'validations' do
    it 'is invalid without an email' do
      l = Learner.new(password: "password")
      expect(l).not_to be_valid
      expect(l.errors[:email]).to include("can't be blank")
    end
  end
end
