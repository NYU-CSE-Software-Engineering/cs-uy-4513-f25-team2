require 'rails_helper'

RSpec.describe Subject, type: :model do
  context 'validations' do
    it 'is invalid without a name' do
      s = Subject.new(code: 'MATH101')
      expect(s).not_to be_valid
      expect(s.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without a code' do
      s = Subject.new(name: 'Calculus')
      expect(s).not_to be_valid
      expect(s.errors[:code]).to include("can't be blank")
    end

    it 'requires code to be unique (case-insensitive)' do
      Subject.create!(name: 'Calculus', code: 'MATH101')
      dup = Subject.new(name: 'Linear Algebra', code: 'math101')
      expect(dup).not_to be_valid
      expect(dup.errors[:code]).to include('has already been taken')
    end
  end
end