class RenameStatusToProcessStatusInSpotUpdateRequests < ActiveRecord::Migration[7.0]
  def change
    # spot_update_requests テーブルの status → process_status
    rename_column :spot_update_requests, :status, :process_status

    # inquiries テーブルの status → process_status
    rename_column :inquiries, :status, :process_status

    # spots テーブルの status → business_status
    rename_column :spots, :status, :business_status
  end
end