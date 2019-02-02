# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Participation, type: :model do

  let(:user) { build :user }
  let(:course) { build :course }

  subject { described_class.new(user: user, course: course) }

  let(:existing_participation) { described_class.new(user_id: user.id, course_id: course.id) }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a user' do
    subject.user = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a course' do
    subject.course = nil
    expect(subject).not_to be_valid
  end

  it 'is invalid if duplicates' do
    subject.course = existing_participation.course
    subject.user = existing_participation.user
    expect(subject).not_to be_valid
  end
end
