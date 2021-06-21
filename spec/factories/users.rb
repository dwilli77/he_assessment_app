# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "username-#{n}" }
    password { 'password' }

    trait :with_books do
      after(:create) do |user|
        user.books = create_list(:book, 15)
      end
    end
  end
end
