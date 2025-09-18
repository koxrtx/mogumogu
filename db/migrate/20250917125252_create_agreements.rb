class CreateAgreements < ActiveRecord::Migration[8.0]
  def change
    create_table :agreements do |t|
      t.references :user, null: false, foreign_key: true
      t.string :terms_version
      t.datetime :agreed_at
      t.string :ip_address

      t.timestamps
    end
  end
end
