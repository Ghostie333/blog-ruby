class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  prepend_before_action :set_locale
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def log_activity
    log = ActivityLog.new

    # Wstawienie danych w pola loga
    log.user = current_user
    log.action = "#{controller_name}: #{action_name}"
    log.details = params.to_unsafe_h.except("controller", "action", "authenticity_token")
    log.ip_address = request.remote_ip

    log.save
  end

  private
  def set_locale
    # Jeśli parametr :locale jest w url to zapisujemy go w sesji
    if params[:locale].present? && I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]
    end

    # Ustawiamy język na ten z sesji lub domyślnie polski
    I18n.locale = session[:locale] || I18n.default_locale
  end
end
