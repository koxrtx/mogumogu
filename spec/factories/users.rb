FactoryBot.define do
  factory :user do
    name { "太郎" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
  end
end
