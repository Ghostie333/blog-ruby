class Admin::ActivityLogsController < Admin::BaseController
  def index
    @all_logs = ActivityLog.all
  end
end
