# frozen_string_literal: true

FactoryBot.define do
  factory :invite do
    
  end

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
    difficulty { :unspecified }
    views { 0 }
  end

  factory :profile do
    name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    nickname { Faker::Internet.username(3..50) }
    address { Faker::Address.full_address }
    birthday { Faker::Date.birthday }
  end

  factory :feedback do
    rating { rand(6) }
    content { Faker::Lorem.paragraph(1) }
  end
end