# frozen_string_literal: true

FactoryBot.define do
  factory :impersonation_history do
    started_at { "2019-02-07 14:35:32" }
    ended_at { "2019-02-07 14:35:32" }
  end
  factory :course_access do
    
  end
  factory :user_answer do
    answer { "MyString" }
  end
  factory :favorite_course do
    
  end
  factory :completion_record do
    score { 1 }
    status { 1 }
    date { "2019-02-07 14:21:47" }
  end
  factory :certificate do
    filename { "MyString" }
  end
  factory :question do
    content { "MyText" }
    type { 1 }
  end
  factory :answer_list do
    correct_answers { "MyString" }
  end
  factory :page do
    html { "MyText" }
    css { "MyText" }
    previous { 1 }
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

end