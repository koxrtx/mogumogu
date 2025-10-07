class ChangeSpotImageToActiveStorage < ActiveRecord::Migration[8.0]
  def change
    remove_reference :spot_update_request_images, :spot_image, foreign_key: true

    add_reference :spot_update_request_images, :spot_image, foreign_key: { to_table: :active_storage_attachments }
  end
end
