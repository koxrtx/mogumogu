class CreateSpotUpdateRequestImages < ActiveRecord::Migration[8.0]
  def change
    create_table :spot_update_request_images do |t|
      t.references :spot_update_request, null: false, foreign_key: true  # 更新リクエスト
      t.references :spot_image, null: false, foreign_key: true           # 写真
      t.timestamps
    end
    add_index :spot_update_request_images, [:spot_update_request_id, :spot_image_id], unique: true
  end
end
