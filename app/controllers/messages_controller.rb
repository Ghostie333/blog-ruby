class MessagesController < ApplicationController
  before_action :authenticate_user!
  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message = @chatroom.messages.new(message_params)
    @message.user = current_user

    if (!@message.body.empty? || @message.attachments.length != 0) && @message.save
      head :ok
    else
      redirect_back fallback_location: root_path, alert: "Nie udało się wysłać wiadomości"
    end
  end

  def message_params
    params.require(:message).permit(:body, attachments: [])
  end
end
