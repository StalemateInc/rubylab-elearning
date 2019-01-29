# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Feedback, type: :model do

  MINIMUM_RATING_VALUE = 0
  MAXIMUM_RATING_VALUE = 5
  MAXIMUM_CONTENT_LENGTH = 200

  let(:user) { User.new(email: 'example@mail.com', password: 'somepassword') }
  let(:course) { Course.new(name: 'somename', duration: 1, difficulty: 1, views: 1) }

  subject { described_class.new(rating: 5, content: 'somecontent', user: user, course: course) }

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

  it "is not valid if content longer than #{MAXIMUM_CONTENT_LENGTH}" do
    subject.content = 's' * (MAXIMUM_CONTENT_LENGTH + 1)
    expect(subject).not_to be_valid
  end

  context 'is not valid if rating' do
    it "is less than #{MINIMUM_RATING_VALUE}" do
      subject.rating = MINIMUM_RATING_VALUE - 1
      expect(subject).not_to be_valid
    end

    it "is larger than #{MAXIMUM_RATING_VALUE}" do
      subject.rating = MAXIMUM_RATING_VALUE + 1
      expect(subject).not_to be_valid
    end

    it 'is not an integer' do
      subject.rating = 1.1
      expect(subject).not_to be_valid
    end
  end
end
