class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :encrypted_password, null: false
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.string :line_user_id
      t.string :google_user_id
      t.integer :role, null: false, default: 0

      t.timestamps
    end

    # DBのカラムに索引（index）を作る命令
    # 重複禁止の制約 uniqueはadd_indexに記載
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
  end
end