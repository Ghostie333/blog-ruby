class Friendship < ApplicationRecord
  belongs_to :user

  # Friend to też user
  belongs_to :friend, class_name: "User"
end
