class AddStatusToSpots < ActiveRecord::Migration[8.0]
  def change
    # 閉店・開店ステータス
    add_column :spots, :status, :integer, default: 0, null: false
  end
end
