class MessagesController < ApplicationController
  before_action :authenticate_user!
  after_action :log_activity, only: %i[create]

  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message = @chatroom.messages.new(message_params)
    @message.user = current_user

    if (!@message.body.empty? || @message.attachments.length != 0) && @message.save
      recipient = @chatroom.users.where.not(id: current_user.id).first

      if recipient
        Notification.create(
          recipient: recipient, # Osoba która dostanie powiadomienie
          actor: current_user, # Osoba która to powiadomienie wywołała
          notifiable: @message # Cały obiekt wiadomości
        )
      end

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @chatroom }
      end
    else
      redirect_back fallback_location: root_path, alert: "Nie udało się wysłać wiadomości"
    end
  end

  def message_params
    params.require(:message).permit(:body, attachments: [])
  end
end
