class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  # Rola użytkownika
  enum :role, { user: "user", admin: "admin" }, default: "user"

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

  # Grupy
  has_many :owned_groups, class_name: "Group", foreign_key: "owner_id"
  has_and_belongs_to_many :groups

  # Logi
  has_many :activity_logs

  # Zdjęcie profilowe
  has_one_attached :avatar
end
