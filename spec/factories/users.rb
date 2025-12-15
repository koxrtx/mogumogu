FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "太郎#{n}" } 
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }

    trait :line_user do
      provider { "line" }          # LINEログインなら provider=line
      uid { SecureRandom.uuid }    # UID も必要
    end
  end
end