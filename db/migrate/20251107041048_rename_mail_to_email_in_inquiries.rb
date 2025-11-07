class RenameMailToEmailInInquiries < ActiveRecord::Migration[8.0]
  def change
    rename_column :inquiries, :mail, :email
  end
end
