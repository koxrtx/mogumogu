class ChangeSpotImageToActiveStorage < ActiveRecord::Migration[8.0]
  def change
    # 外部キー制約の安全な削除
    if foreign_key_exists?(:spot_update_request_images, :spot_images)
      remove_foreign_key :spot_update_request_images, :spot_images
    end

    # カラムの安全な削除
    if column_exists?(:spot_update_request_images, :spot_image_id)
      remove_column :spot_update_request_images, :spot_image_id
    end
  end
end
