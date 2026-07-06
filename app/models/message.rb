class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chatroom

  has_many_attached :attachments

  after_create_commit -> { broadcast_prepend_later_to chatroom, target: "messages" }
end
