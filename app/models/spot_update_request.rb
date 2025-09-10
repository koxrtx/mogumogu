class SpotUpdateRequest < ApplicationRecord
  # 依頼修正モデル（店舗情報・写真削除・閉店連絡）
  # 店舗情報修正依頼時にはログインしてないユーザーもできる設計
  belongs_to :user, optional: true
  belongs_to :spot
  belongs_to :facility_tag, optional: true
  has_many :spot_update_request_images, dependent: :destroy

  validates :spot_id, presence: true
  validates :checkbox, presence: true
  validates :status, presence: true

  # enum 定義
  enum checkbox: { spot_update: 0, image_delete: 1, closure: 2 }
  enum status: { pending: 0, approved: 1, rejected: 2 }
end