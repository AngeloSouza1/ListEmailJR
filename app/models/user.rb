class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :email_lists
  # Associação com contatos
  has_many :contacts, dependent: :destroy
  has_many :email_lists, dependent: :destroy
end
