# app/controllers/users_controller.rb
class UserController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
  end
end