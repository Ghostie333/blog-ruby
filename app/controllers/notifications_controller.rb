class NotificationsController < ApplicationController
  before_action :authenticate_user!
  def index
    @notifications = current_user.notifications.order(created_at: :desc)
    @unread_notifications = @notifications.unread

    if @unread_notifications.any?
      @unread_notifications.update_all(read_at: Time.current)
    end

      respond_to do |format|
        format.html
        format.turbo_stream
    end
  end
end
