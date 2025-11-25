class RenameProcessStatusBackToStatus < ActiveRecord::Migration[8.0]
  def change
    rename_column :spot_update_requests, :process_status, :status
    rename_column :inquiries, :process_status, :status
  end
end