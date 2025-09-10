class CreateSpotFacilities < ActiveRecord::Migration[8.0]
  def change
    create_table :spot_facilities do |t|
      t.references :spot, null: false, foreign_key: true        # spots テーブルへの外部キー
      t.references :facility_tag, null: false, foreign_key: true # facility_tags テーブルへの外部キー
      t.timestamps
    end
    # spot_id と facility_tag_id の組み合わせをユニークにする場合（同じ設備を同じ店に重複させない）
    add_index :spot_facilities, [:spot_id, :facility_tag_id], unique: true
  end
end
