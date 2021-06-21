# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    user { association(:user) }
    sequence(:google_id) { |n| ValidGoogleIds.valid_google_ids[n % 50] }

    trait :with_rating do
      my_rating { 5 }
    end
  end
end
