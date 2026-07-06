class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Relacje do postów i komentarzy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Relacje do znajomych
  has_many :friendships, dependent: :destroy # zwróci liste obiektów friendship
  has_many :friends, through: :friendships, source: :friend # zwróci liste Userów

  # Relacje do wiadomości
  has_many :chatroom_users
  has_many :chatrooms, through: :chatroom_users
  has_many :messages
end
