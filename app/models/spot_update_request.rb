class SpotUpdateRequest < ApplicationRecord
  # 依頼修正モデル（店舗情報・写真削除・閉店連絡）
  # 店舗情報修正依頼時にはログインしてないユーザーもできる設計
  belongs_to :user, optional: true
  belongs_to :spot
  belongs_to :facility_tag, optional: true
  has_many :spot_update_request_images, dependent: :destroy

  # enum 定義
  enum :checkbox, { spot_update: 0, image_delete: 1, closure: 2 }
  enum :status, { pending: 0, approved: 1, rejected: 2 }

  # ユーザー作成時バリデーション
  with_options if: :user_submission? do
    validates :checkbox, presence: true
    # 写真削除依頼
    validates :photo_delete_reason, presence: true, if: :image_delete?
    validates :spot_update_request_images, presence: true, if: :image_delete?
    # 店舗情報修正時
    validate :spot_update_excludes_other_fields, if: :spot_update?
    # 閉店依頼時
    validate :closure_excludes_all_fields, if: :closure?
  end

  # 管理者編集時
  with_options if: :admin_editing? do
    validates :status, presence: true
  end

  # Concern 読み込み
  # privateメゾットはapp/models/concerns/spot_update_request_private_methods.rbへ
  include SpotUpdateRequestPrivateMethods
end