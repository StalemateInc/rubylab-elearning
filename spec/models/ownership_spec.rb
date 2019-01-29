# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ownership, type: :model do

  let(:course) { Course.new(name: 'Course Name', duration: 10, difficulty: :novice) }
  let(:organization) { Organization.new(name: 'sometext', description: 'somedescription') }
  let(:user) { User.new(email: 'example@mail.com', password: 'somepassword') }

  let(:org_ownership) { described_class.new(course: course, ownable: organization,
                                            ownable_type: 'Organization') }
  let(:user_ownership) { described_class.new(course: course, ownable: user, ownable_type: 'User') }
  let(:existing_ownership) { described_class.new(course_id: course.id, ownable_id: user.id,
                                                 ownable_type: 'User') }

  context 'ownership with organization' do
    it 'is valid with valid attributes' do
      expect(org_ownership).to be_valid
    end
  end

  context 'ownership with user' do
    it 'is valid with valid attributes' do
      expect(user_ownership).to be_valid
    end
  end

  it 'is invalid without a course' do
    user_ownership.course = nil
    expect(user_ownership).not_to be_valid
  end

  it 'is invalid without an ownable' do
    user_ownership.ownable = nil
    expect(user_ownership).not_to be_valid
  end

  it 'is invalid if duplicates' do
    user_ownership.course = existing_ownership.course
    user_ownership.ownable = existing_ownership.ownable
    expect(user_ownership).not_to be_valid
  end
end
