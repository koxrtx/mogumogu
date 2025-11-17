class RenameCheckboxToRequestTypeInSpotUpdateRequests < ActiveRecord::Migration[8.0]
  def change
    rename_column :spot_update_requests, :checkbox, :request_type
  end
end
