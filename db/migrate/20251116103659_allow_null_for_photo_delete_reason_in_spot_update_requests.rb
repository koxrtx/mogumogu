class AllowNullForPhotoDeleteReasonInSpotUpdateRequests < ActiveRecord::Migration[8.0]
  def change
     change_column_null :spot_update_requests, :photo_delete_reason, true
  end
end
