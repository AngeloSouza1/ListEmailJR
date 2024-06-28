class CreateContactsEmailLists < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts_email_lists do |t|
      t.references :contact, null: false, foreign_key: true
      t.references :email_list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
