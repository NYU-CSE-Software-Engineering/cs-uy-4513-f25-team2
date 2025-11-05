require 'rails_helper'

RSpec.describe Tutor, type: :model do
  context 'validations' do
    it 'is invalid without a name' do
        t = Tutor.new(bio: '4 years of experience tutoring Calculus')
        expect(t).not_to be_valid
        expect(t.errors[:tutor_name]).to include("can't be blank")
    end

    it 'requires rating_avg to be a number' do
        t = Tutor.new(tutor_name: 'Jane Doe', rating_avg: 'rating')
        expect(t).not_to be_valid
        expect(t.errors[:rating_avg]).to include("is not a number")
    end

    it 'requires rating_avg to be between 0 and 5' do
        t1 = Tutor.new(tutor_name: 'John Doe', rating_avg: 6.2)
        t2 = Tutor.new(tutor_name: 'Emily Johnson', rating_avg: -3.0)
        expect(t1).not_to be_valid
        expect(t2).not_to be_valid
        expect(t1.errors[:rating_avg]).to be_present
        expect(t2.errors[:rating_avg]).to be_present
    end

    it 'requires rating_count to be an integer' do
        t = Tutor.new(tutor_name: 'Sarah Wu', rating_count: 'rating')
        expect(t).not_to be_valid
        expect(t.errors[:rating_count]).to be_present
    end
  end
end