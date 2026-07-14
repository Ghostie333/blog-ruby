# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  after_action :log_activity, only: %i[create edit]

  protected

  # Nadpisujemy domyślną metodę devise aby móc zmienić zdjęcie bez wpisywania hasła
  def update_resource(resource, params)
    if params[:password].blank? && params[:password_confirmation].blank?
      # Aktualizuje profil BEZ wymagania obecnego hasła
      resource.update_without_password(params.except(:current_password))
    else
      # Jeśli użytkownik wpisał nowe hasło to standardowo wymagamy starego
      super
    end
  end
end
