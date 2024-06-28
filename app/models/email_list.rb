# app/models/email_list.rb
class EmailList < ApplicationRecord
  has_and_belongs_to_many :contacts
end