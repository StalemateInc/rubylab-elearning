# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Feedback, type: :model do

  module FeedbackConstants
    MINIMUM_RATING_VALUE = 0
    MAXIMUM_RATING_VALUE = 5
    MAXIMUM_CONTENT_LENGTH = 200
  end

  let(:user) { build :user }
  let(:course) { build :course }

  subject { build(:feedback, user: user, course: course) }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a content' do
    subject.content = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a rating' do
    subject.rating = nil
    expect(subject).not_to be_valid
  end

  it "is not valid if content longer than #{FeedbackConstants::MAXIMUM_CONTENT_LENGTH}" do
    subject.content = 's' * (FeedbackConstants::MAXIMUM_CONTENT_LENGTH + 1)
    expect(subject).not_to be_valid
  end

  context 'when given an incorrect rating' do
    it "is not valid if rating is less than #{FeedbackConstants::MINIMUM_RATING_VALUE}" do
      subject.rating = FeedbackConstants::MINIMUM_RATING_VALUE - 1
      expect(subject).not_to be_valid
    end

    it "is not valid if rating is larger than #{FeedbackConstants::MAXIMUM_RATING_VALUE}" do
      subject.rating = FeedbackConstants::MAXIMUM_RATING_VALUE + 1
      expect(subject).not_to be_valid
    end

    it 'is not valid if rating is not an integer' do
      subject.rating = 1.1
      expect(subject).not_to be_valid
    end
  end

  it 'is not valid without a user' do
    subject.user = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a course' do
    subject.course = nil
    expect(subject).not_to be_valid
  end
end
