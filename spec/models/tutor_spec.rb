require 'rails_helper'

RSpec.describe Tutor, type: :model do
  context 'validations' do
    it 'is invalid without a name' do
        t = Tutor.new(bio: '4 years of experience tutoring Calculus')
        expect(t).not_to be_valid
        expect(t.errors[:tutor_name]).to include("can't be blank")
    end

    it 'requires rating_avg to be a number' do
        t = Tutor.new(tutor_name: 'Jane Doe', rating_avg: '4.5')
        expect(t).not_to be_valid
        expect(t.errors[:rating_avg]).to include("must be a number")
    end
  end
end