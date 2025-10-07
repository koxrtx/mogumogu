class Spot < ApplicationRecord
  # 住所から緯度経度取得する
  geocoded_by :address
  after_validation :address_be_geocode

  # 店舗情報が消えたら設備情報や写真・修正依頼も消える楔形
  belongs_to :user
  has_many :spot_facilities, dependent: :destroy
  has_many :facility_tags, through: :spot_facilities
  has_many :spot_update_requests, dependent: :destroy

  # ファイルをレコードに添付する
  has_many_attached :images do |attachable|
    # 一覧画面用_preprocessed: true でサムネイルを先に作成しておく
    attachable.variant :thumb, resize_to_limit: [200, 200], preprocessed: true
    # 詳細画面用＿スマホ想定なので600で設定
    attachable.variant :detail, resize_to_limit: [600,600]
  end

  # 写真枚数制限
  validate :images_count_limit

  # 閉店フラグ
  enum :status, { open: 0, closed: 1 }

  # belongs_to :userがあるからバリデーションが自動でかかるため user_idのバリデーションは不要
  validates :name, presence: true
  validates :address, presence: true, uniqueness: { message: "この住所はすでに登録されています" }

  private

  # 住所登録したときの例外エラー
  def address_be_geocode
    results = Geocoder.search(address)
    if results.present?
      self.latitude = results.first.latitude
      self.longitude = results.first.longitude
    else
      errors.add(:address, "は地図で見つかりませんでした。入力を確認してください")
    end
  
  # 例外処理
  rescue => e
    Rails.logger.error("Geocodeing failed: #{e.message}")
    errors.add(:address, "の位置情報取得に失敗しました。時間をおいて再度お試しください")
  end

  # 写真制限
  def images_count_limit
    if images.attached? && images.count > 3
      errors.add(:images, "は3枚までしかアップロードできません")
    end
  end

end
