require_relative '../rails_helper'

RSpec.describe User, type: :model do
  subject { User.new(name: 'First User', email: 'test@example.com', password: 'password') }
  before { subject.save }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without an email' do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a password' do
      subject.password = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'associations' do
    it 'has many entities' do
      expect(subject).to respond_to(:entities)
    end

    it 'has many groups' do
      expect(subject).to respond_to(:groups)
    end
  end
end
