module SpotsHelper
  # Cloudinary画像URL生成
  def cloudinary_image_url(record, size: :thumb, image_attribute: :images)
    return nil unless record.has_images?(image_attribute: image_attribute)

    image_key = record.image_key(image_attribute: image_attribute)
    return nil unless image_key.present?

    dimensions = image_dimensions(size)
    cl_image_path(image_key,
      width: dimensions[:width],
      height: dimensions[:height],
      crop: :fill,
      quality: :auto
    )

  rescue => e
    Rails.logger.error "Cloudinary画像URL生成エラー: #{e.message}"
    nil
  end

  # 表示用の画像URL（フォールバック付き）
  def display_image_url(record, size: :thumb, image_attribute: :images)
    cloudinary_url = cloudinary_image_url(record, size: size, image_attribute: image_attribute)
    return cloudinary_url if cloudinary_url.present?

    # ActiveStorageバリアント
    fallback_image_url(record, size, image_attribute)
  rescue => e
    Rails.logger.error "画像URL生成エラー: #{e.message}"
    nil
  end

  private

  # 画像サイズ設定
  def image_dimensions(size)
    case size
    when :thumb
      # 一覧（サムネ）用サイズ
      { width: 200, height: 200 }
    when :detail
      # 詳細表示用サイズ
      { width: 600, height: 600 }
    else
      # デフォルトはthumbサイズ
      { width: 200, height: 200 }
    end
  end

  # Cloudinaryで画像取れない時のフォールバック処理
  def fallback_image_url(record, size, image_attribute)
    return nil unless record.has_images?(image_attribute: image_attribute)

    first_image = record.first_image(image_attribute: image_attribute)
    return nil unless first_image&.blob.present?

    dimensions = image_dimensions(size)

    rails_representation_url(
      first_image.variant(
        resize_to_limit: [dimensions[:width], dimensions[:height]],
        format: :png
      )
    )

  rescue => e
    Rails.logger.error "ActiveStorage処理エラー: #{e.message}"
    nil
  end
end
