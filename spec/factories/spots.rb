FactoryBot.define do
  factory :spot do
    name { "テストスポット" }
    address { "東京都テスト区1-1" }
    association :user
  end
end