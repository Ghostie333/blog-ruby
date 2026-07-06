class ChatroomsController < ApplicationController
  before_action :authenticate_user!
  def index
    @chatrooms = current_user.chatrooms
  end

  def show
    @chatroom = current_user.chatrooms.find(params[:id])
    @messages = @chatroom.messages.order(created_at: :asc)
    @new_message = Message.new
  end

  # Tworzenie nowego chatu
  def create
    friend = User.find(params[:friend_id])

    # Sprawdzamy czy chat między tymi użytkownikami już istnieje
    @chatroom = current_user.chatrooms.joins(:users).where(users: { id: friend.id }).first

    unless @chatroom
      @chatroom = Chatroom.create(name: "Czat z #{friend.email}")
      ChatroomUser.create(chatroom: @chatroom, user: current_user)
      ChatroomUser.create(chatroom: @chatroom, user: friend)
    end

    redirect_to chatroom_path(@chatroom)
  end
end
