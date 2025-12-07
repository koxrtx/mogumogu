class ChangeRequestTypeToInteger < ActiveRecord::Migration[7.0]
  def up
    # 既存のデータを一旦削除するか、変換する
    # 開発環境で問題なければ削除
    SpotImageUpdateRequest.delete_all
    
    # カラムの型を変更
    change_column :spot_image_update_requests, :request_type, :integer, using: 'request_type::integer'
  end

  def down
    change_column :spot_image_update_requests, :request_type, :string
  end
end