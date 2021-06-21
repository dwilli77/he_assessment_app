FactoryBot.define do
  factory :search do
    term { "MyString" }
    response_status { 1 }
    response_body { "" }
  end
end
