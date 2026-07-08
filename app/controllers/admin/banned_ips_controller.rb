class Admin::BannedIpsController < Admin::BaseController
  def index
    @banned_ips = BannedIp.order(created_at: :desc)
    @new_banned_ip = BannedIp.new
  end

  def create
    @banned_ip = BannedIp.new(banned_ip_params)

    if @banned_ip.save
      redirect_to admin_dashboards_path, notice: t("notices.successful_banned", ip_address: @banned_ip.ip_address)
    else
      redirect_to admin_dashboards_path, alert: t("alerts.fail_to_ban", ip_address: @banned_ip.ip_address)
    end
  end

  def destroy
    @banned_ip = BannedIp.find(params[:id])
    @banned_ip.destroy
    redirect_to admin_dashboards_path, notice: t("notices.successful_unbanned", ip_address: @banned_ip.ip_address)
  end

  def banned_ip_params
    params.require(:banned_ip).permit(:ip_address, :reason)
  end
end
