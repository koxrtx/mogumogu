module SpotsHelper
  # 1枚目の画像URL取得（一覧用）
  def display_image_url(record, size: :thumb, image_attribute: :images)
    # Cloudinaryでの画像URL生成を試行
    cloudinary_url = cloudinary_image_url(record, size: size, image_attribute: image_attribute)
    return cloudinary_url if cloudinary_url.present?

    # Cloudinary失敗時はActiveStorageでフォールバック
    fallback_image_url(record, size, image_attribute)
  rescue => e
    Rails.logger.error "画像URL生成エラー: #{e.message}"
    nil
  end

  # 全画像のURL配列取得（詳細用）
  def display_all_image_urls(record, size: :detail, image_attribute: :images)
    return [] unless record.has_images?(image_attribute: image_attribute)

    # Cloudinaryで全画像処理を試す
    cloudinary_urls = all_cloudinary_image_urls(record, size: size, image_attribute: image_attribute)
    return cloudinary_urls if cloudinary_urls.present?

    # フォールバック：ActiveStorageで全画像処理
    all_fallback_image_urls(record, size, image_attribute)
  rescue => e
    Rails.logger.error "全画像URL生成エラー: #{e.message}"
    []
  end

  private

  # Cloudinary：1枚目のURL
  def cloudinary_image_url(record, size: :thumb, image_attribute: :images)
    return nil unless record.has_images?(image_attribute: image_attribute)

    image_key = record.image_key(image_attribute: image_attribute)
    return nil unless image_key.present?

    # 画像サイズ
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

  # Cloudinary：全画像のURL配列
  def all_cloudinary_image_urls(record, size: :detail, image_attribute: :images)
    return [] unless record.has_images?(image_attribute: image_attribute)

    image_keys = record.all_image_keys(image_attribute: image_attribute)
    return [] unless image_keys.present?

    dimensions = image_dimensions(size)
    
    image_keys.map do |key|
      cl_image_path(key,
        width: dimensions[:width],
        height: dimensions[:height],
        crop: :fill,
        quality: :auto
      )
    end
  rescue => e
    Rails.logger.error "Cloudinary全画像処理エラー: #{e.message}"
    []
  end

  # ActiveStorage：1枚目のURL
  def fallback_image_url(record, size, image_attribute)
    return nil unless record.has_images?(image_attribute: image_attribute)

    first_image = record.first_image(image_attribute: image_attribute)
    return nil unless first_image&.blob.present?

    rails_representation_url(first_image.variant(size))
  rescue => e
    Rails.logger.error "ActiveStorage処理エラー: #{e.message}"
    nil
  end

  # ActiveStorage：全画像のURL配列
  def all_fallback_image_urls(record, size, image_attribute)
    return [] unless record.has_images?(image_attribute: image_attribute)

    all_images = record.all_images(image_attribute: image_attribute)
    
    all_images.map do |image|
      next unless image&.blob.present?
      rails_representation_url(image.variant(size))
    end.compact
  rescue => e
    Rails.logger.error "ActiveStorage全画像処理エラー: #{e.message}"
    []
  end

  # 画像サイズ設定
  def image_dimensions(size)
    case size
    # 一覧（サムネ）用サイズ
    when :thumb
      { width: 200, height: 200 }
    # 詳細表示用サイズ
    when :detail
      { width: 600, height: 600 }
    else
      { width: 200, height: 200 }
    end
  end
end
