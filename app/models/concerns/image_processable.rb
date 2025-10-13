# 画像処理
module ImageProcessable
  extend ActiveSupport::Concern

  # 画像が存在するかの確認
  def has_images?(image_attribute: :images)
    send(image_attribute).attached?
  end

  # 最初の画像を取得
  def first_image(image_attribute: :images)
    images_collection = send(image_attribute)
    return nil unless images_collection.attached?
    images_collection.first
  end

  # 画像のキーを取得（Cloudinary用）
  def image_key(image_attribute: :images)
    first_img = first_image(image_attribute: image_attribute)
    first_img&.blob&.key
  end

  # 画像のblobを取得
  def image_blob(image_attribute: :images)
    first_img = first_image(image_attribute: image_attribute)
    first_img&.blob
  end
end