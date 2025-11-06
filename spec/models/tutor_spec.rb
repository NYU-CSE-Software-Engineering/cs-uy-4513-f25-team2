require 'rails_helper'

RSpec.describe Tutor, type: :model do
  context 'validations' do
    it 'is invalid without a learner' do
        t = Tutor.new(bio: '4 years of experience tutoring Calculus')
        expect(t).not_to be_valid
        expect(t.errors[:learner]).to include("must exist")
    end
  end
end