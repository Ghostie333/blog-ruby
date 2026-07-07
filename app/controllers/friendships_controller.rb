class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  after_action :log_activity, only: %i[create update destroy]

  def index
    @friends = current_user.friends

    # Zaproszenia czekające na odpowiedź przez aktualnie zalogowanego Usera
    @incoming_invitations = Friendship.where(friend_id: current_user.id, status: :pending)
  end

  # Wysyłanie zaproszenia do znajomych
  def create
    friend = User.find_by(email: params[:email])

    if friend.nil?
      redirect_back fallback_location: root_path, alert: "Użytkownik nie istnieje"
      return
    end

    if friend == current_user
      redirect_back fallback_location: root_path, alert: "Nie możesz zaprosić sam siebie"
      return
    end

    friendship = current_user.friendships.build(friend: friend, status: :pending)

    if friendship.save
      redirect_back fallback_location: root_path, notice: "Zaproszenie wysłane"
    else
      redirect_back fallback_location: root_path, notice: "Nie udało się wysłać zaproszenia"
    end
  end

  # Zaakceptowanie zaproszenia
  def update
    friendship = Friendship.find(params[:id])
    if friendship.friend == current_user
      friendship.update(status: :accepted)

      # Stworzenie znajomości dla drugiej osoby
      Friendship.create(user: current_user, friend: friendship.user, status: :accepted)

      redirect_back fallback_location: root_path, notice: "Zaakceptowano zaproszenie"
    end
  end

  def destroy
    friendship = Friendship.find(params[:id])

    if friendship.destroy
      redirect_back fallback_location: root_path, notice: "Pomyślnie usunięto znajomego"
    end
  end
end
