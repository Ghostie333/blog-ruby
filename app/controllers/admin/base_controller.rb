class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  # osobny wygląd np. z panelem bocznym dla admina
  layout "admin"

  private
  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "#{t('alert.you_are_not_admin')}"
    end
  end
end
