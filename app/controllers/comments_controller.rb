class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    
    @comment.user = current_user if user_signed_in?

    if @comment.save
      redirect_to @post, notice: "Komentarz został utworzony"
    else
      redirect_to @post, alert: "Błąd dodawania komentarza"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end