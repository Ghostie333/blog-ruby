class Admin::ActivityLogsController < Admin::BaseController
  def index
    filter = params[:query]

    if filter.present?
      @all_logs = ActivityLog.left_joins(:user).where(
        "activity_logs.ip_address ILIKE :q OR
        activity_logs.action ILIKE :q OR
        users.email ILIKE :q",
        q: "%#{filter}%"
      ).order(created_at: :desc)
    else
      @all_logs = ActivityLog.limit(10).order(created_at: :desc)
    end
  end
end
