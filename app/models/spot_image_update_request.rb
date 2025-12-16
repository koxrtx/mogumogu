class SpotImageUpdateRequest < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :spot

  require "open-uri"

  # enum 定義
  # 写真の追加・削除・削除と追加
  enum :request_type, { add: 0, remove: 1 ,both: 2 }
  validates :request_type, presence: true
  # 処理ステータス:保留・承認・却下
  enum :status, { pending: 0, approved: 1, rejected: 2 }

  # 統計用のスコープ
  scope :recent, -> { order(created_at: :desc) }
  scope :today, -> { where(created_at: Time.current.beginning_of_day..Time.current.end_of_day) }
  scope :this_week, -> { where(created_at: Time.current.beginning_of_week..Time.current.end_of_week) }

  # 承認処理
  def approve!
    transaction do
      update!(status: :approved, processed_at: Time.current)
      apply_spot_image_changes if add? || remove? || both?
      true
    end
  rescue => e
    Rails.logger.error "承認処理エラー: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    false
  end

  def reject!
    update!(status: :rejected)
    true
  rescue => e
    Rails.logger.error "却下処理エラー: #{e.message}"
    false
  end

  private

  def apply_spot_image_changes
    Rails.logger.info "=== 画像更新処理開始 ==="
    Rails.logger.info "Request ID: #{id}"
    Rails.logger.info "Request Type: #{request_type}"
    Rails.logger.info "Request Data: #{request_data.inspect}"

    # 削除処理（キー名を修正）
    if request_data["delete_image_ids"].present? && (remove? || both?)
      delete_images
    end

    # 追加処理
    if request_data["add_images"].present? && (add? || both?)
      add_images
    end

    Rails.logger.info "=== 画像更新処理完了 ==="
    true
  rescue => e
    Rails.logger.error "画像更新エラー: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    false
  end

  # 画像削除処理
  def delete_images
    
    # request_dataから削除対象のblob_idを取得
    blob_ids = request_data["delete_image_ids"]
    

    blob_ids.each do |blob_id|

      # Blob IDから該当するAttachmentを検索して削除
      # Cloudinaryを使っている場合もこれで削除できます
      attachment = ActiveStorage::Attachment.find_by(blob_id: blob_id)

      if attachment
        attachment.purge
      else
        
        # 念のためBlobを直接削除
        blob = ActiveStorage::Blob.find_by(id: blob_id)
        if blob
          blob.purge
        else
        end
      end
    end
  end

  # 画像追加処理（将来的に使う場合）
  def add_images
  
    if request_data["add_images"].is_a?(Array)
      request_data["add_images"].each do |image|
        # インターネットのURLから写真を取ってきて、お店にくっつける
        file = URI.open(image['url'])
        spot.images.attach(
          io: file,
          filename: image['original_filename'],
          content_type: image['content_type']
        )
    end
  end
end

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id request_type spot_id status]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[spot user]
  end
end