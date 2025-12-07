class ChangeRequestTypeToInteger < ActiveRecord::Migration[7.0]
  def up
    # 1. 文字列を整数に置き換える
    execute <<-SQL
      UPDATE spot_image_update_requests
      SET request_type = 0
      WHERE request_type = 'add';
    SQL

    execute <<-SQL
      UPDATE spot_image_update_requests
      SET request_type = 1
      WHERE request_type = 'remove';
    SQL

    # 2. カラム型を整数に変更
    change_column :spot_image_update_requests, :request_type, :integer, using: 'request_type::integer'
  end

  def down
    change_column :spot_image_update_requests, :request_type, :string
  end
end