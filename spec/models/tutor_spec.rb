require 'rails_helper'

RSpec.describe Tutor, type: :model do
  context 'validations' do
    it 'is invalid without a learner' do
      t = build(:tutor, learner: nil)
      expect(t).not_to be_valid
      expect(t.errors[:learner]).to include("must exist")
    end

    it 'requires learner to be unique' do
      l = create(:learner)
      create(:tutor, learner: l)
      dup_tutor = build(:tutor, learner: l)
      expect(dup_tutor).not_to be_valid
      expect(dup_tutor.errors[:learner]).to include('has already been taken')
    end

    it 'requires rating_avg to be a number' do
      t = build(:tutor, rating_avg: 'rating')
      expect(t).not_to be_valid
      expect(t.errors[:rating_avg]).to include("is not a number")
    end

    it 'requires rating_avg to be between 0 and 5' do
      t1 = build(:tutor, rating_avg: -0.5)
      t2 = build(:tutor, rating_avg: 7.2)
      expect(t1).not_to be_valid
      expect(t2).not_to be_valid
      expect(t1.errors[:rating_avg]).to include("must be greater than or equal to 0")
      expect(t2.errors[:rating_avg]).to include("must be less than or equal to 5")
    end

    it 'requires rating_count to be an integer' do
      t1 = build(:tutor, rating_count: 'rating')
      t2 = build(:tutor, rating_count: 9.42)
      expect(t1).not_to be_valid
      expect(t2).not_to be_valid
      expect(t1.errors[:rating_count]).to include("is not a number")
      expect(t2.errors[:rating_count]).to include("must be an integer")
    end

    it 'requires rating_count to be non-negative' do
      t = build(:tutor, rating_count: -5)
      expect(t).not_to be_valid
      expect(t.errors[:rating_count]).to include("must be greater than or equal to 0")
    end

    context 'bio validations' do
      it 'allows bio to be nil' do
        t = build(:tutor, bio: nil)
        expect(t).to be_valid
      end

      it 'allows bio to be empty' do
        t = build(:tutor, bio: '')
        expect(t).to be_valid
      end

      it 'requires bio to be less than 500 characters' do
        t = build(:tutor, bio: 'a' * 501)
        expect(t).not_to be_valid
        expect(t.errors[:bio]).to include("Character limit exceeded (500)")
      end
    end

    context 'associations' do
      it 'can have many teaches' do
        t = create(:tutor)
        create(:teach, tutor: t)
        create(:teach, tutor: t)
        expect(t.teaches.count).to eq(2)
      end
  
      it 'can have many subjects through teaches' do
        t = create(:tutor)
        s1 = create(:teach, tutor: t).subject
        s2 = create(:teach, tutor: t).subject
        expect(t.subjects).to include(s1, s2)
      end
    end
  end
end