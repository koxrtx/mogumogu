FactoryBot.define do
  factory :spot_image_update_request do
    association :user   # ユーザー
    association :spot   # スポット

    request_type { :add }     # enum
    status { :pending }       # enum

    # request_dataはテスト側で渡すためデフォルトは {}
    request_data { {} }
  end
end