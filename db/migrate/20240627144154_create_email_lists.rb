class CreateEmailLists < ActiveRecord::Migration[7.1]
  def change
    create_table :email_lists do |t|
      t.string :name

      t.timestamps
    end
  end
end
