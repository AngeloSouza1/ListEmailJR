class EmailListsContact < ApplicationRecord
  belongs_to :email_list
  belongs_to :contact
end
