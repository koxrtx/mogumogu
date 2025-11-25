class SpotImageUpdateRequest < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :spot

  # enum 定義
  # 写真の追加・削除
  enum :request_type, { add: 0, remove: 1 }
  # 処理ステータス:保留・承認・却下
  enum :status, { pending: 0, approved: 1, rejected: 2 }

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

      # 写真更新タイプの場合のみ店舗データに反映
      apply_to_spot_image_changes if add?

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
  def apply_to_spot_image_changes
  return false unless add?

  # 削除処理
  if request_data["delete_image_ids"].present?
    request_data["delete_image_ids"].each do |blob_id|
      blob = ActiveStorage::Blob.find_by(id: blob_id)
      blob&.purge
    end
  end

  # 追加処理
  if request_data["add_images"].present?
    request_data["add_images"].each do |uploaded_io|
      spot.images.attach(uploaded_io)
    end
  end

  true
rescue => e
  Rails.logger.error "写真更新でエラーが発生: #{e.message}"
  false
end

  def self.ransackable_attributes(auth_object = nil)
    %w[
      created_at
      id
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
