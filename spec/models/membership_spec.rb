# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Membership, type: :model do

  let(:user) { User.new(email: 'example@mail.com', password: 'somepassword') }
  let(:organization) { Organization.new(name: 'sometext', description: 'somedescription') }

  subject { described_class.new(user: user, organization: organization) }

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

end
