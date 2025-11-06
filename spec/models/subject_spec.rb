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

    context 'associations'  do 
      it 'can have many teaches' do
        s = Subject.create!(name: 'Calculus', code: 'MATH101')
        l1 = Learner.create!(email: 'jane_doe@example.com', password: 'password123')
        t1 = Tutor.create!(learner: l1)
        l2 = Learner.create!(email: 'jane_doe2@example.com', password: 'password123')
        t2 = Tutor.create!(learner: l2)
        Teach.create!(tutor: t1, subject: s)
        Teach.create!(tutor: t2, subject: s)
        expect(s.teaches.count).to eq(2)
      end
  
      it 'can have many tutors through teaches' do
        s = Subject.create!(name: 'Calculus', code: 'MATH101')
        l1 = Learner.create!(email: 'jane_doe@example.com', password: 'password123')
        t1 = Tutor.create!(learner: l1)
        l2 = Learner.create!(email: 'jane_doe2@example.com', password: 'password123')
        t2 = Tutor.create!(learner: l2)
        Teach.create!(tutor: t1, subject: s)
        Teach.create!(tutor: t2, subject: s)
        expect(s.tutors.map { |t| t.learner.email }).to include('jane_doe@example.com', 'jane_doe2@example.com')
      end
    end
  end
end