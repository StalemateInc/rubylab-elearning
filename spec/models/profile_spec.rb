# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile, type: :model do
  module ProfileConstants
    MINIMUM_NAME_LENGTH = 4
    MAXIMUM_NAME_LENGTH = 20
    MINIMUM_SURNAME_LENGTH = MINIMUM_NAME_LENGTH
    MAXIMUM_SURNAME_LENGTH = MAXIMUM_NAME_LENGTH
    MINIMUM_NICKNAME_LENGTH = 3
    MAXIMUM_NICKNAME_LENGTH = 50
  end

  let(:user) { create :user }
  subject { build :profile, user: user }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without surname' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a surname' do
    subject.surname = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a nickname' do
    subject.nickname = nil
    expect(subject).not_to be_valid
  end

  context 'when given an incorrect name' do
    it "is not valid if name is shorter than #{ProfileConstants::MINIMUM_NAME_LENGTH}" do
      subject.name = 'n' * (ProfileConstants::MINIMUM_NAME_LENGTH - 1)
      expect(subject).not_to be_valid
    end

    it "is not valid if name is longer than #{ProfileConstants::MAXIMUM_NAME_LENGTH}" do
      subject.name = 'n' * (ProfileConstants::MAXIMUM_NAME_LENGTH + 1)
      expect(subject).not_to be_valid
    end

    it 'is not valid if name contains anything other than alphabet symbols' do
      subject.name = 'Johnny_12'
      expect(subject).not_to be_valid
    end
  end

  context 'when given an incorrect surname' do
    it "is not valid if surname is shorter than #{ProfileConstants::MINIMUM_SURNAME_LENGTH} symbols" do
      subject.surname = 'n' * (ProfileConstants::MINIMUM_SURNAME_LENGTH - 1)
      expect(subject).not_to be_valid
    end

    it "is not valid if surname is longer than #{ProfileConstants::MAXIMUM_SURNAME_LENGTH} symbols" do
      subject.surname = 'n' * (ProfileConstants::MAXIMUM_SURNAME_LENGTH + 1)
      expect(subject).not_to be_valid
    end

    it 'is not valid if surname contains anything other than alphabet symbols' do
      subject.surname = 'Johnny_12'
      expect(subject).not_to be_valid
    end
  end

  context 'when given an incorrect nickname' do
    it "is not valid if nickname is shorter than #{ProfileConstants::MINIMUM_NICKNAME_LENGTH} symbols" do
      subject.nickname = 'n' * (ProfileConstants::MINIMUM_NICKNAME_LENGTH - 1)
      expect(subject).not_to be_valid
    end

    it "is not valid if nickname is longer than #{ProfileConstants::MAXIMUM_NICKNAME_LENGTH} symbols" do
      subject.nickname = 'n' * (ProfileConstants::MAXIMUM_NICKNAME_LENGTH + 1)
      expect(subject).not_to be_valid
    end
  end

  it 'is not valid without an already present user' do
    subject.user = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid if user with profile is already present' do
    create :profile, user: user
    expect(subject).not_to be_valid
  end
end
