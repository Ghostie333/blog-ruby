class Post < ApplicationRecord
  has_rich_text :content

  belongs_to :user
  has_many :comments, dependent: :destroy
  belongs_to :group, optional: true, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true
end
