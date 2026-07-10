class Admin::ActivityLogsController < Admin::BaseController
  def index
    @all_logs = ActivityLog.all.order(created_at: :desc)
  end
end
