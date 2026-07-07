class Admin::CommentsController < Admin::BaseController
  before_action :set_comment, only: %i[ create destroy ]

# Poprawione create:
def create
  @post = Post.find(params[:post_id])
  @comment = @post.comments.build(comment_params)
  @comment.user = current_user if user_signed_in?

  if @comment.save
    redirect_to [ :admin, @post ], notice: t("notices.comment_successfully_created")
  else
    redirect_to [ :admin, @post ], alert: t("alerts.comment_fail_to_create") # poprawiłem alert na alerts (w zależności jak masz w YAML)
  end
end

  def destroy
  @comment.destroy!
  # Zamiast redirect_back, przekieruj wprost na widok tego posta w panelu admina:
  redirect_to [ :admin, @post ], alert: "Komentarz usunięty", status: :see_other
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_comment
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
  end
end
