# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :model do

  module CourseConstants
    MINIMUM_NAME_LENGTH = 4
    MAXIMUM_NAME_LENGTH = 20
    MINIMUM_DURATION = 0
    MINIMUM_VIEWS = 0
  end

  subject { build :course }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a duration' do
    subject.duration = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a difficulty' do
    subject.difficulty = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a views field' do
    subject.views = nil
    expect(subject).not_to be_valid
  end

  context 'is not valid if name' do
    it "is shorter than #{CourseConstants::MAXIMUM_NAME_LENGTH} symbols" do
      subject.name = 'a' * (CourseConstants::MINIMUM_NAME_LENGTH - 1)
      expect(subject).not_to be_valid
    end

    it "is longer than #{CourseConstants::MAXIMUM_NAME_LENGTH} symbols" do
      subject.name = 'a' * (CourseConstants::MAXIMUM_NAME_LENGTH + 1)
      expect(subject).not_to be_valid
    end
  end

  context 'is not valid if duration' do
    it 'is not an Integer' do
      subject.duration = 0.01
      expect(subject).not_to be_valid
    end

    it "is less than #{CourseConstants::MINIMUM_DURATION}" do
      subject.duration = CourseConstants::MINIMUM_DURATION - 1
      expect(subject).not_to be_valid
    end

    it "is equal to #{CourseConstants::MINIMUM_DURATION}" do
      subject.duration = CourseConstants::MINIMUM_DURATION
      expect(subject).not_to be_valid
    end
  end

  context 'is not valid if views' do
    it 'is not an Integer' do
      subject.views = 0.01
      expect(subject).not_to be_valid
    end

    it "is less than #{CourseConstants::MINIMUM_VIEWS}" do
      subject.duration = CourseConstants::MINIMUM_VIEWS - 1
      expect(subject).not_to be_valid
    end
  end

  it 'is not valid if difficulty is not specified in model' do
    expect { subject.difficulty = Course.difficulties.length + 1 }.to raise_error(ArgumentError)
  end

  describe '#owner' do

    context 'when used on a course with a user as an owner' do
      before do
        @user = create :user
        Ownership.create!(ownable: @user, course: subject)
      end
      it 'should return User' do
        expect(subject.owner).to eq(@user)
      end
    end

    context 'when used on a course with an organization as an owner' do
      before do
        @organization = create :organization
        Ownership.create!(ownable: @organization, course: subject)
      end
      it 'should return Organization' do
        expect(subject.owner).to eq(@organization)
      end
    end

    context 'when used on a course without an owner' do
      it 'should return nil' do
        expect(subject.owner).to eq(nil)
      end
    end

  end

  it 'should create an Ownership for User-creator'
  it 'should create an Ownership for Organization-creator'
end
