# frozen_string_literal: true

FactoryBot.define do

  factory :user do
    trait :admin do
      admin { true }
    end
    sequence(:email) { |n| "test_user_#{n}@example.com" }
    password { '1234567890' }
  end

  factory :organization do
    name { 'Test Organization' }
    description { Faker::Lorem.characters(100) }
  end

  factory :course do
    name { 'Test Course' }
    duration { 5 }
    difficulty { 0 }
    views { 0 }
  end
end