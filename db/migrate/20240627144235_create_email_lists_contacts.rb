class CreateEmailListsContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :email_lists_contacts do |t|
      t.references :email_list, null: false, foreign_key: true
      t.references :contact, null: false, foreign_key: true

      t.timestamps
    end
  end
end
