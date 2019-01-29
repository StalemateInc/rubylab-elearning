# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do

  subject { described_class.new(email: 'example@mail.com', password: 'somepassword', ) }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a email' do
    subject.email = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a password' do
    subject.password = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid if email is incorrect' do
    subject.email = 'sometext'
    expect(subject).not_to be_valid
  end
end
