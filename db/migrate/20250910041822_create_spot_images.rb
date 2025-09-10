class CreateSpotImages < ActiveRecord::Migration[8.0]
  def change
    create_table :spot_images do |t|
      t.references :spot, null: false, foreign_key: true  # spots テーブルへの外部キー
      t.string :image                      # オリジナル画像のパスやファイル名
      t.timestamps
    end
  end
end
