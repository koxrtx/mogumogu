class ChangeRequestTypeToInteger < ActiveRecord::Migration[7.0]
  def up
    # 本番では値が空かもしれないので安全に
    begin
      execute <<-SQL
        UPDATE spot_image_update_requests
        SET request_type = '0'
        WHERE request_type = 'add';
      SQL
    rescue
      nil
    end

    begin
      execute <<-SQL
        UPDATE spot_image_update_requests
        SET request_type = '1'
        WHERE request_type = 'remove';
      SQL
    rescue
      nil
    end

    # 文字列 '0' / '1' を整数にキャスト
    change_column :spot_image_update_requests, :request_type, :integer, using: 'request_type::integer'
  end

  def down
    change_column :spot_image_update_requests, :request_type, :string
  end
end