class CreateInquiries < ActiveRecord::Migration[8.0]
  def change
    create_table :inquiries do |t|
      t.string :name, null: false                             # 名前は必須
      t.string :mail, null: false                             # メールは必須
      t.string :inquiry_comment, null: false                  # 問い合わせ内容は必須
      t.timestamps
    end
  end
end
