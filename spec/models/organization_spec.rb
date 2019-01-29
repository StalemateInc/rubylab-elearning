# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization, type: :model do

  MINIMUM_NAME_LENGTH = 2
  MAXIMUM_NAME_LENGTH = 20
  MAXIMUM_DESCRIPTION_LENGTH = 500

  subject { described_class.new(name: 'sometext', description: 'somedescription') }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  it 'is valid without a description' do
    subject.description = nil
    expect(subject).to be_valid
  end

  context 'is not valid if name' do
    it "is shorter than #{MINIMUM_NAME_LENGTH}" do
      subject.name = 's' * (MINIMUM_NAME_LENGTH - 1)
      expect(subject).not_to be_valid
    end

    it "is longer than #{MAXIMUM_NAME_LENGTH}" do
      subject.name = 's' * (MAXIMUM_NAME_LENGTH + 1)
      expect(subject).not_to be_valid
    end
  end

  it "is not valid if description longer than #{MAXIMUM_DESCRIPTION_LENGTH}" do
    subject.description = 's' * (MAXIMUM_DESCRIPTION_LENGTH + 1)
    expect(subject).not_to be_valid
  end

end
