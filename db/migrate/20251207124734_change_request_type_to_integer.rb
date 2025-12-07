class ChangeRequestTypeToInteger < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      UPDATE spot_image_update_requests
      SET request_type = CASE
        WHEN request_type = 'add' THEN 0
        WHEN request_type = 'remove' THEN 1
      END
    SQL

    change_column :spot_image_update_requests, :request_type, 'integer USING request_type::integer'
  end

  def down
    change_column :spot_image_update_requests, :request_type, :string
  end
end