class Group < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_and_belongs_to_many :users

  has_many :posts, dependent: :nullify

  has_one_attached :group_picture
  validates :name, presence: true
end
