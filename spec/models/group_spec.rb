require_relative '../rails_helper'

RSpec.describe Group, type: :model do
  let(:user) { User.new(name: 'First User', email: 'test@example.com', password: 'password') }
  subject { Group.new(name: 'First Group', icon: 'fake-img.png', author: user) }
  before { subject.save }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      expect(subject).to respond_to(:author)
    end

    it 'has many entities' do
      expect(subject).to respond_to(:entities)
    end
  end
end
