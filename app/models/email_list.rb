# app/models/email_list.rb
class EmailList < ApplicationRecord
  # Relações
  belongs_to :user
  has_and_belongs_to_many :contacts

  # Validações
  validates :name, presence: true
  validates :contact_ids, presence: true


end