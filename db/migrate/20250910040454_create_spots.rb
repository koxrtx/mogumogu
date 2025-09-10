class CreateSpots < ActiveRecord::Migration[8.0]
  def change
    # お店の情報テーブル
    create_table :spots do |t|
      t.references :user, null: true, foreign_key: true # 投稿者のユーザーID（一般 or 管理者）
      t.string :name, null: false                       # 店舗名
      t.string :address, null: false                    # 住所
      t.string :tel                                     # 電話番号
      t.text :other_facility_comment                    # その他設備説明
      t.decimal :latitude, precision: 10, scale: 6      # 緯度
      t.decimal :longitude, precision: 10, scale: 6     # 経度


      t.timestamps
    end

    # 住所で検索を高速化するためのインデックス
    add_index :spots, :address
  end
end
