class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  prepend_before_action :set_locale
  before_action :check_if_user_banned
  allow_browser versions: :modern
  # Przepuszczanie zdjęcia przez devise
  before_action :configure_permitted_parameters, if: :devise_controller?

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

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [ :avatar ])
    # Jeśli chcesz dodawać awatar również przy rejestracji, odkomentuj linię poniżej:
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:avatar])
  end

  def check_if_user_banned
    # Sprawdzamy czy IP obecnego żądania znajduje się w tabeli BannedIp
    if BannedIp.exists?(ip_address: request.remote_ip)
      # Odcinamy dostęp – strone z błędem i status HTTP 403 Forbidden
      render template: "banned_ips/blocked", status: :forbidden, layout: false
    end
  end

  def set_locale
    # Jeśli parametr :locale jest w url to zapisujemy go w sesji
    if params[:locale].present? && I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]
    end

    # Ustawiamy język na ten z sesji lub domyślnie polski
    I18n.locale = session[:locale] || I18n.default_locale
  end
end
