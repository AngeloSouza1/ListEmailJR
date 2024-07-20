class AddTextEmailToEmailLists < ActiveRecord::Migration[7.1]
  def change
    add_column :email_lists, :text_email, :text
  end
end
