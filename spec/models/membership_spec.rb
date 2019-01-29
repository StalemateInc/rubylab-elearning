# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Membership, type: :model do

  let(:user) { build :user }
  let(:organization) { build :organization }

  subject { described_class.new(user: user, organization: organization) }

  let(:existing_membership) { described_class.new(user_id: user.id, organization_id: organization.id) }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a user' do
    subject.user = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a organization' do
    subject.organization = nil
    expect(subject).not_to be_valid
  end

  it 'is invalid if duplicate membership present' do
    subject.organization = existing_membership.organization
    subject.user = existing_membership.user
    expect(subject).not_to be_valid
  end
end
