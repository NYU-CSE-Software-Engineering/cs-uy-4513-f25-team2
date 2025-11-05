require 'rails_helper'

RSpec.describe Learner, type: :model do
  context 'validations' do
    it 'requires email' do
      l = Learner.new(password: 'password')
      expect(l).not_to be_valid
      expect(l.errors[:name]).to include("can't be blank")
    end
  end
end
