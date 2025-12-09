class Spot < ApplicationRecord
  # 画像のバリアント処理
  include  ImageProcessable

  # 住所から緯度経度取得する
  geocoded_by :address
  after_validation :address_be_geocode

  # 店舗情報が消えたら設備情報や写真・修正依頼も消える楔形
  belongs_to :user
  has_many :spot_update_requests, dependent: :destroy
  has_many :spot_image_update_requests, dependent: :destroy

  # ファイルをレコードに添付する
  has_many_attached :images do |attachable|
    # 一覧画面用
    attachable.variant :thumb, resize_to_limit: [200, 200]
    # 詳細画面用＿スマホ想定なので600で設定
    attachable.variant :detail, resize_to_limit: [600,600]
  end

  # ファイル添付時に自動でファイル名を正規化
  before_save :normalize_image_filenames, if: -> { images.attached? }

  # 写真枚数制限
  validate :images_count_limit
  # 写真枚数カウント
  def images_count
    images.count
  end

  # 写真残り枚数カウント
  def images_remaining_count
    3 - images.count
  end

  # 閉店フラグ
  enum :business_status, { open: 0, closed: 1 }

  # 検索対象として有効な店舗のみ
  scope :active, -> { where(business_status: :open) }

  # belongs_to :userがあるからバリデーションが自動でかかるため user_idのバリデーションは不要
  validates :name, presence: true
  validates :address, presence: true, uniqueness: { message: "この住所はすでに登録されています" }

  private

  def normalize_image_filenames
    images.each do |image|
      original_filename = image.blob.filename.to_s

      # 問題のあるファイル名かチェック
      if problematic_filename?(original_filename)
        safe_filename = sanitize_filename(original_filename)

        # ファイル名を更新
        image.blob.update!(filename: safe_filename)
        Rails.logger.info "ファイル名を正規化しました: #{original_filename} → #{safe_filename}"
      end
    end
  end

  def sanitize_filename(filename)
    extension = File.extname(filename)
    name_without_ext = File.basename(filename, extension)

    # 特殊文字を安全な文字に変換
    safe_name = name_without_ext
                .gsub(/[^\w\-_]/, '_')  # 英数字、ハイフン、アンダースコア以外を_に変換
                .gsub(/_+/, '_')        # 連続する_を1つに
                .gsub(/^_+|_+$/, '')    # 先頭と末尾の_を除去

    # 空になった場合のフォールバック
    safe_name = 'image' if safe_name.blank?

    # タイムスタンプを追加して一意性を確保
    timestamp = Time.current.strftime('%Y%m%d_%H%M%S')
    "#{safe_name}_#{timestamp}#{extension}"
  end

  def problematic_filename?(filename)
    return false if filename.blank?
  
    # 特殊文字をチェック
    filename.match?(/[^\w\-_.]/) ||
    filename.include?(' ') ||
    filename.include?('(') ||
    filename.include?(')') ||
    filename.include?('%')
  end

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

  # Ransackで検索可能な属性を明示的に指定
  def self.ransackable_attributes(auth_object = nil)
    %w[
      name
      address
      child_chair
      tatami_seat
      child_tableware
      bring_baby_food
      stroller_ok
      child_menu
      parking
      other_facility
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
