class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read_at: nil) }

  after_create_commit do
    broadcast_render_to(
      "notifications_#{recipient_id}",
      partial: "notifications/notification_broadcast",
      locals: { notifications: self }
    )
  end
end
