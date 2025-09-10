class AddPhotoDeleteReasonToSpotUpdateRequests < ActiveRecord::Migration[8.0]
  def change
    # 写真削除のときに削除理由を確認するためカラム追加
    add_column :spot_update_requests, :photo_delete_reason, :text, null: false
  end
end
