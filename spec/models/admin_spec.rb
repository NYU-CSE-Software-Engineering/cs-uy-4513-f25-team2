require 'rails_helper'

RSpec.describe Admin, type: :model do
  context 'validations' do
    it 'requires email' do
      a = Admin.new(password: 'secret')
      expect(a).not_to be_valid
      expect(a.errors[:email]).to include("can't be blank")
    end

    it 'requires password' do
      a = Admin.new(email: 'admin@example.com')
      expect(a).not_to be_valid
      expect(a.errors[:password]).to include("can't be blank")
    end

    it 'enforces case-insensitive unique email' do
      Admin.create!(email: 'admin@example.com', password: 'x')
      dup = Admin.new(email: 'ADMIN@example.com', password: 'y')
      expect(dup).not_to be_valid
      expect(dup.errors[:email]).to include('has already been taken')
    end
  end
end
