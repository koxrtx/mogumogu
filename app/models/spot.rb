class Spot < ApplicationRecord
  # 住所から緯度経度取得する
  geocoded_by :address
  after_validation :geocode

  # 店舗情報が消えたら設備情報や写真・修正依頼も消える楔形
  belongs_to :user
  has_many :spot_facilities, dependent: :destroy
  has_many :facility_tags, through: :spot_facilities
  has_many :spot_images, dependent: :destroy
  has_many :spot_update_requests, dependent: :destroy

  # 閉店フラグ
  enum :status, { open: 0, closed: 1 }

  # belongs_to :userがあるからバリデーションが自動でかかるため user_idのバリデーションは不要
  validates :name, presence: true
  validates :address, presence: true

end
