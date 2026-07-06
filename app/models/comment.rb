class Comment < ApplicationRecord
  has_rich_text :body

  belongs_to :post
  belongs_to :user, optional: true

  validates :body, presence: true
end
