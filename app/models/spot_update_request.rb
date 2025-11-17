class SpotUpdateRequest < ApplicationRecord
  # Concern 読み込み
  # privateメゾットはapp/models/concerns/spot_update_request_private_methods.rbへ
  include SpotUpdateRequestPrivateMethods

  store_accessor :request_data,
                  # 基本情報
                  :name, :address, :tel, :opening_hours, :other_facility_comment,
                  :latitude, :longitude, :business_status,

                  # 設備情報
                  :child_chair, :tatami_seat, :child_tableware, :bring_baby_food,
                  :stroller_ok, :child_menu, :parking, :other_facility

  # 依頼修正モデル（店舗情報・写真削除・閉店連絡）
  # 店舗情報修正依頼時にはログインしてないユーザーもできる設計
  belongs_to :user, optional: true
  belongs_to :spot
  belongs_to :facility_tag, optional: true
  has_many :spot_update_request_images, dependent: :destroy

  # enum 定義
  # 店舗修正依頼、写真削除、閉店依頼の3種類
  enum :request_type, { spot_update: 0, image_delete: 1, closure: 2 }
  # 処理ステータス:保留・承認・却下
  enum :status, { pending: 0, approved: 1, rejected: 2 }

  # ユーザー作成時バリデーション
  with_options if: :user_submission? do
    validates :request_type, presence: true
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

  # 統計用のスコープ
  scope :recent, -> { order(created_at: :desc) }
  scope :today, -> { where(created_at: Time.current.beginning_of_day..Time.current.end_of_day) }
  scope :this_week, -> { where(created_at: Time.current.beginning_of_week..Time.current.end_of_week) }

  # 承認処理メソッド
  def approve!
    transaction do
      # ステータスを承認に変更
      self.status = :approved
      save!

      # 店舗情報更新タイプの場合のみ店舗データに反映
      apply_to_spot if spot_update?

      true
    end
  rescue => e
    # エラーログ出力（本番環境での問題調査用）
    Rails.logger.error "承認処理でエラーが発生: #{e.message}"
    false
  end

  # 却下処理メソッド
  def reject!
    # ステータスを却下に変更（シンプルな処理）
    update!(status: :rejected)
    true
  rescue => e
    # エラーログ出力（本番環境での問題調査用）
    Rails.logger.error "却下処理でエラーが発生: #{e.message}"
    false
  end

  # 承認時に実際の店舗情報を更新するメソッド
  def apply_to_spot
    return false unless spot_update? # approved?チェックを削除（approve!内で呼ぶため）
  
    spot.update!(
      # 基本情報
      name: name.presence || spot.name,
      address: address.presence || spot.address,
      tel: tel.presence || spot.tel,
      opening_hours: opening_hours.presence || spot.opening_hours,
      other_facility_comment: other_facility_comment.presence || spot.other_facility_comment,
      latitude: latitude.presence || spot.latitude,
      longitude: longitude.presence || spot.longitude,
      business_status: business_status.presence || spot.business_status,
      
      # 設備情報：チェックあり=true、チェックなし=false
      child_chair: child_chair || false,
      tatami_seat: tatami_seat || false,
      child_tableware: child_tableware || false,
      bring_baby_food: bring_baby_food || false,
      stroller_ok: stroller_ok || false,
      child_menu: child_menu || false,
      parking: parking || false,
      other_facility: other_facility || false
    )
    
    true
  rescue => e
    Rails.logger.error "店舗情報更新でエラーが発生: #{e.message}"
    false
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[
      created_at
      id
      photo_delete_reason
      request_data
      request_type
      spot_id
      status
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[spot]
  end
end