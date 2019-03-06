# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do

  module UserConstants
    MINIMUM_PASSWORD_LENGTH = 6
    TAKEN_EMAIL = 'example@mail.com'
  end

  subject { build(:user, email: UserConstants::TAKEN_EMAIL) }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a email' do
    subject.email = nil
    expect(subject).not_to be_valid
  end

  # it 'is not valid without a password' do
  #   subject.password = nil
  #   expect(subject).not_to be_valid
  # end

  it 'is not valid if email is incorrect' do
    subject.email = 'sometext'
    expect(subject).not_to be_valid
  end

  # it "is not valid if password is less than #{UserConstants::MINIMUM_PASSWORD_LENGTH} symbols" do
  #   subject.password = 'p' * (UserConstants::MINIMUM_PASSWORD_LENGTH - 1)
  #   expect(subject).not_to be_valid
  # end

  context 'if registered the email has already been taken' do
    before do
      create :user, email: UserConstants::TAKEN_EMAIL
    end
    it 'is not valid' do
      expect(subject).not_to be_valid
    end
  end

end
