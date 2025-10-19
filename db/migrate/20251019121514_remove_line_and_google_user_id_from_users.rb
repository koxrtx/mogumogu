class RemoveLineAndGoogleUserIdFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :line_user_id,:string
    remove_column :users, :google_user_id, :string
  end
end
