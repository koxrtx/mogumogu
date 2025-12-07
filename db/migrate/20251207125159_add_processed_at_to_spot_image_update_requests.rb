class AddProcessedAtToSpotImageUpdateRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :spot_image_update_requests, :processed_at, :datetime
  end
end
