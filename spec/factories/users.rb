FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "太郎#{n}" } 
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }

    # ★ OmniAuthの項目がある場合は設定
    provider { nil }
    uid { nil }
  end
end