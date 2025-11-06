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
    end
end