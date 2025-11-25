class DropUnusedTables < ActiveRecord::Migration[8.0]
  def up
    remove_foreign_key :spot_update_requests, :facility_tags
    drop_table :spot_facilities
    drop_table :facility_tags
    drop_table :spot_update_request_images
  end

  def down
    # 万が一戻すときのために元のテーブル定義を入れる
    create_table :facility_tags do |t|
      t.string :content, null: false
      t.timestamps
    end

    create_table :spot_facilities do |t|
      t.references :spot, null: false, foreign_key: true
      t.references :facility_tag, null: false, foreign_key: true
      t.timestamps
    end

    create_table :spot_update_request_images do |t|
      t.references :spot_update_request, null: false, foreign_key: true
      t.timestamps
    end
  end
end