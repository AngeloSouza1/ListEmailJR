# app/models/contact.rb
class Contact < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true
    has_and_belongs_to_many :email_lists
  end