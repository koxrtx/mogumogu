class CreateSpotUpdateRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :spot_update_requests do |t|
      t.references :user, null: true, foreign_key: true           # ユーザーがいない場合もあり
      t.references :spot, null: false, foreign_key: true
      t.references :facility_tag, null: true, foreign_key: true   # 写真依頼ならNULL
      t.jsonb :request_data                                        # JSONで差分管理
      t.integer :checkbox, null: false, default: 0                # 0:店舗情報修正, 1:写真削除, 2:閉店
      t.integer :status, null: false, default: 0                  # 0:未対応, 1:承認, 2:却下
      t.timestamps
    end
  end
end
