class Admin::UsersController < Admin::BaseController
  def index
    @all_users = User.all
  end

  def update
    @user = User.find(params[:id])
    user_ip = @user.current_sign_in_ip

    if user_ip.blank?
      redirect_to admin_dashboards_path, alert: t("alerts.fail_to_ban", ip_address: "nil")
      return
    end

    @banned_ip = BannedIp.new(ip_address: user_ip, reason: "Account #{@user.email} banned")
    if @banned_ip.save
      redirect_to admin_dashboards_path, notice: t("notices.successful_banned", ip_address: user_ip)
    else
      redirect_to admin_dashboards_path, alert: t("alerts.fail_to_ban", ip_address: user_ip)
    end
  end
end
