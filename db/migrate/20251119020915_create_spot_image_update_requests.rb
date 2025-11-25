class CreateSpotImageUpdateRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :spot_image_update_requests do |t|
      t.references :user, foreign_key: true
      t.references :spot, foreign_key: true, null: false
      t.jsonb :request_data         # 追加する写真情報や削除対象IDを格納
      t.integer :request_type       # enum: { add: 0, delete: 1 }
      t.integer :status, default: 0 # enum: { pending: 0, approved: 1, rejected: 2 }
      t.text :reason                # 削除理由など
      t.timestamps
    end
  end
end