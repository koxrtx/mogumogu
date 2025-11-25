class RemoveFacilityTagIdFromSpotUpdateRequests < ActiveRecord::Migration[8.0]
  def change
    remove_column :spot_update_requests, :facility_tag_id, :bigint
  end
end
