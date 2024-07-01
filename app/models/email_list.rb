# app/models/email_list.rb
class EmailList < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :contacts
end