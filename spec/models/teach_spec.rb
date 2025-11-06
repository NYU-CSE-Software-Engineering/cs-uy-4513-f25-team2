require 'rails_helper'

RSpec.describe Teach, type: :model do
    context 'validations' do
        it 'is invalid without a tutor' do
            s = Subject.create!(name: 'Calculus', code: 'MATH101')
            teach = Teach.new(subject: s)
            expect(teach).not_to be_valid
            expect(teach.errors[:tutor]).to include("must exist")
        end

        it 'is invalid without a subject' do
            l = Learner.create!(email: 'jane_doe@example.com', password: 'password123')
            t = Tutor.create!(learner: l)
            teach = Teach.new(tutor: t)
            expect(teach).not_to be_valid
            expect(teach.errors[:subject]).to include("must exist")
        end

        it 'requires tutor and subject to be a unique pair' do
            l1 = Learner.create!(email: 'jane_doe@example.com', password: 'password123')
            l2 = Learner.create!(email: 'john_smith@example.com', password: 'password123')
            t1 = Tutor.create!(learner: l1)
            t2 = Tutor.create!(learner: l2)
            s1 = Subject.create!(name: 'Calculus', code: 'MATH101')
            s2 = Subject.create!(name: 'Biology', code: 'SCI101')

            Teach.create!(tutor: t1, subject: s1)
            dup_teach_invalid = Teach.new(tutor: t1, subject: s1)
            dup_teach_valid1 = Teach.new(tutor: t1, subject: s2)
            dup_teach_valid2 = Teach.new(tutor: t2, subject: s1)

            expect(dup_teach_invalid).not_to be_valid
            expect(dup_teach_invalid.errors[:tutor_id]).to include('has already been taken')
            expect(dup_teach_valid1).to be_valid
            expect(dup_teach_valid2).to be_valid
        end
    end
end