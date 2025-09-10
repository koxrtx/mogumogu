class CreateFacilityTags < ActiveRecord::Migration[8.0]
  def change
    # 子ども用設備テーブル
    create_table :facility_tags do |t|
      t.string :content, null: false
      t.timestamps
    end
  end
end
