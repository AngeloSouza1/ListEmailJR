class AddSendDateToEmailLists < ActiveRecord::Migration[7.1]
  def change
    add_column :email_lists, :send_date, :date
  end
end
