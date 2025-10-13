# 画像処理
module ImageProcessable
  extend ActiveSupport::Concern

  # Cloudinary画像URL生成
  def cloudinary_image_url(size: :thumb, image_attribute: :images)
    images_collection = send(image_attribute)
    return nil unless images_collection.attached?

    first_image = images_collection.first
    return nil unless first_image&.attached?

    if first_image.blob.key.present?
      dimensions = image_dimensions(size)
      cl_image_path(first_image.blob.key,
        width: dimensions[:width],
        height: dimensions[:height],
        crop: :fill,
        quality: :auto
      )
    end

  rescue => e
    Rails.logger.error "Cloudinary画像URL生成エラー: #{e.message}"
    nil
  end

  # 表示用の画像URL（フォールバック付き）
  def display_image_url(size: :thumb, image_attribute: :images)
    # Cloudinary変換
    cloudinary_url = cloudinary_image_url(size: size, image_attribute: image_attribute)
    return cloudinary_url if cloudinary_url.present?

    # ActiveStorageバリアント
    fallback_image_url(size, image_attribute)
  rescue => e
    Rails.logger.error "画像URL生成エラー: #{e.message}"
    nil
  end

  private

  # 画像サイズ
  def image_dimensions(size)
    case size
    # 一覧（サムネ）
    when :thumb
      { width: 200, height: 200 }
    # 詳細
    when :detail
      { width: 600, height: 600 }
    end
  end

  # Cloudinaryで画像取れない時のフォールバック処理
  def fallback_image_url(size, image_attribute)
    images_collection = send(image_attribute)
    return nil unless images_collection.attached?

    dimensions = image_dimensions(size)

    Rails.application.routes.url_helpers.rails_representation_url(
      images_collection.first.variant(
        resize_to_limit: [dimensions[:width], dimensions[:height]],
      )
    )

  rescue => e
    Rails.logger.error "ActiveStorage処理エラー: #{e.message}"
    nil
  end
end