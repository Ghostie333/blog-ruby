# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  after_action :log_activity, only: %i[create]

  def destroy
    logged_user = current_user
    user_ip = request.remote_ip

    super do
      if logged_user
        ActivityLog.create!(
          user: logged_user,
          action: "user_logout",
          ip_address: user_ip,
          details: { method: "web" }
        )
      end
    end
  end
end
