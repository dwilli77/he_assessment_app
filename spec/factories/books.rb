FactoryBot.define do
  factory :book do
    user { nil }
    google_id { "MyString" }
    title { "MyString" }
    author { "MyString" }
    description { "MyText" }
    image_links { "MyString" }
    my_rating { 1 }
    notes { "MyText" }
  end
end
