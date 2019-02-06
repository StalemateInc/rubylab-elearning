# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization, type: :model do

  module OrganizationConstants
    MINIMUM_NAME_LENGTH = 2
    MAXIMUM_NAME_LENGTH = 100
    MAXIMUM_DESCRIPTION_LENGTH = 500
  end

  subject { build :organization }

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
    it "is shorter than #{OrganizationConstants::MINIMUM_NAME_LENGTH}" do
      subject.name = 's' * (OrganizationConstants::MINIMUM_NAME_LENGTH - 1)
      expect(subject).not_to be_valid
    end

    it "is longer than #{OrganizationConstants::MAXIMUM_NAME_LENGTH}" do
      subject.name = 's' * (OrganizationConstants::MAXIMUM_NAME_LENGTH + 1)
      expect(subject).not_to be_valid
    end
  end

  it "is not valid if description longer than #{OrganizationConstants::MAXIMUM_DESCRIPTION_LENGTH}" do
    subject.description = 's' * (OrganizationConstants::MAXIMUM_DESCRIPTION_LENGTH + 1)
    expect(subject).not_to be_valid
  end

end
