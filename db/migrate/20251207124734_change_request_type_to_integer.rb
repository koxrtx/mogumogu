class ChangeRequestTypeToInteger < ActiveRecord::Migration[7.0]
  def up
    # データがない場合でもエラーにならない
    change_column :spot_image_update_requests, :request_type, :integer, using: 'request_type::integer'
  end

  def down
    change_column :spot_image_update_requests, :request_type, :string
  end
end
